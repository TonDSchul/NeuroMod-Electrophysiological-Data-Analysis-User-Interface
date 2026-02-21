function Module_MainWindow_Plot_Events_and_Label(Info,Data,Time,EventIndicies,UIAxis,EventPlot,EventIndexNr,Eventline_handles,YMinLimitsMultipeERP,YMaxLimitsMultipeERP,Channel_Selection,PlotAppearance)

%________________________________________________________________________________________

%% Function to plot event lines and event trigger numbers in main window

% gets called in 
% Module_MainWindow_Plot_Data

% Inputs: 
% 1. Info: main data metadata structure from Data.Info
% 2. Data: channel by time matrix with plotted data
% 3. Time: double vector with time stamps for each plotted data point in
% main plot
% 4. EventIndicies: double vector with sample indicies events are happening
% 5. UIAxis: plot axes to plot in (app.UIAxes)
% 6. EventPlot: char, from main window properties, whether to lot events or
% not 
% 7. EventIndexNr: index of event channel selected for plot
% 8. Eventline_handles: handles of already plotted event lines
% 9. YMinLimitsMultipeERP: min value of data plotted to set ylims
% of vertical line
% 10. YMaxLimitsMultipeERP: max value of data plotted to set ylims
% of vertical line
% 11. Channel_Selection: vector with data amtrix indicies that are selected to
% be plotted by user
% 12. PlotAppearance: structure holding indo about the appearance of plots
% the user selected

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


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