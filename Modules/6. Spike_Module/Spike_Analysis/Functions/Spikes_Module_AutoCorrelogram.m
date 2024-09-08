function Spikes_Module_AutoCorrelogram(Data,SpikeTimes,figs,Units)

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
        title(Figurename,strcat("Autocorrelogram Unit(s) ",num2str(Units{nplots})));
        Figurename.NextPlot = "add";
        Figurename.FontSize = 9;
    end
end

NumBins = 300;  % Bin size in ms
maxLag = 50;  % Maximum lag time to consider for the histogram
binEdges = linspace(-maxLag,maxLag,NumBins);

NRbarplots = 0;
for nplots = 1:length(Units)
    
    if isempty(Units{nplots})
        continue;
    end

    disp(strcat("Plot ",num2str(nplots)));
    na = strcat("UIAxes_",num2str(nplots));
    Figurename = figs.(na);

    maxIsi = 0;
    Barplots = 0;

    Barhandles = findobj(Figurename, 'Tag', 'AutoCorre');

    for nUnit = 1:length(Units{nplots})
        
        interspikeIntervals = [];

        for nchannel = 1:size(Data.Raw,1)

            SpikeIndicies = Data.Spikes.SpikePositions(:,2)==nchannel;

            if sum(SpikeIndicies)>0
                TemSpikes = Data.Spikes.SpikeTimes(SpikeIndicies==1);
                Cluster = Data.Spikes.SpikeCluster(SpikeIndicies==1);
            
                ClusterIndicies = Cluster == Units{nplots}(nUnit);
                TemSpikes = TemSpikes(ClusterIndicies==1);
            end

            spikeTimes_sec = (TemSpikes / Data.Info.NativeSamplingRate)*1000; % convert to ms
            
            nSpikes = length(spikeTimes_sec);
            % Preallocate interspike interval array (maximum possible size is nSpikes * (nSpikes - 1) / 2)
            numIntervals = (nSpikes-1) * (nSpikes-1);
            
            % Compute interspike intervals (positive lags only)
            index = 1;  % Keeps track of where to insert into preallocated array
            for i = 1:nSpikes
                for j = 1:nSpikes
                    interspikeIntervals = [interspikeIntervals,spikeTimes_sec(i) - spikeTimes_sec(j)];
                    index = index + 1;
                end
            end
        end%nchannel

        % Create the histogram for the autocorrelogram
        [counts, ~] = histcounts(interspikeIntervals, binEdges);

        ssttd = std(counts);
        counts(counts>ssttd*10) = 0;

        NRbarplots = NRbarplots+1;

        if isempty(Barhandles)
            bplot = bar(Figurename,binEdges(1:end-1), counts, 'FaceColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5, 'Tag','AutoCorre');
            %ylim(Figurename,[0,max(counts)])
        else
            if length(Barhandles)>=NRbarplots
                set(Barhandles(NRbarplots),'YData',binEdges(1:end-1), counts, 'FaceColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5, 'Tag','AutoCorre');
                bplot = Barhandles(NRbarplots);
            else
                bplot = bar(Figurename,binEdges(1:end-1), counts, 'FaceColor',colorMatrix(nUnit,:),'FaceAlpha', 0.5, 'Tag','AutoCorre');
            end
        end     
    end%nunits

    drawnow;
    if length(Barhandles)>NRbarplots
        delete(Barhandles(NRbarplots+1:end));
    end

end%nplots



