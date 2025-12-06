function Data = Spike_Module_Get_Kilosort_Amplitude(Data)

%ensure no 0 indexing
if min(Data.Spikes.SpikeChannel)==0
    Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel + 1;
end

TempSpikeAmps = zeros(size(Data.Spikes.SpikeTimes));

if isfield(Data,'Preprocessed')
    for i = 1:size(Data.Raw,1)
        CurrentIndices = Data.Spikes.SpikeChannel == Data.Info.ProbeInfo.ActiveChannel(i);
        TempSpikeAmps(CurrentIndices) = Data.Preprocessed(i,Data.Spikes.SpikeTimes(CurrentIndices));
    end
else
    for i = 1:size(Data.Raw,1)
        CurrentIndices = Data.Spikes.SpikeChannel == Data.Info.ProbeInfo.ActiveChannel(i);
        TempSpikeAmps(CurrentIndices) = Data.Raw(i,Data.Spikes.SpikeTimes(CurrentIndices));
    end
end

Data.Spikes.SpikeAmps = TempSpikeAmps;