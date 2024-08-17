function [app] = UIAxes_2ButtonDown(app, event)

%________________________________________________________________________________________
%% Callback Function that handles a click on the time plot
% This function captures the event when the user clicks on a plot. The
% event contains x and y coordinateds of the click in the event structure.
% It then searches for the closest available time point in the time vector
% to the x coordinate of the time plot the user clicked on.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Get the clicked point coordinates
clickPoint = event.IntersectionPoint;

% Calculate absolute differences between time_value and each element of time_vector
if isfield(app.Data.Info,'DownsampleFactor') && app.PreprocDataPlotCheckBox.Value == 1
    differences = abs(clickPoint(1) - app.Data.TimeDownsampled);
else
    differences = abs(clickPoint(1) - app.Data.Time);
end

% Find the index of the minimum difference
[min_difference, app.CurrentTimePoints] = min(differences);

%% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
% Plot functions are fully autonomous without needed the app
% object. It is only needed to get the necessary parameter.
% Both is combined in one function for convenience.
%input 2: 1 if plot time, 0 if no time plot necessary
%input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
%input 4: Whether Data plot should run in a movie or not
Organize_Prepare_Plot_and_Extract_GUI_Info(app,1,"Subsequent","Static",app.PlotEvents,app.Plotspikes);
        
