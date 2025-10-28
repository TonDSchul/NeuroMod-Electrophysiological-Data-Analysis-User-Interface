function [Data,Info,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,Info,PreprocessingSteps,ChannelDeletion,TextArea)
%________________________________________________________________________________________

%% function that deletes all fields of the structure app.Data.Info that correspond to preprocessing that was already applied.

% If user executes new preprocessing, old Data.Preprocessing structure
% gets overwritten. All variables and fields of the Data.Info field that
% correspond to the old preprocessing have to be deleted accordingly

% Input:
% 1. Data: Data structure holding Raw, Preprocessed data and Info structure
% 2. Info: Info structure from preprocessing GUI, NOT the info from the
% variable above!! It holds all infos about the currently selected
% preprocessing steps
% 3. PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 4. ChannelDeletion: double array of channels to be deleted
% 5. TextArea: app object of textarea to show info. Can be empty variable
% when execute outside of GUI

% Outputs:
% 1. Data: Data structure holding Raw, Preprocessed data and Info structure
% 2. Info: currently added prepro infos of all components part of the
% pipeline
% 3. TextArea: content of textarea field in prepro window in case warning
% has to be displayed (line 61) 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Handle Channel Deletion and Time deletion: Independent of other
% preprocessing, therefore no settings get deleted
Delete_old_settings = 1;

nrindependentsteps = 0;

%% When Prepro only consists of Cut time or delete channel, other prepro info doesnt have to be deleted since they can be executed independent of other prepro steps
for i = 1:length(PreprocessingSteps)
    if strcmp(PreprocessingSteps(i),'CutStart')
        nrindependentsteps = nrindependentsteps+1;
    end
    if strcmp(PreprocessingSteps(i),'CutEnd')
        nrindependentsteps = nrindependentsteps+1;
    end
    if strcmp(PreprocessingSteps(i),'ChannelDeletion')
        nrindependentsteps = nrindependentsteps+1;
    end
end

if nrindependentsteps ~= 0 && nrindependentsteps==numel(PreprocessingSteps)
    Delete_old_settings = 0;
end

%% Delete field of old prepro info
if isfield(Data, 'Preprocessed') && Delete_old_settings == 1

    if ~isempty(Data.Preprocessed)
        msgbox("Warning! Data was already preprocessed. Existing preprocessed data will be overwritten if pipeline is started!");
        TextArea.Value = "Warning! Data was already preprocessed. Existing preprocessed data will be overwritten if pipeline is started!";
        pause(0.1);

        if ~isempty(Data.Preprocessed)
            if ~strcmp(PreprocessingSteps(1),"ChannelDeletion")
                Data.Preprocessed = [];
            end  
        else
            fieldsToDelete = {'Preprocessed'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end
    end

    if isfield(Data,'TimeDownsampled')
        % Fields to delete
        fieldsToDelete = {'TimeDownsampled'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
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
    if isfield(Data.Info,'NarrowbandFilterMethod')
        % Fields to delete
        fieldsToDelete = {'NarrowbandFilterMethod','NarrowbandFilterType','NarrowbandFilterDirection','NarrowbandCutoff','NarrowbandFilterOrder'};
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
        fields = {'ASRLineNoiseC','ASRHPTransitions','ASRBurstC','WindowC','ASR'};
        Data.Info = rmfield(Data.Info,fields);
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
        fieldsToDelete = {'StimArtefactChannel','TimeAroundStimArtefact','ArtefactRejectedTrigger'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
end

%% Handle Channel Deletion and Cut start and end
for i = 1:length(PreprocessingSteps)
    if strcmp(PreprocessingSteps(i),"ChannelDeletion")
        if isfield(Data.Info,'ChannelDeletion')
            Data.Info.ChannelDeletion = [Data.Info.ChannelDeletion,ChannelDeletion];
        else
            Data.Info.ChannelDeletion = ChannelDeletion;
        end
    end

    if strcmp(PreprocessingSteps(i),"CutStart")
        if isfield(Data.Info,'CutStart')
            Data.Info.CutStart = [Data.Info.CutStart,Info.CutStart];
        else
            Data.Info.CutStart = Info.CutStart;
        end
    end

    if strcmp(PreprocessingSteps(i),"CutEnd")
        if isfield(Data.Info,'CutEnd')
            Data.Info.CutEnd = [Data.Info.CutEnd,Info.CutEnd];
        else
            Data.Info.CutEnd = Info.CutEnd;
        end
    end

end
