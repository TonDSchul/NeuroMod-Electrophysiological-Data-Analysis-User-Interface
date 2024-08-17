function Continous_Spikes_Plot_Average_Waveforms(Figure,Data,ChannelSelection,UnitstoPlot,MeanWaveform,ChannelSpacing,SpikeType,WaveformsToPlot)

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

% Delete Spike Handles
Image_handles = findobj(Figure,'Tag', 'Image');

if isempty(Image_handles)
    if strcmp(SpikeType,"Kilosort")
        imagesc(Figure,Time,0:ChannelSpacing:NumChannel*ChannelSpacing,squeeze(MeanWaveform),'Tag','Image')
    else
        if ndims(MeanWaveform)==3
            imagesc(Figure,Time,ChannelSpacing/2:ChannelSpacing:NumChannel*ChannelSpacing,squeeze(MeanWaveform),'Tag','Image')
        elseif ndims(MeanWaveform)==2
            imagesc(Figure,Time,ChannelSpacing/2:ChannelSpacing:NumChannel*ChannelSpacing,squeeze(MeanWaveform),'Tag','Image')
        end
    end
else
    if strcmp(SpikeType,"Kilosort")
        set(Image_handles(1),'XData', Time , 'YData', 0:ChannelSpacing:NumChannel*ChannelSpacing ,'CData', squeeze(MeanWaveform),'Tag','Image');
    else
        if ndims(MeanWaveform)==3
            set(Image_handles(1),'XData', Time , 'YData', 0:ChannelSpacing:NumChannel*ChannelSpacing ,'CData', squeeze(MeanWaveform),'Tag','Image');
        elseif ndims(MeanWaveform)==2
            set(Image_handles(1),'XData', Time , 'YData', 0:ChannelSpacing:NumChannel*ChannelSpacing ,'CData', squeeze(MeanWaveform),'Tag','Image');
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

ylim(Figure,[0,(NumChannel*ChannelSpacing)])
xlim(Figure,[Time(1),Time(end)]);

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);
