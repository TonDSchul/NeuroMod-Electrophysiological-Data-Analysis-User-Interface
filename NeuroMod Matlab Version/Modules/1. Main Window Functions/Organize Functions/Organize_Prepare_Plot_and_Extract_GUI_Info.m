function [app] = Organize_Prepare_Plot_and_Extract_GUI_Info(app,PlotTime,TimePlotInitial,DataPlotType,EventPlot,Plotspikes)

%________________________________________________________________________________________

%% Function to plot data in main window based on selecteions and datatypes of the GUI
% This function is called when the user changes the main window data or
% time plot to show new data. This includes spikes and event data. 

% Inputs: 
% 1. app: app object of GUI main window
% 2. PlotTime: 1 or 0, specifying whether time plot should be updated
% 3. TimePlotInitial: string specifying if time plot is hard-resetted. So far only
% Otions: "Initial" (hard reset) or "subsequent"
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
        StopIndex = StartIndex+ceil(TimeDuration*app.Data.Info.NativeSamplingRate);
        if StopIndex > size(app.Data.Raw,2)
            StopIndex = size(app.Data.Raw,2);
        end
    else
        return;
    end
end

%% Extract Channel Number and set colormap

if strcmp(app.ChannelChange,"EditField") && ~isempty(app.ProbeViewWindowHandle)
    if ~isempty(app.ProbeViewWindowHandle.ChannelSelectionEditField.Value)

        [app.Channelrange] = Organize_Convert_ActiveChannel_to_DataChannel(app.Data.Info.ProbeInfo.ActiveChannel,app.ActiveChannel,'MainPlot');

        colorMap = app.tempcolorMapset(app.Channelrange,:);
    else
        app.ChannelChange = "ProbeView";
        [app.Channelrange] = Organize_Convert_ActiveChannel_to_DataChannel(app.Data.Info.ProbeInfo.ActiveChannel,app.ActiveChannel,'MainPlot');
    
        colorMap = app.tempcolorMapset(app.Channelrange,:);
    end
elseif strcmp(app.ChannelChange,"EditField") && isempty(app.ProbeViewWindowHandle)
    app.ChannelChange = "ProbeView";
    [app.Channelrange] = Organize_Convert_ActiveChannel_to_DataChannel(app.Data.Info.ProbeInfo.ActiveChannel,app.ActiveChannel,'MainPlot');

    colorMap = app.tempcolorMapset(app.Channelrange,:);
end

if strcmp(app.ChannelChange,"ProbeView")
    
    [app.Channelrange] = Organize_Convert_ActiveChannel_to_DataChannel(app.Data.Info.ProbeInfo.ActiveChannel,app.ActiveChannel,'MainPlot');
    
    colorMap = app.tempcolorMapset(app.Channelrange,:);
end

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

    SpikeData.Indicie(SpikeData.Indicie==0) = 1;
    SpikeData.ChannelPosition = app.Data.Spikes.ChannelPosition;

    %% If doesnt start with 0 um rescale so that its correctly shown in main window plot
    if strcmp(app.Data.Info.SpikeType,"Kilosort") || strcmp(app.Data.Info.SpikeType,"SpikeInterface")

        UinquePos = unique(app.Data.Spikes.ChannelPosition(:,1));
    
        if numel(UinquePos)>=2
            SpikeData.Position = app.Data.Spikes.DataCorrectedSpikePositions(SpikeDataIndex,2); 
        else
            SpikeData.Position = app.Data.Spikes.SpikePositions(SpikeDataIndex,2);
        end
    else
       SpikeData.Position = app.Data.Spikes.SpikePositions(SpikeDataIndex,2); 

       if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
           [~,~,~,FakeDepths] = Spike_Module_Analysis_Determine_Depths(app.Data,0,app.ActiveChannel);

           SpikeData.Position = FakeDepths(SpikeData.Position);
       end
    end
end

%% Plot Data
% Those functions dont take the app object and are therefore plug and play
% for other figure objects 
% If Preprocessed data shown (Input argument 8 in plot fct. = 1 (1 if preprocessed, 0 if not))

MainPlot = 1;
% if main window not selected in probe view dont plot but only when user is
% not changing time in main window plot
if ~isempty(app.ProbeViewWindowHandle) % Add option to probe view when available
    if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        if ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"Main Window") && ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"All Windows Opened")
            MainPlot = 0;
        end
    end
end
ExtraAnalysisWindowsType = [];
% when user manipulates time in main window always execute -- also when
% preprocessing, event or spike extraction occurs, bc plot has to be
% resetted
% For the plot, DataPlotType has to be "Movie" or "Static". Therefore its
% set to this while saving the other selection like
% MainWindowTimeManipulation for example for the main window analysis plots
if strcmp(DataPlotType,"MainWindowTimeManipulation")
    MainPlot = 1;
    OldDataPlotName = "MainWindowTimeManipulation";
    DataPlotType = "Static";
elseif strcmp(DataPlotType,"MainWindowTimeManipulationMovie")
    MainPlot = 1;
    DataPlotType = "Movie";
    OldDataPlotName = "MainWindowTimeManipulationMovie";
elseif strcmp(DataPlotType,"Preprocessing") || strcmp(DataPlotType,"SpikeExtraction") || strcmp(DataPlotType,"Events")
    ExtraAnalysisWindowsType = DataPlotType;
    MainPlot = 1;
    OldDataPlotName = "Static";
    DataPlotType = "Static";
else
    OldDataPlotName = DataPlotType;
end

if MainPlot
    
    frameTime = str2double(app.TimeRangeViewBox.Value(1:end-1))/app.MovieFramesPerSecond;

    if strcmp(app.DropDown.Value,'Preprocessed Data') 
        % If downsampled data to show: Input argument 11 in plot fct = 1 (1 if donwsampled, 0 if not)
        if isfield(app.Data.Info,'DownsampleFactor') 
            app.LastPlot = "Preprocessed";  
            SpikeDataType = app.Data.Info.SpikeType;
            Module_MainWindow_Plot_Data(app.Data.Preprocessed(app.Channelrange,StartIndex:StopIndex),app.Data.Info,app.UIAxes,app.Data.TimeDownsampled(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,1,EventPlot,EventData,app.Data.Info.DownsampledSampleRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ProbeInfo.FakeSpacing,app.PlotAppearance,app.SpikePlotType,app.Channelrange,frameTime)
        % If Raw data has to be plotted
        else
            app.LastPlot = "Preprocessed";
            SpikeDataType = app.Data.Info.SpikeType;
            Module_MainWindow_Plot_Data(app.Data.Preprocessed(app.Channelrange,StartIndex:StopIndex),app.Data.Info,app.UIAxes,app.Data.Time(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,1,EventPlot,EventData,app.Data.Info.NativeSamplingRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ProbeInfo.FakeSpacing,app.PlotAppearance,app.SpikePlotType,app.Channelrange,frameTime)
        end
    elseif strcmp(app.DropDown.Value,'Raw Data')
        app.LastPlot = "Raw";
        SpikeDataType = app.Data.Info.SpikeType;
        Module_MainWindow_Plot_Data(app.Data.Raw(app.Channelrange,StartIndex:StopIndex),app.Data.Info,app.UIAxes,app.Data.Time(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,0,EventPlot,EventData,app.Data.Info.NativeSamplingRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ProbeInfo.FakeSpacing,app.PlotAppearance,app.SpikePlotType,app.Channelrange,frameTime)
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
    
    Utility_Initialize_Clicks_Plots(app,OldDataPlotName);
   
end

%% Plot Spike Rate if Window for that is open
% app.PSTHApp: if spike rate window open, the variable Existflag will be
SpikeRatePlot = 1;

if ~isempty(app.ProbeViewWindowHandle) % Add option to probe view when available
    if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        if ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"Main Plot Spike Rate") && ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"All Windows Opened")
            SpikeRatePlot = 0;
        end
    end
end

% when user manipulates time in main window always execute
if strcmp(OldDataPlotName,"MainWindowTimeManipulation")
    SpikeRatePlot = 1;
elseif strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
    SpikeRatePlot = 1;
elseif strcmp(ExtraAnalysisWindowsType,"Preprocessing") || strcmp(ExtraAnalysisWindowsType,"SpikeExtraction") || strcmp(ExtraAnalysisWindowsType,"Events")
    SpikeRatePlot = 1;
end

if isprop(app.PSTHApp,'Existflag')
    if app.PSTHApp.Startup == 1 || SpikeRatePlot

        DownsampleSPikeRate = app.PSTHApp.DownsampleCheckBox.Value;
        FilterOrder = app.PSTHApp.FilterOrder;
        CutoffFreque = app.PSTHApp.CutoffFreque;
    
        if strcmp(app.DropDown.Value,"Preprocessed Data")
            PreprocessedPlot = 1;
        else
            PreprocessedPlot = 0;
        end

        %[StartIndex,StopIndex,DatatoPlot,Time,Samplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.CSDApp.DataTypeDropDown.Value,StartIndex,StopIndex);
            
        % Also contains the bar plot!
        if strcmp(app.DropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')
            [app.CurrentPlotData] = Analyse_Main_Window_Spike_Rate (app.Data,app.CurrentTimePoints,app.TimeRangeViewBox.Value,app.PSTHApp.Slider.Value,app.PSTHApp.UIAxes,app.Data.TimeDownsampled(StartIndex:StopIndex),app.PSTHApp.LockYLimCheckBox.Value,app.Data.Info.DownsampledSampleRate,app.Channelrange,StartIndex,StopIndex,PreprocessedPlot,DownsampleSPikeRate,CutoffFreque,FilterOrder,app.CurrentPlotData,app.PlotAppearance);
        else
            [app.CurrentPlotData] = Analyse_Main_Window_Spike_Rate (app.Data,app.CurrentTimePoints,app.TimeRangeViewBox.Value,app.PSTHApp.Slider.Value,app.PSTHApp.UIAxes,app.Data.Time(StartIndex:StopIndex),app.PSTHApp.LockYLimCheckBox.Value,app.Data.Info.NativeSamplingRate,app.Channelrange,StartIndex,StopIndex,PreprocessedPlot,DownsampleSPikeRate,CutoffFreque,FilterOrder,app.CurrentPlotData,app.PlotAppearance);
        end
    end
end

%% Plot CSD if Window for that is open
% app.CSDApp: if csd window open, the variable ExistflagCSD will be
% property of that app (defined in startup fct of CSD window)

CSDPlot = 1;

if ~isempty(app.ProbeViewWindowHandle) % Add option to probe view when available
    if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        if ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"Main Plot Current Source Density") && ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"All Windows Opened")
            CSDPlot = 0;
        end
    end
end

% when user manipulates time in main window always execute
if strcmp(OldDataPlotName,"MainWindowTimeManipulation")
    CSDPlot = 1;
elseif strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
    CSDPlot = 1;
elseif strcmp(ExtraAnalysisWindowsType,"Preprocessing") || strcmp(ExtraAnalysisWindowsType,"SpikeExtraction") || strcmp(ExtraAnalysisWindowsType,"Events")
    CSDPlot = 1;
end

if isprop(app.CSDApp,'ExistflagCSD')
    if app.CSDApp.Startup == 1 || CSDPlot
    
        hamwidth = str2double(app.CSDApp.HammWindowEditField.Value);
        ChannelSpacing = app.Data.Info.ProbeInfo.FakeSpacing;

        [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.CSDApp.DataTypeDropDown.Value,StartIndex,StopIndex,"CSD");
        
        [app.CSDApp.CSDClim,app.CurrentPlotData] = Analyse_Main_Window_CSD(TempDatatoPlot,TempTime,hamwidth,ChannelSpacing,app.CSDApp.CSDClim,app.CSDApp.UIAxes,app.CSDApp.LockCLimCheckBox.Value,app.CSDApp.TwoORThreeD,app.CurrentPlotData,app.PlotAppearance,app.Data,EventData,TempSamplefrequency,app.CurrentEventChannel,EventPlot,app.CSDApp.DataTypeDropDown.Value,app.ActiveChannel);
        
        % Custom YLabels
        Utility_Set_YAxis_Depth_Labels(app.Data,app.CSDApp.UIAxes,[],app.ActiveChannel,0)

        clear TempDatatoPlot TempTime TempSamplefrequency
    end
end

%% Plot Spectral Power Density estimate window is open

PowerEstiamtePlot = 1;

if ~isempty(app.ProbeViewWindowHandle) % Add option to probe view when available
    if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        if ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"Main Plot Power Estimate") && ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"All Windows Opened")
            PowerEstiamtePlot = 0;
        end
    end
end

% when user manipulates time in main window always execute
if strcmp(OldDataPlotName,"MainWindowTimeManipulation")
    PowerEstiamtePlot = 1;
elseif strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
    PowerEstiamtePlot = 1;
elseif strcmp(ExtraAnalysisWindowsType,"Preprocessing") || strcmp(ExtraAnalysisWindowsType,"SpikeExtraction") || strcmp(ExtraAnalysisWindowsType,"Events")
    PowerEstiamtePlot = 1;
end

if isprop(app.SpectralEstApp,'ExistflagSDE')
    if app.SpectralEstApp.Startup == 1 || PowerEstiamtePlot
        %% Extract Channel Number and set colormap
            
        [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.SpectralEstApp.DataTypeDropDown.Value,StartIndex,StopIndex,"PowerSpect");
        
        [app.SpectralEstApp.PDLim,app.CurrentPlotData] = Analyse_Main_Window_Spectral_Density_Estimate(TempDatatoPlot,TempSamplefrequency,app.SpectralEstApp.UIAxes,TempTime,app.SpectralEstApp.PDLim,app.SpectralEstApp.LockYLimCheckBox.Value,app.CurrentPlotData,app.PlotAppearance);
        
        clear TempDatatoPlot TempTime TempSamplefrequency
    end
end

%% Plot Inst. Frequency Live Window
% when user manipulates time in main window always execute

ECHTPlot = 1;

if ~isempty(app.ProbeViewWindowHandle) % Add option to probe view when available
    if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        if ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"Main Plot Phase Synchronization") && ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"All Windows Opened")
            ECHTPlot = 0;
        end
    end
end

% when user manipulates time in main window always execute
if strcmp(OldDataPlotName,"MainWindowTimeManipulation")
    ECHTPlot = 1;
elseif strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
    ECHTPlot = 1;
elseif strcmp(ExtraAnalysisWindowsType,"Preprocessing") || strcmp(ExtraAnalysisWindowsType,"SpikeExtraction") || strcmp(ExtraAnalysisWindowsType,"Events")
    ECHTPlot = 1;
end

if isprop(app.LiveECHTWindow,'ExistflagECHT')
    if app.LiveECHTWindow.Startup == 1 || ECHTPlot
        
        [TempStartIndex,TempStopIndex,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.LiveECHTWindow.DataTypeDropDown.Value,StartIndex,StopIndex,"PhaseSync");
        
        [app.LiveECHTWindow.GlobalYlim,texttoshow,app.CurrentPlotData] = Analyse_Main_Window_Inst_Freq_Main(TempDatatoPlot,TempTime,TempSamplefrequency,app.LiveECHTWindow.PolarPlot,app.LiveECHTWindow.UIAxes_3,app.LiveECHTWindow.UIAxes,app.LiveECHTWindow.UIAxes_2,app.Data,app.LiveECHTWindow.ChannelToCompare,app.LiveECHTWindow.NarrowbandCutoffLowerHigherEditField.Value,app.LiveECHTWindow.NarrowbandFilterorderEditField.Value,app.ActiveChannel,app.LiveECHTWindow.DataTypeDropDown.Value,app.PlotAppearance,app.LiveECHTWindow.GlobalYlim,app.LiveECHTWindow.LockYlimCheckBox.Value,TempStartIndex,TempStopIndex,app.LiveECHTWindow.WhatToDo,app.LiveECHTWindow.Ccolormap,app.LiveECHTWindow.CalculationMethodDropDown.Value,app.LiveECHTWindow.ForceFilterOFFCheckBox.Value,app.LiveECHTWindow.ECHTFilterorderEditField.Value,app.CurrentPlotData,EventData,app.CurrentEventChannel,EventPlot,app.LiveECHTWindow.ShowAnayzedData,app.LiveECHTWindow.LowPassSettings,app.LiveECHTWindow.FilterType);      
        app.LiveECHTWindow.TextArea.Value = texttoshow;

        clear TempDatatoPlot TempTime TempSamplefrequency
    end
end
