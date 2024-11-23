
function LineClicked(app,event)

%________________________________________________________________________________________
%% Function to Handle Case that user clicks at a plotted line in the main window data plot to display channel name
% This function handles displaying a channel name in the main plot when the
% user clicks on a polotted line in the main plot. This has for some reason to be handled by a different callback function
% than clicking on a empty part of the plot. This function is called within
% the callback specified in the Utility_Initialize_Clicks_Plots function
% which gets called every time smt is plotted.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking containing x and y corrdinates, where the user clicked. This is set up and initialized in the
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

% Get the actual channel name from the data index clicked on
if app.Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
    if str2double(app.Data.Info.ProbeInfo.NrRows) == 1 
        ChannelNames = flip(sort(app.Data.Info.ProbeInfo.ActiveChannel));
        ChannelNames = ChannelNames(app.ActiveChannel);
        VectorToDisplay = ChannelNames(closestLine);
    end
else
    VectorToDisplay = app.ActiveChannel(closestLine);
end

TexttoShow{1} = convertStringsToChars(strcat("Channel ",num2str(VectorToDisplay),"; Time: ",num2str(clickPoint(1)),"s"));

if ~isempty(closestLine)
    app.ChannelTextHandle = text(app.UIAxes, clickPoint(1), clickPoint(2), TexttoShow, 'FontSize', 13, 'Color', 'k');
end