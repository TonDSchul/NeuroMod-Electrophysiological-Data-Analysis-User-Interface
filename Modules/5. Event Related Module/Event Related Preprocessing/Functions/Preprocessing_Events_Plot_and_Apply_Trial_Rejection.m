function [EventRelatedData,EventsToPlot,TrialsToReject,ThresCrossingTrials] = Preprocessing_Events_Plot_and_Apply_Trial_Rejection(Data,EventRelatedData,Time,Type,TopFigure,BottomFigure,ChannelSelection,TrialsToReject,EventsToPlot,PlotThreshold,Threshold,EventChannelname)

%________________________________________________________________________________________
%% Function to apply and plot event/trial rejection
% This function simply deletes events selected and replots the broandband
% and ERP plot 

% called when the user enters a value in the trial rejection edit field of
% the trial rejection window

% Inputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with event
% related data
% 2. Time: 1 x ntime double with time values for each time point of event
% realted data ('real' time with negative values)
% 3. Type: char, only 'Plot so far'
% 4. TopFigure: Figure axes handle to top figure of trial rejection window
% plotting ERP
% 5. BottomFigure: Figure axes handle to bottom figure of trial rejection window
% plotting broadband signal
% 6. ChannelSelection: Channel to plot; char with single number like '10' NOTE: Only for Plotting! Rejection
% is done for all channel automatically
% 7. TrialsToReject: char with trial selection of preprocessing window, as
% char, i.e. '1,10' for events 1 to 10
% 8. EventsToPlot: double vector, sets events to plot since plotting can slow down
% everything considerably when having a lot of events.
% 9. PlotThreshold: logical 1 or 0 (empty for non)
% 10. Threshold: double, threshold to automatically detect trials to delete
% 11. EventChannelname: char, name of event channel for which trials are
% rejected

% Outputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with modified event
% related data
% 2. Error: double, 1 if error occured and preprocessing was not applied, 0
% otherwise -- occurs when event selection format wrong

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% if not threshold value but plot threshold is set to 1
if PlotThreshold == 1 && isempty(Threshold)
    PlotThreshold = 0;
end

ThresCrossingTrials = [];
Error = 0;

OriginalChannelSelection = ChannelSelection;
if Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
    TempActiveChannel = (str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows)+1)-sort(Data.Info.ProbeInfo.ActiveChannel);
    [ChannelSelection] = Organize_Convert_ActiveChannel_to_DataChannel(TempActiveChannel,str2double(ChannelSelection),'MainPlot');
    ChannelSelection = num2str(ChannelSelection);
else
    [ChannelSelection] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,str2double(ChannelSelection),'MainPlot');
    ChannelSelection = num2str(ChannelSelection);
end

ChannelSelection = str2double(ChannelSelection);

%extract trheshold
if ~isempty(Threshold)
    Threshold = str2double(Threshold);
    if isnan(Threshold)
        Threshold = [];
    end
else
    Threshold = [];
end

%% Get Trials to reject
if ~isempty(TrialsToReject)
    try
        TrialsToReject = eval(TrialsToReject);
        TrialsToReject = sort(TrialsToReject);
    catch
        TrialsToReject = [];
        disp("Warning: trigger to reject could not be determined. Taking no trigger as default!")
    end
else
    TrialsToReject = [];
    disp("Warning: trigger to reject could not be determined. Taking no trigger as default!")
end

%% Get Trials to Plot
if ~isempty(EventsToPlot)
    try
        EventsToPlot = eval(EventsToPlot);
    catch
        EventsToPlot = 1:size(EventRelatedData,2);
        msgbox("Warning: trigger to plot could not be determined. Taking all trigger as default!")
    end
else
    EventsToPlot = 1:size(EventRelatedData,2);
    msgbox("Warning: trigger to plot could not be determined. Taking all trigger as default!")
end

%% ------------------------------------------------
%% ---------------- Check If selected trials where already deleted ----------------
%% ------------------------------------------------
AlreadyRejectedTrials = [];
if isfield(Data.Info,'EventRelatedPreprocessing')
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials')
        % Find rejection indices for the currently selected event channel
        Namevector = split(string(Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames), ',');
        TrialrejectionindiciesCurrentChannel = find(Namevector == EventChannelname);
        % Select trials if event channel found
        if ~isempty(TrialrejectionindiciesCurrentChannel)
            AlreadyRejectedTrials = Data.Info.EventRelatedPreprocessing.TrialRejectionTrials(TrialrejectionindiciesCurrentChannel);
        else
            AlreadyRejectedTrials = [];
        end
    end
end
if ~isempty(TrialsToReject) 
    % check if trials where already deleted
    if ~isempty(AlreadyRejectedTrials)
        if ~isempty(intersect(AlreadyRejectedTrials, TrialsToReject))
            msgbox(strcat("Error: Trial(s) number ",num2str(intersect(AlreadyRejectedTrials, TrialsToReject))," where already deleted! Returning"));
            return;
        end
    end
end

%% ------------------------------------------------
%% ---------------- Set up vector with all presevered trial identities ----------------
%% ------------------------------------------------
% get original trial number and delte trial numbers for ylabel of broadband
% plot
EventChannelnr = [];
for i = 1:length(Data.Info.EventChannelNames)
    if strcmp(Data.Info.EventChannelNames{i},EventChannelname)
        EventChannelnr = i;
    end
end

% delete already rejected trials

% if ~isempty(AlreadyRejectedTrials)
%     AllTrials(AlreadyRejectedTrials) = [];
% end

% delete TrialRejection
AllTrials = 1:size(EventRelatedData,2);
IndiceToDelete = [];
if ~isempty(TrialsToReject)
    for i = 1:length(TrialsToReject)
        IndiceToDelete = [IndiceToDelete,find(AllTrials==TrialsToReject(i))];
        AllTrials(find(AllTrials==TrialsToReject(i))) = NaN;
        EventRelatedData(:,find(AllTrials==TrialsToReject(i)),:) = NaN;
    end
end

AllTrials2 = 1:length(AllTrials);

%% ---------------- Set Data at deleted trial indicies to NaN ----------------
%IndiciesToDelete = zeros(size(EventRelatedData,2),1);

%IndiciesToDelete(EventsToPlot) = 0;

%IndiciesToDelete(IndiceToDelete) = 1;

%EventRelatedData(:,IndiciesToDelete==1,:) = NaN;

%% ------------------------------------------------
%% ---------------- Check Threshold Crossings ----------------
%% ------------------------------------------------
for ntrials = AllTrials
    if ~isnan(ntrials) %~isnan(AllTrials(ntrials))
        if max(EventRelatedData(ChannelSelection,ntrials,:)) > abs(Threshold) || min(EventRelatedData(ChannelSelection,ntrials,:)) < -abs(Threshold)
            ThresCrossingTrials = [ThresCrossingTrials,ntrials];
        end
    end
end

EventRelatedData(:,isnan(AllTrials),:) = [];

if length(EventsToPlot)>size(EventRelatedData,2)
    EventsToPlot(EventsToPlot>size(EventRelatedData,2)) = [];
    EventRelatedData = EventRelatedData(:,EventsToPlot,:);
else
    EventRelatedData = EventRelatedData(:,EventsToPlot,:);
end

AllTrials(isnan(AllTrials))=[];
AllTrials2(isnan(AllTrials2))=[];

AllTrials = AllTrials(EventsToPlot);
AllTrials2 = AllTrials2(EventsToPlot);

NumTrials = length(AllTrials);



%% ------------------------------------------------
%% ---------------- Plotting ----------------
%% ------------------------------------------------

%% Check if Trials to be rejected are within trialrange of dataset
if size(EventRelatedData,2)>1
    ERP = mean(squeeze(EventRelatedData(ChannelSelection,:,:)),1,'omitnan');
else % just one trial
    ERP = squeeze(EventRelatedData(ChannelSelection,:,:));
end
%% Plot Broadband
hold(TopFigure, 'on' )
cla(TopFigure);
TopFigure.NextPlot = "replace";
if size(EventRelatedData,2)>1
    imagesc(TopFigure,Time ,1:size(squeeze(EventRelatedData(ChannelSelection,:,:)),1),squeeze(EventRelatedData(ChannelSelection,:,:)))
else % just one trial
    imagesc(TopFigure,Time ,1:size(squeeze(EventRelatedData(ChannelSelection,:,:))',1),squeeze(EventRelatedData(ChannelSelection,:,:))')
end
set(TopFigure,'YDir','normal');
titlestring = strcat("Broadband Plot Channel ",OriginalChannelSelection);
TopFigure.FontSize = 10;
xline(TopFigure,0,'Color','k','LineStyle','--','LineWidth',2);
ylabel(TopFigure,'Trial Identities (Trial Number)')
title(TopFigure,titlestring)
xlabel(TopFigure,'Time [s]')
xlim(TopFigure,[Time(1) Time(end)]); % since this signal was low pass filtered at 200Hz
if size(squeeze(EventRelatedData(ChannelSelection,:,:)),1) ~= 1
    ylim(TopFigure,[1 size(squeeze(EventRelatedData(ChannelSelection,:,:)),1)]); % since this signal was low pass filtered at 200Hz
elseif size(squeeze(EventRelatedData(ChannelSelection,:,:)),1) == 1
    ylim(TopFigure,[0.5 1.5]); % since this signal was low pass filtered at 200Hz
end

cbar_handle=colorbar('peer',TopFigure,'location','EastOutside');
cbar_handle.Label.String = "Signal [mV/mm^2]";
cbar_handle.Label.Rotation = 270;
cbar_handle.Label.Color = 'k';   
cbar_handle.Color = 'k';   
TopFigure.XLabel.Color = [0 0 0];
TopFigure.XColor = [0 0 0];
TopFigure.YLabel.Color = [0 0 0];
TopFigure.YColor = [0 0 0];
TopFigure.Title.Color  = [0 0 0];
TopFigure.Box  = 0;
ylim(TopFigure,[0.5,min(length(AllTrials),length(EventsToPlot))+0.5])
drawnow;
%% costume y labels
a = string(AllTrials);
b = string(AllTrials2);

for i = 1:length(a)
    a(i) = strcat(a(i),'(',b(i),')');
end

if length(EventsToPlot)>50
    atemp = [];
    for i = 1:10:length(a)
        atemp = [atemp,a(i)];
    end
    TopFigure.YTick = 1:10:length(a);
    TopFigure.YTickLabel = string(atemp);
else
    TopFigure.YTick = 1:length(a);
    TopFigure.YTickLabel = string(a);
end

hold(TopFigure, 'off' )
%% ERP
TrialsHandle = findobj(BottomFigure, 'Tag', 'Trials');
ERPHandle = findobj(BottomFigure, 'Tag', 'ERP');
EventHandle = findobj(BottomFigure, 'Tag', 'Eventline');
ThreshHandle = findobj(BottomFigure, 'Tag', 'Thresh');

if length(ThreshHandle)>2
    delete(ThreshHandle(3:end));
    ThreshHandle = findobj(BottomFigure, 'Tag', 'Thresh');
end
if length(ERPHandle)>1
    delete(ERPHandle(2:end));
    ERPHandle = findobj(BottomFigure, 'Tag', 'ERP');
end
if length(EventHandle)>1
    delete(EventHandle(2:end));
    EventHandle = findobj(BottomFigure, 'Tag', 'Eventline');
end
if length(TrialsHandle)>NumTrials
    delete(TrialsHandle(NumTrials+1:end));
    TrialsHandle = findobj(BottomFigure, 'Tag', 'Trials');
end
% plot threshold
if PlotThreshold == 1 
    if isempty(ThreshHandle)
        threshline(1) = line(BottomFigure,[Time(1),Time(end)],[Threshold,Threshold],'Color','g','LineStyle','--','LineWidth',2,'Tag','Thresh');
        threshline(2) = line(BottomFigure,[Time(1),Time(end)],[-Threshold,-Threshold],'Color','g','LineStyle','--','LineWidth',2,'Tag','Thresh');
    else
        set(ThreshHandle(1), 'XData', [Time(1),Time(end)], 'YData',[Threshold,Threshold],'Color','g','LineStyle','--','LineWidth',2,'Tag','Thresh');
        set(ThreshHandle(2), 'XData', [Time(1),Time(end)], 'YData',[-Threshold,-Threshold],'Color','g','LineStyle','--','LineWidth',2,'Tag','Thresh');
        threshline = ThreshHandle;
    end
    
end
% plot events
if isempty(EventHandle)
    eventline = line(BottomFigure,[0,0],[min(EventRelatedData,[],'all') max(EventRelatedData,[],'all')],'Color','k','LineStyle','--','LineWidth',2,'Tag','Eventline');
else
    set(EventHandle(1), 'XData', [0,0], 'YData',[min(EventRelatedData,[],'all') max(EventRelatedData,[],'all')],'Color','k','LineStyle','--','LineWidth',2,'Tag','Eventline');
    eventline = EventHandle(1);
end
% plot erp mean
if isempty(ERPHandle)
    MeanERP = line(BottomFigure,Time,ERP,'Color','k','LineWidth',2, 'Tag', 'ERP');
else
    set(ERPHandle(1), 'XData', Time, 'YData',ERP,'Color','k','LineWidth',2, 'Tag', 'ERP');
    MeanERP = ERPHandle(1);
end

% plot trials
for i = 1:size(EventRelatedData,2) % loop over trials
    if isempty(TrialsHandle)
        h = line(BottomFigure,Time,squeeze(EventRelatedData(ChannelSelection,i,:)),'LineWidth',.5,'Tag','Trials');
        set(h,'color',[1 1 1]*.75);
    else
        if i<=length(TrialsHandle)
            set(TrialsHandle(i), 'XData', Time, 'YData',squeeze(EventRelatedData(ChannelSelection,i,:)),'Color',[1 1 1]*.75,'LineWidth',.5,'Tag','Trials');
            h(1) = TrialsHandle(1);
        else
            line(BottomFigure,Time,squeeze(EventRelatedData(ChannelSelection,i,:)),'Color',[1 1 1]*.75,'LineWidth',.5,'Tag','Trials');
        end
    end
end

% Bring Event Line to the front

uistack(MeanERP, 'top');
uistack(eventline, 'top');

if PlotThreshold == 1 
    uistack(threshline, 'top');
end

BottomFigure.FontSize = 11;
titlestring = strcat("ERP Channel ",OriginalChannelSelection);
title(BottomFigure,titlestring);
xlim(BottomFigure,[min(Time) max(Time)]);
ylim(BottomFigure,[min(min(squeeze(EventRelatedData(ChannelSelection,:,:)))) max(max(squeeze(EventRelatedData(ChannelSelection,:,:))))]);
xlabel(BottomFigure,'Time [s]');
ylabel(BottomFigure,'Potential [mV]');
BottomFigure.XLabel.Color = [0 0 0];
BottomFigure.XColor = [0 0 0];
BottomFigure.YLabel.Color = [0 0 0];
BottomFigure.YColor = [0 0 0];
BottomFigure.Title.Color  = [0 0 0];
BottomFigure.Box  = 0;


if PlotThreshold == 1 
    % Add legend only once
    if isempty(findobj(BottomFigure, 'Type', 'legend'))
        try
            % Create legend and then set its 'HandleVisibility' to 'off'
            legendHandle = legend([h(1), MeanERP, eventline,threshline(1)], {'Trials/Events', 'ERP', 'Trigger', 'Thresh'});
            set(legendHandle, 'HandleVisibility', 'off');
        end
    end
else
    % Add legend only once
    if isempty(findobj(BottomFigure, 'Type', 'legend'))
        try
            % Create legend and then set its 'HandleVisibility' to 'off'
            legendHandle = legend([h(1), MeanERP, eventline], {'Trials/Events', 'ERP', 'Trigger'});
            set(legendHandle, 'HandleVisibility', 'off');
        end
    end
end

hold(BottomFigure, 'off' );