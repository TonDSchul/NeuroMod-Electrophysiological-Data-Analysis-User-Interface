function Module_MainWindow_Plot_Events_and_Label(Info,Data,Time,EventIndicies,UIAxis,EventPlot,EventIndexNr,Eventline_handles,YMinLimitsMultipeERP,YMaxLimitsMultipeERP,Channel_Selection,PlotAppearance)

%% Events: Check if Events should be plotted.
if strcmp(EventPlot,"Events") && sum(EventIndicies) > 0

    % Pre-calculate values used multiple times
    eventTimes = Time(EventIndicies == 1);
    numEvents = length(eventTimes);
    
    % Prepare xData and yData without redundant calculations
    xData = [eventTimes; eventTimes];
    yData = [YMinLimitsMultipeERP; YMaxLimitsMultipeERP];
    yData = yData(:, ones(1, numEvents));  
    
    % Check if we need to create new lines or update existing ones
    if isempty(Eventline_handles)
        % Create new lines if there are no existing handles
        line(UIAxis, xData, yData, 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
            'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
    else
        % Number of existing lines
        numHandles = length(Eventline_handles);
        
        % Update existing handles if possible
        minCount = min(numHandles, numEvents);
        for i = 1:minCount
            set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), ...
                'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
        end
        
        % Add new lines if there are more events than handles
        if numEvents > numHandles
            line(UIAxis, xData(:, numHandles+1:end), yData(:, numHandles+1:end), ...
                'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
        % Remove excess handles if there are more handles than events
        elseif numEvents < numHandles
            delete(Eventline_handles(numEvents+1:end));
        end
    end

    %% add event labels as text
    if PlotAppearance.MainWindow.Data.ShowTriggerNumber == 1
        % Place in the middle of the main plot
        if isscalar(Channel_Selection)
            yPos = (abs(YMaxLimitsMultipeERP)-abs(YMinLimitsMultipeERP))/1.1;
        else
            yPos = (abs(YMaxLimitsMultipeERP)-abs(YMinLimitsMultipeERP))/2;
        end
        
        % First remove old event labels if needed
        EventLabel = findobj(UIAxis, 'Tag', 'EventLabel');
        
        if length(EventIndexNr)<length(EventLabel)
            delete(EventLabel(length(EventIndexNr)+1:end));
            EventLabel = findobj(UIAxis, 'Tag', 'EventLabel');
        end
        
        % Add a text label for each event
        for i = 1:length(EventIndexNr)
            
            pos = [eventTimes(i), yPos];  % new position

            if i <= length(EventLabel) && isgraphics(EventLabel(i))
                % Update existing text
                set(EventLabel(i), 'Position', [pos(1), pos(2)], ...
                    'String', strcat("Trigger Nr ", num2str(EventIndexNr(i))), ...
                    'Color', PlotAppearance.MainWindow.Data.TriggerNrTextColor, ...
                    'FontSize', PlotAppearance.MainWindow.Data.TriggerNrTextFontSize, ...
                    'Tag', 'EventLabel');
            else
                % Create new text object
                text(UIAxis, pos(1), pos(2), ...
                    strcat("Trigger Nr ", num2str(EventIndexNr(i))), ...
                    'Rotation', 90, ...                   
                    'HorizontalAlignment', 'left', ...    
                    'VerticalAlignment', 'top', ...       
                    'Color', PlotAppearance.MainWindow.Data.TriggerNrTextColor, ...
                    'FontSize', PlotAppearance.MainWindow.Data.TriggerNrTextFontSize, ...
                    'Tag', 'EventLabel');
            end
        end
    end
end