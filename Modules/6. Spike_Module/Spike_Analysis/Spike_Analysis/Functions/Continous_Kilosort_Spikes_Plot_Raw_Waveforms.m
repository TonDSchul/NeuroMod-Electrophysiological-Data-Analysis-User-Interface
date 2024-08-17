function Continous_Kilosort_Spikes_Plot_Raw_Waveforms(Figure,Data,ChannelSelection,units,Waveforms)

numclus = unique(Data.Spikes.SpikeCluster);

DatatoPlot = squeeze(Data.Spikes.Waveforms.waveForms);

if Waveforms(1)==Waveforms(2) && ChannelSelection(1)==ChannelSelection(2)
    DatatoPlot = DatatoPlot';
end

if strcmp(Data.Info.SpikeType,"Kilosort")
    if ndims(DatatoPlot)==3
        Time = 0:1/Data.Info.NativeSamplingRate:(round(size(DatatoPlot,3))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
        Time = Time*1000; % Convert to ms
    elseif ndims(DatatoPlot)==2
        Time = 0:1/Data.Info.NativeSamplingRate:(round(size(DatatoPlot,2))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
        Time = Time*1000; % Convert to ms
    end
end

SpikeWaveform_handles = findobj(Figure,'Type', 'line', 'Tag', 'SpikeWaveform');
[Maxnrlines,~] = size(DatatoPlot);

if numel(SpikeWaveform_handles)>Maxnrlines
    delete(SpikeWaveform_handles(Maxnrlines+1:end));
end

for i = 1:Maxnrlines
    if isempty(SpikeWaveform_handles)
        line(Figure,Time,DatatoPlot(i,:), 'LineWidth', 2 ,'Tag', 'SpikeWaveform')
    elseif ~isempty(SpikeWaveform_handles) 
        if i <= length(SpikeWaveform_handles)
            set(SpikeWaveform_handles(i), 'XData', Time, 'YData', DatatoPlot(i,:), 'LineWidth', 2 ,'Tag', 'SpikeWaveform');
        else
           line(Figure,Time,DatatoPlot(i,:), 'LineWidth', 2 ,'Tag', 'SpikeWaveform')
        end
    end
end

if max(DatatoPlot,[],'all') ~= min(DatatoPlot,[],'all')
    ylim(Figure,[min(DatatoPlot,[],'all'),max(DatatoPlot,[],'all')])
end
xlim(Figure,[Time(1),Time(end)]);
ylabel(Figure,'Signal [mV]');xlabel(Figure,'Time [ms]'); 
title(Figure,strcat("Spike Waveforms ",num2str(Waveforms)," of Units ",num2str(units)," Across Channel ",num2str(ChannelSelection)));

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);