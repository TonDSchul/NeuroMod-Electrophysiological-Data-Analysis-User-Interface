function Utility_Set_YAxis_Depth_Labels(Data,Figure,executableFolder,CurrentActiveChannel,PreservePlotChannelLocations)

%% Create Probe Layout with ALL Channel, also those that got deleted. This gives true probe positions
DeletedChannel = 0;
if isfield(Data.Info,'ChannelDeletion')
    DeletedChannel = length(unique(Data.Info.ChannelDeletion));
else
    DeletedChannel = 0;
end

if PreservePlotChannelLocations
    % Create combined labels
    newLabels = Data.Info.ProbeInfo.YLabels(min(CurrentActiveChannel):max(CurrentActiveChannel));
else
    % Create combined labels
    newLabels = Data.Info.ProbeInfo.YLabels(CurrentActiveChannel);
end

if PreservePlotChannelLocations
    if ~contains(Figure.Title.String,"Event Related Current")
        Ypositions = Figure.YLim(1):Data.Info.ChannelSpacing:Figure.YLim(2);
    else
        Ypositions = Figure.YLim(1)+(Data.Info.ChannelSpacing/2):Data.Info.ChannelSpacing:Figure.YLim(2)-(Data.Info.ChannelSpacing/2);
    end
else
    if ~contains(Figure.Title.String,"Event Related Current")
        FakeChannelRange = 1:length(CurrentActiveChannel);
        FakeYpositions = (FakeChannelRange-1)*Data.Info.ChannelSpacing;
        StartDepth = min(FakeYpositions);
        StopDepth = max(FakeYpositions);
    
        Ypositions = StartDepth:Data.Info.ChannelSpacing:StopDepth;
    else
        FakeChannelRange = 1:length(CurrentActiveChannel);
        FakeYpositions = (FakeChannelRange-1)*Data.Info.ChannelSpacing;
        StartDepth = min(FakeYpositions);
        StopDepth = max(FakeYpositions);
    
        Ypositions = StartDepth+(Data.Info.ChannelSpacing/2):Data.Info.ChannelSpacing:StopDepth-(Data.Info.ChannelSpacing/2);
    end
end

% Apply to the Data.Info.ProbeInfo.ycoords-axis of your app's UIAxes
if numel(CurrentActiveChannel)>10
    Figure.YTick = Ypositions(1:2:end);
    Figure.YTickLabel = newLabels(1:2:end);
else
    Figure.YTick = Ypositions;
    Figure.YTickLabel = newLabels;
end

