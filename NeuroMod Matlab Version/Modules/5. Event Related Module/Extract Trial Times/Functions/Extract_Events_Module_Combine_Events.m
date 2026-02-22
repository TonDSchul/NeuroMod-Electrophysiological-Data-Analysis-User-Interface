function [Data] = Extract_Events_Module_Combine_Events(Data,EventsToCombine,CompleteEventChannelSelection,ActualUserEventChannelSelection,Eventstodelete)

%________________________________________________________________________________________

%% Function to combine multiple event channel into one 

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% Events: cell array, each cell containing a a x 1 event sample vector
% EventsToCombine: struc with fields: CombinedChannel: vector with event channel numbers specified by the user
% to combine
%                                     CombinedIdentity: original identies
%                                     since user can edit event nrs to
%                                     extract
% CompleteEventChannelSelection: Not used anymore
% ActualUserEventChannelSelection: vector with all event channel numbers to
% compare against EventsToCombine
% Eventstodelete: NOT USED ANYMORE

% Output
% 1. Data: Main window data strucure with changed Data.Events and
% Data.Info fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if sum(ismember(ActualUserEventChannelSelection,EventsToCombine.CombinedChannel)) == 0
    msgbox("Error: Non of the selected event channel to combine are part of the input event channel selection field! Skipping combining events.")
    return;
end

if find(ismember(EventsToCombine.CombinedChannel,ActualUserEventChannelSelection) == 0)
    msgbox("Error: One of the selected event channel to combine is not part of the input event channel selection field! Skipping combining events.")
    return;
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
    if isfield(Data.Info,'EventChannelNames')
        Data.Info.EventChannelNames(CapturedRealEventIndices) = [];
    end
else % if all are deleted, initialize empty cell
    Data.Events = cell(1,length(AllCombinedChannel));
    if isfield(Data.Info,'EventChannelNames')
        Data.Info.EventChannelNames = cell(1,length(AllCombinedChannel));
    end
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

if ~isempty(Data.Events)
    for i = 1:length(Data.Events)
        Data.Events{i} = sort(Data.Events{i});
    end
end