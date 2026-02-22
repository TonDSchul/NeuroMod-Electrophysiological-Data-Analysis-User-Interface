function Data = Spike_Module_Get_Spike_Channel_Max_Template(Data,Sorter)

%________________________________________________________________________________________
%% Function to determine the data channel within the channel x times matrix each spike position in um corresponds to 
% One of two ways to determine spike positions for use with the actual data
% matrix and plotting spikedepth in the main window / analysis windows
% For each spike in a cluster, the max template channel becomes the data
% matrix channel for each spike

% other method: channel coordinate closest to spike x and y position, see Spike_Module_Get_Spike_Channel

% Input Arguments:
% 1. Data: Main window data struc
% 2. Sorter: char, sorter used, since Kilosort max templates are zero
% indexed (not from spikeinterface since its manually created in the sorting script)

% Output Arguments:
% 1. Data: Main window data struc with modified Data.Spikes.SpikeChannel 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%______________________________________________________________________________________

Clus = unique(Data.Spikes.SpikeCluster);

Data.Spikes.SpikeChannel = zeros(size(Data.Spikes.SpikeTimes));

for i = 1:length(Clus)
    AllSpikesCluster = Data.Spikes.SpikeCluster == Clus(i);
    
    if ~isempty(AllSpikesCluster)
        if strcmp(Sorter,"Kilosort")
            Data.Spikes.SpikeChannel(AllSpikesCluster) = Data.Info.ProbeInfo.ActiveChannel(double(Data.Spikes.Cluster_Max_Template_Channel(i))); % noz zero indexed
        else
            Data.Spikes.SpikeChannel(AllSpikesCluster) = Data.Info.ProbeInfo.ActiveChannel(double(Data.Spikes.Cluster_Max_Template_Channel(i)) + 1); % zero indexed
        end
    else
        warning(strcat("Clus ",num2str(NumClus(i))," contains no spikes."));
    end
end
