function app = Module_MainWindow_Initialize_Grid_Trace_Panel(app)

AllChannel = length(unique(app.Data.Info.ProbeInfo.ycoords));
AllRows    = length(unique(app.Data.Info.ProbeInfo.xcoords));

% Create grid INSIDE PANEL
app.ChannelGrid = uigridlayout(app.Grid_Traces_View_Panel, [AllChannel, 1]);
app.ChannelGrid.RowSpacing    = 0;
app.ChannelGrid.ColumnSpacing = 0;
app.ChannelGrid.Padding = [100 0 0 30];   
app.ChannelGrid.BackgroundColor = ...
app.PlotAppearance.MainWindow.Data.Color.MainBackground;

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
    ax.LineWidth = 1;

    ax.Color  = app.PlotAppearance.MainWindow.Data.Color.MainBackground;
    ax.XColor = ax.Color;
    ax.YColor = ax.Color;
    
    ax.XLabel.String = '';
    ax.YLabel.String = '';
    ax.Title.String  = '';
    
    ax.Box = 'on';           % keep frame
    ax.TickLength = [0 0];   % important
    ax.LooseInset = [0 0 0 0];   % works for uiaxes (R2020b+)
    ax.InnerPosition = ax.OuterPosition;

    app.ChannelAxes{nChannel} = ax;
end