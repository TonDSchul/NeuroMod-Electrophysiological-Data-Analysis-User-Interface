function Utility_Set_YAxis_Depth_Labels(Data,Figure,executableFolder,CurrentActiveChannel)

if ~contains(Figure.Title.String,"Event Related Potential")
    Figure.YLim = [min(Data.Info.ProbeInfo.ycoords(CurrentActiveChannel)) max(Data.Info.ProbeInfo.ycoords(CurrentActiveChannel))];
end

%% Create Probe Layout with ALL Channel, also those that got deleted. This gives true probe positions
DeletedChannel = 0;
if isfield(Data.Info,'ChannelDeletion')
    DeletedChannel = length(unique(Data.Info.ChannelDeletion));
else
    DeletedChannel = 0;
end

% Create combined labels
newLabels = arrayfun(@(yy, xx) sprintf('%.0f (%.0f µm)', yy, xx), Data.Info.ProbeInfo.ycoords, Data.Info.ProbeInfo.xcoords, 'UniformOutput', false);

newLabels = newLabels(min(CurrentActiveChannel):max(CurrentActiveChannel));

Ypositions = Figure.YLim(1):Data.Info.ChannelSpacing:Figure.YLim(2);

% Apply to the Data.Info.ProbeInfo.ycoords-axis of your app's UIAxes
if numel(CurrentActiveChannel)>10
    Figure.YTick = Ypositions(1:2:end);
    Figure.YTickLabel = newLabels(1:2:end);
else
    Figure.YTick = Ypositions;
    Figure.YTickLabel = newLabels;
end

