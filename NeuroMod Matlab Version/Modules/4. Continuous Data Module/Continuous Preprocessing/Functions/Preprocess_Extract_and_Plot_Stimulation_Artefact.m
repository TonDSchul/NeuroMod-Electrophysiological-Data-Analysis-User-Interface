function [ArtefactRelatedData,StimArtefactInfo] = Preprocess_Extract_and_Plot_Stimulation_Artefact(Data,ArtefactTimeEditField,TimeToPlot,EventChannelforStimulationDropDown,EventstoPlotDropDown,SpacingSlider,Figure,ActiveChannel,PreserveChannelLocations)

%________________________________________________________________________________________

%% Function to plot artefact time range around the event selected for the Stimulation Artefact Rejection window
% This function is called in the Stimulation Artefact Rejection window
% started when the Stimulation Artefact Rejection button is pressed in the
% preprocessing window. It takes the eventchannel selected in the window,
% extracts data around events saved for this channel and plots them.

% Input:
% 1. Data: main window data structure
% 2. TimeAroundEventsEditField: char, time around events to extract data from. Two numbers split by a comma, i.e. -0.005,0005
% 3. EventChannelforStimulationDropDown: Name of the event channel from
% which event indicies are taken. Identical to names in Data.Info.EventChannelNames
% 4. EventstoPlotDropDown: char, which event ttl's to plot from the selected
% event channel. Either 'Mean over all Trials' OR the number of the
% event,i.e. '1' for the first ttl
% 5. SpacingSlider: double, spacing between channel for plotting
% 6. Figure: figure object handle to plot data (in seconds)
% 7. ActiveChannel: double vector with all active channel in the probe view
% window
% 8. PreserveChannelLocations: double 1 or 0 whether to preserve original
% channel locations with inactive channel islands inbetween active ones

% Output: 
% 1. ArtefactRelatedData: nchannel x ntime x nevents matrix containg the data that is plotted. 
% 2. StimArtefactInfo: strcuture holding info necessray to apply artefact
% rejection to the dataset when the user adds it to the preprocessing
% pipeline. Fields are: StimArtefactInfo.SelectedEventChannelName (char)
% and SamplesToPlot (1 x 2 double in )

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

[SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainWindow');

%% Check Valid Inputs 

[TimeToPlot] = Utility_SimpleCheckInputs(TimeToPlot,"Two",strcat('-0.005,0.005'),0,1);

%% Extract and compute Time windw Info
commaindicie = find(TimeToPlot == ',');
TimeToPlotDouble(1) = str2double(TimeToPlot(1:commaindicie(1)-1));
TimeToPlotDouble(2) = str2double(TimeToPlot(commaindicie(1)+1:end));

ArtefactTimeRange = str2double(strsplit(ArtefactTimeEditField,','))';

StimArtefactInfo.TimeAroundEvents(1) = round(abs(ArtefactTimeRange(1))*Data.Info.NativeSamplingRate);
StimArtefactInfo.TimeAroundEvents(2) = round(abs(ArtefactTimeRange(2))*Data.Info.NativeSamplingRate);

ArtefactTimeRange = ArtefactTimeRange*1000; % convert in ms -- just to plot here

%convert to samples
SamplesToPlot(1) = round(abs(TimeToPlotDouble(1))*Data.Info.NativeSamplingRate);
SamplesToPlot(2) = round(abs(TimeToPlotDouble(2))*Data.Info.NativeSamplingRate);

PlotTimeVector = ((-SamplesToPlot(1):SamplesToPlot(2)) / Data.Info.NativeSamplingRate)*1000;% in ms

numtimepoints = length(PlotTimeVector);

%% Determine selected events
% not necesary i startup but later: get event number user selected
SelectedEventIndicie = [];
for neventchannel = 1:length(Data.Events)
    if strcmp(EventChannelforStimulationDropDown,Data.Info.EventChannelNames{neventchannel})
        SelectedEventIndicie = neventchannel;
        StimArtefactInfo.SelectedEventChannelName = EventChannelforStimulationDropDown;
    end
end

%% Extract Data around stimulation event
% Raw Data
ArtefactRelatedData = NaN(length(SelectedChannel),numtimepoints,length(Data.Events{SelectedEventIndicie}));

Eventsoutside = [];
for nevents = 1:length(Data.Events{SelectedEventIndicie})
    if Data.Events{SelectedEventIndicie}(nevents)-SamplesToPlot(1) > 0 && Data.Events{SelectedEventIndicie}(nevents)+SamplesToPlot(2) < size(Data.Raw,2)
        ArtefactRelatedData(1:length(SelectedChannel),1:numtimepoints,nevents) = Data.Raw(SelectedChannel,Data.Events{SelectedEventIndicie}(nevents)-SamplesToPlot(1):Data.Events{SelectedEventIndicie}(nevents)+SamplesToPlot(2));;
    else
        Eventsoutside = [Eventsoutside,nevents];
    end
end

if ~isempty(Eventsoutside)
    msgbox(strcat("Boundaries for event nr. ",num2str(Eventsoutside)," violate time limits. Data around event not extracted."))
end

%% Select Data based on user input
PlotData = [];

if strcmp(EventstoPlotDropDown,"Mean over all Trigger")
    PlotData = mean(ArtefactRelatedData,3);
else
    PlotData = ArtefactRelatedData(:,:,str2double(EventstoPlotDropDown));
end

%% Add ChannelSapcing for proper plot
for i = 1:size(PlotData,1)     
    PlotData(i, :) = PlotData(i, :) - (i - 1) * SpacingSlider;
end

%% Plot Data

colorMap = eval(strcat("parula","(size(PlotData,1))")); % Example colormap: You can use any other colormap

ArtefactData_handles = findobj(Figure, 'Tag', 'TracesAroundArtefacts');
EventData_handles = findobj(Figure, 'Tag', 'EventLine');
ArtefactLine_handles = findobj(Figure, 'Tag', 'ArtefactLine');

Figure.FontSize = 10;
xlabel(Figure,"Time [ms]")
ylabel(Figure,"Channel")
xlim(Figure,[PlotTimeVector(1),PlotTimeVector(end)])
ylim(Figure,[min(PlotData,[],'all') max(PlotData,[],'all')]);
Figure.XLabel.Color = [0 0 0];
Figure.YLabel.Color = [0 0 0];       
Figure.YColor = 'k';  
%UIAxes.XTickLabelMode = 'auto';
Figure.XColor = 'k';  
Figure.Title.Color = 'k';  
Figure.Box ="off";

if isempty(ArtefactData_handles)
    for i = 1:size(PlotData,1) % over channel for costum color
        line(Figure,PlotTimeVector,PlotData(i,:),'Color',colorMap(i,:),'LineWidth',1,'Tag',"TracesAroundArtefacts")
    end
    % Red event line in middle
    line(Figure,[0,0],[min(PlotData,[],'all') max(PlotData,[],'all')],'Tag','EventLine','LineWidth',2,'Color','r');
    % Artefact time range
    line(Figure,[ArtefactTimeRange(1),ArtefactTimeRange(1)],[min(PlotData,[],'all') max(PlotData,[],'all')],'Tag','ArtefactLine','LineWidth',2,'Color','k');
    line(Figure,[ArtefactTimeRange(2),ArtefactTimeRange(2)],[min(PlotData,[],'all') max(PlotData,[],'all')],'Tag','ArtefactLine','LineWidth',2,'Color','k');
    
    ArtefactData_handles = findobj(Figure, 'Tag', 'TracesAroundArtefacts');
    EventData_handles = findobj(Figure, 'Tag', 'EventLine');
    ArtefactLine_handles = findobj(Figure, 'Tag', 'ArtefactLine');

    legend(Figure,[EventData_handles, ArtefactLine_handles(1), ArtefactLine_handles(2)], {'Event', 'Artefact Start', 'Artefact End'}, 'Location', 'northeast');

else
    if length(ArtefactData_handles)>size(PlotData,1)
        delete(ArtefactData_handles(size(PlotData,1)+1:end));
        ArtefactData_handles = findobj(Figure, 'Tag', 'TracesAroundArtefacts');
    end

    if length(EventData_handles)>1
        delete(EventData_handles(2:end));
    end

    for i = 1:size(PlotData,1)
        if length(ArtefactData_handles) >= i
            set(ArtefactData_handles(i), 'XData', PlotTimeVector, 'YData', PlotData(i,:),'Color',colorMap(i,:), 'Tag', 'TracesAroundArtefacts','LineWidth',1);
        else
            line(Figure,PlotTimeVector,PlotData(i,:),'Color',colorMap(i,:),'LineWidth',1,'Tag',"TracesAroundArtefacts")
        end
    end

    set(EventData_handles(1), 'XData', [0,0], 'YData', [min(PlotData,[],'all') max(PlotData,[],'all')], 'Tag', 'EventLine','LineWidth',2,'Color','r');
    eventline = EventData_handles(1);

    if length(ArtefactLine_handles)>2
        delete(ArtefactLine_handles(3:end));
    end

    % Artefact time range
    set(ArtefactLine_handles(1), 'XData', [ArtefactTimeRange(1),ArtefactTimeRange(1)], 'YData', [min(PlotData,[],'all') max(PlotData,[],'all')], 'Tag', 'ArtefactLine','LineWidth',2,'Color','k');
    set(ArtefactLine_handles(2), 'XData', [ArtefactTimeRange(2),ArtefactTimeRange(2)], 'YData', [min(PlotData,[],'all') max(PlotData,[],'all')], 'Tag', 'ArtefactLine','LineWidth',2,'Color','k');
    Artefactline1 = ArtefactLine_handles(1);
    Artefactline2 = ArtefactLine_handles(2);

    % Bring Event Line to the front
    uistack(eventline, 'top');
    uistack(Artefactline1, 'top');
    uistack(Artefactline2, 'top');
    % Add legend for the three specific lines
    legend(Figure,[eventline, Artefactline1, Artefactline2], {'Trigger', 'Artefact Start', 'Artefact End'}, 'Location', 'northeast');
end

% Custom YLabels

Utility_Set_YAxis_Depth_Labels(Data,Figure,[],ActiveChannel,PreserveChannelLocations)

Figure.YTickLabel = flip(Figure.YTickLabel);