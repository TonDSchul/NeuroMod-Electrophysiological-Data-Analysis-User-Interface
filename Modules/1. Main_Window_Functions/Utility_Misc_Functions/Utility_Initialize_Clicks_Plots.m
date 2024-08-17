function Utility_Initialize_Clicks_Plots(app)
%________________________________________________________________________________________
%% Function to initilaze click functionality of plots
% This function gets called whenever something new is plotted in the main
% window to initiate the UIAxesButtonDown callcbacks that capture the x and
% y corrdinate of a point being clicked.

% UIAxesButtonDown and LineClicked = main window data plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)
% UIAxes_2ButtonDown and LineClickedTime = maine window time plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)

% Input Arguments:
% 1. app: main window app object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Set the ButtonDownFcn for UIAxes to register clicks in the plot outside of plotted lines (clicks in epmty plot regions)
% Intialize function
app.UIAxes.ButtonDownFcn = @(src1, event1) UIAxesButtonDown(app, event1);
% Add ButtonDownFcn to each line object in UIAxis
lines = findobj(app.UIAxes, 'Type', 'line');

%% Set the ButtonDownFcn for UIAxes to register clicks on a plotted line directly
for i = 1:numel(lines)
    % Call Lineclicked function if that happens
    lines(i).ButtonDownFcn = @(src1, event1) LineClicked(app, event1);
end

%% Set the ButtonDownFcn for UIAxes:2 to register clicks in the Time plot
% Intialize function
app.UIAxes_2.ButtonDownFcn = @(src1, event1) UIAxes_2ButtonDown(app, event1);
% Add ButtonDownFcn to each line object in UIAxis
lines = findobj(app.UIAxes_2, 'Type', 'line');

%% Set the ButtonDownFcn for UIAxes to register clicks on a plotted line directly
for i = 1:numel(lines)
    % Call Lineclicked function if that happens
    lines(i).ButtonDownFcn = @(src1, event1) LineClickedTime(app, event1);
end