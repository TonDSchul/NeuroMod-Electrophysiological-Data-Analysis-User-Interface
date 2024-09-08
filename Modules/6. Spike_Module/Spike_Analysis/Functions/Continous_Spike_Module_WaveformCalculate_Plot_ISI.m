function Spike_Module_Calculate_Plot_ISI(Data,SpikeTimes,SampleRate)

% SpikeTimes in Samples

% Compute interspike intervals
InterspikeIntervals = (diff(SpikeTimes))/Data.Info.NativeSamplingRate; % Convert to s