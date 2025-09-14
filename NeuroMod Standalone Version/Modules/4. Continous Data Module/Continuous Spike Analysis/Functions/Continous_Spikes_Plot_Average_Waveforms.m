function CurrentPlotData = Continous_Spikes_Plot_Average_Waveforms(Figure,Data,ChannelSelection,UnitstoPlot,MeanWaveform,ChannelSpacing,SpikeType,WaveformsToPlot,TwoORThreeD,CurrentPlotData)

%________________________________________________________________________________________
%% Function to plot average waveforms over each channel for a single unit

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots and Continous_Internal_Spikes_Manage_Analysis_Plots function

%NOTE: it takes a nchannel x ntimewaveforms matrix as input,
%where the mean was already claculated over each waveform 

% Inputs:
% 1. Figure: fugire aces handle to plot in
% 2. Data: main window app structure (just needed for Data.Info to get samplerate)
% 3. ChannelSelection: 1x2 double with channelselection of user, i.e. [1,10]
% for channel 1 to 10 
% 4. UnitstoPlot: number of unit selected as double (just for title) 
% 5. MeanWaveform: nchannel x ntime matrix holding averaged waveform for
% each channel
% 6. ChannelSpacing: in um as double, from Data.Info.ChannelSpacing
% 7. SpikeType: char, Type of spike to analyse, either 'Kilosort' OR 'Internal'
% 8. WaveformsToPlot: 1x2 double with waveformselection of user, i.e. [1,10]
% for 10 waveforms
% 9. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


% If no spike data and therefore no waveform for a channel: field is NaN
% --> set to 0

NumChannel = length(ChannelSelection);

if ndims(MeanWaveform)==3
    Time = 0:1/Data.Info.NativeSamplingRate:(round(size(MeanWaveform,3))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
    Time = Time*1000; % Convert to ms
elseif ndims(MeanWaveform)==2
    Time = 0:1/Data.Info.NativeSamplingRate:(round(size(MeanWaveform,2))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
    Time = Time*1000; % Convert to ms
end

ydata = linspace(0,(NumChannel-1)*ChannelSpacing,NumChannel);

%ydata = linspace(0,(NumChannel)*ChannelSpacing,NumChannel);
%ydata = ChannelSpacing:ChannelSpacing:(NumChannel)*ChannelSpacing;

if strcmp(TwoORThreeD,"TwoD")
    PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    if length(PowerDepth2D_handles)>1
        delete(PowerDepth2D_handles(2:end));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    end

    min_z = 0;
    if isempty(PowerDepth2D_handles)
        % 2D Plot
        MeanWaveform=squeeze(MeanWaveform);
        surface(Figure,Time, ydata, min_z * ones(size(MeanWaveform)), ...
        'CData', MeanWaveform, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    else
        % 2D Plot
        set(PowerDepth2D_handles(1),'XData',Time,'YData', ydata,'ZData', min_z * ones(size(squeeze(MeanWaveform))), ...
        'CData', squeeze(MeanWaveform), 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    end
elseif strcmp(TwoORThreeD,"ThreeD")
    PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    
    if length(PowerDepth2D_handles)>1
        delete(PowerDepth2D_handles(2:end));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
    elseif length(PowerDepth3D_handles)>1
        delete(PowerDepth3D_handles(2:end));
        PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    end
    
    if length(PowerDepth3D_handles)+length(PowerDepth2D_handles)==1
        delete(PowerDepth3D_handles(:));
        delete(PowerDepth2D_handles(:));
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    end

    if isempty(PowerDepth2D_handles) || isempty(PowerDepth3D_handles)
        % 3D Plot
        surf(Figure,Time,ydata,squeeze(MeanWaveform),'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
        % 2D Plot
        min_z = min(MeanWaveform,[],'all');
        surface(Figure,Time, ydata, min_z * ones(size(squeeze(MeanWaveform))), ...
        'CData', squeeze(MeanWaveform), 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    else
        % 3D Plot
        set(PowerDepth3D_handles(1),'XData',Time,'YData',ydata,'ZData',squeeze(MeanWaveform),'CData',squeeze(MeanWaveform),'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
        % 2D Plot
        min_z = min(MeanWaveform,[],'all');
        set(PowerDepth2D_handles(1),'XData',Time, 'YData',ydata, 'ZData',min_z * ones(size(squeeze(MeanWaveform))), ...
        'CData', squeeze(MeanWaveform), 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
    end

    view(Figure,45,45);
    box(Figure, 'off');
    grid(Figure, 'off');
end

set(Figure, 'YDir', 'reverse'); 

if strcmp(UnitstoPlot,"All") || strcmp(UnitstoPlot,"Non")
    title(Figure,strcat("All Units Average of Biggest Waveform(s) ", num2str(WaveformsToPlot)," Across Channel Selection"))
else
    if isnumeric(UnitstoPlot)
        title(Figure,strcat("Unit ",num2str(UnitstoPlot)," Average of Biggest Waveform(s) ", num2str(WaveformsToPlot)," Across Channel Selection"))
    else
        title(Figure,strcat("Unit ",UnitstoPlot," Average of Biggest Waveform(s) ", num2str(WaveformsToPlot)," Across Channel Selection"))
    end
end

cbar_handle=colorbar('peer',Figure,'location','WestOutside');
colormap(Figure, colormap_BlueWhiteRed);
cbar_handle.Label.String = "Amplitude [mV]";
xlabel(Figure,'Time [ms]')
ylabel(Figure,'Depth [µm]')
if min(squeeze(MeanWaveform),[],'all') ~= max(squeeze(MeanWaveform),[],'all')
    Figure.CLim = [min(squeeze(MeanWaveform),[],'all'),max(squeeze(MeanWaveform),[],'all')];
end
NewCLim = [-1 1]*max(abs(Figure.CLim()));
colormap(Figure,colormap_BlueWhiteRed); 
Figure.CLim = [NewCLim(1) NewCLim(2)]; 

if ydata(1) ~= ydata(end)
   % ylim(Figure,[0,ydata(end)])
    ylim(Figure,[ydata(1),ydata(end)])
end
xlim(Figure,[Time(1),Time(end)]);

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);

%% save plotted data in case user wants to save 

CurrentPlotData.MainXData = Time;
CurrentPlotData.MainYData = ydata;
CurrentPlotData.MainCData = squeeze(MeanWaveform);
if strcmp(Data.Info.SpikeType,"Kilosort")
    CurrentPlotData.MainType = strcat("Continous Kilosort Spikes: Average Waveform");
else
    CurrentPlotData.MainType = strcat("Continous Internal Spikes: Average Waveform");
end
CurrentPlotData.MainXTicks = Figure.XTickLabel;