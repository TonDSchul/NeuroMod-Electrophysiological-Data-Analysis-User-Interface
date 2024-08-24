function [SpikesPerBin] = Spike_Module_Calculate_Spikes_Times_In_Bin(SpikeTimes,SpikePositions,NumBins,BinSize,Samplingrate,SpikeRateType)

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

%Outputs:
% 2. SpikesPerBin: 1 x nbins double; If Samplingrate = 1 as input, spike rate is given as number of
% spikes per bin. When you input a proper Samplingrate > 1, this function
% returns the spike rate in Hz for each bin


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Analyse Spike Data by creating and filling bins

SpikesPerBin = zeros(1,NumBins);

if strcmp(SpikeRateType,"SpikeRateoverTime")

    Currentbinmin = 0;
    Currentbinmax = BinSize;
    for currentbiniteration = 1:NumBins
        
        SpikesPerBin(currentbiniteration) = sum(SpikeTimes > Currentbinmin & SpikeTimes <= Currentbinmax);
    
        Currentbinmin = Currentbinmax;
        Currentbinmax = Currentbinmin+BinSize;
    end

elseif strcmp(SpikeRateType,"SpikeRateoverChannel")

    Currentbinmin = 0;
    Currentbinmax = BinSize;
    for currentbiniteration = 1:NumBins
        
        SpikesPerBin(currentbiniteration) = sum(SpikePositions >= Currentbinmin & SpikePositions < Currentbinmax);
    
        Currentbinmin = Currentbinmax;
        Currentbinmax = Currentbinmin+BinSize;
    end
end

% If BinSize is not equally dividing range, take care of last values by
% introducing a new bin
if sum(SpikeTimes>Currentbinmax) > 0
    SpikesPerBin(end) = SpikesPerBin(end)+sum(SpikeTimes>Currentbinmax);
end

%% Convert to Frequeny
if Samplingrate ~= 1
    SpikesPerBin = SpikesPerBin./(BinSize/Samplingrate);
else
    SpikesPerBin = SpikesPerBin;
end
