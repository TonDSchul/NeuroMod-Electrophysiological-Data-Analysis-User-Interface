function [Data,CurrentPlotData] = Execute_Autorun_Extract_Events_Module_Functions(AutorunConfig,FunctionOrder,Data,DataPath,LoadedData,executableFolder,CurrentPlotData)

%________________________________________________________________________________________
%% This is the main function to execute event module autorun analysis 

% This function is called in the Execute_Autorun_Config_Template function
% when specified in the FunctionOrder

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute
% 3. Data: main data structure 
% 4. DataPath: char, Path to currently analyzed folder
% 5. LoadedData: 1 if data was loaded, 0 if data was extracted

% Outputs:
% 1. Data: main data structure 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%______________________________________________________________________________________________________
%% 4. Event Data Module
%______________________________________________________________________________________________________
% 4.1 Extract Events and Data
%______________________________________________________________________________________________________

if strcmp(FunctionOrder,'Extract_Events')
    %% Determine folder with events
    if strcmp(Data.Info.RecordingType,"NEO")
        Path = Data.Info.NeoSaveFolder;
    else
        Path = Data.Info.Data_Path;
    end
    % Time around each trigger
    TimearoundEvent(1) = str2double(AutorunConfig.ExtractEventRelatedDataModule.TimeBeforeEvent);
    TimearoundEvent(2) = str2double(AutorunConfig.ExtractEventRelatedDataModule.TimeAfterEvent );

    %% Function to determine which event channel are available for NEO recordings
    if strcmp(Data.Info.RecordingType,"NEO")
        [NeoEventStartTimeStamp,EventInfo,~,~] = Extract_Events_Module_NEO_Determine_Available_EventChannel(Data,Path);
        Info = [];
    else
        [EventInfo,~,~,~,Info] = Extract_Events_Module_Determine_Available_EventChannel(Data,Path,AutorunConfig.ExtractEventDataModule.ChannelOfInterest);
    end
    
    if strcmp(Data.Info.RecordingType,"TDT Tank Data")
        Info.State = 'Rising Edge';
    end

    %% Set general settings necessary to run event extraction function
    AdditionalEventInfo = Info;
    
    if ~strcmp(Data.Info.RecordingType,"Open Ephys")
        EventInfo.InputChannelNumber = AutorunConfig.ExtractEventDataModule.EventChannelSelection;
    else
        AdditionalEventInfo.InputChannelNumber = AutorunConfig.ExtractEventDataModule.EventChannelSelection;
    end

    % Split the string based on the delimiter ','
    IndividualStrings = strsplit(AutorunConfig.ExtractEventDataModule.EventChannelSelection, ',');
    
    % Convert the cell array of strings to a numeric vector
    InputChannelSelection = str2double(IndividualStrings);
    
    ExtractedRHDEventsFlag = 0;
    TextArea = [];
    RHDAllChannelData = [];

    SelectedNode = []; % in case of OE data this is filled

    %% Manage User selection to combine channel
    if ~isempty(AutorunConfig.ExtractEventRelatedDataModule.CombineEventChannel)
        
        EventsToCombine.CombinedChannel = [];
        EventsToCombine.CombinedIdentity = [];
        EventsToCombine.NewCombinedChannelNames = [];
         
        % selected Channel
        EventsToCombine.CombinedChannel = [EventsToCombine.CombinedChannel, str2double(strsplit(AutorunConfig.ExtractEventRelatedDataModule.CombineEventChannel,','))];
        numberevents = length(str2double(strsplit(AutorunConfig.ExtractEventRelatedDataModule.CombineEventChannel,',')));
        % New Event Identities
        if ~isempty(max(EventsToCombine.CombinedIdentity)+1)
            EventsToCombine.CombinedIdentity = [EventsToCombine.CombinedIdentity, zeros(1,numberevents)+max(EventsToCombine.CombinedIdentity)+1];
        else
            EventsToCombine.CombinedIdentity = [EventsToCombine.CombinedIdentity, zeros(1,numberevents)];
        end

        % Event Channel names
        if isempty(EventsToCombine.NewCombinedChannelNames)
            EventsToCombine.NewCombinedChannelNames = strsplit(AutorunConfig.ExtractEventRelatedDataModule.NewEventChannelName,',');
        else
            NewChannelNames = strsplit(AutorunConfig.ExtractEventRelatedDataModule.NewEventChannelName,',');
            for i = 1:length(NewChannelNames)
                EventsToCombine.NewCombinedChannelNames{end+1} = NewChannelNames{i};
            end
        end
    else
        EventsToCombine = [];
    end
    
    if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"Spike2") || strcmp(Data.Info.RecordingType,"IntanRHD") || strcmp(Data.Info.RecordingType,"NEO") || strcmp(Data.Info.RecordingType,"TDT Tank Data")
        EventInfo.EventType = AutorunConfig.ExtractEventDataModule.TriggerType;
    end
    
    if str2double(AutorunConfig.ExtractEventRelatedDataModule.LoadCosutmeTriggerIdentity) == 1
        Proceed = 1;
        if length(InputChannelSelection)>1
            warning("When wanting to load costume trigger identites, only a single event input channel is allowed! Skipping.")
            Proceed = 0;
        end
        
        if Proceed == 1
            MockUpMainapp.executableFolder = executableFolder;
            MockUpapp = [];
            CostumeTriggerIdentityWindow = Load_Costume_Trigger_Identity_Window(MockUpMainapp, MockUpapp);
            
            uiwait(CostumeTriggerIdentityWindow.LoadCostumeTriggerIdentityUIFigure);
            % Wait for the app to close
            
            if isvalid(CostumeTriggerIdentityWindow)
                if isempty(CostumeTriggerIdentityWindow.EventInfo)
                    msgbox("No valid file selected.")
                    delete(CostumeTriggerIdentityWindow);
                end
            end
            
            if isvalid(CostumeTriggerIdentityWindow)
                CostumeTriggerIdentityData = CostumeTriggerIdentityWindow.EventInfo;
                delete(CostumeTriggerIdentityWindow)
            else
                disp("Load Costume Trigger Identity Window closed.")
                CostumeChannelIdentityInfo = [];
            end
            
            CostumeChannelIdentityInfo = CostumeTriggerIdentityData;
        else
            CostumeChannelIdentityInfo = [];
        end
    else
        CostumeChannelIdentityInfo = [];
    end
    
    %% ---------------- Start Event Extraction ----------------
    if strcmp(Data.Info.RecordingType,"Open Ephys")
        [stringArray] = Utility_Extract_Contents_of_Folder(DataPath);
        stringArray(stringArray=="") = [];
        stringArray(~contains(stringArray,"Record")) = [];

        for i = 1:length(stringArray)
            if strcmp(AutorunConfig.ExtractEventDataModule.ChannelOfInterest,stringArray(i))
                SelectedNode = i;
                break;
            end
        end
        
        startTimestamp = Info.startTimestamp{SelectedNode};
        [Data,~,~,~] = Extract_Events_Module_Main_Function(Data,EventInfo,DataPath,Data.Info.RecordingType,AutorunConfig.ExtractEventDataModule.ChannelOfInterest,AutorunConfig.ExtractEventDataModule.EventSignalThreshold,InputChannelSelection,ExtractedRHDEventsFlag,TextArea,RHDAllChannelData,executableFolder,startTimestamp,TimearoundEvent,AdditionalEventInfo,EventsToCombine);
    else
        if strcmp(Data.Info.RecordingType,"NEO")
            startTimestamp = NeoEventStartTimeStamp;
        else
            if isfield(Data.Info,'startTimestamp')
                startTimestamp = Data.Info.startTimestamp;
            end
        end

        if strcmp(Data.Info.RecordingType,"SpikeInterface Maxwell MEA .h5")
            if isempty(EventInfo)
                warning(strcat("Ne event data found for Maxwell MEA .h5 recording in path ",DataPath));
                if isfield(Data,'Events')
                    Data.Events = [];
                end
                return;
            else
                if ~isfield(EventInfo,'EventSamples')
                    warning(strcat("Ne event data found for Maxwell MEA .h5 recording in path ",DataPath));
                    if isfield(Data,'Events')
                        Data.Events = [];
                    end
                    return;
                end
            end
        end

        [Data,~,~,~] = Extract_Events_Module_Main_Function(Data,EventInfo,DataPath,Data.Info.RecordingType,AutorunConfig.ExtractEventDataModule.ChannelOfInterest,AutorunConfig.ExtractEventDataModule.EventSignalThreshold,InputChannelSelection,ExtractedRHDEventsFlag,TextArea,RHDAllChannelData,executableFolder,startTimestamp,TimearoundEvent,AdditionalEventInfo,EventsToCombine);
    end
    
    if isfield(Data,'Events')
        %% Save event related infos for later on the fly extraction
        Data = Extract_Events_Module_Add_EventRelatedInfo(Data,AutorunConfig.ExtractEventRelatedDataModule.TimeBeforeEvent,AutorunConfig.ExtractEventRelatedDataModule.TimeAfterEvent);
    end

    %% Populate text are
    if ~isempty(CostumeChannelIdentityInfo) && isfield(Data,'Events')
        if ~isempty(Data.Events)
            [Data,Error] = Extract_Events_Module_Costume_Trigger_Identity(Data,CostumeChannelIdentityInfo);
            if Error == 0
                disp(strcat('Trigger for event channel where divided in ',num2str(length(CostumeChannelIdentityInfo.UniqueIdentities)),' individual channel according to the loaded trigger identity file.'));
                for i = 1:length(CostumeChannelIdentityInfo.UniqueIdentities)
                    disp(convertStringsToChars(strcat("Channel ",CostumeChannelIdentityInfo.UniqueIdentities(i)," contains ",num2str(sum(CostumeChannelIdentityInfo.AllIdentities==CostumeChannelIdentityInfo.UniqueIdentities(i)))," trigger.")));
                end
            else
                disp('No costume trigger identity could be applied!');
            end

        end
        CostumeChannelIdentityInfo = [];
    end

    if isfield(Data,'Events')
        if ~isempty(Data.Events)
            disp("Successfully extracted Events.");
        else
            warning("No Events could be extracted.");
            msgbox("No Events could be extracted.");
        end
    else
        warning("No Events could be extracted.");
        msgbox("No Events could be extracted.");
    end
end

% 4.2 Extract Events and Data
%______________________________________________________________________________________________________

ImportEventInfo = [];

if strcmp(FunctionOrder,'Import_Events')
    [ImportEventInfo,Errormessage,NewPath,outputLines] = Import_Events_Read_File(ImportEventInfo);

    if ~isfield(ImportEventInfo,'TempEvents')
        warning("Error: No valid file containing events selected!");
        return
    end

    if isempty(ImportEventInfo.TempEvents)
        warning("Error: No valid file containing events selected!");
        return
    end

    [Data,~] = Import_Events_Add_Imported_Events(Data,ImportEventInfo);
    
    
    if ~isfield(Data,'Events')
        warning("No suitable event indices found. Check whether the correct file is loaded and sampling frequency is the same.");
    else
        succesmessagetoshow = [];
        for i = 1:length(Data.Events)
            succesmessagetoshow{i} = ['Saved ',num2str(length(Data.Events{i})) ,' Event/TTL Trigger for channel ',Data.Info.EventChannelNames{i}];
        end
        disp(succesmessagetoshow);

        %% Save event related infos for later on the fly extraction
        Data = Extract_Events_Module_Add_EventRelatedInfo(Data,AutorunConfig.ExtractEventRelatedDataModule.ImportTimeBeforeEvent,AutorunConfig.ExtractEventRelatedDataModule.ImportTimeAfterEvent);
    end
end

%______________________________________________________________________________________________________
% 4.3 Event Related Signal Analysis
%______________________________________________________________________________________________________

if isfield(Data,'Events')

    %% ERP
    if strcmp(FunctionOrder,'Event_Analysis_ERP') || strcmp(FunctionOrder,'Event_Analysis_CSD') || strcmp(FunctionOrder,'Event_Analysis_TimeFrequencyPower') || strcmp(FunctionOrder,'Event_Static_Power_Spectrum')
        EventChannelFound = 0;
        for i = 1:length(Data.Info.EventChannelNames)
            if strcmp(AutorunConfig.AnalyseEventDataModule.EventChannelSelection,Data.Info.EventChannelNames{i})
                EventChannelFound = 1;
            end
        end

        if EventChannelFound == 0
            warning("Event channel name to extract event related data from (AutorunConfig.AnalyseEventDataModule.EventChannelSelection) is not found as part of the dataset! Skipping")
        end

        if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,'Preprocessed Event Related Data')
            if ~isfield(Data.Info,'EventRelatedPreprocessing')
                warning("Preprocessed event related data selected for analysis, but not present in dataset. Skipping step to analyse lfp.")
                return;
            end
        end
        
        if EventChannelFound == 1

            tempcolorMapset = eval(strcat(AutorunConfig.AnalyseEventDataModule.tempcolorMap,"(size(Data.Raw,1))")); % Example colormap: You can use any other colormap
            
            %% -------------------- Extract Event Related Data -------------------- 
            TimearoundEvent(1) = str2double(AutorunConfig.ExtractEventRelatedDataModule.TimeBeforeEvent);
            TimearoundEvent(2) = str2double(AutorunConfig.ExtractEventRelatedDataModule.TimeAfterEvent);
            
            [Data,~] = Event_Module_Extract_Event_Related_Data(Data,AutorunConfig.AnalyseEventDataModule.EventChannelSelection,TimearoundEvent,AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType);
    
            %% -------------------- Populate event channel selection -------------------- 
            if strcmp(AutorunConfig.AnalyseEventDataModule.TriggerToAnalyze,'All')
                numtrig = 1:size(Data.EventRelatedData,2);
                charStr = sprintf('%g,', numtrig);
                charStr(end) = [];   % remove the last comma
                TriggerToAnayze = charStr;
            else
                TriggerToAnayze = AutorunConfig.AnalyseEventDataModule.TriggerToAnalyze;
            end
            [TriggerToAnayze] = Event_Module_Check_EventInput(TriggerToAnayze,Data,AutorunConfig.AnalyseEventDataModule.EventChannelSelection,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,1);
            
            EventNr = sort(eval(TriggerToAnayze));
    
            if strcmp(AutorunConfig.AnalyseEventDataModule.ERPPlotType,'ImageSC')
                SingleChannelPlotType = 1;
            else
                SingleChannelPlotType = 0;
            end
                
            % ERP
            if strcmp(FunctionOrder,'Event_Analysis_ERP')

                

               
                ERPFigure = figure();
                UIAxes = subplot(2,1,1);
                UIAxes_2 = subplot(2,1,2);
                UIAxes.NextPlot = "add";
                
                SelectedChannel = Data.Info.ProbeInfo.ActiveChannel(AutorunConfig.AnalyseEventDataModule.ChannelSelection);
                
                if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,'Raw Event Related Data')
                    [~,~,~,~,CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,UIAxes_2,Data.EventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,SelectedChannel,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All',AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr,AutorunConfig.PreservePlotChannelLocations,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                else
                    [~,~,~,~,CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,UIAxes_2,Data.PreprocessedEventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,SelectedChannel,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All',AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr,AutorunConfig.PreservePlotChannelLocations,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                end
                
                ERPFigure.Color = AutorunConfig.ComponentsInWindowColor;
                [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
                [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);
    
                %% Plot Results if turned on
                if strcmp(AutorunConfig.SaveFigures,"on")
                    Execute_Autorun_Save_Figure(ERPFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Event_Related_Potential", DataPath, "ERP", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ERP")
                end
                
                %% Export Data if required
                if AutorunConfig.ExportDataThisBlock == 1
                    Execute_Autorun_Export_Data(AutorunConfig,"Event ERP",Data,executableFolder,"",CurrentPlotData,0);
                end
                CurrentPlotData = [];

            end
        
            %% CSD
            if strcmp(FunctionOrder,'Event_Analysis_CSD')
        
                CSDFigure = figure();
                UIAxes = axes;
                UIAxes.NextPlot = "add";
                
                CSD.ChannelSpacing = Data.Info.ChannelSpacing;
                CSD.HammWindow = str2double(AutorunConfig.AnalyseEventDataModule.CSDHammWindow);
                CSD.SelectedChannel = Data.Info.ProbeInfo.ActiveChannel(AutorunConfig.AnalyseEventDataModule.ChannelSelection);
                
                if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,'Raw Event Related Data')
                    [~,~,~,~,CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,[],Data.EventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,CSD.SelectedChannel,CSD,[],[],[],AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr,AutorunConfig.PreservePlotChannelLocations,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                else
                    [~,~,~,~,CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,[],Data.PreprocessedEventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,CSD.SelectedChannel,CSD,[],[],[],AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr,AutorunConfig.PreservePlotChannelLocations,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                end
    
                CSDFigure.Color = AutorunConfig.ComponentsInWindowColor;
                [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
                
                %% Plot Results if turned on
                if strcmp(AutorunConfig.SaveFigures,"on")
                    Execute_Autorun_Save_Figure(CSDFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Event_Related_Current_Source_Density", DataPath, "CSD", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "CSD")
                end

                %% Export Data if required
                if AutorunConfig.ExportDataThisBlock == 1
                    Execute_Autorun_Export_Data(AutorunConfig,"Event CSD",Data,executableFolder,"",CurrentPlotData,0);
                end
                CurrentPlotData = [];
            end
    
            if strcmp(FunctionOrder,'Event_Static_Power_Spectrum')
                for i = 1:length(AutorunConfig.AnalyseEventDataModule.SpectrumPlotType)
                    
                    if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Preprocessed Event Related Data")
                        if ~isfield(Data,'PreprocessedEventRelatedData')
                            disp("No preprocecssed event related data available for static spectrum. Please change 'AutorunConfig.AnalyseEventDataModule.EventRelatedDataType' to 'Raw Event Related Data' or preprocess before that step. Skipping");
                            return;
                        end
                    end
    
                    if strcmp(AutorunConfig.AnalyseEventDataModule.SpectrumPlotType(i),"Band Power Individual Channel")
        
                        EventSpectrumFigure = figure();
                        UIAxes = axes;
                        UIAxes.NextPlot = "add";
    
                        SelectedChannel = str2double(AutorunConfig.AnalyseEventDataModule.SpectrumChannel);           
    
                        if Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
                            TempActiveChannel = (str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows)+1)-sort(Data.Info.ProbeInfo.ActiveChannel);
                            [SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(TempActiveChannel,SelectedChannel,'MainWindow');
                        else
                            [SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,SelectedChannel,'MainWindow');
                        end
     
                        SelectedEvents = EventNr;
    
                        set(UIAxes, 'YDir', 'normal');
                        cb = colorbar(UIAxes);   % Create a colorbar (if it exists)
                        if ~isempty(cb)
                            delete(cb);                  % Delete the colorbar
                        end
                        
                        [CurrentPlotData] = Event_Analyse_Static_Power_Spectrum(Data,UIAxes,AutorunConfig.AnalyseEventDataModule.SpectrumDataType,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SelectedChannel,AutorunConfig.AnalyseEventDataModule.SpectrumChannel,AutorunConfig.AnalyseEventDataModule.SpectrumFrequencyRange,CurrentPlotData,AutorunConfig.PlotAppearance,SelectedEvents,AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                        
                        EventSpectrumFigure.Color = AutorunConfig.ComponentsInWindowColor;
                        [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
                        
                        %% Export Data if required
                        if AutorunConfig.ExportDataThisBlock == 1
                            Execute_Autorun_Export_Data(AutorunConfig,"Event Related Static Spectrum",Data,executableFolder,AutorunConfig.AnalyseEventDataModule.SpectrumPlotType(i),CurrentPlotData,0);
                        end
                        CurrentPlotData = [];
                    elseif strcmp(AutorunConfig.AnalyseEventDataModule.SpectrumPlotType(i),"Band Power over Depth")
                        
                        EventSpectrumFigure = figure();
                        UIAxes = subplot(1,2,1);
                        UIAxes_2 = subplot(1,2,2);
                        UIAxes.NextPlot = "add";
                        UIAxes_2.NextPlot = "add";
    
                        UIAxes.YScale = 'linear';
                               
                        if strcmp(AutorunConfig.AnalyseEventDataModule.TriggerToAnalyze,'All')
                            SelectedEvents = 1:size(Data.EventRelatedData,2);
                        else
                            SelectedEvents = str2double(split(AutorunConfig.AnalyseEventDataModule.TriggerToAnalyze,','))';
                        end
            	        
                        DepthChannel = Data.Info.ProbeInfo.ActiveChannel(AutorunConfig.AnalyseEventDataModule.ChannelSelection);
                        
                        BandPower = [];
                        
                        [~,BandPower,CurrentPlotData] = Event_Power_Spectrum_Over_Depth(Data,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,BandPower,AutorunConfig.AnalyseEventDataModule.SpectrumFrequencyRange,UIAxes,UIAxes_2,[],'All',AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,SelectedEvents,DepthChannel,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,AutorunConfig.PreservePlotChannelLocations,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);    
                        
                        EventSpectrumFigure.Color = AutorunConfig.ComponentsInWindowColor;
                        [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
                        [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);

                        %% Export Data if required
                        if AutorunConfig.ExportDataThisBlock == 1
                            Execute_Autorun_Export_Data(AutorunConfig,"Event Related Static Spectrum",Data,executableFolder,AutorunConfig.AnalyseEventDataModule.SpectrumPlotType(i),CurrentPlotData,0);
                        end
                        CurrentPlotData = [];
                    end
    
                    %% Plot Results if turned on
                    if strcmp(AutorunConfig.SaveFigures,"on")
                        Execute_Autorun_Save_Figure(EventSpectrumFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.AnalyseEventDataModule.SpectrumPlotType(i), DataPath, "Event_Related_Spectrum", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "Event_Related_Spectrum")
                    end
                end
                
            end
        
            if strcmp(FunctionOrder,'Event_Analysis_TimeFrequencyPower')
                for i = 1:length(AutorunConfig.AnalyseEventDataModule.TFPlotType)
                    for j = 1:length(AutorunConfig.AnalyseEventDataModule.TFPlotAddons)
            
                        TFFigure = figure();
                        UIAxes = axes;
                        UIAxes.NextPlot = "add";
            
                        ChannelSelection = AutorunConfig.AnalyseEventDataModule.ChannelSelection;
                
                        EventSelection = TriggerToAnayze;
                        
                        [~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(Data,"Moorlet Wavelets",ChannelSelection,EventSelection,AutorunConfig.AnalyseEventDataModule.TFFrequencyRange,AutorunConfig.AnalyseEventDataModule.TFCycleWidth,[],[]);
        
                        if strcmp(AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,'Raw Data')
                            if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Raw Event Related Data")
                                [~,CurrentPlotData] = Event_Module_Time_Frequency_Main(Data,Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                            elseif strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Preprocessed Event Related Data")
                                [~,CurrentPlotData] = Event_Module_Time_Frequency_Main(Data,Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                            end
                        else
                            if isfield(Data.Info,"DownsampleFactor")
                                if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Raw Event Related Data")
                                    [~,CurrentPlotData] = Event_Module_Time_Frequency_Main(Data,Data.EventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                                elseif strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Preprocessed Event Related Data")
                                    [~,CurrentPlotData] = Event_Module_Time_Frequency_Main(Data,Data.PreprocessedEventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                                end
                            else
                                if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Raw Event Related Data")
                                    [~,CurrentPlotData] = Event_Module_Time_Frequency_Main(Data,Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                                elseif strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Preprocessed Event Related Data")
                                    [~,CurrentPlotData] = Event_Module_Time_Frequency_Main(Data,Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.BaselineNormalize,AutorunConfig.AnalyseEventDataModule.BaselineWindow);
                                end
                            end
                        end
                        
                        TFFigure.Color = AutorunConfig.ComponentsInWindowColor;
                        [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
    
                        %% Plot Results if turned on
                        if strcmp(AutorunConfig.SaveFigures,"on")
                            Execute_Autorun_Save_Figure(TFFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "_Time_Frequency_Power", DataPath, AutorunConfig.AnalyseEventDataModule.TFPlotType(i), AutorunConfig.ExtractRawRecording.FileType, AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j), AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "TF")
                        end

                        %% Export Data if required
                        if AutorunConfig.ExportDataThisBlock == 1
                            Execute_Autorun_Export_Data(AutorunConfig,"Event TF",Data,executableFolder,strcat(AutorunConfig.AnalyseEventDataModule.TFPlotType(i),",",AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j)),CurrentPlotData,0);
                        end
                        CurrentPlotData = [];
                    end
                end
            end
        end
    end

else % if isfield(Data,'Events')
    if strcmp(FunctionOrder,'Event_Analysis_ERP') || strcmp(FunctionOrder,'Event_Analysis_CSD') || strcmp(FunctionOrder,'Event_Analysis_TimeFrequencyPower') || strcmp(FunctionOrder,'Event_Static_Power_Spectrum')
        warning("No Events found, skipping step.");
        msgbox("No Events found, skipping step.");
    end
end

%______________________________________________________________________________________________________
% 4.4 Prepro event related data
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'PreproEventDataModule')
    if isfield(Data,'Events')
        %% Trial Rejection
        if AutorunConfig.PreproEventDataModule.TrialRejection == true
            Channel = [1,size(Data.Raw,1)];
            try
                RejectTrials = eval(AutorunConfig.PreproEventDataModule.TrialsToReject);
            catch
                msgbox("Error: Could not determine trigger to reject.")
                return;
            end
            
            [Data,Error] = Preprocessing_Events_Add_Preprocessing_Info(Data,'Trial Rejection',Channel,RejectTrials,AutorunConfig.PreproEventDataModule.EventChannelSelection);
            
            if Error == 1
                warning("Event related preprocessing could not be performed. Check autorun config file!")
                return
            end
        end
        %% Channel Interpoaltion
        if AutorunConfig.PreproEventDataModule.ChannelInterpolation == true
            try
                RejectChannel = eval(AutorunConfig.PreproEventDataModule.ChannelToInterpolate);
            catch
                msgbox("Error: Could not determine channel to interpolate.")
                return;
            end
            
            Trials = [];
            for i = 1:length(Data.Info.EventChannelNames)
                if strcmp(AutorunConfig.PreproEventDataModule.EventChannelSelection,Data.Info.EventChannelNames{i})
                    Trials = [1,length(Data.Events{i})];
                end
            end
    
            if isempty(Trials)
                warning("Error: Channel to preprocess is not found as part of the dataset. Check the autorun config file!")
                return;
            end
    
            [Data,Error] = Preprocessing_Events_Add_Preprocessing_Info(Data,'Channel Rejection',RejectChannel,Trials,AutorunConfig.PreproEventDataModule.EventChannelSelection);
            
            if Error == 1
                return
            end
        end

    else
        warning("No event data found. Skipping preprocessing of event related data.");
    end
end
%______________________________________________________________________________________________________
% 4.5 Event Related Spike Analysis
%______________________________________________________________________________________________________

if isfield(Data,'Events')
    if strcmp(FunctionOrder,'Event_Spike_Analysis')

        DepthChannel = AutorunConfig.AnalyseEventSpikesModule.ChanneltoPlot;
        
        if ~isfield(Data,'Spikes')
        
            msgbox("Warning: No spike data found. Please first use the Spike Module to extract spike data! Skipping event related spike analysis.");
            warning("Warning: No spike data found. Please first use the Spike Module to extract spike data! Skipping event related spike analysis.");

        elseif isfield(Data,'Spikes')
            
            %% -------------------- Extract Event Related Data -------------------- 
            TimearoundEvent(1) = str2double(AutorunConfig.ExtractEventRelatedDataModule.TimeBeforeEvent);
            TimearoundEvent(2) = str2double(AutorunConfig.ExtractEventRelatedDataModule.TimeAfterEvent);
            
            [Data,~] = Event_Module_Extract_Event_Related_Data(Data,AutorunConfig.AnalyseEventDataModule.EventChannelSelection,TimearoundEvent,AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType);
    
            %% -------------------- Populate event channel selection -------------------- 
            if strcmp(AutorunConfig.AnalyseEventDataModule.TriggerToAnalyze,'All')
                numtrig = 1:size(Data.EventRelatedData,2);
                charStr = sprintf('%g,', numtrig);
                charStr(end) = [];   % remove the last comma
                TriggerToAnayze = charStr;
            else
                TriggerToAnayze = AutorunConfig.AnalyseEventDataModule.TriggerToAnalyze;
            end
            [TriggerToAnayze] = Event_Module_Check_EventInput(TriggerToAnayze,Data,AutorunConfig.AnalyseEventDataModule.EventChannelSelection,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,1);
            
            Events = TriggerToAnayze;

            BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;

            numCluster = numel(unique(Data.Spikes.SpikeCluster));
            rgbMatrix = lines(numCluster);

            % Simulate GUI inputs by converting variables into edit field structure 
            if strcmp(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot,"All") && ~strcmp(Data.Info.SpikeType,'Internal')
                numunits = length(unique(Data.Spikes.SpikeCluster));
                AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot = string(1:numunits);
            end

            ChannelSelection.Value = DepthChannel;
            UnitsToPlot.Value = AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot;

            if isempty(UnitsToPlot.Value) || strcmp(Data.Info.SpikeType,'Internal')
                TotalIterations = 1;
            else
                TotalIterations = 2;
            end

            SpkTrgSpikes = 2;
            
            if strcmp(Data.Info.Sorter,'Non')
                [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',0,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,AutorunConfig.AnalyseEventDataModule.EventChannelSelection);
            else
                [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',0,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,AutorunConfig.AnalyseEventDataModule.EventChannelSelection);
            end

            for TotalIts = 1:TotalIterations % 2 if unit plots

                if TotalIts == 1 % if no unit plot
                    UnitIterations = 1;
                    ClusterToPlot = AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions;
                else % if unit plot
                    if isscalar(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot)
                        AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot = convertStringsToChars(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot);
                        if contains(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot,',')
                            AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot = string(str2double(strsplit(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot,',')));
                        end
                    end

                    UnitIterations = length(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot);
                    ClusterToPlot = AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot;
                end
                % loop over analysis types
                for i = 1:length(AutorunConfig.AnalyseEventSpikesModule.Plottype)
                    
                    if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average") && SpkTrgSpikes == 0
                        [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',1,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,AutorunConfig.AnalyseEventDataModule.EventChannelSelection);
                        SpkTrgSpikes = 1;
                    elseif ~strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average") && SpkTrgSpikes == 1
                        [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',0,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,AutorunConfig.AnalyseEventDataModule.EventChannelSelection);
                        SpkTrgSpikes = 0;
                    end
                    
                    % loop over units
                    for nunits = 1:UnitIterations

                        if strcmp(Data.Info.SpikeType,'Internal')
                            CurrentClusterToPlot.Value = "Non";
                            ClusterToPlot = "Non";
                        else
                            if ~strcmp(ClusterToPlot(1),"All") && ~strcmp(ClusterToPlot(1),"Non")
                                if str2double(ClusterToPlot(nunits))<=numCluster
                                    CurrentClusterToPlot.Value = num2str(ClusterToPlot(nunits));
                                else
                                    disp(strcat("Unit ",ClusterToPlot(nunits)," not part of spike dataset. Skipping"));
                                    continue;
                                end
                            else
                                CurrentClusterToPlot.Value  = ClusterToPlot;                          
                            end
        
                            if ischar(CurrentClusterToPlot.Value)
                                CurrentClusterToPlot.Value = convertCharsToStrings(CurrentClusterToPlot.Value);
                            end
                        end

                        SpikeAnalysisFigure = figure();
                        UIAxes = subplot(2,2,1);
                        UIAxes_2 = subplot(2,2,2);
                        UIAxes_3 = subplot(2,2,3);
                        UIAxes.NextPlot = "add";
                        
                        BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;
        
                        TextArea = [];
    
                        [TempData,~,~,~,CurrentPlotData] = Events_Spikes_Manage_Analysis_Plots(Data,Events,UIAxes,AutorunConfig.AnalyseEventSpikesModule.Plottype(i),AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,TextArea,rgbMatrix,numCluster,CurrentClusterToPlot.Value,ChannelSelection,BaselineWindow,AutorunConfig.AnalyseEventSpikesModule.Normalize,AutorunConfig.AnalyseEventSpikesModule.TimeSpikeTriggeredAverage,UIAxes_3,UIAxes_2,AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings,AutorunConfig.PlotAppearance,DepthChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,AutorunConfig.AnalyseEventDataModule.EventChannelSelection,1,AutorunConfig.PreservePlotChannelLocations);
         
                        if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered LFP") || strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average")
                            if ~isempty(TempData)
                                Data = TempData;
                            end
                        else
                            %Data = TempData;
                        end
                        
                        %% Properly set up plot for saving (x axis ticks/labels and stuff like that)
                        if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Map")
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes,0,"Left Axis Only",[],[],"Time [s]",[],[],8);
                        end
        
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
                        
                        % Dont know why thats necessary, but it is,
                        % just when units plotted 
                        if TotalIterations > 1
                            yyaxis(UIAxes_3, 'left');
                            UIAxes_3.YDir = 'reverse';
                        end
                        
                        SpikeAnalysisFigure.Color = AutorunConfig.ComponentsInWindowColor;
                        [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
                        if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Map")
                            UIAxes.Color = [1 1 1];
                        end
                        [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);
                        [UIAxes_3] = Execute_Autorun_Set_Plot_Colors(UIAxes_3,AutorunConfig);
                        
                        if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered LFP") || strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average") || strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Rate Heatmap")
                            c = findobj(UIAxes.Parent, 'Type', 'ColorBar');
                            c.Color = 'k';   
                            c.Label.Color = 'k';  
                        end
                        
                        if strcmp(Data.Info.Sorter,'Non')
                            SpikeName = "Internal Spike Detection";
                        else
                            SpikeName = AutorunConfig.LoadfromSpikeSorting.Sorter;
                        end

                        if TotalIterations > 1 && TotalIts == 2
                            %% Plot Results if turned on
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,strcat(" Event Spikes ",SpikeName," Unit ",num2str(nunits)," "), DataPath,AutorunConfig.AnalyseEventSpikesModule.Plottype(i) , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventIteration")
                            end
                        elseif TotalIterations > 1 && TotalIts == 1
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.AnalyseEventSpikesModule.Plottype(i), DataPath, strcat(" Event Spikes ",SpikeName) , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventSpikes")
                            end
                        else
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.AnalyseEventSpikesModule.Plottype(i), DataPath, strcat(" Event Spikes ",SpikeName) , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventSpikes")
                            end
                        end

                    end
                end%Plottpes
            end
        end
    end
else % if isfield(Data,'Events')
    if strcmp(FunctionOrder,'Event_Spike_Analysis')
        warning("No Events found, skipping event spike analysis step.");
        msgbox("No Events found, skipping event spike analysis step.");
    end
end