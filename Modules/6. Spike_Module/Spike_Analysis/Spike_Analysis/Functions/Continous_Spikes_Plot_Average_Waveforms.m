function Continous_Spikes_Plot_Average_Waveforms(Figure,Data,ChannelSelection,UnitstoPlot,MeanWaveform,ChannelSpacing,SpikeType,WaveformsToPlot,TwoORThreeD)

%________________________________________________________________________________________
%% Function to plot average waveforms over each channel for a single unit

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots and Continous_Internal_Spikes_Manage_Analysis_Plots function

% Inputs:
% 1. Figure: fugire aces handle to plot in
% 2. Data: main window app structure (just needed for Data.Info to get samplerate)
% 3. ChannelSelection: 1x2 double with channelselection of user, i.e. [1,10]
% for channel 1 to 10 
% 4. UnitstoPlot: number of unit selected as double (just for title) 
% 5. MeanWaveform: depending on whether one or multiple channel selected
% either a 3d double matrix with nunit x nchannel x ntime or 2D matrix (1x1xntime)
% 6. ChannelSpacing: in um as double, from Data.Info.ChannelSpacing
% 7. SpikeType: char, Type of spike to analyse, either 'Kilosort' OR 'Internal'
% 8. WaveformsToPlot: 1x2 double with waveformselection of user, i.e. [1,10]
% for 10 waveforms

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


% If no spike data and therefore no waveform for a channel: field is NaN
% --> set to 0

NumChannel = length(ChannelSelection(1):ChannelSelection(2));

if ndims(MeanWaveform)==3
    Time = 0:1/Data.Info.NativeSamplingRate:(round(size(MeanWaveform,3))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
    Time = Time*1000; % Convert to ms
elseif ndims(MeanWaveform)==2
    Time = 0:1/Data.Info.NativeSamplingRate:(round(size(MeanWaveform,2))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
    Time = Time*1000; % Convert to ms
end

cla(Figure)

ydata = 0:ChannelSpacing:(NumChannel-1)*ChannelSpacing;

if strcmp(SpikeType,"Kilosort") 
    if strcmp(TwoORThreeD,"TwoD")
        % 2D Plot
        min_z = min(MeanWaveform,[],'all');
        surface(Figure,Time, ydata, min_z * ones(size(squeeze(MeanWaveform))), ...
        'CData', squeeze(MeanWaveform), 'FaceColor', 'texturemap', 'EdgeColor', 'none');
    elseif strcmp(TwoORThreeD,"ThreeD")
        % 3D Plot
        surf(Figure,Time,ydata,squeeze(MeanWaveform),'EdgeColor', 'none')
        % 2D Plot
        min_z = min(MeanWaveform,[],'all');
        surface(Figure,Time, ydata, min_z * ones(size(squeeze(MeanWaveform))), ...
        'CData', squeeze(MeanWaveform), 'FaceColor', 'texturemap', 'EdgeColor', 'none');

        view(Figure,45,45);
        box(Figure, 'off');
        grid(Figure, 'off');
    end
else
    if ndims(MeanWaveform)==3
        if strcmp(TwoORThreeD,"TwoD")
            imagesc(Figure,Time,ydata,squeeze(MeanWaveform),'Tag','Image')
        elseif strcmp(TwoORThreeD,"ThreeD")
            imagesc(Figure,Time,ydata,squeeze(MeanWaveform))
            surf(Figure,Time,ydata,squeeze(MeanWaveform),'EdgeColor', 'none')
            view(Figure,45,45);
            box(Figure, 'off');
            grid(Figure, 'off');
        end
    elseif ndims(MeanWaveform)==2
        if strcmp(TwoORThreeD,"TwoD")
            imagesc(Figure,Time,ydata,squeeze(MeanWaveform),'Tag','Image')
        elseif strcmp(TwoORThreeD,"ThreeD")
            surf(Figure,Time,ydata,squeeze(MeanWaveform),'EdgeColor', 'none')
            imagesc(Figure,Time,ydata,squeeze(MeanWaveform))
            view(Figure,45,45);
            box(Figure, 'off');
            grid(Figure, 'off');
        end
    end
end


set(Figure, 'YDir', 'reverse'); 
if strcmp(SpikeType,"Kilosort")
    title(Figure,strcat("Unit ",num2str(UnitstoPlot)," Average of Waveform(s) ", num2str(WaveformsToPlot)," Across Channels ",num2str(ChannelSelection)))
else
    title(Figure,strcat("Average of Waveform(s) ", num2str(WaveformsToPlot)," Across Channels ",num2str(ChannelSelection)))
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

ylim(Figure,[ydata(1),ydata(end)])
xlim(Figure,[Time(1),Time(end)]);

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);
