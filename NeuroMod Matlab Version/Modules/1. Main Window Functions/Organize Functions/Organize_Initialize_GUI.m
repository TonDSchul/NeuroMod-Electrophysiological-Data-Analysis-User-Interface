function [app] = Organize_Initialize_GUI (app,Type,Data,HeaderInfo,SampleRate,SelectedFolder,RecordingType,PreviousChannelDeletetion,Time,Load_Data_Window_Info)
%________________________________________________________________________________________

%% Function to Organize all basic mainapp values, properties, app parts and variables. 
% This function is called all over the toolbox to initiate and organize app
% windows and datasets

% This is used, to initiate variables when the GUI is started, when data is
% extracted (delete old data and autoset some values to match the new dataset), data is loaded (delete old data and autoset some values to match the new dataset)
% or preprocessed 

% NOTE: this only works with the main window app object as first input
% NOTE: Type "VariableDefinition" as input defines all necessary Data.Info
% fiels
% Inputs:
% 1. app: app object of GUI main window
% 2. Type: string, specifies why/at which point this function is called. % Options: "Initial" when GUI is started or reset, "Loading" when a new
% dataset is loaded (previosuly saved with GUI), "Extracting" when dataset
% was extracted from raw data, "Preprocessing" after preprocessing steps
% were applied or "VariableDefinition" during the data extractionf from raw
% data to centralize the fundamental infos of the Data.Info field 
% 3. Data: Data structure of the main window
% 4. HeaderInfo: Infos about recording extracted from raw datasets. Gets
% fused with Data.Info when Type = "VariableDefinition"
% 5. SampleRate in Hz as double when Type = "VariableDefinition"
% 6. SelectedFolder: Folder from which data was exracted or loaded from, as char
% only applicable when Type = "VariableDefinition"
% 7. RecordingType: string specifying the recording system when Type =
%"Extracting", Options: "IntanDat", "IntanRHD", "Spike2", "Open Ephys"
% 8. PreviousChannelDeletetion: not needed anymore!!
% 9. Time: double array with time point for each value of the raw dataset. Becomes app.Data.Time when Type = "VariableDefinition"
% 10. Load_Data_Window_Info: structure holding probe info like
% channelspacing or nrchannel

% Output:
% 1. app: object with initialized values

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if strcmp(Type,"Initial")
    
    warning('off', 'MATLAB:modes:mode:InvalidPropertySet'); % warning that buttondown on data plot doesnt work when the user selected an interactive option within the plot (like zoom or moving the plot)

    % Replace and empty all plots
    app.UIAxes.NextPlot = "replace"; 
    plot(app.UIAxes,0,0);
    app.UIAxes_2.NextPlot = "replace"; 
    plot(app.UIAxes_2,0,0);

    % Reset App Properties
    %app.ChannelSelectionEditField.Value = "";
    app.ChannelSelection = [];
    app.DefaultTimeRangeDataPlot = [];
    app.TimeLimit = [];
    app.CurrentTimePoints = [];
    app.CheckSuccesful_Extraction = [];
    app.CheckPlayMovie = [];
    app.FlagPlotDownsampledData = 0;
    app.FlagPlotRawData = 1;
    app.PlotEvents = "no";
    app.Plotspikes = "no";
    app.PlotLineSpacing = []; % Info from slider how much channel should be apart
    app.Channelrange = []; % Info from GUI which channel are selected
    app.tempcolorMapset = []; % Holding result Eval function integrating GUI selection. This is used for the plot functions!
    app.tempcolorMap = "parula";
    app.CurrentEventChannel = [];
    app.PSTHApp = [];
    app.CSDApp = [];
    app.SpectralEstApp = [];
    app.PowerSpecResults = [];

    app.PlotAppearance = Utility_Save_Load_Delete_Plot_Appearance(app.PlotAppearance,app.executableFolder,"Load");
   
    app.UIAxes.Color = app.PlotAppearance.MainWindow.Data.Color.MainBackground;
    app.UIAxes_2.Color = app.PlotAppearance.MainWindow.Data.Color.TimeBackground;
    app.UIAxes.FontSize = app.PlotAppearance.MainWindow.Data.MainFontSize;
    app.UIAxes_2.FontSize = app.PlotAppearance.MainWindow.Data.TimeFontSize;

    %% Reset Standard GUI Values

    app.TextArea.Value = "";
       
    % Disable 0.1 and 1s checkboxes to control time window and activate 0.5s
    % checkbox
    app.TimeSpanControlDropDown.Value = '0.1s';
    
    % Predefine Variable holding app.Data
    app.Data = [];
       
    % Predefine Time Ranges
    %app.DefaultTimeRangeDataPlot = 1000; % Default time range shown in app.Data plot in amount of samples (64x1000 points plot)
    app.TimeLimit = [0.0333,3]; % sets maximum and minimum amount of time shown in Main Window Plot
    TimeRangeText = strcat(num2str(0.5),"s");
    app.TimeRangeViewBox.Value = TimeRangeText;
    app.CurrentTimePoints = 1; % Standard TIme in seconds
    
    app.PlotComponents = "Raw"; % What is shown in the plot
   
    % Enable/Disable buttons
    app.RUNButton_4.Enable = "on";
    app.RUNButton_5.Enable = "off";
    app.RUNButton_3.Enable = "off";
    app.RUNButton_2.Enable = "off";
    app.RUNButton.Enable = "off";

    app.EventChannelDropDown.Enable = "off";
    app.EventChannelDropDown.Items = {};
    
    app.FlagPlotRawData = 1;
    
    % Plot Cheboxes
    Placeholder = {};
    app.DropDown.Items = Placeholder;
    app.DropDown.Items{1} = 'Raw Data';

    Placeholder = {};
    app.DropDown_2.Items = Placeholder;
    app.DropDown_2.Items{1} = 'Non';

    app.CurrentPlotData.XData = [];
    app.CurrentPlotData.YData = [];
    app.CurrentPlotData.CData = [];
    app.CurrentPlotData.Type = "Non";
    app.CurrentPlotData.XTicks = [];
    
    app.EventTriggerNumberField.Value = "";

elseif strcmp(Type,"Loading")

    %Organize_Delete_All_Open_Windows(app,1);

    app.ActiveChannel = app.Data.Info.ProbeInfo.ActiveChannel;

    % Enable/Disable buttons
    app.RUNButton_5.Enable = "on";
    app.RUNButton_2.Enable = "on";
    app.RUNButton_3.Enable = "on";
    app.RUNButton.Enable = "on";

    % Setting defalut app values after loading
    % Update Time window shown in the top right corner
    
    if isfield(app.Data,'Raw') && ~isfield(app.Data,'Preprocessed')
        Placeholder = {};
        app.DropDown.Items = Placeholder;
        app.DropDown.Items{1} = 'Raw Data';
    elseif isfield(app.Data,'Raw') && isfield(app.Data,'Preprocessed')
        Placeholder = {};
        app.DropDown.Items = Placeholder;
        app.DropDown.Items{1} = 'Raw Data';
        app.DropDown.Items{2} = 'Preprocessed Data';
    end

    if isfield(app.Data,'Events')
        Placeholder = {};
        app.DropDown_2.Items = Placeholder;
        app.DropDown_2.Items{1} = 'Non';
        app.DropDown_2.Items{2} = 'Events';

        app.EventChannelDropDown.Enable = "on";
        app.EventChannelDropDown.Items = app.Data.Info.EventChannelNames;
        app.CurrentEventChannel = 1; 
    else
        Placeholder = {};
        app.DropDown_2.Items = Placeholder;
        app.DropDown_2.Items{1} = 'Non';

        app.EventChannelDropDown.Enable = "off";
        app.EventChannelDropDown.Items = {};
    end
    if isfield(app.Data, 'Spikes') 
        app.DropDown_2.Items{end+1} = 'Spikes';
    end

    %% Event trial number text area in main windwo

    if isfield(app.Data,'Events')
        EventIndice = [];
        for i = 1:length(app.Data.Info.EventChannelNames)
            if strcmp(app.Data.Info.EventChannelNames{i},app.EventChannelDropDown.Value)
                EventIndice = i;
            end
        end
        app.EventTriggerNumberField.Value = strcat(num2str(length(app.Data.Events{EventIndice}))," event trigger.");
    else
       app.EventTriggerNumberField.Value = "No event trigger found."; 
    end
    
    if app.Data.Time(end)<3
        if app.Data.Time(end)<1
            TimeRangeText = strcat(num2str(app.Data.Time(end)),"s");
            app.TimeLimit = [0.0333,app.Data.Time(end)]; % sets maximum and minimum amount of time shown in Main Window Plot
        else
            TimeRangeText = strcat(num2str(0.5),"s");
            app.TimeLimit = [0.0333,app.Data.Time(end)]; % sets maximum and minimum amount of time shown in Main Window Plot
        end
    else
        TimeRangeText = strcat(num2str(0.5),"s");
        app.TimeLimit = [0.0333,3]; % sets maximum and minimum amount of time shown in Main Window Plot
    end

    % Offer single sample time range
    PrevItems = app.TimeSpanControlDropDown.Items;
    if length(PrevItems)>5
        PrevItems(1) = [];
    end

    app.TimeSpanControlDropDown.Items = {};
    app.TimeSpanControlDropDown.Items{1} = strcat(num2str(1/app.Data.Info.NativeSamplingRate),'s');
    for i = 1:length(PrevItems)
        app.TimeSpanControlDropDown.Items{i+1} = PrevItems{i};
    end
    
    app.TimeRangeViewBox.Value = TimeRangeText;
    app.ClimMaxValues = [];
    
    app.PlayedMovieBefore = 0;

    app.ChannelChange = "ProbeView";
    app.Grid_Traces_View_Panel.Visible                = "off";
    app.Grid_Traces_View_Panel.Enable                 = "off";
    if ~isempty(app.ChannelAxes)
        for k = 1:numel(app.ChannelAxes)
            if isvalid(app.ChannelAxes{k})  
                delete(app.ChannelAxes{k});
            end
        end
        app.ChannelAxes = [];
    end
    if ~isempty(app.ChannelGrid)
        delete(app.ChannelGrid)
        app.ChannelGrid = [];
    end

    app.PreservePlotChannelLocations = 1;
    app.PreviousThreshGrids = [];
    app.PlotThreshGrids = [];

    app.MovieTimeToJump = 30;

    % first plot after loading data: max 100 channel shown
    if length(app.Data.Info.ProbeInfo.ActiveChannel) > 100
        app.ActiveChannel = app.Data.Info.ProbeInfo.ActiveChannel(1:100);
    end
    
    datapointsforstd = round(str2double(app.TimeRangeViewBox.Value(1:end-1)) * app.Data.Info.NativeSamplingRate);
    
    stdrawdata = double(std(app.Data.Raw(:,1:datapointsforstd),[],'all','omitnan'));
    lowerlimit = 0;
    
    app.Slider.Limits = [lowerlimit,stdrawdata+stdrawdata*2];
    app.Slider.Value = (stdrawdata+stdrawdata*2)/2;

    app.PlotLineSpacing = app.Slider.Value;  % Height between each row plot
    app.PowerSpecResults = [];

    channelnr = size(app.Data.Raw,1);

    % Pick Colormap based on what the user selected (default = parula)
    app.tempcolorMapset = eval(strcat(app.tempcolorMap,"(channelnr)")); 
    Utility_Show_Info_Loaded_Data(app);

    app.UIAxes.Box = "off";

    if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        app.UIAxes.YDir = 'reverse';
    else
        app.UIAxes.YDir = 'normal';
    end

elseif strcmp(Type,"Extracting")

    %% Predefine checkboxes of what to plot
    % Activate the main window buttons that can be used after
    % loading the app.Data

    app.RUNButton_4.Enable = "on";
    app.RUNButton_5.Enable = "on";
    app.RUNButton_3.Enable = "on";
    app.RUNButton_2.Enable = "on";
    app.RUNButton.Enable = "on";

    app.CheckSuccesful_Extraction = 0;

    Placeholder = {};
    app.DropDown.Items = Placeholder;
    app.DropDown.Items{1} = 'Raw Data';
    
    Placeholder = {};
    app.DropDown_2.Items = Placeholder;
    app.DropDown_2.Items{1} = 'Non';

    app.PowerSpecResults = [];
    
    % Pick Colormap based on what the user selected (default = parula)
    app.tempcolorMapset = eval(strcat(app.tempcolorMap,"(size(app.Data.Raw,1))")); % Example colormap: You can use any other colormap
    
    Utility_Show_Info_Loaded_Data(app);
    
    if length(app.Data.Info.ProbeInfo.ActiveChannel)~=size(app.Data.Raw,1)
        msgbox(strcat(num2str(size(app.Data.Raw,1))," amplifier data channels found but ",num2str(length(app.Data.Info.ProbeInfo.ActiveChannel))," probe channel defined! Please define probe layout again with as many channel as in the raw dataset!"))
        error(strcat(num2str(size(app.Data.Raw,1))," amplifier data channels found but ",num2str(length(app.Data.Info.ProbeInfo.ActiveChannel))," probe channel defined! Please define probe layout again with as many channel as in the raw dataset!"));       
    end
    
    app.EventTriggerNumberField.Value = "No event trigger found."; 
    
    app.UIAxes.Box = "off";
    
elseif strcmp(Type,"VariableDefinition")

    Organize_Delete_All_Open_Windows(app,1);

    %% Define all important Variables based on extracted dat files
    if ~isa(Data, 'single')
        app.Data.Raw = single(Data);
    else
        app.Data.Raw = Data;
    end

    app.Data.Time = Time;
    clear Data;

    if strcmp(RecordingType,"IntanDat") || strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"Spike2") || strcmp(RecordingType,"Open Ephys") || strcmp(RecordingType,"NEO") || strcmp(RecordingType,"TDT Tank Data") || strcmp(RecordingType,"SpikeGLX NP") || strcmp(RecordingType,"SpikeInterface Maxwell MEA .h5")
        app.Data.Info = HeaderInfo;
    else
        fieldsToDelete = {'Header'};
        % Delete fields
        app.Data.Info = rmfield(HeaderInfo.orig(1).hdr, fieldsToDelete);
    end

    if ~isfield(app.Data.Info,'Channelorder')
        app.Data.Info.Channelorder = [];
    end
    % give extra samples to start time sample since its shifted back! -->
    % important for event analysis later!
    if isfield(HeaderInfo,'ExtractedTime')
        ExtracStartTimeStamp = HeaderInfo.ExtractedTime(1);
    else
        ExtracStartTimeStamp = 0;
    end

    if isfield(HeaderInfo,'startTimestamp')
        app.Data.Info.startTimestamp = HeaderInfo.startTimestamp+ExtracStartTimeStamp;
    elseif isfield(HeaderInfo,'firstSample')
        app.Data.Info.startTimestamp = str2double(HeaderInfo.firstSample)+ExtracStartTimeStamp;
    else
        app.Data.Info.startTimestamp = 0;
    end
    
    
    app.Data.Info.Data_Path = SelectedFolder;
    app.Data.Info.NativeSamplingRate = SampleRate;
    app.Data.Info.RecordingType = RecordingType;
    
    if ~strcmp(RecordingType,"SpikeInterface Maxwell MEA .h5")
        app.Data.Info.num_data_points = size(app.Data.Raw,2);
        app.Data.Info.NrChannel = size(app.Data.Raw,1);
        if ischar(Load_Data_Window_Info.ChannelSpacing) || isstring(Load_Data_Window_Info.ChannelSpacing)
            app.Data.Info.ChannelSpacing = str2double(Load_Data_Window_Info.ChannelSpacing);
        else
            app.Data.Info.ChannelSpacing = Load_Data_Window_Info.ChannelSpacing;
        end
        
        app.Data.Info.ProbeInfo.NrChannel = num2str(Load_Data_Window_Info.NrChannel);
        app.Data.Info.ProbeInfo.NrRows = num2str(Load_Data_Window_Info.NumberChannelRows);
        app.Data.Info.ProbeInfo.VertOffset = num2str(Load_Data_Window_Info.VerticalOffsetum);
        app.Data.Info.ProbeInfo.HorOffset = num2str(Load_Data_Window_Info.HorizontalOffsetum);
        app.Data.Info.ProbeInfo.ActiveChannel = sort(Load_Data_Window_Info.ActiveChannel);
            
        app.Data.Info.ProbeInfo.ECoGArray = Load_Data_Window_Info.ECoGArray;
        app.Data.Info.ProbeInfo.SwitchTopBottomChannel = Load_Data_Window_Info.SwitchTopBottomChannel;
        app.Data.Info.ProbeInfo.SwitchLeftRightChannel = Load_Data_Window_Info.SwitchLeftRightChannel;
        app.Data.Info.ProbeInfo.FlipLoadedData = Load_Data_Window_Info.FlipLoadedData;
        
        app.Data.Info.ProbeInfo.OffSetRows = double(Load_Data_Window_Info.OffSetRows);
        app.Data.Info.ProbeInfo.OffSetRowsDistance = Load_Data_Window_Info.OffSetRowsDistance;
        
        if isfield(Load_Data_Window_Info,'ProbeTrajectoryInfo')
            app.Data.Info.ProbeInfo.CompleteAreaNames = Load_Data_Window_Info.ProbeTrajectoryInfo.AreaNamesLong;
            app.Data.Info.ProbeInfo.ShortAreaNames = Load_Data_Window_Info.ProbeTrajectoryInfo.AreaNamesShort;
            app.Data.Info.ProbeInfo.AreaDistanceFromTip = Load_Data_Window_Info.ProbeTrajectoryInfo.AreaTipDistance;
        end
    else
        app.Data.Info.num_data_points = size(app.Data.Raw,2);
        app.Data.Info.NrChannel = size(app.Data.Raw,1);
    end

    % Get True MEA Grid Locations for position related analyis
    if strcmp(RecordingType,"SpikeInterface Maxwell MEA .h5")
        [app.Data] = Manage_Dataset_MEA_Grid_Locations(app.Data,app.Data.Info.MEACoords,HeaderInfo);
        if app.ExtractDataWindow.Save_Probe_Kilosort.Value == 1
            activechannel{1} = app.Data.Info.ProbeInfo.ActiveChannel;
            DummyStruc.Raw = [];
            DummyStruc.Info.ProbeInfo.NrChannel = app.Data.Info.ProbeInfo.NrChannel;
            msgbox("Please select a location to save the probe design in.")
            [~,~,~] = Manage_Dataset_Save_ProbeInfo_Kilosort(DummyStruc,app.executableFolder,app.Data.Info.ProbeInfo.NrRows,app.Data.Info.ProbeInfo.NrChannel,num2str(app.Data.Info.ChannelSpacing),activechannel,app.Data.Info.ProbeInfo.OffSetRows,str2double(app.Data.Info.ProbeInfo.OffSetRowsDistance),str2double(app.Data.Info.ProbeInfo.VertOffset),str2double(app.Data.Info.ProbeInfo.HorOffset),1,app.ExtractDataWindow.Save_Probe_SpikeInterface.Value);
            disp("Succesfully saved probe design in ")
            app.ExtractDataWindow.Save_Probe_SpikeInterface.Value;
        end
    end

    % get x and y coordinates
    activechannel{1} = app.Data.Info.ProbeInfo.ActiveChannel;
    DummyStruc.Raw = [];
    DummyStruc.Info.ProbeInfo.NrChannel = app.Data.Info.ProbeInfo.NrChannel;
    
    [app.Data.Info.ProbeInfo.xcoords,app.Data.Info.ProbeInfo.ycoords,~] = Manage_Dataset_Save_ProbeInfo_Kilosort(DummyStruc,"",app.Data.Info.ProbeInfo.NrRows,app.Data.Info.ProbeInfo.NrChannel,num2str(app.Data.Info.ChannelSpacing),activechannel,app.Data.Info.ProbeInfo.OffSetRows,str2double(app.Data.Info.ProbeInfo.OffSetRowsDistance),str2double(app.Data.Info.ProbeInfo.VertOffset),str2double(app.Data.Info.ProbeInfo.HorOffset),0,app.ExtractDataWindow.Save_Probe_SpikeInterface.Value);
    
    if str2double(app.Data.Info.ProbeInfo.VertOffset) ~= 0
        app.Data.Info.ProbeInfo.FakeSpacing = unique(diff(app.Data.Info.ProbeInfo.ycoords));
        if length(app.Data.Info.ProbeInfo.FakeSpacing)>1 && str2double(app.Data.Info.ProbeInfo.VertOffset) > 0 % just take first distance, other distances are 'skipped'
            app.Data.Info.ProbeInfo.FakeSpacing = abs(app.Data.Info.ProbeInfo.FakeSpacing(1));
        end
    else
        app.Data.Info.ProbeInfo.FakeSpacing = app.Data.Info.ChannelSpacing;
    end

    % Set up y labels with proper y and x coordinate
    app.Data.Info.ProbeInfo.YLabels = arrayfun(@(yy, xx) sprintf('%.0f (%.0f µm)', yy, xx), app.Data.Info.ProbeInfo.ycoords, app.Data.Info.ProbeInfo.xcoords, 'UniformOutput', false);
    
    if app.Data.Time(end)<3
        if app.Data.Time(end)<1
            TimeRangeText = strcat(num2str(app.Data.Time(end)),"s");
            app.TimeLimit = [0.0333,app.Data.Time(end)]; % sets maximum and minimum amount of time shown in Main Window Plot
        else
            TimeRangeText = strcat(num2str(0.5),"s");
            app.TimeLimit = [0.0333,app.Data.Time(end)]; % sets maximum and minimum amount of time shown in Main Window Plot
        end
    else
        TimeRangeText = strcat(num2str(0.5),"s");
        app.TimeLimit = [0.0333,3]; % sets maximum and minimum amount of time shown in Main Window Plot
    end

    % Offer single sample time range
    PrevItems = app.TimeSpanControlDropDown.Items;
    if length(PrevItems)>5
        PrevItems(1) = [];
    end

    app.TimeSpanControlDropDown.Items = {};
    app.TimeSpanControlDropDown.Items{1} = strcat(num2str(1/app.Data.Info.NativeSamplingRate),'s');
    for i = 1:length(PrevItems)
        app.TimeSpanControlDropDown.Items{i+1} = PrevItems{i};
    end
    app.TimeSpanControlDropDown.Value = app.TimeSpanControlDropDown.Items{end-2};

    app.TimeRangeViewBox.Value = TimeRangeText;
    app.ClimMaxValues = [];

    app.PreviousThreshGrids = [];
    app.PlotThreshGrids = [];
    
    if strcmp(RecordingType,"SpikeInterface Maxwell MEA .h5") % take from recording, not user data
        app.ActiveChannel = sort(app.Data.Info.ProbeInfo.ActiveChannel);    
    else
        app.ActiveChannel = sort(Load_Data_Window_Info.ActiveChannel);
    end

    app.Data.Info.SpikeType = "Non";
    app.ChannelChange = "ProbeView";
    
    app.MovieTimeToJump = 30;
    app.PlayedMovieBefore = 0;
    
    % Grid traces axes panel 
    if ~isempty(app.ChannelAxes)
        for k = 1:numel(app.ChannelAxes)
            if isvalid(app.ChannelAxes{k})  
                delete(app.ChannelAxes{k});
            end
        end
        app.ChannelAxes = [];
    end
    if ~isempty(app.ChannelGrid)
        delete(app.ChannelGrid)
        app.ChannelGrid = [];
    end

    app.Grid_Traces_View_Panel.Visible                = "off";
    app.Grid_Traces_View_Panel.Enable                 = "off";
    
    app.ChannelAxes = [];
    app.ChannelGrid = [];

    app.PreservePlotChannelLocations = 1;

    % first plot after loading data: max 100 channel shown
    if length(app.Data.Info.ProbeInfo.ActiveChannel) > 100
        app.ActiveChannel = app.Data.Info.ProbeInfo.ActiveChannel(1:100);
    end

    % % Get Channel Selection when new app.Data loadaed
    % ChannelString = strcat("1",",",num2str(app.Data.Info.NrChannel));
    % app.ChannelSelectionEditField.Value = ChannelString;

    % If extraction was succesfull and dat variable is
    % filled, indicate that it was succesful. This is
    % implemented bc. right after this module finished the extraction, the
    % window is closed and app.Data is plotted. But it should
    % only be plotted when the user succesfully extracted app.Data
    if ~isempty(app.Data)
        app.CheckSuccesful_Extraction = 1;
    end

    datapointsforstd = round(str2double(app.TimeRangeViewBox.Value(1:end-1)) * app.Data.Info.NativeSamplingRate);

    stdrawdata = double(std(app.Data.Raw(:,1:datapointsforstd),[],'all','omitnan'));
    lowerlimit = 0;

    app.Slider.Limits = [lowerlimit,stdrawdata+stdrawdata*2];
    app.Slider.Value = (stdrawdata+stdrawdata*2)/2;

    app.PlotLineSpacing = app.Slider.Value;  % Height between each row plot

    if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        app.UIAxes.YDir = 'reverse';
    else
        app.UIAxes.YDir = 'normal';
    end

elseif strcmp(Type,"Preprocessing")

    % Save Downsampled SamplingRate when Downsampling was applied
    % if isfield(app.Data.Info, 'DownsampleFactor') && app.PreprocDataPlotCheckBox.Value == 1
    %     app.Data.Info.DownsampledSamplingRate = round(app.Data.Info.NativeSamplingRate/app.Info.DownsampleFactor);
    % end

    if isfield(app.PowerSpecResults,'Preprocessed')
        fieldsToDelete = {'Preprocessed'};
        % Delete fields
        app.PowerSpecResults = rmfield(app.PowerSpecResults, fieldsToDelete);
    end

    [app] = Organize_Set_MainWindow_Dropdown(app,app.Data);
    app.ClimMaxValues = [];
    % if strcmp(app.DropDown.Value,'Raw Data')
    %     app.ChannelSelectionEditField.Value = strcat("1,",num2str(size(app.Data.Raw,1)));
    % elseif strcmp(app.DropDown.Value,'Preprocessed Data')
    %     app.ChannelSelectionEditField.Value = strcat("1,",num2str(size(app.Data.Preprocessed,1)));
    % end

    app.UIAxes.NextPlot = "replace"; 
    plot(app.UIAxes,0,0);
    app.UIAxes.NextPlot = "add"; 
    app.UIAxes_2.NextPlot = "replace"; 
    plot(app.UIAxes_2,0,0);
    app.UIAxes_2.NextPlot = "add"; 

    app.UIAxes.Box = "off";

    if strcmp(app.PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        app.UIAxes.YDir = 'reverse';
    else
        app.UIAxes.YDir = 'normal';
    end

    %Take care of potentially changed backgroundcolor
    app.UIAxes.Color = app.PlotAppearance.MainWindow.Data.Color.MainBackground;
    app.UIAxes_2.Color = app.PlotAppearance.MainWindow.Data.Color.TimeBackground;
    app.UIAxes.FontSize = app.PlotAppearance.MainWindow.Data.MainFontSize;
    app.UIAxes_2.FontSize = app.PlotAppearance.MainWindow.Data.TimeFontSize;

    app.RUNButton_3.Enable = "on";

end