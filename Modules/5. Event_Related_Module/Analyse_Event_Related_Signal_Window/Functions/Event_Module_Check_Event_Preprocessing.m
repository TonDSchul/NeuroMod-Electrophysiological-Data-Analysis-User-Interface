function [EventDataTypeField,Value]= Event_Module_Check_Event_Preprocessing(Data,EventChannelSelection,CurrentValue)

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