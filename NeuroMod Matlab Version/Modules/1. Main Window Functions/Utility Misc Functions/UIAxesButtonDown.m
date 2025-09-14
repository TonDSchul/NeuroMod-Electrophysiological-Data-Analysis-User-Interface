function [app] = UIAxesButtonDown(app, event)
%________________________________________________________________________________________
%% Callback Function that handles a click on the data plot and displays a corresponding channel
% This function captures the event when the user clicks on a plot. The
% event contains x and y coordinateds of the click in the event structure.
% It then searches for the closest available y value in the data matrix
% plotted to the y coordinate of the data plot the user clicked on.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Get the clicked point coordinates
clickPoint = event.IntersectionPoint;
% Remove previous text handle from plot
delete(app.ChannelTextHandle);
% Identify the closest line to the clicked point
closestLine = Utility_findClosestLineDatPlot(app,app.UIAxes, clickPoint);

if app.Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
    TempActiveChannel = (str2double(app.Data.Info.ProbeInfo.NrChannel)*str2double(app.Data.Info.ProbeInfo.NrRows)+1) - app.ActiveChannel;
    TexttoShow{1} = convertStringsToChars(strcat("Channel ",num2str(TempActiveChannel(closestLine)),"; Time: ",num2str(clickPoint(1)),"s"));
else
    TexttoShow{1} = convertStringsToChars(strcat("Channel ",num2str(app.ActiveChannel(closestLine)),"; Time: ",num2str(clickPoint(1)),"s"));
end

if ~isempty(closestLine)
    app.ChannelTextHandle = text(app.UIAxes, clickPoint(1), clickPoint(2),TexttoShow , 'FontSize', 13, 'Color', 'k');
end
