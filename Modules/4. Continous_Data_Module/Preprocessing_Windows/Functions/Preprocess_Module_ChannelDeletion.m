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

h = waitbar(0, 'Deleting Channel...', 'Name','Deleting Channel...');

msg = sprintf('Deleting Channel... (%d%% done)', round(100*(1/5)));
waitbar(1/4, h, msg);

%% Delete Continous Data points
if isfield(Data,'Preprocessed')
    if ~isempty(Data.Preprocessed)
        Data.Preprocessed(ChannelDeletion,:) = [];
    end
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

Data.Info.Channelorder(ChannelDeletion) = [];

Data.Info.ProbeInfo.ActiveChannel(ChannelDeletion) = [];
Data.Info.ProbeInfo.NrChannel = num2str(size(Data.Raw,1));

msg = sprintf('Deleting Channel... (%d%% done)', round(100*(2/4)));
waitbar(2/4, h, msg);

%% Delete Spike indicies
% if strcmp(Data.Info.SpikeType,"Internal")
% 
% else
%     if Data.Spikes.SpikePositions(1,2) == 1
%         Data.Spikes.SpikePositions(:,2) = Data.Spikes.SpikePositions(:,2)*Data.Info.ChannelSpacing;
%     end
% end

if isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
    if ~isempty(Data.Spikes.SpikeTimes)
        ChannelIndicies = zeros(length(Data.Spikes.SpikePositions(:,2)),1);

        for nchannel = 1:length(ChannelDeletion)
            TempChannelIndicies = Data.Spikes.SpikePositions(:,2) == ChannelDeletion(nchannel);
            ChannelIndicies = ChannelIndicies+TempChannelIndicies;
        end
        
        ChannelIndicies(ChannelIndicies>1) = 1;
        
        if sum(ChannelIndicies) == length(Data.Spikes.SpikeTimes)
            fieldsToDelete = {'Spikes'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
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

            Data.Info.SpikeType = "Non";
            msgbox("No spikes left after channel deletion. Spike data component is deleted!")
            return;
        end

        Data.Spikes.SpikeTimes(ChannelIndicies==1) = [];
        Data.Spikes.SpikePositions(ChannelIndicies==1,:) = [];
        if ~isempty(Data.Spikes.SpikeCluster)
            Data.Spikes.SpikeCluster(ChannelIndicies==1) = [];
        end
        %Scale SpikePositions to Channel 1
        if ChannelDeletion(1)==1
            Data.Spikes.SpikePositions(:,2) = Data.Spikes.SpikePositions(:,2) - length(ChannelDeletion);
        end

        Data.Spikes.SpikeAmps(ChannelIndicies==1) = [];
        Data.Spikes.SpikeChannel(ChannelIndicies==1) = [];
        if ChannelDeletion(1)==1
            Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel - length(ChannelDeletion);
        end
       
        if ChannelDeletion(1) == 1
            Data.Spikes.ChannelMap(1:ChannelDeletion(end)) = [];
            Data.Spikes.ChannelMap = Data.Spikes.ChannelMap-ChannelDeletion(end);

            Data.Spikes.ChannelPosition(1:ChannelDeletion(end),:) = [];
            Data.Spikes.ChannelPosition(:,2) = Data.Spikes.ChannelPosition(:,2)-ChannelDeletion(end);
        else
            Data.Spikes.ChannelMap(ChannelDeletion(1):end) = [];
            Data.Spikes.ChannelPosition(ChannelDeletion(1):end) = [];
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
end

msg = sprintf('Deleting Channel... (%d%% done)', round(100*(3/4)));
waitbar(3/4, h, msg);

% NOTE: Nothing has to be done for EventRelatedSpikes, since evewnt related spikes are computed
% everytime, a spike analysis is selcted

% Adjust Info file
Data.Info.NrChannel = size(Data.Raw,1);

msg = sprintf('Deleting Channel... (%d%% done)', round(100*(4/4)));
waitbar(4/4, h, msg);

close(h);


