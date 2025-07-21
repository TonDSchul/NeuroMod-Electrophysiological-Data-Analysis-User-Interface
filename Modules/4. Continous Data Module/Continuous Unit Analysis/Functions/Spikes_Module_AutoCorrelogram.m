function CurrentPlotData = Spikes_Module_AutoCorrelogram(Data,SpikeTimes,SpikePositions,SpikeChannel,SpikeCluster,figs,Units,NumBins,CurrentPlotData,TimeLag)

%________________________________________________________________________________________
%% Function to calculate and plot the Autocorrelogram for all spikes

% This function is called in the unit analysis window when the ISI has to
% be computed

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. SpikeTimes: nspikes x 1 with spike times in samples
% 3. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 4. SpikeChannel: nspikes x 1 with nr of channel for each spike
% 5. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 6. figs: structure, each field is a figure object handle to plot in
% 7. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 8. NumBins: nr bins for ISI, as double
% 9. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 10. TimeLag: double, Time lag in ms. I.e. 20 for -20 to 20ms

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


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
        xlabel(Figurename,'Time lag (ms)');
        ylabel(Figurename,'Spike count');
        title(Figurename,strcat("Autocorrelogram Unit(s) ",num2str(Units{nplots})," (All Unit Waveforms)"));
        Figurename.NextPlot = "add";
        Figurename.FontSize = 9;
    end
end

maxLag = TimeLag;  % Maximum lag time
binEdges = linspace(-maxLag,maxLag,NumBins);

NRbarplots = 0;

for nplots = 1:length(Units)
   
    NRbarplots = 0;

    if isempty(Units{nplots})
        continue;
    end

    %disp(strcat("Plot ",num2str(nplots)));
    na = strcat("UIAxes_",num2str(nplots));
    Figurename = figs.(na);

    Barhandles = findobj(Figurename, 'Tag', 'AutoCorre');
    delete(Barhandles(1:end)); 
    Barhandles = findobj(Figurename, 'Tag', 'AutoCorre');
    
    for nUnit = 1:length(Units{nplots})
        
        SpikePlotIndex = 1;  % Keeps track of where to insert into preallocated array
        nspikes = sum(SpikeCluster == Units{nplots}(nUnit));
        interspikeIntervals = NaN(1,(nspikes^2)+1);
        
        h = waitbar(0, 'Calculating Autocorrelogram...', 'Name','Calculating Autocorrelogram...');

        for nchannel = 1:size(Data.Raw,1)
            if strcmp(Data.Info.SpikeType,"Internal")
                SpikeIndicies = SpikePositions==nchannel;
            else
                SpikeIndicies = SpikeChannel ==nchannel;
            end

            if sum(SpikeIndicies)>0
                TemSpikes = SpikeTimes(SpikeIndicies==1);
                Cluster = SpikeCluster(SpikeIndicies==1);

                ClusterIndicies = Cluster == Units{nplots}(nUnit);
                TemSpikes = TemSpikes(ClusterIndicies==1);

                spikeTimes_sec = (TemSpikes / Data.Info.NativeSamplingRate)*1000; % convert to ms
                nSpikes = length(spikeTimes_sec);

                % Compute interspike intervals 
                for i = 1:nSpikes
                    for j = 1:nSpikes
                        if i ~=j
                            interspikeIntervals(SpikePlotIndex) = spikeTimes_sec(i) - spikeTimes_sec(j);
                            SpikePlotIndex = SpikePlotIndex + 1;
                        end
                    end
                end
            end
            
            fraction = nchannel/size(Data.Raw,1);
            msg = sprintf('Calculating Autocorrelogram... (%d%% done)', round(100*fraction));
            waitbar(fraction, h, msg);

        end%nchannel

        close(h);

        interspikeIntervals(isnan(interspikeIntervals)) = [];
        
        smaller = abs(interspikeIntervals)<maxLag;
        
        interspikeIntervals = interspikeIntervals(smaller);

        if ~isempty(interspikeIntervals)
            % Create the histogram for the autocorrelogram
            [counts, edges] = histcounts(interspikeIntervals, binEdges);
    
            % ssttd = std(counts);
            % counts(counts>ssttd*10) = 0;

            NRbarplots = NRbarplots+1;
    
            if isempty(Barhandles)
                bar(Figurename,binEdges(1:end-1), counts, 'FaceColor',colorMatrix(nUnit,:), 'EdgeColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5,'EdgeAlpha', 0.5, 'Tag','AutoCorre');
            else
                if length(Barhandles)>=NRbarplots
                    set(Barhandles(NRbarplots),'XData',binEdges(1:end-1),'YData', counts, 'FaceColor',colorMatrix(nUnit,:), 'EdgeColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5,'EdgeAlpha', 0.5, 'Tag','AutoCorre');
                else
                    bar(Figurename,binEdges(1:end-1), counts, 'FaceColor',colorMatrix(nUnit,:), 'EdgeColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5,'EdgeAlpha', 0.5, 'Tag','AutoCorre');
                end
            end
            
            %% Save results to ba able to export 
            CurrentPlotData.UnitAnalyisAutoXData{nplots,nUnit} = binEdges(1:end-1);
            CurrentPlotData.UnitAnalyisAutoYData{nplots,nUnit} = counts;
            CurrentPlotData.UnitAnalyisAutoCData{nplots,nUnit} = [];
            
            if strcmp(Data.Info.SpikeType,"Kilosort")
                CurrentPlotData.UnitAnalyisAutoType{nplots,nUnit} = strcat("Continous Kilosort Unit ",num2str(Units{nplots}(nUnit))," Analyis: Autocorrelogram");
            else
                CurrentPlotData.UnitAnalyisAutoType{nplots,nUnit} = strcat("Continous Internal Unit ",num2str(Units{nplots}(nUnit))," Analyis: Autocorrelogram");
            end
            
            CurrentPlotData.UnitAnalyisAutoXTicks{nplots,nUnit} = Figurename.XTickLabel;

            
        end %~isempty(interspikeIntervals)
    end%nunits

    drawnow;
end%nplots



