function [Data] = Execute_Autorun_Extract_Events_Module_Functions(AutorunConfig,FunctionOrder,Data,DataPath,LoadedData,executableFolder)

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
        EventInfo.EventType = AutorunConfig.ExtractEventDataModule.EventType;
    end
    
    if str2double(AutorunConfig.ExtractEventRelatedDataModule.LoadCosutmeTriggerIdentity) == 1
        Proceed = 1;
        if length(InputChannelSelection)>1
            disp("When wanting to load costume trigger identites, only a single event input channel is allowed!")
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

%______________________________________________________________________________________________________
% 4.1 Event Related Signal Analysis
%______________________________________________________________________________________________________

if isfield(Data,'Events')

    %% ERP
    if strcmp(FunctionOrder,'Event_Analysis_ERP') || strcmp(FunctionOrder,'Event_Analysis_CSD') || strcmp(FunctionOrder,'Event_Analysis_TimeFrequencyPower') || strcmp(FunctionOrder,'Event_Static_Power_Spectrum')
        if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,'Preprocessed Event Related Data')
            if ~isfield(Data,'PreprocessedEventRelatedData')
                warning("Preprocessed event related data selected for analysis, but not present in dataset. Skipping step to analyse lfp.")
                return;
            end
        end

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
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,UIAxes_2,Data.EventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,SelectedChannel,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All',AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr);
            else
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,UIAxes_2,Data.PreprocessedEventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,SelectedChannel,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All',AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr);
            end
            
            ERPFigure.Color = AutorunConfig.ComponentsInWindowColor;
            [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
            [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);

            %% Plot Results if turned on
            if strcmp(AutorunConfig.SaveFigures,"on")
                Execute_Autorun_Save_Figure(ERPFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Event_Related_Potential", DataPath, "ERP", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ERP")
            end
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
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,[],Data.EventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,CSD.SelectedChannel,CSD,[],[],[],AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr);
            else
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,[],Data.PreprocessedEventRelatedData(:,EventNr,:),Data.Info.EventRelatedTime,CSD.SelectedChannel,CSD,[],[],[],AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.SingleERPChannel,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SingleChannelPlotType,EventNr);
            end

            CSDFigure.Color = AutorunConfig.ComponentsInWindowColor;
            [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
            
            %% Plot Results if turned on
            if strcmp(AutorunConfig.SaveFigures,"on")
                Execute_Autorun_Save_Figure(CSDFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Event_Related_Current_Source_Density", DataPath, "CSD", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "CSD")
            end
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
                    
                    [AutorunConfig.CurrentPlotData] = Event_Analyse_Static_Power_Spectrum(Data,UIAxes,AutorunConfig.AnalyseEventDataModule.SpectrumDataType,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,SelectedChannel,AutorunConfig.AnalyseEventDataModule.SpectrumChannel,AutorunConfig.AnalyseEventDataModule.SpectrumFrequencyRange,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance,SelectedEvents,AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom);
                    
                    EventSpectrumFigure.Color = AutorunConfig.ComponentsInWindowColor;
                    [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);

                elseif strcmp(AutorunConfig.AnalyseEventDataModule.SpectrumPlotType(i),"Band Power over Depth")
                    
                    EventSpectrumFigure = figure();
                    UIAxes = subplot(1,2,1);
                    UIAxes_2 = subplot(1,2,2);
                    UIAxes.NextPlot = "add";
                    UIAxes_2.NextPlot = "add";

                    UIAxes.YScale = 'linear';
                           
                    if ~ischar(AutorunConfig.EventRange)
                        if ~isempty(AutorunConfig.EventRange)
                            SelectedEvents = AutorunConfig.EventRange;
                        else
                            SelectedEvents = [1,size(Data.EventRelatedData,2)];
                        end
                    else
                        if ~isempty(AutorunConfig.EventRange)
                            SelectedEvents = str2double(split(AutorunConfig.EventRange,','))';
                        else
                            SelectedEvents = [1,size(Data.EventRelatedData,2)];
                        end
                    end
            	    
                    DepthChannel = Data.Info.ProbeInfo.ActiveChannel(AutorunConfig.AnalyseEventDataModule.ChannelSelection);
                    
                    BandPower = [];
                    
                    [~,BandPower,~] = Event_Power_Spectrum_Over_Depth(Data,AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,BandPower,AutorunConfig.AnalyseEventDataModule.SpectrumFrequencyRange,UIAxes,UIAxes_2,[],'All',AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,SelectedEvents,DepthChannel,AutorunConfig.PlotAppearance,AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom);    
                    
                    EventSpectrumFigure.Color = AutorunConfig.ComponentsInWindowColor;
                    [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
                    [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);
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
        
                    ChannelSelection = Data.Info.ProbeInfo.ActiveChannel(AutorunConfig.AnalyseEventDataModule.ChannelSelection);
            
                    EventSelection = TriggerToAnayze;
                    
                    [~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(Data,"Moorlet Wavelets",ChannelSelection,EventSelection,AutorunConfig.AnalyseEventDataModule.TFFrequencyRange,AutorunConfig.AnalyseEventDataModule.TFCycleWidth,[],[]);
    
                    if strcmp(AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,'Raw Data')
                        if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Raw Event Related Data")
                            Event_Module_Time_Frequency_Main(Data,Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                        elseif strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Preprocessed Event Related Data")
                            Event_Module_Time_Frequency_Main(Data,Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                        end
                    else
                        if isfield(Data.Info,"DownsampleFactor")
                            if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Raw Event Related Data")
                                Event_Module_Time_Frequency_Main(Data,Data.EventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            elseif strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Preprocessed Event Related Data")
                                Event_Module_Time_Frequency_Main(Data,Data.PreprocessedEventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            end
                        else
                            if strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Raw Event Related Data")
                                Event_Module_Time_Frequency_Main(Data,Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            elseif strcmp(AutorunConfig.AnalyseEventDataModule.EventRelatedDataType,"Preprocessed Event Related Data")
                                Event_Module_Time_Frequency_Main(Data,Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            end
                        end
                    end
                    
                    TFFigure.Color = AutorunConfig.ComponentsInWindowColor;
                    [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);

                    %% Plot Results if turned on
                    if strcmp(AutorunConfig.SaveFigures,"on")
                        Execute_Autorun_Save_Figure(TFFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "_Time_Frequency_Power", DataPath, AutorunConfig.AnalyseEventDataModule.TFPlotType(i), AutorunConfig.ExtractRawRecording.FileType, AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j), AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "TF")
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
% 4.2 Prepro event related data
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'PreproEventDataModule') && isfield(Data,'EventRelatedData')
    %% Trial Rejection
    if AutorunConfig.PreproEventDataModule.TrialRejection == true
    
        EventRelatedDataTimeRange = [];
        Data.Info.EventRelatedTime = [];
    
        spaceindicie = find(Data.Info.EventRelatedDataTimeRange == ' ');
        EventRelatedDataTimeRange(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie));
        EventRelatedDataTimeRange(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie+1:end));
        
        if strcmp(AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,'Raw Data')
            Data.Info.EventRelatedTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
        else
            if isfield(Data.Info,"DownsampleFactor")
                Data.Info.EventRelatedTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.DownsampledSampleRate:EventRelatedDataTimeRange(2);
            else
                Data.Info.EventRelatedTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
            end
        end
    
        if ~isempty(Data.Info.EventRelatedTime)
            if isfield(Data,'PreprocessedEventRelatedData')
                [EventRelatedData,Error,~] = Preprocessing_Events_Plot_and_Apply_Trial_Rejection(Data,Data.PreprocessedEventRelatedData,Data.Info.EventRelatedTime,'OnlyReject',[],[],1:size(Data.Raw,1),AutorunConfig.PreproEventDataModule.TrialsToReject);
            else
                [EventRelatedData,Error,~] = Preprocessing_Events_Plot_and_Apply_Trial_Rejection(Data,Data.EventRelatedData,Data.Info.EventRelatedTime,'OnlyReject',[],[],1:size(Data.Raw,1),AutorunConfig.PreproEventDataModule.TrialsToReject);
            end

            if Error == 0
                Data.PreprocessedEventRelatedData = EventRelatedData;
                CommaTest = find(AutorunConfig.PreproEventDataModule.TrialsToReject == ',');
                Trials(1,1) = str2double(AutorunConfig.PreproEventDataModule.TrialsToReject(1:CommaTest(1)-1));
                Trials(1,2) = str2double(AutorunConfig.PreproEventDataModule.TrialsToReject(CommaTest+1:end));
                if isfield(Data,'PreprocessedEventRelatedData')
                    Channel = [1,size(Data.PreprocessedEventRelatedData,1)];
                else
                    Channel = [1,size(Data.EventRelatedData,1)];
                end
                [Data] = Preprocessing_Events_Add_Preprocessing_Info(Data,'Trial Rejection',Channel,Trials,[]);
            
                disp("Rejection of selected trials succesfull.");
            else
                disp("Trial Rejection was not possible. No valid event time window.");
            end
        elseif isempty(Data.Info.EventRelatedTime) 
           disp("Trial Rejection was not possible. No valid event time window.");
        end
    end

    %% Channel Rejection
    if AutorunConfig.PreproEventDataModule.ChannelRejection == true

        RejectChannel = AutorunConfig.PreproEventDataModule.ChannelToReject;
    
        EventRelatedDataTimeRange = [];
        Data.Info.EventRelatedTime = [];

        spaceindicie = find(Data.Info.EventRelatedDataTimeRange == ' ');
        EventRelatedDataTimeRange(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie));
        EventRelatedDataTimeRange(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie+1:end));

        if strcmp(AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom,'Raw Data')
            Data.Info.EventRelatedTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
        else
            if isfield(Data.Info,"DownsampleFactor")
                Data.Info.EventRelatedTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.DownsampledSampleRate:EventRelatedDataTimeRange(2);
            else
                Data.Info.EventRelatedTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
            end
        end
        
        RejectChannel = RejectChannel(1):RejectChannel(2);

        if isfield(Data,'PreprocessedEventRelatedData')
            [Data.PreprocessedEventRelatedData] = Preprocessing_Events_Channel_Rejection(Data,Data.PreprocessedEventRelatedData,Data.Info.EventRelatedTime,RejectChannel,Data.Info.ChannelSpacing,[],"InterpolatedOnly",Data.Info.ProbeInfo.ActiveChannel);
        else
            [Data.PreprocessedEventRelatedData] = Preprocessing_Events_Channel_Rejection(Data,Data.EventRelatedData,Data.Info.EventRelatedTime,RejectChannel,Data.Info.ChannelSpacing,[],"InterpolatedOnly",Data.Info.ProbeInfo.ActiveChannel);
        end
    
        Trials = [1,size(Data.PreprocessedEventRelatedData,2)];
        
        [Data] = Preprocessing_Events_Add_Preprocessing_Info(Data,'Channel Rejection',RejectChannel,Trials,[]);
    
    end
else
    if strcmp(FunctionOrder,'PreproEventDataModule')
        warning("No event ralted data found. Skipping preprocessing of event related data.");
    end
end
%______________________________________________________________________________________________________
% 4.3 Event Related Spike Analysis
%______________________________________________________________________________________________________

if isfield(Data,'Events') && isfield(Data,'EventRelatedData')
    if strcmp(FunctionOrder,'Event_Spike_Analysis')

        DepthChannel = AutorunConfig.AnalyseEventSpikesModule.ChanneltoPlot;
        
        if ~isfield(Data,'Spikes')
        
            msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Kilosort") || isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"SpikeInterface")   
        
            % Handle Events to show
            if isempty(AutorunConfig.EventRange)
                Events = strcat('1,',num2str(size(Data.EventRelatedData,2)));
            else
                Events = AutorunConfig.EventRange;
            end
            % Handle Channel to show
            if isempty(AutorunConfig.AnalyseEventDataModule.ChannelSelection)
                ChannelSelection = strcat('1,',num2str(size(Data.EventRelatedData,1)));
            else
                ChannelSelection = AutorunConfig.AnalyseEventSpikesModule.ChanneltoPlot;
            end

            BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;

            numCluster = numel(unique(Data.Spikes.SpikeCluster));
            rgbMatrix = lines(numCluster);

            UnitsToPlot.Value = AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot;

            if isempty(UnitsToPlot.Value)
                TotalIterations = 1;
            else
                TotalIterations = 2;
            end

            SpkTrgSpikes = 2;

            [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',0);

            for TotalIts = 1:TotalIterations % 2 if unit plots

                if TotalIts == 1 % if no unit plot
                    UnitIterations = 1;
                    ClusterToPlot = AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions;
                else % if unit plot
                    UnitIterations = length(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot);
                    ClusterToPlot = AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot;
                end
                % loop over analysis types
                for i = 1:length(AutorunConfig.AnalyseEventSpikesModule.Plottype)
                    
                    if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average") && SpkTrgSpikes == 0
                        [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',1);
                        SpkTrgSpikes = 1;
                    elseif ~strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average") && SpkTrgSpikes == 1
                        [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',0);
                        SpkTrgSpikes = 0;
                    end
                    
                    % loop over units
                    for nunits = 1:UnitIterations
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

                        SpikeAnalysisFigure = figure();
                        UIAxes = subplot(2,2,1);
                        UIAxes_2 = subplot(2,2,2);
                        UIAxes_3 = subplot(2,2,3);
                        UIAxes.NextPlot = "add";
                        
                        BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;
        
                        TextArea = [];
    
                        [TempData,~,~,~,AutorunConfig.CurrentPlotData] = Events_Kilosort_Spikes_Manage_Analysis_Plots(Data,Events,UIAxes,AutorunConfig.AnalyseEventSpikesModule.Plottype(i),AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,TextArea,rgbMatrix,numCluster,CurrentClusterToPlot.Value,ChannelSelection,BaselineWindow,AutorunConfig.AnalyseEventSpikesModule.Normalize,AutorunConfig.AnalyseEventSpikesModule.TimeSpikeTriggeredAverage,UIAxes_3,UIAxes_2,AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings,AutorunConfig.PlotAppearance,DepthChannel);
         
                        if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered LFP") || strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average")
                            if ~isempty(TempData)
                                Data = TempData;
                            end
                        else
                            %Data = TempData;
                        end
    
                        %% Properly set up plot for saving (x axis ticks/labels and stuff like that)
                        if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
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

                        if TotalIterations > 1 && TotalIts == 2
                            %% Plot Results if turned on
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,strcat(" Event Spikes Unit ",num2str(nunits)," "), DataPath,AutorunConfig.AnalyseEventSpikesModule.Plottype(i) , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventIteration")
                            end
                        elseif TotalIterations > 1 && TotalIts == 1
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.AnalyseEventSpikesModule.Plottype(i), DataPath, " Event Spikes " , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventSpikes")
                            end
                        else
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.AnalyseEventSpikesModule.Plottype(i), DataPath, " Event Spikes " , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventSpikes")
                            end
                        end

                    end
                end%Plottpes
            end
           
        
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
           
            %if Error == 0
                % Handle Events to show
                if isempty(AutorunConfig.EventRange)
                    Events = strcat('1,',num2str(size(Data.EventRelatedData,2)));
                else
                    Events = AutorunConfig.EventRange;
                end
                % Handle Channel to show
                if isempty(AutorunConfig.AnalyseEventDataModule.ChannelSelection)
                    ChannelSelection = strcat('1,',num2str(size(Data.EventRelatedData,1)));
                else
                    ChannelSelection = AutorunConfig.AnalyseEventSpikesModule.ChanneltoPlot;
                end
    
                BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;

                if isfield(Data.Info,'Sorter')
                    if strcmp(Data.Info.Sorter,'WaveClus')
                        if ~isempty(Data.Spikes.Waveforms)
                            % Exatract number of spike clusters Kilosort found
                            numCluster = numel(unique(Data.Spikes.SpikeCluster));
                            % Define unique color for each cluster
                            rgbMatrix = lines(numCluster);
                        end
                    else
                        if strcmp(AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions,"All") % When no cluster present
                            AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions = "Non";
                        end
                        
                        numCluster = 1;
                        % Define unique color for each cluster
                        rgbMatrix = lines(1);
                    end
                else
                    if strcmp(AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions,"All") % When no cluster present
                        AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions = "Non";
                    end
                    
                    numCluster = 1;
                    % Define unique color for each cluster
                    rgbMatrix = lines(1);
                end

                UnitsToPlot.Value = AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot;
    
                if isempty(UnitsToPlot.Value)
                    TotalIterations = 1;
                else
                    if isfield(Data.Info,'Sorter')
                        if ~strcmp(Data.Info.Sorter,'WaveClus')
                            TotalIterations = 1;
                            disp("Unit plots selected, but no spike sorting found. Unit plots are not executed.")
                        else
                            TotalIterations = 2;
                        end
                    else
                        TotalIterations = 1;
                        disp("Unit plots selected, but no spike sorting found. Unit plots are not executed.")
                    end
                end

                SpkTrgSpikes = 2;

                [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',0);
                
                for TotalIts = 1:TotalIterations % 2 if unit plots

                    if TotalIts == 1 % if no unit plot
                        UnitIterations = 1;
                        ClusterToPlot = AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions;
                    else % if unit plot
                        UnitIterations = length(AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot);
                        ClusterToPlot = AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot;
                    end

                    % Loop over multiple analysis plots
                    for i = 1:length(AutorunConfig.AnalyseEventSpikesModule.Plottype)

                        if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average") && SpkTrgSpikes == 0
                            [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',1);
                            SpkTrgSpikes = 1;
                        elseif ~strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average") && SpkTrgSpikes == 1
                            [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',0);
                            SpkTrgSpikes = 0;
                        end

                        for nunits = 1:UnitIterations
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
                            % Loop over multiple analysis plots
                            SpikeAnalysisFigure = figure();
                            UIAxes = subplot(2,2,1);
                            UIAxes_2 = subplot(2,2,2);
                            UIAxes_3 = subplot(2,2,3);
                            UIAxes.NextPlot = "add";
            
                            BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;
            
                            %% Prepare Analysis
                            TextArea = [];
                            [TempData,~,~,~,AutorunConfig.CurrentPlotData] = Events_Internal_Spikes_Manage_Analysis_Plots(Data,Events,UIAxes,AutorunConfig.AnalyseEventSpikesModule.Plottype(i),AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,TextArea,rgbMatrix,ChannelSelection,BaselineWindow,AutorunConfig.AnalyseEventSpikesModule.Normalize,AutorunConfig.AnalyseEventSpikesModule.TimeSpikeTriggeredAverage,UIAxes_3,UIAxes_2,AutorunConfig.twoORthree_D_Plotting,CurrentClusterToPlot.Value,numCluster,AutorunConfig.CurrentPlotData,AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings,AutorunConfig.PlotAppearance,DepthChannel);
                    
                            if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered LFP") || strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered Average")
                                if ~isempty(TempData)
                                    Data = TempData;
                                end
                            else
                                %Data = TempData;
                            end
            
                            if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                                [~] = Execute_Autorun_Set_Up_Figure(UIAxes,0,"Left Axis Only",[],[],"Time [s]",[],[],8);
                            end
            
                            %% Properly set up plot for saving (x axis ticks/labels and stuff like that)
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
                            
                            if TotalIterations > 1
                                %% Plot Results if turned on
                                if strcmp(AutorunConfig.SaveFigures,"on")
                                    Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat(" Internal Event Spikes Unit ",num2str(nunits)," ") , DataPath,AutorunConfig.AnalyseEventSpikesModule.Plottype(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "InternalEventIteration")
                                end
                            else
                                if strcmp(AutorunConfig.SaveFigures,"on")
                                    Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, AutorunConfig.AnalyseEventSpikesModule.Plottype(i) , DataPath," Internal Event Spikes " , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "InternalEventSpikes")
                                end
                            end
                        end% for nunits
        
                    end %Spike analysis Type

                end % total iterations
            %end
        end
    end
else % if isfield(Data,'Events')
    if strcmp(FunctionOrder,'Event_Spike_Analysis')
        warning("No Events found, skipping step.");
        msgbox("No Events found, skipping step.");
    end
end

if strcmp(FunctionOrder,'Event_Unit_Analysis') && isfield(Data,'EventRelatedData')
    Execute = 1;

    if ~isfield(Data,'Spikes')
        disp("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data, skipping step");
        Execute = 0;
    else
        if strcmp(Data.Info.SpikeType,"Internal")
            if isfield(Data.Info,'Sorter')
                if ~strcmp(Data.Info.Sorter,'WaveClus')
                    disp("Warning: No spike clustering found for internal spikes, skipping step.");
                    Execute = 0;
                end
            else
                disp("Warning: No spike clustering found for internal spikes, skipping step.");
                Execute = 0;
            end
        end
    end

    if Execute == 1
        UnitAnalysisFigure = figure();
        UIAxes_1 = subplot(3,3,1);
        UIAxes_2 = subplot(3,3,2);
        UIAxes_3 = subplot(3,3,3);
        UIAxes_4 = subplot(3,3,4);
        UIAxes_5 = subplot(3,3,5);
        UIAxes_6 = subplot(3,3,6);
        UIAxes_7 = subplot(3,3,7);
        UIAxes_8 = subplot(3,3,8);
        UIAxes_9 = subplot(3,3,9);

        UIAxes_1.NextPlot = "add";
        UIAxes_2.NextPlot = "add";
        UIAxes_3.NextPlot = "add";
        UIAxes_4.NextPlot = "add";
        UIAxes_5.NextPlot = "add";
        UIAxes_6.NextPlot = "add";
        UIAxes_7.NextPlot = "add";
        UIAxes_8.NextPlot = "add";
        UIAxes_9.NextPlot = "add";
        
        if strcmp(Data.Info.SpikeType,"Internal")
            [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Internal",0);
        elseif strcmp(Data.Info.SpikeType,"Kilosort") || strcmp(Data.Info.SpikeType,"SpikeInterface") 
            [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Kilosort",0);
        end
        
        if Error == 0
            [Units,Waves,Wavefigs,ISIfigs,AutoCfigs,SpikeTimes,SpikePositions,SpikeCluster,SpikeWaveforms,SpikeChannel,AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram] = Spike_Module_Prepare_WaveForm_Window_and_Analysis(Data,AutorunConfig.EventUnitAnalysis.UnitsPlot1,AutorunConfig.EventUnitAnalysis.UnitsPlot2,AutorunConfig.EventUnitAnalysis.UnitsPlot3,AutorunConfig.EventUnitAnalysis.NumberWaveformsPlot1,AutorunConfig.EventUnitAnalysis.NumberWaveformsPlot2,AutorunConfig.EventUnitAnalysis.NumberWaveformsPlot3,UIAxes_1,UIAxes_2,UIAxes_3,UIAxes_4,UIAxes_5,UIAxes_6,UIAxes_7,UIAxes_8,UIAxes_9,"StartUp","EventWindow",AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram);
    
            %% Plot Waveforms
            
            Spike_Waveforms_Plot_Waveforms(Data,Units,SpikeWaveforms,SpikeCluster,Waves,Wavefigs);
    
            %% Plot ISI
            
            Spike_Module_Calculate_Plot_ISI(Data,SpikeTimes,SpikePositions,SpikeCluster,SpikeChannel,Units,Waves,ISIfigs,str2double(AutorunConfig.EventUnitAnalysis.NumBins),str2double(AutorunConfig.EventUnitAnalysis.MaxTImeISI));
      
            %% Plot Autocorrelogramme
    
            Spikes_Module_AutoCorrelogram(Data,SpikeTimes,SpikePositions,SpikeChannel,SpikeCluster,AutoCfigs,Units,str2double(AutorunConfig.EventUnitAnalysis.NumBins),[],str2double(AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram));
    
            %% Plot Results if turned on
            if strcmp(AutorunConfig.SaveFigures,"on")
                if strcmp(Data.Info.SpikeType,"Internal")
                    Execute_Autorun_Save_Figure(UnitAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat("Internal Spikes Event Unit Analysis"), DataPath, " ", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ContWaveforms");
                else
                    Execute_Autorun_Save_Figure(UnitAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat("Kilosort Spikes Event Unit Analysis"), DataPath, " ", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ContWaveforms");
                end
            end
        end
    end
else
    if strcmp(FunctionOrder,'Event_Unit_Analysis')
        warning("No event ralted data found. Skipping unit analysis");
    end
end