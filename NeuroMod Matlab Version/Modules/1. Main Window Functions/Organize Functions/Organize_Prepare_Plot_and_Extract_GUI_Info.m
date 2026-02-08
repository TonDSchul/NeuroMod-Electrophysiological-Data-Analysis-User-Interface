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

PreserveChannelSpacing = app.PreservePlotChannelLocations;
if strcmp(app.Data.Info.RecordingType,"SpikeGLX NP") || app.Data.Info.ProbeInfo.OffSetRows
    if PreserveChannelSpacing == 1
        PreserveChannelSpacing = 0;
    end
end

% If events addon selected in main window (events added to plot) select
% which input event channel to show
% EventPlot = "no" when checkbox disabled, "Events" when checkbox activated

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
% ensure proper length according to time range
StopIndex = StopIndex - 1;

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
    
        if numel(UinquePos)>=2 ||  strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"DataLinesGrid")
            SpikeData.Position = app.Data.Spikes.SpikeChannel(SpikeDataIndex); 
        else
            SpikeData.Position = app.Data.Spikes.SpikePositions(SpikeDataIndex,2);
        end
        
        % if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        %     [~,~,~,FakeDepths] = Spike_Module_Analysis_Determine_Depths(app.Data,PreserveChannelSpacing,app.Data.Info.ProbeInfo.ActiveChannel);
        % 
        %     SpikeData.Position = FakeDepths(SpikeData.Position);
        % end
    else
       SpikeData.Position = app.Data.Spikes.SpikePositions(SpikeDataIndex,2); 

       % if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
       %     [~,~,~,FakeDepths] = Spike_Module_Analysis_Determine_Depths(app.Data,0,app.ActiveChannel);
       % 
       %     SpikeData.Position = FakeDepths(SpikeData.Position);
       % end
    end
end

%% Determine whether main plot should be updated or jsut live windows (when just live analysis window specific parameter was changed)
JustLiveWindow = 0;
if ~isempty(app.CSDApp)
    if isprop(app.CSDApp,'ExistflagCSD')
        if app.CSDApp.ChangeMainPlot == 0
            JustLiveWindow = 1;
        end
    end
end
if ~isempty(app.LiveECHTWindow)
    if isprop(app.LiveECHTWindow,'ExistflagECHT')
        if app.LiveECHTWindow.ChangeMainPlot == 0
            JustLiveWindow = 1;
        end
    end
end
if ~isempty(app.SpectralEstApp)
    if isprop(app.SpectralEstApp,'ExistflagSDE')
        if app.SpectralEstApp.ChangeMainPlot == 0
            JustLiveWindow = 1;
        end
    end
end
if ~isempty(app.LiveSpectrogramApp)
    if isprop(app.LiveSpectrogramApp,'ExistflagLiveSpectogram')
        if app.LiveSpectrogramApp.ChangeMainPlot == 0
            JustLiveWindow = 1;
        end
    end
end
if ~isempty(app.PSTHApp)
    if isprop(app.PSTHApp,'Existflag')
        if app.PSTHApp.ChangeMainPlot == 0
            JustLiveWindow = 1;
        end
    end
end
%% Plot Data
% Those functions dont take the app object and are therefore plug and play
% for other figure objects 
% If Preprocessed data shown (Input argument 8 in plot fct. = 1 (1 if preprocessed, 0 if not))

if MainPlot && JustLiveWindow == 0
    if ~strcmp(DataPlotType,"Movie")
        app.PlayedMovieBefore = 0;
    else
        app.PlayedMovieBefore = 1;
    end
    
    if isempty(app.PreviousThreshGrids)
        app.PreviousThreshGrids.T1 = [];
        app.PreviousThreshGrids.T2 = [];
    else
        if ~isfield(app.PreviousThreshGrids,'T1')
            app.PreviousThreshGrids.T1 = [];
            app.PreviousThreshGrids.T2 = [];
        end
    end

    if strcmp(app.DropDown.Value,'Preprocessed Data') 
        PlotData = app.Data.Preprocessed(app.Channelrange,StartIndex:StopIndex);
    elseif strcmp(app.DropDown.Value,'Raw Data')
        PlotData = app.Data.Raw(app.Channelrange,StartIndex:StopIndex);
    end

    if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Surf") && strcmp(DataPlotType,"Movie") || strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Mesh") && strcmp(DataPlotType,"Movie") || strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"AxonViewer") && strcmp(DataPlotType,"Movie")
        if strcmp(app.DropDown.Value,'Preprocessed Data') 
            if isfield(app.Data,'TimeDownsampeld')
                if StopIndex+app.MovieTimeToJump>length(app.Data.TimeDownsampled)
                    StopIndex = length(app.Data.TimeDownsampled);
                end
            end
            PlotDataT2 = app.Data.Preprocessed(app.Channelrange,StartIndex+app.MovieTimeToJump:StopIndex+app.MovieTimeToJump);
        elseif strcmp(app.DropDown.Value,'Raw Data')
            if StopIndex+app.MovieTimeToJump>length(app.Data.Time)
                StopIndex = length(app.Data.Time);
            end
            PlotDataT2 = app.Data.Raw(app.Channelrange,StartIndex+app.MovieTimeToJump:StopIndex+app.MovieTimeToJump);
        end
    else
        PlotDataT2 = []; % for movie mode only to habe next time point to interpolate to
    end
    
    DataLinesGrid = 0;

    if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"DataLinesGrid")
        DataLinesGrid = 1;
    end    
   
    frameTime = str2double(app.TimeRangeViewBox.Value(1:end-1))/app.MovieFramesPerSecond;
    
    if DataLinesGrid == 0 % if no individual subplot data lines in a grid
        if strcmp(app.DropDown.Value,'Preprocessed Data') 
            % If downsampled data to show: Input argument 11 in plot fct = 1 (1 if donwsampled, 0 if not)
            if isfield(app.Data.Info,'DownsampleFactor') 
                app.LastPlot = "Preprocessed";  
                SpikeDataType = app.Data.Info.SpikeType;
                
                [app.ClimMaxValues,app.PreviousThreshGrids,app.PlotThreshGrids] = Module_MainWindow_Plot_Data(PlotData,app.Data.Info,app.UIAxes,app.Data.TimeDownsampled(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,1,EventPlot,EventData,app.Data.Info.DownsampledSampleRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ProbeInfo.FakeSpacing,app.PlotAppearance,app.SpikePlotType,app.Channelrange,frameTime,app.ClimMaxValues,app.PreviousThreshGrids,PlotDataT2,app.PlotThreshGrids);
            % If Raw data has to be plotted
            else
                app.LastPlot = "Preprocessed";
                SpikeDataType = app.Data.Info.SpikeType;
                [app.ClimMaxValues,app.PreviousThreshGrids,app.PlotThreshGrids] = Module_MainWindow_Plot_Data(PlotData,app.Data.Info,app.UIAxes,app.Data.Time(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,1,EventPlot,EventData,app.Data.Info.NativeSamplingRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ProbeInfo.FakeSpacing,app.PlotAppearance,app.SpikePlotType,app.Channelrange,frameTime,app.ClimMaxValues,app.PreviousThreshGrids,PlotDataT2,app.PlotThreshGrids);
            end
        elseif strcmp(app.DropDown.Value,'Raw Data')
            app.LastPlot = "Raw";
            SpikeDataType = app.Data.Info.SpikeType;
            [app.ClimMaxValues,app.PreviousThreshGrids,app.PlotThreshGrids] = Module_MainWindow_Plot_Data(PlotData,app.Data.Info,app.UIAxes,app.Data.Time(StartIndex:StopIndex),app.Channelrange,app.PlotLineSpacing,DataPlotType,colorMap,0,EventPlot,EventData,app.Data.Info.NativeSamplingRate,Plotspikes,SpikeData,StartIndex,StopIndex,SpikeDataType,app.Data.Info.ProbeInfo.FakeSpacing,app.PlotAppearance,app.SpikePlotType,app.Channelrange,frameTime,app.ClimMaxValues,app.PreviousThreshGrids,PlotDataT2,app.PlotThreshGrids);
        end
    else % if individual subplot data lines in a grid
        % initialize panel 
        if isempty(app.ChannelAxes)
            app = Module_MainWindow_Initialize_Grid_Trace_Panel(app);
        end

        if ~isempty(app.ChannelAxes)
            if strcmp(app.DropDown.Value,'Preprocessed Data') 
                app.UIAxes.Title.String = 'Preprocessed Data';
                if isfield(app.Data.Info,'DownsampleFactor') 
                    app.LastPlot = "Preprocessed";
                    
                    Module_Main_Window_Plot_Grid_Trace_View(app,app.Data,PlotData,app.Data.TimeDownsampled(StartIndex:StopIndex),StartIndex,app.PlotAppearance,app.ActiveChannel,PreserveChannelSpacing,SpikeData,[],1)
                else
                    app.LastPlot = "Preprocessed";
                    Module_Main_Window_Plot_Grid_Trace_View(app,app.Data,PlotData,app.Data.Time(StartIndex:StopIndex),StartIndex,app.PlotAppearance,app.ActiveChannel,PreserveChannelSpacing,SpikeData,[],1)
                end
            elseif strcmp(app.DropDown.Value,'Raw Data')
                app.UIAxes.Title.String = 'Raw Data';
                app.LastPlot = "Raw";
                Module_Main_Window_Plot_Grid_Trace_View(app,app.Data,PlotData,app.Data.Time(StartIndex:StopIndex),StartIndex,app.PlotAppearance,app.ActiveChannel,PreserveChannelSpacing,SpikeData,[],1)
            end
        end
        
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
if isprop(app.PSTHApp,'Existflag')
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
    
    Proceed = 1;
    if app.PSTHApp.CoupleTimetoMainWindowCheckBox.Value == 0 && JustLiveWindow == 0
        Proceed = 0;
    end

    if app.PSTHApp.Startup == 1 && Proceed == 1 || SpikeRatePlot && Proceed == 1

        DownsampleSPikeRate = app.PSTHApp.DownsampleCheckBox.Value;
        FilterOrder = app.PSTHApp.FilterOrder;
        CutoffFreque = app.PSTHApp.CutoffFreque;
    
        if strcmp(app.DropDown.Value,"Preprocessed Data")
            PreprocessedPlot = 1;
        else
            PreprocessedPlot = 0;
        end

        if app.PSTHApp.CoupleTimetoMainWindowCheckBox.Value == 1
            if strcmp(app.DropDown.Value,"Preprocessed Data") && isfield(app.Data.Info,'DownsampledSampleRate')
                TimeinSecs = app.Data.TimeDownsampled(app.CurrentTimePoints);
                % Calculate the absolute differences
                differences = abs(app.Data.Time - TimeinSecs);

                % Find the index of the minimum difference
                [~, TempCurrentTimePoints] = min(differences);

                TimeDuration = str2double(app.TimeRangeViewBox.Value(1:end-1));
                TempStartIndex = TempCurrentTimePoints;
                TempStopIndex = TempStartIndex+ceil(TimeDuration*app.Data.Info.NativeSamplingRate);
                if TempStopIndex > size(app.Data.Raw,2)
                    TempStopIndex = size(app.Data.Raw,2);
                end
            else
                TempStartIndex = StartIndex;
                TempStopIndex = StopIndex;
            end
            % TempStartIndex = StartIndex;
            % TempStopIndex = StopIndex;
            [~,~,~,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.DropDown.Value,TempStartIndex,TempStopIndex,"SpikeRate",app.PSTHApp.CoupleTimetoMainWindowCheckBox.Value);
            [app.CurrentPlotData] = Analyse_Main_Window_Spike_Rate(app.Data,app.PSTHApp.Slider.Value,app.PSTHApp.UIAxes,TempTime,app.PSTHApp.LockYLimCheckBox.Value,TempSamplefrequency,app.Channelrange,TempStartIndex,TempStopIndex,0,DownsampleSPikeRate,CutoffFreque,FilterOrder,app.CurrentPlotData,app.PlotAppearance,TempStartIndex,TempStopIndex);
        else
            TimeWindow = str2double(strsplit(app.PSTHApp.TimeWindowfromtoinsEditField.Value,','));
            if strcmp(app.DropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')
                [~,TempStartIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(1)));
                [~,TempStopIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(2)));

                [~,~,~,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.DropDown.Value,TempStartIndex,TempStopIndex,"SpikeRate",app.PSTHApp.CoupleTimetoMainWindowCheckBox.Value);
            else
                [~,TempStartIndex] = min(abs(app.Data.Time - TimeWindow(1)));
                [~,TempStopIndex] = min(abs(app.Data.Time - TimeWindow(2)));
                [~,~,~,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.DropDown.Value,TempStartIndex,TempStopIndex,"SpikeRate",app.PSTHApp.CoupleTimetoMainWindowCheckBox.Value);
            end


            % TimeWindow = str2double(strsplit(app.PSTHApp.TimeWindowfromtoinsEditField.Value,','));
            % [~,TempStartIndex] = min(abs(app.Data.Time - TimeWindow(1)));
            % [~,TempStopIndex] = min(abs(app.Data.Time - TimeWindow(2)));
            % [~,~,~,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.DropDown.Value,TempStartIndex,TempStopIndex,"SpikeRate",app.PSTHApp.CoupleTimetoMainWindowCheckBox.Value);
            [app.CurrentPlotData] = Analyse_Main_Window_Spike_Rate(app.Data,app.PSTHApp.Slider.Value,app.PSTHApp.UIAxes,TempTime,app.PSTHApp.LockYLimCheckBox.Value,TempSamplefrequency,app.Channelrange,StartIndex,StopIndex,PreprocessedPlot,DownsampleSPikeRate,CutoffFreque,FilterOrder,app.CurrentPlotData,app.PlotAppearance,TempStartIndex,TempStopIndex);
        end  
    end
end

%% Plot CSD if Window for that is open
% app.CSDApp: if csd window open, the variable ExistflagCSD will be
% property of that app (defined in startup fct of CSD window)
if isprop(app.CSDApp,'ExistflagCSD')
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
    
    Proceed = 1;
    if app.CSDApp.CoupleTimetoMainWindowCheckBox.Value == 0 && JustLiveWindow == 0
        Proceed = 0;
    end

    if app.CSDApp.Startup == 1 && Proceed == 1 || CSDPlot && Proceed == 1
        
        hamwidth = str2double(app.CSDApp.HammWindowEditField.Value);
        ChannelSpacing = app.Data.Info.ProbeInfo.FakeSpacing;

        if app.CSDApp.CoupleTimetoMainWindowCheckBox.Value == 1
            [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.CSDApp.DataTypeDropDown.Value,StartIndex,StopIndex,"CSD",app.CSDApp.CoupleTimetoMainWindowCheckBox.Value);
        else
            TimeWindow = str2double(strsplit(app.CSDApp.TimeWindowfromtoinsEditField.Value,','));
            if strcmp(app.CSDApp.DataTypeDropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')
                [~,TempStartIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(1)));
                [~,TempStopIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(2)));

                [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.CSDApp.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"CSD",app.CSDApp.CoupleTimetoMainWindowCheckBox.Value);
            else
                [~,TempStartIndex] = min(abs(app.Data.Time - TimeWindow(1)));
                [~,TempStopIndex] = min(abs(app.Data.Time - TimeWindow(2)));
                [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.CSDApp.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"CSD",app.CSDApp.CoupleTimetoMainWindowCheckBox.Value);
            end
        end
        
        [app.CSDApp.CSDClim,app.CurrentPlotData] = Analyse_Main_Window_CSD(TempDatatoPlot,TempTime,hamwidth,ChannelSpacing,app.CSDApp.CSDClim,app.CSDApp.UIAxes,app.CSDApp.LockCLimCheckBox.Value,app.CSDApp.TwoORThreeD,app.CurrentPlotData,app.PlotAppearance,app.Data,EventData,TempSamplefrequency,app.CurrentEventChannel,EventPlot,app.CSDApp.DataTypeDropDown.Value,app.ActiveChannel);
        
        % Custom YLabels
        Utility_Set_YAxis_Depth_Labels(app.Data,app.CSDApp.UIAxes,[],app.ActiveChannel,0)

        clear TempDatatoPlot TempTime TempSamplefrequency
    end
end

%% Plot Spectral Power Density estimate window is open

if isprop(app.SpectralEstApp,'ExistflagSDE')
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
    
    Proceed = 1;
    if app.SpectralEstApp.CoupleTimetoMainWindowCheckBox.Value == 0 && JustLiveWindow == 0
        Proceed = 0;
    end

    if isprop(app.SpectralEstApp,'ExistflagSDE')
        if app.SpectralEstApp.Startup == 1 && Proceed == 1 || PowerEstiamtePlot && Proceed == 1
            %% Extract Channel Number and set colormap
            if app.SpectralEstApp.CoupleTimetoMainWindowCheckBox.Value == 1
                [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.SpectralEstApp.DataTypeDropDown.Value,StartIndex,StopIndex,"PowerSpect",app.SpectralEstApp.CoupleTimetoMainWindowCheckBox.Value);
            else
                TimeWindow = str2double(strsplit(app.SpectralEstApp.TimeWindowfromtoinsEditField.Value,','));
                if strcmp(app.DropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')
                    [~,TempStartIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(1)));
                    [~,TempStopIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(2)));
    
                    [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.SpectralEstApp.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"PowerSpect",app.SpectralEstApp.CoupleTimetoMainWindowCheckBox.Value);
                else
                    [~,TempStartIndex] = min(abs(app.Data.Time - TimeWindow(1)));
                    [~,TempStopIndex] = min(abs(app.Data.Time - TimeWindow(2)));
                    [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.SpectralEstApp.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"PowerSpect",app.SpectralEstApp.CoupleTimetoMainWindowCheckBox.Value);
                end
            end

            [app.SpectralEstApp.PDLim,app.CurrentPlotData] = Analyse_Main_Window_Spectral_Density_Estimate(TempDatatoPlot,TempSamplefrequency,app.SpectralEstApp.UIAxes,TempTime,app.SpectralEstApp.PDLim,app.SpectralEstApp.LockYLimCheckBox.Value,app.CurrentPlotData,app.PlotAppearance);
            
            clear TempDatatoPlot TempTime TempSamplefrequency
        end
    end
end

%% Plot Inst. Frequency Live Window
% when user manipulates time in main window always execute
if isprop(app.LiveECHTWindow,'ExistflagECHT')
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
    
    Proceed = 1;
    if app.LiveECHTWindow.CoupleTimetoMainWindowCheckBox.Value == 0 && JustLiveWindow == 0
        Proceed = 0;
    end
    
    if isprop(app.LiveECHTWindow,'ExistflagECHT')
        if app.LiveECHTWindow.Startup == 1 && Proceed == 1 || ECHTPlot && Proceed == 1
            
            if app.LiveECHTWindow.CoupleTimetoMainWindowCheckBox.Value == 1
                [TempStartIndex,TempStopIndex,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.LiveECHTWindow.DataTypeDropDown.Value,StartIndex,StopIndex,"PhaseSync",app.LiveECHTWindow.CoupleTimetoMainWindowCheckBox.Value);
            else
                TimeWindow = str2double(strsplit(app.LiveECHTWindow.TimeWindowfromtoinsEditField.Value,','));
                if strcmp(app.LiveECHTWindow.DataTypeDropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')
                    [~,TempStartIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(1)));
                    [~,TempStopIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(2)));
    
                    [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.LiveECHTWindow.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"PhaseSync",app.LiveECHTWindow.CoupleTimetoMainWindowCheckBox.Value);
                else
                    [~,TempStartIndex] = min(abs(app.Data.Time - TimeWindow(1)));
                    [~,TempStopIndex] = min(abs(app.Data.Time - TimeWindow(2)));
                    [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.LiveECHTWindow.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"PhaseSync",app.LiveECHTWindow.CoupleTimetoMainWindowCheckBox.Value);
                end
            end
            [app.LiveECHTWindow.GlobalYlim,texttoshow,app.CurrentPlotData] = Analyse_Main_Window_Inst_Freq_Main(TempDatatoPlot,TempTime,TempSamplefrequency,app.LiveECHTWindow.PolarPlot,app.LiveECHTWindow.UIAxes_3,app.LiveECHTWindow.UIAxes,app.LiveECHTWindow.UIAxes_2,app.Data,app.LiveECHTWindow.ChannelToCompare,app.LiveECHTWindow.NarrowbandCutoffLowerHigherEditField.Value,app.LiveECHTWindow.NarrowbandFilterorderEditField.Value,app.ActiveChannel,app.LiveECHTWindow.DataTypeDropDown.Value,app.PlotAppearance,app.LiveECHTWindow.GlobalYlim,app.LiveECHTWindow.LockYlimCheckBox.Value,TempStartIndex,TempStopIndex,app.LiveECHTWindow.WhatToDo,app.LiveECHTWindow.Ccolormap,app.LiveECHTWindow.CalculationMethodDropDown.Value,app.LiveECHTWindow.ForceFilterOFFCheckBox.Value,app.LiveECHTWindow.ECHTFilterorderEditField.Value,app.CurrentPlotData,EventData,app.CurrentEventChannel,EventPlot,app.LiveECHTWindow.ShowAnayzedData,app.LiveECHTWindow.LowPassSettings,app.LiveECHTWindow.FilterType);      
            app.LiveECHTWindow.TextArea.Value = texttoshow;
    
            clear TempDatatoPlot TempTime TempSamplefrequency
        end
    end
end

%% Plot Live Spectrogram Window
% when user manipulates time in main window always execute
if isprop(app.LiveSpectrogramApp,'ExistflagLiveSpectogram')
    LiveSpectrogramPlot = 1;
    
    if ~isempty(app.ProbeViewWindowHandle) % Add option to probe view when available
        if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
            if ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"Main Plot Spectrogram") && ~strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Value,"All Windows Opened")
                LiveSpectrogramPlot = 0;
            end
        end
    end
    
    % when user manipulates time in main window always execute
    if strcmp(OldDataPlotName,"MainWindowTimeManipulation")
        LiveSpectrogramPlot = 1;
    elseif strcmp(OldDataPlotName,"MainWindowTimeManipulationMovie")
        LiveSpectrogramPlot = 1;
    elseif strcmp(ExtraAnalysisWindowsType,"Preprocessing") || strcmp(ExtraAnalysisWindowsType,"SpikeExtraction") || strcmp(ExtraAnalysisWindowsType,"Events")
        LiveSpectrogramPlot = 1;
    end
    
    Proceed = 1;
    if app.LiveSpectrogramApp.CoupleTimetoMainWindowCheckBox.Value == 0 && JustLiveWindow == 0
        Proceed = 0;
    end
    
    if isprop(app.LiveSpectrogramApp,'ExistflagLiveSpectogram')
        if app.LiveSpectrogramApp.Startup == 1 && Proceed == 1 || LiveSpectrogramPlot && Proceed == 1
            
            if app.LiveSpectrogramApp.CoupleTimetoMainWindowCheckBox.Value == 1
                [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.LiveSpectrogramApp.DataTypeDropDown.Value,StartIndex,StopIndex,"Spectrogram",app.LiveSpectrogramApp.CoupleTimetoMainWindowCheckBox.Value);
            else
                TimeWindow = str2double(strsplit(app.LiveSpectrogramApp.TimeWindowfromtoinsEditField.Value,','));
                if strcmp(app.LiveSpectrogramApp.DataTypeDropDown.Value,'Preprocessed Data') && isfield(app.Data.Info,'DownsampleFactor')
                    [~,TempStartIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(1)));
                    [~,TempStopIndex] = min(abs(app.Data.TimeDownsampled - TimeWindow(2)));
    
                    [~,~,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.LiveSpectrogramApp.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"Spectrogram",app.LiveSpectrogramApp.CoupleTimetoMainWindowCheckBox.Value);
                else
                    [~,TempStartIndex] = min(abs(app.Data.Time - TimeWindow(1)));
                    [~,TempStopIndex] = min(abs(app.Data.Time - TimeWindow(2)));
                    [a,b,TempDatatoPlot,TempTime,TempSamplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,app.LiveSpectrogramApp.DataTypeDropDown.Value,TempStartIndex,TempStopIndex,"Spectrogram",app.LiveSpectrogramApp.CoupleTimetoMainWindowCheckBox.Value);
                end
            end

            [app.LiveSpectrogramApp.CurrentClim,app.CurrentPlotData] = Analyse_Main_Window_Live_Spectrogram2(app.Data,TempDatatoPlot,EventData,app.LiveSpectrogramApp.ChannelToPlotDropDown.Value,app.LiveSpectrogramApp.WindowsEditField.Value,app.LiveSpectrogramApp.FrequencyRangeMinMaxEditField.Value,app.LiveSpectrogramApp.LockCLimCheckBox.Value,app.LiveSpectrogramApp.DataTypeDropDown.Value,app.LiveSpectrogramApp.CurrentClim,app.LiveSpectrogramApp.UIAxes,TempSamplefrequency,app.PlotAppearance,TempTime,app.CurrentEventChannel,EventPlot,app.CurrentPlotData,app.LiveSpectrogramApp.TwoORThreeD);
            
            clear TempDatatoPlot TempTime TempSamplefrequency
        end
    end
end