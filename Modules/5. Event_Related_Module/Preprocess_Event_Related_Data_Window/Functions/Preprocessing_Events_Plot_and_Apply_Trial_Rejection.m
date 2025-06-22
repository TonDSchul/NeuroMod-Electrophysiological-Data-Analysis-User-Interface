function [EventRelatedData,Error,Trialselectionfield] = Preprocessing_Events_Plot_and_Apply_Trial_Rejection(Data,EventRelatedData,Time,Type,TopFigure,BottomFigure,ChannelSelection,TrialsToReject,EventsToPlot)

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
% 3. Type: char, determines what is done her, Either 'OnlyReject' OR 'RejectandPlot' OR 'Plot'
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

% Outputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with modified event
% related data
% 2. Error: double, 1 if error occured and preprocessing was not applied, 0
% otherwise -- occurs when event selection format wrong

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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

if strcmp(Type,'OnlyReject') || strcmp(Type,'RejectandPlot')

    [~,NrTrials,~] = size(EventRelatedData);

    %% Check TrialSelection

    Input = TrialsToReject;
    Error = 0;
    
    Trialselectionfield = Input;


    %% Check if Trials to be rejected are within trialrange of dataset

    if length(EventsToPlot)>size(EventRelatedData,2) || sum(EventsToPlot>size(EventRelatedData,2))
        msgbox("Error: One or more trigger not in range of available trigger!");
        Trialselectionfield = '1:1';
        return;
    end

    if length(EventsToPlot) == size(EventRelatedData,2)
        msgbox("Error: Not possible to reject all Trials!");
        Trialselectionfield = '1:1';
        return;
    end

    EventRelatedData(:,EventsToPlot,:) = [];

end

if strcmp(Type,'Plot') || strcmp(Type,'RejectandPlot')

    Input = TrialsToReject;
    Error = 0;
    
    Trialselectionfield = Input;

    %% Check if Trials to be rejected are within trialrange of dataset

    % if length(EventsToPlot)>size(EventRelatedData,2) || sum(EventsToPlot>size(EventRelatedData,2))
    %     msgbox("Error: One or more trigger not in range of available trigger!");
    %     Trialselectionfield = '';
    %     return;
    % end
    % 
    % if length(EventsToPlot) == size(EventRelatedData,2)
    %     msgbox("Error: Not possible to reject all Trials!");
    %     Trialselectionfield = '';
    %     return;
    % end

    ERP = mean(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),1);

    %% Plot Broadband
    hold(TopFigure, 'on' )
    cla(TopFigure);
    TopFigure.NextPlot = "replace";
    imagesc(TopFigure,Time ,1:size(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),1),squeeze(EventRelatedData(str2double(ChannelSelection),:,:)))
    set(TopFigure,'YDir','normal');
    titlestring = strcat("Broadband Plot Channel ",OriginalChannelSelection);
    TopFigure.FontSize = 10;
    xline(TopFigure,0,'Color','k','LineStyle','--','LineWidth',2);
    ylabel(TopFigure,'Trials/Events')
    title(TopFigure,titlestring)
    xlabel(TopFigure,'Time [s]')
    xlim(TopFigure,[Time(1) Time(end)]); % since this signal was low pass filtered at 200Hz
    if size(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),1) ~= 1
        ylim(TopFigure,[1 size(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),1)]); % since this signal was low pass filtered at 200Hz
    elseif size(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),1) == 1
        ylim(TopFigure,[0.5 1.5]); % since this signal was low pass filtered at 200Hz
    end

    cbar_handle=colorbar('peer',TopFigure,'location','EastOutside');
    cbar_handle.Label.String = "Signal [mV/mm^2]";
    cbar_handle.Label.Rotation = 270;
    hold(TopFigure, 'off' )

    %% ERP
    TrialstoPlot = size(EventRelatedData,2);

    TrialsHandle = findobj(BottomFigure, 'Tag', 'Trials');
    ERPHandle = findobj(BottomFigure, 'Tag', 'ERP');
    EventHandle = findobj(BottomFigure, 'Tag', 'Eventline');
    
    if length(ERPHandle)>1
        delete(ERPHandle(2:end));
        ERPHandle = findobj(BottomFigure, 'Tag', 'ERP');
    end
    if length(EventHandle)>1
        delete(EventHandle(2:end));
        EventHandle = findobj(BottomFigure, 'Tag', 'Eventline');
    end
    if length(TrialsHandle)>length(TrialstoPlot)
        delete(TrialsHandle(length(TrialstoPlot)+1:end));
        TrialsHandle = findobj(BottomFigure, 'Tag', 'Trials');
    end

    if isempty(EventHandle)
        eventline = line(BottomFigure,[0,0],[min(EventRelatedData,[],'all') max(EventRelatedData,[],'all')],'Color','k','LineStyle','--','LineWidth',2,'Tag','Eventline');
    else
        set(EventHandle(1), 'XData', [0,0], 'YData',[min(EventRelatedData,[],'all') max(EventRelatedData,[],'all')],'Color','k','LineStyle','--','LineWidth',2,'Tag','Eventline');
        eventline = EventHandle(1);
    end

    if isempty(ERPHandle)
        MeanERP = line(BottomFigure,Time,ERP,'Color','k','LineWidth',2, 'Tag', 'ERP');
    else
        set(ERPHandle(1), 'XData', Time, 'YData',ERP,'Color','k','LineWidth',2, 'Tag', 'ERP');
        MeanERP = ERPHandle(1);
    end
    
    for i = 1:length(TrialstoPlot) % loop over trials
        if isempty(TrialsHandle)
            h = line(BottomFigure,Time,squeeze(EventRelatedData(str2double(ChannelSelection),TrialstoPlot,:)),'LineWidth',.5,'Tag','Trials');
            set(h,'color',[1 1 1]*.75);
        else
            if i<=length(TrialsHandle)
                set(TrialsHandle(i), 'XData', Time, 'YData',squeeze(EventRelatedData(str2double(ChannelSelection),TrialstoPlot(i),:)),'Color',[1 1 1]*.75,'LineWidth',.5,'Tag','Trials');
                h(1) = TrialsHandle(1);
            else
                line(BottomFigure,Time,squeeze(EventRelatedData(str2double(ChannelSelection),TrialstoPlot(i),:)),'Color',[1 1 1]*.75,'LineWidth',.5,'Tag','Trials');
            end
        end
    end
    
    % Bring Event Line to the front

    uistack(MeanERP, 'top');
    uistack(eventline, 'top');

    BottomFigure.FontSize = 11;
    titlestring = strcat("ERP Channel ",OriginalChannelSelection);
    title(BottomFigure,titlestring);
    xlim(BottomFigure,[min(Time) max(Time)]);
    ylim(BottomFigure,[min(min(squeeze(EventRelatedData(str2double(ChannelSelection),TrialstoPlot,:)))) max(max(squeeze(EventRelatedData(str2double(ChannelSelection),TrialstoPlot,:))))]);
    xlabel(BottomFigure,'Time [s]');
    ylabel(BottomFigure,'Potential [mV]');

    % Add legend only once
    if isempty(findobj(BottomFigure, 'Type', 'legend'))
        % Create legend and then set its 'HandleVisibility' to 'off'
        legendHandle = legend([h(1), MeanERP, eventline], {'Trials/Events', 'ERP', 'Trigger'});
        set(legendHandle, 'HandleVisibility', 'off');
    end

    hold(BottomFigure, 'off' );

end