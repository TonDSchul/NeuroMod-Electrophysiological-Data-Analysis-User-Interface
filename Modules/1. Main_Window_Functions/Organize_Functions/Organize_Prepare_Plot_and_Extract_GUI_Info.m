function [app] = Organize_Prepare_Plot_and_Extract_GUI_Info(app,PlotTime,TimePlotInitial,DataPlotType,EventPlot,Plotspikes)

%________________________________________________________________________________________

%% Function to plot data in main window based on selecteions and datatypes of the GUI
% This function is called when the user changes the main window data or
% time plot to show new data. This includes spikes and event data. 

% Inputs: 
% 1. app: app object of GUI main window
% 2. PlotTime: Time in samples of the first datapoint plotted
% 3. TimePlotInitial: string specifying what is plotted in time plot. So far only
% Otions: "Initial"
% 4. DataPlotType: string specifying if movie or normal single plot is
% executed/selected. Either "Static" or "Movie"
% 5. EventPlot: string, "Events" to plot events, any other string to not
% plot events, like "Non"
% 6. Plotspikes: string, "Spikes" to plot spikes, any other string to not
% plot spikes, like "Non"

% Output:
% app object with updated app.CurrentTimePoints value capturing the first time
% point of the main window plot that is shown (in samples)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% If events addon selected in main window (events added to plot) select
% which input event channel to show
% EventPlot = "no" when checkbox disabled, "Events" when checkbox activated

if strcmp(EventPlot,"Events") && isfield(app.Data,'Events')
    EventData = app.Data.Events{app.CurrentEventChannel};
% If no events: Pass empty variable in following functions
else
    EventData = [];
end

if isfield(app.Data.Info,'DownsampleFactor') && strcmp(app.DropDown.Value,'Preprocessed Data')
    EventData = round(EventData./app.Data.Info.DownsampleFactor);
end

%% The following part extracts info from the GUI to determine the time range and select the time and data range based on this.

%% Extract Indicies to be plotted based on Main Window Settings
% CurrentTimePoints = Current Indicie at which displayed plot starts
if strcmp(app.DropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')  
    TimeDuration = str2double(app.TimeRangeViewBox.Value(1:end-1));
    StartIndex = app.CurrentTimePoints;
    StopIndex = StartIndex+round(TimeDuration*app.Data.Info.DownsampledSampleRate);
    if StopIndex > size(app.Data.Preprocessed,2)
        StopIndex = size(app.Data.Preprocessed,2);
    end
else % If not downsampled
    if strcmp(app.DropDown.Value,'Raw Data') || strcmp(app.DropDown.Value,'Preprocessed Data')
        TimeDuration = str2double(app.TimeRangeViewBox.Value(1:end-1));
        StartIndex = app.CurrentTimePoints;
        StopIndex = StartIndex+round(TimeDuration*app.Data.Info.NativeSamplingRate);
        if StopIndex > size(app.Data.Raw,2)
            StopIndex = size(app.Data.Raw,2);
        end
    else
        return;
    end
end

%% Extract Channel Number and set colormap
CommaIndex = strfind(app.ChannelSelectionEditField.Value,",");
app.Channelrange(1) = str2double(app.ChannelSelectionEditField.Value(1:CommaIndex-1));
app.Channelrange(2) = str2double(app.ChannelSelectionEditField.Value(CommaIndex+1:end));

colorMap = app.tempcolorMapset(app.Channelrange(1):app.Channelrange(2),:);

%% Handle Spike Data
% If spikes addon in main window plot selected: extract spikes that fall
% into the time range to be plotted

if ~strcmp(Plotspikes,"Spikes") || ~isfield(app.Data,'Spikes')
    SpikeData = [];
elseif strcmp(Plotspikes,"Spikes") && isfield(app.Data,'Spikes')
    SpikeData.Indicie = [];
    if isfield(app.Data.Info,'DownsampleFactor') && strcmp(app.DropDown.Value,'Preprocessed Data')
        TempDownsamplespikes = round(app.Data.Spikes.SpikeTimes ./ app.Data.Info.DownsampleFactor);
        SpikeDataIndex = TempDownsamplespikes >= StartIndex & TempDownsamplespikes <= StopIndex;
        SpikeData.Indicie = TempDownsamplespikes(SpikeDataIndex) - StartIndex; % Spike Times are indicies of whole datastream. To get indicie within shown time window substract start time
    else
        SpikeDataIndex = app.Data.Spikes.SpikeTimes >= StartIndex & app.Data.Spikes.SpikeTimes <= StopIndex;
        SpikeData.Indicie = app.Data.Spikes.SpikeTimes(SpikeDataIndex) - StartIndex; % Spike Times are indicies of whole datastream. To get indicie within shown time window substract start time
    end
    SpikeData.Position = app.Data.Spikes.SpikePositions(SpikeDataIndex,2);
    SpikeData.Indicie(SpikeData.Indicie==0) = 1;
    SpikeData.ChannelPosition = app.Data.Spikes.ChannelPosition;
end

%% Plot Data
% Those functions dont take the app object and are therefore plug and play
% for other figure objects 
% If Preprocessed data shown (Input argument 8 in plot fct. = 1 (1 if preprocessed, 0 if not))

% if isfield(app,'LastPlot') 
%     if ~isempty(app.LastPlot)
%         tempLastPlot = app.LastPlot;
%     end
% end

if strcmp(app.DropDown.Value,'Preprocessed Data') 
    % If downsampled data to show: Input argument 11 in plot fct = 1 (1 if donwsampled, 0 if not)
    if isfield(app.Data.Info,'DownsampleFactor') 
        app.LastPlot = "Preprocessed";  
        SpikeDataType = app.Data.Info.SpikeType;
        Module_MainWindow_Plot_Data(app.Data.Preprocessed(app.Channelrange(1):app.Channelrange(2),StartIndex:StopIndex),app.UIAxes,app.Data.TimeDownsampled(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,1,EventPlot,EventData,app.Data.Info.DownsampledSampleRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ChannelSpacing,app.PlotAppearance,app.SpikePlotType)
    % If Raw data has to be plotted
    else
        app.LastPlot = "Preprocessed";
        SpikeDataType = app.Data.Info.SpikeType;
        Module_MainWindow_Plot_Data(app.Data.Preprocessed(app.Channelrange(1):app.Channelrange(2),StartIndex:StopIndex),app.UIAxes,app.Data.Time(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,1,EventPlot,EventData,app.Data.Info.NativeSamplingRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ChannelSpacing,app.PlotAppearance,app.SpikePlotType)
    end
elseif strcmp(app.DropDown.Value,'Raw Data')
    app.LastPlot = "Raw";
    SpikeDataType = app.Data.Info.SpikeType;
    Module_MainWindow_Plot_Data(app.Data.Raw(app.Channelrange(1):app.Channelrange(2),StartIndex:StopIndex),app.UIAxes,app.Data.Time(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,0,EventPlot,EventData,app.Data.Info.NativeSamplingRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ChannelSpacing,app.PlotAppearance,app.SpikePlotType)
end

%% Plot Time

if PlotTime == 1    
% Those functions dont take the app object and are therefore plug and play
% for other figure objects 
% If Preprocessed data shown and downsampled: Pass downsampled time in plot
% fct.
    if isfield(app.Data.Info,'DownsampleFactor') && strcmp(app.DropDown.Value,'Preprocessed Data')
        [app.rectangleHandle] = Module_MainWindow_Plot_Time(app.UIAxes_2,app.Data.TimeDownsampled,StartIndex,StopIndex,TimePlotInitial,app.rectangleHandle,EventPlot,EventData,app.PlotAppearance);
    else
        [app.rectangleHandle] = Module_MainWindow_Plot_Time(app.UIAxes_2,app.Data.Time,StartIndex,StopIndex,TimePlotInitial,app.rectangleHandle,EventPlot,EventData,app.PlotAppearance);
    end
end

% Enable Button clicks on Main Window Data Plot (does it for data plot, time plot and clicks on lines within these plots.)
% Those fct. handle updating time and data plot when clicking a different
% time window in time plot

Utility_Initialize_Clicks_Plots(app);

%% Plot Spike Rate if Window for that is open
% app.PSTHApp: if spike rate window open, the variable Existflag will be
% property of that app (defined in startup fct of spike rate window)
if isprop(app.PSTHApp,'Existflag')

    CommaIndex = strfind(app.PSTHApp.ChannelSelectionPreprocessedChannelEditField.Value,",");
    ChannelSelection(1) = str2double(app.PSTHApp.ChannelSelectionPreprocessedChannelEditField.Value(1:CommaIndex-1));
    ChannelSelection(2) = str2double(app.PSTHApp.ChannelSelectionPreprocessedChannelEditField.Value(CommaIndex+1:end));
    
    DownsampleSPikeRate = app.PSTHApp.DownsampleCheckBox.Value;
    FilterOrder = app.PSTHApp.FilterOrder;
    CutoffFreque = app.PSTHApp.CutoffFreque;

    if strcmp(app.DropDown.Value,"Preprocessed Data")
        PreprocessedPlot = 1;
    else
        PreprocessedPlot = 0;
    end

    % Also contains the bar plot!
    if strcmp(app.DropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')
        [app.CurrentPlotData] = Analyse_Main_Window_Spike_Rate (app.Data,app.CurrentTimePoints,app.TimeRangeViewBox.Value,app.PSTHApp.Slider.Value,app.PSTHApp.UIAxes,app.Data.TimeDownsampled(StartIndex:StopIndex),app.PSTHApp.LockYLimCheckBox.Value,app.Data.Info.DownsampledSampleRate,ChannelSelection,StartIndex,StopIndex,PreprocessedPlot,DownsampleSPikeRate,CutoffFreque,FilterOrder,app.CurrentPlotData,app.PlotAppearance);
    else
        [app.CurrentPlotData] = Analyse_Main_Window_Spike_Rate (app.Data,app.CurrentTimePoints,app.TimeRangeViewBox.Value,app.PSTHApp.Slider.Value,app.PSTHApp.UIAxes,app.Data.Time(StartIndex:StopIndex),app.PSTHApp.LockYLimCheckBox.Value,app.Data.Info.NativeSamplingRate,ChannelSelection,StartIndex,StopIndex,PreprocessedPlot,DownsampleSPikeRate,CutoffFreque,FilterOrder,app.CurrentPlotData,app.PlotAppearance);
    end
end

%% Plot CSD if Window for that is open
% app.CSDApp: if csd window open, the variable ExistflagCSD will be
% property of that app (defined in startup fct of CSD window)
if isprop(app.CSDApp,'ExistflagCSD')
    CommaIndex = strfind(app.CSDApp.ChannelSelectionfromtoEditField.Value,",");
    ChannelSelection(1) = str2double(app.CSDApp.ChannelSelectionfromtoEditField.Value(1:CommaIndex-1));
    ChannelSelection(2) = str2double(app.CSDApp.ChannelSelectionfromtoEditField.Value(CommaIndex+1:end));
    % in main window user can select raw data. the csd however always
    % analyses preprocessed data. Since the DatatoPlot and TimeRangetoPlot are set above based on raw data when checkbox active, timerange and data have to be extracted again for preprocessed data and/or downsampled! 
    
    if strcmp(app.DropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')  
        TimeDurationTemp = str2double(app.TimeRangeViewBox.Value(1:end-1));
        StartTimeTemp = app.Data.Time(app.CurrentTimePoints);
        % Compute absolute differences
        differences = abs(app.Data.TimeDownsampled - StartTimeTemp);
        % Find the index of the minimum difference
        [~, StartIndex] = min(differences);
        StopIndex = StartIndex+round(TimeDurationTemp*app.Data.Info.DownsampledSampleRate);
    end

    hamwidth = str2double(app.CSDApp.HammWindowEditField.Value);
    ChannelSpacing = app.Data.Info.ChannelSpacing;

    if strcmp(app.CSDApp.DataTypeDropDown.Value,'Raw')
        [app.CSDApp.CSDClim,app.CurrentPlotData] = Analyse_Main_Window_CSD(hamwidth,ChannelSpacing,app.CSDApp.ChannelSelectionfromtoEditField.Value,app.CSDApp.CSDClim,app.CSDApp.UIAxes,app.Data.Raw(ChannelSelection(1):ChannelSelection(2),StartIndex:StopIndex),app.Data.Time(StartIndex:StopIndex),"Initial",app.CSDApp.LockCLimCheckBox.Value,app.CSDApp.TwoORThreeD,app.CurrentPlotData,app.PlotAppearance);
    elseif strcmp(app.CSDApp.DataTypeDropDown.Value,'Preprocessed')
        if isfield(app.Data.Info,'DownsampleFactor')
            [app.CSDApp.CSDClim,app.CurrentPlotData] = Analyse_Main_Window_CSD(hamwidth,ChannelSpacing,app.CSDApp.ChannelSelectionfromtoEditField.Value,app.CSDApp.CSDClim,app.CSDApp.UIAxes,app.Data.Preprocessed(ChannelSelection(1):ChannelSelection(2),StartIndex:StopIndex),app.Data.TimeDownsampled(StartIndex:StopIndex),"Initial",app.CSDApp.LockCLimCheckBox.Value,app.CSDApp.TwoORThreeD,app.CurrentPlotData,app.PlotAppearance);
        else
            [app.CSDApp.CSDClim,app.CurrentPlotData] = Analyse_Main_Window_CSD(hamwidth,ChannelSpacing,app.CSDApp.ChannelSelectionfromtoEditField.Value,app.CSDApp.CSDClim,app.CSDApp.UIAxes,app.Data.Preprocessed(ChannelSelection(1):ChannelSelection(2),StartIndex:StopIndex),app.Data.Time(StartIndex:StopIndex),"Initial",app.CSDApp.LockCLimCheckBox.Value,app.CSDApp.TwoORThreeD,app.CurrentPlotData,app.PlotAppearance);
        end
    end
end

%% Plot Spectral Power Density estimate window is open
if isprop(app.SpectralEstApp,'ExistflagSDE')
    % in main window user can select raw data. the csd however always
    % analyses preprocessed data. Since the DatatoPlot and TimeRangetoPlot are set above based on raw data when checkbox active, timerange and data have to be extracted again for preprocessed data and/or downsampled! 
    CommaIndex = strfind(app.SpectralEstApp.ChannelSelectionPreprocessedChannelEditField.Value,",");
    ChannelSelection(1) = str2double(app.SpectralEstApp.ChannelSelectionPreprocessedChannelEditField.Value(1:CommaIndex-1));
    ChannelSelection(2) = str2double(app.SpectralEstApp.ChannelSelectionPreprocessedChannelEditField.Value(CommaIndex+1:end));
    
    if strcmp(app.DropDown.Value,'Raw Data') && isfield(app.Data.Info,'DownsampleFactor') 
        TimeDurationTemp = str2double(app.TimeRangeViewBox.Value(1:end-1));
        StartTimeTemp = app.Data.Time(app.CurrentTimePoints);
        % Compute absolute differences
        differences = abs(app.Data.TimeDownsampled - StartTimeTemp);
        % Find the index of the minimum difference
        [~, StartIndex] = min(differences);
        StopIndex = StartIndex+round(TimeDurationTemp*app.Data.Info.DownsampledSampleRate);
    end

    if strcmp(app.SpectralEstApp.DataTypeDropDown.Value,'Raw')
        [app.SpectralEstApp.PDLim,app.CurrentPlotData] = Analyse_Main_Window_Spectral_Density_Estimate(app.Data.Raw(ChannelSelection(1):ChannelSelection(2),StartIndex:StopIndex),app.Data.Info.NativeSamplingRate,app.SpectralEstApp.UIAxes,app.Data.Time(StartIndex:StopIndex),app.SpectralEstApp.PDLim,app.SpectralEstApp.LockYLimCheckBox.Value,app.CurrentPlotData,app.PlotAppearance);
    elseif strcmp(app.SpectralEstApp.DataTypeDropDown.Value,'Preprocessed')
        if isfield(app.Data.Info,'DownsampleFactor')
            [app.SpectralEstApp.PDLim,app.CurrentPlotData] = Analyse_Main_Window_Spectral_Density_Estimate(app.Data.Preprocessed(ChannelSelection(1):ChannelSelection(2),StartIndex:StopIndex),app.Data.Info.DownsampledSampleRate,app.SpectralEstApp.UIAxes,app.Data.TimeDownsampled(StartIndex:StopIndex),app.SpectralEstApp.PDLim,app.SpectralEstApp.LockYLimCheckBox.Value,app.CurrentPlotData,app.PlotAppearance);
        else
            [app.SpectralEstApp.PDLim,app.CurrentPlotData] = Analyse_Main_Window_Spectral_Density_Estimate(app.Data.Preprocessed(ChannelSelection(1):ChannelSelection(2),StartIndex:StopIndex),app.Data.Info.NativeSamplingRate,app.SpectralEstApp.UIAxes,app.Data.Time(StartIndex:StopIndex),app.SpectralEstApp.PDLim,app.SpectralEstApp.LockYLimCheckBox.Value,app.CurrentPlotData,app.PlotAppearance);
        end
    end
end
