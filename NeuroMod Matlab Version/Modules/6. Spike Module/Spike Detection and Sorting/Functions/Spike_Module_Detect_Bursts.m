function Spike_Module_Detect_Bursts(Data,N,ISIThreshold)

Spike.T = Spikes.SpikeTimes/Data.Info.NativeSamplingRate;
Spike.C = Spikes.SpikeChannel;

[Data.Spikes.Bursts.BurstTimes , Data.Spikes.Bursts.BurstNumber] = BurstDetectISIn( Spike, N, ISIThreshold );

figure;
plot(Spikes.SpikeTimes,Spikes.SpikePositions(:,2),'+');
hold on 

plot(Spikes.SpikeTimes(SpikeBurstNumber~=-1),Spikes.SpikePositions(SpikeBurstNumber~=-1,2),'+','Color','r');