function [CurrentPlotData] = Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,TimeSpikeFigure,ChannelSpikeFigure,Type,rgb_matrix,ClustertoShow,numBins,ChannelSelection,ChannelSpacing,CurrentPlotData,PlotAppearance)

%________________________________________________________________________________________

%% Function to plot spike rate from kilosortData over time and over Channel
% Input:
% 1. Data: Data structure containing KilosortData
% 2. SpikeTimes nspikes x 1 double in seconds
% 3. SpikePositions = N x 1 double or single in um
% 4. CluterPositions = N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: if no spike clustering for
% internal spikes, all spikecluster are 1
% 5. TimeSpikeFigure: Figure handle to app.UIaxes_3 Spike Rate over time 
% 6. TemplateFigure: Figure handle to app.UIaxes_5 Spike Rate over channel 
% 7. Type: "Initial" when plotting for the first time after resetting,
% BinsizeChangeInitial when binsize was changed, "Non" when nothing
% 8. rgb_matrix: RGB values for each cluster to show them in different colors
% 9. numCluster: Number of clusters (saved under app.numCluster within Analyse_Kilosort_Window)
% 10. ClustertoShow: Number of cluster the user selected to highlight in their color. Can
% be "All" to show all cluster in their color, "Non" to show no colors or a
% number as a string to show only that cluster. 
% 11. numBins: Number of bins selectd in the analysis window (string or char)
% 12. ChannelSelection: 1x2 double with channel [from to], i.e. [1,10] for
% channel 1 to 10 
% 13. ChannelSpacing: as double in um, not required yet but always helpful
% to have
% 14. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Spike Rate over Time
ClusterSpikeTimes = [];
ClusterNr = [];

IndiciesCurrentCluster = [];

if strcmp(ClustertoShow,"Non") || strcmp(ClustertoShow,"All") || strcmp(Type,"BinsizeChangeInitial")
    ClusterNr = 1:length(unique(CluterPositions));
    %title(TimeSpikeFigure,strcat("Spike Rate per Bin All Cluster "));
    ClusterSpikeTimes = SpikeTimes;
else
    ClusterNr = str2double(ClustertoShow);
    %title(TimeSpikeFigure,strcat("Spike Rate per Bin Cluster ",num2str(ClusterNr)))
    ClusterSpikeTimes = SpikeTimes(CluterPositions == ClusterNr);
end

%% Spie Rate over Time
if strcmp(Type,"Initial") && ~strcmp(Type,"NewCluster") || strcmp(Type,"BinsizeChangeInitial")
    cN = numBins;  % number of steps/chunks
    % Divide the data into chunks (last chunk is smaller than the rest)
    dN = length(Data.Time);
   
    BinSizeSamples = floor(dN/cN);
    BinSizeTime = BinSizeSamples*(1/Data.Info.NativeSamplingRate);
    
    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(SpikeTimes,SpikePositions,cN,BinSizeTime,1,"SpikeRateoverTime");
    
    %% Calculate mean over all channel and convert to frequency
    ChanneRange = ChannelSelection(1):ChannelSelection(2);
    SpikesInBins = (SpikesInBins./BinSizeTime)./length(ChanneRange);
    
    %% Plot
   
    %if strcmp(Data.Info.SpikeType,"Kilosort")
        yyaxis(TimeSpikeFigure, 'left');
    %end
    if length(SpikesInBins)+0.5 ~= 0.5
        xlim(TimeSpikeFigure,[0.5,length(SpikesInBins)+0.5])
    end
    TotalRate_handles = findobj(TimeSpikeFigure, 'Tag', 'TotalRate');

    if isempty(TotalRate_handles)
        bar(TimeSpikeFigure,SpikesInBins,'FaceColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor,'EdgeColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor,'Tag', 'TotalRate');
    elseif ~isempty(TotalRate_handles)
        set(TotalRate_handles, 'YData', SpikesInBins,'FaceColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor,'EdgeColor',PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor,'Tag','TotalRate');
    end

    ylabel(TimeSpikeFigure,PlotAppearance.InternalEventSpikePlot.SRTimePlotYLabel)
    xlabel(TimeSpikeFigure,strcat(PlotAppearance.InternalEventSpikePlot.SRTimePlotXLabel,"; ",num2str(BinSizeTime),"s per bin"));
    TimeSpikeFigure.FontSize = PlotAppearance.InternalEventSpikePlot.SRTimePlotFontSize;

    % Set the x-tick labels to the correct time values
    % Calculate bin centers or edges
    bin_edges = Data.Time(1) + (0:cN) * BinSizeTime;
    bin_centers = bin_edges(1:end-1) + BinSizeTime/2;

    max_xticks = 50;
    tick_interval = max(1, round(cN / max_xticks));

    x_ticks = 1:tick_interval:cN;
    x_tick_labels = arrayfun(@(x) sprintf('%.2f', x), bin_centers(x_ticks), 'UniformOutput', false);

    TimeSpikeFigure.XTick = x_ticks;
    TimeSpikeFigure.XTickLabel = x_tick_labels;

end

% Save data main plot -- time spike rate
if strcmp(ClustertoShow,"Non") || strcmp(ClustertoShow,"All")
    CurrentPlotData.MainRateTimeXData = 1:length(SpikesInBins);
    CurrentPlotData.MainRateTimeYData = SpikesInBins;
    CurrentPlotData.MainRateTimeCData = [];
    if strcmp(Data.Info.SpikeType,"Kilosort")
        CurrentPlotData.MainRateTimeType = strcat("Continous Kilosort All Spikes Spike Rate Times");
    else
        CurrentPlotData.MainRateTimeType = strcat("Continous Internal All Spikes Spike Rate Times");
    end
    CurrentPlotData.MainRateTimeXTicks = TimeSpikeFigure.XTickLabel;
end

%% Spike Rate over Channel
if strcmp(Type,"Initial") || strcmp(Type,"BinsizeChangeInitial")

    SpikesInBins = [];
    
    yyaxis(TimeSpikeFigure, 'left');

    if strcmp(Data.Info.SpikeType,"Kilosort")
        cN = numBins;  % number of steps/chunks
        dN = (length(ChannelSelection(1):ChannelSelection(2))-1)*Data.Info.ChannelSpacing;
        TempSpikePos = SpikePositions;
        BinSize = dN/cN;
    else
        cN = length(ChannelSelection(1):ChannelSelection(2));  % number of steps/chunks
        dN = length(ChannelSelection(1):ChannelSelection(2));
        TempSpikePos = SpikePositions/Data.Info.ChannelSpacing;
        BinSize = Data.Info.ChannelSpacing;
    end
    % Divide the data into chunks (last chunk is smaller than the rest)

    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(TempSpikePos,SpikePositions,cN,BinSize,1,"SpikeRateoverChannel");
    
    % Get Frequency
    SpikesInBins = SpikesInBins/Data.Time(end);
    if ~isempty(SpikesInBins)
        ylim(ChannelSpikeFigure,[0,length(SpikesInBins)])
    end
    if max(SpikesInBins) ~= 0
        xlim(ChannelSpikeFigure,[0 max(SpikesInBins)]);
    end
    barh(ChannelSpikeFigure,SpikesInBins','FaceColor',PlotAppearance.InternalEventSpikePlot.SRChannelPlotBarColor,'EdgeColor',PlotAppearance.InternalEventSpikePlot.SRChannelPlotBarColor);
   
    xlabel(ChannelSpikeFigure,strcat(PlotAppearance.InternalEventSpikePlot.SRChannelPlotXLabel," ",num2str(BinSize),"µm [Hz]"))
    ylabel(ChannelSpikeFigure,PlotAppearance.InternalEventSpikePlot.SRChannelPlotYLabel)
    
    ChannelSpikeFigure.FontSize = PlotAppearance.InternalEventSpikePlot.SRChannelPlotFontSize;
    set(ChannelSpikeFigure,'yticklabel',{[]})

    %% save plotted data in case user wants to save 
    % Save data main plot -- channel spike rate
    
    CurrentPlotData.MainRateChannelXData = SpikesInBins;
    CurrentPlotData.MainRateChannelYData = 1:length(SpikesInBins);
    CurrentPlotData.MainRateChannelCData = [];
    if strcmp(Data.Info.SpikeType,"Kilosort")
        CurrentPlotData.MainRateChannelType = strcat("Continous Kilosort All Spikes Spike Rate Channel");
    else
        CurrentPlotData.MainRateChannelType = strcat("Continous Internal All Spikes Spike Rate Channel");
    end
    CurrentPlotData.MainRateChannelXTicks = ChannelSpikeFigure.XTickLabel;

end

if strcmp(Type,"BinsizeChangeInitial")
    return;
end

%% Plot Unit spike Rate
if ~strcmp(ClustertoShow,"All") && ~strcmp(ClustertoShow,"Non")

    cN = numBins;  % number of steps/chunks
    % Divide the data into chunks (last chunk is smaller than the rest)
    dN = length(Data.Time);
    
    BinSizeSamples = floor(dN/cN);
    BinSizeTime = BinSizeSamples*(1/Data.Info.NativeSamplingRate);
    
    [SpikesInBins] = Spike_Module_Calculate_Spikes_Times_In_Bin(ClusterSpikeTimes,SpikePositions,cN,BinSizeTime,1,"SpikeRateoverTime");

    % Normalize spike rate over all channel in which spikes where found
    if strcmp(Data.Info.SpikeType,"Internal")
        SpikesInBins = SpikesInBins./length(unique(SpikePositions(CluterPositions == ClusterNr)));
    end
    %% Plot 
    
    yyaxis(TimeSpikeFigure, 'right');
    if length(SpikesInBins)+0.5 ~= 0.5
        xlim(TimeSpikeFigure,[0.5,length(SpikesInBins)+0.5])
    end
    Cluster_handles = findobj(TimeSpikeFigure, 'Tag', 'ClusterRateRight');

    if length(Cluster_handles)>1
        delete(Cluster_handles(2:end));
    end

    if strcmp(Type,"NewCluster")
        %xlim(TimeSpikeFigure,[0 1000]);
        if isempty(Cluster_handles)
            bar(TimeSpikeFigure,SpikesInBins, 'FaceColor', rgb_matrix(str2double(ClustertoShow),:),'Tag','ClusterRateRight');
        else
            set(Cluster_handles(:), 'YData', SpikesInBins,'FaceColor', rgb_matrix(str2double(ClustertoShow),:),'Tag','ClusterRateRight');
        end
    else
        delete(Cluster_handles(:));
        Cluster_handles = findobj(TimeSpikeFigure, 'Tag', 'ClusterRateRight');
        bar(TimeSpikeFigure,SpikesInBins, 'FaceColor', rgb_matrix(str2double(ClustertoShow),:),'Tag','ClusterRateRight'); 
    end
 
end

if strcmp(ClustertoShow,"All") || strcmp(ClustertoShow,"Non")
    yyaxis(TimeSpikeFigure, 'right');
    Cluster_handles = findobj(TimeSpikeFigure, 'Tag', 'ClusterRateRight');
    if ~isempty(Cluster_handles)
        delete(Cluster_handles(:));
    end
end

%% save plotted data in case user wants to save 

% Save data Units spike rate (over time only)
if ~strcmp(ClustertoShow,"Non") && ~strcmp(ClustertoShow,"All")
    CurrentPlotData.MainRateUnitXData = 1:length(SpikesInBins);
    CurrentPlotData.MainRateUnitYData = SpikesInBins;
    CurrentPlotData.MainRateUnitCData = [];
    if strcmp(Data.Info.SpikeType,"Kilosort")
        CurrentPlotData.MainRateUnitType = strcat("Continous Kilosort Unit ", ClustertoShow ," Spike Rate Time");
    else
        CurrentPlotData.MainRateUnitType = strcat("Continous Internal Unit ", ClustertoShow ," Spike Rate Time");
    end
    CurrentPlotData.MainRateUnitXTicks = TimeSpikeFigure.XTickLabel;
end