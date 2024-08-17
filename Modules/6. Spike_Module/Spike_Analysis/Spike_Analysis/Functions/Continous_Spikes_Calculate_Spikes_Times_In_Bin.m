function [SpikesPerBin] = Continous_Spikes_Calculate_Spikes_Times_In_Bin(SpikeTimes,SpikePositions,NumBins,BinSize,Samplingrate)
% BinSize double in Samples
% BinSize double 
% SpikeTimes double in Samples

%% Analyse Spike Data by creating and filling bins

SpikesPerBin = zeros(1,NumBins);

Currentbinmin = 0;
Currentbinmax = BinSize;

for currentbiniteration = 1:NumBins
    
    SpikesPerBin(currentbiniteration) = sum(SpikeTimes > Currentbinmin & SpikeTimes <= Currentbinmax);

    Currentbinmin = Currentbinmax;
    Currentbinmax = Currentbinmin+BinSize;
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