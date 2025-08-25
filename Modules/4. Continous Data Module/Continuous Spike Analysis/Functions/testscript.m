function testscript(Data)


figure()
plot(Data.Spikes.SpikeTimes,Data.Spikes.SpikePositions(:,1),'o');
title("All Spikes");