function app = Module_MainWindow_Initialize_Grid_Trace_Panel(app,Mainapp,Window)

PreserveChannelSpacing = Mainapp.PreservePlotChannelLocations;
if strcmp(Mainapp.Data.Info.RecordingType,"SpikeGLX NP") || Mainapp.Data.Info.ProbeInfo.OffSetRows
    if PreserveChannelSpacing == 1
        PreserveChannelSpacing = 0;
    end
end

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