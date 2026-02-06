function CurrentPlotData = Event_Module_ERP_MultipleLines(Data,EventRelatedData,PlotLineSpacing,EventTime,Figure2,Type,DataChannelSelected,rgbcolormap,PlotAppearance,CurrentPlotData)

%% Plot ERP for all Channel
adjustedcolormap = rgbcolormap(DataChannelSelected,:);

%% ----------------------------------- Baseline Normalize All Channel -----------------------------------
if strcmp(Type,'MultipleERPOnly')
    if BaselineNormalize
        EventRelatedData = Event_Module_Baseline_Normalize(Data,EventRelatedData,NormalizationWindow,EventTime,"ERP");
    end
end

if DataChannelSelected(1) == DataChannelSelected(end) 
    DataToPlot = squeeze(mean(EventRelatedData(DataChannelSelected(1),:,:),2))';
else
    DataToPlot = squeeze(mean(EventRelatedData(DataChannelSelected,:,:),2,'omitnan')); 
end

[nc,ntr,nti] = size(DataToPlot);

% DataToPlot = squeeze(mean(DataToPlot(:,:,:),2,'omitnan'));

for nchannel = 1:nc   
    DataToPlot(nchannel,:) = DataToPlot(nchannel,:) - (nchannel - 1) * PlotLineSpacing;
end

YMaxLimitsMultipeERP = max(DataToPlot,[],"all");
YMinLimitsMultipeERP = min(DataToPlot,[],"all");
xlim(Figure2, [EventTime(1),EventTime(end)]);
ylim(Figure2, [YMinLimitsMultipeERP,YMaxLimitsMultipeERP]);
xlabel(Figure2,PlotAppearance.ERPWindow.MultipleERP.XLabel)
ylabel(Figure2,PlotAppearance.ERPWindow.MultipleERP.YLabel)
title(Figure2,"Event Related Potential All Active Channel");

ChannelERPHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'ChannelERP');

if ~isempty(ChannelERPHandles)
    if length(ChannelERPHandles) > 1
        delete(ChannelERPHandles(2:end));
        ChannelERPHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'ChannelERP');
    end
else
    Figure2.FontSize = PlotAppearance.ERPWindow.MultipleERP.FontSize;
    Figure2.Color = PlotAppearance.ERPWindow.MultipleERP.BackgroundColor;
    Figure2.XLabel.Color = [0 0 0];
    %UIAxes.XTickLabelMode = 'auto';
    Figure2.XColor = 'k';  
    Figure2.Title.Color = 'k';  
    Figure2.Box ="off";
end

for nchannel = 1:size(DataToPlot,1)
    if nchannel <= length(ChannelERPHandles)
        set(ChannelERPHandles(nchannel), 'XData',EventTime, 'YData', DataToPlot(nchannel,:),'Color',adjustedcolormap(nchannel,:),'LineWidth',PlotAppearance.ERPWindow.MultipleERP.MeanLineWidth,'Tag','ChannelERP');
        Meanplot = ChannelERPHandles(1);
    else
        Meanplot = line(Figure2,EventTime,DataToPlot(nchannel,:),'Color',adjustedcolormap(nchannel,:),'LineWidth',PlotAppearance.ERPWindow.MultipleERP.MeanLineWidth,'Tag','ChannelERP');
    end
end

%% Plot Event Line
EventLinesHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'EventLines');

if ~isempty(EventLinesHandles)
    if length(EventLinesHandles) > 1
        delete(EventLinesHandles(2:end));
        EventLinesHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'EventLines');
    end
end

if isempty(EventLinesHandles)
    Eventplot = line(Figure2,[0,0],[min(DataToPlot,[],'all') max(DataToPlot,[],'all')],'Color',PlotAppearance.ERPWindow.MultipleERP.TriggerColor,'LineWidth',PlotAppearance.ERPWindow.MultipleERP.TriggerLineWidth,'Tag','EventLines');
else
    set(EventLinesHandles(:), 'XData',[0,0],'YData', [min(DataToPlot,[],'all') max(DataToPlot,[],'all')],'Color',PlotAppearance.ERPWindow.MultipleERP.TriggerColor,'LineWidth',PlotAppearance.ERPWindow.MultipleERP.TriggerLineWidth,'Tag','EventLines');
    Eventplot = EventLinesHandles(1);
end

% Bring Event Line to the front
uistack(Meanplot, 'top');
uistack(Eventplot, 'top');

% Add legend only once
if isempty(findobj(Figure2, 'Type', 'legend'))
    % Create legend and then set its 'HandleVisibility' to 'off'
    legendHandle = legend(Figure2,Eventplot, {'Trigger'});
    set(legendHandle, 'HandleVisibility', 'off');
end

%% save plotted data in case user wants to save 
% Save data main plot -- channel spike rate

CurrentPlotData.ERPoverChannelXData = EventTime;
CurrentPlotData.ERPoverChannelYData = DataToPlot;
CurrentPlotData.ERPoverChannelCData = [];
CurrentPlotData.ERPoverChannelType = strcat("Event Related Potential over Channel");
CurrentPlotData.ERPoverChannelXTicks = Figure2.XTickLabel;

%Utility_Set_YAxis_Depth_Labels(Data,Figure2,[],OriginalDataChannelSelected)
Figure2.YTickLabel = flip(Figure2.YTickLabel);