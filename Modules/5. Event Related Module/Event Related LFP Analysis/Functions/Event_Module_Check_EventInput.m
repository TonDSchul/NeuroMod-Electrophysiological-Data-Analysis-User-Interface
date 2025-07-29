function [EventFieldValue] = Event_Module_Check_EventInput(EventFieldValue,Data,EventSelected,EventDataType,StartUp)

%________________________________________________________________________________________
%% Function to check whether the selection of trigger in event related analysis windows is proper

% executed on starup of event related LFP analysis windows or when the user
% changes the selction of triggers

% Inputs: 
% 1. EventFieldValue: char, input of user
% 2. Data: main window data object
% 3. EventSelected: char, name of the event channel for which trigger are
% checked
% 4. EventDataType: char, either 'Raw Event Related Data' OR 'Preprocessed
% Event Related Data' -- prepro data can have less trigger
% 5. StartUp: double, 1 or 0 whether this function is execute on window
% startup or not
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

for i = 1:length(Data.Info.EventChannelNames)
    if strcmp(EventSelected,Data.Info.EventChannelNames{i})
        EventChannelNr = i;
    end
end

if strcmp(EventDataType,'Raw Event Related Data')
    AlleventNr = length(Data.Events{EventChannelNr});
else %% if prepro and channel deleted make it differetm
    AlleventNr = length(Data.Events{EventChannelNr});
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials')

        Namevector = split(string(Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames), ',');
        TrialrejectionindiciesCurrentChannel = find(Namevector == Data.Info.EventChannelNames{EventChannelNr});

        if ~isempty(TrialrejectionindiciesCurrentChannel)
            AlleventNr = AlleventNr - length(Data.Info.EventRelatedPreprocessing.TrialRejectionTrials(TrialrejectionindiciesCurrentChannel));
        end
    end
end

if StartUp
    EventFieldValue = strcat('1:',num2str(AlleventNr));
end

if contains(EventFieldValue,',')
    if ~contains(EventFieldValue,'[') || ~contains(EventFieldValue,']')
        EventFieldValue = strcat('[',EventFieldValue,']');
    end
end

if strcmp(EventDataType,'Raw Event Related Data')
    try
        EventNr = eval(EventFieldValue);
    catch
        EventNr = 1:AlleventNr;
        EventFieldValue = strcat(num2str(min(EventNr)),':',num2str(max(EventNr)));
    end

    if length(EventNr)>AlleventNr || sum(EventNr>AlleventNr) ~= 0 || isempty(EventNr)
        msgbox("Error: Trigger range exceeds existing number of triggers! Plotting all trigger.")
        EventNr = 1:AlleventNr;
        EventFieldValue = strcat(num2str(min(EventNr)),':',num2str(max(EventNr)));
    end
else
    try
        EventNr = eval(EventFieldValue);
    catch
        EventNr = 1:AlleventNr;
        EventFieldValue = strcat(num2str(min(EventNr)),':',num2str(max(EventNr)));
    end

    if length(EventNr)>AlleventNr || sum(EventNr>AlleventNr) ~= 0 || isempty(EventNr)
        msgbox("Error: Trigger range exceeds existing number of triggers! Plotting all trigger.")
        EventNr = 1:AlleventNr;
        EventFieldValue = strcat(num2str(min(EventNr)),':',num2str(max(EventNr)));
    end
end
