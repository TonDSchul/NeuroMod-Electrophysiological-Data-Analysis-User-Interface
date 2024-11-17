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

% Get UIaxis children (plotted data lines)
children = findobj(axis, 'Type', 'line', 'Tag', 'Data');
% Loop through all plotted lines

YValues = NaN(1,length(children));

for i = 1:length(children)
    if isprop(children(i), 'XData') == 1

        xData = children(i).XData;
        yData = children(i).YData;

        [~, XIndex] = min(abs(children(i).XData - clickPoint(1)));
        YValues(i) = yData(XIndex);
    else
        YValues(i) = []; 
    end
end

[~,closestLine] = min(abs(YValues - clickPoint(2)));

end