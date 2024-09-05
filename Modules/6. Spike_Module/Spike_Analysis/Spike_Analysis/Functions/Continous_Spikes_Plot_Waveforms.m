function Continous_Spikes_Plot_Waveforms(Data,SpikeTimes,SpikePositions,SpikeAmps,SpikeCluster,Waveforms,PlotInfo,ClusterSelection,Figure)

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
NumWaveformsToPlot = numel((PlotInfo.Waveforms(1):PlotInfo.Waveforms(2)))*numel((PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2)));
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
    title(Figure,strcat("Cluster ",ClusterSelection," Waveforms ",num2str(PlotInfo.Waveforms(1)),",",num2str(PlotInfo.Waveforms(end))," Channel ",num2str(PlotInfo.ChannelSelection)));
else
    title(Figure,strcat("All Cluster, Waveforms ",num2str(PlotInfo.Waveforms(1)),",",num2str(PlotInfo.Waveforms(end))," Channel ",num2str(PlotInfo.ChannelSelection)));
end
xlabel(Figure,"Time [ms]");
ylabel(Figure,"Signal [mV]");
xlim(Figure,[Time(1),Time(end)])
if max(WaveformsInCluster,[],'all') ~= min(WaveformsInCluster,[],'all')
    ylim(Figure,[min(WaveformsInCluster,[],'all'),max(WaveformsInCluster,[],'all')])
end
