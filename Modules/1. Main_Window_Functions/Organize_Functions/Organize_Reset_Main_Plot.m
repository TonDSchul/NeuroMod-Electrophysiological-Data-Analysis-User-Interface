function Organize_Reset_Main_Plot(app,DeleteChannelData,DeleteTimePlot,KeepEvents,KeepSpikes,ReplaceDataType)

% delte data plots
if DeleteChannelData
    app.UIAxes.NextPlot = "replace"; 
    plot(app.UIAxes,0,0);
    app.UIAxes.NextPlot = "add"; 
    app.UIAxes.Box = "off";

    % Check if the Y-axis is reversed
    if strcmp(app.UIAxes.YDir, 'reverse')
        if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        else
            app.UIAxes.YDir = 'normal';
        end
    else
        if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
            app.UIAxes.YDir = 'reverse';
        end
    end
end

%Take care of potentially changed backgroundcolor
app.UIAxes.Color = app.PlotAppearance.MainWindow.Data.Color.MainBackground;
app.UIAxes_2.Color = app.PlotAppearance.MainWindow.Data.Color.TimeBackground;
app.UIAxes.FontSize = app.PlotAppearance.MainWindow.Data.MainFontSize;
app.UIAxes_2.FontSize = app.PlotAppearance.MainWindow.Data.TimeFontSize;

if ReplaceDataType
    app.DropDown.Value = 'Raw Data';
end

% Delete time plots
if DeleteTimePlot
    app.UIAxes_2.NextPlot = "replace"; 
    plot(app.UIAxes_2,0,0);
    app.UIAxes_2.NextPlot = "add"; 
end

% Event Plots
if ~KeepEvents
    EventHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');
    if ~isempty(EventHandles)
        delete(EventHandles(:));
    end
    app.PlotEvents = "No";
    app.DropDown_2.Value = 'Non';
end

% Spike Plots
if ~KeepSpikes
    SpikeHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Spikes');
    if ~isempty(SpikeHandles)
        delete(SpikeHandles(:));
    end
    app.Plotspikes = "No";
    app.DropDown_2.Value = 'Non';
end

%% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
% Plot functions are fully autonomous without needed the app
% object. It is only needed to get the necessary parameter.
% Both is combined in one function for convenience.
%input 2: 1 if plot time, 0 if no time plot necessary
%input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
%input 4: Whether Data plot should run in a movie or not
Organize_Prepare_Plot_and_Extract_GUI_Info(app,1,"Initial","Events",app.PlotEvents,app.Plotspikes);

Utility_Initialize_Clicks_Plots(app,"Static");