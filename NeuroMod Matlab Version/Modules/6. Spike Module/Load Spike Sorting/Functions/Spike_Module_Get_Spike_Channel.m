function Data = Spike_Module_Get_Spike_Channel(Data,SpikePositions)

%% Get Channel number corresponding to depth in um
if str2double(Data.Info.ProbeInfo.NrRows) == 1
    SpikePositions = SpikePositions./Data.Info.ChannelSpacing;
    Data.Spikes.SpikeChannel = round(SpikePositions)+1;
    
    % now some channel can be wrongly assigned when right at the border between
    % two channel --> spike channel can be NOT part of active channel (if there
    % is a gap in active channel) but is shifted by one
    NonExistent = ismember(Data.Spikes.SpikeChannel, Data.Info.ProbeInfo.ActiveChannel);
    % Get the spikes that are NOT in ActiveChannel
    ZeroIndex = find(NonExistent==0);
    
    for i = 1:length(ZeroIndex)
        CurrentChannel = Data.Spikes.SpikeChannel(ZeroIndex(i));
        
        % take nearest channel. If two nearest, take the smaller one (bc round() was used)
        [minDist, minIdx] = min(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel));
        
        % Handle ties: if multiple channels have same distance, pick the lower one
        nearestChannels = Data.Info.ProbeInfo.ActiveChannel(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel) == minDist);
        Data.Spikes.SpikeChannel(ZeroIndex(i)) = min(nearestChannels);  % pick lower one
    end
else %% Two channel rows
    %% Depth can be the sme. Therefore we need the x position as well
    %SpikePositionsX = Data.Spikes.SpikePositions(:,1);
    for i = 1:length(SpikePositions)
        % find closes y values (multiple)

        [~, minChanIdx] = min(Data.Preprocessed(:,Data.Spikes.SpikeTimes(i)));
        
        TrueChannel = Data.Info.ProbeInfo.ActiveChannel(minChanIdx);
        
        Data.Spikes.SpikeChannel(i) = TrueChannel;
    end

    % now some channel can be wrongly assigned when right at the border between
    % two channel --> spike channel can be NOT part of active channel (if there
    % is a gap in active channel) but is shifted by one
    NonExistent = ismember(Data.Spikes.SpikeChannel, Data.Info.ProbeInfo.ActiveChannel);
    % Get the spikes that are NOT in ActiveChannel
    ZeroIndex = find(NonExistent==0);
    
    for i = 1:length(ZeroIndex)
        CurrentChannel = Data.Spikes.SpikeChannel(ZeroIndex(i));
        
        % take nearest channel. If two nearest, take the smaller one (bc round() was used)
        [minDist, minIdx] = min(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel));
        
        % Handle ties: if multiple channels have same distance, pick the lower one
        nearestChannels = Data.Info.ProbeInfo.ActiveChannel(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel) == minDist);
        Data.Spikes.SpikeChannel(ZeroIndex(i)) = min(nearestChannels);  % pick lower one
    end 

end

if size(Data.Spikes.SpikeChannel,1)<size(Data.Spikes.SpikeChannel,2)
    Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel';
end