function Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,TimeSpikeFigure,ChannelSpikeFigure,Type,rgb_matrix,ClustertoShow,numBins,ChannelSelection,ChannelSpacing)

%________________________________________________________________________________________

%% Function to plot spike rate from kilosortData over time and over Channel
% Input:
% 1. Data: Data structure containing KilosortData
% 2. SpikeTimes nspikes x 1 double in seconds
% 3. SpikePositions = N x 1 double or single in um
% 4. CluterPositions = N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: for internal spikes, no
% units get analyse. Therefore this vector has to be made up of just 1 
% 5. TimeSpikeFigure: Figure handle to app.UIaxes_3 Spike Rate over time 
% 6. TemplateFigure: Figure handle to app.UIaxes_5 Spike Rate over channel 
% 7. Type: "Initial" when plotting for the first time after resetting,
% BinsizeChangeInitial when binsize was changed, "Non" when nothing
% 8. rgb_matrix: RGB values for each cluster to show them in different colors
% 9. numCluster: Number of clusters (saved under app.numCluster within Analyse_Kilosort_Window)
% 10. ClustertoShow: Number of cluster the user selected to highlight in their color. Can
% be "All" to show all cluster in their color, "Non" to show no colors or a
% number as a string to show only that cluster. Indexing starts with 0!
% 11. numBins: Number of bins selectd in the analysis window (string or char)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Spike Rate over Time
ClusterSpikeTimes = [];
ClusterNr = [];

if strcmp(ClustertoShow,"Non") || strcmp(ClustertoShow,"All") || strcmp(Type,"BinsizeChangeInitial")
    ClusterNr = 1:length(unique(CluterPositions));
    %title(TimeSpikeFigure,strcat("Spike Rate per Bin All Cluster "));
    ClusterSpikeTimes = SpikeTimes;
else
    ClusterNr = str2double(ClustertoShow);
    %title(TimeSpikeFigure,strcat("Spike Rate per Bin Cluster ",num2str(ClusterNr)))
    ClusterSpikeTimes = SpikeTimes(CluterPositions == ClusterNr);
end

%% Spie Rate over Time
if strcmp(Type,"Initial") && ~strcmp(Type,"NewCluster") || strcmp(Type,"BinsizeChangeInitial")
    cN = numBins;  % number of steps/chunks
    % Divide the data into chunks (last chunk is smaller than the rest)
    dN = length(Data.Time);
   
    BinSizeSamples = floor(dN/cN);
    BinSizeTime = BinSizeSamples*(1/Data.Info.NativeSamplingRate);
    
    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(SpikeTimes,SpikePositions,cN,BinSizeTime,1,"SpikeRateoverTime");
    
    %% Calculate mean over all channel and convert to frequency
    ChanneRange = ChannelSelection(1):ChannelSelection(2);
    SpikesInBins = (SpikesInBins./BinSizeTime)./length(ChanneRange);
    
    %% Plot
   
    if strcmp(Data.Info.SpikeType,"Kilosort")
        yyaxis(TimeSpikeFigure, 'left');
    end
    if length(SpikesInBins)+0.5 ~= 0.5
        xlim(TimeSpikeFigure,[0.5,length(SpikesInBins)+0.5])
    end
    TotalRate_handles = findobj(TimeSpikeFigure, 'Tag', 'TotalRate');

    if isempty(TotalRate_handles)
        bar(TimeSpikeFigure,SpikesInBins,'black', 'Tag', 'TotalRate');
    elseif ~isempty(TotalRate_handles)
        set(TotalRate_handles, 'YData', SpikesInBins,'Tag','TotalRate');
    end

    ylabel(TimeSpikeFigure,"Spike Rate [Hz]")
    xlabel(TimeSpikeFigure,strcat("Time [s]; ",num2str(BinSizeTime),"s per bin"));
    TimeSpikeFigure.FontSize = 10;

    % Set the x-tick labels to the correct time values
    % Calculate bin centers or edges
    bin_edges = Data.Time(1) + (0:cN) * BinSizeTime;
    bin_centers = bin_edges(1:end-1) + BinSizeTime/2;

    max_xticks = 50;
    tick_interval = max(1, round(cN / max_xticks));

    x_ticks = 1:tick_interval:cN;
    x_tick_labels = arrayfun(@(x) sprintf('%.2f', x), bin_centers(x_ticks), 'UniformOutput', false);

    TimeSpikeFigure.XTick = x_ticks;
    TimeSpikeFigure.XTickLabel = x_tick_labels;

end

%% Spike Rate over Channel
if strcmp(Type,"Initial") || strcmp(Type,"BinsizeChangeInitial")

    SpikesInBins = [];
    
    if strcmp(Data.Info.SpikeType,"Kilosort")
        cN = numBins;  % number of steps/chunks
        dN = length(ChannelSelection(1):ChannelSelection(2))*Data.Info.ChannelSpacing;
        TempSpikePos = SpikePositions;
        BinSize = dN/cN;
    else
        cN = length(ChannelSelection(1):ChannelSelection(2));  % number of steps/chunks
        dN = length(ChannelSelection(1):ChannelSelection(2));
        TempSpikePos = SpikePositions/Data.Info.ChannelSpacing;
        BinSize = Data.Info.ChannelSpacing;
    end
    % Divide the data into chunks (last chunk is smaller than the rest)

    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(TempSpikePos,SpikePositions,cN,BinSize,1,"SpikeRateoverChannel");

    % Get Frequency
    SpikesInBins = SpikesInBins/Data.Time(end);
    if length(SpikesInBins)+0.5 ~= 0.5
        ylim(ChannelSpikeFigure,[0.5,length(SpikesInBins)+0.5])
    end
    if max(SpikesInBins) ~= 0
        xlim(ChannelSpikeFigure,[0 max(SpikesInBins)]);
    end
    barh(ChannelSpikeFigure,SpikesInBins','black');
   
    xlabel(ChannelSpikeFigure,strcat("Spike Rate per ",num2str(BinSize),"µm [Hz]"))

    ChannelSpikeFigure.FontSize = 10;
    set(ChannelSpikeFigure,'yticklabel',{[]})

end

if strcmp(Type,"BinsizeChangeInitial")
    return;
end

if  ~strcmp(ClustertoShow,"All") && ~strcmp(ClustertoShow,"Non")

    SpikeswithinRange = zeros(1,length(ClusterSpikeTimes));

    cN = numBins;  % number of steps/chunks
    % Divide the data into chunks (last chunk is smaller than the rest)
    dN = length(Data.Time);
    
    BinSizeSamples = floor(dN/cN);
    BinSizeTime = BinSizeSamples*(1/Data.Info.NativeSamplingRate);
    
    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(ClusterSpikeTimes,SpikePositions,cN,BinSizeTime,1,"SpikeRateoverTime");

    %% Plot 
    
    yyaxis(TimeSpikeFigure, 'right');
    if length(SpikesInBins)+0.5 ~= 0.5
        xlim(TimeSpikeFigure,[0.5,length(SpikesInBins)+0.5])
    end
    Cluster_handles = findobj(TimeSpikeFigure, 'Tag', 'ClusterRateRight');

    if length(Cluster_handles)>1
        delete(Cluster_handles(2:end));
    end

    if strcmp(Type,"NewCluster")
        %xlim(TimeSpikeFigure,[0 1000]);
        if isempty(Cluster_handles)
            bar(TimeSpikeFigure,SpikesInBins, 'FaceColor', rgb_matrix(str2double(ClustertoShow)+1,:),'Tag','ClusterRateRight');
        else
            set(Cluster_handles(:), 'YData', SpikesInBins,'FaceColor', rgb_matrix(str2double(ClustertoShow)+1,:),'Tag','ClusterRateRight');
        end
    else
        delete(Cluster_handles(:));
        Cluster_handles = findobj(TimeSpikeFigure, 'Tag', 'ClusterRateRight');
        bar(TimeSpikeFigure,SpikesInBins, 'FaceColor', rgb_matrix(str2double(ClustertoShow)+1,:),'Tag','ClusterRateRight'); 
    end
 
end

if strcmp(ClustertoShow,"All") || strcmp(ClustertoShow,"Non")
    if strcmp(Data.Info.SpikeType,"Kilosort")
        yyaxis(TimeSpikeFigure, 'right');
        Cluster_handles = findobj(TimeSpikeFigure, 'Tag', 'ClusterRateRight');
        if ~isempty(Cluster_handles)
            delete(Cluster_handles(:));
        end
    end
end