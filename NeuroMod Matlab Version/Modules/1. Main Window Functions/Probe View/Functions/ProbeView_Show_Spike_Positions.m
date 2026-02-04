function ProbeView_Show_Spike_Positions(Data,ProbeViewProperties,Figure,WhatToShow)

SpikeHandles = findobj(Figure, 'Tag', 'SpikePositions');
if ~isempty(SpikeHandles)
    delete(SpikeHandles);
end

NumSpikesPerChannel = zeros(1,size(Data.Info.ProbeInfo.ActiveChannel,1));
CurrentAmps = zeros(1,size(Data.Info.ProbeInfo.ActiveChannel,1));

%% Plot internal spikes
if strcmp(Data.Info.SpikeType,"Internal")

    Costumcolormap = jet(length(unique(Data.Spikes.SpikeChannel)));

    for nchannel = 1:length(Data.Info.ProbeInfo.ActiveChannel)
        CuurentChannelIndicies = Data.Spikes.SpikeChannel == nchannel;
        if sum(CuurentChannelIndicies)>0
            if strcmp(WhatToShow,"NumSpikes")
                NumSpikesPerChannel(nchannel) = sum(CuurentChannelIndicies);
                
            elseif strcmp(WhatToShow,"SpikeAmps")
                CurrentAmps(nchannel) = mean(abs(Data.Spikes.SpikeAmps(CuurentChannelIndicies)));
            end
        end
    end

    if strcmp(WhatToShow,"NumSpikes")
        markerSize = round(1 + (NumSpikesPerChannel - min(NumSpikesPerChannel)) * (550 - 1) / (max(NumSpikesPerChannel) - min(NumSpikesPerChannel)));
    elseif strcmp(WhatToShow,"SpikeAmps")
        markerSize = round(1 + (CurrentAmps - min(CurrentAmps)) * (550 - 1) / (max(CurrentAmps) - min(CurrentAmps)));
    end

    Xall = [];
    Yall = [];
    Sall = [];
    Call = [];
    PreScaledX = [];
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
            
            if nchannel == 1 || isempty(PreScaledX)
                % scale spikepos to probe view plot pos
                if length(unique(Data.Info.ProbeInfo.xcoords)) == 2 
                    PreScaledX = (0.65 - 0.25) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
                    PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
                elseif length(unique(Data.Info.ProbeInfo.xcoords)) == 4 && Data.Info.ProbeInfo.OffSetRows == 1
                    PreScaledX = (0.83 - 0.17) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
                    PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
                else
                    ProbeViewProperties.XlimsPlottedChannel(end) = ProbeViewProperties.XlimsPlottedChannel(end) - ((ProbeViewProperties.XlimsPlottedChannel(2)-ProbeViewProperties.XlimsPlottedChannel(1)));
    
                    PreScaledX = (ProbeViewProperties.XlimsPlottedChannel(end) - ProbeViewProperties.XlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.xcoords) - min(Data.Info.ProbeInfo.xcoords));
                    PreScaledX = PreScaledX - 0.00068;
                    PreScaledY = (ProbeViewProperties.YlimsPlottedChannel(end) - ProbeViewProperties.YlimsPlottedChannel(1)) / (max(Data.Info.ProbeInfo.ycoords) - min(Data.Info.ProbeInfo.ycoords));
                end
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
                ClusterXSpikPos = FullyScaledX + ((ProbeViewProperties.XlimsPlottedChannel(2)-ProbeViewProperties.XlimsPlottedChannel(1))*25);
                ClusterYSpikPos = FullyScaledY;
            end

            Xall(end+1) = ClusterXSpikPos(1);
            Yall(end+1) = ClusterYSpikPos(1);
            Sall(end+1) = round(markerSize(nchannel));
            Call(end+1,:) = Costumcolormap(LaufVariable,:);
       
            % scatter(Figure,ClusterXSpikPos(1),ClusterYSpikPos(1),round(markerSize(nchannel)),'Marker','o','Tag','SpikePositions','MarkerFaceColor', Costumcolormap(LaufVariable,:), ...
            % 'MarkerEdgeColor','k','LineWidth',1.5,'MarkerFaceAlpha',0.5)

            %drawnow
        end
        
        LaufVariable = LaufVariable + 1; 
    end

    scatter(Figure, Xall, Yall, Sall, Call, ...
    'Marker','o','Tag','SpikePositions','MarkerFaceColor', Costumcolormap(LaufVariable,:), ...
             'MarkerEdgeColor','k','LineWidth',1.5,'MarkerFaceAlpha',0.5);
  
else
   
    Xall = [];
    Yall = [];
    Sall = [];
    Call = [];

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
        if ~isempty(CurrentClusterIndicie)
            if strcmp(WhatToShow,"NumSpikes")
                NumSpikesCluster(i) = sum(CurrentClusterIndicie);
            else
                CurrentAmps(i) = mean(abs(Data.Spikes.SpikeAmps(CurrentClusterIndicie)));
            end
        end

    end
    
    if strcmp(WhatToShow,"NumSpikes")
        markerSize = round(1 + (NumSpikesCluster - min(NumSpikesCluster)) * (550 - 1) / (max(NumSpikesCluster) - min(NumSpikesCluster)));
    elseif strcmp(WhatToShow,"SpikeAmps")
        markerSize = round(1 + (CurrentAmps - min(CurrentAmps)) * (550 - 1) / (max(CurrentAmps) - min(CurrentAmps)));
    end
    
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

        Xall(end+1) = ClusterXSpikPos(1);
        Yall(end+1) = ClusterYSpikPos(1);
        Sall(end+1) = round(markerSize(i));
        Call(end+1,:) = Costumcolormap(i,:);
    
    end

    scatter(Figure, Xall, Yall, Sall, Call, ...
    'Marker','o','Tag','SpikePositions','MarkerFaceColor', Costumcolormap(1,:), ...
             'MarkerEdgeColor','k','LineWidth',1.5,'MarkerFaceAlpha',0.5);
end