function [ChannelAxes,fig] = Execute_Autorun_Initialize_Grid_Trace_Panel(Data,Window,PreservePlotChannelLocations,PlotAppearance)

PreserveChannelSpacing = PreservePlotChannelLocations;

[AllChannel,~,~] = Module_MainWindow_ActiveChannel_ChannerlNumber_Grid_Traces(Data.Info,[],"NumChan",Data.Info.ProbeInfo.ActiveChannel,PreserveChannelSpacing);

% Create normal figure
fig = figure('Color', PlotAppearance.MainWindow.Data.Color.MainBackground);

fig.Color = PlotAppearance.MainWindow.Data.Color.MainBackground;

% Create vertical layout
t = tiledlayout(fig, AllChannel, 1);
t.TileSpacing = 'none';
t.Padding     = 'compact';

ChannelAxes = cell(AllChannel,1);

for nChannel = 1:AllChannel
    ax = nexttile(t, nChannel);
    hold(ax,'on')

    ax.XTick = [];
    ax.YTick = [];
    ax.Box   = 'on';
    ax.LineWidth = 0.5;

    % Background color selection
    if strcmp(Window,"MainWindow")
        ax.Color  = PlotAppearance.MainWindow.Data.Color.MainBackground;
    elseif strcmp(Window,"ERP")
        ax.Color  = PlotAppearance.ERPWindow.SingleERP.BackgroundColor;
    elseif strcmp(Window,"StaticEventSpectrum")
        ax.Color  = PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;
    elseif strcmp(Window,"EventTFWindow")
        ax.Color  = PlotAppearance.TFWindow.BackgroundColor;
    end

    ax.XColor = ax.Color;
    ax.YColor = ax.Color;

    ax.XLabel.String = '';
    ax.YLabel.String = '';
    ax.Title.String  = '';

    ax.TickLength = [0 0];

    ChannelAxes{nChannel} = ax;
end