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
% 4. ChannelSpacing in um as double

% Output: Preserved Data structure with filtered spikes

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% convert input numbers from gui into double
Tolerance = str2double(Tolerance);
ArtefactDepth = str2double(ArtefactDepth);
%get Channelnr of depth
ArtefactDepth = round(ArtefactDepth/ChannelSpacing);
% initiate progress bar
h = waitbar(0, 'Filtering Spike Indicies...', 'Name','Filtering Vertical Spike Artefacts...');

%% Attempted Filtering of artefacts across all channel
% This code finds spike indicies that are the same +/-1 sample across more
% than 10 channel
SpikeTimes = Data.Spikes.SpikeTimes;
SpikePositions = Data.Spikes.SpikePositions(:,2);

% % Sort SpikeTimes and keep track of the original indices
% [SpikeTimes, sortIdx] = sort(SpikeTimes);
% SpikePositions = SpikePositions(sortIdx);
% Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps(sortIdx);
% Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel(sortIdx);

% Initialize logical index array to mark values to keep
toKeep = true(size(SpikeTimes));

% Vectorized search for spike times within ±1 sample
ProgressSteps = round(length(SpikeTimes)/100);
CurrentProgress = ProgressSteps;

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

% For later output save indices deleted
TempToKeep.SpikeTimes = SpikeTimes(~toKeep);
TempToKeep.SpikePosition = SpikePositions(~toKeep);
TempToKeep.SpikeAmps = Data.Spikes.SpikeAmps(~toKeep);
TempToKeep.SpikeIndiciestoKeep = toKeep;

% Remove the marked spike times and corresponding positions
Data.Spikes.SpikeTimes = SpikeTimes(toKeep);
TempSpikePositions = Data.Spikes.SpikePositions(:,1);
TempSpikePositions = TempSpikePositions(toKeep);
TempSpikePositions(:,2) = SpikePositions(toKeep);
Data.Spikes.SpikePositions = TempSpikePositions;

Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps(toKeep);
Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel(toKeep);

toKeep = TempToKeep;

close(h);

