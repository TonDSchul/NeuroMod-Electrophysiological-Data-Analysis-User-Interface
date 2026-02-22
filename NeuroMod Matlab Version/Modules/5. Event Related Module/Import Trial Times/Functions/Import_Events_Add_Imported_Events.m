function [Data,EventChannelDropDown] = Import_Events_Add_Imported_Events(Data,EventInfo)

%________________________________________________________________________________________
%% Function to add imported events to the main window data structure

% Inputs:
% 1. Data: main window data structure
% 2. EventInfo: struc holding event info laoded from selected file with
% fields TempEvents as cell array with time stamps for each event channel
% pretty much the finsihed Data.Events already, just has to be 'cleaned' by checking time violations etc.

% Outputs:
% 1. Data: main window data structure with Data.Events and corresponding
% Data.Info fields
% 2. EventChannelDropDown: cell array with each cell containing a char with
% an event channel name

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% First maintaining GUI main data structure by deleting previous event data
if isfield(Data,'Events')
    msgbox("Warning: Events where already extracted. Previous data will be overwritten!");
end

if isfield(Data,'Events')
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Events");
end

%% check for events outside of range
eventnames = strsplit(EventInfo.EventNames,',');

for i = 1:length(EventInfo.TempEvents)

    deletedevents = EventInfo.TempEvents{i}(EventInfo.TempEvents{i} > Data.Info.num_data_points);

    EventInfo.TempEvents{i}(EventInfo.TempEvents{i} > Data.Info.num_data_points) = [];

    if ~isempty(deletedevents)
        msgbox(strcat("Event ",eventnames{i}," contains ",num2str(length(deletedevents))," event indices outside the time range that are deleted."))
    end
end

Celltodelete = [];
for i = 1:length(EventInfo.TempEvents)
    if isempty(EventInfo.TempEvents{i})
        Celltodelete = [Celltodelete,i];
    end
end

if ~isempty(Celltodelete)
    for i = 1:length(Celltodelete)
        if length(EventInfo.TempEvents) > 1
            EventInfo.TempEvents(Celltodelete) = [];
            eventnames(Celltodelete) = [];
        else
            EventChannelDropDown{1} = "";
            msgbox("Non of the event channel contain suitable indices. No events extracted.")
            if isfield(Data,'Events')
                fieldToRemove = 'Events';
                Data = rmfield(Data, fieldToRemove);
            end
            return
        end
    end
end

Data.Info.EventChannelNames = eventnames;
Data.Events = EventInfo.TempEvents;
Data.Info.EventChannelType = "Imported File";

for i = 1:length(eventnames)
    EventChannelDropDown{i} = eventnames{i};
end