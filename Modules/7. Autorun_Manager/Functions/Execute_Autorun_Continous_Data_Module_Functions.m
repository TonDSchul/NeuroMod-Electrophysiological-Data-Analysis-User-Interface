function [Data] = Execute_Autorun_Continous_Data_Module_Functions (AutorunConfig,FunctionOrder,Data,DataPath,LoadedData)

%________________________________________________________________________________________
%% This is the main function to execute continous autorun data analysis 

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
%% 3. Continous Data Module
%______________________________________________________________________________________________________
% 3.1 Preprocessing Continous Data
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Preprocess_Continous_Data')
    PreproInfo = [];
    PreprocessingSteps = [];
    
    if ~isfield(Data,'Raw') && isfield(Data, 'Preprocessed')
        msgbox("Warning! No raw data found. Current preprocessed data is used as raw data, new preprocessing steps will be applied to it and be save as preprocessed data!");
        Data.Raw = Data.Preprocessed;
    end
    
    for i = 1:length(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr})
        [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr}(i),PreproInfo,PreprocessingSteps,0,AutorunConfig.PreprocessCont.FilterMethod{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.FilterType{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.CuttoffFrequency{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.FilterDirection{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.FilterOrder{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.DownsampleRate,Data.Info.NativeSamplingRate);
    end

    if isempty(PreprocessingSteps)
        msgbox("Error: No pipeline components added");
        return;
    end
        
    if isfield(PreproInfo,'ChannelDeletion')
        ChannelDeletion = PreproInfo.ChannelDeletion;
    else
        ChannelDeletion = [];
    end
    
    TextArea = [];

    [Data,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
    
    [Data] = Preprocess_Module_Apply_Pipeline (Data,Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea);
end

%______________________________________________________________________________________________________
% 3.2 Static Power Spectrum
%______________________________________________________________________________________________________

if strcmp(FunctionOrder,'Static_Power_Spectrum')
    for i = 1:length(AutorunConfig.StaticPowerSpectrum.PlotType)
        if strcmp(AutorunConfig.StaticPowerSpectrum.PlotType(i),"Band Power Individual Channel ")
            StaticPowerSpectrumfig = figure();
            StaticPowerSpectrumFigure = axes;

            Analyse_Main_Window_Static_Power_Spectrum(Data,StaticPowerSpectrumFigure,AutorunConfig.StaticPowerSpectrum.DataType,AutorunConfig.StaticPowerSpectrum.DataSource,str2double(AutorunConfig.StaticPowerSpectrum.Channel),num2str(AutorunConfig.StaticPowerSpectrum.Channel),AutorunConfig.StaticPowerSpectrum.FrequencyRangeBPDepth);
        
        elseif strcmp(AutorunConfig.StaticPowerSpectrum.PlotType(i),"Band Power over Depth")
            StaticPowerSpectrumfig = figure();
            UIAxes = subplot(1,2,1);
            UIAxes_2 = subplot(1,2,2);
            UIAxes.NextPlot = "add";

            TextArea = [];
            % Band Power over Depth
            if strcmp(AutorunConfig.StaticPowerSpectrum.DataSource,"Raw Data")
                nChansInFile = size(Data.Raw,1);  
                [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
                lfpBandPower([], Data.Info.NativeSamplingRate, nChansInFile, [], Data.Raw,TextArea);
            else
                nChansInFile = size(Data.Preprocessed,1);  
                if ~isfield(Data.Info,'DownsampleFactor')
                    [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
                    lfpBandPower([], Data.Info.NativeSamplingRate, nChansInFile, [], Data.Preprocessed,TextArea);
                else
                    [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
                    lfpBandPower([], Data.Info.DownsampledSampleRate, nChansInFile, [], Data.Preprocessed,TextArea);
                end
            end
                 
            % plot LFP power over specific bands
            BandPower.allPowerEst = BandPower.allPowerEst(:,1:nChansInFile)'; % now nChans x nFreq
            BandPower.marginalChans = 1;
            BandPower.freqBands = {[1.5 4], [4 10], [10 30], [30 80], [80 200]};
        
            commaindicie = find(AutorunConfig.StaticPowerSpectrum.FrequencyRangeBPDepth == ',');
            dispRange(1) = str2double(AutorunConfig.StaticPowerSpectrum.FrequencyRangeBPDepth(1:commaindicie(1)-1)); % Hz
            dispRange(2) = str2double(AutorunConfig.StaticPowerSpectrum.FrequencyRangeBPDepth(commaindicie(1)+1:end)); % Hz
        
            UIAxes_2.NextPlot = "add";
            plotLFPpower(BandPower.F, BandPower.allPowerEst, dispRange, BandPower.marginalChans, BandPower.freqBands, UIAxes, UIAxes_2, 'All',Data.Info.ChannelSpacing,AutorunConfig.twoORthree_D_Plotting);
          
        end
    
        %% Plot Results if turned on
        if strcmp(AutorunConfig.SaveFigures,"on")
            Execute_Autorun_Save_Figure(StaticPowerSpectrumfig, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Static Power Spectrum", DataPath, AutorunConfig.StaticPowerSpectrum.PlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "StaticPowerSpectrum")
        end
    end
end

%______________________________________________________________________________________________________
% 3.2 Analyse Spike Data
%______________________________________________________________________________________________________

if strcmp(FunctionOrder,'Continous_Spike_Analysis')
    Execute = 1;
    if ~isfield(Data,'Spikes')
        msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        Execute = 0;
    end
    
    if Execute == 1
        if isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Kilosort")
            AverageWaveforms = [];
            % Handle Events: when empty take first event when
            % extracted.
            if isfield(Data.Info,'EventChannelNames') && ~strcmp(AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,"Non")
                if isempty(AutorunConfig.ContSpikeAnalysis.EventChannelToPlot)
                    AutorunConfig.ContSpikeAnalysis.EventChannelToPlot = Data.Info.EventChannelNames{1};
                end
            elseif ~isfield(Data.Info,'EventChannelNames')
                AutorunConfig.ContSpikeAnalysis.EventChannelToPlot = "Non";
            end

            % Channel Data: Dont have to convert, char input of channel
            % is expected
            if isempty(AutorunConfig.ContSpikeAnalysis.ChannelSelection)
                AutorunConfig.ContSpikeAnalysis.ChannelSelection = strcat('1,',num2str(size(Data.Raw,1)));
            end

            % Exatract number of spike clusters Kilosort found
            numCluster = numel(unique(Data.Spikes.SpikeCluster));
            
            % Define unique color for each cluster
            rgbMatrix = lines(numCluster);

            TextArea = [];

            % Simulate GUI inputs by converting variables into edit field structure 
            
            ChannelSelection.Value = AutorunConfig.ContSpikeAnalysis.ChannelSelection;
            WaveformsToPlot.Value = AutorunConfig.ContSpikeAnalysis.WaveformsToPlot;
            UnitsToPlot.Value = AutorunConfig.ContSpikeAnalysis.UnitsToPlot;
            NumBinsSpikeRate.Value = AutorunConfig.ContSpikeAnalysis.NumBinsSpikeRate;
            TimeWindowSpiketriggredLFP.Value = AutorunConfig.ContSpikeAnalysis.TimeWindowSpiketriggredLFP;
            
            if isempty(UnitsToPlot.Value)
                TotalIterations = 1;
            else
                TotalIterations = 2;
            end

            for TotalIts = 1:TotalIterations % 2 if unit plots

                if TotalIts == 1 % if no unit plot
                    UnitIterations = 1;
                    ClusterToPlot = AutorunConfig.ContSpikeAnalysis.Clustertoshow;
                else % if unit plot
                    UnitIterations = length(AutorunConfig.ContSpikeAnalysis.UnitsToPlot);
                    ClusterToPlot = AutorunConfig.ContSpikeAnalysis.UnitsToPlot;
                end

                for i = 1:length(AutorunConfig.ContSpikeAnalysis.KilosortPlotType)
                    
                    KilosortPlotType.Value = AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i);

                    for nunits = 1:UnitIterations
                        if ~strcmp(ClusterToPlot(1),"All") || ~strcmp(ClusterToPlot(1),"Non")
                            CurrentClusterToPlot.Value = num2str(ClusterToPlot(nunits));
                        else
                            CurrentClusterToPlot.Value  = ClusterToPlot;
                        end
    
                        if ischar(CurrentClusterToPlot.Value)
                            CurrentClusterToPlot.Value = convertCharsToStrings(CurrentClusterToPlot.Value);
                        end

                        %% Plot Kilosort Spike Times in big plot as dots
                        SpikeAnalysisFigure = figure();
                        UIAxes = subplot(2,2,1);
                        UIAxes_2 = subplot(2,2,3);
                        UIAxes_3 = subplot(2,2,2);
                        UIAxes.NextPlot = "add";
    
                        if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Average Waveforms Across Channel")
                            if isempty(AverageWaveforms)
                                % For Kilosort we dont have channel information to extract from raw or
                                % preprocessed data --> Therefor we take channel closest to position
                                SpikePositions = (Data.Spikes.SpikePositions(:,2)./Data.Info.ChannelSpacing)+1;
                                SpikePositions = round(SpikePositions);
                                [AverageWaveforms,~] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,SpikePositions,"AverageWaveforms");
                            end
                        end
    
                        %% Prepare Plots
    
                        if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Average Waveforms Across Channel")
                            [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,ChannelSelectionforPlottingEditField,WaveformSelectionforPlottingEditField,UnitstoPlotEditField,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField,WaveformChannel] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,CurrentClusterToPlot,[],"Kilosort",KilosortPlotType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,AverageWaveforms);
                        else
                            [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,ChannelSelectionforPlottingEditField,WaveformSelectionforPlottingEditField,UnitstoPlotEditField,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField,WaveformChannel] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,CurrentClusterToPlot,[],"Kilosort",KilosortPlotType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,Data.Spikes.Waveforms);
                        end
    
                        %% Plot
                        [TempData] = Continous_Kilosort_Spikes_Manage_Analysis_Plots(Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,Waveforms,WaveformChannel,CluterPositions,UIAxes,AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),TextArea,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,rgbMatrix,numCluster,CurrentClusterToPlot.Value,UIAxes_2,UIAxes_3,AutorunConfig.twoORthree_D_Plotting);
                        
                        if ~strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                            [~] = Continous_Kilosort_Spikes_Manage_Analysis_Plots(Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,Waveforms,WaveformChannel,CluterPositions,UIAxes,'SpikeRateBinSizeChange',TextArea,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,rgbMatrix,numCluster,CurrentClusterToPlot.Value,UIAxes_2,UIAxes_3,AutorunConfig.twoORthree_D_Plotting);    
                        end

                        if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Triggered LFP")
                            if ~isempty(TempData)
                                Data = TempData;
                            end
                        else
                            Data = TempData;
                        end
    
                        if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes,1,"Left Axis Only",Data.Time,20,"Time [s]",[],[],8);
                        end
        
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
        
                        if UnitIterations > 1
                            %% Plot Results if turned on
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat("Unit ",num2str(nunits)," Cont Kilosort "), DataPath, AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortContinousIteration")
                            end
                        else
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Cont Kilosort ", DataPath, AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortContinous")
                            end
                        end
                    end % nunits
                end % Kilosort Plottype
            end % Totaliterations ("normal" and unit specific plots)
        %% Internal Spike Analysis
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
            
            AverageWaveforms = [];

            % Handle Events: when empty take first event when
            % extracted.
            if isfield(Data.Info,'EventChannelNames') && ~strcmp(AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,"Non")
                if isempty(AutorunConfig.ContSpikeAnalysis.EventChannelToPlot)
                    AutorunConfig.ContSpikeAnalysis.EventChannelToPlot = Data.Info.EventChannelNames{1};
                end
            elseif ~isfield(Data.Info,'EventChannelNames')
                AutorunConfig.ContSpikeAnalysis.EventChannelToPlot = "Non";
            end

            % Channel Data: Dont have to convert, char input of channel
            % is expected
            if isempty(AutorunConfig.ContSpikeAnalysis.ChannelSelection)
                AutorunConfig.ContSpikeAnalysis.ChannelSelection = strcat('1,',num2str(size(Data.Raw,1)));
            end
            
            if isfield(Data.Info,'SpikeSorting')
                if ~isempty(Data.Spikes.Waveforms)
                    % Exatract number of spike clusters Kilosort found
                    numCluster = numel(unique(Data.Spikes.SpikeCluster));
                    % Define unique color for each cluster
                    rgbMatrix = lines(numCluster);
                end
            else
                if strcmp(AutorunConfig.ContSpikeAnalysis.Clustertoshow,"All") % When no cluster present
                    AutorunConfig.ContSpikeAnalysis.Clustertoshow = "Non";
                end
                numCluster = 1;
                % Define unique color for each cluster
                rgbMatrix = lines(1);
            end

            TextArea = [];

            % Simulate GUI inputs by converting variables into edit field structure  
            ChannelSelection.Value = AutorunConfig.ContSpikeAnalysis.ChannelSelection;
            WaveformsToPlot.Value = AutorunConfig.ContSpikeAnalysis.WaveformsToPlot;
            UnitsToPlot.Value = AutorunConfig.ContSpikeAnalysis.UnitsToPlot;
            NumBinsSpikeRate.Value = AutorunConfig.ContSpikeAnalysis.NumBinsSpikeRate;
            TimeWindowSpiketriggredLFP.Value = AutorunConfig.ContSpikeAnalysis.TimeWindowSpiketriggredLFP;

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
                    ClusterToPlot = AutorunConfig.ContSpikeAnalysis.Clustertoshow;
                else % if unit plot
                    UnitIterations = length(AutorunConfig.ContSpikeAnalysis.UnitsToPlot);
                    ClusterToPlot = AutorunConfig.ContSpikeAnalysis.UnitsToPlot;
                end

                for i = 1:length(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType)
    
                    InternalPlotType.Value = AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i);
    
                    for nunits = 1:UnitIterations
                        if ~strcmp(ClusterToPlot(1),"All") || ~strcmp(ClusterToPlot(1),"Non")
                            CurrentClusterToPlot.Value = num2str(ClusterToPlot(nunits));
                        else
                            CurrentClusterToPlot.Value  = ClusterToPlot;
                        end
    
                        if ischar(CurrentClusterToPlot.Value)
                            CurrentClusterToPlot.Value = convertCharsToStrings(CurrentClusterToPlot.Value);
                        end

                        %% Plot Kilosort Spike Times in big plot as dots
                        SpikeAnalysisFigure = figure();
                        UIAxes = subplot(2,2,1);
                        UIAxes_2 = subplot(2,2,3);
                        UIAxes_3 = subplot(2,2,2);
                        UIAxes.NextPlot = "add";
                        % for waveforms across channel extract waveforms
                        % for each spike over all channel. Just do once
                        if strcmp(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i),"Average Waveforms Across Channel") 
                            if isempty(AverageWaveforms)
                                [AverageWaveforms,~] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,Data.Spikes.SpikePositions(:,2),"AverageWaveforms");
                            end
                        end
                        % if Average Waveforms Across Channel, waveform
                        % input is the Waveform Output from above over all
                        % channel
                        if strcmp(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i),"Average Waveforms Across Channel")
                            [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,ChannelPosition,PlotInfo,ChannelSelection,WaveformsToPlot,UnitsToPlot,NumBinsSpikeRate,TimeWindowSpiketriggredLFP] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,CurrentClusterToPlot,[],"Internal",InternalPlotType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,AverageWaveforms);
                        else
                            [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,ChannelPosition,PlotInfo,ChannelSelection,WaveformsToPlot,UnitsToPlot,NumBinsSpikeRate,TimeWindowSpiketriggredLFP] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,CurrentClusterToPlot,[],"Internal",InternalPlotType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,Data.Spikes.Waveforms);
                        end
    
                        %% Plot
                        if ~isfield(Data.Info,'SpikeSorting')
                            PlotInfo.Units = NaN;
                        end
    
                        [TempData] = Continous_Internal_Spikes_Manage_Analysis_Plots(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i),Data,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,Waveforms,PlotInfo,TextArea,ChannelPosition,UIAxes,UIAxes_2,UIAxes_3,rgbMatrix,AutorunConfig.twoORthree_D_Plotting,CurrentClusterToPlot.Value);
        
                        if ~strcmp(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i),"SpikeMap")
                            [~] = Continous_Internal_Spikes_Manage_Analysis_Plots('SpikeRateBinSizeChange',Data,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,Waveforms,PlotInfo,TextArea,ChannelPosition,UIAxes,UIAxes_2,UIAxes_3,rgbMatrix,AutorunConfig.twoORthree_D_Plotting,CurrentClusterToPlot.Value);
                        end
    
                        if strcmp(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i),"Spike Triggered LFP")
                            if ~isempty(TempData)
                                Data = TempData;
                            end
                        else
                            Data = TempData;
                        end
        
                        if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes,1,"Left Axis Only",Data.Time,20,"Time [s]",[],[],8);
                        end
        
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
        
                        if UnitIterations > 1
                            %% Plot Results if turned on
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat("Unit ",num2str(nunits)," Cont Internal "), DataPath, AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "InternalContinousIteration")
                            end
                        else
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Cont Internal ", DataPath, AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ContInternalSpikes")
                            end
                        end
                        
                    end% over units internal spike analysis
                end % loop over analysis types
            end % loop either 1 or 2, 2 if individual unit plots selected
        end % if Internal Spikes present
    end % if Execute == 1
end % if FunctionOrder == "Cont. Spike Analysis"

if strcmp(FunctionOrder,'Continous_Unit_Analysis')
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
        
        [Units,Waves,Wavefigs,ISIfigs,AutoCfigs,SpikeTimes,SpikePositions,SpikeCluster,SpikeWaveforms,SpikeChannel] = Spike_Module_Prepare_WaveForm_Window_and_Analysis(Data,AutorunConfig.ContinousUnitAnalysis.UnitsPlot1,AutorunConfig.ContinousUnitAnalysis.UnitsPlot2,AutorunConfig.ContinousUnitAnalysis.UnitsPlot3,AutorunConfig.ContinousUnitAnalysis.NumberWaveformsPlot1,AutorunConfig.ContinousUnitAnalysis.NumberWaveformsPlot2,AutorunConfig.ContinousUnitAnalysis.NumberWaveformsPlot3,UIAxes_1,UIAxes_2,UIAxes_3,UIAxes_4,UIAxes_5,UIAxes_6,UIAxes_7,UIAxes_8,UIAxes_9,"StartUp","ContinousWindow");

        %% Plot Waveforms
        
        Spike_Waveforms_Plot_Waveforms(Data,Units,SpikeWaveforms,SpikeCluster,Waves,Wavefigs);

        %% Plot ISI
        
        Spike_Module_Calculate_Plot_ISI(Data,SpikeTimes,SpikePositions,SpikeCluster,SpikeChannel,Units,Waves,ISIfigs,str2double(AutorunConfig.ContinousUnitAnalysis.NumBins),str2double(AutorunConfig.ContinousUnitAnalysis.MaxTImeISI));
  
        %% Plot Autocorrelogramme

        Spikes_Module_AutoCorrelogram(Data,SpikeTimes,SpikePositions,SpikeChannel,SpikeCluster,AutoCfigs,Units,str2double(AutorunConfig.ContinousUnitAnalysis.NumBins));

        %% Plot Results if turned on
        if strcmp(AutorunConfig.SaveFigures,"on")
            Execute_Autorun_Save_Figure(UnitAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat("Cont. Unit Analysis"), DataPath, " ", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ContWaveforms")
        end
    end
end