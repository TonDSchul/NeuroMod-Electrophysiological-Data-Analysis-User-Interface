function CurrentPlotData = Event_Spikes_Plot_Heatmap_Spike_Rate(SpikeTimes,SpikePositions,Figure,SR,time_bin_size,depth_edges,time_edges,nevents,eventtime,Normalize,NormWindow,Clustertoshow,ClusterIdentity,rgbMatrix,ChannelsToPlot,ChannelSpacing,appWindow,TwoORThreeD,CurrentPlotData,PlotAppearance)

%________________________________________________________________________________________

%% Function to compute and plot spike rate over depth (as a Heatmap)
% This function takes all spikes and sorts for those in the event range
% every time, the window for event spike analysis is opened. It is saved as
% Data.EventRelatedSpikes structure, which gets overwritten every time

% This function gets called in the main window when the user clicks on run
% for event spike analysis (Internal and Kilosort)

% Input:
% 1. SpikeTimes: nspikes x 1 double in seconds. Spike time before event is
% negativ
% 2. SpikePositions: nspikes x 1 double with spike positions (in um) - for
% internal: channelnr * ChannelSpacing
% 3. Figure: Figure axes object to plot in
% 4. SR: SampleRate as double in Hz
% 5. time_bin_size: double, Bin size in seconds
% 6. depth_edges: edges of depth bins (in um)
% 7. time_edges: edges of depth bins (in s)
% 8. nevents: number of events to divide spike rate by to normalize for a
% single trial/event
% 9. eventtime: double, Time in seconds to plot event line at (default at 0s)
% 10. Normalize: 1 to basline normalized, 0 if not
% 11. NormWindow: 1x2 double with min and max of time range (in seconds with negativ possible)
% 12. Clustertoshow: char, 'Non' OR 'All' or a single number like '4' for
% unit 4
% 13. ClusterIdentity: nspikes x 1 double with unit identitiy for each spike
% 14. rgbMatrix: nunits x 3 double with rgb values 
% 15. ChannelsToPlot: 1 x 2 double with channel to plot, i.e. [1,10] for
% channel 1 to 10 
% 16. ChannelSpacing: in um from Data.Info.ChannelSpacing
% 17. appWindow: char, 'Kilosort' OR 'Internal' to see which window it
% comes from
% 18. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 19. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Calculate Spike Rate in each bin
% Convert spike times to seconds

% Create 2D histogram of spike counts
depth_edges = depth_edges - ChannelSpacing/2;
spike_counts = histcounts2(SpikePositions, SpikeTimes, depth_edges, time_edges);

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

%% make sure that Image_handles is empty

eventLine = [];

DepthToPlot = depth_edges(2:end) - ChannelSpacing/2;

if strcmp(TwoORThreeD,"TwoD")
    PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    if length(PowerDepth2D_handles)>1
        delete(PowerDepth2D_handles(2:end));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    end

    min_z = 0;
    if isempty(PowerDepth2D_handles)
        surface(Figure,time_edges(1:end-1),DepthToPlot, min_z * ones(size(spike_rates)), ...
        'CData', spike_rates, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    else
        set(PowerDepth2D_handles(1),'XData',time_edges(1:end-1),'YData',DepthToPlot, 'ZData',min_z * ones(size(spike_rates)), ...
        'CData', spike_rates, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    end

    Event_handles = findobj(Figure,'Tag', 'Event');
    if numel(Event_handles)>1
        delete(Event_handles(2:end));
    end
    if isempty(Event_handles)
        eventLine = line(Figure,[eventtime,eventtime],[DepthToPlot(1),DepthToPlot(end)],'Color',PlotAppearance.InternalEventSpikePlot.MainPlotTriggerColor,'LineWidth',PlotAppearance.InternalEventSpikePlot.MainPlotTriggerWidth, 'Tag', 'Event');
    else
        set(Event_handles(1),'XData',[eventtime,eventtime],'YData',[DepthToPlot(1),DepthToPlot(end)],'Color',PlotAppearance.InternalEventSpikePlot.MainPlotTriggerColor,'LineWidth',PlotAppearance.InternalEventSpikePlot.MainPlotTriggerWidth, 'Tag', 'Event');
        eventLine = Event_handles(1);
    end
elseif strcmp(TwoORThreeD,"ThreeD")
    PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    
    if length(PowerDepth2D_handles)>1
        delete(PowerDepth2D_handles(2:end));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    elseif length(PowerDepth3D_handles)>1
        delete(PowerDepth3D_handles(2:end));
        PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    end
    
    if length(PowerDepth3D_handles)+length(PowerDepth2D_handles)==1
        delete(PowerDepth3D_handles(:));
        delete(PowerDepth2D_handles(:));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    end

    if isempty(PowerDepth2D_handles) || isempty(PowerDepth3D_handles)
        % 3D
        surf(Figure,time_edges(1:end-1),DepthToPlot,spike_rates,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
        % 2D
        % 2D Plot
        min_z = min(spike_rates,[],'all');
        surface(Figure,time_edges(1:end-1),DepthToPlot, min_z * ones(size(spike_rates)), ...
        'CData', spike_rates, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    else
        % 3D
        set(PowerDepth3D_handles(1),'XData',time_edges(1:end-1),'YData',DepthToPlot,'ZData',spike_rates,'CData',spike_rates,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
        % 2D
        % 2D Plot
        min_z = min(spike_rates,[],'all');
        set(PowerDepth2D_handles(1),'XData',time_edges(1:end-1),'YData',DepthToPlot, 'ZData',min_z * ones(size(spike_rates)), ...
        'CData', spike_rates, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    end

    view(Figure,45,45);
    box(Figure, 'off');
    grid(Figure, 'off');

    % event line
    Event_handles = findobj(Figure,'Tag', 'Event');
    if numel(Event_handles)>1
        delete(Event_handles(2:end));
    end

    % Define the Y and Z ranges
    Y = [DepthToPlot(1), DepthToPlot(end)];
    Z = [min(spike_rates,[],'all'), max(spike_rates,[],'all')];  
    
    % Create a plane through Y and Z
    [YGrid, ZGrid] = meshgrid(Y, Z);
    
    XGrid = zeros(size(YGrid));
    
    if isempty(Event_handles)
        eventLine=surf(Figure,XGrid, YGrid, ZGrid, 'FaceColor', PlotAppearance.InternalEventSpikePlot.MainPlotTriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
    else
        set(Event_handles(1),'XData',XGrid,'YData', YGrid,'ZData', ZGrid, 'FaceColor', PlotAppearance.InternalEventSpikePlot.MainPlotTriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
        eventLine = Event_handles(1);
    end
end

ylim(Figure,[min(DepthToPlot), max(DepthToPlot)]);  % Ensure y-axis matches
xlim(Figure,[time_edges(1),time_edges(end)]);
ylabel(Figure,PlotAppearance.InternalEventSpikePlot.MainPlotYLabel);
xlabel(Figure,PlotAppearance.InternalEventSpikePlot.MainPlotXLabel);

set(Figure, 'YDir', 'reverse');
set(Figure,'xticklabel',{[]});

% Add legend only once
if isempty(findobj(Figure, 'Type', 'legend')) && ~isempty(eventLine)
    % Create legend with imagesc and event line
    legendHandle = legend(eventLine, {'Trigger'});
    set(legendHandle, 'HandleVisibility', 'off');
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
    IndiciesCurrentCluster = ClusterIdentity == Clustertoshow; %% 

    if sum(IndiciesCurrentCluster)>0
        spikeTimes = SpikeTimes(IndiciesCurrentCluster==1);
        spikePositions = SpikePositions(IndiciesCurrentCluster==1);
    
        Clusterline = line(Figure,spikeTimes,spikePositions,'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgbMatrix(Clustertoshow,:),'MarkerEdgeColor',rgbMatrix(Clustertoshow,:),'MarkerSize',PlotAppearance.InternalEventSpikePlot.MainPlotSpikeWidth, 'Tag', 'SpikeRateCluster');
    
        % Bring the event line to the front
        uistack(Clusterline, 'top');
    
        legendEntries = findobj(Figure, 'Type', 'line', '-not', 'Tag', 'SpikeRateCluster');
        legendLabels = arrayfun(@(h) get(h, 'DisplayName'), legendEntries, 'UniformOutput', false);
        legendLabels = legendLabels(~cellfun('isempty', legendLabels));  % Remove empty labels
    
        % Create legend with imagesc and event line
        legendHandle = legend(Clusterline, {'Cluster'});
        set(legendHandle, 'HandleVisibility', 'off');
    end
end

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",time_edges,20,[],[],[],10);
xlabel(Figure,"Time [ms]")

%% Save data main plot for export
CurrentPlotData.MainXData = time_edges(1:end-1);
CurrentPlotData.MainYData = DepthToPlot;
CurrentPlotData.MainCData = spike_rates;

if strcmp(appWindow,"Kilosort")
    CurrentPlotData.MainType = strcat("Event Kilosort Heatmap Spike Rates");
else
    CurrentPlotData.MainType = strcat("Event Internal Heatmap Spike Rates");
end

CurrentPlotData.MainXTicks = Figure.XTickLabel;

