function [SpikesPerBin] = Spike_Module_Calculate_Spikes_Times_In_Bin(SpikeTimes,SpikePositions,NumBins,BinSize,Samplingrate,SpikeRateType,MinEdge,MaxEdge)

%________________________________________________________________________________________
%% Function calculate the amount of spikes within a bin of time
% Note: If Samplingrate = 1 as input, spike rate is given as number of
% spikes per bin. When you input a proper Samplingrate > 1, this function
% returns the spike rate in Hz for each bin

% This function is called in the Event_Spikes_Plot_Spike_Rate,
% Continous_Spikes_Plot_Spike_Rate and 

% Inputs:
% 1. SpikeTimes: nspikes x 1 double with indicie if each spike in samples
% 2. SpikePositions: nspikes x 1 double with position of spike in um -- no
% needed yet but always useful
% 3: NumBins: Number of bins as double
% 4: BinSize: Size of each bin as double in samples
% 5: Samplingrate: as double in Hz
% 6. SpikeRateType: either "SpikeRateoverTime" or "SpikeRateoverChannel"

%Outputs:
% 1. SpikesPerBin: 1 x nbins double; If Samplingrate = 1 as input, spike rate is given as number of
% spikes per bin. When you input a proper Samplingrate > 1, this function
% returns the spike rate in Hz for each bin


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Analyse Spike Data by creating and filling bins

SpikesPerBin = zeros(1,NumBins);

if strcmp(SpikeRateType,"SpikeRateoverTime")

    % Calculate the bin edges based on the desired bin size and number of bins
    minEdge = 0; % Minimum value of SpikePositions
    maxEdge = NumBins*BinSize; % Define the range of bins
    binEdges = minEdge:BinSize:maxEdge;  % Create bin edges

    % Count the number of SpikePositions in each bin
    [SpikesPerBin, ~] = histcounts(SpikeTimes, binEdges);

elseif strcmp(SpikeRateType,"SpikeRateoverChannel")

    % Calculate the bin edges based on the desired bin size and number of bins
    binEdges = MinEdge:BinSize:MaxEdge;  % Create bin edges

    % Count the number of SpikePositions in each bin
    [SpikesPerBin, ~] = histcounts(SpikePositions, binEdges);
end

%% Convert to Frequeny
if Samplingrate ~= 1
    SpikesPerBin = double(SpikesPerBin)./(BinSize/Samplingrate);
else
    SpikesPerBin = SpikesPerBin;
end
