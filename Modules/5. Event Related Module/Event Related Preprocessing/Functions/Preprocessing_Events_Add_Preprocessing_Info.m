function [Data,Error] = Preprocessing_Events_Add_Preprocessing_Info(Data,EventRelatedPreprocessingType,ChannelSelection,TrialSelection,EventChannelName)

%________________________________________________________________________________________
%% Function to take preprocessing options for event related data and save them in Data.Info
% This function populates main window Data.Info field 
% Gets called after preprocessing step was applied to dataset

% Note:  Data.Info fields with event prepro info is NOT overwritten. Instead it takes the old
% fields and adds new parameter to it.

% Inputs: 
% 1.Data: Main Window data structure with the info field.
% 2. EventRelatedPreprocessingType: char, type of preprocessing applied;
% Options: 'Artefact Rejection' OR 'Channel Rejection' OR 'Trial Rejection'
% 3. ChannelSelection: 1 x 2 double for which channel preprocessiing step was applied
% i.e. [1,10] for channel 1 to 10; in GUI:all channel
% 4. TrialSelection: 1 x n double vector with trial indicies to delete
% 5. EventChannelName: char, name of the event channel for which
% preprocessing was applied

% Outputs:
% 1.Data: Main Window data structure with the info field.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

Error = 0;
% -----------------------------------------------------
%% ------------ Add Channel Rejection Info ------------
% -----------------------------------------------------

if strcmp(EventRelatedPreprocessingType,'Channel Rejection')
    %% ------------ Add Info that channel rejection was done ------------
    if isfield(Data.Info,'EventRelatedPreprocessing') % new if not existent
        if isfield(Data.Info.EventRelatedPreprocessing,'ChannelRejectionChannel')%add if already existent
            Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = strcat(Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType,",Channel Rejection");
            Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel = [Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel,ChannelSelection];
            repeatedEventChannelName = strjoin(repmat({EventChannelName}, 1, length(ChannelSelection)), ',');
            Data.Info.EventRelatedPreprocessing.ChannelRejectionEventChannelNames = strcat(Data.Info.EventRelatedPreprocessing.ChannelRejectionEventChannelNames,',',repeatedEventChannelName);
        else % new if not existent
            Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = "Channel Rejection";
            Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel = ChannelSelection;
            repeatedEventChannelName = strjoin(repmat({EventChannelName}, 1, length(ChannelSelection)), ',');
            Data.Info.EventRelatedPreprocessing.ChannelRejectionEventChannelNames = repeatedEventChannelName;
        end
        %% ------------ trials affected by channel rejection ------------
        if isfield(Data.Info.EventRelatedPreprocessing,'ChannelRejectionTrials')%add if already existent
            Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials = [Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials,TrialSelection];
        else % new if not existent
            Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials = TrialSelection;
        end
    else
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = "Channel Rejection";
        Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel = ChannelSelection;
        repeatedEventChannelName = strjoin(repmat({EventChannelName}, 1, length(ChannelSelection)), ',');
        Data.Info.EventRelatedPreprocessing.ChannelRejectionEventChannelNames = repeatedEventChannelName;
        %% ------------ trials affected by channel rejection ------------
        if isfield(Data.Info.EventRelatedPreprocessing,'ChannelRejectionTrials')%add if already existent
            Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials = [Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials,TrialSelection];
        else % new if not existent
            Data.Info.EventRelatedPreprocessing.ChannelRejectionTrials = TrialSelection;
        end
    end

% ---------------------------------------------------
%% ------------ Add Trial Rejection Info ------------
% ---------------------------------------------------

elseif strcmp(EventRelatedPreprocessingType,'Trial Rejection')
    %% ------------ Check if Trials to be rejected are within trialrange of dataset ------------
    % if ~isempty(TrialSelection) 
    %     AlreadyRejectedTrials = [];
    %     if isfield(Data.Info,'EventRelatedPreprocessing')
    %         if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials')
    %             %Find rejection indices for the currently selected event channel
    %             Namevector = split(string(Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames), ',');
    %             TrialrejectionindiciesCurrentChannel = find(Namevector == EventChannelName);
    %             %Select trials if event channel found
    %             if ~isempty(TrialrejectionindiciesCurrentChannel)
    %                 AlreadyRejectedTrials = Data.Info.EventRelatedPreprocessing.TrialRejectionTrials(TrialrejectionindiciesCurrentChannel);
    %             else
    %                 AlreadyRejectedTrials = [];
    %             end
    %         end
    %     end
    % 
    %     % check if trials where already deleted
    %     if ~isempty(AlreadyRejectedTrials)
    %         %% Now change currently selected channel in true channel idenetites based on already rejected trials
    %         if ~isempty(intersect(AlreadyRejectedTrials, TrialSelection))
    %             msgbox(strcat("Error: Trial(s) number ",num2str(intersect(AlreadyRejectedTrials, TrialSelection))," where already deleted! Returning"));
    %             Error = 1;
    %             return;
    %         end
    %     end
    % end


    %% ------------ Add Info that trial rejection was done ------------
    if ~isfield(Data.Info,'EventRelatedPreprocessing') % new if not existent
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = "Trial Rejection"; 
    else %add if already existent
        Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType = strcat(Data.Info.EventRelatedPreprocessing.EventRelatedPreprocessingType,",Trial Rejection");
    end
    %% ------------ channel affected by channel rejection ------------
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionChannel')  %add if already existent
        Data.Info.EventRelatedPreprocessing.TrialRejectionChannel = [Data.Info.EventRelatedPreprocessing.TrialRejectionChannel,ChannelSelection];
    else % new if not existent
        Data.Info.EventRelatedPreprocessing.TrialRejectionChannel = ChannelSelection;
    end
    %% ------------ trials affected by channel rejection ------------
    % one to one mapping between trials rejected and event channel names
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials') % add if already existent
        % newly delted trials are not in indice space of orignal
        % eventrelated data. So indices have to be converted.
        %for example first deleteion: trial 10. Then open again, user can
        %again select trial 10. But now this correspinds to trial 11 in the
        %orignal trial space
        [NewTrialsToDelete] = Preprocessing_Events_Get_Original_Trial_Indice(TrialSelection,Data.Info.EventRelatedPreprocessing.TrialRejectionTrials);

        Data.Info.EventRelatedPreprocessing.TrialRejectionTrials = [Data.Info.EventRelatedPreprocessing.TrialRejectionTrials,NewTrialsToDelete];
        repeatedEventChannelName = strjoin(repmat({EventChannelName}, 1, length(TrialSelection)), ',');
        Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames = strcat(Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames,',',repeatedEventChannelName);
    else % new if not existent
        repeatedEventChannelName = strjoin(repmat({EventChannelName}, 1, length(TrialSelection)), ',');
        Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames = repeatedEventChannelName;
        Data.Info.EventRelatedPreprocessing.TrialRejectionTrials = TrialSelection;
    end
end