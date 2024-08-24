function [Data] = Execute_Autorun_Extract_Events_Module_Functions(AutorunConfig,FunctionOrder,Data,DataPath,LoadedData)

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
    [Data,~,~,~] = Extract_Events_Module_Main_Function(Data,EventInfo,DataPath,Data.Info.RecordingType,AutorunConfig.ExtractEventDataModule.ChannelOfInterest,AutorunConfig.ExtractEventDataModule.EventSignalThreshold,InputChannelSelection,ExtractedRHDEventsFlag,TextArea,RHDAllChannelData);

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
        TimearoundEvent(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie-1));
        TimearoundEvent(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie+1:end));
        
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
            
            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,'Raw Event Related Data')
                Event_Module_Compute_and_Plot_ERP_CSD(UIAxes,UIAxes_2,Data.EventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All');
            else
                Event_Module_Compute_and_Plot_ERP_CSD(UIAxes,UIAxes_2,Data.PreprocessedEventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,[],tempcolorMapset,str2double(AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots),'All');
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
    
            CSD.ChannelSpacing = AutorunConfig.AnalyseEventDataModule.CSDChannelSpacing;
            CSD.HammWindow = str2double(AutorunConfig.AnalyseEventDataModule.CSDHammWindow);
            CSD.SurfaceChannel = str2double(AutorunConfig.AnalyseEventDataModule.CSDSurfaceChannel);
    
            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,'Raw Event Related Data')
                [~] = Event_Module_Compute_and_Plot_ERP_CSD(UIAxes,[],Data.EventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,CSD);
            else
                [~] = Event_Module_Compute_and_Plot_ERP_CSD(UIAxes,[],Data.PreprocessedEventRelatedData(:,AutorunConfig.AnalyseEventDataModule.EventSelection(1):AutorunConfig.AnalyseEventDataModule.EventSelection(2),:),EventTime,AutorunConfig.AnalyseEventDataModule.ChannelSelection,CSD);
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
        
                    ChannelSelection = strcat(num2str(AutorunConfig.AnalyseEventDataModule.ChannelSelection(1)),',',num2str(AutorunConfig.AnalyseEventDataModule.ChannelSelection(2)));
                    EventSelection = strcat(num2str(AutorunConfig.AnalyseEventDataModule.EventSelection(1)),',',num2str(AutorunConfig.AnalyseEventDataModule.EventSelection(2)));
                    
                    [~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(Data,"Moorlet Wavelets",ChannelSelection,EventSelection,AutorunConfig.AnalyseEventDataModule.TFFrequencyRange,AutorunConfig.AnalyseEventDataModule.TFCycleWidth,[],[]);
            
                    if strcmp(Data.Info.EventRelatedDataType,'Raw')
                        [~,~,~,~,~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(app,"TF",Data.Info.NativeSamplingRate,TimearoundEvent);
                        if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Raw Event Data")
                            Event_Module_Time_Frequency_Main(Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets")
                        elseif strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Preprocessed Event Data")
                            Event_Module_Time_Frequency_Main(Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets")
                        end
                    else
                        if isfield(Data.Info,"DownsampleFactor")
                            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Raw Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.EventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets")
                            elseif strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Preprocessed Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.PreprocessedEventRelatedData,UIAxes,Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets")
                            end
                        else
                            if strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Raw Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.EventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets")
                            elseif strcmp(AutorunConfig.AnalyseEventDataModule.DataSource,"Preprocessed Event Related Data")
                                Event_Module_Time_Frequency_Main(Data.PreprocessedEventRelatedData,UIAxes,Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,TimearoundEvent,TF,AutorunConfig.AnalyseEventDataModule.TFPlotType(i),AutorunConfig.AnalyseEventDataModule.TFPlotAddons(j),"Moorlet Wavelets")
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
% 4.1 Event Related Spike Analysis
%______________________________________________________________________________________________________

if isfield(Data,'Events')
    if strcmp(FunctionOrder,'Event_Spike_Analysis')
        if ~isfield(Data,'Spikes')
        
            msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Kilosort")
            
            [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Kilosort");         
        
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
    
                numCluster = numel(unique(Data.EventRelatedSpikes.SpikeCluster));
                rgbMatrix = lines(numCluster);
    
                for i = 1:length(AutorunConfig.AnalyseEventSpikesModule.Plottype)
                    
                    SpikeAnalysisFigure = figure();
                    UIAxes = subplot(2,2,1);
                    UIAxes_2 = subplot(2,2,2);
                    UIAxes_3 = subplot(2,2,3);
                    
                    BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;
    
                    %% Prepare Analysis
                    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,~] = Event_Spikes_Prepare_Plots(Data,Events,ChannelSelection,BaselineWindow,AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,"Kilosort");
        
                    if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Map")
                        Spikes_Plot_Spike_Times("Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,UIAxes,numCluster,AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions,[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing)
                        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"Initial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions,AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,UIAxes_3,UIAxes_2,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
                    elseif strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Rate Heatmap")
                        Event_Spikes_Plot_Heatmap_Spike_Rate(SpikeTimes,SpikePositions,UIAxes,Data.Info.NativeSamplingRate,PlotInfo.time_bin_size,PlotInfo.depth_edges,PlotInfo.time_edges,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),0,BaselineWindow.Value,PlotInfo.NormWindow,AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions,SpikeCluster,rgbMatrix,PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,"Kilosort")
                        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"Initial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions,AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,UIAxes_3,UIAxes_2,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
                    end
    
                    %% Properly set up plot for saving (x axis ticks/labels and stuff like that)
                    if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes,0,"Left Axis Only",[],[],"Time [s]",[],[],8);
                    end
    
                    [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                    [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
    
                    %% Plot Results if turned on
                    if strcmp(AutorunConfig.SaveFigures,"on")
                        Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Event_Kilosort_", DataPath, AutorunConfig.AnalyseEventSpikesModule.Plottype(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortEventSpikes")
                    end
    
                end
            end
        
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
        
            [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Internal");
           
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
    
                rgbMatrix = lines(1);
    
                % Loop over multiple analysis plots
                for i = 1:length(AutorunConfig.AnalyseEventSpikesModule.Plottype)
                    % Loop over multiple analysis plots
                    SpikeAnalysisFigure = figure();
                    UIAxes = subplot(2,2,1);
                    UIAxes_2 = subplot(2,2,2);
                    UIAxes_3 = subplot(2,2,3);
    
                    BaselineWindow.Value = AutorunConfig.AnalyseEventSpikesModule.BaselineWindow;
    
                    %% Prepare Analysis
                    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,~,~,~,~] = Event_Spikes_Prepare_Plots(Data,Events,ChannelSelection,BaselineWindow,AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,"Internal");
        
                    if strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Map")
                        Spikes_Plot_Spike_Times("Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,UIAxes,[],"Non",[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing)
                        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"Initial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),"Non",AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,UIAxes_3,UIAxes_2,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
                    elseif strcmp(AutorunConfig.AnalyseEventSpikesModule.Plottype(i),"Spike Rate Heatmap")
                        Event_Spikes_Plot_Heatmap_Spike_Rate(SpikeTimes,SpikePositions,UIAxes,Data.Info.NativeSamplingRate,PlotInfo.time_bin_size,PlotInfo.depth_edges,PlotInfo.time_edges,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),0,BaselineWindow.Value,PlotInfo.NormWindow,"Non",SpikeCluster,rgbMatrix,PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,"Internal")
                        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"Initial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),"Non",AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins,UIAxes_3,UIAxes_2,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
                    end
    
                    if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes,0,"Left Axis Only",[],[],"Time [s]",[],[],8);
                    end
    
                    %% Properly set up plot for saving (x axis ticks/labels and stuff like that)
                    [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                    [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
                    
                    %% Plot if turned on
                    if strcmp(AutorunConfig.SaveFigures,"on")
                        Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Event_Internal", DataPath, AutorunConfig.AnalyseEventSpikesModule.Plottype(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "InternalEventSpikes")
                    end
    
                end
            end
        end
    end
else % if isfield(Data,'Events')
    disp("No Events found, skipping step.");
    msgbox("No Events found, skipping step.");
end