function app = Module_MainWindow_Initialize_Grid_Trace_Panel(app,Mainapp,Window)

%________________________________________________________________________________________

%% Function to initialze the grid of axes to plot data in grid view
% required is a app.Panel object to initiate all axes. One axes is
% initiated for each probe column. this acts like a subplot arrangement
% without using subplot (not usable in apps)

% each axes or probe column plots data forall rows concatonated together
% and separated by black vertical lines being plotted in the same axes.
% This boosts performance compared to an axes for each channel individually

% this function gets called for the main window data plot, ERP plot and
% spectrm plot. Thats ehy the second input ar is Mainapp, bc app can be one
% of the above

% Inputs: 
% 1. app: object to app window with app.Grid_Traces_View_Panel objectto
% intiate axes in
% 2. Mainapp: object to main window
% 3. Window: char, from which window this is called

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

PreserveChannelSpacing = Mainapp.PreservePlotChannelLocations;

[AllChannel,~,~] = Module_MainWindow_ActiveChannel_ChannerlNumber_Grid_Traces(Mainapp.Data.Info,[],"NumChan",Mainapp.Data.Info.ProbeInfo.ActiveChannel,PreserveChannelSpacing);

% Create grid INSIDE PANEL
app.ChannelGrid = uigridlayout(app.Grid_Traces_View_Panel, [AllChannel, 1]);
app.ChannelGrid.RowSpacing    = 0;

app.ChannelGrid.ColumnSpacing = 0;
if strcmp(Window,"StaticEventSpectrum")
    app.ChannelGrid.Padding = [135 0 0 0]; 
else
    app.ChannelGrid.Padding = [100 0 0 0]; 
end
app.ChannelGrid.BackgroundColor = ...
Mainapp.PlotAppearance.MainWindow.Data.Color.MainBackground;

% Preallocate axes storage
app.ChannelAxes = cell(AllChannel,1);

for nChannel = 1:AllChannel
    ax = uiaxes(app.ChannelGrid);
    ax.Layout.Row    = nChannel;
    ax.Layout.Column = 1;
    hold(ax,'on')
    ax.XTick = [];
    ax.YTick = [];
    ax.Box   = 'on';
    ax.LineWidth = 0.5;
    
    if strcmp(Window,"MainWindow")
        ax.Color  = Mainapp.PlotAppearance.MainWindow.Data.Color.MainBackground;
    elseif strcmp(Window,"ERP")
        ax.Color  = Mainapp.PlotAppearance.ERPWindow.SingleERP.BackgroundColor;
    elseif strcmp(Window,"StaticEventSpectrum")
        ax.Color  = Mainapp.PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;
    elseif strcmp(Window,"EventTFWindow")
        ax.Color  = Mainapp.PlotAppearance.TFWindow.BackgroundColor;
    end

    ax.XColor = ax.Color;
    ax.YColor = ax.Color;
    
    ax.XLabel.String = '';
    ax.YLabel.String = '';
    ax.Title.String  = '';
    
    ax.Box = 'on';           % keep frame
    ax.TickLength = [0 0];   % important
    ax.LooseInset = [0 0 0 0];  
    ax.InnerPosition = ax.OuterPosition;

    app.ChannelAxes{nChannel} = ax;
end