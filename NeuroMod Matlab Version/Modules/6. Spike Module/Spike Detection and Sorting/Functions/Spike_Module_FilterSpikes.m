function [Data,toKeep] = Spike_Module_FilterSpikes(Data, Tolerance, ArtefactDepth, ChannelSpacing)
%________________________________________________________________________________________

%% Function to filter Data.Spikes in Terms of vertical artefacets. 
%If a spike occurs at the same indicie +/- as many samples as specified in
%Tolerance variable over a minimum amount of depth, the count as artefacts
%and are deleted. This can be used to remove spike artefacts from optogenetic stimulation
%artefacts

% Input:
% 1. Data: Data structure containing Data.Spikes field created in the
% 'Spike_Module_Spike_Detection' function
% 2. Tolerance: Tolerance of vertical spike artefacts in samples as char. For example 3 means: spike time +/- 3 samples to the left and right over specified depth are counted as artefacts 
% 3. ArtefactDepth: Depth in um as char over which same spike times have to occur to count as a artefact.
% 4. ChannelSpacing: in um as double from Data.Info.ChannelSpacing

% Output: Preserved Data structure with filtered spikes

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Determine if there are two channel rows
UinquePos = unique(Data.Spikes.ChannelPosition(:,1));
NrChannel = size(Data.Spikes.ChannelPosition,1);
% convert input numbers from gui into double
Tolerance = str2double(Tolerance);
ArtefactDepth = str2double(ArtefactDepth);
%get Channelnr of depth
ArtefactDepth = round(ArtefactDepth/ChannelSpacing);
% initiate progress bar
h = waitbar(0, 'Filtering Spike Indicies...', 'Name','Filtering Vertical Spike Artefacts...');

% Vectorized search for spike times within ±1 sample
ProgressSteps = round(length(Data.Spikes.SpikeTimes)/100);
CurrentProgress = ProgressSteps;

TempSpikeTimes = [];
TempSpikePositions = [];
TempSpikeAmps = [];
TempSpikeChannel = [];
TempSpikeXPositions = [];

%% If two channelrows loop over both
if isscalar(UinquePos)
    TotalIters = 1;
elseif length(UinquePos)==2
    TotalIters = 2;
elseif length(UinquePos)==4
    TotalIters = 4;
else
    TotalIters = length(UinquePos);
end

% For multiple channel rows: treat each row individually --> loop through
% all x positions, take spikes from just these channel and filter them.
for its = 1:TotalIters
    
    if TotalIters == 2
        % extract channel spikes from current channelrow
        AllChannelLeft = 1:2:NrChannel;
        AllChannelRight = 2:2:NrChannel;
        
        %% Create logical indices saving a 1 if spikepositio0n is part of
        % the current channelrow
        CurrentChannel = zeros(size(Data.Spikes.SpikeTimes));
        
        % Left Channel Row
        if its == 1
            for nchannel = 1:length(AllChannelLeft)
                CurrentChannel = CurrentChannel + double(Data.Spikes.SpikePositions(:,2) == AllChannelLeft(nchannel));
                CurrentChannel(CurrentChannel>1) = 1;
            end
        elseif its == 2 % Right Channel Row
            for nchannel = 1:length(AllChannelRight)
                CurrentChannel = CurrentChannel + double(Data.Spikes.SpikePositions(:,2) == AllChannelRight(nchannel));
                CurrentChannel(CurrentChannel>1) = 1;
            end
        end
        
        %% just select spike parameter from those channel
        SpikeTimes = Data.Spikes.SpikeTimes(CurrentChannel==1);
        OriginalSpikeXPositions = Data.Spikes.SpikePositions(CurrentChannel==1,1);
        OriginalSpikePositions = Data.Spikes.SpikePositions(CurrentChannel==1,2);
        SpikePositions = Data.Spikes.SpikePositions(CurrentChannel==1,2);
        % temporatily Convert spikepositions to consecutive indicies
        % SpikePositions = 1,3,5 to 1,2,3 but only 
        % if channel contains spikes
        if its == 1
            for nchannel = 1:length(AllChannelLeft)
                SpikePositions(SpikePositions== AllChannelLeft(nchannel)) = nchannel;
            end
        elseif its == 2 % Right Channel Row
            for nchannel = 1:length(AllChannelRight)
                SpikePositions(SpikePositions== AllChannelRight(nchannel)) = nchannel;
            end
        end

        SpikeAmps = Data.Spikes.SpikeAmps(CurrentChannel==1);
        SpikeChannel = Data.Spikes.SpikeChannel(CurrentChannel==1);

        % Initialize logical index array to mark values to keep
        toKeep = true(size(SpikeTimes));

    elseif TotalIters == 4 % 2 channel row mit jeder zweiter line verschoben
        AllChannelLeft1 = 1:4:NrChannel;
        AllChannelLeft2 = 3:4:NrChannel;
        AllChannelRight1 = 2:4:NrChannel;
        AllChannelRight2 = 4:4:NrChannel;
        
        CurrentChannel = zeros(size(Data.Spikes.SpikeTimes));

        % Left Channel Row
        if its == 1 % left channel row
            for nchannel = 1:length(AllChannelLeft1)
                CurrentChannel = CurrentChannel + double(Data.Spikes.SpikePositions(:,2) == AllChannelLeft1(nchannel));
                CurrentChannel(CurrentChannel>1) = 1;
            end
        elseif its == 2 % Right Channel Row
            for nchannel = 1:length(AllChannelLeft2)
                CurrentChannel = CurrentChannel + double(Data.Spikes.SpikePositions(:,2) == AllChannelLeft2(nchannel));
                CurrentChannel(CurrentChannel>1) = 1;
            end
        elseif its == 3 % Right Channel Row
            for nchannel = 1:length(AllChannelRight1)
                CurrentChannel = CurrentChannel + double(Data.Spikes.SpikePositions(:,2) == AllChannelRight1(nchannel));
                CurrentChannel(CurrentChannel>1) = 1;
            end

        elseif its == 4 % Right Channel Row
            for nchannel = 1:length(AllChannelRight2)
                CurrentChannel = CurrentChannel + double(Data.Spikes.SpikePositions(:,2) == AllChannelRight2(nchannel));
                CurrentChannel(CurrentChannel>1) = 1;
            end
        end

        %% just select spike parameter from those channel
        SpikeTimes = Data.Spikes.SpikeTimes(CurrentChannel==1);
        OriginalSpikeXPositions = Data.Spikes.SpikePositions(CurrentChannel==1,1);
        OriginalSpikePositions = Data.Spikes.SpikePositions(CurrentChannel==1,2);
        SpikePositions = Data.Spikes.SpikePositions(CurrentChannel==1,2);
        % temporatily Convert spikepositions to consecutive indicies
        % SpikePositions = 1,3,5 to 1,2,3 but only 
        % if channel contains spikes
        if its == 1
            for nchannel = 1:length(AllChannelLeft1)
                SpikePositions(SpikePositions== AllChannelLeft1(nchannel)) = nchannel;
            end
        elseif its == 2 % Right Channel Row
            for nchannel = 1:length(AllChannelLeft2)
                SpikePositions(SpikePositions== AllChannelLeft2(nchannel)) = nchannel;
            end
        elseif its == 3 % Right Channel Row
            for nchannel = 1:length(AllChannelRight1)
                SpikePositions(SpikePositions== AllChannelRight1(nchannel)) = nchannel;
            end
        elseif its == 4 % Right Channel Row
            for nchannel = 1:length(AllChannelRight2)
                SpikePositions(SpikePositions== AllChannelRight2(nchannel)) = nchannel;
            end
        end

        SpikeAmps = Data.Spikes.SpikeAmps(CurrentChannel==1);
        SpikeChannel = Data.Spikes.SpikeChannel(CurrentChannel==1);

        % Initialize logical index array to mark values to keep
        toKeep = true(size(SpikeTimes));

    elseif TotalIters == 1 % 1 channel row
        %% Attempted Filtering of artefacts across all channel
        % This code finds spike indicies that are the same +/-1 sample across more
        % than 10 channel
        SpikeTimes = Data.Spikes.SpikeTimes;
        SpikePositions = Data.Spikes.SpikePositions(:,2);
        SpikeAmps = Data.Spikes.SpikeAmps;
        SpikeChannel = Data.Spikes.SpikeChannel;
        OriginalSpikeXPositions = Data.Spikes.SpikePositions(:,1);
        OriginalSpikePositions = Data.Spikes.SpikePositions(:,2);
        
        % Initialize logical index array to mark values to keep
        toKeep = true(size(SpikeTimes));

    elseif TotalIters > 4 % Array with 3 or more rows
        AllChannel = its:str2double(Data.Info.ProbeInfo.NrRows):its + (NrChannel-1);
        CurrentChannel = zeros(size(Data.Spikes.SpikeTimes));

        % Left Channel Row
        for nchannel = 1:length(AllChannel)
            CurrentChannel = CurrentChannel + double(Data.Spikes.SpikePositions(:,2) == AllChannel(nchannel));
            CurrentChannel(CurrentChannel>1) = 1;
        end

        %% just select spike parameter from those channel
        SpikeTimes = Data.Spikes.SpikeTimes(CurrentChannel==1);
        OriginalSpikeXPositions = Data.Spikes.SpikePositions(CurrentChannel==1,1);
        OriginalSpikePositions = Data.Spikes.SpikePositions(CurrentChannel==1,2);
        SpikePositions = Data.Spikes.SpikePositions(CurrentChannel==1,2);

        for nchannel = 1:length(AllChannel)
            SpikePositions(SpikePositions== AllChannel(nchannel)) = nchannel;
        end
       
        SpikeAmps = Data.Spikes.SpikeAmps(CurrentChannel==1);

        if size(Data.Spikes.SpikeChannel,1)==2
            SpikeChannel = Data.Spikes.SpikeChannel(2,CurrentChannel==1)';
        else
            SpikeChannel = Data.Spikes.SpikeChannel(CurrentChannel==1);
        end

        % Initialize logical index array to mark values to keep
        toKeep = true(size(SpikeTimes));
    end

    %% Conduct Actual Filtering
    for i = 1:length(SpikeTimes)
        
        if i == CurrentProgress
           % Update the progress bar
           fraction = CurrentProgress/length(SpikeTimes);
           msg = sprintf('Filtering Vertical Spike Artefacts... (%d%% done)', round(100*fraction));
           waitbar(fraction, h, msg);
           CurrentProgress = round(CurrentProgress+ProgressSteps);
        end
    
        % spike times within +/- tolerance sample
        SameIndicies = abs(SpikeTimes - SpikeTimes(i)) <= Tolerance;
    
        if sum(SameIndicies) > 1
            uniqueChannels = unique(SpikePositions(SameIndicies));
            if length(uniqueChannels) > ArtefactDepth
                % if also consecutive channel
                differences = diff(uniqueChannels);
                NumConsecutiveIndices = sum(differences == 1);
                % -1 bc of difference --> 10 channels being the same means 9
                % diffs of 1
                if NumConsecutiveIndices >= ArtefactDepth-1
                    toKeep(SameIndicies) = false;
                end
            end
        end
    end
    
    % Remove the marked spike times and corresponding positions
    TempSpikeTimes = [TempSpikeTimes;SpikeTimes(toKeep)];
    TempSpikePositions = [TempSpikePositions;OriginalSpikePositions(toKeep)];
    TempSpikeXPositions = [TempSpikeXPositions;OriginalSpikeXPositions(toKeep)];
    TempSpikeAmps = [TempSpikeAmps;SpikeAmps(toKeep)];
    TempSpikeChannel = [TempSpikeChannel;SpikeChannel(toKeep)];
    
end

Data.Spikes.SpikePositions = zeros(size(TempSpikeTimes,1),2);
Data.Spikes.SpikePositions(:,1) = TempSpikeXPositions;
Data.Spikes.SpikePositions(:,2) = TempSpikePositions;
Data.Spikes.SpikeTimes = TempSpikeTimes;
Data.Spikes.SpikeAmps = TempSpikeAmps;
Data.Spikes.SpikeChannel = TempSpikeChannel;

toKeep = [];

close(h);

