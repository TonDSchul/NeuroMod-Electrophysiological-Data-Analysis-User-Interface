function [PlotAppearance] = Organize_Set_Standard_PlotAppearance(Type,PlotAppearance)

%________________________________________________________________________________________

%% Function to set the standrad appearance settings of each plot.  
% This function sets the standrad settings of all GUI plots. It also serves
% as a template if user wants to reset his costumizations
% All settings saved in one variable to be able to easily save and load variable as .mat to set new standard
% settings. 

% Inputs
% 1. PlotAppearance: strcuture holding all appearances.

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
    PlotAppearance.MainWindow.Data.MainXLabel = "";
    PlotAppearance.MainWindow.Data.MainYLabel = "";
    PlotAppearance.MainWindow.Data.MainFontSize = 10;
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
    PlotAppearance.MainWindow.Data.TimeFontSize = 10;
    
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
    PlotAppearance.SpectrumWindow.Data.TimeYLabel = "Power/Frequency (dB/Hz)";
    PlotAppearance.SpectrumWindow.Data.TimeFontSize = 10;

    % LineWodth
    PlotAppearance.SpectrumWindow.Data.SpectrumLinwWidth = 1.5; % blue

    % Color
    PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor = [1,1,1]; % white
    PlotAppearance.SpectrumWindow.Data.SpectrumColor = [0,0.447058823529412,0.741176470588235]; % blue
end