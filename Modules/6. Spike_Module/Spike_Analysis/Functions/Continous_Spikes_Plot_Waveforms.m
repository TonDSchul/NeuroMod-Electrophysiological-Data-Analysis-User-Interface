function CurrentPlotData = Continous_Spikes_Plot_Waveforms(Data,SpikeTimes,SpikePositions,SpikeAmps,SpikeCluster,Waveforms,PlotInfo,ClusterSelection,Figure,CurrentPlotData)

%________________________________________________________________________________________
%% Function to plot spike rate from kilosortData over time and over Channel

% NOTE: This function takes waveforms of all spikes, the number of waveforms to
% plot and only plots the n biggest waveforms!

% Input:
% 1. Data: Data structure containing KilosortData
% 2. SpikeTimes nspikes x 1 double in seconds
% 3. SpikePositions = N x 1 double or single in um
% 4. SpikeCluster = N x 1 double or single with cluster/unit identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: if no spike clustering for
% internal spikes, all spikecluster are 1
% 5. Waveforms: nspikes x ntimewaveform matrix with waveforms for each
% spike
% 6. PlotInfo: structure containing user selected parameter for analysis. Comes from Continous_Spikes_Prepare_Plots.m function
% 7. ClusterSelection: Number of cluster the user selected to highlight in their color. Can
% be "All" to show all cluster in their color, "Non" to show no colors or a
% number as a string to show only that cluster. 
% 8. Figure: figure object handle to plot data in
% 9. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Plot Data 

%% Select Data according to cluster
if strcmp(ClusterSelection,"All") || strcmp(ClusterSelection,"Non")
    WaveformsInCluster = Waveforms;
else
    SpikesInCluster = SpikeCluster == PlotInfo.Units;
    if sum(SpikesInCluster)>1
        WaveformsInCluster = Waveforms(SpikesInCluster==1,:);
    else
        msgbox("No Spikes for current Parameter found!")
        return;
    end
end


%% Select just number of waveforms specified -- use max amplitude wavefroms
% Select for each Channel Individually
NumWaveformsToPlot = numel((PlotInfo.Waveforms(1):PlotInfo.Waveforms(2)));
[BiggestAmplitude,BiggestAmplitudeIndex] = maxk(max(abs(WaveformsInCluster),[],2),NumWaveformsToPlot);

WaveformsInCluster = WaveformsInCluster(BiggestAmplitudeIndex,:);

Time = 0:1/Data.Info.NativeSamplingRate:(round(size(WaveformsInCluster,2))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
Time = Time*1000; % Convert to ms

TotalSpikes = size(WaveformsInCluster,1);

Waveform_handles = findobj(Figure, 'Tag', 'Waveforms');
if length(Waveform_handles) > TotalSpikes+1
    for i = 1:length(Waveform_handles)
        delete(Waveform_handles(TotalSpikes+2:end));
    end
end

Waveform_handles = findobj(Figure,'Tag', 'Waveforms');

NrPlots = 0;

for nwaves = 1:size(WaveformsInCluster,1)
    NrPlots = NrPlots+1;
    if isempty(Waveform_handles) || NrPlots > length(Waveform_handles) 
        line(Figure,Time,WaveformsInCluster(nwaves,:),'LineWidth',1, 'Tag', 'Waveforms','Color','c');
    else
        set(Waveform_handles(NrPlots), 'XData', Time, 'YData', WaveformsInCluster(nwaves,:),'LineWidth',1, 'Tag', 'Waveforms','Color','c');
    end
end

if isempty(Waveform_handles) || NrPlots+1 > length(Waveform_handles) 
    if size(WaveformsInCluster,1)>1
        MeanPlot = line(Figure,Time,mean(WaveformsInCluster,1),'LineWidth',2, 'Tag', 'Waveforms','Color','k');
    else
        MeanPlot = line(Figure,Time,WaveformsInCluster,'LineWidth',2, 'Tag', 'Waveforms','Color','k');
    end
else
    if size(WaveformsInCluster,1)>1
        set(Waveform_handles(NrPlots+1), 'XData', Time, 'YData', mean(WaveformsInCluster,1),'LineWidth',2, 'Tag', 'Waveforms','Color','k');
        MeanPlot = Waveform_handles(NrPlots+1);
    else
        set(Waveform_handles(NrPlots+1), 'XData', Time, 'YData', WaveformsInCluster,'LineWidth',2, 'Tag', 'Waveforms','Color','k');
        MeanPlot = Waveform_handles(NrPlots+1);
    end
end

% Bring the mean plot to the front using uistack
uistack(MeanPlot, 'top');
if ~isnan(PlotInfo.Units)
    title(Figure,strcat("Cluster ",ClusterSelection," Biggest Waveforms ",num2str(PlotInfo.Waveforms(1)),",",num2str(PlotInfo.Waveforms(end))," Inbetween Channel ",num2str(PlotInfo.ChannelSelection)));
else
    title(Figure,strcat("All Cluster, Biggest Waveforms ",num2str(PlotInfo.Waveforms(1)),",",num2str(PlotInfo.Waveforms(end))," Inbetween Channel ",num2str(PlotInfo.ChannelSelection)));
end

xlabel(Figure,"Time [ms]");
ylabel(Figure,"Signal [mV]");
xlim(Figure,[Time(1),Time(end)])

if max(WaveformsInCluster,[],'all') ~= min(WaveformsInCluster,[],'all')
    ylim(Figure,[min(WaveformsInCluster,[],'all'),max(WaveformsInCluster,[],'all')])
end

CurrentPlotData.MainXData = Time;
CurrentPlotData.MainYData = WaveformsInCluster;
CurrentPlotData.MainCData = [];
if strcmp(Data.Info.SpikeType,"Kilosort")
    CurrentPlotData.MainType = strcat("Continous Kilosort Spikes: Individual Spike Waveforms");
else
    CurrentPlotData.MainType = strcat("Continous Internal Spikes: Individual Spike Waveforms");
end
CurrentPlotData.MainXTicks = Figure.XTickLabel;