function Data = Spike_Module_Get_Spike_Channel(Data)

%% Get Channel number corresponding to depth in um
if str2double(Data.Info.ProbeInfo.NrRows) == 1

    SpikePositions = (Data.Spikes.SpikePositions(:,2))./Data.Info.ChannelSpacing;
    Data.Spikes.SpikeChannel = round(SpikePositions)+1;
    
    % runs through always when testes, follwoing not needed just there as
    % failsave .. if found channel not part of activechannel bc right at
    % the border to an inactive
    NonExistent = ismember(Data.Spikes.SpikeChannel, Data.Info.ProbeInfo.ActiveChannel);
    % Get the spikes that are NOT in ActiveChannel
    ZeroIndex = find(NonExistent==0);
    
    for i = 1:length(ZeroIndex)
        CurrentChannel = Data.Spikes.SpikeChannel(ZeroIndex(i));
        
        % take nearest channel. If two nearest, take the smaller one
        [minDist, minIdx] = min(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel));
        
        %if multiple have same distance, pick the lower one
        nearestChannels = Data.Info.ProbeInfo.ActiveChannel(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel) == minDist);
        Data.Spikes.SpikeChannel(ZeroIndex(i)) = min(nearestChannels);  % pick lower one
    end
else %% Two or more channel rows
        %% Depth can be the smae. Therefore we need the x position as well
    
    for i = 1:length(Data.Spikes.SpikePositions(:,2))
        % find closes y values (multiple)
        distances = abs(Data.Info.ProbeInfo.ycoords - Data.Spikes.SpikePositions(i,2));
        minDist = min(distances);
        % indice of all channel matching depth -- two if same channel
        % depths for both rows
        Yidx = find(distances == minDist);
        
        % find closest x value (only one)

        [~, Xidx] = min(abs(Data.Info.ProbeInfo.xcoords(Yidx) - Data.Spikes.SpikePositions(i,1))); 
        
        Data.Spikes.SpikeChannel(i) = Yidx(round(Xidx));
    end
    
    % runs through always when testes, follwoing not needed just there as
    % failsave .. if found channel not part of activechannel bc right at
    % the border to an inactive
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