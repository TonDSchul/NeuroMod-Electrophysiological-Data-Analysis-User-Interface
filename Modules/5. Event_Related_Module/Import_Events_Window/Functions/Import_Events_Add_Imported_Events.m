function [Data,EventChannelDropDown] = Import_Events_Add_Imported_Events(Data,EventInfo)

%________________________________________________________________________________________
%% Function to add imported events to the main window data structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% First maintaining GUI main data structure by deleting previous event data
if isfield(Data,'Events')
    msgbox("Warning: Events where already extracted. Previous data will be overwritten!");
    fieldToRemove = 'Events';
    Data = rmfield(Data, fieldToRemove);
    if isfield(Data,'EventChannelType')
        fieldsToDelete = {'EventChannelType'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data,'EventChannelNames')
        fieldsToDelete = {'EventChannelNames'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
else
    Data.Events = [];
end

if isfield(Data,'EventRelatedSpikes')
    fieldsToDelete = {'EventRelatedSpikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
end

if isfield(Data,'EventRelatedData')
    msgbox("Existing event related data found and overwritten");
    fieldsToDelete = {'EventRelatedData'};
    Data = rmfield(Data, fieldsToDelete);
    fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
    Data.Info = rmfield(Data.Info, fieldsToDelete);
end

if isfield(Data,'PreprocessedEventRelatedData')
    msgbox("Existing preprocessed event related data found and deleted");
    fieldsToDelete = {'PreprocessedEventRelatedData'};
    Data = rmfield(Data, fieldsToDelete);
    fieldsToDelete = {'EventRelatedPreprocessing'};
    Data.Info = rmfield(Data.Info, fieldsToDelete);
end

Data.Events = EventInfo.TempEvents;
Data.Info.EventChannelType = "Imported File";

eventnames = strsplit(EventInfo.EventNames,',');

Data.Info.EventChannelNames = eventnames;

for i = 1:length(eventnames)
    EventChannelDropDown{i} = eventnames{i};
end