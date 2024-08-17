
function LineClickedTime(app,event)
%________________________________________________________________________________________
%% Function to Handle Case that user clicks at a plotted line in the main window time plot to switch displayed time
% This has for some reason to be handled by a different callback function
% than clicking on a empty part of the plot. This function is called within
% the callback specified in the Utility_Initialize_Clicks_Plots function,
% which is executed every time the plots get changed when the user clicks on some point of the time plot.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking containing x and y corrdinates, where the user clicked. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Get the clicked point coordinates
clickLine = event.IntersectionPoint;

% Calculate absolute differences between time_value and each element of time_vector
if isfield(app.Data.Info,'DownsampleFactor') && app.PreprocDataPlotCheckBox.Value == 1
    differences = abs(clickLine(1) - app.Data.TimeDownsampled);
else
    differences = abs(clickLine(1) - app.Data.Time);

end

% % Find the index of the minimum difference
[min_difference, app.CurrentTimePoints] = min(differences);

%% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
% Plot functions are fully autonomous without needed the app
% object. It is only needed to get the necessary parameter.
% Both is combined in one function for convenience.
%input 2: 1 if plot time, 0 if no time plot necessary
%input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
%input 4: Whether Data plot should run in a movie or not
Organize_Prepare_Plot_and_Extract_GUI_Info(app,1,"Subsequent","Static",app.PlotEvents,app.Plotspikes);
