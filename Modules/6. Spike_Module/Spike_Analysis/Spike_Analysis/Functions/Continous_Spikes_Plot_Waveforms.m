function Continous_Spikes_Plot_Waveforms(Data,Waveforms,ChannelSelection,WaveformsToPlot,ClusterSelection)

%% Plot Data 

WaveformRange = WaveformsToPlot(1):WaveformsToPlot(2);

Plotdata = squeeze(Data.Spikes.Waveforms(ChannelSelection(1):ChannelSelection(2),WaveformRange,:));

Waveforms = [];
BiggestSpikeIndicies = [];

Time = 0:1/Data.Info.NativeSamplingRate:(round(size(Data.Spikes.Waveforms,3))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
Time = Time*1000; % Convert to ms

TotalSpikes = length(WaveformRange)*length((ChannelSelection(1):ChannelSelection(2)));

if ndims(Plotdata) == 2 && size(Plotdata,1) ~=1 && size(Plotdata,2) == 1
    Plotdata = Plotdata';
end

Waveform_handles = findobj(Figure, 'Tag', 'Waveforms');
if length(Waveform_handles) > TotalSpikes
    for i = 1:length(Waveform_handles)
        delete(Waveform_handles(TotalSpikes+1:end));
    end
end

Waveform_handles = findobj(Figure,'Tag', 'Waveforms');

NrPlots = 0;

for nchannel = 1:size(Plotdata,1)
    for nwaves = 1:numel(WaveformRange)
        NrPlots = NrPlots+1;
        if isempty(Waveform_handles) || NrPlots > length(Waveform_handles) 
            if ndims(Plotdata(nchannel,nwaves,:)) == 3 
                if size(Plotdata(nchannel,nwaves,:),1) == 1
                    line(Figure,Time,squeeze(Plotdata(nchannel,nwaves,:)),'LineWidth',1, 'Tag', 'Waveforms');
                else
                    line(Figure,Time,Plotdata(nchannel,nwaves,:),'LineWidth',1, 'Tag', 'Waveforms');
                end
            else
                line(Figure,Time,Plotdata(nchannel,:),'LineWidth',1, 'Tag', 'Waveforms');
            end
            
        else
            if ndims(Plotdata(nchannel,nwaves,:)) == 3 
                if size(Plotdata(nchannel,nwaves,:),1) == 1
                    set(Waveform_handles(NrPlots), 'XData', Time, 'YData', squeeze(Plotdata(nchannel,nwaves,:)),'LineWidth',1, 'Tag', 'Waveforms');
                else
                    set(Waveform_handles(NrPlots), 'XData', Time, 'YData', Plotdata(nchannel,nwaves,:),'LineWidth',1, 'Tag', 'Waveforms');
                end
            else
                set(Waveform_handles(NrPlots), 'XData', Time, 'YData', Plotdata(nchannel,:),'LineWidth',1, 'Tag', 'Waveforms');
            end
        end
    end
end

title(Figure,strcat("Waveforms ",num2str(WaveformRange(1)),",",num2str(WaveformRange(end))," Channel ",num2str(ChannelSelection)));
xlabel(Figure,"Time [ms]");
ylabel(Figure,"Signal [mV]");
xlim(Figure,[Time(1),Time(end)])
if max(Data.Spikes.Waveforms,[],'all') ~= min(Data.Spikes.Waveforms,[],'all')
    ylim(Figure,[min(Data.Spikes.Waveforms,[],'all'),max(Data.Spikes.Waveforms,[],'all')])
end
