function [ISIs,CurrentPlotData] = Spike_Module_Calculate_Plot_ISI(Data,SpikeTimes,SpikePositions,SpikeCluster,SpikeChannel,Units,Waves,figs,NumBins,MaxISITime,CurrentPlotData)

%________________________________________________________________________________________
%% Function to calculate and plot the ISI of a number of spikes

% This function is called in the unit analysis window when the ISI has to
% be computed

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. SpikeTimes: nspikes x 1 with spike times in samples
% 3. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 4. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 5. SpikeChannel: nspikes x 1 with nr of channel for each spike
% 6. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 7. Waves: 1x3 cell array, each cell contains the nr of waveforms for a plot as a 1 x nunits vector
% 8. figs: structure, each field is a figure object handle to plot in
% 9. NumBins: nr bins for ISI, as double
% 10. MaxISITime: Max ISI to be displayed in bar plot, as double in seconds
% 11. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. ISIs: ISI for seelcted time range that is plotted, 1 x nbins vector
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% Define the number of bins
numBins = NumBins;

%% Prepare Data
MaxNrUnits = 0;
for i = 1:length(Units)
    if length(Units{i})>MaxNrUnits
        MaxNrUnits = length(Units{i});
    end
end

colorMatrix = jet(MaxNrUnits);
for nplots = 1:length(Units)
    if ~isempty(Units{nplots})
        na = strcat("UIAxes_",num2str(nplots));
        Figurename = figs.(na);
        title(Figurename,strcat("Probability ISI <= ",num2str(MaxISITime)," s (All Unit Waveforms)"));
        xlabel(Figurename,'Interspike Interval [s]');
        xlim(Figurename,[-0.5,numBins+0.5]);
        ylabel(Figurename,'Probability [%]');
        Figurename.FontSize = 9;
    end
end

ISIs = cell(length(Units),MaxNrUnits);

for nplots = 1:length(Units)
    
    if isempty(Units{nplots})
        continue;
    end

    %disp(strcat("Plot ",num2str(nplots)));
    na = strcat("UIAxes_",num2str(nplots));
    Figurename = figs.(na);

    maxIsi = 0;
    Barplots = 0;

    Barhandles = findobj(Figurename, 'Tag', 'ISI');

    for nUnit = 1:length(Units{nplots})
        % Compute interspike intervals
        InterspikeIntervals = [];
        % Extract Isi channelwise to avoid artefacts from end of one channel to
        % start of the next.

        ClusterIndicies = SpikeCluster == Units{nplots}(nUnit);
        TemSpikes = SpikeTimes(ClusterIndicies==1);
        
        if length(TemSpikes)>1
            %InterspikeIntervals = [InterspikeIntervals;(diff(TemSpikes))]; % Convert to s
            InterspikeIntervals = [InterspikeIntervals;abs((diff(sort(TemSpikes))))]; % Convert to s
        end
                
        if ~isempty(InterspikeIntervals)
            

            InterspikeIntervals = InterspikeIntervals./Data.Info.NativeSamplingRate;
            
            ISISmallerThanMax = InterspikeIntervals<=MaxISITime;
            InterspikeIntervals = InterspikeIntervals(ISISmallerThanMax==1);

            if max(InterspikeIntervals)>maxIsi
                maxIsi = max(InterspikeIntervals);
            end

            % Compute the counts per bin
            [counts, ~] = histcounts(InterspikeIntervals, numBins);

            % Convert to probability
            InterspikeIntervals = counts./sum(counts);       

            Figurename.NextPlot = "add";
            % For waveform in ms
            if isempty(Barhandles)
                Barplots = Barplots+1;
                bar(Figurename,InterspikeIntervals, 'FaceColor',colorMatrix(nUnit,:), 'EdgeColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5,'EdgeAlpha', 0.5,'Tag','ISI'); 
            else
                Barplots = Barplots+1;
                if length(Barhandles)>=Barplots
                    set(Barhandles(Barplots),'YData',InterspikeIntervals, 'FaceColor',colorMatrix(nUnit,:), 'EdgeColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5,'EdgeAlpha', 0.5,'Tag','ISI'); %
                else
                    bar(Figurename,InterspikeIntervals, 'FaceColor',colorMatrix(nUnit,:), 'EdgeColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5,'EdgeAlpha', 0.5,'Tag','ISI'); 
                end
            end      

            %% Save results to ba able to export 
            CurrentPlotData.UnitAnalyisISIXData{nplots,nUnit} = 1:length(InterspikeIntervals);
            CurrentPlotData.UnitAnalyisISIYData{nplots,nUnit} = InterspikeIntervals;
            CurrentPlotData.UnitAnalyisISICData{nplots,nUnit} = [];
            
            CurrentPlotData.UnitAnalyisISIType{nplots,nUnit} = strcat("Unit ",num2str(Units{nplots}(nUnit))," Analyis: ISI");

        end % if spike indicies found
    end%For nUnits

    Barhandles = findobj(Figurename, 'Tag', 'ISI');

    if length(Barhandles)>Barplots
        delete(Barhandles(Barplots+1:end));
    end

    Time = linspace(0,MaxISITime,numBins); % in s
    
    % Define the number of x-ticks you want to display (e.g., 5)
    numTicksToDisplay = 10;
    
    % Create evenly spaced indices for the x-ticks
    tickIndices = round(linspace(1, numBins, numTicksToDisplay));
    
    % Set x-ticks to these specific indices
    Figurename.XTick = tickIndices;
    
    % Set the x-tick labels to the corresponding time values
    Figurename.XTickLabel = string(Time(tickIndices));

    for i = 1:length(Units{nplots})
        CurrentPlotData.UnitAnalyisISIXTicks{nplots,i} = Time;
    end

    drawnow;
    
end%For nPlots