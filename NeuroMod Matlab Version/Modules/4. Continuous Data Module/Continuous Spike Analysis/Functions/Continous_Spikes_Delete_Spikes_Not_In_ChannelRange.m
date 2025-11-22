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
% 4: Channel_Selection: 1 x 2 double with channelselction of user, i.e.
% [1,10] for channel 1 to 10
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
    
    if str2double(Info.ProbeInfo.NrRows) == 1
        %% Delte Channel not in range
        % What channels where deleted?
        DeleteIndicies = [];
        for nchannel = 1:length(ALLActiveChannel)
            if sum(nchannel == Channel_Selection) ==0 
                DeleteIndicies = [DeleteIndicies,nchannel];
            end
        end
        
        % Convert in um
        OriginalDeleteIndicies = DeleteIndicies;
        DeleteIndicies = Info.ProbeInfo.ycoords(Info.ProbeInfo.ActiveChannel(OriginalDeleteIndicies));

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
    
    
        if strcmp(Window,"Con_Spikes") || strcmp(Window,"Event_Spikes")
            return;
        end
        
        % Now correct spike positions based on channel deleted --> account for
        % channel deleted before by substracting number of channels delted
        % above spikes
        % Convert back in channel
        [~,a] = ismember(DeleteIndicies,Info.ProbeInfo.ycoords);
        [~,DeleteIndicies] = ismember(a,Info.ProbeInfo.ActiveChannel);
        DeleteIndicies = Info.ProbeInfo.ycoords(Info.ProbeInfo.ActiveChannel(DeleteIndicies));

        % if active channels have islands of consecutive numbers apart by a gap
        % --> adjust for that gap
        GapsDiffsOrig = diff(Info.ProbeInfo.ActiveChannel);
        GapsDurations = GapsDiffsOrig(GapsDiffsOrig > 1)-1;
        GapsOnsetChannel = Info.ProbeInfo.ActiveChannel(GapsDiffsOrig>1) + 1;
        
        for i = 1:length(SpikePositions)
            % if active cahnnel deactivated
            if sum(SpikePositions(i) > DeleteIndicies + (ChannelSpacing/2)) > 0
                
                GapsNumberWithinBelow = 0;
                for nGaps = 1:length(GapsDurations)

                    GapDepth = ((GapsDurations(nGaps)-1) * Info.ChannelSpacing) + Info.ChannelSpacing/2;
                    
                    ThreshPosition = Info.ProbeInfo.ycoords((GapsOnsetChannel(nGaps) + GapsDurations(nGaps))-1);

                    if SpikePositions(i) > ThreshPosition
                        
                        if GapsNumberWithinBelow==0
                            GapsNumberWithinBelow = GapsNumberWithinBelow + GapDepth;
                        else
                            GapsNumberWithinBelow = GapsNumberWithinBelow + (GapDepth+Info.ChannelSpacing/2);
                        end
                    end
                end
    
                if GapsNumberWithinBelow == 0 % before gap
                    Correction = sum(SpikePositions(i) > DeleteIndicies) * ChannelSpacing; % 
                else % after gap -- affected
                    Correction = (sum(SpikePositions(i) > DeleteIndicies) * ChannelSpacing) + GapsNumberWithinBelow; % + gap zwischen channel inseln wenn vorhhanden
                end
                
                SpikePositions(i) = SpikePositions(i) - Correction;
    
            else % if no active channel deactivated
                
                if ~strcmp(Window,"Con_Spikes") && ~strcmp(Window,"Event_Spikes")

                    GapsNumberWithinBelow = 0;
                    for nGaps = 1:length(GapsDurations)

                        GapDepth = ((GapsDurations(nGaps)-1) * Info.ChannelSpacing) + Info.ChannelSpacing/2;
                        
                        ThreshPosition = Info.ProbeInfo.ycoords((GapsOnsetChannel(nGaps) + GapsDurations(nGaps))-1);

                        if SpikePositions(i) > ThreshPosition
                            
                            if GapsNumberWithinBelow==0
                                GapsNumberWithinBelow = GapsNumberWithinBelow + GapDepth;
                            else
                                GapsNumberWithinBelow = GapsNumberWithinBelow + (GapDepth+Info.ChannelSpacing/2);
                            end
                        end
                    end
        
                    if GapsNumberWithinBelow > 0 % before gap
                        Correction = GapsNumberWithinBelow; % + gap zwischen channel inseln wenn vorhhanden
                    else
                        Correction = 0;
                    end
                    
                    SpikePositions(i) = SpikePositions(i) - Correction;
                end
            end
        end
    end

    %% Now correct spikes are always?! selected based on this
    %--> just too many, namely twice as much per depth
    
    if str2double(Info.ProbeInfo.NrRows) >= 2
        
        %% Delte Channel not in range
        % What channels where deleted?
        DeleteIndicies = [];
        for nchannel = 1:length(ALLActiveChannel)
            if sum(nchannel == Channel_Selection) ==0 
                DeleteIndicies = [DeleteIndicies,nchannel];
            end
        end
        
        % Convert in um
        %DeleteIndicies = (DeleteIndicies-1)*ChannelSpacing;
        FakeChannelRange = 1:str2double(Info.ProbeInfo.NrChannel)*str2double(Info.ProbeInfo.NrRows);
        FakeYpositions = (FakeChannelRange-1)*Info.ChannelSpacing;
        DeleteIndicies = FakeYpositions(Info.ProbeInfo.ActiveChannel(DeleteIndicies));

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
        
        if strcmp(Window,"Con_Spikes") || strcmp(Window,"Event_Spikes")
            return;
        end

        ChannelBeforeActive = min(Info.ProbeInfo.ActiveChannel)-1;
        if ChannelBeforeActive<0
            ChannelBeforeActive = 0;
        else
            ChannelBeforeActive = (ChannelBeforeActive)*ChannelSpacing;
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
            if sum(SpikePositions(i) > DeleteIndicies + (ChannelSpacing/2)) > 0
                GapsNumberWithinBelow = 0;
                for nGaps = 1:length(GapsDurations)
                    if SpikePositions(i) > Gaplocations(nGaps) * ChannelSpacing
                       GapsNumberWithinBelow = GapsNumberWithinBelow + (GapsDurations(nGaps)*ChannelSpacing);
                    end
                end

                if GapsNumberWithinBelow == 0 % before gap
                    Correction = sum(SpikePositions(i) > DeleteIndicies) * ChannelSpacing; % 
                else % after gap -- affected
                    Correction = (sum(SpikePositions(i) > DeleteIndicies) * ChannelSpacing) + GapsNumberWithinBelow; % + gap zwischen channel inseln wenn vorhhanden
                end

                SpikePositions(i) = (SpikePositions(i) - Correction) - ChannelBeforeActive;

            else % if no active channel deactivated

                if ~strcmp(Window,"Con_Spikes") && ~strcmp(Window,"Event_Spikes")
                    GapsNumberWithinBelow = 0;
                    for nGaps = 1:length(GapsDurations)
                        if SpikePositions(i) > Gaplocations(nGaps) * ChannelSpacing
                           GapsNumberWithinBelow = GapsNumberWithinBelow + (GapsDurations(nGaps)*ChannelSpacing);
                        end
                    end

                    if GapsNumberWithinBelow > 0 % before gap
                        Correction = GapsNumberWithinBelow; % + gap zwischen channel inseln wenn vorhhanden
                    else
                        Correction = 0;
                    end

                    SpikePositions(i) = (SpikePositions(i) - Correction) - ChannelBeforeActive;
                end
            end
        end

    end
end