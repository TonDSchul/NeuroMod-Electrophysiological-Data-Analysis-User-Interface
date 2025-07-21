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

ActiveChannelDeletionIndice = zeros(size(Data.Info.ProbeInfo.ActiveChannel));

for i = 1:length(ChannelDeletion)
    if Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
        ActiveChannelDeletionIndice = ActiveChannelDeletionIndice + (flip(sort(Data.Info.ProbeInfo.ActiveChannel)) == ChannelDeletion(i));
    else
        ActiveChannelDeletionIndice = ActiveChannelDeletionIndice + (Data.Info.ProbeInfo.ActiveChannel == ChannelDeletion(i));
    end
end

ChannelDeletion = find(ActiveChannelDeletionIndice==1);

%% Delete Continous Data points
if isfield(Data,'Preprocessed')
    if ~isempty(Data.Preprocessed)
        Data.Preprocessed(ChannelDeletion,:) = [];
    end
end

if isfield(Data,'Raw')
    Data.Raw(ChannelDeletion,:) = [];
end

%% Delete Event related data channel
if isfield(Data,'EventRelatedData')
    Data.EventRelatedData(ChannelDeletion,:,:) = [];
end

if isfield(Data,'PreprocessedEventRelatedData')
    Data.PreprocessedEventRelatedData(ChannelDeletion,:,:) = [];
end

if isfield(Data.Info,'EventRelatedActiveChannel')
    Data.Info.EventRelatedActiveChannel(ChannelDeletion) = [];
end

Data.Info.Channelorder(ChannelDeletion) = [];

Data.Info.ProbeInfo.ActiveChannel(ChannelDeletion) = [];

msg = sprintf('Deleting Channel... (%d%% done)', round(100*(2/4)));
waitbar(2/4, h, msg);

%% Delete Spike indicies
if isfield(Data,'Spikes')
    msgbox("Warning: Spike data is deleted since the channelconfiguration changed");
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Spikes");
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


