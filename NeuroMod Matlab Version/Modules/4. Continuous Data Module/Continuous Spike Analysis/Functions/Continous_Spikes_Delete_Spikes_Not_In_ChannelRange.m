function [SpikeTimes,SpikePositions,DeleteSpikePositions] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(Window,Info,SpikeTimes,SpikePositions,ChannelSpacing,Channel_Selection,SpikeType,ALLActiveChannel)

%________________________________________________________________________________________
%% Function to take spike times and delete indicies outside of selected channel range

% This function is called whenever spike data is plotted to determine
% spikes in selcted channelrange/depth in the
% Continous_Spikes_Prepare_Plots function

% Inputs:
% 1. Info: NeuroMod info structure (Data.Info)
% 1. SpikeTimes: nspikes x 1 double in seconds
% 2. SpikePositions: nspikes x 1 double with position of spike in um (for internal spikes: nchannel * ChannelSpacing)
% 3: ChannelSpacing: as double in um (from Data.Info.ChannelSpacing)
% 4: Channel_Selection: double vector with channelselction of user, i.e.
% [1,2,3,4,5] for channel 1 to 5
% 5: SpikeType: type of spike data as char, either 'Internal' OR 'Kilosort'
% 6. ALLActiveChannel: double vector, all activ channel defined when
% extracting the dataset

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
    if strcmp(Window,"MainWindow")
        for i = 1:length(SpikePositions)
            % Spikes below deletions
            if sum(SpikePositions(i) > DeleteIndicies)
                SpikePositions(i) = SpikePositions(i) - length(DeleteIndicies(SpikePositions(i) > DeleteIndicies));
            end
        end
    end
end

if strcmp(SpikeType,'Kilosort') || strcmp(SpikeType,'SpikeInterface')
    
    %% Now correct spikes are always?! selected based on this
    %--> just too many, namely twice as much per depth
    
    %% Delte Channel not in range
    % What channels where deleted?
    DeleteIndicies = [];
    for nchannel = 1:length(ALLActiveChannel)
        if sum(nchannel == Channel_Selection) ==0 
            DeleteIndicies = [DeleteIndicies,nchannel];
        end
    end
    
    % Custome YLabel
    FakeData = [];
    FakeData.Info = Info;
    [StartDepth,StopDepth,FakeChannelRange,FakeYpositions] = Spike_Module_Analysis_Determine_Depths(FakeData,1,Info.ProbeInfo.ActiveChannel(Channel_Selection));
    
    % Convert in um
    %DeleteIndicies = (DeleteIndicies-1)*Info.ProbeInfo.FakeSpacing;
    %FakeChannelRange = 1:str2double(Info.ProbeInfo.NrChannel)*str2double(Info.ProbeInfo.NrRows);
    %FakeYpositions = (FakeChannelRange-1)*Info.ProbeInfo.FakeSpacing;
    DeleteIndicies = FakeYpositions(Info.ProbeInfo.ActiveChannel(DeleteIndicies));

    % Find spikes with channels that were deleted
    % save in a array and delete after loop
    DeleteSpikePositions = [];
    if ~isempty(DeleteIndicies)
        DeleteSpikePositions = zeros(length(SpikePositions),1);
        for Idelete= 1:length(DeleteIndicies)
            TempDeleteSpikePositions = SpikePositions >= (DeleteIndicies(Idelete))-(Info.ProbeInfo.FakeSpacing/2) & SpikePositions <= DeleteIndicies(Idelete)+(Info.ProbeInfo.FakeSpacing/2);
            DeleteSpikePositions = DeleteSpikePositions + double(TempDeleteSpikePositions);
        end
        % delete Spike Indicies not in range
        if sum(DeleteSpikePositions)>0
            DeleteSpikePositions(DeleteSpikePositions>1) = 1;
        
            SpikePositions(DeleteSpikePositions>0) = [];
            SpikeTimes(DeleteSpikePositions>0) = [];            
        end
    end
    
    if strcmp(Window,"Con_Spikes") || strcmp(Window,"Event_Spikes")
        return;
    end

    ChannelBeforeActive = min(Info.ProbeInfo.ActiveChannel)-1;
    if ChannelBeforeActive<=0
        ChannelBeforeActive = 0;
    else
        ChannelBeforeActive = (ChannelBeforeActive)*Info.ProbeInfo.FakeSpacing;
    end
    
    % Convert back in channel
    %
    
    % % Now correct spike positions based on channel deleted --> account for
    % % channel deleted before by substracting number of channels delted
    % % above spikes
    % % Convert back in channel

    % if active channels have islands of consecutive numbers apart by a gap
    % --> adjust for that gap        
    GapsDiffsOrig = diff(Info.ProbeInfo.ActiveChannel);
    GapsDurations = (GapsDiffsOrig(GapsDiffsOrig > 1) - 1);

    Gaplocations = Info.ProbeInfo.ActiveChannel(GapsDiffsOrig>1)+1;
    Gaplocations = Gaplocations + (GapsDurations-1);

    for i = 1:length(SpikePositions)
        % if active cahnnel deactivated
        if sum(SpikePositions(i) > DeleteIndicies + (Info.ProbeInfo.FakeSpacing/2)) > 0
            GapsNumberWithinBelow = 0;
            for nGaps = 1:length(GapsDurations)
                if SpikePositions(i) > Gaplocations(nGaps) * Info.ProbeInfo.FakeSpacing
                   if nGaps == 1
                        GapsNumberWithinBelow = GapsNumberWithinBelow + ((GapsDurations(nGaps)+2)*Info.ProbeInfo.FakeSpacing) + Info.ProbeInfo.FakeSpacing;
                   else
                        GapsNumberWithinBelow = GapsNumberWithinBelow + ((GapsDurations(nGaps))*Info.ProbeInfo.FakeSpacing) - Info.ProbeInfo.FakeSpacing;
                   end
                   %GapsNumberWithinBelow = GapsNumberWithinBelow + ((GapsDurations(nGaps)+(length(GapsDurations)+1-nGaps))*Info.ProbeInfo.FakeSpacing);
                end
            end
            
            if GapsNumberWithinBelow == 0 % before gap
                Correction = sum(SpikePositions(i) > DeleteIndicies) * Info.ProbeInfo.FakeSpacing; % 
            else % after gap -- affected
                Extra = (nGaps)*Info.ProbeInfo.FakeSpacing;
                GapsNumberWithinBelow = GapsNumberWithinBelow - Extra;
                Correction = (sum(SpikePositions(i) > DeleteIndicies) * Info.ProbeInfo.FakeSpacing) + GapsNumberWithinBelow; % + gap zwischen channel inseln wenn vorhhanden
            end

            SpikePositions(i) = (SpikePositions(i) - Correction) - ChannelBeforeActive;

        else % if no active channel deactivated
            GapsNumberWithinBelow = 0;
            for nGaps = 1:length(GapsDurations)
                if SpikePositions(i) > Gaplocations(nGaps) * Info.ProbeInfo.FakeSpacing
                    if nGaps == 1
                        GapsNumberWithinBelow = GapsNumberWithinBelow + ((GapsDurations(nGaps)+2)*Info.ProbeInfo.FakeSpacing) + Info.ProbeInfo.FakeSpacing ;
                    else
                        GapsNumberWithinBelow = GapsNumberWithinBelow + ((GapsDurations(nGaps))*Info.ProbeInfo.FakeSpacing) - Info.ProbeInfo.FakeSpacing;
                    end
                    %GapsNumberWithinBelow = GapsNumberWithinBelow + ((GapsDurations(nGaps)+(length(GapsDurations)+1-nGaps))*Info.ProbeInfo.FakeSpacing);
                end
            end

            if GapsNumberWithinBelow > 0 % before gap
                Extra = (nGaps)*Info.ProbeInfo.FakeSpacing;
                GapsNumberWithinBelow = GapsNumberWithinBelow - Extra;
                Correction = GapsNumberWithinBelow; % + gap zwischen channel inseln wenn vorhhanden
            else
                Correction = 0;
            end

            SpikePositions(i) = (SpikePositions(i) - Correction) - ChannelBeforeActive;
        end
        
    end
end