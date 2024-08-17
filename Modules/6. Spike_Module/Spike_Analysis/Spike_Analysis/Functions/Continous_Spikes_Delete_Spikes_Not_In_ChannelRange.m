function [SpikeTimes,SpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeTimes,SpikePositions,ChannelSpacing,Channel_Selection,SpikeType)

% If Internal spikes convert channelnr in um depth
if strcmp(SpikeType,'Internal')
    SpikePositions = SpikePositions.*ChannelSpacing;
    ChannelRange = (Channel_Selection(1):Channel_Selection(2))*ChannelSpacing;
end

if strcmp(SpikeType,'Kilosort')
    if Channel_Selection(1)~=Channel_Selection(2)
        ChannelRange = (Channel_Selection(1):Channel_Selection(2))*ChannelSpacing;
    else
        ChannelRange(1) = (Channel_Selection(1)*ChannelSpacing)-(ChannelSpacing/2);
        ChannelRange(2) = (Channel_Selection(2)*ChannelSpacing)+(ChannelSpacing/2);
    end
end
% SpikeIndicies within ChannelRange
SelectedChannelIndicies = SpikePositions >= ChannelRange(1) & SpikePositions <= ChannelRange(end);

% Delete All indicies outside of Channelrange
SpikeTimes = SpikeTimes(SelectedChannelIndicies==1);
SpikePositions = SpikePositions(SelectedChannelIndicies==1);

%If Channel 10 to 20: 10 has to have indicie 1 to be plotted
%correctly
if Channel_Selection(1) > 1
    SpikePositions = SpikePositions - (ChannelRange(1)-ChannelSpacing);
end