function Event_Spikes_Plot_Spike_Rate(Data,Time,Type,rgb_matrix,SpikeTimes,SpikePositions,SpikeCluster,NumEvents,Clustertoshow,NumBins,SpikeRateTimeFigure,SpikeRateChannelFigure,KilosortChannelPos,SampleRate,ChannelToPlot)

%% Spike Rate over Timeapp.Mainapp
ClusterSpikeTimes = [];

if strcmp(Clustertoshow,"Non") || strcmp(Clustertoshow,"All") || strcmp(Type,"BinsizeChangeInitial")
    ClusterNr = 1:length(unique(SpikeCluster));
    %title(SpikeRateTimeFigure,strcat("Spike Rate per Bin All Cluster "));
    ClusterSpikeTimes = SpikeTimes;
else
    ClusterNr = str2double(Clustertoshow);
    %title(SpikeRateTimeFigure,strcat("Spike Rate per Bin Cluster ",num2str(ClusterNr)))
    ClusterSpikeTimes = SpikeTimes(SpikeCluster == ClusterNr);
end

%% Here bar plots get initially plotted. Afterwards, it is just updated if needed
if strcmp(Type,"Initial") || strcmp(Type,"BinsizeChangeInitial")
    cN = str2double(NumBins);  % number of steps/chunks
    % Divide the data into chunks (last chunk is smaller than the rest)
    dN = length(Time);
    
    BinSizeSamples = floor(dN/cN);
    BinSizeTime = BinSizeSamples*(1/SampleRate);
    TempSpikeTimes = SpikeTimes+abs(Time(1));
    [SpikesInBins] = Continous_Spikes_Calculate_Spikes_Times_In_Bin(TempSpikeTimes,SpikePositions,cN,BinSizeTime,1);
    
    %% Calculate mean over all channel
    ChannelRange = ChannelToPlot(1):ChannelToPlot(2);
    SpikesInBins = ((SpikesInBins./BinSizeTime)./length(ChannelRange))/NumEvents;
    
    %% Low Pass Filter if time window smaller than 30ms so that spike rate is not multiple thousands of Hz
    if BinSizeTime <= 0.002
        Samplefrequency = 1/BinSizeTime;
        SpikesInBins = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikesInBins, [], Samplefrequency, 1, cN);
    end

    %% Plot

    yyaxis(SpikeRateTimeFigure, 'left');
    if length(SpikesInBins)+0.5 ~= 0.5
        xlim(SpikeRateTimeFigure,[0.5,length(SpikesInBins)+0.5])
    end
    TotalRate_handles = findobj(SpikeRateTimeFigure, 'Tag', 'TotalRate');

    if isempty(TotalRate_handles)
        bar(SpikeRateTimeFigure,SpikesInBins,'black', 'Tag', 'TotalRate');
    elseif ~isempty(TotalRate_handles)
        set(TotalRate_handles(1), 'YData', SpikesInBins,'Tag','TotalRate');
    end

    ylabel(SpikeRateTimeFigure,"Spike Rate [Hz]")
    xlabel(SpikeRateTimeFigure,strcat("Time [s]; ",num2str(BinSizeTime),"s per bin"));
    SpikeRateTimeFigure.FontSize = 10;

    % Set the x-tick labels to the correct time values
    % Calculate bin centers or edges
    bin_edges = Time(1) + (0:cN) * BinSizeTime;
    bin_centers = bin_edges(1:end-1) + BinSizeTime/2;

    max_xticks = 50;
    tick_interval = max(1, round(cN / max_xticks));

    x_ticks = 1:tick_interval:cN;
    x_tick_labels = arrayfun(@(x) sprintf('%.2f', x), bin_centers(x_ticks), 'UniformOutput', false);

    SpikeRateTimeFigure.XTick = x_ticks;
    SpikeRateTimeFigure.XTickLabel = x_tick_labels;

    %% Spike Rate over Channel
    %if ~strcmp(Type,"BinsizeChange")

    SpikesInBins = [];
    
    if strcmp(Data.Info.SpikeType,"Kilosort")
        cN = str2double(NumBins);  % number of steps/chunks
        dN = length(ChannelToPlot(1):ChannelToPlot(2))*Data.Info.ChannelSpacing;
        TempSpikePos = SpikePositions;
    else
        cN = length(ChannelToPlot(1):ChannelToPlot(2));  % number of steps/chunks
        dN = length(ChannelToPlot(1):ChannelToPlot(2));
        TempSpikePos = SpikePositions/Data.Info.ChannelSpacing;
    end
    % Divide the data into chunks (last chunk is smaller than the rest)

    BinSize = dN/cN;
    
    [SpikesInBins] = Continous_Spikes_Calculate_Spikes_Times_In_Bin(TempSpikePos,SpikePositions,cN,BinSize,1);

    % Get Frequency
    SpikesInBins = (SpikesInBins./(abs(Time(1))+Time(end)))./NumEvents;

    %% Low Pass Filter if time window smaller than 30ms so that spike rate is not multiple thousands of Hz
    if BinSizeTime <= 0.002
        Samplefrequency = 1/BinSizeTime;
        SpikesInBins = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikesInBins, [], Samplefrequency, 1, cN);
    end
    if length(SpikesInBins)+0.5~=0.5
        ylim(SpikeRateChannelFigure,[0.5,length(SpikesInBins)+0.5])
    end
    if max(SpikesInBins)~= 0
        xlim(SpikeRateChannelFigure,[0 max(SpikesInBins)]);
    end

    barh(SpikeRateChannelFigure,SpikesInBins,'black');
    if strcmp(Data.Info.SpikeType,"Kilosort")
        xlabel(SpikeRateChannelFigure,strcat("Spikes per ",num2str(BinSize),"µm [Hz]"))
    else
        xlabel(SpikeRateChannelFigure,strcat("Spikes per ",num2str(BinSize*Data.Info.ChannelSpacing),"µm [Hz]"))
    end
    SpikeRateChannelFigure.FontSize = 10;
    set(SpikeRateChannelFigure,'yticklabel',{[]})

    %end
    if strcmp(Type,"BinsizeChangeInitial")
        return;
    end
end

if  ~strcmp(Clustertoshow,"All") && ~strcmp(Clustertoshow,"Non") || strcmp(Type,"BinsizeChange") && ~strcmp(Clustertoshow,"All") && ~strcmp(Clustertoshow,"Non")

    SpikeswithinRange = zeros(1,length(ClusterSpikeTimes));

    cN = str2double(NumBins);  % number of steps/chunks
    % Divide the data into chunks (last chunk is smaller than the rest)
    dN = length(Time);
    
    BinSizeSamples = floor(dN/cN);
    BinSizeTime = BinSizeSamples*(1/SampleRate);
    
    ClusterSpikeTimes = ClusterSpikeTimes+abs(Time(1));
    [SpikesInBins] = Continous_Spikes_Calculate_Spikes_Times_In_Bin(ClusterSpikeTimes,SpikePositions,cN,BinSizeTime,1);
    
    %% Calculate mean over all channel
    ChannelRange = ChannelToPlot(1):ChannelToPlot(2);
    SpikesInBins = ((SpikesInBins./BinSizeTime))/NumEvents;
        
    %% Low Pass Filter if time window smaller than 30ms so that spike rate is not multiple thousands of Hz
    if BinSizeTime <= 0.002
        Samplefrequency = 1/BinSizeTime;
        SpikesInBins = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikesInBins, [], Samplefrequency, 1, cN);
    end

    %% Plot
    yyaxis(SpikeRateTimeFigure, 'right');
    if length(SpikesInBins)+0.5 ~= 0.5
        xlim(SpikeRateTimeFigure,[0.5,length(SpikesInBins)+0.5])
    end
    Cluster_handles = findobj(SpikeRateTimeFigure, 'Tag', 'ClusterRate');

    if length(Cluster_handles)>1
        delete(Cluster_handles(2:end));
    end
    if ~strcmp(Type,"BinsizeChange")
        yyaxis(SpikeRateTimeFigure, 'right');
        if isempty(Cluster_handles)
            bar(SpikeRateTimeFigure,SpikesInBins, 'FaceColor', rgb_matrix(str2double(Clustertoshow)+1,:),'Tag','ClusterRate');
        else
            set(Cluster_handles(1), 'YData', SpikesInBins,'FaceColor', rgb_matrix(str2double(Clustertoshow)+1,:),'Tag','ClusterRate');
        end
    else
        delete(Cluster_handles(:));
        yyaxis(SpikeRateTimeFigure, 'right');
        Cluster_handles = findobj(SpikeRateTimeFigure, 'Tag', 'ClusterRate');
        bar(SpikeRateTimeFigure,SpikesInBins, 'FaceColor', rgb_matrix(str2double(Clustertoshow)+1,:),'Tag','ClusterRate'); 
    end
 
end

if strcmp(Clustertoshow,"All") || strcmp(Type,"NewCluster") && strcmp(Clustertoshow,"Non") || strcmp(Type,"BinsizeChange") && strcmp(Clustertoshow,"All") ||  strcmp(Type,"BinsizeChange") && strcmp(Clustertoshow,"Non")
    yyaxis(SpikeRateTimeFigure, 'right');
    Cluster_handles = findobj(SpikeRateTimeFigure, 'Tag', 'ClusterRate');
    if ~isempty(Cluster_handles)
        delete(Cluster_handles(:));
    end
end