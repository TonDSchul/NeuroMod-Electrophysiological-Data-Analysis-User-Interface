function DataPlotonScrollZoom(app, event)

% % Get the current mouse position in the figure
% mousePosition = app.NeuromodToolboxMainWindowUIFigure.CurrentPoint;
% 
% % Get the position and size of the UIAxes object in pixels
% axesPosition = app.UIAxes.Position; % [x, y, width, height]
% 
% % Check if the mouse position is within the UIAxes boundaries
% if mousePosition(1) >= axesPosition(1) && ...
%    mousePosition(1) <= (axesPosition(1) + axesPosition(3)) && ...
%    mousePosition(2) >= axesPosition(2) && ...
%    mousePosition(2) <= (axesPosition(2) + axesPosition(4))
% 
%     % Mouse is over UIAxes, so we proceed with zooming
% 
%     % Convert the mouse position in the figure to data coordinates
%     point = app.UIAxes.CurrentPoint; % Returns [x, y; x, y] matrix
%     xData = point(1, 1); % X data coordinate
%     yData = point(1, 2); % Y data coordinate
% 
%     % Set the zoom factor (e.g., 10% of current limits per scroll step)
%     zoomFactor = 0.1;
% 
%     % Get current limits
%     xlim = app.UIAxes.XLim;
%     ylim = app.UIAxes.YLim;
% 
%     % Check scroll direction
%     if event.VerticalScrollCount > 0
%         % Scroll down: zoom out
%         newXLim = [xData - (xlim(2) - xlim(1)) * (1 + zoomFactor) / 2, ...
%                    xData + (xlim(2) - xlim(1)) * (1 + zoomFactor) / 2];
%         newYLim = [yData - (ylim(2) - ylim(1)) * (1 + zoomFactor) / 2, ...
%                    yData + (ylim(2) - ylim(1)) * (1 + zoomFactor) / 2];
%     else
%         % Scroll up: zoom in
%         newXLim = [xData - (xlim(2) - xlim(1)) * (1 - zoomFactor) / 2, ...
%                    xData + (xlim(2) - xlim(1)) * (1 - zoomFactor) / 2];
%         newYLim = [yData - (ylim(2) - ylim(1)) * (1 - zoomFactor) / 2, ...
%                    yData + (ylim(2) - ylim(1)) * (1 - zoomFactor) / 2];
%     end
% 
%     % Apply new limits to zoom in or out at the hover point
%     app.UIAxes.XLim = newXLim;
%     app.UIAxes.YLim = newYLim;
% end

% Get the current mouse position in the figure
mousePosition = app.NeuromodToolboxMainWindowUIFigure.CurrentPoint;

% Get the position and size of the UIAxes object in pixels
axesPosition = app.UIAxes.Position; % [x, y, width, height]

% Check if the mouse position is within the UIAxes boundaries
if mousePosition(1) >= axesPosition(1) && ...
   mousePosition(1) <= (axesPosition(1) + axesPosition(3)) && ...
   mousePosition(2) >= axesPosition(2) && ...
   mousePosition(2) <= (axesPosition(2) + axesPosition(4))

    % Mouse is over UIAxes, so proceed with zooming

    % Convert the mouse position in the figure to data coordinates in UIAxes
    point = app.UIAxes.CurrentPoint; % Returns [x, y; x, y] matrix
    xData = point(1, 1); % X data coordinate
    yData = point(1, 2); % Y data coordinate

    % Define the zoom factor (e.g., 10% of current limits per scroll step)
    zoomFactor = 0.1;
    steps = 5; % Number of smooth steps to reach the target

    % Get current limits of the axes
    xlim = app.UIAxes.XLim;
    ylim = app.UIAxes.YLim;

    % Calculate the target limits based on scroll direction
    if event.VerticalScrollCount > 0
        % Scroll down: zoom out
        targetXLim = [xData - (xlim(2) - xlim(1)) * (1 + zoomFactor) / 2, ...
                      xData + (xlim(2) - xlim(1)) * (1 + zoomFactor) / 2];
        targetYLim = [yData - (ylim(2) - ylim(1)) * (1 + zoomFactor) / 2, ...
                      yData + (ylim(2) - ylim(1)) * (1 + zoomFactor) / 2];
    else
        % Scroll up: zoom in
        targetXLim = [xData - (xlim(2) - xlim(1)) * (1 - zoomFactor) / 2, ...
                      xData + (xlim(2) - xlim(1)) * (1 - zoomFactor) / 2];
        targetYLim = [yData - (ylim(2) - ylim(1)) * (1 - zoomFactor) / 2, ...
                      yData + (ylim(2) - ylim(1)) * (1 - zoomFactor) / 2];
    end

    % Calculate the incremental step for each zoom update
    xStep = (targetXLim - xlim) / steps;
    yStep = (targetYLim - ylim) / steps;

    % Smoothly interpolate from the current limits to the target limits
    for step = 1:steps
        % Incrementally update limits for smooth transition
        newXLim = xlim + xStep * step;
        newYLim = ylim + yStep * step;

        % Apply the new limits to the UIAxes
        app.UIAxes.XLim = newXLim;
        app.UIAxes.YLim = newYLim;

        % Pause briefly to create a smooth animation effect
        pause(0.01); % Adjust the pause duration as needed for speed
    end
end