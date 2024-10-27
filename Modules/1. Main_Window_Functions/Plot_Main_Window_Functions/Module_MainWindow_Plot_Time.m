function [rectangleHandle] = Module_MainWindow_Plot_Time(UIAxis,Time,StartTimeIndex,StopTimeIndex,PlotType,rectangleHandle,EventPlot,EventData,PlotAppearance)
%________________________________________________________________________________________
%% Function to Plot Time in the Main Window
% Input Arguments:
% 1. UIAxis: App UIAxes object designating the plot you want to plot in
% 2. Time: Vector with time points to be plotted (single/double)
% 3. StartTimeIndex: Number of samples at which main window data plots beings
% to draw red rectangle
% 4. StopTimeIndex: Number of samples at which main window data plots ends
% to draw red rectangle
% 5. PlotType: "Initial" -- only input possible and needed so far
% 6. rectangleHandle: Handle to red rectangle drawn in time plot. Input and output to be
% able to access in rest of the GUI. Not needed yet
% 7. EventPlot: "Events" to show event plots if within time range, any other
% string like "Non" leads to no events being plotted
% 8. EventData: vector of time points (in s as double) of the event selected
% on the bottom right of the main window. Only needed if EventPlot = "Events"
% 9. PlotAppearance: structure holding indo about the appearance of plots
% the user selected

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


% "Initial" = First Time TIme vector is plotted for a new dataset. Only
% then the black horizontal line is drawn. Otherwise just the red rectangle
% is updated

if strcmp(PlotType,"Initial")
    
    %% Plot Time axis
    ylim(UIAxis,[-0.5,0.5])
    set(UIAxis,'yticklabel',{[]});
    xlim(UIAxis,[Time(1),Time(end)]);
    xlabel(UIAxis,PlotAppearance.MainWindow.Data.TimeXLabel)
    ylabel(UIAxis,PlotAppearance.MainWindow.Data.TimeYLabel)
    title(UIAxis,PlotAppearance.MainWindow.Data.TimeTitle)

    UIAxis.Color = PlotAppearance.MainWindow.Data.Color.TimeBackground;

    
    %% Plot Events
    if strcmp(EventPlot,"Events") 
       
        EventHandles = findobj(UIAxis,'Tag', 'Eventlines');
        if length(EventHandles)>length(EventData)
            delete(EventHandles(length(EventData)+1:end));
        end
        
        if isempty(EventHandles)
            % Replicate y values to match the length of x_values
            y_start = repmat(-0.5, size(EventData));
            y_end = repmat(0.5, size(EventData));
            line(UIAxis,[Time(EventData); Time(EventData)], [y_start; y_end],'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.TimeEvents, 'Color', PlotAppearance.MainWindow.Data.Color.TimeEvents,'Tag','Eventlines'); % Adjust color as needed
        else
            y_start = -0.5;
            y_end = 0.5;
            for i = 1:length(EventData)
                if length(EventHandles) >= i
                    set(EventHandles(i), 'XData', [Time(EventData(i)); Time(EventData(i))], 'YData', [y_start; y_end],'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.TimeEvents, 'Color', PlotAppearance.MainWindow.Data.Color.TimeEvents,'Tag','Eventlines');
                else
                    line(UIAxis,[Time(EventData(i)); Time(EventData(i))], [y_start; y_end],'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.TimeEvents, 'Color', PlotAppearance.MainWindow.Data.Color.TimeEvents,'Tag','Eventlines'); % Adjust color as needed
                end
            end
        end
    else
        EventHandles = findobj(UIAxis,'Tag', 'Eventlines');
        if length(EventHandles)>length(EventData)
            delete(EventHandles(1:end));
        end
    end
   
    %% Plot rectangle indicating selected time
    % Define rectangle properties

    TimeRange = Time(StopTimeIndex)-Time(StartTimeIndex);
    x = Time(StartTimeIndex); % x-coordinate of the bottom-left corner
   
    y = -0.45; % y-coordinate of the bottom-left corner
    width = TimeRange; % Width of the rectangle
    height = 0.9; % Height of the rectangle
    
    % Plot the rectangle on the UIAxes
    rectangleHandle = rectangle(UIAxis, 'Position', [x, y, width, height], 'EdgeColor', PlotAppearance.MainWindow.Data.Color.TimeRectangle, 'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.TimeRectangle);
    
else
    
    rectangleHandle = findobj(UIAxis, 'Type', 'rectangle');

    if length(rectangleHandle) > 1
        delete(rectangleHandle(2:end));
    end
    %% Plot rectangle indicating selected time
    % Define rectangle properties
    TimeRange = Time(StopTimeIndex)-Time(StartTimeIndex);
    x = Time(StartTimeIndex); % x-coordinate of the bottom-left corner

    y = -0.45; % y-coordinate of the bottom-left corner
    width = TimeRange; % Width of the rectangle
    height = 0.9; % Height of the rectangle

    newRectanglePosition = [x, y, width, height]; % Define new position
    % Update the position of the rectangle
    if isempty(rectangleHandle)
        rectangleHandle = rectangle(UIAxis, 'Position', [x, y, width, height], 'EdgeColor', PlotAppearance.MainWindow.Data.Color.TimeRectangle, 'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.TimeRectangle);
    else
        set(rectangleHandle(1), 'Position', newRectanglePosition); % Update rectangle position
    end
end
