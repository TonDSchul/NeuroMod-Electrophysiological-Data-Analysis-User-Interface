function CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,Time,Type,rgb_matrix,SpikeTimes,SpikePositions,SpikeCluster,NumEvents,Clustertoshow,NumBins,SpikeRateTimeFigure,SpikeRateChannelFigure,KilosortChannelPos,SampleRate,ChannelToPlot,CurrentPlotData,PlotAppearance)

%________________________________________________________________________________________

%% Function to compute and plot spike rate over for all channel combined and for individual channel over the whole time range
% This function takes spikes over all channel, calculates spike rate for
% all channel and the normalizes by channel nr. and event nr.

% This function gets called in the main window when the user clicks on run
% for event spike analysis (Internal and Kilosort)

% Input:
% 1. Data: main window data structure with Data.Info field
% 2. Time: 1 x ntime time points in seconds
% 3. Type: char when this function is called, "Initial" on startup and when plotting completly new OR "BinsizeChangeInitial" when just num bins change OR "NewCluster" when just the clusterselection in window changed
% 4. rgbMatrix: nunits x 3 double with rgb values for unit colors
% 5. SpikeTimes: nspikes x 1 double with spike indicies (in samples)
% 6. SpikePositions: nspikes x 1 double with spike positions (in um) - for
% internal: channelnr * ChannelSpacing
% 7. SpikeCluster: nspikes x 1 double with spike cluster identity (integer,
% 1-indexed)-
% 8. NumEvents: double, number of events to normaloze spike rate
% 9. Clustertoshow: char, 'Non' OR 'All' or a single number like '4' for
% unit 4
% 10. NumBins: double, number of bins to divide time in for spike rate per bin
% 11. SpikeRateTimeFigure: Figure axes for figure to plot spike rate over
% time in
% 12. SpikeRateChannelFigure:Figure axes for figure to plot spike rate over
% channel in
% 13. KilosortChannelPos: not used here. 
% 14. SampleRate: double in Hz
% 15. ChannelToPlot: 1x2 double with channel to plot, i.e. [1,10] for
% channel 1 to 10
% 16. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Spike Rate over Time
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
    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(TempSpikeTimes,SpikePositions,cN,BinSizeTime,1,"SpikeRateoverTime");
    
    %% Calculate mean over all channel
    ChannelRange = ChannelToPlot;
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
        bar(SpikeRateTimeFigure,SpikesInBins,'FaceColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor,'EdgeColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor, 'Tag', 'TotalRate');
    elseif ~isempty(TotalRate_handles)
        set(TotalRate_handles(1), 'YData', SpikesInBins,'FaceColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor,'EdgeColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor,'Tag','TotalRate');
    end

    ylabel(SpikeRateTimeFigure,PlotAppearance.InternalEventSpikePlot.SRTimePlotYLabel)
    xlabel(SpikeRateTimeFigure,strcat(PlotAppearance.InternalEventSpikePlot.SRTimePlotXLabel,"; ",num2str(BinSizeTime),"s per bin"));
    SpikeRateTimeFigure.FontSize = PlotAppearance.InternalEventSpikePlot.SRTimePlotFontSize;

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

    % Save data main plot -- time spike rate
    if strcmp(Clustertoshow,"Non") || strcmp(Clustertoshow,"All")
        CurrentPlotData.MainRateTimeXData = 1:length(SpikesInBins);
        CurrentPlotData.MainRateTimeYData = SpikesInBins;
        CurrentPlotData.MainRateTimeCData = [];
        if strcmp(Data.Info.SpikeType,"Kilosort")
            CurrentPlotData.MainRateTimeType = strcat("Events Kilosort All Spikes Spike Rate Times");
        else
            CurrentPlotData.MainRateTimeType = strcat("Events Internal All Spikes Spike Rate Times");
        end
        CurrentPlotData.MainRateTimeXTicks = SpikeRateTimeFigure.XTickLabel;
    end

    %% Spike Rate over Channel
    %if ~strcmp(Type,"BinsizeChange")

    SpikesInBins = [];
    
    if strcmp(Data.Info.SpikeType,"Kilosort")
        cN = str2double(NumBins);  % number of steps/chunks
        dN = (length(ChannelToPlot)-1)*Data.Info.ChannelSpacing;
        TempSpikePos = SpikePositions;
        BinSize = dN/cN;
    else
        cN = length(ChannelToPlot);  % number of steps/chunks
        dN = length(ChannelToPlot);
        TempSpikePos = SpikePositions;
        BinSize = Data.Info.ChannelSpacing;
    end  
    
    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(TempSpikePos,SpikePositions,cN,BinSize,1,"SpikeRateoverChannel");

    % Get Frequency
    SpikesInBins = (SpikesInBins./(abs(Time(1))+Time(end)))./NumEvents;

    %% Low Pass Filter if time window smaller than 30ms so that spike rate is not multiple thousands of Hz
    if BinSizeTime <= 0.002
        Samplefrequency = 1/BinSizeTime;
        SpikesInBins = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikesInBins, [], Samplefrequency, 1, cN);
    end
    if ~isempty(SpikesInBins)
        ylim(SpikeRateChannelFigure,[0,length(SpikesInBins)])
    end
    if max(SpikesInBins)~= 0
        xlim(SpikeRateChannelFigure,[0 max(SpikesInBins)]);
    end

    barh(SpikeRateChannelFigure,SpikesInBins,'FaceColor',PlotAppearance.InternalEventSpikePlot.SRChannelPlotBarColor,'EdgeColor',PlotAppearance.InternalEventSpikePlot.SRChannelPlotBarColor);
    
    xlabel(SpikeRateChannelFigure,strcat(PlotAppearance.InternalEventSpikePlot.SRChannelPlotXLabel," per ",num2str(BinSize),"µm"));
    ylabel(SpikeRateChannelFigure,PlotAppearance.InternalEventSpikePlot.SRChannelPlotYLabel);

    SpikeRateChannelFigure.FontSize = PlotAppearance.InternalEventSpikePlot.SRChannelPlotFontSize;
    set(SpikeRateChannelFigure,'yticklabel',{[]})

    %% save plotted data in case user wants to save 
    % Save data main plot -- channel spike rate
    
    CurrentPlotData.MainRateChannelXData = 1:length(SpikesInBins);
    CurrentPlotData.MainRateChannelYData = SpikesInBins;
    CurrentPlotData.MainRateChannelCData = [];
    if strcmp(Data.Info.SpikeType,"Kilosort")
        CurrentPlotData.MainRateChannelType = strcat("Events Kilosort All Spikes Spike Rate Channel");
    else
        CurrentPlotData.MainRateChannelType = strcat("Events Internal All Spikes Spike Rate Channel");
    end
    CurrentPlotData.MainRateChannelXTicks = SpikeRateChannelFigure.XTickLabel;

    if strcmp(Type,"BinsizeChangeInitial")
        return;
    end
end

if ~strcmp(Clustertoshow,"All") && ~strcmp(Clustertoshow,"Non") || strcmp(Type,"BinsizeChange") && ~strcmp(Clustertoshow,"All") && ~strcmp(Clustertoshow,"Non")

    SpikeswithinRange = zeros(1,length(ClusterSpikeTimes));

    cN = str2double(NumBins);  % number of steps/chunks
    % Divide the data into chunks (last chunk is smaller than the rest)
    dN = length(Time);
    
    BinSizeSamples = floor(dN/cN);
    BinSizeTime = BinSizeSamples*(1/SampleRate);
    
    ClusterSpikeTimes = ClusterSpikeTimes+abs(Time(1));
    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(ClusterSpikeTimes,SpikePositions,cN,BinSizeTime,1,"SpikeRateoverTime");
    
    % Normalize spike rate over all channel in which spikes where found
    if strcmp(Data.Info.SpikeType,"Internal")
        SpikesInBins = SpikesInBins./length(unique(SpikePositions(SpikeCluster == ClusterNr)));
    end

    %% Calculate mean over all channel
    ChannelRange = ChannelToPlot;
    SpikesInBins = ((SpikesInBins./BinSizeTime))/NumEvents;
        
    %% Low Pass Filter if time window smaller than 30ms so that spike rate is not multiple thousands of Hz
    if BinSizeTime <= 0.002
        Samplefrequency = 1/BinSizeTime;
        SpikesInBins = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikesInBins, [], Samplefrequency, 1, cN);
    end

    %% For RGB Map Indice
    UniqueCluster = unique(SpikeCluster);
    clusIndice = find(UniqueCluster==ClusterNr);

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
            bar(SpikeRateTimeFigure,SpikesInBins, 'FaceColor', rgb_matrix(clusIndice,:),'Tag','ClusterRate');
        else
            set(Cluster_handles(1), 'YData', SpikesInBins,'FaceColor', rgb_matrix(clusIndice,:),'Tag','ClusterRate');
        end
    else
        delete(Cluster_handles(:));
        yyaxis(SpikeRateTimeFigure, 'right');
        Cluster_handles = findobj(SpikeRateTimeFigure, 'Tag', 'ClusterRate');
        bar(SpikeRateTimeFigure,SpikesInBins, 'FaceColor', rgb_matrix(clusIndice,:),'Tag','ClusterRate'); 
    end

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
 
end

if strcmp(Clustertoshow,"All") || strcmp(Type,"NewCluster") && strcmp(Clustertoshow,"Non") || strcmp(Type,"BinsizeChange") && strcmp(Clustertoshow,"All") ||  strcmp(Type,"BinsizeChange") && strcmp(Clustertoshow,"Non")
    yyaxis(SpikeRateTimeFigure, 'right');
    Cluster_handles = findobj(SpikeRateTimeFigure, 'Tag', 'ClusterRate');
    if ~isempty(Cluster_handles)
        delete(Cluster_handles(:));
    end
end

%% save plotted data in case user wants to save 

% Save data Units spike rate (over time only)
if ~strcmp(Clustertoshow,"Non") && ~strcmp(Clustertoshow,"All")
    CurrentPlotData.MainRateUnitXData = 1:length(SpikesInBins);
    CurrentPlotData.MainRateUnitYData = SpikesInBins;
    CurrentPlotData.MainRateUnitCData = [];
    if strcmp(Data.Info.SpikeType,"Kilosort")
        CurrentPlotData.MainRateUnitType = strcat("Events Kilosort Unit ", Clustertoshow ," Spike Rate Time");
    else
        CurrentPlotData.MainRateUnitType = strcat("Events Internal Unit ", Clustertoshow ," Spike Rate Time");
    end
    CurrentPlotData.MainRateUnitXTicks = SpikeRateTimeFigure.XTickLabel;
end