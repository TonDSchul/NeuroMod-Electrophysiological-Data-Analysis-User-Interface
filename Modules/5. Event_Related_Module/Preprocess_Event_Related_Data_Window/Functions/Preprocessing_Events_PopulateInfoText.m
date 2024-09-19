function Preprocessing_Events_PopulateInfoText(TextArea,Data)

%________________________________________________________________________________________
%% Function to show what preprocessing steps were applied already to event related data in windoww the user selects the prepro step

% called when some preprocessing step was applied or when window to select
% prepro steps is opened

% Inputs: 
% 1. TextArea: text object of prepro selection window supposed to show the
% prepro infos (shown when string or char is saved as TextArea.Value)
% 2. Data: main app data structure with Data.PreprocessedEventRelatedData, 
% Data.EventRelatedPreprocessing and Data.Info fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if isfield(Data.Info,'EventRelatedPreprocessing')
    [nchannel,ntrials,ntime] = size(Data.PreprocessedEventRelatedData);
    TextArea.Value = ["Please select the kind of preprocessing you want to conduct.","","Preprocessed Event Related Data found with dimensions:","","Nr Channel: ",num2str(nchannel),"Nr Trials: ",num2str(ntrials),"Nr Time Points:", num2str(ntime),"","Already applied preprocessing:"];
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
    TextArea.Value = "Event data was not preprocessed yet. Please select the kind of preprocessing you want to conduct.";
    [nchannel,ntrials,ntime] = size(Data.EventRelatedData);
    TextArea.Value = [TextArea.Value,"","Event Data has following dimensions:","","Nr Channel: ",num2str(nchannel),"Nr Trials: ",num2str(ntrials),"Nr Time Points:", num2str(ntime)];
end