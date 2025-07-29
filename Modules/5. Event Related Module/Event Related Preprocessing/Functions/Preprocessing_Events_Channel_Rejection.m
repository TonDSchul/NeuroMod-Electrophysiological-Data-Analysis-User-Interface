function [EventRelatedData] = Preprocessing_Events_Channel_Rejection(Data,EventRelatedData,Time,Rejectedchan,ChannelSpacing,Figure,Type,AllActiveChannel)

%________________________________________________________________________________________
%% Function to execute channel rejection and interpolation event preprocessing step
% This function modifes the Data.EventRelatedData or
% Data.PreprocessedEventRelatedData if prepro was already applied

% Inputs: 
% 1. EventRelatedData: nchannel x nevents x ntime single matrix with event
% related data
% 2. Time: double time vector, same length as ntime, in seconds
% 3. Rejectedchan: 1xn double vector with channel to be deleted
% 4. ChannelSpacing: double in um (Data.Info.ChannelSpacing)
% 5. Figure: axes object of channel rejection prepro app window to plot
% result in
% 6. Type: selects if results should be plotted, Otions: 'InterpolatedOnly' OR 'PlotOnly' OR 'All'
% 7. AllActiveChannel: double vector with all active channel in the probe
% design (not the currently active ones)

% Outputs:
% 1. EventRelatedData: nchannel x nevents x ntime single matrix with modified event related data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Rejectedchan deletion/interpolation

if strcmp(Type,'InterpolatedOnly') || strcmp(Type,'All')

    if size(EventRelatedData,1)<3
        error('More than 2 channel required!');
    end
   
    if Data.Info.ProbeInfo.SwitchTopBottomChannel == 0
        [Rejectedchan] = Organize_Convert_ActiveChannel_to_DataChannel(AllActiveChannel,Rejectedchan,'MainWindow');
    else
        ReversedActiveChannel = (str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows)+1)-Data.Info.ProbeInfo.ActiveChannel;
        [Rejectedchan] = Organize_Convert_ActiveChannel_to_DataChannel(ReversedActiveChannel,Rejectedchan,'MainWindow');
    end

    if ~isempty(Rejectedchan)
        Error = 0;
        if Rejectedchan(1) == Rejectedchan(end) && Rejectedchan(1) == 1
            msgbox("Fist channel has just one neighbouring channel and cannot be interploated.")
            Error = 1;
        end
        if Rejectedchan(1) == Rejectedchan(end) && Rejectedchan(end) == size(EventRelatedData,1)
            msgbox("Last channel has just one neighbouring channel and cannot be interploated.")
            Error = 1;
        end
        if Rejectedchan(1) ~= Rejectedchan(end) && Rejectedchan(1) == 1
            msgbox("Fist channel has just one neighbouring channel and cannot be interploated.")
            Rejectedchan = Rejectedchan(1)+1:Rejectedchan(end);
        end
        if length(Rejectedchan)>1
            if Rejectedchan(1) ~= Rejectedchan(end) && Rejectedchan(end) == size(EventRelatedData,1)
                msgbox("Last channel has just one neighbouring channel and cannot be interploated.")
                Rejectedchan = Rejectedchan(1):Rejectedchan(end)-1;
            end
        else
            if Rejectedchan(1) == size(EventRelatedData,1)
                msgbox("Last channel has just one neighbouring channel and cannot be interploated.")
                Error = 1;
            end
        end
        
        if Error == 1
            Rejectedchan = [];
        end
    end

    [EventRelatedData] = Preprocessing_Events_Interpolate_Channel(EventRelatedData,Rejectedchan);

end

if strcmp(Type,'PlotOnly') || strcmp(Type,'All')
    %% Plotting
    
    colorMap = eval(strcat("parula","(size(EventRelatedData,1))")); % Example colormap: You can use any other colormap

    % Calculate ERP for each channel (across trials)
    ERPs = squeeze(mean(EventRelatedData, 2)); % Collapse trials dimension to calculate average
    ERPs = flip(ERPs,1);
    
    %% Plotting ERP for each Rejectedchan
    NumChannels = size(ERPs, 1);

    row_height = ChannelSpacing;  % Height between each row plot
    
    YMaxLimitsMultipeERP = NaN(1,NumChannels);
    YMinLimitsMultipeERP = NaN(1,NumChannels);
    
    ERPHandle = findobj(Figure, 'Tag', 'ERP');
    
    if length(ERPHandle) > NumChannels
        delete(ERPHandle(NumChannels+1:end));
    end
    
    for i = 1:NumChannels
        if i <= length(ERPHandle)
            set(ERPHandle(i), 'XData', Time, 'YData',ERPs(i, :) + (i - 1) * row_height, 'Color', colorMap(i, :), 'Tag', 'ERP','LineWidth',1);
            Dataplot(1) = ERPHandle(1);
        else
            Dataplot = line(Figure,Time,ERPs(i, :) + (i - 1) * row_height, 'Color', colorMap(i, :), 'Tag', 'ERP','LineWidth',1);
        end
        YMaxLimitsMultipeERP(i) = max(ERPs(i, :) + (i - 1) * row_height);
        YMinLimitsMultipeERP(i) = min(ERPs(i, :) + (i - 1) * row_height);
    end
    
    eventline = xline(Figure,0,'Color','k','LineStyle','--','LineWidth',2);
    titlestring = strcat("ERPs For Each Probe View Channel Without Rejection");
    xlabel(Figure,"Time [s]");
    ylabel(Figure,"Channel");
    Figure.YTickLabel = [];

    title(Figure, titlestring);
    xlim(Figure, [Time(1),Time(end)]);
    ylim(Figure, [min(YMinLimitsMultipeERP),max(YMaxLimitsMultipeERP)]);
    
    % Add legend only once
    if isempty(findobj(Figure, 'Type', 'legend'))
        % Create legend and then set its 'HandleVisibility' to 'off'
        legendHandle = legend([Dataplot(1), eventline], {'ERP per Channel','Trigger'});
        set(legendHandle, 'HandleVisibility', 'off');
    end
end