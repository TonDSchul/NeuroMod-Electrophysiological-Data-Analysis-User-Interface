function Continous_Kilosort_Spikes_Plot_Raw_Waveforms(Figure,Data,ChannelSelection,units,Waveforms)

%________________________________________________________________________________________
%% Function to plot waveforms that where extracted for Kilosort spikes
% Note: For each spike the specified nr of waveforms over all selected channel are plotted

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots function

% Inputs:
% 1. Figure: Figure axes handle top plot in 
% 2. Data: main window data structure with Data.Spikes and Data.Info field; Data.Spikes with field Data.Spikes.Waveforms.waveForms
% 3. ChannelSelection: 1x2 double with channel to plot the waveforms for,
% i.e. [1,10] for channel 1 to 10
% 4. units: unitselection as double, for title (waveform already extracted for just that unit)
% 5. Waveforms: 1x2 double with wavefor selection of user, i.e. [1,10] for
% 10 waveforms

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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