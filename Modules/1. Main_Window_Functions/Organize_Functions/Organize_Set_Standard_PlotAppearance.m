function [PlotAppearance] = Organize_Set_Standard_PlotAppearance(Type,PlotAppearance)

%________________________________________________________________________________________

%% Function to set the standrad appearance settings of each plot.  
% This function hard codes standard plot appearances. It is called when no
% .m file is saved in GUI_Path/Modules/MISC/Variables (do not edit!) to
% create a new Template_PlotAppearance.m file

% Inputs
% 1. Type: string, Specifies what settings to reset to standard. "All" to
% reset all appearances OR "MainDataPlot" OR "MainTimePlot" OR
% "SpectrumPlot" to reet window specific plot settings.
% 2. PlotAppearance: strcuture holding all appearances.

% Outputs
% 1. PlotAppearance: strcuture holding all appearances.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Main Window Data Plot
if strcmp(Type,"MainDataPlot") || strcmp(Type,"All")
    % Lables and Fontsize
    PlotAppearance.MainWindow.Data.Title.Raw = "Raw Data";
    PlotAppearance.MainWindow.Data.Title.Preprocessed = "Preprocessed Data";
    PlotAppearance.MainWindow.Data.Plottype = "Individual Lines"; % Alternative: "Imagesc"
    PlotAppearance.MainWindow.Data.MainXLabel = "";
    PlotAppearance.MainWindow.Data.MainYLabel = "";
    PlotAppearance.MainWindow.Data.MainFontSize = 12;
    % Colors
    PlotAppearance.MainWindow.Data.Color.MainSpikes = [1,0,0]; % red
    PlotAppearance.MainWindow.Data.Color.MainEvents = [0,0,0]; % black
    PlotAppearance.MainWindow.Data.Color.MainBackground = [1,1,1]; % white
    % LineWidths
    PlotAppearance.MainWindow.Data.LineWidth.MainSpikes = 2.5;
    PlotAppearance.MainWindow.Data.LineWidth.MainEvents = 2.5;
    PlotAppearance.MainWindow.Data.LineWidth.MainData = 1.5;
end

%% Main Window Time Plot
if strcmp(Type,"MainTimePlot") || strcmp(Type,"All")
    
    % Lables and Fontsize
    PlotAppearance.MainWindow.Data.TimeTitle = "";
    PlotAppearance.MainWindow.Data.TimeXLabel = "Time [s]";
    PlotAppearance.MainWindow.Data.TimeYLabel = "";
    PlotAppearance.MainWindow.Data.TimeFontSize = 12;
    
    % Colors
    PlotAppearance.MainWindow.Data.Color.TimeEvents = [0,0,0]; % black
    PlotAppearance.MainWindow.Data.Color.TimeRectangle = [1,0,0]; % blue
    PlotAppearance.MainWindow.Data.Color.TimeBackground = [0.9,0.9,0.9]; % black
    
    % LineWidths
    PlotAppearance.MainWindow.Data.LineWidth.TimeEvents = 1.5;
    PlotAppearance.MainWindow.Data.LineWidth.TimeRectangle = 2;

end

%% Main Window Cont. Spectrum
if strcmp(Type,"SpectrumPlot") || strcmp(Type,"All") 
    % Lables and Fontsize
    PlotAppearance.SpectrumWindow.Data.TimeXLabel = "Frequency [Hz]";
    PlotAppearance.SpectrumWindow.Data.TimeYLabel = "Power/Frequency [dB/Hz]";
    PlotAppearance.SpectrumWindow.Data.TimeFontSize = 11;
    
    % LineWidth
    PlotAppearance.SpectrumWindow.Data.SpectrumLinwWidth = 1.5; % blue

    % Color
    PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor = [1,1,1]; % white
    PlotAppearance.SpectrumWindow.Data.SpectrumColor = [0,0.447058823529412,0.741176470588235]; % blue
end

%% ERP Window
if strcmp(Type,"ERPPlot") || strcmp(Type,"All") 
    % Lables and Fontsize
    PlotAppearance.ERPWindow.SingleERP.XLabel = "Time [s]";
    PlotAppearance.ERPWindow.SingleERP.YLabel = "Signal [mV]";
    PlotAppearance.ERPWindow.SingleERP.FontSize = 11;
    
    % LineWidth
    PlotAppearance.ERPWindow.SingleERP.EventLineWidth = 1; % 
    PlotAppearance.ERPWindow.SingleERP.MeanLineWidth = 2; % 
    PlotAppearance.ERPWindow.SingleERP.TriggerLineWidth = 2; % 

    % Color
    PlotAppearance.ERPWindow.SingleERP.EventColor = [0.75,0.75,0.75]; % grey
    PlotAppearance.ERPWindow.SingleERP.MeanColor = [0,0,0]; % black
    PlotAppearance.ERPWindow.SingleERP.TriggerColor = [1,0,0]; % red
    PlotAppearance.ERPWindow.SingleERP.BackgroundColor = [1,1,1]; % white

    % Multiple ERPs (for each channel)
    % Lables and Fontsize
    PlotAppearance.ERPWindow.MultipleERP.XLabel = "Time [s]";
    PlotAppearance.ERPWindow.MultipleERP.YLabel = "";
    PlotAppearance.ERPWindow.MultipleERP.FontSize = 11;
    
    % LineWidth
    PlotAppearance.ERPWindow.MultipleERP.MeanLineWidth = 1; % 
    PlotAppearance.ERPWindow.MultipleERP.TriggerLineWidth = 1; % 

    % Color
    PlotAppearance.ERPWindow.MultipleERP.TriggerColor = [1,0,0]; % red
    PlotAppearance.ERPWindow.MultipleERP.BackgroundColor = [1,1,1]; % white
end

%% CSD Window
if strcmp(Type,"CSDPlot") || strcmp(Type,"All") 
    % Lables and Fontsize
    PlotAppearance.CSDWindow.XLabel = "Time [s]";
    PlotAppearance.CSDWindow.YLabel = "Depth [µm]";
    PlotAppearance.CSDWindow.CLabel = "Signal [mV/mm^2]";
    PlotAppearance.CSDWindow.FontSize = 11;
    
    % LineWidth
    PlotAppearance.CSDWindow.TriggerLineWidth = 2; % 

    % Color
    PlotAppearance.CSDWindow.TriggerColor = [1,0,0]; % red
    PlotAppearance.CSDWindow.BackgroundColor = [1,1,1]; % white

end

%% TF Window
if strcmp(Type,"TFPlot") || strcmp(Type,"All") 
    % Lables and Fontsize
    PlotAppearance.TFWindow.XLabel = "Time [s]";
    PlotAppearance.TFWindow.YLabel = "Frequency [Hz]";
    PlotAppearance.TFWindow.CLabel = "dB Power";
    PlotAppearance.TFWindow.FontSize = 11;
    
    % LineWidth
    PlotAppearance.TFWindow.TriggerLineWidth = 2; % 

    % Color
    PlotAppearance.TFWindow.TriggerColor = [1,0,0]; % red
    PlotAppearance.TFWindow.BackgroundColor = [1,1,1]; % white

end

%% CSD Live Window
if strcmp(Type,"LiveCSDPlot") || strcmp(Type,"All") 
    % Lables and Fontsize
    PlotAppearance.LiveCSDWindow.XLabel = "Time [s]";
    PlotAppearance.LiveCSDWindow.YLabel = "Depth [µm]";
    PlotAppearance.LiveCSDWindow.CLabel = "Signal [mV/mm^2]";
    PlotAppearance.LiveCSDWindow.FontSize = 11;

    PlotAppearance.LiveCSDWindow.BackgroundColor = [1,1,1]; % white
end

%% Power Estimate Live Window
if strcmp(Type,"PowerEstimatePlot") || strcmp(Type,"All") 
    % Lables and Fontsize
    PlotAppearance.LivePowerEstimateWindow.XLabel = "";
    PlotAppearance.LivePowerEstimateWindow.YLabel = "Power/Frequency [dB/Hz]";
    PlotAppearance.LivePowerEstimateWindow.FontSize = 11;

    PlotAppearance.LivePowerEstimateWindow.BackgroundColor = [1,1,1]; % white
    PlotAppearance.LivePowerEstimateWindow.BarColor = [0,0,0]; % black
end

%% Live Spike Rate Window
if strcmp(Type,"LiveSpikeRatePlot") || strcmp(Type,"All") 
    % Lables and Fontsize
    PlotAppearance.LiveSpikeRateWindow.XLabel = "Time [s]";
    PlotAppearance.LiveSpikeRateWindow.YLabel = "Spike Rate [Hz]";
    PlotAppearance.LiveSpikeRateWindow.FontSize = 11;

    PlotAppearance.LiveSpikeRateWindow.BackgroundColor = [1,1,1]; % white
    PlotAppearance.LiveSpikeRateWindow.BarColor = [0,0,0]; % black
end

%% Internal Event Spike Analysis
if strcmp(Type,"InternalEventSpikePlot") || strcmp(Type,"All") 
    % Main plot
    % Lables and Fontsize
    PlotAppearance.InternalEventSpikePlot.MainPlotXLabel = "";
    PlotAppearance.InternalEventSpikePlot.MainPlotYLabel = "Depth [µm]";
    PlotAppearance.InternalEventSpikePlot.MainPlotFontSize = 11;
    % Color
    PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor = [1,1,1]; % white
    PlotAppearance.InternalEventSpikePlot.MainPlotTriggerColor = [1,0,0]; % red
    PlotAppearance.InternalEventSpikePlot.MainPlotSpikeColor = [0.9,0.9,0.9]; % grey
    % LineWidth
    PlotAppearance.InternalEventSpikePlot.MainPlotTriggerWidth = 2; % 
    PlotAppearance.InternalEventSpikePlot.MainPlotSpikeWidth = 2.5; % 

    % Spike rate over time
    % Lables and Fontsize
    PlotAppearance.InternalEventSpikePlot.SRTimePlotXLabel = "Time [s]";
    PlotAppearance.InternalEventSpikePlot.SRTimePlotYLabel = "Spike Rate [Hz]";
    PlotAppearance.InternalEventSpikePlot.SRTimePlotFontSize = 11;
    % Color
    PlotAppearance.InternalEventSpikePlot.SRTimePlotBarColor = [0,0,0]; % black
    PlotAppearance.InternalEventSpikePlot.SRTimePlotBackgroundColor = [1,1,1]; % white
    % Spike rate over channel
    PlotAppearance.InternalEventSpikePlot.SRChannelPlotXLabel = "Spike Rate per";
    PlotAppearance.InternalEventSpikePlot.SRChannelPlotYLabel = "";
    PlotAppearance.InternalEventSpikePlot.SRChannelPlotFontSize = 11;
    % Color
    PlotAppearance.InternalEventSpikePlot.SRChannelPlotBarColor = [0,0,0]; % black
    PlotAppearance.InternalEventSpikePlot.SRChannelPlotBackgroundColor = [1,1,1]; % white
end