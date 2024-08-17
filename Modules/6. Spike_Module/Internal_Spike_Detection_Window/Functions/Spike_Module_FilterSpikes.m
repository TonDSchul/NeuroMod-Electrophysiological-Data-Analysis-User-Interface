function [Data] = Spike_Module_FilterSpikes(Data, Tolerance, ArtefactDepth, ChannelSpacing)
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
h = waitbar(0, 'Filtering Spike Indicies...', 'Name','Filtering Spike Indicies...');

%% Attempted Filtering of artefacts across all channel
% This code finds spike indicies that are the same +/-1 sample across more
% than 10 channel
% Initialize empty arrays for concatenated results
SpikeTimes = Data.Spikes.SpikeTimes;
SpikePositions = Data.Spikes.SpikePositions(:,2);

% Sort SpikeTimes and keep track of the original indices
[sortedSpikeTimes, sortIdx] = sort(SpikeTimes);
sortedSpikePositions = SpikePositions(sortIdx);
Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps(sortIdx);
Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel(sortIdx);

% Initialize logical index array to mark values to keep
toKeep = true(size(sortedSpikeTimes));

% Vectorized search for spike times within ±1 sample
ProgressSteps = round(length(sortedSpikeTimes)/100);
CurrentProgress = ProgressSteps;
for i = 1:length(sortedSpikeTimes)
    %if toKeep(i) == true %%%% Is going faster but does not yield the same
    %results
        if i == CurrentProgress
            % Update the progress bar
           fraction = CurrentProgress/length(sortedSpikeTimes);
           msg = sprintf('Filtering Spike Indicies... (%d%% done)', round(100*fraction));
           waitbar(fraction, h, msg);
           CurrentProgress = round(CurrentProgress+ProgressSteps);
        end
        % Create a logical array for spike times within +/- tolerance sample
        SameIndicies = abs(sortedSpikeTimes - sortedSpikeTimes(i)) <= Tolerance;

        if sum(SameIndicies) > 1
            uniqueChannels = unique(sortedSpikePositions(SameIndicies));
            if length(uniqueChannels) > ArtefactDepth
                toKeep(SameIndicies) = false;
            end
        end
end

% Remove the marked spike times and corresponding positions
Data.Spikes.SpikeTimes = sortedSpikeTimes(toKeep);

TempSpikePositions = Data.Spikes.SpikePositions(:,1);
TempSpikePositions = TempSpikePositions(toKeep);
TempSpikePositions(:,2) = sortedSpikePositions(toKeep);
Data.Spikes.SpikePositions = TempSpikePositions;

Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps(toKeep);
Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel(toKeep);

close(h);

