function [SpikeTimes,SpikePositions,DeleteSpikePositions] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeTimes,SpikePositions,ChannelSpacing,Channel_Selection,SpikeType,ALLActiveChannel)

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

DeleteSpikePositions = [];

%% Internal Spikes: Delete Spike Positions not part of vhannelselction, then substract a channel to account for new scaling

if strcmp(SpikeType,'Internal')
    %% Delte Channel not in range
    % What channels where deleted?
    DeleteIndicies = [];
    for nchannel = 1:length(ALLActiveChannel)
        if sum(nchannel == Channel_Selection) ==0 
            DeleteIndicies = [DeleteIndicies,nchannel];
        end
    end

    % Find spikes with channels that were deleted
    % save in a array and delete after loop
    DeleteSpikePositions = [];
    if ~isempty(DeleteIndicies)
        DeleteSpikePositions = zeros(length(SpikePositions),1);
        for Idelete= 1:length(DeleteIndicies)
            TempDeleteSpikePositions = SpikePositions == DeleteIndicies(Idelete);
            DeleteSpikePositions = DeleteSpikePositions + double(TempDeleteSpikePositions);
        end
        % delete Spike Indsicies not in range
        if sum(DeleteSpikePositions)>0
            DeleteSpikePositions(DeleteSpikePositions>1) = 1;
        
            SpikePositions(DeleteSpikePositions>0) = [];
            SpikeTimes(DeleteSpikePositions>0) = [];            
        end
    end

    % Now correct spike positions based on channel deleted --> account for
    % channel deleted before by substracting number of channels delted
    % above spikes
    for i = 1:length(SpikePositions)
        % Spikes below deletions
        if sum(SpikePositions(i) > DeleteIndicies)
            SpikePositions(i) = SpikePositions(i) - length(DeleteIndicies(SpikePositions(i) > DeleteIndicies));
        end
    end
end

if strcmp(SpikeType,'Kilosort') || strcmp(SpikeType,'SpikeInterface')

    %% Delte Channel not in range
    % What channels where deleted?
    DeleteIndicies = [];
    for nchannel = 1:length(ALLActiveChannel)
        if sum(nchannel == Channel_Selection) ==0 
            DeleteIndicies = [DeleteIndicies,nchannel];
        end
    end

    % Convert in um
    DeleteIndicies = (DeleteIndicies-1)*ChannelSpacing;

    % Find spikes with channels that were deleted
    % save in a array and delete after loop
    DeleteSpikePositions = [];
    if ~isempty(DeleteIndicies)
        DeleteSpikePositions = zeros(length(SpikePositions),1);
        for Idelete= 1:length(DeleteIndicies)
            TempDeleteSpikePositions = SpikePositions >= (DeleteIndicies(Idelete))-(ChannelSpacing/2) & SpikePositions <= DeleteIndicies(Idelete)+(ChannelSpacing/2);
            DeleteSpikePositions = DeleteSpikePositions + double(TempDeleteSpikePositions);
        end
        % delete Spike Indicies not in range
        if sum(DeleteSpikePositions)>0
            DeleteSpikePositions(DeleteSpikePositions>1) = 1;
        
            SpikePositions(DeleteSpikePositions>0) = [];
            SpikeTimes(DeleteSpikePositions>0) = [];            
        end
    end

    % Convert back in channel
    DeleteIndicies = (DeleteIndicies/ChannelSpacing)+1;

    % Now correct spike positions based on channel deleted --> account for
    % channel deleted before by substracting number of channels delted
    % above spikes
    for i = 1:length(SpikePositions)

        % Spikes below deletions
        if sum(SpikePositions(i) > ((DeleteIndicies-1)*ChannelSpacing) -(ChannelSpacing/2)) > 0

            Correction = sum(SpikePositions(i) > ((DeleteIndicies-1)*ChannelSpacing)) * ChannelSpacing;
            
            SpikePositions(i) = SpikePositions(i) - Correction;
        end
    end
end

%% Now correct spikes are always?! selected based on this
%--> just too many, namely twice as much per depth