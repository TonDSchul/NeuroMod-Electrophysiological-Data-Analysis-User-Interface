function [Data] = Extract_Events_Module_Combine_Events(Data,EventsToCombine,CompleteEventChannelSelection,ActualUserEventChannelSelection,Eventstodelete)

% check if channel to combine are part of the actually selected channel
ActualUserEventChannelSelection = str2double(strsplit(ActualUserEventChannelSelection,','));

if sum(ismember(ActualUserEventChannelSelection,EventsToCombine.CombinedChannel)) == 0
    msgbox("Error: Non of the selected event channel to combine are part of the input event channel selection field! Skipping combining events.")
    return;
end
if find(ismember(EventsToCombine.CombinedChannel,ActualUserEventChannelSelection) == 0)
    msgbox("Error: One of the selected event channel to combine is not part of the input event channel selection field! Skipping combining events.")
    return;
end

if ~isempty(Eventstodelete)
    if find(ismember(EventsToCombine.CombinedChannel,Eventstodelete) == 1)
        Indices = ismember(EventsToCombine.CombinedChannel,Eventstodelete);
        msgbox(strcat("Error: One or more of the selected channel to combine had to be deleted (for example bc. it was not selected as input event channe or due to all triggers being outside of time window). Cannot combine events! Please try again by deleteing the channel without triggers in the input event channel selection field! Event Indices affected: ",num2str(EventsToCombine.CombinedChannel(Indices))))
        return;
    end
end

CompleteEventChannelSelection = str2double(strsplit(CompleteEventChannelSelection,','));

% number of how often channel are combined to a single one
AllCombinedChannel = length(unique(EventsToCombine.CombinedIdentity));

AllEvents = {}; % save combine event time stamps. Each cell for a newly combined event channel

CapturedRealEventIndices = [];
for i = 0:AllCombinedChannel-1 %zero indexed
    % Indice of all channel part of the first(second...) combination selection
    AllCurrentChannel = EventsToCombine.CombinedIdentity == i;
    
    RealEventIndices = find(ismember(ActualUserEventChannelSelection,EventsToCombine.CombinedChannel(AllCurrentChannel))==1);
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