function [ChannelAxes,fig] = Execute_Autorun_Initialize_Grid_Trace_Panel(Data,Window,PreservePlotChannelLocations,PlotAppearance)

%________________________________________________________________________________________

%% Function to initialze the grid of axes to plot data in grid view in autorun mode!
% creates the figure and channelaxes
% initiates within a normal Matlab figure object.

% each axes or probe column plots data for all rows concatonated together
% and separated by black vertical lines being plotted in the same axes.
% This boosts performance compared to an axes for each channel individually

% Inputs: 
% 1. Data: struc with all relevant data components
% 2. Window: char, for which kind of analysis this function is called
% 3. PreservePlotChannelLocations: 1 or 0 whether to preserve distances
% between channel with inactive channel islands inbetween active ones
% 4. PlotAppearance: struc with all user defined or standard plot
% appearance settings

% Outputs:
% 1. ChannelAxes: cell array with each cell containing an axes generated (for each probe column)
% 2. fig: figure object channel axes are created in 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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