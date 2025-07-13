function Organize_Plot_Trigger_Indices(Data,Figure,EventToPlot,Time,ActiveChannel,EventstoPlotDropDown,SpacingSlider,EventTriggerChannel,TimearoundEvent,DataToExtractFromDropDown,DataSourceDropDown,ColorMap)

[SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainWindow');

%% -------------------- Extract Event Related Data -------------------- 
[Data,~] = Event_Module_Extract_Event_Related_Data(Data,EventTriggerChannel,TimearoundEvent,DataToExtractFromDropDown,DataSourceDropDown);

ArtefactRelatedData = squeeze(Data.EventRelatedData(SelectedChannel,EventToPlot,:));

[Data,~] = Organize_Delete_Dataset_Components(Data,"EventRelatedData");

%% Select Data based on user input

if strcmp(EventstoPlotDropDown,"Mean over all Trigger")
    ArtefactRelatedData = mean(ArtefactRelatedData,2);
end

%% Add ChannelSapcing for proper plot
for i = 1:size(ArtefactRelatedData,1)     
    ArtefactRelatedData(i, :) = ArtefactRelatedData(i, :) - (i - 1) * SpacingSlider;
end

%% Plot Data
colorMap = ColorMap(SelectedChannel,:);
%colorMap = eval(strcat("parula","(size(ArtefactRelatedData,1))")); % Example colormap: You can use any other colormap

ArtefactData_handles = findobj(Figure, 'Tag', 'TracesAroundArtefacts');
EventData_handles = findobj(Figure, 'Tag', 'EventLine');
ArtefactLine_handles = findobj(Figure, 'Tag', 'ArtefactLine');

if length(ArtefactLine_handles)>size(ArtefactRelatedData,1)
    delete(ArtefactLine_handles(size(ArtefactRelatedData,1)+1:end));
end

if isempty(ArtefactData_handles)
    for i = 1:size(ArtefactRelatedData,1) % over channel for costum color
        line(Figure,Time,ArtefactRelatedData(i,:),'Color',colorMap(i,:),'LineWidth',1,'Tag',"TracesAroundArtefacts")
    end
    % Red event line in middle
    line(Figure,[0,0],[min(ArtefactRelatedData,[],'all') max(ArtefactRelatedData,[],'all')],'Tag','EventLine','LineWidth',2,'Color','r');
    
    ArtefactData_handles = findobj(Figure, 'Tag', 'TracesAroundArtefacts');
    EventData_handles = findobj(Figure, 'Tag', 'EventLine');

    legend(Figure,EventData_handles, {'Trigger'}, 'Location', 'northeast');

else
    if length(ArtefactData_handles)>size(ArtefactRelatedData,1)
        delete(ArtefactData_handles(size(ArtefactRelatedData,1)+1:end));
        ArtefactData_handles = findobj(Figure, 'Tag', 'TracesAroundArtefacts');
    end

    if length(EventData_handles)>1
        delete(EventData_handles(2:end));
    end

    for i = 1:size(ArtefactRelatedData,1)
        if length(ArtefactData_handles) >= i
            set(ArtefactData_handles(i), 'XData', Time, 'YData', ArtefactRelatedData(i,:),'Color',colorMap(i,:), 'Tag', 'TracesAroundArtefacts','LineWidth',1);
        else
            line(Figure,Time,ArtefactRelatedData(i,:),'Color',colorMap(i,:),'LineWidth',1,'Tag',"TracesAroundArtefacts")
        end
    end

    set(EventData_handles(1), 'XData', [0,0], 'YData', [min(ArtefactRelatedData,[],'all') max(ArtefactRelatedData,[],'all')], 'Tag', 'EventLine','LineWidth',2,'Color','r');
    eventline = EventData_handles(1);

    if length(ArtefactLine_handles)>2
        delete(ArtefactLine_handles(3:end));
    end

    % Bring Event Line to the front
    uistack(eventline, 'top');
    % Add legend for the three specific lines
    legend(Figure,eventline, {'Trigger'}, 'Location', 'northeast');
end

Figure.FontSize = 11;
xlabel(Figure,"Time [ms]")
ylabel(Figure,"Channel")
if strcmp(EventstoPlotDropDown,"Mean over all Trigger")
    title(Figure,"ERP Around all Trigger");
else
    title(Figure,strcat("Data Around Trigger ",num2str(EventToPlot)));
end

xlim(Figure,[Time(1),Time(end)])
ylim(Figure,[min(ArtefactRelatedData,[],'all') max(ArtefactRelatedData,[],'all')]);
Figure.XLabel.Color = [0 0 0];
Figure.YLabel.Color = [0 0 0];       
Figure.YColor = 'k';  
Figure.XColor = 'k';  
Figure.Title.Color = 'k';  
Figure.Box ="off";