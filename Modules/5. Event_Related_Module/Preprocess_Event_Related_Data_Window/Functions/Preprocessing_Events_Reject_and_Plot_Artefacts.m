function [EventRelatedData,ERP,ERPs] = Preprocessing_Events_Reject_and_Plot_Artefacts(EventRelatedData,ChannelSelection,TrialsofInterest,Time,TimeWindin,Figure1,Figure2,Figure3,ChanneltoPlot,ChannelSpacing,InterpolationMethod,Type,colorMap,WhattoPlot)

%________________________________________________________________________________________
%% Function to check each input the user has to make in the artefact rejection app window
% This function takes inputs from GUI as Input.Value structure. The value
% field saves what the user selcts as a char. I.e. TrialSelection.Value =
% '1,10' if user wants events/trials 1 to 10. If input violates format
% rules, selection gets autoreplaced by standard values and ouputted, so
% that autochange gets visible in app window

% called when the user clicks on the 'Interpolate Artefact Window' button of the artefact rejection window

% Inputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with event
% related data
% 2. ChannelSelection: 1x2 double channel selection of user for what channel to do the
% correction, i.e. [1,10] for channel 1 to 10 
% 3. TrialsofInterest: 1x2 double event selection of user for what events to do the
% correction, i.e. [1,10] for events 1 to 10 
% 5. Time: time vector in seconds for event related data, same length
% as ntime of event related data ('real' time with negative values)
% 6. TimeWindin: 1x2 double time window selection in seconds for what time
% window artefact rejection is applied. Format: [starttime stoptime], like [-0.005 0.005] to reject and
% interpolate data from -0.005 to 0.005 seconds
% 7. Figure1: figure axes handle to plot of ERP plot (top left)
% 8. Figure2: figure axes handle to plot of rejected ERP plot (bottom left)
% 9. Figure3: figure axes handle to plot of ERP for all channe (right plot)
% 10. ChanneltoPlot: char, single channel to plot erp's on the left, like
% '10' to plot channel 10, NOTE: Only for plotting! Channelselection
% happens through the channelselection edit field and variable
% 11. ChannelSpacing: as double in um, in Data.Info.Channelspacing
% 12. InterpolationMethod: string, method to apply to data in timewin;
% Option: "Linear Interpolation" 
% 13. Type: char, determines what is done here, Options: 'DeleteandPlot' (interpolates data for bottom plot, sets NaN for top plot) OR
% 'Interpolating' (just sets data in timwin to NaN for top ERP plot)
% 14. colorMap: nchannel x 3 double matrix with rgb values for the color
% of each channel for the plot on the right side
% 15. WhattoPlot: char, determines what is plotted here, Options: 'ERP' OR 'ERPAllChannel' OR 'InterpolationPlot' OR 'All'

% Outputs: -- if error was deteccted, these values are different to the
% input values
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with modified event
% related data
% ERP: 1x ntime single vector with ERP data (mean over channel and events)
% ERPs: nchannel x ntime single vector with ERP data for each channel (mean over events)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if strcmp(Type,'DeleteandPlot')

        %% Extract EventRelatedData based on GUI inputs
        %[nchan,ntrials,ntimepoints] = size(EventRelatedData);
        
        DeletedData = EventRelatedData(ChannelSelection(1):ChannelSelection(2),TrialsofInterest(1,1):TrialsofInterest(1,2),:);
        
        if TrialsofInterest(1) == TrialsofInterest(2)
            DeletedData = DeletedData.';
        end
        
        % Single Channel ERP
        ERP = mean(DeletedData,2);
        
        % Calculate ERP for all channel (across trials)
        ERPs = squeeze(mean(EventRelatedData(:,TrialsofInterest(1,1):TrialsofInterest(1,2),:), 2)); % Collapse trials dimension to calculate average
        ERPs = flip(ERPs,1);
        
        %% Get sample closest to select Time point
        % Calculate absolute differences between values and Time points
        diff1 = abs(Time - TimeWindin(1));
        diff2 = abs(Time - TimeWindin(2));   
        
        % Find the indices of the minimum differences
        [~, index1] = min(diff1);
        [~, index2] = min(diff2);
        
        DeletedData(:,:,index1:index2) = NaN;
            
        ChannelRange = ChannelSelection(1):1:ChannelSelection(2);
        ChannelofInterest = find(ChannelRange == str2double(ChanneltoPlot));
        
        if isempty(ChannelofInterest)
            if str2double(ChanneltoPlot) < ChannelRange(1)
                ChannelofInterest = ChannelRange(1);
                ChanneltoPlot = num2str(ChannelofInterest);
                msgbox("Warning: Channel to plot not within specified channelrange and autoset to the first/last value of the channelrange");
            elseif str2double(ChanneltoPlot) > ChannelRange(2)
                ChannelofInterest = ChannelRange(2);
                ChanneltoPlot = num2str(ChannelofInterest);
                msgbox("Warning: Channel to plot not within specified channelrange and autoset to the first/last value of the channelrange");
            end
        end

    if strcmp(WhattoPlot,'ERP') || strcmp(WhattoPlot,'All')
        %% Manage Plot Handles
        ERPHandle = findobj(Figure1, 'Tag', 'ERP');
        TrialsHandle = findobj(Figure1, 'Tag', 'Trials');
        RjectWindHandle = findobj(Figure1, 'Tag', 'RjectWind');
        
        if length(RjectWindHandle) > 2
            delete(RjectWindHandle(3:end));
            RjectWindHandle = findobj(Figure1, 'Tag', 'RjectWind');
        end
        
        if length(ERPHandle) > 1
            delete(ERPHandle(2:end));
            ERPHandle = findobj(Figure1, 'Tag', 'ERP');
        end
        
        if length(TrialsHandle) > size(DeletedData,2)
            delete(TrialsHandle(size(DeletedData,2)+1:end));
            TrialsHandle = findobj(Figure1, 'Tag', 'Trials');
        end
        
        %% Plot Trials
        if isempty(TrialsHandle)
            h = line(Figure1,Time,squeeze(DeletedData(ChannelofInterest,:,:)), 'Tag', 'Trials');
            set(h,'color',[1 1 1]*.75);
        else
            for nTrials = 1:size(DeletedData,2)
                if nTrials <= length(TrialsHandle)
                    set(TrialsHandle(nTrials), 'XData', Time, 'YData',squeeze(DeletedData(ChannelofInterest,nTrials,:)), 'Tag', 'Trials');
                else
                    h = line(Figure1,Time,squeeze(DeletedData(ChannelofInterest,nTrials,:)), 'Tag', 'Trials');
                    set(h,'color',[1 1 1]*.75);
                end
            end
        end
        
        %% Plot ERP
        if isempty(ERPHandle)
            if ChannelSelection(1)==ChannelSelection(2)
                line(Figure1,Time,squeeze(ERP),'Color','k','LineWidth',1.5, 'Tag', 'ERP');
            else
                line(Figure1,Time,squeeze(ERP(ChannelofInterest,:,:)),'Color','k','LineWidth',1.5, 'Tag', 'ERP');
            end
        else
            if ChannelSelection(1)==ChannelSelection(2)
                set(ERPHandle(:), 'XData', Time, 'YData',squeeze(ERP), 'Tag', 'ERP');
            else
                set(ERPHandle(:), 'XData', Time, 'YData',squeeze(ERP(ChannelofInterest,:,:)), 'Tag', 'ERP');
            end
        end
        
        titlestring = strcat("Signal and Selected Window for Interpolation Channel ",ChanneltoPlot);
        title(Figure1,titlestring);

        %% Plot cutting window
        if isempty(RjectWindHandle)
            line(Figure1,[TimeWindin(1),TimeWindin(1)],[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')],'Color','k','LineWidth',1, 'Tag', 'RjectWind');
            line(Figure1,[TimeWindin(2),TimeWindin(2)],[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')],'Color','k','LineWidth',1, 'Tag', 'RjectWind');
        else
            set(RjectWindHandle(1), 'XData', [TimeWindin(1),TimeWindin(1)], 'YData',[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')] ,'Tag','RjectWind');
            set(RjectWindHandle(2), 'XData', [TimeWindin(2),TimeWindin(2)], 'YData',[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')] ,'Tag','RjectWind');
        end
    end

    if strcmp(WhattoPlot,'ERPAllChannel') || strcmp(WhattoPlot,'All')

        %% Plot ERP over all Channel
        
        % Plotting each row at descending y positions
        NumChannels = size(ERPs, 1);
        row_height = ChannelSpacing;  % Height between each row plot
        
        YMaxLimitsMultipeERP = NaN(1,NumChannels);
        YMinLimitsMultipeERP = NaN(1,NumChannels);
        
        %% Manage Plot Handles
    
        ERPAllChannelHandle = findobj(Figure3, 'Tag', 'ERPAllChannelHandle');
    
        if length(ERPAllChannelHandle) > size(DeletedData,1)
            delete(ERPAllChannelHandle(size(DeletedData,1)+1:end))
            ERPAllChannelHandle = findobj(Figure3, 'Tag', 'ERPAllChannelHandle');
        end
    
        %% Plot All Channel ERP
        for i = 1:NumChannels
            if i <= length(ERPAllChannelHandle)
                set(ERPAllChannelHandle(i), 'XData', Time, 'YData', ERPs(i, :) + (i - 1) * row_height, 'Color' ,colorMap(i,:), 'Tag', 'ERPAllChannelHandle');
            else
                line(Figure3,Time,ERPs(i, :) + (i - 1) * row_height, 'Color' ,colorMap(i,:), 'Tag', 'ERPAllChannelHandle');
            end
        
            YMaxLimitsMultipeERP(i) = max(ERPs(i, :) + (i - 1) * row_height);
            YMinLimitsMultipeERP(i) = min(ERPs(i, :) + (i - 1) * row_height);
        end
        
        
        titlestring = strcat("ERP for each Channel ");
        title(Figure3, titlestring);
        
        ylim(Figure3, [min(YMinLimitsMultipeERP),max(YMaxLimitsMultipeERP)]);

    end
end

%% Interpolating 

if strcmp(Type,'Interpolating')

    hg = waitbar(0, 'Interpolating Artefacts...', 'Name','Interpolating Artefacts...');

    DeletedData = EventRelatedData(ChannelSelection(1):ChannelSelection(2),TrialsofInterest(1,1):TrialsofInterest(1,2),:);
    
    if TrialsofInterest(1) == TrialsofInterest(2)
        DeletedData = DeletedData.';
    end

    %% Get sample closest to select Time point
    % Calculate absolute differences between values and Time points
    diff1 = abs(Time - TimeWindin(1));
    diff2 = abs(Time - TimeWindin(2));   
    
    % Find the indices of the minimum differences
    [~, index1] = min(diff1);
    [~, index2] = min(diff2);
    
    DeletedData(:,:,index1:index2) = NaN;

    ChannelRange = ChannelSelection(1):1:ChannelSelection(2);
    ChannelofInterest = find(ChannelRange == str2double(ChanneltoPlot));
    
    if isempty(ChannelofInterest)
        if str2double(ChanneltoPlot) < ChannelRange(1)
            ChannelofInterest = ChannelRange(1);
            ChanneltoPlot = num2str(ChannelofInterest);
            msgbox("Warning: Channel to plot not within specified channelrange and autoset to the first/last value of the channelrange");
        elseif str2double(ChanneltoPlot) > ChannelRange(2)
            ChannelofInterest = ChannelRange(2);
            ChanneltoPlot = num2str(ChannelofInterest);
            msgbox("Warning: Channel to plot not within specified channelrange and autoset to the first/last value of the channelrange");
        end
    end

    %% Linear Interpolation 
    if strcmp(InterpolationMethod,"Linear Interpolation")
    
        %% Interpolate Missing Data
        nanIndices = [];
        nonNaNIndices = [];
    
        % Number of trials and time points
        [nChannel, ntrials, ntime_points] = size(DeletedData);
        TempDataInter =[];
        % Interpolation for each trial
        for j = 1:nChannel
            fraction = j/(nChannel+3);
            msg = sprintf('Interpolating Artefacts... (%d%% done)', round(100*fraction));
            waitbar(fraction, hg, msg);

            for i = 1:ntrials
                nan_indices = squeeze(isnan(DeletedData(j,i, :))); % Find NaN indices
                non_nan_indices = find(~nan_indices); % Find non-NaN indices
    
                % Linear interpolation using interp1
                DeletedData(j,i, nan_indices) = interp1(non_nan_indices, squeeze(DeletedData(j,i, non_nan_indices)), find(nan_indices), 'linear');
            end
        end
    
    end
    
    %% Apply to Dataset for single channel Plots

    EventRelatedData(ChannelSelection(1):ChannelSelection(2),TrialsofInterest(1,1):TrialsofInterest(1,2),:) = single(DeletedData);
    
    ERP = squeeze(mean(EventRelatedData(str2double(ChanneltoPlot),TrialsofInterest(1,1):TrialsofInterest(1,2),:),2))';
    
    %% Apply to Dataset for all channel Plot
    
    % Calculate ERP for each channel (across trials)
    ERPs = squeeze(mean(EventRelatedData(:,TrialsofInterest(1,1):TrialsofInterest(1,2),:), 2)); % Collapse trials dimension to calculate average
    ERPs = flip(ERPs,1);
    
    fraction = (nChannel+1)/(nChannel+3);
    msg = sprintf('Interpolating Artefacts... (%d%% done)', round(100*fraction));
    waitbar(fraction, hg, msg);
 
    if strcmp(WhattoPlot,'InterpolationPlot')
        %% Manage Plot Handles
        
        ERPHandle = findobj(Figure2, 'Tag', 'ERP');
        TrialsHandle = findobj(Figure2, 'Tag', 'Trials');
        RjectWindHandle = findobj(Figure2, 'Tag', 'RjectWind');
        
        if length(RjectWindHandle) > 2
            delete(RjectWindHandle(3:end));
            RjectWindHandle = findobj(Figure2, 'Tag', 'RjectWind');
        end
        
        if length(ERPHandle) > 1
            delete(ERPHandle(2:end));
            ERPHandle = findobj(Figure2, 'Tag', 'ERP');
        end
        
        if length(TrialsHandle) > size(DeletedData,2)
            delete(TrialsHandle(size(DeletedData,2)+1:end));
            TrialsHandle = findobj(Figure2, 'Tag', 'Trials');
        end
        
        %% Plot Trials
        if isempty(TrialsHandle)
            h = line(Figure2,Time,squeeze(DeletedData(ChannelofInterest,:,:)), 'Tag', 'Trials');
            set(h,'color',[1 1 1]*.75);
        else
            for nTrials = 1:size(DeletedData,2)
                if nTrials <= length(TrialsHandle)
                    set(TrialsHandle(nTrials), 'XData', Time, 'YData',squeeze(DeletedData(ChannelofInterest,nTrials,:)), 'Tag', 'Trials');
                else
                    h = line(Figure2,Time,squeeze(DeletedData(ChannelofInterest,nTrials,:)), 'Tag', 'Trials');
                    set(h,'color',[1 1 1]*.75);
                end
            end
        end
        
        %% Plot ERP
        if isempty(ERPHandle)
            line(Figure2,Time,ERP,'Color','k','LineWidth',1.5, 'Tag', 'ERP');
        else
            set(ERPHandle(:), 'XData', Time, 'YData',ERP, 'Tag', 'ERP');
        end
    
        titlestring = strcat("Interpolated ERP Channel ",ChanneltoPlot);
        title(Figure2,titlestring);
       
        %% Plot cutting window
        if isempty(RjectWindHandle)
            line(Figure2,[TimeWindin(1),TimeWindin(1)],[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')],'Color','k','LineWidth',1, 'Tag', 'RjectWind');
            line(Figure2,[TimeWindin(2),TimeWindin(2)],[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')],'Color','k','LineWidth',1, 'Tag', 'RjectWind');
        else
            set(RjectWindHandle(1), 'XData', [TimeWindin(1),TimeWindin(1)], 'YData',[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')] ,'Tag','RjectWind');
            set(RjectWindHandle(2), 'XData', [TimeWindin(2),TimeWindin(2)], 'YData',[min(DeletedData(ChannelofInterest,:,:),[],'all'), max(DeletedData(ChannelofInterest,:,:),[],'all')] ,'Tag','RjectWind');
        end
    
        fraction = (nChannel+2)/(nChannel+3);
        msg = sprintf('Interpolating Artefacts... (%d%% done)', round(100*fraction));
        waitbar(fraction, hg, msg);
    
        %% Plot ERP over all Channel
            
        % Plotting each row at descending y positions
        NumChannels = size(ERPs, 1);
        row_height = ChannelSpacing;  % Height between each row plot
        
        YMaxLimitsMultipeERP = NaN(1,NumChannels);
        YMinLimitsMultipeERP = NaN(1,NumChannels);
        
        %% Manage Plot Handles
    
        ERPAllChannelHandle = findobj(Figure3, 'Tag', 'ERPAllChannelHandle');
    
        if length(ERPAllChannelHandle) > size(DeletedData,1)
            delete(ERPAllChannelHandle(size(DeletedData,1)+1:end))
            ERPAllChannelHandle = findobj(Figure3, 'Tag', 'ERPAllChannelHandle');
        end
    
        %% Plot All Channel ERP
        for i = 1:NumChannels
            if i <= length(ERPAllChannelHandle)
                set(ERPAllChannelHandle(i), 'XData', Time, 'YData', ERPs(i, :) + (i - 1) * row_height, 'Color' ,colorMap(i,:), 'Tag', 'ERPAllChannelHandle');
            else
                line(Figure3,Time,ERPs(i, :) + (i - 1) * row_height, 'Color' ,colorMap(i,:), 'Tag', 'ERPAllChannelHandle');
            end
        
            YMaxLimitsMultipeERP(i) = max(ERPs(i, :) + (i - 1) * row_height);
            YMinLimitsMultipeERP(i) = min(ERPs(i, :) + (i - 1) * row_height);
        end
        
        titlestring = strcat("ERP for each Channel ");
        title(Figure3, titlestring);
        
        ylim(Figure3, [min(YMinLimitsMultipeERP),max(YMaxLimitsMultipeERP)]);

    end

    fraction = (nChannel+3)/(nChannel+3);
    msg = sprintf('Interpolating Artefacts... (%d%% done)', round(100*fraction));
    waitbar(fraction, hg, msg);

    close(hg);
        
end