function CurrentPlotData = Event_Module_ERP_MultipleLines(Data,EventRelatedData,PlotLineSpacing,EventTime,BaselineNormalize,NormalizationWindow,Figure2,Type,DataChannelSelected,rgbcolormap,PlotAppearance,CurrentPlotData)

%________________________________________________________________________________________
%% Function to plot individual trigger lines and mean (ERP) in ERP analysis window

% Inputs: 
% 1. Data: data strcuture of main window, to simplfy inputs later on?!
% 2. EventRelatedData: nchannel x nevents x ntimepoints single matrix
% containing event related data
% 3. PlotLineSpacing: factor as double that determines the spacing between
% plotted erp lines of different channel
% 4. EventTime: double time vector of events with one time in seconds for
% each time point of the EventRelatedData variable (with negativ pre event time)
% 5. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 6. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds
% 7.Figure2: axis handle to figure on bottom of ERP window
% 8. Type: Detmerines what is plotted, Options: 'SingleERPOnly' for just
% erp plots of one channel over all events OR 'MultipleERPOnly' for just
% erp plot of each channel OR 'All' for both plots
% 9. DataChannelSelected: 1 x 2 double with channelrange to be plotted;
% [1,10] means channel 1 to 10 
% 10. rgbcolormap: nplots x 3 double matrix with rgb values for each line
% plotted (only for plotting multiple channel erp's with consistent colors)
% 11. PlotAppearance: structure holding info about plot appearances the user
% might have modified.
% 12. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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