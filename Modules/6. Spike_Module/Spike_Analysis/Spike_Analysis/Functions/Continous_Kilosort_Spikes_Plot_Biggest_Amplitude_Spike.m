function Continous_Kilosort_Spikes_Plot_Biggest_Amplitude_Spike(Figure,Data,units,rgbMatrix)

if strcmp(Data.Info.SpikeType,"Kilosort")
    Time = 0:1/Data.Info.NativeSamplingRate:(round(size(Data.Spikes.BiggestAmplWaveform,2))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
    Time = Time*1000; % Convert to ms
end

xlim(Figure,[Time(1),Time(end)]);
xlabel(Figure,'Time [ms]')
ylabel(Figure,'Amplitude');
title(Figure,strcat("Biggest Waveform of Unit ", num2str(units)," Across Channel"));

SpikeWaveform_handles = findobj(Figure,'Type', 'line', 'Tag', 'MaxWaveform');

SpikeWaveform_handles = findobj(Figure,'Type', 'line', 'Tag', 'MaxWaveform');

if isempty(SpikeWaveform_handles)
    line(Figure,Time,Data.Spikes.BiggestAmplWaveform(units,:),'Tag', 'MaxWaveform', 'Color', rgbMatrix(units,:), 'LineWidth', 2);
elseif ~isempty(SpikeWaveform_handles) 
    set(SpikeWaveform_handles(1), 'XData', Time, 'YData', Data.Spikes.BiggestAmplWaveform(units,:), 'LineWidth', 2 ,'Tag', 'MaxWaveform', 'Color', rgbMatrix(units,:), 'LineWidth', 2);
end

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);