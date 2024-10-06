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
    %% Function to determine which event channel area vailable in folder based on names of folder components

    [EventInfo,FileEndingsExist,FilePaths,texttoshow,Info] = Extract_Events_Module_Determine_Available_EventChannel(Data,DataPath,AutorunConfig.ExtractEventDataModule.ChannelOfInterest);
    
    % Split the string based on the delimiter ','
    IndividualStrings = strsplit(AutorunConfig.ExtractEventDataModule.EventChannelSelection, ',');
    
    % Convert the cell array of strings to a numeric vector
    InputChannelSelection = str2double(IndividualStrings);
    
    ExtractedRHDEventsFlag = 0;
    TextArea = [];
    RHDAllChannelData = [];

    %% Start Event Extraction
    [Data,~,~,~] = Extract_Events_Module_Main_Function(Data,EventInfo,DataPath,Data.Info.RecordingType,AutorunConfig.ExtractEventDataModule.ChannelOfInterest,AutorunConfig.ExtractEventDataModule.EventSignalThreshold,InputChannelSelection,ExtractedRHDEventsFlag,TextArea,RHDAllChannelData,executableFolder);

    if isfield(Data,'Events')
        if ~isempty(Data.Events)
            disp("Successfully extracted Events.");
        else
            disp("No Events could be extracted.");
            msgbox("No Events could be extracted.");
        end
    end
end

%______________________________________________________________________________________________________
% 4.1 Extract EventRelated Data
%______________________________________________________________________________________________________
if isfield(Data,'Events')
    if ~isempty(Data.Events)
        if strcmp(FunctionOrder,'Extract_Event_Related_Data')
            if isempty(AutorunConfig.ExtractEventRelatedDataModule.EventChanneltoUse)
                AutorunConfig.ExtractEventRelatedDataModule.EventChanneltoUse = Data.Info.EventChannelNames{1};
            end
        
            [Data,TimearoundEvent] = Event_Module_Extract_Event_Related_Data(Data,AutorunConfig.ExtractEventRelatedDataModule.EventChanneltoUse,AutorunConfig.ExtractEventRelatedDataModule.TimeBeforeEvent,AutorunConfig.ExtractEventRelatedDataModule.TimeAfterEvent,AutorunConfig.ExtractEventRelatedDataModule.DataSource);
            
            if isfield(Data,'EventRelatedData') 
                if ~isempty(Data.EventRelatedData)
                     disp("Success. Event related data can now be analysed.");
                else
                    disp("No Event Related Data extracted");
                end
            end
        end
    else
        disp("No Events found, skipping step.");
        msgbox("No Events found, skipping step.");
    end
else % if isfield(Data,'Events')
    disp("No Events found, skipping step.");
    msgbox("No Events found, skipping step.");
end
%______________________________________________________________________________________________________
% 4.1 Event Related Signal Analysis
%______________________________________________________________________________________________________

if isfield(Data,'Events')
    %% ERP
    if strcmp(FunctionOrder,'Event_Analysis_ERP') || strcmp(FunctionOrder,'Event_Analysis_CSD') || strcmp(FunctionOrder,'Event_Analysis_TimeFrequencyPower')
        tempcolorMapset = eval(strcat(AutorunConfig.AnalyseEventDataModule.tempcolorMap,"(size(Data.Raw,1))")); % Example colormap: You can use any other colormap
        
        spaceindicie = strfind(Data.Info.EventRelatedDataTimeRange," ");
        TimearoundEvent(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
        TimearoundEvent(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));
        
        if strcmp(Data.Info.EventRelatedDataType,"Preprocessed") && isfield(Data.Info,'DownsampledSampleRate')
            EventTime = 0-TimearoundEvent(1):1/Data.Info.DownsampledSampleRate:TimearoundEvent(2);
        else
            EventTime = 0-TimearoundEvent(1):1/Data.Info.NativeSamplingRate:TimearoundEvent(2);
        end
    
        % Handle Events to show
        if isempty(AutorunConfig.AnalyseEventDataModule.EventSelection)
            TempEventSelection = strcat('1,',num2str(size(Data.EventRelatedData,2)));
        else
            TempEventSelection = AutorunConfig.AnalyseEventDataModule.EventSelection;
        end
    
        commaindicie = strfind(TempEventSelection,',');
        AutorunConfig.AnalyseEventDataModule.EventSelection(1) = str2double(TempEventSelection(1:commaindicie-1));
        AutorunConfig.AnalyseEventDataModule.EventSelection(2) = str2double(TempEventSelection(commaindicie+1:end));
    
        % Handle Channel to show
        if isempty(AutorunConfig.AnalyseEventDataModule.ChannelSelection)
            TempChannel = strcat('1,',num2str(size(Data.EventRelatedData,1)));
        else
            TempChannel = AutorunConfig.AnalyseEventDataModule.ChannelSelection;
        end
    
        commaindicie = strfind(TempChannel,',');
        AutorunConfig.AnalyseEventDataModule.ChannelSelection(1) = str2double(TempChannel(1:commaindicie-1));
        AutorunConfig.AnalyseEventDataModule.ChannelSelection(2) = str2double(TempChannel(commaindicie+1:end));
    
        % ERP
        if strcmp(FunctionOrder,'Event_Analysis_ERP')
           
            ERPFigure = figure();
            UIAxes = subplot(2,1,1);
            UIAxes_2 = subplot(2,1,2);
            UIAxes.NextPlot = "add";
            
            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,'Raw Event Related Data')
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,UIAxes_2,Data.EventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All',AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance);
            else
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,UIAxes_2,Data.PreprocessedEventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All',AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance);
            end
    
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
            
            CSD.ChannelSpacing = AutorunConfig.AnalyseEventDataModule.CSDChannelSpacing;
            CSD.HammWindow = str2double(AutorunConfig.AnalyseEventDataModule.CSDHammWindow);
            CSD.SurfaceChannel = str2double(AutorunConfig.AnalyseEventDataModule.CSDSurfaceChannel);
    
            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,'Raw Event Related Data')
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,[],Data.EventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,CSD,[],[],[],AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance);
            else
                Event_Module_Compute_and_Plot_ERP_CSD(Data,UIAxes,[],Data.PreprocessedEventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,CSD,[],[],[],AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance);
            end
    
            %% Plot Results if turned on
            if strcmp(AutorunConfig.SaveFigures,"on")
                Execute_Autorun_Save_Figure(CSDFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Event_Related_Current_Source_Density", DataPath, "CSD", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "CSD")
            end
    
        end
    
        if strcmp(FunctionOrder,'Event_Analysis_TimeFrequencyPower')
            for i = 1:length(AutorunConfig.AnalyseEventDataModule.TFPlotType)
                for j = 1:length(AutorunConfig.AnalyseEventDataModule.TFPlotAddons)
        
                    TFFigure = figure();
                    UIAxes = axes;
                    UIAxes.NextPlot = "add";
        
                    ChannelSelection = strcat(num2str(AutorunConfig.AnalyseEventDataModule.ChannelSelection(1)),',',num2str(AutorunConfig.AnalyseEventDataModule.ChannelSelection(2)));
                    EventSelection = strcat(num2str(AutorunConfig.AnalyseEventDataModule.EventSelection(1)),',',num2str(AutorunConfig.AnalyseEventDataModule.EventSelection(2)));
                    
                    [~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(Data,"Moorlet Wavelets",ChannelSelection,EventSelection,AutorunConfig.AnalyseEventDataModule.TFFrequencyRange,AutorunConfig.AnalyseEventDataModule.TFCycleWidth,[],[]);
            
                    if strcmp(Data.Info.EventRelatedDataType,'Raw')
                        [~,~,~,~,~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(app,"TF",Data.Info.NativeSamplingRate,TimearoundEvent);
                        if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Raw Event Data")
                            Event_Module_Time_Frequency_Main(Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                        elseif strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Preprocessed Event Data")
                            Event_Module_Time_Frequency_Main(Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                        end
                    else
                        if isfield(Data.Info,"DownsampleFactor")
                            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Raw Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.EventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            elseif strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Preprocessed Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.PreprocessedEventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            end
                        else
                            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Raw Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            elseif strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Preprocessed Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets",AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.PlotAppearance)
                            end
                        end
                    end
    
                    %% Plot Results if turned on
                    if strcmp(AutorunConfig.SaveFigures,"on")
                        Execute_Autorun_Save_Figure(TFFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "_Time_Frequency_Power", DataPath, AutorunConfig.AnalyseEventDataModule.TFPlotType(i), AutorunConfig.ExtractRawRecording.FileType, AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j), AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "TF")
                    end
                end
            end
        end
    end

else % if isfield(Data,'Events')
    disp("No Events found, skipping step.");
    msgbox("No Events found, skipping step.");
end

%______________________________________________________________________________________________________
% 4.2 Prepro event related data
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'PreproEventDataModule')
    % First Trial Rejection
    if AutorunConfig.PreproEventDataModule.TrialRejection == true
    
        EventRelatedDataTimeRange = [];
        EventTime = [];
    
        spaceindicie = find(Data.Info.EventRelatedDataTimeRange == ' ');
        EventRelatedDataTimeRange(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie));
        EventRelatedDataTimeRange(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie+1:end));
        
        if strcmp(Data.Info.EventRelatedDataType,'Raw')
            EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
        else
            if isfield(Data.Info,"DownsampleFactor")
                EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.DownsampledSampleRate:EventRelatedDataTimeRange(2);
            else
                EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
            end
        end
    
        if ~isempty(EventTime)
            if isfield(Data,'PreprocessedEventRelatedData')
                [EventRelatedData,Error,~] = Preprocessing_Events_Plot_and_Apply_Trial_Rejection(Data.PreprocessedEventRelatedData,EventTime,'OnlyReject',[],[],[],AutorunConfig.PreproEventDataModule.TrialsToReject);
            else
                [EventRelatedData,Error,~] = Preprocessing_Events_Plot_and_Apply_Trial_Rejection(Data.EventRelatedData,EventTime,'OnlyReject',[],[],[],AutorunConfig.PreproEventDataModule.TrialsToReject);
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
        elseif isempty(EventTime) 
           disp("Trial Rejection was not possible. No valid event time window.");
        end
    end
    % Channel Rejection
    if AutorunConfig.PreproEventDataModule.ChannelRejection == true
        indicesep = find(AutorunConfig.PreproEventDataModule.ChannelToReject == ',');
        RejectChannel(1,1) = str2double(AutorunConfig.PreproEventDataModule.ChannelToReject(1:indicesep(1)-1));
        RejectChannel(1,2) = str2double(AutorunConfig.PreproEventDataModule.ChannelToReject(indicesep+1:end));
    
        EventTime = [];
        if strcmp(Data.Info.EventRelatedDataType,'Raw')
            EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
        else
            if isfield(Data.Info,"DownsampleFactor")
                EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.DownsampledSampleRate:EventRelatedDataTimeRange(2);
            else
                EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
            end
        end

        if isfield(Data,'PreprocessedEventRelatedData')
            [Data.PreprocessedEventRelatedData] = Preprocessing_Events_Channel_Rejection(Data.PreprocessedEventRelatedData,EventTime,RejectChannel,[],[],"InterpolatedOnly");
        else
            [Data.PreprocessedEventRelatedData] = Preprocessing_Events_Channel_Rejection(Data.EventRelatedData,EventTime,RejectChannel,[],[],"InterpolatedOnly");
        end
    
        Trials = [1,size(Data.PreprocessedEventRelatedData,2)];
        
        [Data] = Preprocessing_Events_Add_Preprocessing_Info(Data,'Channel Rejection',RejectChannel,Trials,[]);
    
    end
    % Artefact Rejection
    if AutorunConfig.PreproEventDataModule.ArtefactRejection == true
        if isempty(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject)
            if isfield(Data,'PreprocessedEventRelatedData')
                AutorunConfig.PreproEventDataModule.ArtefactChannelToReject = strcat('1,',num2str(size(Data.PreprocessedEventRelatedData,1)));
            else
                AutorunConfig.PreproEventDataModule.ArtefactChannelToReject = strcat('1,',num2str(size(Data.EventRelatedData,1)));
            end
        end
    
        if isempty(AutorunConfig.PreproEventDataModule.EventsToReject)
            if isfield(Data,'PreprocessedEventRelatedData')
                AutorunConfig.PreproEventDataModule.EventsToReject = strcat('1,',num2str(size(Data.PreprocessedEventRelatedData,2)));
            else
                AutorunConfig.PreproEventDataModule.EventsToReject = strcat('1,',num2str(size(Data.EventRelatedData,2)));
            end
        end

        EventTime = [];
        if strcmp(Data.Info.EventRelatedDataType,'Raw')
            EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
        else
            if isfield(Data.Info,"DownsampleFactor")
                EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.DownsampledSampleRate:EventRelatedDataTimeRange(2);
            else
                EventTime = 0-EventRelatedDataTimeRange(1):1/Data.Info.NativeSamplingRate:EventRelatedDataTimeRange(2);
            end
        end
    
        % Apply rejection
        %% Get Timewindow and trial information from GUI
        if isempty(AutorunConfig.PreproEventDataModule.TimeWindowAroundEvent)
            TimeWindin(1,1) = app.EventTime(floor(length(app.EventTime)/3));
            TimeWindin(1,2) = app.EventTime(floor(length(app.EventTime)/3)*2);
        else
            indicesep = find(AutorunConfig.PreproEventDataModule.TimeWindowAroundEvent == ',');
            TimeWindin(1,1) = str2double(AutorunConfig.PreproEventDataModule.TimeWindowAroundEvent(1:indicesep(1)-1));
            TimeWindin(1,2) = str2double(AutorunConfig.PreproEventDataModule.TimeWindowAroundEvent(indicesep+1:end));
        end
    
        %Channel
        indicesep = find(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject == ',');
        Channel(1,1) = str2double(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(1:indicesep(1)-1));
        Channel(1,2) = str2double(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(indicesep+1:end));
        if Channel(1,2) > size(Data.EventRelatedData,1)
            msgbox("Last channel bigger than channel number. Autosetting to all channel");
            Channel(1,2) = size(Data.EventRelatedData,1);
            AutorunConfig.PreproEventDataModule.ArtefactChannelToReject = strcat("1,",num2str(size(Data.EventRelatedData,1)));
        end
    
        indicesep = find(AutorunConfig.PreproEventDataModule.EventsToReject == ',');
        Trials(1,1) = str2double(AutorunConfig.PreproEventDataModule.EventsToReject(1:indicesep(1)-1));
        Trials(1,2) = str2double(AutorunConfig.PreproEventDataModule.EventsToReject(indicesep+1:end));
    
        %ChanneltoPlot = str2double(AutorunConfig.PreproEventDataModule.ChannelToReject);
        
        %% Extract Data and Plot
    
        if isfield(Data,'PreprocessedEventRelatedData')
            [Data.PreprocessedEventRelatedData,~,~] = Preprocessing_Events_Reject_and_Plot_Artefacts(Data.PreprocessedEventRelatedData,Channel,Trials,EventTime,TimeWindin,[],[],[],AutorunConfig.PreproEventDataModule.ArtefactChannelToReject,[],AutorunConfig.PreproEventDataModule.Method,'Interpolating',[],'No Plot');
        else
            [Data.PreprocessedEventRelatedData,~,~] = Preprocessing_Events_Reject_and_Plot_Artefacts(Data.EventRelatedData,Channel,Trials,EventTime,TimeWindin,[],[],[],AutorunConfig.PreproEventDataModule.ArtefactChannelToReject,[],AutorunConfig.PreproEventDataModule.Method,'Interpolating',[],'No Plot');
        end
    
        [Data] = Preprocessing_Events_Add_Preprocessing_Info(Data,'Artefact Rejection',Channel,Trials,TimeWindin);
    
    end
end
%______________________________________________________________________________________________________
% 4.3 Event Related Spike Analysis
%______________________________________________________________________________________________________

if isfield(Data,'Events')
    if strcmp(FunctionOrder,'Event_Spike_Analysis')
        if ~isfield(Data,'Spikes')
        
            msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Kilosort")
            
            [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Kilosort",0);         
        
            if Error == 0 
                % Handle Events to show
                if isempty(AutorunConfig.AnalyseEventDataModule.EventSelection)
                    Events = strcat('1,',num2str(size(Data.EventRelatedData,2)));
                else
                    Events = AutorunConfig.AnalyseEventSpikesModule.SelectedEvents;
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
        
                            [TempData,~,~,~,AutorunConfig.CurrentPlotData] = Events_Kilosort_Spikes_Manage_Analysis_Plots(Data,Events,UIAxes,AutorunConfig.AnalyseEventSpikesModule.Plottype(i),AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,TextArea,rgbMatrix,numCluster,CurrentClusterToPlot.Value,ChannelSelection,BaselineWindow,AutorunConfig.AnalyseEventSpikesModule.Normalize,AutorunConfig.AnalyseEventSpikesModule.TimeSpikeTriggeredAverage,UIAxes_3,UIAxes_2,AutorunConfig.twoORthree_D_Plotting,AutorunConfig.CurrentPlotData,AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings,AutorunConfig.PlotAppearance);
             
                            if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered LFP")
                                if ~isempty(TempData)
                                    Data = TempData;
                                end
                            else
                                Data = TempData;
                            end
        
                            %% Properly set up plot for saving (x axis ticks/labels and stuff like that)
                            if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                                [~] = Execute_Autorun_Set_Up_Figure(UIAxes,0,"Left Axis Only",[],[],"Time [s]",[],[],8);
                            end
            
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
                            
                            if UnitIterations > 1
                                %% Plot Results if turned on
                                if strcmp(AutorunConfig.SaveFigures,"on")
                                    Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,strcat(" Kilosort Event Spikes Unit ",num2str(nunits)," "), DataPath,AutorunConfig.AnalyseEventSpikesModule.Plottype(i) , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventIteration")
                                end
                            else
                                if strcmp(AutorunConfig.SaveFigures,"on")
                                    Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.AnalyseEventSpikesModule.Plottype(i), DataPath, " Kilosort Event Spikes " , AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventSpikes")
                                end
                            end

                        end
                    end%Plottpes
                end
            end
        
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
        
            [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Internal",0);
           
            if Error == 0
                % Handle Events to show
                if isempty(AutorunConfig.AnalyseEventDataModule.EventSelection)
                    Events = strcat('1,',num2str(size(Data.EventRelatedData,2)));
                else
                    Events = AutorunConfig.AnalyseEventSpikesModule.SelectedEvents;
                end
                % Handle Channel to show
                if isempty(AutorunConfig.AnalyseEventDataModule.ChannelSelection)
                    ChannelSelection = strcat('1,',num2str(size(Data.EventRelatedData,1)));
                else
                    ChannelSelection = AutorunConfig.AnalyseEventSpikesModule.ChanneltoPlot;
                end
    
                BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;

                if isfield(Data.Info,'SpikeSorting')
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

                UnitsToPlot.Value = AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot;
    
                if isempty(UnitsToPlot.Value)
                    TotalIterations = 1;
                else
                    if ~isfield(Data.Info,'SpikeSorting')
                        TotalIterations = 1;
                        disp("Unit plots selected, but no spike sorting found. Unit plots are not executed.")
                    else
                        TotalIterations = 2;
                    end
                end

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
                            [TempData,~,~,~,AutorunConfig.CurrentPlotData] = Events_Internal_Spikes_Manage_Analysis_Plots(Data,Events,UIAxes,AutorunConfig.AnalyseEventSpikesModule.Plottype(i),AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,TextArea,rgbMatrix,ChannelSelection,BaselineWindow,AutorunConfig.AnalyseEventSpikesModule.Normalize,AutorunConfig.AnalyseEventSpikesModule.TimeSpikeTriggeredAverage,UIAxes_3,UIAxes_2,AutorunConfig.twoORthree_D_Plotting,CurrentClusterToPlot.Value,numCluster,AutorunConfig.CurrentPlotData,AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings,AutorunConfig.PlotAppearance);
                    
                            if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Triggered LFP")
                                if ~isempty(TempData)
                                    Data = TempData;
                                end
                            else
                                Data = TempData;
                            end
            
                            if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                                [~] = Execute_Autorun_Set_Up_Figure(UIAxes,0,"Left Axis Only",[],[],"Time [s]",[],[],8);
                            end
            
                            %% Properly set up plot for saving (x axis ticks/labels and stuff like that)
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
                            
                            
                            if UnitIterations > 1
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
            end
        end
    end
else % if isfield(Data,'Events')
    disp("No Events found, skipping step.");
    msgbox("No Events found, skipping step.");
end

if strcmp(FunctionOrder,'Event_Unit_Analysis')
    Execute = 1;

    if ~isfield(Data,'Spikes')
        disp("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data, skipping step");
        Execute = 0;
    else
        if strcmp(Data.Info.SpikeType,"Internal")
            if ~isfield(Data.Info,'SpikeSorting')
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
        elseif strcmp(Data.Info.SpikeType,"Kilosort")
            [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Kilosort",0);
        end
        
        if Error == 0
            [Units,Waves,Wavefigs,ISIfigs,AutoCfigs,SpikeTimes,SpikePositions,SpikeCluster,SpikeWaveforms,SpikeChannel,AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram] = Spike_Module_Prepare_WaveForm_Window_and_Analysis(Data,AutorunConfig.EventUnitAnalysis.UnitsPlot1,AutorunConfig.EventUnitAnalysis.UnitsPlot2,AutorunConfig.EventUnitAnalysis.UnitsPlot3,AutorunConfig.EventUnitAnalysis.NumberWaveformsPlot1,AutorunConfig.EventUnitAnalysis.NumberWaveformsPlot2,AutorunConfig.EventUnitAnalysis.NumberWaveformsPlot3,UIAxes_1,UIAxes_2,UIAxes_3,UIAxes_4,UIAxes_5,UIAxes_6,UIAxes_7,UIAxes_8,UIAxes_9,"StartUp","EventWindow",AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram);
    
            %% Plot Waveforms
            
            Spike_Waveforms_Plot_Waveforms(Data,Units,SpikeWaveforms,SpikeCluster,Waves,Wavefigs);
    
            %% Plot ISI
            
            Spike_Module_Calculate_Plot_ISI(Data,SpikeTimes,SpikePositions,SpikeCluster,SpikeChannel,Units,Waves,ISIfigs,str2double(AutorunConfig.EventUnitAnalysis.NumBins),str2double(AutorunConfig.EventUnitAnalysis.MaxTImeISI));
      
            %% Plot Autocorrelogramme
    
            Spikes_Module_AutoCorrelogram(Data,SpikeTimes,SpikePositions,SpikeChannel,SpikeCluster,AutoCfigs,Units,str2double(AutorunConfig.EventUnitAnalysis.NumBins),str2double(AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram));
    
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
end