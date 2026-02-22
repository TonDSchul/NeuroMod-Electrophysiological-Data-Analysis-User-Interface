function Utility_Set_YAxis_Depth_Labels(Data,Figure,executableFolder,CurrentActiveChannel,PreservePlotChannelLocations)

%________________________________________________________________________________________
%% Function to put custom depth labels on the y axis (see plots like cont. spike analysis spike map)

% Input Arguments:
% 1. Data: main window datastructure
% 2. Figure: app.UIaxes object to change y labels for
% 3. executableFolder: char, folder NeuroMod was started in
% 4. CurrentActiveChannel: vector, sam ass app.ActiveChannel
% 5. PreservePlotChannelLocations: double 1 or 0 whether to preserve
% channel spacings

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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

[DataCurrentActiveChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,CurrentActiveChannel,'MainPlot');

if PreservePlotChannelLocations
    if ~contains(Figure.Title.String,"Event Related Current")
        edges = [Figure.YLim(1):Data.Info.ProbeInfo.FakeSpacing:Figure.YLim(2), Figure.YLim(2)];
        Ypositions = unique(edges); 
    else
        edges = [Figure.YLim(1)+(Data.Info.ProbeInfo.FakeSpacing/2):Data.Info.ProbeInfo.FakeSpacing:Figure.YLim(2)-(Data.Info.ProbeInfo.FakeSpacing/2), Figure.YLim(2)-(Data.Info.ProbeInfo.FakeSpacing/2)];
        Ypositions = unique(edges);  
    end
else
    if ~contains(Figure.Title.String,"Event Related Current")
       
        [StartDepth,StopDepth,~,~] = Spike_Module_Analysis_Determine_Depths(Data,PreservePlotChannelLocations,CurrentActiveChannel);
        
        edges = [StartDepth:Data.Info.ProbeInfo.FakeSpacing:StopDepth, StopDepth];
        Ypositions = unique(edges);  
    else
        [StartDepth,StopDepth,~,~] = Spike_Module_Analysis_Determine_Depths(Data,PreservePlotChannelLocations,CurrentActiveChannel);
        
        edges = [StartDepth+(Data.Info.ProbeInfo.FakeSpacing/2):Data.Info.ProbeInfo.FakeSpacing:StopDepth-(Data.Info.ProbeInfo.FakeSpacing/2), StopDepth-(Data.Info.ProbeInfo.FakeSpacing/2)];
        Ypositions = unique(edges); 
    end
end

% Apply to the Data.Info.ProbeInfo.ycoords-axis of your app's UIAxes
if numel(CurrentActiveChannel)>10 && numel(CurrentActiveChannel)<100
    if mod(length(Ypositions),2)
        Figure.YTick = Ypositions(1:2:end);
        Figure.YTickLabel = newLabels(1:2:end);
    else
        Figure.YTick = Ypositions(1:3:end);
        Figure.YTickLabel = newLabels(1:3:end);
    end
elseif numel(CurrentActiveChannel)>100
    if mod(length(Ypositions),2)
        Figure.YTick = Ypositions(1:8:end);
        Figure.YTickLabel = newLabels(1:8:end);
    else
        Figure.YTick = Ypositions(1:9:end);
        Figure.YTickLabel = newLabels(1:9:end);
    end
else
    Figure.YTick = Ypositions;
    Figure.YTickLabel = newLabels;
end

