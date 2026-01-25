function ProbeView_Show_Spike_Positions(Data,ProbeViewProperties,Figure)

SpikeHandles = findobj(Figure, 'Tag', 'SpikePositions');
if ~isempty(SpikeHandles)
    delete(SpikeHandles);
end

NumSpikesPerChannel = zeros(1,size(Data.Info.ProbeInfo.ActiveChannel,1));

%% Plot internal spikes
if strcmp(Data.Info.SpikeType,"Internal")

    Costumcolormap = jet(length(unique(Data.Spikes.SpikeChannel)));

    for nchannel = 1:length(Data.Info.ProbeInfo.ActiveChannel)
        CuurentChannelIndicies = Data.Spikes.SpikeChannel == nchannel;
        NumSpikesPerChannel(nchannel) = sum(CuurentChannelIndicies);
    end
    
    markerSize = 1 + (NumSpikesPerChannel - min(NumSpikesPerChannel)) ...
                     / (max(NumSpikesPerChannel) - min(NumSpikesPerChannel)) ...
                     * (550 - 1);

    for nchannel = 1:length(Data.Info.ProbeInfo.ActiveChannel)

        LaufVariable = 1;
    
        CuurentChannelIndicies = Data.Spikes.SpikeChannel == nchannel;
        
        if sum(CuurentChannelIndicies)>0
            ChannelSpikPos = Data.Info.ProbeInfo.ActiveChannel(Data.Spikes.SpikeChannel(CuurentChannelIndicies));
            FlippedChannel = length(Data.Info.ProbeInfo.ycoords)-(unique(ChannelSpikPos)-1);
            
            if isscalar(unique(Data.Info.ProbeInfo.xcoords))
                ClusterXSpikePosum = zeros(size(ChannelSpikPos));
            else
                ClusterXSpikePosum = Data.Info.ProbeInfo.xcoords(ChannelSpikPos);
            end
            
            ClusterYSpikePosum = Data.Info.ProbeInfo.ycoords(FlippedChannel); 
        
            % scale spikepos to probe view plot pos
            if length(unique(Data.Info.ProbeInfo.xcoords)) == 2 
                PreScaledX = (0.65 - 0.25) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
                PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
            elseif length(unique(Data.Info.ProbeInfo.xcoords)) == 4 && Data.Info.ProbeInfo.OffSetRows == 1
                PreScaledX = (0.83 - 0.17) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
                PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
            else
                ProbeViewProperties.XlimsPlottedChannel(end) = ProbeViewProperties.XlimsPlottedChannel(end) - ((ProbeViewProperties.XlimsPlottedChannel(2)-ProbeViewProperties.XlimsPlottedChannel(1))*3);


                PreScaledX = (ProbeViewProperties.XlimsPlottedChannel(end) - ProbeViewProperties.XlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
                PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
            end
            
            if sum(isinf(PreScaledX))>0
                PreScaledX = 1;
            end
            if sum(isinf(PreScaledY))>0
                PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / ProbeViewProperties.YlimsPlottedChannel(1);
            end

            FullyScaledX = (ClusterXSpikePosum - min(Data.Info.ProbeInfo.xcoords)) * PreScaledX + ProbeViewProperties.XlimsPlottedChannel(1);
            FullyScaledY = (ClusterYSpikePosum - min(Data.Info.ProbeInfo.ycoords)) * PreScaledY + ProbeViewProperties.YlimsPlottedChannel(1);
            
            if isscalar(unique(Data.Info.ProbeInfo.xcoords))
                ClusterXSpikPos = 0.5;
                ClusterYSpikPos = FullyScaledY;
            elseif length(unique(Data.Info.ProbeInfo.xcoords))==2 
                ClusterXSpikPos = FullyScaledX - 3.7;
                ClusterYSpikPos = FullyScaledY;
            elseif length(unique(Data.Info.ProbeInfo.xcoords)) == 4 && Data.Info.ProbeInfo.OffSetRows == 1
                ClusterXSpikPos = FullyScaledX - 3.82;
                ClusterYSpikPos = FullyScaledY;
            else
                ClusterXSpikPos = FullyScaledX + ((ProbeViewProperties.XlimsPlottedChannel(2)-ProbeViewProperties.XlimsPlottedChannel(1))*6);
                ClusterYSpikPos = FullyScaledY;
            end
       
            scatter(Figure,ClusterXSpikPos(1),ClusterYSpikPos(1),round(markerSize(nchannel)),'Marker','o','Tag','SpikePositions','MarkerFaceColor', Costumcolormap(LaufVariable,:), ...
            'MarkerEdgeColor','k','LineWidth',1.5,'MarkerFaceAlpha',0.5)

            drawnow
        end
        
        LaufVariable = LaufVariable + 1; 
    end
  
else
    % set colormap
    Costumcolormap = jet(length(unique(Data.Spikes.SpikeCluster)));
    
    % flip bc y axis is reverse
    FlippedY = max(Data.Info.ProbeInfo.ycoords) - Data.Spikes.SpikePositions(:,2);
    % scale spikepos to probe view plot pos
    if length(unique(Data.Info.ProbeInfo.xcoords)) == 2 || length(unique(Data.Info.ProbeInfo.xcoords)) == 4 && Data.Info.ProbeInfo.OffSetRows == 1
        PreScaledX = (1 - 0) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
        PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
    else
        PreScaledX = (ProbeViewProperties.XlimsPlottedChannel(end) - ProbeViewProperties.XlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
        PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
    end
    
    if sum(isinf(PreScaledX))>0
        PreScaledX = 0;
    end
    if sum(isinf(PreScaledY))>0
        PreScaledY = 0;
    end
    % rescale if only one channel row
        
    FullyScaledX = (Data.Spikes.SpikePositions(:,1) - min(Data.Info.ProbeInfo.xcoords)) * PreScaledX + ProbeViewProperties.XlimsPlottedChannel(1);
    FullyScaledY = (FlippedY - min(Data.Info.ProbeInfo.ycoords)) * PreScaledY + ProbeViewProperties.YlimsPlottedChannel(1);
    
    NumSpikesCluster = nan(1,length(unique(Data.Spikes.SpikeCluster)));
    UniqueCluster = unique(Data.Spikes.SpikeCluster);
    for i = 1:length(UniqueCluster)
        CurrentCluster = UniqueCluster(i);
        CurrentClusterIndicie = CurrentCluster==Data.Spikes.SpikeCluster;
        NumSpikesCluster(i) = sum(CurrentClusterIndicie);
    end
    
    markerSize = 1 + (NumSpikesCluster - min(NumSpikesCluster)) ...
                 / (max(NumSpikesCluster) - min(NumSpikesCluster)) ...
                 * (550 - 1);
    
    % Loop over cluster and plot
    UniqueCluster = unique(Data.Spikes.SpikeCluster);
    for i = 1:length(unique(Data.Spikes.SpikeCluster))
        CurrentCluster = UniqueCluster(i);
        CurrentClusterIndicie = CurrentCluster==Data.Spikes.SpikeCluster;
        
        if isscalar(unique(Data.Info.ProbeInfo.xcoords))
            ClusterXSpikPos = 0.5;
            ClusterYSpikPos = median(FullyScaledY(CurrentClusterIndicie));
        elseif length(unique(Data.Info.ProbeInfo.xcoords))==2 || length(unique(Data.Info.ProbeInfo.xcoords)) == 4 && Data.Info.ProbeInfo.OffSetRows == 1
            ClusterXSpikPos = median(FullyScaledX(CurrentClusterIndicie)) - 4 ;
            ClusterYSpikPos = median(FullyScaledY(CurrentClusterIndicie));
        else
            ClusterXSpikPos = median(FullyScaledX(CurrentClusterIndicie));
            ClusterYSpikPos = median(FullyScaledY(CurrentClusterIndicie));
        end
    
        scatter(Figure,ClusterXSpikPos,ClusterYSpikPos,round(markerSize(i)),'Marker','o','Tag','SpikePositions','MarkerFaceColor', Costumcolormap(i,:), ...
        'MarkerEdgeColor','k','LineWidth',1.5,'MarkerFaceAlpha',0.4)
    end
end