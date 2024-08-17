function Event_Spikes_Plot_Heatmap_Spike_Rate(SpikeTimes,SpikePositions,Figure,SR,time_bin_size,depth_edges,time_edges,nevents,eventtime,Normalize,NormWindow,Clustertoshow,ClusterIdentity,rgbMatrix,ChannelsToPlot,ChannelSpacing,appWindow)

%% Calculate Spike Rate in each bin
% Convert spike times to seconds

% Create 2D histogram of spike counts
spike_counts = histcounts2(SpikePositions, SpikeTimes, depth_edges, time_edges );

closestTime = abs(time_edges-NormWindow(2));
closestTime = find(closestTime==min(closestTime));
time_edgesNorm = time_edges(1:closestTime);

if Normalize
    % Create 2D histogram of spike counts
    SpikesinNormWin = (SpikeTimes >= NormWindow(1) & SpikeTimes <= NormWindow(2));
    
    if sum(SpikesinNormWin>0)
        spike_countsNorm = histcounts2(SpikePositions(SpikesinNormWin), SpikeTimes(SpikesinNormWin), depth_edges, time_edgesNorm );
        spike_counts = spike_counts-mean(spike_countsNorm,2);
    else
        spike_counts = 0;
    end
end

% Calculate spike rate for each bin
spike_rates = (spike_counts / time_bin_size);
spike_rates = spike_rates/nevents;

%% Plotting
ylim(Figure,[depth_edges(1)-(ChannelSpacing/2),depth_edges(end)+(ChannelSpacing/2)]);
xlim(Figure,[time_edges(1),time_edges(end)]);

Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
Image_handles = findobj(Figure,'Type', 'image', 'Tag', 'SpikeRateImage');

if numel(Event_handles)>1
    Event_handles(2:end) = [];
end
if numel(Image_handles)>1
    Image_handles(2:end) = [];
end

eventLine = [];

if ~isempty(Image_handles)
    set(Image_handles(1),'XData', time_edges(1:end-1) , 'YData', depth_edges(1:end) ,'CData', spike_rates, 'Tag', 'SpikeRateImage');
    set(Event_handles(1),'XData', [eventtime,eventtime] , 'YData', [depth_edges(1)-(ChannelSpacing/2),depth_edges(end)+(ChannelSpacing/2)],'Color','k','LineWidth',2.5, 'Tag', 'Event');
else
    imagesc(Figure,time_edges(1:end-1), depth_edges(1:end), spike_rates, 'Tag', 'SpikeRateImage') %plot CSD
    eventLine = line(Figure,[eventtime,eventtime],[depth_edges(1)-(ChannelSpacing/2),depth_edges(end)+(ChannelSpacing/2)],'Color','k','LineWidth',2.5, 'Tag', 'Event');
    ylabel(Figure,'Depth [µm]');
    set(Figure, 'YDir', 'reverse');
    set(Figure,'xticklabel',{[]});
    % Add legend only once
    if isempty(findobj(Figure, 'Type', 'legend')) && ~isempty(eventLine)
        % Create legend with imagesc and event line
        legendHandle = legend(eventLine, {'Trigger'});
        set(legendHandle, 'HandleVisibility', 'off');
    end
end

if Normalize
    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    colormap(Figure, colormap_BlueWhiteRed);
    cbar_handle.Label.String = "Normalized Spike Rate [Hz]";
    title(Figure,'Normalized Spike Rate over Depth');
else
    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    colormap(Figure, colormap_BlueWhiteRed);
    cbar_handle.Label.String = "Spike Rate [Hz]";
    title(Figure,'Spike Rate over Depth');
end

cbar_handle.Label.Rotation = 270;

Clusterline = [];

% Find all line objects in the figure
Cluster_handles = findobj(Figure,'Type', 'line');

% Loop through all lines and delete those with the tag 'SpikeRateCluster'
for i = 1:length(Cluster_handles)
    if strcmp(get(Cluster_handles(i), 'Tag'), 'SpikeRateCluster')
        delete(Cluster_handles(i));
    end
end

Cluster_handles = findobj(Figure,'Type', 'line');

if ~strcmp(Clustertoshow,"All") && ~strcmp(Clustertoshow,"Non")
    Clustertoshow = str2double(Clustertoshow);
    %% Plot Cluster
    IndiciesCurrentCluster = ClusterIdentity == Clustertoshow; %% zero indexing, in app shown and seleceted as cluster+1

    spikeTimes = SpikeTimes(IndiciesCurrentCluster==1);
    spikePositions = SpikePositions(IndiciesCurrentCluster==1);

    Clusterline = line(Figure,spikeTimes,spikePositions,'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgbMatrix(Clustertoshow+1,:),'MarkerEdgeColor',rgbMatrix(Clustertoshow+1,:),'MarkerSize',5, 'Tag', 'SpikeRateCluster');

    % Bring the event line to the front
    uistack(Clusterline, 'top');

    legendEntries = findobj(Figure, 'Type', 'line', '-not', 'Tag', 'SpikeRateCluster');
    legendLabels = arrayfun(@(h) get(h, 'DisplayName'), legendEntries, 'UniformOutput', false);
    legendLabels = legendLabels(~cellfun('isempty', legendLabels));  % Remove empty labels

    % Create legend with imagesc and event line
    legendHandle = legend(Clusterline, {'Cluster'});
    set(legendHandle, 'HandleVisibility', 'off');
   
end

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",time_edges,20,[],[],[],10);
xlabel(Figure,"Time [ms]")

