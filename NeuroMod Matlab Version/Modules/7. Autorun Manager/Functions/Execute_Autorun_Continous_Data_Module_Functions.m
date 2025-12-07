function [Data,CurrentPlotData] = Execute_Autorun_Continous_Data_Module_Functions (AutorunConfig,FunctionOrder,Data,DataPath,LoadedData,CurrentPlotData,executableFolder)

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
    
    % When artefact rejection: populate necessary strucutre accordingly,
    % otherwise set empty
    for i = 1:length(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr})
        if ~strcmp(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr},"StimArtefactRejection")
            ArtefactRejectionInfo = [];
        else
            if ~isfield(Data,'Events')
                disp("Now event channel extracted for stimulation artefact rejection!")
                return;
            end

            ArtefactRejectionInfo.SelectedEventChannelName = AutorunConfig.PreprocessCont.ArtefactRejetction.StimArtefactChannel;
            
            if ~isempty(AutorunConfig.PreprocessCont.ArtefactRejetction.TriggerToSelect)
                ArtefactRejectionInfo.SelectedTriggertChannel = double(strsplit(AutorunConfig.PreprocessCont.ArtefactRejetction.TriggerToSelect,','));
            else
                EventIndice = [];
                for neventname = 1:length(Data.Info.EventChannelNames)
                    if strcmp(Data.Info.EventChannelNames{neventname},AutorunConfig.PreprocessCont.ArtefactRejetction.StimArtefactChannel)
                        EventIndice = neventname;
                    end
                end
                if ~isempty(EventIndice)
                    ArtefactRejectionInfo.SelectedTriggertChannel = 1:size(Data.Events{EventIndice});
                else
                    disp("Specified event channel name for stimulation artefact rejection is not found as part of the dataset!")
                    return;
                end
            end

            AutorunConfig.PreprocessCont.ArtefactRejetction.TimeAroundArtefact = convertStringsToChars(AutorunConfig.PreprocessCont.ArtefactRejetction.TimeAroundArtefact);
            commaindicie = find(AutorunConfig.PreprocessCont.ArtefactRejetction.TimeAroundArtefact==',');
            ArtefactRejectionInfo.TimeAroundEvents(1) = str2double(AutorunConfig.PreprocessCont.ArtefactRejetction.TimeAroundArtefact(1:commaindicie(1)-1));
            ArtefactRejectionInfo.TimeAroundEvents(2) = str2double(AutorunConfig.PreprocessCont.ArtefactRejetction.TimeAroundArtefact(commaindicie(1)+1:end));
            % Convert to samples
            ArtefactRejectionInfo.TimeAroundEvents = round(ArtefactRejectionInfo.TimeAroundEvents.*Data.Info.NativeSamplingRate);
            
            if isempty(AutorunConfig.PreprocessCont.ArtefactRejetction.ChannelSelection)
                ArtefactRejectionInfo.ChannelSelection = 1:size(Data.Raw,1);
            else
                TempChannelSelection = str2double(strsplit(AutorunConfig.PreprocessCont.ArtefactRejetction.ChannelSelection,','));
                ArtefactRejectionInfo.ChannelSelection = TempChannelSelection(1):TempChannelSelection(2);


                AutorunConfig.PreprocessCont.ArtefactRejetction.TriggerToSelect
            end
        end

        % ASR
        if strcmp(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr}(i),"ASR")
            PreproInfo.ASRLineNoiseC = str2double(AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.LineNoiseCriterion);
            PreproInfo.ASRHPTransitions = str2double(strsplit(AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.HighPassTransBand,','));
            PreproInfo.ASRBurstC = str2double(AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.BurstCriterion);
            PreproInfo.WindowC = str2double(AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.WindowCriterion);
        end

        if strcmp(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr}(i),"CutStart")
            PreproInfo.CutStart = str2double(AutorunConfig.PreprocessCont.CutTimeFromStart);
        end
        if strcmp(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr}(i),"CutEnd")
            PreproInfo.CutEnd = str2double(AutorunConfig.PreprocessCont.CutTimeFromEnd);
        end
        
        if strcmp(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr}(i),"ChannelDeletion")
            AutorunConfig.PreprocessCont.DeleteChannel = str2double(strsplit(AutorunConfig.PreprocessCont.DeleteChannel,','));
            PreproInfo.ChannelDeletion = AutorunConfig.PreprocessCont.DeleteChannel;
        end

        [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(AutorunConfig.PreprocessCont.PreproMethod{Data.CurrentPreproNr}(i),PreproInfo,PreprocessingSteps,0,AutorunConfig.PreprocessCont.FilterMethod{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.FilterType{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.CuttoffFrequency{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.FilterDirection{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.FilterOrder{Data.CurrentPreproNr},AutorunConfig.PreprocessCont.DownsampleRate,Data.Info.NativeSamplingRate,ArtefactRejectionInfo);
    
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
    ExportedAlready = 0;
    for i = 1:length(AutorunConfig.StaticPowerSpectrum.PlotType)
        if strcmp(AutorunConfig.StaticPowerSpectrum.PlotType(i),"Band Power Individual Channel ")

            if strcmp(AutorunConfig.StaticPowerSpectrum.DataSource,"Preprocessed Data")
                if ~isfield(Data,'Preprocessed')
                    disp("No preprocecssed data available for static spectrum. Please change 'AutorunConfig.StaticPowerSpectrum.DataSource' to 'Raw Data' or preprocess before that step. Skipping");
                    return;
                end
            end

            StaticPowerSpectrumfig = figure();
            StaticPowerSpectrumFigure = axes;

            CurrentPlotData = Analyse_Main_Window_Static_Power_Spectrum(Data,StaticPowerSpectrumFigure,AutorunConfig.StaticPowerSpectrum.DataType,AutorunConfig.StaticPowerSpectrum.DataSource,str2double(AutorunConfig.StaticPowerSpectrum.Channel),num2str(AutorunConfig.StaticPowerSpectrum.Channel),AutorunConfig.StaticPowerSpectrum.FrequencyRange,CurrentPlotData,AutorunConfig.PlotAppearance,AutorunConfig.StaticPowerSpectrum.WindowSize,AutorunConfig.StaticPowerSpectrum.UseCostumeWindowSize);
            
            StaticPowerSpectrumfig.Color = AutorunConfig.ComponentsInWindowColor;

        elseif strcmp(AutorunConfig.StaticPowerSpectrum.PlotType(i),"Band Power over Depth")
            StaticPowerSpectrumfig = figure();
            UIAxes = subplot(1,2,1);
            UIAxes_2 = subplot(1,2,2);
            UIAxes.NextPlot = "add";
            UIAxes_2.NextPlot = "add";

            TextArea = [];
            BandPower = [];
            PowerSpecResults = [];

            DepthChannel = AutorunConfig.StaticPowerSpectrum.DepthChannel;
            
            [~,~,CurrentPlotData] = Continous_Power_Spectrum_Over_Depth(Data,AutorunConfig.StaticPowerSpectrum.DataSource,PowerSpecResults,BandPower,AutorunConfig.StaticPowerSpectrum.FrequencyRange,UIAxes,UIAxes_2,TextArea,"All",AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,DepthChannel,AutorunConfig.PlotAppearance,AutorunConfig.PreservePlotChannelLocations);
            
            StaticPowerSpectrumfig.Color = AutorunConfig.ComponentsInWindowColor;
            [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
            [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);
        end
        
        %% Plot Results if turned on
        if strcmp(AutorunConfig.SaveFigures,"on")
            Execute_Autorun_Save_Figure(StaticPowerSpectrumfig, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, "Static Power Spectrum", DataPath, AutorunConfig.StaticPowerSpectrum.PlotType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "StaticPowerSpectrum")
        end
        
        %% Export Data id required
        if AutorunConfig.ExportDataThisBlock == 1
            Execute_Autorun_Export_Data(AutorunConfig,"Continuous Static Spectrum",Data,executableFolder,AutorunConfig.StaticPowerSpectrum.PlotType(i),CurrentPlotData,ExportedAlready);
            ExportedAlready = 1;
        end
    end
    ExportedAlready = 0;
end

%______________________________________________________________________________________________________
% 3.2 Analyse Spike Data
%______________________________________________________________________________________________________

if strcmp(FunctionOrder,'Continous_Spike_Analysis')
    ExportedAlready = 0; 
    Execute = 1;
    if ~isfield(Data,'Spikes')
        msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        Execute = 0;
    end
    
    if Execute == 1

        DepthChannel = AutorunConfig.ContSpikeAnalysis.ChannelSelection;

        if isfield(Data,'Spikes')
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
            if strcmp(AutorunConfig.ContSpikeAnalysis.UnitsToPlot,"All") && ~strcmp(Data.Info.SpikeType,'Internal')
                numunits = length(unique(Data.Spikes.SpikeCluster));
                AutorunConfig.ContSpikeAnalysis.UnitsToPlot = string(1:numunits);
            end

            ChannelSelection.Value = AutorunConfig.ContSpikeAnalysis.ChannelSelection;
            WaveformsToPlot.Value = AutorunConfig.ContSpikeAnalysis.WaveformsToPlot;
            UnitsToPlot.Value = AutorunConfig.ContSpikeAnalysis.UnitsToPlot;
            NumBinsSpikeRate.Value = AutorunConfig.ContSpikeAnalysis.NumBinsSpikeRate;
            TimeWindowSpiketriggredLFP.Value = AutorunConfig.ContSpikeAnalysis.TimeWindowSpiketriggredLFP;
            
            if isempty(UnitsToPlot.Value) || strcmp(Data.Info.SpikeType,'Internal')
                TotalIterations = 1;
            else
                TotalIterations = 2;
            end

            for TotalIts = 1:TotalIterations % 2 if unit plots

                if TotalIts == 1 % if no unit plot
                    UnitIterations = 1;
                    ClusterToPlot = AutorunConfig.ContSpikeAnalysis.Clustertoshow;
                else % if unit plot
                    if isscalar(AutorunConfig.ContSpikeAnalysis.UnitsToPlot)
                        AutorunConfig.ContSpikeAnalysis.UnitsToPlot = convertStringsToChars(AutorunConfig.ContSpikeAnalysis.UnitsToPlot);
                        if contains(AutorunConfig.ContSpikeAnalysis.UnitsToPlot,',')
                            AutorunConfig.ContSpikeAnalysis.UnitsToPlot = string(str2double(strsplit(AutorunConfig.ContSpikeAnalysis.UnitsToPlot,',')));
                        end
                    end

                    UnitIterations = length(AutorunConfig.ContSpikeAnalysis.UnitsToPlot);
                    ClusterToPlot = AutorunConfig.ContSpikeAnalysis.UnitsToPlot;
                end

                for i = 1:length(AutorunConfig.ContSpikeAnalysis.AnalysisType)
                    
                    ConvertedAnalysisType.Value = AutorunConfig.ContSpikeAnalysis.AnalysisType(i);

                    for nunits = 1:UnitIterations
                        if strcmp(Data.Info.SpikeType,"SpikeInterface")
                            if strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Waveform Templates")
                                disp("Waveform Templates no available yet for Spikeinterface data. Skipping");
                                continue;
                            elseif strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Template from Max Amplitude Channel")
                                disp("Template from Max Amplitude Channel no available yet for Spikeinterface data. Skipping");
                                continue;
                            end
                        end
                        
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

                        %% Plot Spike Times in big plot as dots
                        SpikeAnalysisFigure = figure();
                        UIAxes = subplot(2,2,1);
                        UIAxes_2 = subplot(2,2,3);
                        UIAxes_3 = subplot(2,2,2);
                        UIAxes.NextPlot = "add";
                        
                        if strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Average Waveforms Across Channel") && isempty(AverageWaveforms)
                            %% Data needs to be high pass filtered! Otherwise waveforms are weird. Recommended is also grand average
                            % Detect high pass filter
                            HigPassFiltered = 1;
                            
                            if isfield(Data,'Preprocessed') 
                                if isfield(Data.Info,'FilterMethod') 
                                    if ~strcmp(Data.Info.FilterMethod,'High-Pass')
                                        msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
                                        HigPassFiltered = 0;
                                    end
                                else
                                    msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
                                    HigPassFiltered = 0;
                                end
                            else
                                msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
                                HigPassFiltered = 0;
                            end
                            
                            %%% if it has to be high pass filtered --> save as TempData, extract
                            %%% waveforms and delete temp variable
                            if HigPassFiltered == 0

                                HighPassFilterSettings = [];
                                Spike_Extraction_HighPassWindow = Spike_Extraction_AskforHighPass(HighPassFilterSettings);
                                
                                uiwait(Spike_Extraction_HighPassWindow.PreproSTAWindowUIFigure);
                                
                                if isvalid(Spike_Extraction_HighPassWindow)
                                    Cutoff = Spike_Extraction_HighPassWindow.HighPassFilterSettings.Cutoff;
                                    FilterOrder = Spike_Extraction_HighPassWindow.HighPassFilterSettings.FilterOrder;
                                    SaveFilter = Spike_Extraction_HighPassWindow.HighPassFilterSettings.SaveFilter;
                                    delete(Spike_Extraction_HighPassWindow);
                                else
                                    disp("High pass filter settings window closed before manual config was saved. Using standad high pass filter settings (300Hz cutoff, filterorder 6)")
                                    Cutoff = "300";
                                    FilterOrder = "6";
                                    SaveFilter = "No";
                                end

                                PreproInfo = [];
                                PreprocessingSteps = [];
                            
                                Methods = ["Filter"];
                                [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods,PreproInfo,PreprocessingSteps,0,"High-Pass","Butterworth IR",Cutoff,"Zero-phase forward and reverse",FilterOrder,[],Data.Info.NativeSamplingRate);
                                    
                                if isfield(PreproInfo,'ChannelDeletion')
                                    ChannelDeletion = PreproInfo.ChannelDeletion;
                                else
                                    ChannelDeletion = [];
                                end
                                
                                TextArea = [];

                                if strcmp(SaveFilter,"No")
                                    [TempData,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
                                    [TempData] = Preprocess_Module_Apply_Pipeline (TempData,TempData.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea); 
                                    %% Now extract Waveforms
                                    % For Kilosort we dont have channel information to extract from raw or
                                    % preprocessed data --> Therefor we take channel closest to position
                                    
                                    [AverageWaveforms,~] = Spikes_Module_Get_Waveforms(TempData,TempData.Spikes.SpikeTimes,TempData.Spikes.SpikeChannel,"AverageWaveforms");
                                    clear TempData;
                                else
                                    [Data,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
                                    [Data] = Preprocess_Module_Apply_Pipeline (Data,Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea); 
                                    %% Now extract Waveforms
                                    % For Kilosort we dont have channel information to extract from raw or
                                    % preprocessed data --> Therefor we take channel closest to position
                                    
                                    [AverageWaveforms,~] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,Data.Spikes.SpikeChannel,"AverageWaveforms");
                                end
                                
                            else % If high pass was already applied
                                % For Kilosort we dont have channel information to extract from raw or
                                % preprocessed data --> Therefor we take channel closest to position
                                
                                [AverageWaveforms,~] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,Data.Spikes.SpikeChannel,"AverageWaveforms");
                            end
                        end

                        %% Prepare Plots
                        if strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Average Waveforms Across Channel")
                            [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,ChannelSelection,WaveformsToPlot,UnitsToPlot,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,WaveformChannel] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,CurrentClusterToPlot,[],Data.Info.SpikeType,ConvertedAnalysisType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,AverageWaveforms,DepthChannel,AutorunConfig.ContSpikeAnalysis.AnalysisType(i),AutorunConfig.PreservePlotChannelLocations);
                        else
                            [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,ChannelSelection,WaveformsToPlot,UnitsToPlot,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,WaveformChannel] = Continous_Spikes_Prepare_Plots(Data,ChannelSelection,WaveformsToPlot,CurrentClusterToPlot,[],Data.Info.SpikeType,ConvertedAnalysisType,NumBinsSpikeRate,TimeWindowSpiketriggredLFP,1,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,Data.Spikes.Waveforms,DepthChannel,AutorunConfig.ContSpikeAnalysis.AnalysisType(i),AutorunConfig.PreservePlotChannelLocations);
                        end
    
                        FakeTextAre.Value = '';
                        
                        if strcmp(Data.Info.SpikeType,'Internal') && strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Waveform Templates") || strcmp(Data.Info.SpikeType,'Internal') && strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Template from Max Amplitude Channel")
                            disp("Template plots not available for NeuroMod internal spike detection data.")
                            continue;
                        else
                            [TempData,CurrentPlotData] = Continous_Spikes_Manage_Analysis_Plots(Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,Waveforms,WaveformChannel,CluterPositions,UIAxes,AutorunConfig.ContSpikeAnalysis.AnalysisType(i),FakeTextAre,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,rgbMatrix,numCluster,CurrentClusterToPlot.Value,UIAxes_2,UIAxes_3,AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,1,Data.Info.ProbeInfo.ActiveChannel,AutorunConfig.PreservePlotChannelLocations);
                        end

                        if strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Spike Triggered LFP") || strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Spike Triggered Average")
                            if ~isempty(TempData)
                                Data = TempData;
                            end
                        else
                            %Data = TempData;
                        end

                        if ~strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Spike Map")
                            [~,CurrentPlotData] = Continous_Spikes_Manage_Analysis_Plots(Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,Waveforms,WaveformChannel,CluterPositions,UIAxes,"SpikeRateBinSizeChange",FakeTextAre,AutorunConfig.ContSpikeAnalysis.EventChannelToPlot,rgbMatrix,numCluster,CurrentClusterToPlot.Value,UIAxes_2,UIAxes_3,AutorunConfig.twoORthree_D_Plotting,CurrentPlotData,AutorunConfig.PlotAppearance,1,Data.Info.ProbeInfo.ActiveChannel,AutorunConfig.PreservePlotChannelLocations);
                        end

                        if strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Spike Map")
                            [~] = Execute_Autorun_Set_Up_Figure(UIAxes,1,"Left Axis Only",Data.Time,20,"Time [s]",[],[],8);
                        end
                        
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_2,0,"Both Axis",[],[],[],[],[],8);
                        [~] = Execute_Autorun_Set_Up_Figure(UIAxes_3,0,"Left Axis Only",[],[],[],[],[],8);
                        
                        SpikeAnalysisFigure.Color = AutorunConfig.ComponentsInWindowColor;
                        [UIAxes] = Execute_Autorun_Set_Plot_Colors(UIAxes,AutorunConfig);
                        if strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Spike Map")
                            UIAxes.Color = [1 1 1];
                        end
                        [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);
                        [UIAxes_3] = Execute_Autorun_Set_Plot_Colors(UIAxes_3,AutorunConfig);

                        if strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Cumulative Spike Amplitude Density Along Depth") || strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Spike Amplitude Density Along Depth") || strcmp(AutorunConfig.ContSpikeAnalysis.AnalysisType(i),"Average Waveforms Across Channel")
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
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat(" Cont. ",SpikeName," Spikes Unit ",num2str(nunits)," "), DataPath, AutorunConfig.ContSpikeAnalysis.AnalysisType(i), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortContinousIteration")
                            end
                        elseif TotalIterations > 1 && TotalIts == 1
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.ContSpikeAnalysis.AnalysisType(i), DataPath, strcat(" Cont. ",SpikeName," Spikes "), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortContinous")
                            end
                        else
                            if strcmp(AutorunConfig.SaveFigures,"on")
                                Execute_Autorun_Save_Figure(SpikeAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving,AutorunConfig.ContSpikeAnalysis.AnalysisType(i), DataPath, strcat(" Cont. ",SpikeName," Spikes "), AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "KilosortContinous")
                            end
                        end
                        
                        %% Eport Data if required
                        if AutorunConfig.ExportDataThisBlock == 1
                            if strcmp(CurrentClusterToPlot.Value,"All") || strcmp(CurrentClusterToPlot.Value,"Non")
                                Execute_Autorun_Export_Data(AutorunConfig,"Continuous Spikes",Data,executableFolder,AutorunConfig.ContSpikeAnalysis.AnalysisType(i),CurrentPlotData,ExportedAlready);
                            else
                                Execute_Autorun_Export_Data(AutorunConfig,strcat("Continuous Spikes Unit ",CurrentClusterToPlot.Value),Data,executableFolder,AutorunConfig.ContSpikeAnalysis.AnalysisType(i),CurrentPlotData,ExportedAlready);
                            end

                            ExportedAlready = 1;
                        end
                        CurrentPlotData = [];

                    end % nunits
                end % Sorter Plottype
            end % Totaliterations ("normal" and unit specific plots)
        end % if is spikes
    end % if Execute == 1
end % if FunctionOrder == "Cont. Spike Analysis"

if strcmp(FunctionOrder,'Continous_Unit_Analysis')
    CurrentPlotData = [];
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
        UIAxes_1 = subplot(3,2,1);
        UIAxes_2 = subplot(3,2,2);
        UIAxes_3 = subplot(3,2,3);
        UIAxes_4 = subplot(3,2,4);
        UIAxes_5 = subplot(3,2,5);
        UIAxes_6 = subplot(3,2,6);

        UIAxes_1.NextPlot = "add";
        UIAxes_2.NextPlot = "add";
        UIAxes_3.NextPlot = "add";
        UIAxes_4.NextPlot = "add";
        UIAxes_5.NextPlot = "add";
        UIAxes_6.NextPlot = "add";

        [Units,Waves,Wavefigs,ISIfigs,AutoCfigs,SpikeTimes,SpikePositions,SpikeCluster,SpikeWaveforms,SpikeChannel,AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram] = Spike_Module_Prepare_WaveForm_Window_and_Analysis(Data,AutorunConfig.ContinousUnitAnalysis.UnitsPlot1,AutorunConfig.ContinousUnitAnalysis.UnitsPlot2,AutorunConfig.ContinousUnitAnalysis.NumberWaveformsPlot1,AutorunConfig.ContinousUnitAnalysis.NumberWaveformsPlot2,UIAxes_1,UIAxes_2,UIAxes_3,UIAxes_4,UIAxes_5,UIAxes_6,"StartUp","ContinousWindow",AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram);

        %% Plot Waveforms
        
        CurrentPlotData = Spike_Waveforms_Plot_Waveforms(Data,Units,SpikeWaveforms,SpikeCluster,Waves,Wavefigs);
        
        if AutorunConfig.ExportDataThisBlock == 1
            Execute_Autorun_Export_Data(AutorunConfig,"Continuous Unit Analysis",Data,executableFolder,"Waveforms",CurrentPlotData,0);
        end
        CurrentPlotData = [];

        %% Plot ISI
        
        [~,CurrentPlotData] = Spike_Module_Calculate_Plot_ISI(Data,SpikeTimes,SpikePositions,SpikeCluster,SpikeChannel,Units,Waves,ISIfigs,str2double(AutorunConfig.ContinousUnitAnalysis.NumBins),str2double(AutorunConfig.ContinousUnitAnalysis.MaxTImeISI));
        
        if AutorunConfig.ExportDataThisBlock == 1
            Execute_Autorun_Export_Data(AutorunConfig,"Continuous Unit Analysis",Data,executableFolder,"ISI",CurrentPlotData,0);
        end
        CurrentPlotData = [];

        %% Plot Autocorrelogramme

        CurrentPlotData = Spikes_Module_AutoCorrelogram(Data,SpikeTimes,SpikePositions,SpikeChannel,SpikeCluster,AutoCfigs,Units,str2double(AutorunConfig.ContinousUnitAnalysis.NumBins),[],str2double(AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram));
        
        if AutorunConfig.ExportDataThisBlock == 1
            Execute_Autorun_Export_Data(AutorunConfig,"Continuous Unit Analysis",Data,executableFolder,"Auto",CurrentPlotData,0);
        end
        CurrentPlotData = [];

        if strcmp(Data.Info.Sorter,'Non')
            SpikeName = "Internal Spike Detection";
        else
            SpikeName = AutorunConfig.LoadfromSpikeSorting.Sorter;
        end

        UnitAnalysisFigure.Color = AutorunConfig.ComponentsInWindowColor;
        [UIAxes_1] = Execute_Autorun_Set_Plot_Colors(UIAxes_1,AutorunConfig);
        [UIAxes_2] = Execute_Autorun_Set_Plot_Colors(UIAxes_2,AutorunConfig);
        [UIAxes_3] = Execute_Autorun_Set_Plot_Colors(UIAxes_3,AutorunConfig);
        [UIAxes_4] = Execute_Autorun_Set_Plot_Colors(UIAxes_4,AutorunConfig);
        [UIAxes_5] = Execute_Autorun_Set_Plot_Colors(UIAxes_5,AutorunConfig);
        [UIAxes_6] = Execute_Autorun_Set_Plot_Colors(UIAxes_6,AutorunConfig);

        %% Plot Results if turned on
        if strcmp(AutorunConfig.SaveFigures,"on")
            if strcmp(Data.Info.SpikeType,"Internal")
                Execute_Autorun_Save_Figure(UnitAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat(SpikeName," Cont. Unit Analysis"), DataPath, " ", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ContWaveforms")
            else
                Execute_Autorun_Save_Figure(UnitAnalysisFigure, AutorunConfig.SaveFiguresFormat, AutorunConfig.DeleteFigureAfterSaving, strcat(SpikeName," Cont. Unit Analysis"), DataPath, " ", AutorunConfig.ExtractRawRecording.FileType, [], AutorunConfig.ExtractRawRecording.RecordingsSystem, LoadedData, "ContWaveforms")
            end
        end
        
    end
end