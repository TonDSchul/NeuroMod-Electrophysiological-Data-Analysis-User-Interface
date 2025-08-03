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
% 1. Data: main window data structure
% 2. Error: 1 if no data would be left after deleting, 0 if otherwise; If 1,
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

    if isfield(Data.Info,'Sorter')
        fieldsToDelete = {'Sorter'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'SpikeDetectionNrStd')
        fieldsToDelete = {'SpikeDetectionNrStd'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    Data.Info.SpikeType = "Non";
    
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
    
    if isfield(Data.Info,'EventRelatedPreprocessing')
        fieldsToDelete = {'EventRelatedPreprocessing'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'EventRelatedDataInfo')
        fieldsToDelete = {'EventRelatedDataInfo'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

elseif strcmp(ComponentToDelete,"Events")
    
    if isfield(Data,'Events')
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

    if isfield(Data.Info,'EventChannelType')
        fieldsToDelete = {'EventChannelType', 'EventChannelNames'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

    if isfield(Data,'EventRelatedData')
        fieldsToDelete = {'EventRelatedData'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
       
        fieldsToDelete = {'EventRelatedDataTimeRange','EventRelatedActiveChannel'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data,'PreprocessedEventRelatedData')
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'EventRelatedPreprocessing'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'EventRelatedPreprocessing')
        fieldsToDelete = {'EventRelatedPreprocessing'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'EventRelatedDataInfo')
        fieldsToDelete = {'EventRelatedDataInfo'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'NeoEventStartTimeStamp')
        fieldsToDelete = {'NeoEventStartTimeStamp'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

elseif strcmp(ComponentToDelete,"Preprocessed")

    %% If just Raw Data saved: Delete preprocessing infos from Data.Info structure.
    % They all come after the field "ChannelOrder
    % Find the index of the specific field
    if isfield(Data.Info,'DownsampleFactor')
        fieldsToDelete = {'TimeDownsampled'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);

        fieldsToDelete = {'DownsampleFactor','DownsampledSampleRate'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data,'TimeDownsampled')
        % Fields to delete
        fieldsToDelete = {'TimeDownsampled'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
    if isfield(Data.Info,'NarrowbandFilterMethod')
        % Fields to delete
        fieldsToDelete = {'NarrowbandFilterMethod','NarrowbandFilterType','NarrowbandFilterDirection','NarrowbandCutoff','NarrowbandFilterOrder'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'Resample')
        % Fields to delete
        fieldsToDelete = {'Resample','ResamplingFrequency'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'FilterMethod')
        % Fields to delete
        fieldsToDelete = {'Cutoff', 'FilterOrder', 'FilterMethod', 'FilterType', 'FilterDirection'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'MedianFilterMethod')
        % Fields to delete
        fieldsToDelete = {'MedianFilterOrder', 'MedianFilterMethod'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'BandStopFilterMethod')
        % Fields to delete
        fieldsToDelete = {'BandStopCutoff', 'BandStopFilterOrder', 'BandStopFilterMethod', 'BandStopFilterType', 'BandStopFilterDirection'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'DownsampleFactor')
        fieldsToDeleteInfo = {'DownsampleFactor','DownsampledSampleRate'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDeleteInfo);
    end
    if isfield(Data.Info,'ASR')
        fieldsToDeleteInfo = {'ASRLineNoiseC','ASRHPTransitions','ASRBurstC','WindowC','ASR'};
        Data.Info = rmfield(Data.Info,fieldsToDeleteInfo);
    end
    if isfield(Data.Info,'Normalize')
        fieldsToDelete = {'Normalize'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'GrandAverage')
        fieldsToDelete = {'GrandAverage'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'StimArtefactChannel')
        fieldsToDelete = {'StimArtefactChannel','TimeAroundStimArtefact'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
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

        Data.Info.EventRelatedActiveChannel = Data.Info.ProbeInfo.ActiveChannel;

    end

    if isfield(Data.Info,'EventRelatedPreprocessing')
        fieldsToDelete = {'EventRelatedPreprocessing'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

end