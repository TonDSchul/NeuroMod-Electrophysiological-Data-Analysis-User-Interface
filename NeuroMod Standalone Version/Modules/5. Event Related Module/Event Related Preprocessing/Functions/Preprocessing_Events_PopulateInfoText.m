function Preprocessing_Events_PopulateInfoText(TextArea,Data,EventChannelSelectionDropDown)

%________________________________________________________________________________________
%% Function to show what preprocessing steps were applied already to event related data in windoww the user selects the prepro step

% called when some preprocessing step was applied or when window to select
% prepro steps is opened

% Inputs: 
% 1. TextArea: text object of prepro selection window supposed to show the
% prepro infos (shown when string or char is saved as TextArea.Value)
% 2. Data: main app data structure with Data.PreprocessedEventRelatedData, 
% Data.EventRelatedPreprocessing and Data.Info fields
% 3. EventChannelSelectionDropDown: char, name of the event channel 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if isfield(Data.Info,'EventRelatedPreprocessing')

    TextArea.Value = ["Please select the kind of preprocessing you want to conduct. After saving changes to the dataset, the conducted steps will be shown in this window.";"Preprocessing steps for event related data found:"];
    infoString = [];
    fields = fieldnames(Data.Info.EventRelatedPreprocessing);
    for k = 1:numel(fields)
        fieldName = fields{k};
        fieldValue = Data.Info.EventRelatedPreprocessing.(fieldName);
        if isnumeric(fieldValue)
            infoString = sprintf('%s%s: %s\n', infoString, fieldName, num2str(fieldValue));
        else
            infoString = sprintf('%s%s: %s\n', infoString, fieldName, fieldValue);
        end
    end
    % Get the current value of the TextArea.Value
    currentValue = TextArea.Value;
    
    % Ensure the current value is a character array (char type)
    if iscell(currentValue)
        currentValue = char(currentValue);
    end

    TextArea.Value = [currentValue;"";infoString];

else
    
    TextArea.Value = "Event data for the currently selected event channel was not preprocessed yet. Please select the kind of preprocessing you want to conduct. After saving changes to the dataset, the conducted steps will be shown in this window.";
    EventIndice = [];
    for i = 1:length(Data.Info.EventChannelNames)
        if strcmp(EventChannelSelectionDropDown,Data.Info.EventChannelNames{i})
            EventIndice = i;
            break;
        end
    end
    
    if ~isempty(EventIndice)
        ntrials = length(Data.Events{EventIndice});
    end
    nchannel = size(Data.Raw,1);
    
    if isfield(Data,'Preprocessed')
        TextArea.Value = [TextArea.Value;"Preprocessed data found to extract from with the following steps applied:"];
        [texttoshow] = Preprocessing_Events_ExtractPreprocessingStep(Data);
        TextArea.Value = [TextArea.Value;texttoshow];
    end
    
    for i = 1:length(Data.Info.EventChannelNames)
        TextArea.Value{end+1} = '';
        TextArea.Value{end+1} = convertStringsToChars(strcat("Event Related Data for Event Channel",Data.Info.EventChannelNames{i}," has following dimensions: ","Number Channel: ",num2str(nchannel),", Number Trigger: ",num2str(length(Data.Events{i}))));
    end
    TextArea.Value{end+1} = '';
    TextArea.Value{end+1} = '**Note** Number of trigger determined before data was extracted. Actual trigger/trial number per channel can vary if extacted trial data violates time limits.';
end