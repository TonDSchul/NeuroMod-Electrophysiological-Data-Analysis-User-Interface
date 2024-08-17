function [Data,Error] = Organize_Delete_Dataset_Components(Data,ComponentToDelete)
%________________________________________________________________________________________

%% Function to delete a specific field of the Data structure. 
% Inputs:
% 1. Data: Data structure with Data.Raw or Data.Preprocessed, Data.Spikes
% and so on for Data and Data.Info for information about data.
% 2: ComponentToDelete: string, determines which part of the dataset should
% be deleted, otions: 
%"Spikes" OR "EventRelatedSpikes" OR "EventRelatedData" OR "Events" OR "Preprocessed" OR "Raw" Or "PreprocessedEventRelatedData"

% Output:
% Error: 1 if no data would be left after deleting, 0 if otherwise, If 1,
% deletion is not executed

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Error = 0;

if strcmp(ComponentToDelete,"Spikes")
    
    fieldsToDelete = {'Spikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
    Data.Info.SpikeType = 'Non';
    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
    if isfield(Data.Info,'SpikeDetectionThreshold')
        fieldsToDelete = {'SpikeDetectionThreshold'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'KilosortScalingFactor')
        fieldsToDelete = {'KilosortScalingFactor'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    
elseif strcmp(ComponentToDelete,"EventRelatedSpikes")
    
    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
    
elseif strcmp(ComponentToDelete,"EventRelatedData")
    
    fieldsToDelete = {'EventRelatedData'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
    
    fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
    Data.Info = rmfield(Data.Info, fieldsToDelete);
    
    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

    if isfield(Data,'PreprocessedEventRelatedData')
        if ~isempty(Data.PreprocessedEventRelatedData)
            fieldsToDelete = {'PreprocessedEventRelatedData'};
            Data = rmfield(Data, fieldsToDelete);
            fieldsToDelete = {'EventRelatedPreprocessing'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
    end

elseif strcmp(ComponentToDelete,"Events")

    fieldsToDelete = {'Events'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);

    fieldsToDelete = {'EventChannelType', 'EventChannelNames'};
    % Delete fields
    Data.Info = rmfield(Data.Info, fieldsToDelete);

    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

    if isfield(Data,'EventRelatedData')
        fieldsToDelete = {'EventRelatedData'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
       
        fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data,'EventRelatedData')
        if ~isempty(Data.EventRelatedData)
            fieldsToDelete = {'EventRelatedData'};
            Data = rmfield(Data, fieldsToDelete);
            fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
    end
    
    if isfield(Data,'PreprocessedEventRelatedData')
        if ~isempty(Data.PreprocessedEventRelatedData)
            fieldsToDelete = {'PreprocessedEventRelatedData'};
            Data = rmfield(Data, fieldsToDelete);
            fieldsToDelete = {'EventRelatedPreprocessing'};
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
    end
    
elseif strcmp(ComponentToDelete,"Preprocessed")

    if ~isfield(Data,'Raw')
        msgbox("Error: No raw data found. Either raw or preprocessed data required for the toolbox to work.");
        Error = 1;
        return;
    end

    if isfield(Data.Info,'DownsampleFactor')
        fieldsToDelete = {'TimeDownsampled'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'DownsampleFactor','DownsampledSampleRate'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    fieldNames = fieldnames(Data.Info);
    idx = find(strcmp(fieldNames, 'Channelorder'));
   
    TempEventChannel = [];
    TempEventDataType = [];
    TempEventTimeRange = [];

    if isfield(Data.Info,'EventChannelNames')
        TempEventChannel = Data.Info.EventRelatedDataChannel;
        TempEventDataType = Data.Info.EventRelatedDataType;
        TempEventTimeRange = Data.Info.EventRelatedDataTimeRange;
    end

    TempEventChannelNames = [];
    TempEventChannelType = [];
    if isfield(Data,'EventRelatedData')
        TempEventChannelNames = Data.Info.EventChannelNames;
        TempEventChannelType = Data.Info.EventChannelType;
    end

    % Create a new structure with only the fields up to the found index
    Data.Info = rmfield(Data.Info, fieldNames(idx+1:end));

    if ~isempty(TempEventChannelNames)
        Data.Info.EventChannelNames = TempEventChannelNames;
        Data.Info.EventChannelType = TempEventChannelType;
    end

    if ~isempty(TempEventChannel)
        Data.Info.EventRelatedDataChannel = TempEventChannel;
        Data.Info.EventRelatedDataType = TempEventDataType;
        Data.Info.EventRelatedDataTimeRange = TempEventTimeRange;
    end

    if isfield(Data,'Preprocessed')
        fieldsToDelete = {'Preprocessed'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

elseif strcmp(ComponentToDelete,"Raw")

    if isfield(Data,'Preprocessed')
        fieldsToDelete = {'Raw'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);    
    else
        msgbox("Error: No preprocessed data found. Either raw or preprocessed data is required for the toolbox to work");
        Error = 1;
        return;
    end

elseif strcmp(ComponentToDelete,"PreprocessedEventRelatedData")

    if isfield(Data,'PreprocessedEventRelatedData')
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        
        Data = rmfield(Data, fieldsToDelete);
    
        fieldsToDelete = {'EventRelatedPreprocessing'};
        
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

end