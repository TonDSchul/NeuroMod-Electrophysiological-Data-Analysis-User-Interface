function [Data] = Spike_Module_Convert_Indicies_to_Data_Channel(Data)

%________________________________________________________________________________________

%% Function to convert spike positions for a probe design with 2 rows. This is becuase spike depths of the neighbouring channel are the same.
%% However, to display all channel in the GUI from top to bottom, spike depths have to be adjusted

% This basically just takes spikes from the second to the last channel and
% adds Channelspacing to them.
%For Channelspacing = 20um:
% Ch 0 +0um
% Ch 1 + 20um
% Ch 2 + 20um
% Ch 3 + 40um
% Ch 4 + 40um and so on....
% 
% Input:
% 1. Data = structure containing all data. 

% Output:
% 1. Data structure of toolbox with added field:
% Data.Spikes.DataCorrectedSpikePositions with adjusted spikepositions and
% Data.Spikes.SpikeChannel to save the corresponding spike channel indices
% used for adjustments

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


%% First assign a unique channel from 1 to 64 to each channel based on x and y coordinate

Data.Spikes.DataCorrectedSpikePositions = Data.Spikes.SpikePositions;

FakeChannel = NaN(size(Data.Spikes.SpikeTimes));

AllChannel = 1:size(Data.Spikes.ChannelPosition,1);

for i = 1:size(Data.Spikes.SpikePositions,1)

    ChannelIndex = Data.Spikes.SpikePositions(i,2) > Data.Spikes.ChannelPosition(:,2)-Data.Info.ChannelSpacing/2 & Data.Spikes.SpikePositions(i,2) < Data.Spikes.ChannelPosition(:,2) + Data.Info.ChannelSpacing/2; 
    
    YBasedChannel = AllChannel(ChannelIndex);

    if Data.Spikes.SpikePositions(i,1) < Data.Info.ProbeInfo.HorOffset/2 % left
        FakeChannel(i) = YBasedChannel(1);
    else % right
        FakeChannel(i) = YBasedChannel(2);
    end
end

%% Now create fake spikepositions field with adjusted positions spanning from 0 to NrChannel * 2 
% ch 1 + 0 um
% ch 2 + 20um
% ch 3 + 20 um
% ch 4 + 40um
% ch 5 + 40 um
% ch 6 + 60 um
% ch 7 + 60 um
% ch 8 + 80 um
% ch 9 + 80 um
% ch 10 + 100um .....

%create that vector

n = size(Data.Spikes.ChannelPosition,1); % Number of elements in the vector
step = Data.Info.ChannelSpacing; % Step size

% Generate the vector
result = [0, repelem(step:step:step*(ceil((n-1)/2)), 2)];
result = result(1:n); % Trim to exactly n elements

for nchannel = 1:n
   SpikeCurrentChannel = FakeChannel == nchannel;
   Data.Spikes.DataCorrectedSpikePositions(SpikeCurrentChannel,2) = Data.Spikes.SpikePositions(SpikeCurrentChannel,2) + result(nchannel);
end

Data.Spikes.SpikeChannel = FakeChannel;


