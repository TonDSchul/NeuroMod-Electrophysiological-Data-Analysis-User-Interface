function [Data] = Spike_Module_Convert_Indicies_to_Data_Channel(Data)

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


