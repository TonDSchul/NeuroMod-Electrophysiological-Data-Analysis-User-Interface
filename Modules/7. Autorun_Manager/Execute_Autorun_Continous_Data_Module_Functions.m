function [Data] = Execute_Autorun_Continous_Data_Module_Functions (AutorunConfig,FunctionOrder,Data,LoadDataPath,LoadedData)

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
    
    PreviousChannelDeletetion = 0;
    % If Channel were deleted in previous preprocessing flag this
    % to reset main window parameter after + only allow for prepro
    % view if prepro was generated
    if isfield(Data.Info,"ChannelDeletion")
        PreviousChannelDeletetion = 1;
    end
    
    if isfield(PreproInfo,'ChannelDeletion')
        ChannelDeletion = PreproInfo.ChannelDeletion;
    else
        ChannelDeletion = [];
    end
    
    Events = [];
    Spikes = [];
    
    if isfield(Data,'Events')
        Events = Data.Events;
    end
    
    if isfield(Data,'Spikes')
        Spikes = Data.Spikes.SpikeTimes;
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

            Analyse_Main_Window_Static_Power_Spectrum(Data,StaticPowerSpectrumFigure,AutorunConfig.StaticPowerSpectrum.DataType,AutorunConfig.StaticPowerSpectrum.DataSource,str2double(AutorunConfig.StaticPowerSpectrum.Channel),num2str(AutorunConfig.StaticPowerSpectrum.Channel));
        
        elseif strcmp(AutorunConfig.StaticPowerSpectrum.PlotType(i),"Band Power over Depth")
            StaticPowerSpectrumfig = figure();
            UIAxes = subplot(1,2,1);
            UIAxes_2 = subplot(1,2,2);

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
            plotLFPpower(BandPower.F, BandPower.allPowerEst, dispRange, BandPower.marginalChans, BandPower.freqBands, UIAxes, UIAxes_2, 'All',Data.Info.ChannelSpacing);
          
        end
    
        %% Plot Results if turned on
        if strcmp(AutorunConfig.SaveFigures,"on")
            Execute_Autorun_Save_Figure(StaticPowerSpectrumfig, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Static Power Spectrum", LoadDataPath, AutorunConfig.StaticPowerSpectrum.PlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "StaticPowerSpectrum")
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

            for i = 1:length(AutorunConfig.ContSpikeAnalysis.KilosortPlotType)
                
                KilosortPlotType.Value = AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i);

                if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Average Waveforms Across Channel") || strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Waveforms from Raw Data") || strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Waveforms Templates") || strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Template from Max Amplitude Channel")
                    if strcmp(AutorunConfig.ContSpikeAnalysis.UnitsToPlot,"All")
                        TotalIterations = numel(unique(Data.Spikes.SpikeCluster));
                        SpikeClusterRange = 1:TotalIterations;
                        ClusterToPlot = 0:TotalIterations-1;
                    elseif length(AutorunConfig.ContSpikeAnalysis.UnitsToPlot) >= 1
                        TotalIterations = numel(AutorunConfig.ContSpikeAnalysis.UnitsToPlot);
                        for k = 1:TotalIterations
                            SpikeClusterRange(k) = str2double(AutorunConfig.ContSpikeAnalysis.UnitsToPlot(k));
                        end
                        for k = 1:numel(SpikeClusterRange)
                            ClusterToPlot(k) = SpikeClusterRange(k);
                        end
                    end
                else
                    TotalIterations = 1;
                    SpikeClusterRange = 1;
                    ClusterToPlot = AutorunConfig.ContSpikeAnalysis.Clustertoshow;
                end

                for nunits = 1:TotalIterations
                    if isfield(Data.Spikes,'Waveforms')
                        Data.Spikes.Waveforms = [];
                    end
                    if ~strcmp(ClusterToPlot(1),"All") || ~strcmp(ClusterToPlot(1),"Non")
                        CurrentClusterToPlot = num2str(ClusterToPlot(nunits));
                    else
                        CurrentClusterToPlot = ClusterToPlot;
                    end

                    UnitsToPlot.Value = num2str(SpikeClusterRange(nunits));
                    %% Plot Kilosort Spike Times in big plot as dots
                    SpikeAnalysisFigure = figure();
                    UIAxes = subplot(2,2,1);
                    UIAxes_2 = subplot(2,2,3);
                    UIAxes_3 = subplot(2,2,2);
    
                    %% Prepare Plots
                    [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,~,PlotInfo,ChannelSelection,WaveformsToPlot,UnitsToPlot,NumBinsSpikeRate,TimeWindowSpiketriggredLFP] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,UnitsToPlot,[],"Kilosort",KilosortPlotType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot);
                    
                    %% Plot
                    [Data] = Continous_Kilosort_Spikes_Manage_Analysis_Plots(Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,CluterPositions,UIAxes,AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),TextArea,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,rgbMatrix,numCluster,CurrentClusterToPlot,UIAxes_2,UIAxes_3);
                    if ~strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                      [Data] = Continous_Kilosort_Spikes_Manage_Analysis_Plots(Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,CluterPositions,UIAxes,'SpikeRateBinSizeChange',TextArea,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,rgbMatrix,numCluster,CurrentClusterToPlot,UIAxes_2,UIAxes_3);    
                    end
    
                    if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes,1,"Left Axis Only",Data.Time,20,"Time [s]",[],[],8);
                    end
    
                    [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                    [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
    
                    if TotalIterations > 1
                        %% Plot Results if turned on
                        if strcmp(AutorunConfig.SaveFigures,"on")
                            Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat("Unit ",num2str(nunits)," Cont_Kilosort_"), LoadDataPath, AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortContinousIteration")
                        end
                    else
                        if strcmp(AutorunConfig.SaveFigures,"on")
                            Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Cont_Kilosort_", LoadDataPath, AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortContinous")
                        end
                    end
                end
                
            end
           
        %% Internal Spike Analysis
        elseif isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
            
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
            numCluster = 1;
            
            % Define unique color for each cluster
            rgbMatrix = lines(1);

            TextArea = [];

            % Simulate GUI inputs by converting variables into edit field structure  
            ChannelSelection.Value = AutorunConfig.ContSpikeAnalysis.ChannelSelection;
            WaveformsToPlot.Value = AutorunConfig.ContSpikeAnalysis.WaveformsToPlot;
            UnitsToPlot.Value = AutorunConfig.ContSpikeAnalysis.UnitsToPlot;
            NumBinsSpikeRate.Value = AutorunConfig.ContSpikeAnalysis.NumBinsSpikeRate;
            TimeWindowSpiketriggredLFP.Value = AutorunConfig.ContSpikeAnalysis.TimeWindowSpiketriggredLFP;

            for i = 1:length(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType)

                InternalPlotType.Value = AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i);

                %% Plot Kilosort Spike Times in big plot as dots
                SpikeAnalysisFigure = figure();
                UIAxes = subplot(2,2,1);
                UIAxes_2 = subplot(2,2,3);
                UIAxes_3 = subplot(2,2,2);
                
                %% Prepare Plots
                [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,ChannelPosition,PlotInfo,ChannelSelection,WaveformsToPlot,UnitsToPlot,NumBinsSpikeRate,TimeWindowSpiketriggredLFP] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,UnitsToPlot,[],"Internal",InternalPlotType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot);
                
                %% Plot

                Continous_Internal_Spikes_Manage_Analysis_Plots(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i),Data,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,PlotInfo,TextArea,ChannelPosition,UIAxes,UIAxes_2,UIAxes_3,rgbMatrix)

                if ~strcmp(AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i),"Spike Map")
                  Continous_Internal_Spikes_Manage_Analysis_Plots("SpikeRateBinSizeChange",Data,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,PlotInfo,TextArea,ChannelPosition,UIAxes,UIAxes_2,UIAxes_3,rgbMatrix)
                end

                if strcmp(AutorunConfig.ContSpikeAnalysis.KilosortPlotType(i),"Spike Map")
                    [~] = Execute_Autorun_Set_Up_Figure(UIAxes,1,"Left Axis Only",Data.Time,20,"Time [s]",[],[],8);
                end

                [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);

                %% Plot Results if turned on
                if strcmp(AutorunConfig.SaveFigures,"on")
                    Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Cont_Internal_Spikes", LoadDataPath, AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ContInternalSpikes")
                end

            end % loop over analysis types
        end % if Internal Spikes present
    end % if Execute == 1
end % if FunctionOrder == "Cont. Spike Analysis"
