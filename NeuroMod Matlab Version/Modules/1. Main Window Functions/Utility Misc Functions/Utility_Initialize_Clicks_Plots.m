function Utility_Initialize_Clicks_Plots(app,OldDataPlotName)

%________________________________________________________________________________________
%% Function to initialize click functionality of plots
% This function gets called when something new is plotted in the main
% window to initiate the UIAxesButtonDown callcbacks that capture the x and
% y corrdinate of a point being clicked. But only sets click callback if
% reason of plot is not jsut to update the time. Istn necessary then and
% reduces overhead

% UIAxesButtonDown and LineClicked = main window data plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)
% UIAxes_2ButtonDown and LineClickedTime = maine window time plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)

% Input Arguments:
% 1. app: main window app object
% 2. OldDataPlotName: string with why plot was updated. If
% "MainWindowTimeManipulation" OR
% "MainWindowTimeManipulationMovie" dont update click callback since its
% not necessary then

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Set the ButtonDownFcn for UIAxes to register clicks in the plot outside of plotted lines (clicks in epmty plot regions)
% Intialize function

%% Data Plot
if ~strcmp(OldDataPlotName,"MainWindowTimeManipulation") && ~strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
    if isempty(app.UIAxes.ButtonDownFcn)
        app.UIAxes.ButtonDownFcn = @(src1, event1) UIAxesButtonDown(app, event1);
    end   
    % Add ButtonDownFcn to each line object in UIAxis    
    lines = findobj(app.UIAxes, 'Type', 'line');
    
    %% Set the ButtonDownFcn for UIAxes to register clicks on a plotted line directly
    for i = 1:numel(lines)
        % Call Lineclicked function if that happens
        lines(i).ButtonDownFcn = @(src1, event1) LineClicked(app, event1);
    end
end

%% Make Data Plot scrollable
if ~strcmp(OldDataPlotName,"MainWindowTimeManipulation") && ~strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
    if ~isprop(app.NeuromodToolboxMainWindowUIFigure,'WindowScrollWheelFcn') 
        app.NeuromodToolboxMainWindowUIFigure.WindowScrollWheelFcn = @(src, event) DataPlotonScrollZoom(app, event);
    else
        if isempty(app.NeuromodToolboxMainWindowUIFigure.WindowScrollWheelFcn)
            app.NeuromodToolboxMainWindowUIFigure.WindowScrollWheelFcn = @(src, event) DataPlotonScrollZoom(app, event);
        end
    end
end

if ~strcmp(OldDataPlotName,"MainWindowTimeManipulation") && ~strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
    %% Time Plot
    if isempty(app.UIAxes_2.ButtonDownFcn)
        %% Set the ButtonDownFcn for UIAxes:2 to register clicks in the Time plot
        % Intialize function
        app.UIAxes_2.ButtonDownFcn = @(src1, event1) UIAxes_2ButtonDown(app, event1);
        
    end
    % Add ButtonDownFcn to each line object in UIAxis
    lines = findobj(app.UIAxes_2, 'Type', 'line');
    
    % Add ButtonDownFcn to each line object in UIAxis
    rectangle = findobj(app.UIAxes_2, 'Type', 'rectangle');
    
    %% Set the ButtonDownFcn for UIAxes to register clicks on a plotted line directly
    
    for i = 1:numel(lines)
        % Call Lineclicked function if that happens
        lines(i).ButtonDownFcn = @(src1, event1) LineClickedTime(app, event1);
    end
    
    rectangle(1).ButtonDownFcn = @(src1, event1) LineClickedTime(app, event1);
end


