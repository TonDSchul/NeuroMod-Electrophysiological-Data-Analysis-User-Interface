function [Data] = Preprocess_Module_ChannelDeletion(Data,ChannelDeletion)
%________________________________________________________________________________________

%% Function to apply channel deletion to GUI data

% Input:
% 1. Data: Data structure containing raw and potentially preprocessed data as a Channel x Time matrix
% and Info structure with already applied preprocessing steps and other infos
% 2. ChannelDeletion: double array with channel to be deleted.

% Output: 
% 1. Data with modified fields. Channel get deleted for Raw and
% Preprocessed Data, Event Related Data and Spike Data from internal spike detection (thresholding). Spike Data from Kilosort is just deleted and
% has to be extracted again. Potential TO DO but a lot of work and the
% kilosort .dat file used for analysis is not based on the same channel anymore, so loading
% kilosort data has to be modified too. 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Delete Continous Data points
if isfield(Data,'Preprocessed')
    Data.Preprocessed(ChannelDeletion,:) = [];
end
if isfield(Data,'Raw')
    Data.Raw(ChannelDeletion,:) = [];
end
%% Delete Event related data points
if isfield(Data,'EventRelatedData')
    Data.EventRelatedData(ChannelDeletion,:,:) = [];
end

if isfield(Data,'PreprocessedEventRelatedData')
    Data.PreprocessedEventRelatedData(ChannelDeletion,:,:) = [];
end

%% Delete Spike indicies

if Data.Spikes.SpikePositions(1,2) == 1
    Data.Spikes.SpikePositions(:,2) = Data.Spikes.SpikePositions(:,2)*Data.Info.ChannelSpacing;
end

if isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
    if ~isempty(Data.Spikes.SpikeTimes)
        ChannelIndicies = zeros(length(Data.Spikes.SpikePositions(:,2)),1);
        Channeltodelete = ChannelDeletion*Data.Info.ChannelSpacing;

        for nchannel = 1:length(ChannelDeletion)
            TempChannelIndicies = Data.Spikes.SpikePositions(:,2) == Channeltodelete(nchannel);
            ChannelIndicies = ChannelIndicies+TempChannelIndicies;
            ChannelIndicies(ChannelIndicies>1) = 1;
        end

        if sum(ChannelIndicies) == length(Data.Spikes.SpikeTimes)
            fieldsToDelete = {'Spikes'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
            if isfield(Data.Info,'SpikeDetectionThreshold')
                fieldsToDelete = {'SpikeDetectionThreshold'};
                % Delete fields
                Data.Info = rmfield(Data.Info, fieldsToDelete);
            end
            Data.Info.SpikeType = "Non";
            return;
        end

        Data.Spikes.SpikeTimes(ChannelIndicies==1) = [];
        Data.Spikes.SpikePositions(ChannelIndicies==1,:) = [];
        %Scale SpikePositions to Channel 1
        Data.Spikes.SpikePositions(:,2) = Data.Spikes.SpikePositions(:,2) - (length(Channeltodelete)*Data.Info.ChannelSpacing);
        Data.Spikes.SpikeAmps(ChannelIndicies==1) = [];
        Data.Spikes.SpikeChannel(ChannelIndicies==1) = [];
        Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel - length(Channeltodelete);
        if Channeltodelete(1) == 1*Data.Info.ChannelSpacing
            Data.Spikes.ChannelMap(1:Channeltodelete(end)/Data.Info.ChannelSpacing) = [];
            Data.Spikes.ChannelMap = Data.Spikes.ChannelMap-(Channeltodelete(end)/Data.Info.ChannelSpacing);

            Data.Spikes.ChannelPosition(1:Channeltodelete(end)/Data.Info.ChannelSpacing,:) = [];
            Data.Spikes.ChannelPosition(:,2) = Data.Spikes.ChannelPosition(:,2)-Channeltodelete(end);
        else
            Data.Spikes.ChannelMap(Channeltodelete(1)/Data.Info.ChannelSpacing:end) = [];
            Data.Spikes.ChannelPosition(Channeltodelete(1)/Data.Info.ChannelSpacing:end) = [];
        end
    end

elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Kilosort")
        msgbox("Warning: Loaded Kilosort spikes have to be deleted since the channelconfiguration changed. Please save data again for Kilosort and laod the new Kilosort output.");
        Data.Info.SpikeType = "Non";
        fieldsToDelete = {'Spikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        if isfield(Data,'EventRelatedSpikes')
            fieldsToDelete = {'EventRelatedSpikes'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end
end

% NOTE: Nothing has to be done for EventRelatedSpikes, since evewnt related spikes are computed
% everytime, a spike analysis is selcted

% Adjust Info file
Data.Info.NrChannel = length(Data.Raw);



