function [EventRelatedData,Error,Trialselectionfield] = Preprocessing_Events_Plot_and_Apply_Trial_Rejection(EventRelatedData,Time,Type,TopFigure,BottomFigure,ChannelSelection,TrialsToReject)

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

% Outputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with modified event
% related data
% 2. Error: double, 1 if error occured and preprocessing was not applied, 0
% otherwise -- occurs when event selection format wrong

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

Error = 0;

if strcmp(Type,'OnlyReject') || strcmp(Type,'RejectandPlot')

    [~,NrTrials,~] = size(EventRelatedData);

    %% Check TrialSelection

    Input = TrialsToReject;
    Error = 0;

    if isempty(Input) == 0 % If Trialselection field filled (empty = All Trials)
        [TrialsToReject] = Utility_SimpleCheckInputs(TrialsToReject,"Two",strcat('1,',num2str(NrTrials)),1,0);
    end

    Trialselectionfield = TrialsToReject; 

    %% Get Trials to be Rejected if Selection field in GUI is filled
    if isempty(Trialselectionfield) == 0
        value = Trialselectionfield;
        indicesep = find(value == ',');
        RejectedTrialsofInterest(1,1) = str2double(value(1:indicesep(1)-1));
        RejectedTrialsofInterest(1,2) = str2double(value(indicesep+1:end));
    else
        msgbox("Error: Please Input Trials to reject first in the format: 1,10 or 1,1");
        return;
    end

    %% Check if Trials to be rejected are within trialrange of dataset
    Trialsavailable(1) = 1;
    Trialsavailable(2) = NrTrials;
    
    if RejectedTrialsofInterest(2) > Trialsavailable(2) 
        f = msgbox("Error: Selected Trials not in Range");
        return;
    elseif RejectedTrialsofInterest(1) > Trialsavailable(2) 
        f = msgbox("Error: Selected Trials not in Range");
        return;
    elseif RejectedTrialsofInterest(1) == 1 && RejectedTrialsofInterest(2)  == NrTrials
       f = msgbox("Error: Not possible to reject all Trials");
       return;
    end

    EventRelatedData(:,RejectedTrialsofInterest(1):RejectedTrialsofInterest(2),:) = [];

end

if strcmp(Type,'Plot') || strcmp(Type,'RejectandPlot')

    Input = TrialsToReject;
    Error = 0;
    
    if isempty(Input) == 0 % If Trialselection field filled (empty = All Trials)
        [TrialsToReject] = Utility_SimpleCheckInputs(TrialsToReject,"Two",strcat('1,',num2str(NrTrials)),1,0);
    end

    Trialselectionfield = TrialsToReject; 

    ERP = mean(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),1);

    %% Plot Broadband
    hold(TopFigure, 'on' )
    TopFigure.NextPlot = "replace";
    imagesc(TopFigure,Time ,1:size(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),1),squeeze(EventRelatedData(str2double(ChannelSelection),:,:)))
    set(TopFigure,'YDir','normal');
    titlestring = strcat("Broadband Plot Channel ",ChannelSelection);
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
    hold(BottomFigure, 'on' );
    % ERP
    BottomFigure.NextPlot = "replace"; 
    plot(BottomFigure,Time,ERP,'k','linew',3);
    BottomFigure.NextPlot = "add"; 
    xline(BottomFigure,0,'Color','k','LineStyle','--','LineWidth',2);
    h = plot(BottomFigure,Time,squeeze(EventRelatedData(str2double(ChannelSelection),:,:)),'linew',.5);
    BottomFigure.FontSize = 10;
    set(h,'color',[1 1 1]*.75);
    plot(BottomFigure,Time,ERP,'k','linew',3);
    titlestring = strcat("ERP Channel ",ChannelSelection);
    title(BottomFigure,titlestring);
    xlim(BottomFigure,[min(Time) max(Time)]);
    ylim(BottomFigure,[min(min(squeeze(EventRelatedData(str2double(ChannelSelection),:,:)))) max(max(squeeze(EventRelatedData(str2double(ChannelSelection),:,:))))]);
    xlabel(BottomFigure,'Time [s]');
    ylabel(BottomFigure,'Potential [mV]');
    hold(BottomFigure, 'off' );
end