function [EventRelatedData] = Preprocessing_Events_Channel_Rejection(EventRelatedData,Time,Channel,ChannelSpacing,Figure,Type)

%________________________________________________________________________________________
%% Function to execute channel rejection and interpolation event preprocessing step
% This function modifes the Data.EventRelatedData or
% Data.PreprocessedEventRelatedData if prepro was already applied

% Inputs: 
% 1. EventRelatedData: nchannel x nevents x ntime single matrix with event
% related data
% 2. Time: double time vector, same length as ntime, in seconds
% 3. Channel: 1x2 double with channel to be deleted, i.e. [1,10] for
% channel 1 to 10 
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
        error('Matrix needs more channels!');
    end
    
    [nchannel,~,~]=size(EventRelatedData); %get size
    
    chan = Channel(1):1:Channel(2);
    
    %% Find out whether broken channel is first or last
    if Channel(1)~=Channel(2)  % If multiple Channel selected
        
        %Get Indices of good channel 
        goodchannel = 1:1:nchannel;
        goodchannel(chan) = [];
    
        if length(goodchannel) <=2
            f = msgbox("Error: At least two valid Channel required, Exiting");
            return;
        end
    
        for deleteChannel = 1:numel(chan) % From first Channel to be deleted and interpolated to the last one
            if chan(deleteChannel)==nchannel % If last channel use the two previous ones
                %Get the first good and bad channel before and after the
                %channel to be deleted
                GoodchannelbeforeDeletion = max(find(goodchannel < chan(deleteChannel)));
                GoodchannelAfterDeletion = max(find(goodchannel < GoodchannelbeforeDeletion));
    
                temp=EventRelatedData(goodchannel(GoodchannelbeforeDeletion),:,:)-EventRelatedData(goodchannel(GoodchannelAfterDeletion),:,:); %linear extrapolation
                EventRelatedData(chan(deleteChannel),:,:)=EventRelatedData(goodchannel(GoodchannelbeforeDeletion),:,:)+temp; 
            elseif chan(deleteChannel)==1 % If first channel, use the two following ones
                %Get the first good and bad channel before and after the
                %channel to be deleted
                GoodchannelAfterDeletion = min(find(goodchannel > chan(deleteChannel)));
                GoodchannelbeforeDeletion = min(find(goodchannel > goodchannel(GoodchannelAfterDeletion)));
                
                temp=EventRelatedData(goodchannel(GoodchannelAfterDeletion),:,:)-EventRelatedData(goodchannel(GoodchannelbeforeDeletion),:,:); %linear extrapolation
                EventRelatedData(chan(deleteChannel),:,:)=EventRelatedData(goodchannel(GoodchannelAfterDeletion),:,:)+temp; 
    
                % Now tell the loop that the interpolated channel is now valid
                % for the next channel to be interpolated
                % Find the index where 6 is located
                tempgoodchannel = NaN(1,numel(goodchannel)+1);
                tempgoodchannel(2:end) = goodchannel;
                tempgoodchannel(1) = 1;
                % Insert 5 after the index where 6 is located
                goodchannel = tempgoodchannel;
            elseif chan(deleteChannel)~=1 && chan(deleteChannel)~=nchannel
                %Get the first good and bad channel before and after the
                %channel to be deleted
                GoodchannelbeforeDeletion = max(find(goodchannel < chan(deleteChannel)));
                GoodchannelAfterDeletion = min(find(goodchannel > chan(deleteChannel)));
                if ~isempty(GoodchannelAfterDeletion)
                    EventRelatedData(chan(deleteChannel),:,:)=(EventRelatedData(goodchannel(GoodchannelbeforeDeletion),:,:)+EventRelatedData(goodchannel(GoodchannelAfterDeletion),:,:))./2; %interpolation
                elseif GoodchannelbeforeDeletion-1 <= 0 
                    return;
                else
                    EventRelatedData(chan(deleteChannel),:,:)=(EventRelatedData(goodchannel(GoodchannelbeforeDeletion-1),:,:)+EventRelatedData(goodchannel(GoodchannelbeforeDeletion),:,:))./2; %interpolation
                end
                % Find the index where 6 is located
                idx = find(goodchannel == GoodchannelbeforeDeletion);
                
                % Split the vector into two parts at the index
                part1 = goodchannel(1:idx);
                part2 = goodchannel(idx+1:end);
                
                % Concatenate the parts with 5 in between
                goodchannel = [part1, chan(deleteChannel), part2];
            end
            
        end
    
    else % If one Channel selected
    
        if chan==nchannel % If last channel use the two previous ones
            temp=EventRelatedData(end-1,:,:)-EventRelatedData(end-2,:,:); %linear extrapolation
            EventRelatedData(chan,:,:)=EventRelatedData(end-1,:,:)+temp; 
        elseif chan==1 % If first channel, use the two following ones
            temp=EventRelatedData(2,:,:)-EventRelatedData(3,:,:); %linear extrapolation
            EventRelatedData(chan,:,:)=EventRelatedData(2,:,:)+temp; 
        else
            EventRelatedData(chan,:,:)=(EventRelatedData(chan-1,:,:)+EventRelatedData(chan+1,:,:))/2; %interpolation
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