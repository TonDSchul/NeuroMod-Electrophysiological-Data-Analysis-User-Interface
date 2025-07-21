function Organize_Reset_Main_Plot(app,DeleteChannelData,KeepEvents,KeepSpikes,ReplaceDataType,PlotTime)

%________________________________________________________________________________________

%% Function to reset the data and/or time plot of the main window 

% This function gets called whenever data is extracted/chnaged that might be shown
% in the main window like events and spikes and preprocessing as well as
% when new data is loaded or the user selects the reset plots button

% Input:
% 1. app: app object of the extract data window to access the
% Load_Data_Window_Info variable which holds the loaded channel order and
% channelspacing 
% 2. DeleteChannelData: Hard reset of data plot; double, 1 or 0, determines whether main data plot
%channeldata is deleted. Can be set to 0 if only event or spike data
%changes
% 4: KeepEvents: double, 1 or 0, determines whether events lines should continue to be shown
% when they were already selected - set 1 when spikes are extracted to keep
% event line plots, set to 0 to delete event line plots
% 5: KeepSpikes: double, 1 or 0, determines whether spikes should continue to be shown
% when they were already selected - set 1 when events are extracted to keep
% spike plots, set to 0 to delete spike plots
% 6: ReplaceDataType: double, 1 or 0, set to 1 the set plotted datatype to
% 'Raw Data', otherwise userselection is not changed
% 8: PlotTime: number of samples time plot currently is set to
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Set standard values from Main window startup
app.MovieFramesPerSecond = 40;
app.CurrentTimePoints = PlotTime;
app.MovieTimeToJump = 0.02;
app.MovieTimeToJump = str2double(app.TimeRangeViewBox.Value(1:end-1))*app.MovieTimeToJump;

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

% Event Plots
if ~KeepEvents
    EventHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Events');
    if ~isempty(EventHandles)
        delete(EventHandles(:));
    end
    app.PlotEvents = "No";
    if strcmp(app.DropDown_2.Value,'Events')
        app.DropDown_2.Value = 'Non';
    end
end

% Spike Plots
if ~KeepSpikes
    SpikeHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Spikes');
    if ~isempty(SpikeHandles)
        delete(SpikeHandles(:));
    end
    app.Plotspikes = "No";
    if strcmp(app.DropDown_2.Value,'Spikes')
        app.DropDown_2.Value = 'Non';
    end
end

%% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
% Plot functions are fully autonomous without needed the app
% object. It is only needed to get the necessary parameter.
% Both is combined in one function for convenience.
%input 2: 1 if plot time, 0 if no time plot necessary
%input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
%input 4: Whether Data plot should run in a movie or not
Organize_Prepare_Plot_and_Extract_GUI_Info(app,1,"Initial","Static",app.PlotEvents,app.Plotspikes);

Utility_Initialize_Clicks_Plots(app,"Static");