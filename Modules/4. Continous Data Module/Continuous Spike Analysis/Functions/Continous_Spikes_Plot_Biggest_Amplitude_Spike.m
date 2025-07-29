function CurrentPlotData = Continous_Spikes_Plot_Biggest_Amplitude_Spike(Figure,Data,units,rgbMatrix,CurrentPlotData)

%________________________________________________________________________________________
%% Function to plot biggest template of waveforms
% Note: Each unit has a template for each channel. What is plotted here is
% the biggest of those templates

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots function

% Inputs:
% 1. Figure: Figure axes handle top plot in 
% 2. Data: main window data structure with Data.Spikes and Data.Info field; Data.Spikes with field Data.Spikes.BiggestAmplWaveform
% 4. units: unitselection as double, for title (waveform already extracted for just that unit)
% 5. rgbMatrix: ntemplates x 3 double with rgb values for each template 
% 6. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


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

% save data for export
CurrentPlotData.MainXData = Time;
CurrentPlotData.MainYData = Data.Spikes.BiggestAmplWaveform(units,:);
CurrentPlotData.MainCData = [];
CurrentPlotData.MainType = strcat("Continous Spikes: Individual Spike Waveforms");
CurrentPlotData.MainXTicks = Figure.XTickLabel;