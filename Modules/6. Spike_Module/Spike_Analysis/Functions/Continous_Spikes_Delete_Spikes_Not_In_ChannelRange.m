function [SpikeTimes,SpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeTimes,SpikePositions,ChannelSpacing,Channel_Selection,SpikeType)

%________________________________________________________________________________________
%% Function to take spike times and delete indicies outside of selected channel range

% This function is called whenever spike data is plotted to determine
% spikes in selcted channelrange/depth in the
% Continous_Spikes_Prepare_Plots function

% Inputs:
% 1. SpikeTimes: nspikes x 1 double in seconds
% 2. SpikePositions: nspikes x 1 double with position of spike in um (for internal spikes: nchannel * ChannelSpacing)
% 3: ChannelSpacing: as double in um (from Data.Info.ChannelSpacing)
% 4: Channel_Selection: 1 x 2 double with channelselction of user, i.e.
% [1,10] for channel 1 to 10
% 5: SpikeType: type of spike data as char, either 'Internal' OR 'Kilosort'

%Outputs:
% 1. SpikeTimes: nspikes x 1 double with indicie of each spike in samples
% in the selected range
% 2. SpikePositions: nspikes x 1 double with position of spike in um in the selected range 
% 3. SelectedChannelIndicies: nspikes x 1 logical with a 1 for spikes in
% range, 0 otherwise. This is used outside of this function to also delete
% indiceis in Spikes.Amps and Spikes.SpikeCluster or Spikes.Clusterposition

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% If Internal spikes convert channelnr in um depth
if strcmp(SpikeType,'Internal')
    SpikePositions = (SpikePositions-1).*ChannelSpacing;
    ChannelRange = ((Channel_Selection(1):Channel_Selection(2))*ChannelSpacing)-ChannelSpacing;
end

if strcmp(SpikeType,'Kilosort')
    if Channel_Selection(1)~=Channel_Selection(2)
        ChannelRange = (Channel_Selection(1):Channel_Selection(2)-1)*ChannelSpacing;
    else
        ChannelRange(1) = ((Channel_Selection(1)-1)*ChannelSpacing)-(ChannelSpacing/2);
        ChannelRange(2) = ((Channel_Selection(2)-1)*ChannelSpacing)+(ChannelSpacing/2);
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
    SpikePositions = SpikePositions - (ChannelRange(1));
end