function [Data] = Extract_Events_Module_Combine_Events(Data,EventsToCombine,EventChannelSelection)

EventChannelSelection = str2double(strsplit(EventChannelSelection,','));

% number of how often channel are combined to a single one
AllCombinedChannel = length(unique(EventsToCombine.CombinedIdentity));

AllEvents = {}; % save combine event time stamps. Each cell for a newly combined event channel

CapturedRealEventIndices = [];
for i = 0:AllCombinedChannel-1 %zero indexed
    % Indice of all channel part of the first(second...) combination selection
    AllCurrentChannel = EventsToCombine.CombinedIdentity == i;
    
    RealEventIndices = find(ismember(EventChannelSelection,EventsToCombine.CombinedChannel(AllCurrentChannel))==1);
    % save for later
    CapturedRealEventIndices = [CapturedRealEventIndices,RealEventIndices];

    for j = 1:length(RealEventIndices)
        if j > 1
            AllEvents{i+1} = [AllEvents{i+1};Data.Events{RealEventIndices(j)}(:)];
        end
        if j == 1
            AllEvents{i+1} = [Data.Events{RealEventIndices(j)}(:)];
        end
    end
end

% delete individual event channel (or all)
if length(EventsToCombine.CombinedIdentity) < length(Data.Events)
    Data.Events(CapturedRealEventIndices) = [];
    Data.Info.EventChannelNames(CapturedRealEventIndices) = [];
else % if all are deleted, initialize empty cell
    Data.Events = cell(1,length(AllCombinedChannel));
    Data.Info.EventChannelNames = cell(1,length(AllCombinedChannel));
end

if ~isempty(AllEvents)
    if isempty(Data.Events{1}) % if new cell was initiated: every event is replaced from 1 to end
        for i = 1:length(AllEvents)
            Data.Events{i} = AllEvents{i}';
            Data.Info.EventChannelNames{i} = EventsToCombine.NewCombinedChannelNames{i};
        end
    else 
        for i = 1:length(AllEvents) % some channel still left. So dont start indexing of data.events at 1
            Data.Events{end+1} = AllEvents{i}';
            Data.Info.EventChannelNames{end+1} = EventsToCombine.NewCombinedChannelNames{i};
        end
    end
end