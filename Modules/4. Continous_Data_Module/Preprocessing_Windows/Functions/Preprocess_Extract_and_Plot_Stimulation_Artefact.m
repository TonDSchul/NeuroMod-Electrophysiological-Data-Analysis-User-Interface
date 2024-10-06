function [ArtefactRelatedData,StimArtefactInfo] = Preprocess_Extract_and_Plot_Stimulation_Artefact(Data, TimeAroundEventsEditField, EventChannelforStimulationDropDown, EventstoPlotDropDown, SpacingSlider, Figure)

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
% event channel. Either 'Mean over all Events' OR the number of the
% event,i.e. '1' for the first ttl
% 5. SpacingSlider: double, spacing between channel for plotting
% 6. Figure: figure object handle to plot data (in seconds)

% Output: 
% 1. ArtefactRelatedData: nchannel x ntime x nevents matrix containg the data that is plotted. 
% 2. StimArtefactInfo: strcuture holding info necessray to apply artefact
% rejection to the dataset when the user adds it to the preprocessing
% pipeline. Fields are: StimArtefactInfo.SelectedEventChannelName (char)
% and StimArtefactInfo.TimeAroundEvents (1 x 2 double in )

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Check Valid Inputs 

[TimeAroundEventsEditField] = Utility_SimpleCheckInputs(TimeAroundEventsEditField,"Two",strcat('-0.005,0.005'),0,1);

%% Extract and compute Time windw Info
commaindicie = find(TimeAroundEventsEditField == ',');
TimeAroundEvent(1) = str2double(TimeAroundEventsEditField(1:commaindicie(1)-1));
TimeAroundEvent(2) = str2double(TimeAroundEventsEditField(commaindicie(1)+1:end));

%convert to samples
StimArtefactInfo.TimeAroundEvents(1) = round(abs(TimeAroundEvent(1))*Data.Info.NativeSamplingRate);
StimArtefactInfo.TimeAroundEvents(2) = round(abs(TimeAroundEvent(2))*Data.Info.NativeSamplingRate);

PlotTimeVector = (TimeAroundEvent(1):1/Data.Info.NativeSamplingRate:TimeAroundEvent(2))*1000; % in ms

numtimepoints = round((abs(TimeAroundEvent(1))+abs(TimeAroundEvent(2)))*Data.Info.NativeSamplingRate)+1;

%% Determine selected channel
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
ArtefactRelatedData = NaN(size(Data.Raw,1),numtimepoints,length(Data.Events{SelectedEventIndicie}));

Eventsoutside = [];
for nevents = 1:length(Data.Events{SelectedEventIndicie})
    if Data.Events{SelectedEventIndicie}(nevents)-StimArtefactInfo.TimeAroundEvents(1) > 0 && Data.Events{SelectedEventIndicie}(nevents)+StimArtefactInfo.TimeAroundEvents(2) < size(Data.Raw,2)
        ArtefactRelatedData(1:size(Data.Raw,1),1:numtimepoints,nevents) = Data.Raw(:,Data.Events{SelectedEventIndicie}(nevents)-StimArtefactInfo.TimeAroundEvents(1):Data.Events{SelectedEventIndicie}(nevents)+StimArtefactInfo.TimeAroundEvents(2));;
    else
        Eventsoutside = [Eventsoutside,nevents];
    end
end

if ~isempty(Eventsoutside)
    msgbox(strcat("Boundaries for event nr. ",num2str(Eventsoutside)," violate time limits. Data around event not extracted."))
end

%% Select Data based on user input
PlotData = [];

if strcmp(EventstoPlotDropDown,"Mean over all Events")
    PlotData = mean(ArtefactRelatedData,3);
else
    PlotData = ArtefactRelatedData(:,:,str2double(EventstoPlotDropDown));
end

%% Add ChannelSapcing for proper plot
for i = 1:size(PlotData,1)     
    PlotData(i, :) = PlotData(i, :) - (i - 1) * SpacingSlider;
end

%% Plot Data

ArtefactData_handles = findobj(Figure, 'Tag', 'TracesAroundArtefacts');
EventData_handles = findobj(Figure, 'Tag', 'EventLine');

xlabel(Figure,"Time [ms]")
ylabel(Figure,"Channel")
xlim(Figure,[PlotTimeVector(1),PlotTimeVector(end)])

if isempty(ArtefactData_handles)
    line(Figure,PlotTimeVector,PlotData,'LineWidth',1,'Tag',"TracesAroundArtefacts")
    line(Figure,[0,0],[min(PlotData,[],'all') max(PlotData,[],'all')],'Tag','EventLine');
else
    if length(ArtefactData_handles)>size(PlotData,1)
        delete(ArtefactData_handles(size(PlotData,1)+1:end));
    end
    if length(EventData_handles)>1
        delete(EventData_handles(2:end));
    end
    for i = 1:length(ArtefactData_handles)
        set(ArtefactData_handles(i), 'XData', PlotTimeVector, 'YData', PlotData(i,:), 'Tag', 'TracesAroundArtefacts','LineWidth',1);
    end
    set(EventData_handles(1), 'XData', [0,0], 'YData', [min(PlotData,[],'all') max(PlotData,[],'all')], 'Tag', 'EventLine','LineWidth',1.5);
    eventline = EventData_handles(1);
    % Bring Event Line to the front
    uistack(eventline, 'top');
    ylim(Figure,[min(PlotData,[],'all') max(PlotData,[],'all')]);
end