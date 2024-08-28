function closestLine = Utility_findClosestLineDatPlot(app,axis, clickPoint)
%________________________________________________________________________________________
%% Function to identify the closest line to the point in the plot the user clicked on
% This function gets called when the user clicks on the data plot to
% display the channel nr. For this, the y value of the clicked position
% has to be compared to the y values of the plotteded data lines. The Nr of data line
% closest to the clicked point is the channel nr to display

% Input Arguments:
% 1. app: app -- not needed ynamore but maybe useful for modifications
% 2. axis: handle to fugure the user clicked on (data plot in main window)
% 3. clickPoint: 1 x 3 double containing the x and y and z value of the point the
% user clicked on (z==0) -- can also be 1 x 2 with just x and y

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Function to identify the closest line to the point in the plot the user clicked on
% axis = UIaxis object from main window (app.UIaxis)
% clickPoint = x and y coordinates in the plot the user clicked on

%%
% Get UIaxis children (plotted data lines)
children = findobj(axis, 'Type', 'line', 'Tag', 'Data');

%children = axis.Children;

% intialize variable for distances to all plotted objects 
distances = zeros(1, numel(children));

% Loop through all plotted lines
for i = 1:length(children)
% for i = 1:numel(children)
    if isprop(children(i),'XData') == 1
        % Get x and y of the current line 
        xData = children(i).XData;
        yData = children(i).YData;
        % Calculate euclidian distance from clicked point to current line
        distances(i) = min((xData - clickPoint(1)).^2 + (yData - clickPoint(2)).^2);
    else
        % If no x data: set distance super high so that this is not
        % selected
        distances(i) = 1000000;
    end
    
end
% Index of plotted lines with minimum distance to the clicked position
[~, closestLine] = min(distances);
end