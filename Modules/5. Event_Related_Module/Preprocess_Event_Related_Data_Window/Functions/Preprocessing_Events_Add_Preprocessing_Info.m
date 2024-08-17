function [Data] = Preprocessing_Events_Add_Preprocessing_Info(Data,EventRelatedPreprocessingType,ChannelSelection,TrialSelection,TimeRangeArtefact)

%________________________________________________________________________________________
%% Function to take preprocessing options for event related data and save them in Data.Info
% This function populates main window Data.Info field 
% Gets called after preprocessing step was applied to dataset

% Note: Since preprocessing was already applied when this function is called, the Data.Info structure 
% already contains the specific kind of preprocessing applied as
% Data.Info.EventRelatedPreprocessing (as char)
% It can contain following options: 'TrialRejectionChannel' OR
% 'ChannelRejectionTrials' OR 'ArtefactRejectionChannel' OR
% 'ArtefactRejectionTrials' OR 'ArtefactRejectionTimeRange'. It is important here because
% prepro steps can be applied multiple times. Therefore Data.Info
% fields with event prepro info is NOT overwritten. Instead it takes the old
% fields and adds new parameter to it.

% Inputs: 
% 1.Data: Main Window data structure with the info field.
% 2. EventRelatedPreprocessingType: char, type of preprocessing applied;
% Options: 'Artefact Rejection' OR 'Channel Rejection' OR 'Trial Rejection'
% 3. ChannelSelection: 1 x 2 double for which channel preprocessiing step was applied
% i.e. [1,10] for channel 1 to 10
% 4. TrialSelection: 1 x 2 double for which events preprocessiing step was applied
% i.e. [1,10] for events 1 to 10
% 5. TimeRangeArtefact: 1 x 2 double capturing the stop and start time of
% the artefact rejection step if applied
% i.e. [1,10] for events 1 to 10

% Outputs:
% 1.Data: Main Window data structure with the info field.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if strcmp(EventRelatedPreprocessingType,'Artefact Rejection')
    if ~isfield(Data.Info,'EventRelatedPreprocessing')
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = "Artefact Rejection";
    else
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = strcat(Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType,",Artefact Rejection");
    end
    if isfield(Data.Info.EventRelatedPreprocessing,'ArtefactRejectionChannel')
        Data.Info.EventRelatedPreprocessing.ArtefactRejectionChannel = [Data.Info.EventRelatedPreprocessing.ArtefactRejectionChannel,ChannelSelection];
    else
        Data.Info.EventRelatedPreprocessing.ArtefactRejectionChannel = ChannelSelection;
    end
    if isfield(Data.Info.EventRelatedPreprocessing,'ArtefactRejectionTrials')
        Data.Info.EventRelatedPreprocessing.ArtefactRejectionTrials = [Data.Info.EventRelatedPreprocessing.ArtefactRejectionTrials,TrialSelection];
    else
        Data.Info.EventRelatedPreprocessing.ArtefactRejectionTrials = TrialSelection;
    end

    if isfield(Data.Info.EventRelatedPreprocessing,'ArtefactRejectionTimeRange')
        Data.Info.EventRelatedPreprocessing.ArtefactRejectionTimeRange = [Data.Info.EventRelatedPreprocessing.ArtefactRejectionTimeRange,TimeRangeArtefact];
    else
        Data.Info.EventRelatedPreprocessing.ArtefactRejectionTimeRange = TimeRangeArtefact;
    end
elseif strcmp(EventRelatedPreprocessingType,'Channel Rejection')
    if ~isfield(Data.Info,'EventRelatedPreprocessing')
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = "Channel Rejection";
    else
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = strcat(Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType,",Channel Rejection");
    end
    if isfield(Data.Info.EventRelatedPreprocessing,'ChannelRejectionChannel')
        Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel = [Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel,ChannelSelection];
    else
        Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel = ChannelSelection;
    end
    if isfield(Data.Info.EventRelatedPreprocessing,'ChannelRejectionTrials')
        Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials = [Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials,TrialSelection];
    else
        Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials = TrialSelection;
    end
elseif strcmp(EventRelatedPreprocessingType,'Trial Rejection')
    if ~isfield(Data.Info,'EventRelatedPreprocessing')
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = "Trial Rejection";
    else
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = strcat(Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType,",Trial Rejection");
    end
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionChannel')
        Data.Info.EventRelatedPreprocessing.TrialRejectionChannel = [Data.Info.EventRelatedPreprocessing.TrialRejectionChannel,ChannelSelection];
    else
        Data.Info.EventRelatedPreprocessing.TrialRejectionChannel = ChannelSelection;
    end
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials')
        Data.Info.EventRelatedPreprocessing.TrialRejectionTrials = [Data.Info.EventRelatedPreprocessing.TrialRejectionTrials,TrialSelection];
    else
        Data.Info.EventRelatedPreprocessing.TrialRejectionTrials = TrialSelection;
    end

end