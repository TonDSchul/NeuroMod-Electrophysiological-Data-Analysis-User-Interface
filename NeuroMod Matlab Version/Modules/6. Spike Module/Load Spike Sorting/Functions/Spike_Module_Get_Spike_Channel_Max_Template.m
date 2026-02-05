function Data = Spike_Module_Get_Spike_Channel_Max_Template(Data,Sorter)

Clus = unique(Data.Spikes.SpikeCluster);

Data.Spikes.SpikeChannel = zeros(size(Data.Spikes.SpikeTimes));

for i = 1:length(Clus)
    AllSpikesCluster = Data.Spikes.SpikeCluster == Clus(i);
    
    if ~isempty(AllSpikesCluster)
        if strcmp(Sorter,"Kilosort")
            Data.Spikes.SpikeChannel(AllSpikesCluster) = Data.Info.ProbeInfo.ActiveChannel(double(Data.Spikes.Cluster_Max_Template_Channel(i))); % noz zero indexed
        else
            Data.Spikes.SpikeChannel(AllSpikesCluster) = Data.Info.ProbeInfo.ActiveChannel(double(Data.Spikes.Cluster_Max_Template_Channel(i)) + 1); % zero indexed
        end
    else
        warning(strcat("Clus ",num2str(NumClus(i))," contains no spikes."));
    end
end
