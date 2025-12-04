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

[StartDepth,StopDepth,FakeChannelRange,FakeYpositions] = Spike_Module_Analysis_Determine_Depths(Data,1,Data.Info.ProbeInfo.ActiveChannel);
        
% FakeChannelRange = 1:str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows);
% FakeYpositions = (FakeChannelRange-1)*Data.Info.ProbeInfo.FakeSpacing;

FakeDepths = NaN(size(Data.Spikes.SpikeTimes));

for i = 1:length(Data.Spikes.SpikeChannel)
    CurrentIntegerY = Data.Info.ProbeInfo.ycoords(Data.Spikes.SpikeChannel(i));
    RestaroundInteger = Data.Spikes.SpikePositions(i,2)-CurrentIntegerY;
    FakeDepths(i) = FakeYpositions(Data.Spikes.SpikeChannel(i)) + RestaroundInteger;
end

Data.Spikes.DataCorrectedSpikePositions = zeros(size(Data.Spikes.SpikePositions));
Data.Spikes.DataCorrectedSpikePositions(:,2) = FakeDepths;
Data.Spikes.DataCorrectedSpikePositions(:,1) = Data.Spikes.SpikePositions(:,1);


% FakeChannelRange = 1:str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows);
% FakeYpositions = (FakeChannelRange-1)*Data.Info.ProbeInfo.FakeSpacing;
% 
% FakeDepths = NaN(size(Data.Spikes.SpikeTimes));
% Data.Spikes.DataCorrectedSpikePositions = zeros(size(Data.Spikes.SpikePositions));
% 
% for i = 1:size(Data.Spikes.SpikePositions,1)
%     ChannelIndex = Data.Spikes.SpikePositions(i,2) >= Data.Spikes.ChannelPosition(:,2)-Data.Info.ProbeInfo.FakeSpacing/2 & Data.Spikes.SpikePositions(i,2) < Data.Spikes.ChannelPosition(:,2) + Data.Info.ProbeInfo.FakeSpacing/2; 
% 
%     YBasedChannel = FakeChannelRange(ChannelIndex);
%     if sum(ChannelIndex)>1
%         disp("aha")
%     end
% 
%     ChannelForCurrentSpike = YBasedChannel;
%     TargetDepth = (ChannelForCurrentSpike-1)*Data.Info.ProbeInfo.FakeSpacing;
%     Residual = Data.Spikes.SpikePositions(i,2)-Data.Spikes.ChannelPosition(YBasedChannel,2);
% 
%     Data.Spikes.DataCorrectedSpikePositions(i,2) = TargetDepth - double(Residual);
% 
%     FakeDepths(i) = YBasedChannel;
% end
% Data.Spikes.DataCorrectedSpikePositions(:,1) = Data.Spikes.SpikePositions(:,1);






























%% First assign a unique channel from 1 to 64 to each channel based on x and y coordinate
 
% else % 3 or more channel rows!
%     Data.Spikes.DataCorrectedSpikePositions = Data.Spikes.SpikePositions;
% 
%     FakeChannel = NaN(size(Data.Spikes.SpikeTimes));
% 
%     AllChannel = 1:size(Data.Spikes.ChannelPosition,1);
% 
%     for i = 1:size(Data.Spikes.SpikePositions,1)
% 
%         ChannelIndex = Data.Spikes.SpikePositions(i,2) >= Data.Spikes.ChannelPosition(:,2)-Data.Info.ChannelSpacing/2 & Data.Spikes.SpikePositions(i,2) < Data.Spikes.ChannelPosition(:,2) + Data.Info.ChannelSpacing/2; 
% 
%         YBasedChannel = AllChannel(ChannelIndex);
% 
%         RespectiveXPositions = Data.Spikes.ChannelPosition(ChannelIndex,1);
% 
%         HalfChannelDist = HorOffset/2;
% 
%         RespectiveXChannel = [];
%         for uu = 1:length(RespectiveXPositions)
%             if Data.Spikes.SpikePositions(i,1) >= RespectiveXPositions(uu)-HalfChannelDist && Data.Spikes.SpikePositions(i,1) < RespectiveXPositions(uu)+HalfChannelDist
%                RespectiveXChannel = [RespectiveXChannel,uu];
%             end
%             if Data.Spikes.SpikePositions(i,1) > RespectiveXPositions(end)
%                 RespectiveXChannel = [RespectiveXChannel,length(RespectiveXPositions)];
%             end
%         end
%         % Can be within two channel ranges --> just take the one with
%         % smallest distance to actual channel location
%         if length(RespectiveXChannel)>1
%             Xtocheck = RespectiveXPositions(RespectiveXChannel);
%             [a,SmallestDistanceIndex] = min(abs(Xtocheck-Data.Spikes.SpikePositions(i,1)));
%             RespectiveXChannel = RespectiveXChannel(SmallestDistanceIndex);
%         end
% 
%         ChannelForCurrentSpike = YBasedChannel(RespectiveXChannel);
%         TargetDepth = (ChannelForCurrentSpike-1)*Data.Info.ChannelSpacing;
%         Residual = Data.Spikes.SpikePositions(i,2)-Data.Spikes.ChannelPosition(YBasedChannel(RespectiveXChannel),2);
% 
%         Data.Spikes.DataCorrectedSpikePositions(i,2) = TargetDepth - double(Residual);
% 
%         FakeChannel(i) = YBasedChannel(RespectiveXChannel);
%     end
% end
% %% Now create fake spikepositions field with adjusted positions spanning from 0 to NrChannel * 2 
% % ch 1 + 0 um
% % ch 2 + 20um
% % ch 3 + 20 um
% % ch 4 + 40um
% % ch 5 + 40 um
% % ch 6 + 60 um
% % ch 7 + 60 um
% % ch 8 + 80 um
% % ch 9 + 80 um
% % ch 10 + 100um .....
% 
% if str2double(Data.Info.ProbeInfo.NrRows) <=2 
% 
%     %create that vector
% 
%     n = size(Data.Spikes.ChannelPosition,1); % Number of elements in the vector
%     step = Data.Info.ChannelSpacing; % Step size
% 
%     % Generate the vector
%     result = [0, repelem(step:step:step*(ceil((n-1)/2)), 2)];
%     result = result(1:n); % Trim to exactly n elements
% 
%     if strcmp(Data.Info.Sorter,'External Kilosort GUI') && str2double(Data.Info.ProbeInfo.NrRows) == 1 && Data.Info.ProbeInfo.OffSetRows == 1 
%            for nchannel = 1:n
%                SpikeCurrentChannel = FakeChannel == nchannel;
%                Data.Spikes.DataCorrectedSpikePositions(SpikeCurrentChannel,2) = Data.Spikes.SpikePositions(SpikeCurrentChannel,2);
%             end
%     else
%         for nchannel = 1:n
%            SpikeCurrentChannel = FakeChannel == nchannel;
%            Data.Spikes.DataCorrectedSpikePositions(SpikeCurrentChannel,2) = Data.Spikes.SpikePositions(SpikeCurrentChannel,2) + result(nchannel);
%         end
%     end
% end



