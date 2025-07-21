function [EventRelatedData] = Preprocessing_Events_Channel_Rejection(Data,EventRelatedData,Time,Channel,ChannelSpacing,Figure,Type,ActiveChannel)

%________________________________________________________________________________________
%% Function to execute channel rejection and interpolation event preprocessing step
% This function modifes the Data.EventRelatedData or
% Data.PreprocessedEventRelatedData if prepro was already applied

% Inputs: 
% 1. EventRelatedData: nchannel x nevents x ntime single matrix with event
% related data
% 2. Time: double time vector, same length as ntime, in seconds
% 3. Channel: 1xn double vector with channel to be deleted
% 4. ChannelSpacing: double in um (Data.Info.ChannelSpacing)
% 5. Figure: axes object of channel rejection prepro app window to plot
% result in
% 6. Type: selects if results should be plotted, Otions: 'InterpolatedOnly' OR 'PlotOnly' OR 'All'

% Outputs:
% 1. EventRelatedData: nchannel x nevents x ntime single matrix with modified event related data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Channel deletion/interpolation

if strcmp(Type,'InterpolatedOnly') || strcmp(Type,'All')

    if size(EventRelatedData,1)<3
        error('More than 2 channel required!');
    end
   
    nchannel=length(ActiveChannel); %get size
    
    if length(Channel)>1
        Channel = Channel(1):Channel(2);
    end

    if Data.Info.ProbeInfo.SwitchTopBottomChannel == 0
        [Channel] = Organize_Convert_ActiveChannel_to_DataChannel(ActiveChannel,Channel,'MainWindow');
    else
        ReversedActiveChannel = (str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows)+1)-Data.Info.ProbeInfo.ActiveChannel;
        [Channel] = Organize_Convert_ActiveChannel_to_DataChannel(ReversedActiveChannel,Channel,'MainWindow');
    end

    if ~isempty(Channel)
        if Channel(1) == Channel(end) && Channel(1) == 1
            msgbox("Fist channel has just one neighbouring channel and cannot be interploated.")
            Channel = [];
        end
        if Channel(1) == Channel(end) && Channel(end) == size(EventRelatedData,1)
            msgbox("Last channel has just one neighbouring channel and cannot be interploated.")
            Channel = [];
        end
        if Channel(1) ~= Channel(end) && Channel(1) == 1
            msgbox("Fist channel has just one neighbouring channel and cannot be interploated.")
            Channel = Channel(1)+1:Channel(end);
        end
        if length(Channel)>1
            if Channel(1) ~= Channel(end) && Channel(end) == size(EventRelatedData,1)
                msgbox("Last channel has just one neighbouring channel and cannot be interploated.")
                Channel = Channel(1):Channel(end)-1;
            end
        else
            if Channel(1) == size(EventRelatedData,1)
                msgbox("Last channel has just one neighbouring channel and cannot be interploated.")
                Channel = [];
            end
        end

    end
    if isscalar(Channel)
        Channel(2) = Channel(1);
    end
    Rejectedchan = Channel;
    
    %% Find out whether broken channel is first or last
    if ~isempty(Rejectedchan)
        
            if Channel(1)~=Channel(2)  % If multiple Channel selected
                
                %Get Indices of good channel 
                goodchannel = 1:1:nchannel;
                goodchannel(Rejectedchan) = [];
            
                if length(goodchannel) <=2
                    f = msgbox("Error: At least two valid Channel required, Exiting");
                    return;
                end
            
                for deleteChannel = 1:numel(Rejectedchan) % From first Channel to be deleted and interpolated to the last one
                    %Get the first good and bad channel before and after the
                    %channel to be deleted
                    % Assume Data is of size [nChannel x nTrial x nTime]
                    [nChannel, nTrial, nTime] = size(EventRelatedData);
                    
                    % Ensure goodchannel is sorted
                    goodchannel = sort(goodchannel);
                    badchannel = sort(Rejectedchan);
                    
                    % Create a copy of the original data to write interpolated values
                    InterpolatedData = EventRelatedData;
                    
                    for i = 1:length(badchannel)
                        badIdx = badchannel(i);
                        
                        % Find neighboring good channels (before and after)
                        lowerGood = goodchannel(find(goodchannel < badIdx, 1, 'last'));
                        upperGood = goodchannel(find(goodchannel > badIdx, 1, 'first'));
                        
                        if ~isempty(lowerGood) && ~isempty(upperGood)
                            % Interpolate using the average of the two neighboring good channels
                            InterpolatedData(badIdx, :, :) = (EventRelatedData(lowerGood, :, :) + EventRelatedData(upperGood, :, :)) / 2;
                            
                        elseif ~isempty(lowerGood)
                            % If only one neighbor exists (e.g., at the top), copy from that
                            InterpolatedData(badIdx, :, :) = EventRelatedData(lowerGood, :, :);
                            
                        elseif ~isempty(upperGood)
                            % If only one neighbor exists (e.g., at the bottom), copy from that
                            InterpolatedData(badIdx, :, :) = EventRelatedData(upperGood, :, :);
                            
                        else
                            warning('No good neighboring channels found for bad channel %d. Skipping interpolation.', badIdx);
                        end
                    end
    
                    EventRelatedData = InterpolatedData;          
                end
            
            else % If one Channel selected
                
                InterpolatedData = EventRelatedData;
                InterpolatedData(Rejectedchan(1), :, :) = (EventRelatedData(Rejectedchan(1)-1, :, :) + EventRelatedData(Rejectedchan(1)+1, :, :)) / 2;            
                
                EventRelatedData = InterpolatedData; 
            end
    end
end

if strcmp(Type,'PlotOnly') || strcmp(Type,'All')
    %% Plotting
    
    colorMap = eval(strcat("parula","(size(EventRelatedData,1))")); % Example colormap: You can use any other colormap

    % Calculate ERP for each channel (across trials)
    ERPs = squeeze(mean(EventRelatedData, 2)); % Collapse trials dimension to calculate average
    ERPs = flip(ERPs,1);
    
    %% Plotting ERP for each Channel
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
    titlestring = strcat("ERPs for each Channel without Rejection");
    title(Figure, titlestring);
    xlim(Figure, [Time(1),Time(end)]);
    ylim(Figure, [min(YMinLimitsMultipeERP),max(YMaxLimitsMultipeERP)]);
    
    % Add legend only once
    if isempty(findobj(Figure, 'Type', 'legend'))
        % Create legend and then set its 'HandleVisibility' to 'off'
        legendHandle = legend([Dataplot(1), eventline], {'ERP per Channel','Trials/Events'});
        set(legendHandle, 'HandleVisibility', 'off');
    end
end