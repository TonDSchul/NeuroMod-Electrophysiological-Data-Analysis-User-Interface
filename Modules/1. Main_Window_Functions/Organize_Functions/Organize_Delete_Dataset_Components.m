function [Data,Error] = Organize_Delete_Dataset_Components(Data,ComponentToDelete)
%________________________________________________________________________________________

%% Function to delete a specific field of the Data structure. 

% Gets called in the Manage dataset components window when the user clicks
% the 'Delete Dataset Component' Button

% Inputs:
% 1. Data: Data structure with Data.Raw or Data.Preprocessed, Data.Spikes
% and so on as well as Data.Info for information about data.
% 2: ComponentToDelete: string, determines which part of the dataset should
% be deleted, otions: 
%"Spikes" OR "EventRelatedSpikes" OR "EventRelatedData" OR "Events" OR "Preprocessed" OR "Raw" Or "PreprocessedEventRelatedData"

% Output:
% Error: 1 if no data would be left after deleting, 0 if otherwise; If 1,
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

    if isfield(Data.Info,'SpikeSorting')
        fieldsToDelete = {'SpikeSorting'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'SpikeDetectionNrStd')
        fieldsToDelete = {'SpikeDetectionNrStd'};
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
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'EventRelatedPreprocessing'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
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
        fieldsToDelete = {'EventRelatedData'};
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    
    if isfield(Data,'PreprocessedEventRelatedData')
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'EventRelatedPreprocessing'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    
elseif strcmp(ComponentToDelete,"Preprocessed")

    %% If just Raw Data saved: Delete preprocessing infos from Data.Info structure.
    % They all come after the field "ChannelOrder
    % Find the index of the specific field
    if isfield(Data.Info,'DownsampleFactor')
        fieldsToDelete = {'TimeDownsampled','DownsampledSampleRate'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'DownsampleFactor'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    fieldNames = fieldnames(Data.Info);
    idx = find(strcmp(fieldNames, 'Channelorder'));
   
    TempEventChannel = [];
    TempEventDataType = [];
    TempEventTimeRange = [];
    TempPreproInfoType = [];
    TempSpikeDetectionThreshold = [];
    TempKilosortScalingFactor = [];
    TempSpikeType = Data.Info.SpikeType;
    TempCutStart = [];
    TempCutStop = [];
    TempChannelDeletion = [];
    TempSpike2EventChannelToTake = [];
    TempSpikeSorting = [];
    TempSpikeDetectionNrStd = [];

    if isfield(Data.Info,'CutStart')
        TempCutStart = Data.Info.CutStart;
    end

    if isfield(Data.Info,'Spike2EventChannelToTake')
        TempSpike2EventChannelToTake = Data.Info.Spike2EventChannelToTake;
    end

    if isfield(Data.Info,'CutEnd')
        TempCutStop = Data.Info.CutEnd;
    end

    if isfield(Data.Info,'ChannelDeletion')
        TempChannelDeletion = Data.Info.ChannelDeletion;
    end

    if isfield(Data.Info,'KilosortScalingFactor')
        TempKilosortScalingFactor = Data.Info.KilosortScalingFactor;
    end

    if isfield(Data,'EventRelatedData')
        TempEventChannel = Data.Info.EventRelatedDataChannel;
        TempEventDataType = Data.Info.EventRelatedDataType;
        TempEventTimeRange = Data.Info.EventRelatedDataTimeRange;
    end

    if isfield(Data,'PreprocessedEventRelatedData')
        if isfield(Data.Info,'EventRelatedPreprocessing')
            TempPreproInfoType = Data.Info.EventRelatedPreprocessing;
        end
    end

    if isfield(Data.Info,'SpikeSorting')
        TempSpikeSorting = Data.Info.SpikeSorting;
    end

    if isfield(Data.Info,'SpikeDetectionNrStd')
        TempSpikeDetectionNrStd = Data.Info.SpikeDetectionNrStd;
    end

    if isfield(Data.Info,'SpikeDetectionThreshold')
        TempSpikeDetectionThreshold = Data.Info.SpikeDetectionThreshold;
    end
    
    if isfield(Data.Info,'EventChannelNames')
        TempEventChannelNames = Data.Info.EventChannelNames;
        TempEventChannelType = Data.Info.EventChannelType;
    else
        TempEventChannelNames = [];
    end

    % Create a new structure with only the fields up to the found index
    Data.Info = rmfield(Data.Info, fieldNames(idx+1:end));

    if ~isempty(TempEventChannelNames)
        Data.Info.EventChannelNames = TempEventChannelNames;
        Data.Info.EventChannelType = TempEventChannelType;
    end

    if ~isempty(TempPreproInfoType)
        Data.Info.EventRelatedPreprocessing = TempPreproInfoType;
    end

    if ~isempty(TempEventChannel)
        Data.Info.EventRelatedDataChannel = TempEventChannel;
        Data.Info.EventRelatedDataType = TempEventDataType;
        Data.Info.EventRelatedDataTimeRange = TempEventTimeRange;
    end

    if ~isempty(TempSpikeDetectionThreshold)
        Data.Info.SpikeDetectionThreshold = TempSpikeDetectionThreshold;
    end

    if ~isempty(TempKilosortScalingFactor)
        Data.Info.KilosortScalingFactor = TempKilosortScalingFactor;
    end

    if ~isempty(TempCutStart)
         Data.Info.CutStart = TempCutStart;
    end

    if ~isempty(TempCutStop)
        Data.Info.CutEnd = TempCutStop;
    end

    if ~isempty(TempChannelDeletion)
        Data.Info.ChannelDeletion = TempChannelDeletion;
    end

    if ~isempty(TempSpike2EventChannelToTake)
        Data.Info.Spike2EventChannelToTake = TempSpike2EventChannelToTake;
    end

    if ~isempty(TempSpikeSorting)
        Data.Info.SpikeSorting = TempSpikeSorting;
    end
    
    if ~isempty(TempSpikeDetectionNrStd)
        Data.Info.SpikeDetectionNrStd = TempSpikeDetectionNrStd;
    end

    Data.Info.SpikeType = TempSpikeType;

    if isfield(Data,'Preprocessed')
        fieldsToDelete = {'Preprocessed'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

    if isfield(Data.Info,'EventRelatedDataType')
        if strcmp(Data.Info.EventRelatedDataType,"Preprocessed")
            msgbox("Event related data is based on preprocessed data and will be deleted");
            if isfield(Data,'EventRelatedData')
                fieldsToDelete = {'EventRelatedData'};
                % Delete fields
                Data = rmfield(Data, fieldsToDelete);
                fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
                Data.Info = rmfield(Data.Info, fieldsToDelete);
            end
            if isfield(Data,'PreprocessedEventRelatedData')
                fieldsToDelete = {'PreprocessedEventRelatedData'};
                % Delete fields
                Data = rmfield(Data, fieldsToDelete);
                
                if isfield(Data.Info,'EventRelatedPreprocessing')
                    fieldsToDelete = {'EventRelatedPreprocessing'};
                    % Delete fields
                    Data.Info = rmfield(Data.Info, fieldsToDelete);
                end

            end
        end
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