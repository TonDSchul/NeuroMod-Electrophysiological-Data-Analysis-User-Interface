function Continous_Kilosort_Spikes_Plot_Spike_Templates(Figure,Data,ChannelSelection,units,rgbMatrix)
 

Template_handles = findobj(Figure,'Type', 'line', 'Tag', 'Template');

if numel(Template_handles)>length(ChannelSelection(1):ChannelSelection(2))
    delete(Template_handles(length(ChannelSelection(1):ChannelSelection(2))+1:end));
end

Template_handles = findobj(Figure,'Type', 'line', 'Tag', 'Template');

AllChannel = ChannelSelection(1):ChannelSelection(2);

Datatoplot = squeeze(Data.Spikes.templates(units,:,ChannelSelection(1):ChannelSelection(2)));

if ChannelSelection(1)==ChannelSelection(2)
    Datatoplot = Datatoplot';
end

% if units(1) ~= units(2)
%     Datatoplot = Datatoplot';
%     AllChannel = units(1):units(2);
% end

if size(rgbMatrix,1) < size(Datatoplot,2)
    rgbMatrix = lines(size(Datatoplot,2));
end

if strcmp(Data.Info.SpikeType,"Kilosort")
    Time = 0:1/Data.Info.NativeSamplingRate:(round(size(Datatoplot,1))/Data.Info.NativeSamplingRate)-(1/Data.Info.NativeSamplingRate);
    Time = Time*1000; % Convert to ms
end

for nchannel = 1:size(Datatoplot,2)
    if isempty(Template_handles)
        line(Figure,Time,Datatoplot(:,nchannel), 'LineWidth', 2, 'Tag', 'Template','Color',rgbMatrix(AllChannel(nchannel),:));
    elseif ~isempty(Template_handles) 
        if nchannel <= length(Template_handles)
            set(Template_handles(nchannel), 'XData', Time, 'YData', Datatoplot(:,nchannel), 'LineWidth', 2, 'Tag', 'Template','Color',rgbMatrix(AllChannel(nchannel),:));
        else
            line(Figure,Time,Datatoplot(:,nchannel), 'LineWidth', 2, 'Tag', 'Template','Color',rgbMatrix(AllChannel(nchannel),:));
        end
    end
end

if sum(Datatoplot,'all') > 0
    ylim(Figure,[min(Datatoplot,[],'all'),max(Datatoplot,[],'all')])
end

xlim(Figure,[Time(1),Time(end)]);
ylabel(Figure,'Amplitude');xlabel(Figure,'Time [ms]'); 
title(Figure,strcat("Spike Templates of Unit ",num2str(units)," Across Channel ",num2str(ChannelSelection)));

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);