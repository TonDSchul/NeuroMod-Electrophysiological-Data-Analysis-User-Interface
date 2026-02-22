function [EventDataTypeField,Value]= Event_Module_Check_Event_Preprocessing(Data,EventChannelSelection,CurrentValue)

%________________________________________________________________________________________
%% Function to check whether event related data was preprocessed to fill selection dropdown menu

% executed when the user changes the for example the event channel
% selection for which Event related data is anylszed. This is bc
% preprocessing is bound to a certain event channel

% Inputs: 
% 1. Data: main window data object
% 2. EventChannelSelection: char, name of the event channel for which trigger are
% checked
% 3. CurrentValue: Currently selected value (either 'Raw Event Related Data' OR 'Preprocessed Event Related Data')
% --> this is so selection of prepro data can be preserved when selecting
% another event channel

% Outputs:
% 1. EventDataTypeField: Determined content of selection dropdown menu (dropdown.Items)
% 2. Value: Current value selected in the selection dropdown menu (dropdown.Value)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

OriginalValue = [];

if ~isempty(CurrentValue)
    OriginalValue = CurrentValue;
end
EventDataTypeField = {};

if ~isfield(Data.Info,'EventRelatedPreprocessing')
    EventDataTypeField{1} = 'Raw Event Related Data';
    Value = 'Raw Event Related Data';
    return;
else
    EventDataTypeField{1} = 'Raw Event Related Data';
end

FoundPreproSteps = 0;
%% --------- Check Trial Rejection Presence ---------
% Find rejection indices for the currently selected event channel
if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionEventChannelNames')
    Namevector = split(string(Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames), ',');
    TrialrejectionindiciesCurrentChannel = find(Namevector == EventChannelSelection);
    
    if ~isempty(TrialrejectionindiciesCurrentChannel)
        FoundPreproSteps = FoundPreproSteps + 1 ;
    end
end
%% --------- Check Trial Rejection Presence ---------
% Find rejection indices for the currently selected event channel
if isfield(Data.Info.EventRelatedPreprocessing,'ChannelRejectionEventChannelNames')
    Namevector = split(string(Data.Info.EventRelatedPreprocessing.ChannelRejectionEventChannelNames), ',');
    ChannelrejectionindiciesCurrentChannel = find(Namevector == EventChannelSelection);
    
    if ~isempty(ChannelrejectionindiciesCurrentChannel)
        FoundPreproSteps = FoundPreproSteps + 1 ;
    end
end

if FoundPreproSteps>0
    EventDataTypeField{2} = 'Preprocessed Event Related Data';
end

%% --------- Restore Original Value selected if avalable ---------
Value = 'Raw Event Related Data';
if FoundPreproSteps>0
    if ~isempty(OriginalValue)
        OrignalIndice = [];
        for i = 1:length(EventDataTypeField)
            if strcmp(OriginalValue,EventDataTypeField{i})
                OrignalIndice = i;
            end
        end
        if ~isempty(OrignalIndice)
            Value = EventDataTypeField{OrignalIndice};
        else
            Value = EventDataTypeField{1};
        end
    else
        Value = EventDataTypeField{1};
    end
else
    Value = EventDataTypeField{1};
end

if isempty(Value)
    Value = EventDataTypeField{1};
end