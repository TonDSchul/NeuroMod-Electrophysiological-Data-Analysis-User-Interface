function [ISIs] = Spike_Module_Calculate_Plot_ISI(Data,SpikeTimes,Units,Waves,figs,NumBins,MaxISITime)

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
        title(Figurename,strcat("Probability Distribution ISI <= ",num2str(MaxISITime)," s"));
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

    disp(strcat("Plot ",num2str(nplots)));
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
        
        if strcmp(Data.Info.SpikeType,"Internal")
            for nchannel = 1:size(Data.Raw,1)
                SpikeIndicies = Data.Spikes.SpikePositions(:,2)==nchannel;
                if sum(SpikeIndicies)>0
                    TemSpikes = Data.Spikes.SpikeTimes(SpikeIndicies==1);
                    Cluster = Data.Spikes.SpikeCluster(SpikeIndicies==1);
                
                    ClusterIndicies = Cluster == Units{nplots}(nUnit);
                    TemSpikes = TemSpikes(ClusterIndicies==1);
                    
                    %InterspikeIntervals = [InterspikeIntervals;(diff(TemSpikes))]; % Convert to s
                    InterspikeIntervals = [InterspikeIntervals;abs((diff(sort(TemSpikes))))]; % Convert to s
                end
            end
        end
        
        if ~isempty(InterspikeIntervals)
            
            InterspikeIntervals = InterspikeIntervals./Data.Info.NativeSamplingRate;
            
            ISISmallerThanMax = InterspikeIntervals<=MaxISITime;
            InterspikeIntervals = InterspikeIntervals(ISISmallerThanMax==1);

            if max(InterspikeIntervals)>maxIsi
                maxIsi = max(InterspikeIntervals);
            end

            % Compute the counts per bin
            [counts, edges] = histcounts(InterspikeIntervals, numBins);

            % Convert to probability
            InterspikeIntervals = counts./sum(counts);          

            Figurename.NextPlot = "add";
            % For waveform in ms
            if isempty(Barhandles)
                Barplots = Barplots+1;
                bplot = bar(Figurename,InterspikeIntervals, 'FaceColor',colorMatrix(nUnit,:),'Tag','ISI'); % Adjust 'BinWidth' as needed
            else
                Barplots = Barplots+1;
                if length(Barhandles)>=Barplots
                    set(Barhandles(Barplots),'YData',InterspikeIntervals, 'FaceColor',colorMatrix(nUnit,:),'Tag','ISI'); % Adjust 'BinWidth' as needed+
                    bplot = Barhandles(Barplots);
                else
                    bplot = bar(Figurename,InterspikeIntervals, 'FaceColor',colorMatrix(nUnit,:),'Tag','ISI'); % Adjust 'BinWidth' as needed
                end
            end

            bplot.FaceAlpha = 0.5; %
            
        end

    ISIs{nplots,nUnit} = InterspikeIntervals;

    end%For nUnits

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

    drawnow;
    

end%For nPlots