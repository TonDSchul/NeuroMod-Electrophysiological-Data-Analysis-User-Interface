function ProbeView_Show_Spike_Positions(Data,ProbeViewProperties,Figure)

% set colormap
Costumcolormap = jet(length(unique(Data.Spikes.SpikeCluster)));

% flip bc y axis is reverse
FlippedY = max(Data.Info.ProbeInfo.ycoords) - Data.Spikes.SpikePositions(:,2);
% scale spikepos to probe view plot pos
PreScaledX = (ProbeViewProperties.XlimsPlottedChannel(end) - ProbeViewProperties.XlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));

FullyScaledX = (Data.Spikes.SpikePositions(:,1) - min(Data.Info.ProbeInfo.xcoords)) * PreScaledX + ProbeViewProperties.XlimsPlottedChannel(1);
FullyScaledY = (FlippedY - min(Data.Info.ProbeInfo.ycoords)) * PreScaledY + ProbeViewProperties.YlimsPlottedChannel(1);

NumSpikesCluster = nan(1,length(unique(Data.Spikes.SpikeCluster)));
for i = 1:length(unique(Data.Spikes.SpikeCluster))
    CurrentCluster = Data.Spikes.SpikeCluster(i);
    CurrentClusterIndicie = CurrentCluster==Data.Spikes.SpikeCluster;
    NumSpikesCluster(i) = sum(CurrentClusterIndicie);
end

markerSize = 1 + (NumSpikesCluster - min(NumSpikesCluster)) ...
             / (max(NumSpikesCluster) - min(NumSpikesCluster)) ...
             * (550 - 1);

% Loop over cluster and plot
for i = 1:length(unique(Data.Spikes.SpikeCluster))
    CurrentCluster = Data.Spikes.SpikeCluster(i);
    CurrentClusterIndicie = CurrentCluster==Data.Spikes.SpikeCluster;
    
    ClusterXSpikPos = median(FullyScaledX(CurrentClusterIndicie));
    ClusterYSpikPos = median(FullyScaledY(CurrentClusterIndicie));

    
    
    scatter(Figure,ClusterXSpikPos,ClusterYSpikPos,round(markerSize(i)),'Marker','o','Tag','SpikePositions','MarkerFaceColor', Costumcolormap(i,:), ...
    'MarkerEdgeColor','k','LineWidth',1.5,'MarkerFaceAlpha',0.5)
end
