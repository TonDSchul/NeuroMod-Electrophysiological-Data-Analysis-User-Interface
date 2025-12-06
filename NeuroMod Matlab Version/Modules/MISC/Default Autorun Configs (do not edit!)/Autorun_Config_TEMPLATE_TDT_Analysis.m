function [AutorunConfig] = Autorun_Config_TEMPLATE_TDT_Analysis(DisplayOrder)

%% Options What to Execute
%______________________
%--- Manage Dataset ---
%______________________
% 'Extract_Raw_Recording'
% 'Load_Data'
% 'Save_Data'
%______________________
%--- Continous Module ---
%______________________
% 'Preprocess_Continous_Data'
% 'Static_Power_Spectrum'
% 'Continous_Spike_Analysis'
% 'Continous_Unit_Analysis'
%______________________
%--- Event Module ---
%______________________
% 'Extract_Events'
% 'Import_Events'
% 'Event_Spike_Analysis'
% 'PreproEventDataModule'
% 'Event_Analysis_ERP'
% 'Event_Analysis_CSD'
% 'Event_Static_Power_Spectrum'
% 'Event_Analysis_TimeFrequencyPower'
%______________________
%--- Spike Module ---
%______________________
% 'Internal_Spike_Detection'
% 'Create_Spike_Sorting'
% 'Load_from_SpikeSorting'
% 'Save_for_SpikeSorting'
% 'Open_in_Phy'

% What to execute
AutorunConfig.FunctionOrder = ["Extract_Raw_Recording","Extract_Events","Event_Analysis_ERP","Event_Analysis_CSD"];

% Whether true relations between active channel are display in analysis
% plots. This becomes relevant when you have inactive channel islands
% inbetween active channel or disable certain channel from for analysis (next variable)
AutorunConfig.PreservePlotChannelLocations = 1;

% Channel and Events to Analyze
AutorunConfig.ChannelRange = []; % Empty for all channel, otherwise char, '1','2','3','4','5','6'...; Range is from 1 to NrChannel (NOT based on active channel names but number of available channel number!) --> '1,2,3' means first three active channel

% General Information
AutorunConfig.StartFromFolder = 1; % specify 2 to skip the first folder in directory selected
AutorunConfig.ExtractMultipleRecordings = "on"; % "on" OR "off"; Set "on" to loop over multiple recordings in a folder (each recording in its own folder within the destination folder selected)

% Figures
AutorunConfig.SaveFigures = "on";
AutorunConfig.SaveFiguresFormat = "png"; % "png" OR "svg" OR "fig"
AutorunConfig.DeleteFigureAfterSaving = "on";

AutorunConfig.AutorunConfigName = "TDT LFP and Spike Analysis";
AutorunConfig.SaveAutorunConfig = "on"; % For later reference, the config variable can be save along with the dataset to trace back parameters with which figures were created
AutorunConfig.twoORthree_D_Plotting = "TwoD"; % string, either "TwoD" OR "ThreeD" to show image plots as 2D plots or as 3D plots
AutorunConfig.AdditionalAmpFactor = []; % Additional signal amplification factor; empty for non, otherwise factor raw data gets multiplied with

% Plot Appearance
AutorunConfig.ColorMode = 'DarkMode_Dark_Light'; % DarkMode_Light_Dark OR "DarkMode_Dark_Light" OR "LightMode_Dark_Light" OR "LightMode_Light_Dark"

% When Autorun window is openend, just the above information are taken to populate
% the fields that can be changed in the autorun window 
if strcmp(DisplayOrder,"Display Order")
    AutorunConfig.FunctionOrder = AutorunConfig.FunctionOrder';
    return;
end

%% Configure Variables for each Module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Manage Dataset Module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1.1 Extract Data from Raw Recordings
%______________________________________________________________________________________________________
AutorunConfig.ExtractRawRecording.CostumChannelOrder = true; % false if you dont want to change channelorder with a costum one
AutorunConfig.ExtractRawRecording.LibraryToUse = "NeuroMod Matlab"; % Either "NeuroMod Matlab" OR "NeuralEnsemble NEO Python Library"
AutorunConfig.ExtractRawRecording.NEOLeaveConsolOpen = 1; % Only when "NeuralEnsemble NEO Python Library"; Either 1 or 0. specify whteher python console opening to show progress of NEO data extracton should stay open with you having to press enter after it completed
AutorunConfig.ExtractRawRecording.NEOJustLoadRecording = 0; % Only when "NeuralEnsemble NEO Python Library"; Either 1 or 0, whether to load the files NEO saved to load into Matlab in a previous data extraction of that recording -- does not open python, all matlab intern
AutorunConfig.ExtractRawRecording.FormatToSaveAndReadIntoMatlab = "NEO Format to .mat Conversion"; % Either "NEO Format to .mat Conversion" OR "Costume files (.dat,.mat)"
AutorunConfig.ExtractRawRecording.NEOFormat = "Auto Detected Recording System"; % Either "Auto Detected Recording System" to let NEO automatically detect the format. OR "NEO + Recordingsystemname" like "NEO Neuralynx" or "NEO Plexon" or "NEO New Open Ephys Format" OR "NEO Legacy Open Ephys Format"

AutorunConfig.ExtractRawRecording.RecordingsSystem = "TDT Tank Data"; % Recoring system with which recording was made. 
AutorunConfig.ExtractRawRecording.FileType = "TDT .sev"; % "TDT .sev"

AutorunConfig.ExtractRawRecording.ChannelToExtract = "All"; % Either "All" to extract all channel from the recording or Matlab expressions like [1,2,3] or 1:3
%______________________________________________________________________________________________________
%% 1.2 Load data saved with GUI
%______________________________________________________________________________________________________
AutorunConfig.LoadData.Format = 'Saved NWB format'; % 'Saved NeuroMod format' OR 'Saved Neo readable .mat file' OR 'Saved NWB format' OR 'Saved SpikeInterface format'
%______________________________________________________________________________________________________
%% 1.3 Save data loaded in GUI
%______________________________________________________________________________________________________
AutorunConfig.SaveData.SaveFor = 'Other'; % 'NeuroMod' OR 'NEO' OR 'Other'
AutorunConfig.SaveData.SaveAs = 'NWB File (Neuroscience Without Borders)'; % '.dat' (NeuroMod) OR 'Neo Compatible .mat File' OR 'SpikeInterface Compatible Binary File' OR 'NWB File (Neuroscience Without Borders)'

AutorunConfig.SaveData.Whattosave = [1,1,1,1,1,0]; % 3. Whattosave: vector with 6 numbers being either a 1 or a 0. Each
% indicie of the vector stands for a component of the dataset. A 1 indicates, that this component
% should be save. Components in the correct order are:
% [Raw,Preprocessed,Events,Spikes,EventrelatedData,PreprocessedEventrelatedData] --> [1,1,1,0,0,0] saves raw data, preprocessed data and event time points

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Continous Data Module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3.1 Preprocess Continous Data
%______________________________________________________________________________________________________
% Preprocessing pipeline can be constructed by entering the corresponding
% prepro method names in the AutorunConfig.PreprocessCont.PreproMethod
% variable as a single string or string array. If you want to low pass filter and
% downsample (so 2 steps in the same preprocessing step), specify as AutorunConfig.PreprocessCont.PreproMethod{1} = ["Filter","Downsample"]
% Sometimes you want to apply preprocessing steps at different time points
% in your pipeline. If you for example want to do LFP and spike analysis in
% the same run, you have to specify two different filter for two differnt times in your pipeline.
% To do so, you can specify mutiple cells for
% AutorunConfig.PreprocessCont.PreproMethod and other parameters. The first
% cell is taken for the first time preprocessing is called, the second cell
% for the second occurance of preprocessing and so on. To first do LFP then
% Spike analysis, you can use:
% AutorunConfig.PreprocessCont.PreproMethod{1} = ["Filter","Downsample"]
% AutorunConfig.PreprocessCont.PreproMethod{2} = ["Filter"]
% NOTE: 

AutorunConfig.PreprocessCont.PreproMethod{1} = ["Filter"]; % Preprocessing method to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd" OR "ASR" OR "StimArtefactRejection" OR multiple Inputs like ["Filter","Downsample"]
AutorunConfig.PreprocessCont.PreproMethod{2} = ["Filter","Downsample"]; % "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd" OR "ASR" OR "StimArtefactRejection" OR multiple Inputs like ["Filter","Downsample"]
% Only if "Filter" is selected as one of the PreproMethods
AutorunConfig.PreprocessCont.FilterMethod{1} = "High-Pass"; % "High-Pass" OR "Low-Pass" OR "Narrowband" OR "Band-Stop" OR "Median Filter"
AutorunConfig.PreprocessCont.FilterMethod{2} = "Low-Pass"; % "High-Pass" OR "Low-Pass" OR "Narrowband" OR "Band-Stop" OR "Median Filter"
AutorunConfig.PreprocessCont.FilterType{1} = "Butterworth IR"; % "Butterworth IR" OR "FIR-1" OR "Firls" 
AutorunConfig.PreprocessCont.FilterType{2} = "Butterworth IR"; % "Butterworth IR" OR "FIR-1" OR "Firls" 
AutorunConfig.PreprocessCont.CuttoffFrequency{1} = "300"; % Cut off frequency for filters. Only requied when filter selected in PreproMethod field, Input as char in Hz
AutorunConfig.PreprocessCont.CuttoffFrequency{2} = "220"; % Cut off frequency for filters. Only requied when filter selected in PreproMethod field, Input as char in Hz
AutorunConfig.PreprocessCont.FilterDirection{1} = "Zero-phase forward and reverse"; % "Zero-phase forward and reverse" OR "Forward" OR "Reverse" OR "Zero-phase reverse and forward"
AutorunConfig.PreprocessCont.FilterDirection{2} = "Zero-phase forward and reverse"; % "Zero-phase forward and reverse" OR "Forward" OR "Reverse" OR "Zero-phase reverse and forward"
AutorunConfig.PreprocessCont.FilterOrder{1} = "3"; % Filter order for applied filter. Input as char. This only is required when a filter is selected as the methods field.
AutorunConfig.PreprocessCont.FilterOrder{2} = "3"; % Filter order for applied filter. Input as char. This only is required when a filter is selected as the methods field.
% Only if "Downsample" is selected as one of the PreproMethods
AutorunConfig.PreprocessCont.DownsampleRate = "1000"; % New downsampled sampling rate in Hz; input as char. This only is required when a filter is selected as the methods field.
% Only if "CutStart", "CutEnd" or "ChannelDeletion" is selected as one of the PreproMethods
AutorunConfig.PreprocessCont.CutTimeFromStart = '200'; % How much time in seconds should be cut from the start. Char, '10' will delete the first 10 seconds of the recording
AutorunConfig.PreprocessCont.CutTimeFromEnd = '100'; % How much time in seconds should be cut from the end. Char, '10' will delete the last 10 seconds of the recording
% Only if "ChannelDeletion" is selected as one of the PreproMethods
AutorunConfig.PreprocessCont.DeleteChannel = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15'; % Which channel should be deleted. Char, '1,2,3' means that the first three active channel get deleted. Same format as AutorunConfig.ChannelRange
% Only if "StimArtefactRejection" is selected as one of the PreproMethods
AutorunConfig.PreprocessCont.ArtefactRejetction.StimArtefactChannel = "DIN-04"; % Event channel which holds the time points of the stimulation. These are equal to the artefact time points
AutorunConfig.PreprocessCont.ArtefactRejetction.TimeAroundArtefact = "-0.05,0.3"; % Time around the artefact for which you want to correct (interpolate) data; in seconds
AutorunConfig.PreprocessCont.ArtefactRejetction.TriggerToSelect = []; %char, empty for all trigger, otherwise char with comma separated numbers, like '1,5,6,20'
%% Artefact Subaspace Reconstruction
AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.LineNoiseCriterion = '4'; % Matlab epxressions
AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.HighPassTransBand = '0.25,0.75';
AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.BurstCriterion = '5';
AutorunConfig.PreprocessCont.ArtefactSubSpaceReconst.WindowCriterion = '0.25';

%% 3.2 Static Power Spectrum
%______________________________________________________________________________________________________
AutorunConfig.StaticPowerSpectrum.PlotType = ["Band Power Individual Channel ","Band Power over Depth"]; % Analysis options for static power spectrum analysis. Input either string array or single strig. Options: "Band Power Individual Channel" OR "Band Power over Depth"
AutorunConfig.StaticPowerSpectrum.DataType = "Mean over all Channel"; % Data over which band power analysis over individual channel is calculated. Input as string, Options: "Channel Individually" OR "Mean over all Channel". This is not reuired when no 
AutorunConfig.StaticPowerSpectrum.DataSource = "Raw Data"; % "Raw Data" or "Preprocessed Data"
AutorunConfig.StaticPowerSpectrum.FrequencyRange = '0,1000'; % Frequency Range shown in Power Spectrum analysis. This only affects the plot and has no influence on the analysis. Input as char
AutorunConfig.StaticPowerSpectrum.Channel = '5'; % Channel for which power spectrum should be calculated (char). If DataType is specified as "Mean over all Channel", this input has no effect
AutorunConfig.StaticPowerSpectrum.UseCostumeWindowSize = 0; % 1 or 0 whether to use costume windowsize for pwelch 
AutorunConfig.StaticPowerSpectrum.WindowSize = 25000; % Only if UseCostumeWindowSize == 1; Window size for pwelch

%% 3.3 Analyse Spike Data
%______________________________________________________________________________________________________
% Kilosort Plots
AutorunConfig.ContSpikeAnalysis.AnalysisType = ["Spike Map","Spike Amplitude Density Along Depth","Cumulative Spike Amplitude Density Along Depth","Average Waveforms Across Channel","Spike Waveforms","Waveform Templates","Template from Max Amplitude Channel"]; % "Spike Map","Spike Amplitude Density Along Depth","Cumulative Spike Amplitude Density Along Depth","Average Waveforms Across Channel","Spike Waveforms","Waveform Templates","Template from Max Amplitude Channel","Spike Triggered LFP"
% For Sorting AND Internal Spikes:
AutorunConfig.ContSpikeAnalysis.EventChannelToPlot = "Non"; %Non for no event plotting, empty for first automatically taking the first channel, otherwise eventName specified as char, like 'DIN-04' or 'ADC-01'
AutorunConfig.ContSpikeAnalysis.TimeWindowSpiketriggredLFP = '-0.005,0.25'; %as char
AutorunConfig.ContSpikeAnalysis.NumBinsSpikeRate = "200"; % Number of bins for the spike rate plots as char
AutorunConfig.ContSpikeAnalysis.WaveformsToPlot = '1,100'; %as char
% Control Single Units in the above plots:
% Every plot specified above is plotted once with Clustertoshow as selected unit.
% If UnitsToPlot is non empty, all of the above plots will be plotted for
% each unit specified in UnitsToPlot and saved in a seperate folder calles
% "units". If UnitsToPlot is empty, just plots for Clustertoshow are
% created
AutorunConfig.ContSpikeAnalysis.Clustertoshow = "Non"; %For spike map and indication of cluster in all spikes plots. 'All' OR 'Non' OR '1' (or whatever clusternumber you want (just one cluster!). Starts with 1!)
%Individual Unit Analysis
AutorunConfig.ContSpikeAnalysis.UnitsToPlot = "1,2,3"; % 'All' will create a folder named units with one plot for each unit, for the plots where it matters. Otherwise enter units manualy or leave empty for no unit specific plots. For multiple units as string array i.e. "1,2,3". For single unit single number as char!
%% 3.4 Unit Analysis
%______________________________________________________________________________________________________
AutorunConfig.ContinousUnitAnalysis.NumBins = "150";
AutorunConfig.ContinousUnitAnalysis.MaxTImeISI = "0.15";
AutorunConfig.ContinousUnitAnalysis.TimeLagAutocorrelogram = "20";

AutorunConfig.ContinousUnitAnalysis.NumberWaveformsPlot1 = '20';
AutorunConfig.ContinousUnitAnalysis.NumberWaveformsPlot2 = '20';

AutorunConfig.ContinousUnitAnalysis.UnitsPlot1 = '1,2,3';
AutorunConfig.ContinousUnitAnalysis.UnitsPlot2 = '4,5,6';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Event Data Module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4.1 Extract Events Trigger
%______________________________________________________________________________________________________
% Warning: ChannelOfInterest is the kind of event channel to extract from.
% 'DIN Inputs' only works for .dat Intan files, not .rhd files. If you have
% -rhd files and DIN Inputs, use the "Digital Inputs" argument

AutorunConfig.ExtractEventDataModule.ChannelOfInterest = 'TDT Trigger scalars:Evnt'; % Options: 'TDT Trigger scalars:Evnt','TDT Trigger scalars:Tria','TDT Trigger epocs:Evnt','TDT Trigger epocs:Tria','TDT Trigger epocs:Brst','TDT Trigger epocs:Stro','TDT Trigger epocs:Tick'
AutorunConfig.ExtractEventDataModule.TriggerType = 'Rising Edge'; % do not change
AutorunConfig.ExtractEventDataModule.EventChannelSelection = '1'; %Determines How many and which event channel of the type specified above should be analysed. If you record 5 event channel but only three of them hold data, specify as char i.e '1,2,3' 
AutorunConfig.ExtractEventDataModule.EventSignalThreshold = ''; % not applicable
% Event Related Data
AutorunConfig.ExtractEventRelatedDataModule.TimeBeforeEvent = '0.3'; %Time in seconds extracted before events (HAS TO BE POSITIVE!) as char
AutorunConfig.ExtractEventRelatedDataModule.TimeAfterEvent = '0.6'; %Time in seconds extracted after events as char

AutorunConfig.ExtractEventRelatedDataModule.CombineEventChannel = []; % which event channel should be combined? Has to be part of AutorunConfig.ExtractEventDataModule.EventChannelSelection, Format: char, comma separated numbers or empty for no combination
AutorunConfig.ExtractEventRelatedDataModule.NewEventChannelName = 'Combined Event Channel 1'; % char, name of the newly created/combined event channel. So far in Autorun it is only possible to combine to a single event channel, not multiple ones so enter only one channel name. In the GUI you can combine to multiple event channel.

AutorunConfig.ExtractEventRelatedDataModule.LoadCosutmeTriggerIdentity = '0'; % char, 1 or 0 whether to to load costume trigger identity. If set to 1, widnow will open to ask you for the location of the file containing costume identites.

%% 4.2 Import Event Trigger
%______________________________________________________________________________________________________
AutorunConfig.ExtractEventDataModule.ImportEventChannelSelection = '1'; %Determines How many and which event channel of the type specified above should be analysed. If you record 5 event channel but only three of them hold data, specify as char i.e '1,2,3' 
AutorunConfig.ExtractEventRelatedDataModule.ImportTimeBeforeEvent = '0.3'; %Time in seconds extracted before events (HAS TO BE POSITIVE!) as char
AutorunConfig.ExtractEventRelatedDataModule.ImportTimeAfterEvent = '0.6'; %Time in seconds extracted after events as char
AutorunConfig.ExtractEventRelatedDataModule.EventNames = 'Event TTL Nr.1,Event TTL Nr.2'; % Name of the event channel you import. One name for each channel, format: comma separated within char like 'Event TTL Nr.1,Event TTL Nr.2'

%% 4.3 Prepro event related data
%______________________________________________________________________________________________________
AutorunConfig.PreproEventDataModule.EventChannelSelection = 'DIN-04'; % Event Channel for which you want to apply preprocessing
% Trial/Event Deletion
AutorunConfig.PreproEventDataModule.TrialRejection = false; % false if you dont want this step to be executed
AutorunConfig.PreproEventDataModule.TrialsToReject = '1:48'; % Matlab expression as char, specify events/trials to be deleted, i.e. '1:49' for trigger 1 to 49
% Channel Interpolation
AutorunConfig.PreproEventDataModule.ChannelInterpolation = false;
AutorunConfig.PreproEventDataModule.ChannelToInterpolate = '1:5'; % Matlab expression as charwith two channel i.e. '1:10' for channel 1 to 10 or 1,1 for just channel 1

%% 4.4 Analyse event related signal
%______________________________________________________________________________________________________
AutorunConfig.AnalyseEventDataModule.EventRelatedDataType = 'Raw Event Related Data'; % 'Raw Event Related Data' OR 'Preprocessed Event Related Data' as char. Only use "Preprocessed" if you preprocessed event related data before!
AutorunConfig.AnalyseEventDataModule.DataSourceToExtractFrom = 'Raw Data'; % Either 'Raw Data' or 'Preprocessed Data' to indicate whether ERP is extracted from raw or prepro dataset
AutorunConfig.AnalyseEventDataModule.EventChannelSelection = 'TDT Trigger scalars:Evnt Ch 1'; % Options: 'TDT Trigger scalars:Evnt','TDT Trigger scalars:Tria','TDT Trigger epocs:Evnt','TDT Trigger epocs:Tria','TDT Trigger epocs:Brst','TDT Trigger epocs:Stro','TDT Trigger epocs:Tick' PLUS 'Ch 1' or Ch 2 depending in the input channel selection
AutorunConfig.AnalyseEventDataModule.TriggerToAnalyze = 'All'; % Either 'All' to analyze for all event trigger or enter a char with comma separated values like '1,2,4,6,87,100'
AutorunConfig.AnalyseEventDataModule.ERPPlotType = 'ImageSC'; % Either 'ImageSC' OR 'Lines' to set plot type
% ERP Settings
AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots = '0.1'; % When multiple ERP are plotted, this is the scaling factor responsible for plotting th channel data apart from each other
AutorunConfig.AnalyseEventDataModule.SingleERPChannel = '7'; % How much is CSD data smoothed in time and space domain? Format: Char
% CSD Settings
AutorunConfig.AnalyseEventDataModule.CSDHammWindow = '7'; % How much is CSD data smoothed in time and space domain? Format: Char
AutorunConfig.AnalyseEventDataModule.tempcolorMap = "parula"; 
% Event Static Spectrum Settings
AutorunConfig.AnalyseEventDataModule.SpectrumPlotType = ["Band Power Individual Channel","Band Power over Depth"]; % string, either "Band Power Individual Channel" and/or "Band Power over Depth"
AutorunConfig.AnalyseEventDataModule.SpectrumDataType = "Mean over all Channel"; % Data over which band power analysis over individual channel is calculated. Input as string, Options: "Channel Individually" OR "Mean over all Channel". This is not reuired when no 
AutorunConfig.AnalyseEventDataModule.SpectrumFrequencyRange = '0,1000'; % Frequency Range shown in Power Spectrum analysis. This only affects the plot and has no influence on the analysis. Input as char
AutorunConfig.AnalyseEventDataModule.SpectrumChannel = '7'; % Channel for which power spectrum should be calculated (char). If DataType is specified as "Mean over all Channel", this input has no effect
% Time Freqency Power Settings
AutorunConfig.AnalyseEventDataModule.TFFrequencyRange = '2,120,120'; % Frequency range being displayed, input as char in the format: Lowest Frequency, Highest Frequency, Steps
AutorunConfig.AnalyseEventDataModule.TFChannelSelection = '10'; % char, channel to show the Time freuency power plot for
AutorunConfig.AnalyseEventDataModule.TFCycleWidth = '5,9'; % Cycle width as char in format : Lowest Width, Highest Width
AutorunConfig.AnalyseEventDataModule.TFPlotType = ["TF","ITPC"]; % 'Time Frequency' OR 'Intertrial Phase Clustering'; If just one: format is char!
AutorunConfig.AnalyseEventDataModule.TFPlotAddons = ["Total","PhaseLocked","NonPhaseLocked"]; % 'Phase independent' OR 'Phase locked' OR 'Non-phase locked'; If just one: format is char!
%% 4.5 Analyse event related spikes
%______________________________________________________________________________________________________
% Standard Settings
AutorunConfig.AnalyseEventSpikesModule.Plottype = ["Spike Map","Spike Rate Heatmap","Spike Triggered LFP"]; %"Spike Map" OR "Spike Rate Heatmap" OR "Spike Triggered LFP"

AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.depth_bin_size = []; %if empty: channelspacing is taken
AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.time_bin_size = 0.006; % app.GeneralSettings.Time bin size in seconds; % false if you dont want this step to be executed

AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins = '100'; % Number of bins for the spike rate plots
AutorunConfig.AnalyseEventSpikesModule.Normalize = true; % Only for Heatmap and applicable if heatmap as plot type selected
AutorunConfig.AnalyseEventSpikesModule.BaselineWindow = '-0.2,-0.05'; % Window of event related data used to normalize (Before the event trigger)
AutorunConfig.AnalyseEventSpikesModule.TimeSpikeTriggeredAverage = '-0.005,0.1';

AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions = "Non"; %'All' OR 'Non' OR '1' (or whatever clusternumber you want. Starts with 1!)
AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot = 'All'; % 'All' will create a folder named units with one plot for each unit, for the plots where it matters. Otherwise enter units manualy or leave empty for no unit specific plots. For multiple units as string array i.e. "1,2,3". For single unit single number as char!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Spike Module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5.1 Internal Spike Detection
%______________________________________________________________________________________________________
AutorunConfig.InternalSpikeDetection.Detectionmethod = 'Quiroga Method'; % 'Quiroga Method' OR 'Threshold: Mean - Std' OR 'Threshold: Median - Std'
AutorunConfig.InternalSpikeDetection.Type = 'All Channel Max Values'; % 'All Channel Max Values' OR 'All Channel' OR 'Individual Ch.'
AutorunConfig.InternalSpikeDetection.STDThreshold = '5.5'; % Number of standard deviations from mean to set threshold.
AutorunConfig.InternalSpikeDetection.Filterspikes = true;
AutorunConfig.InternalSpikeDetection.FilterSpikeTimeOffset = '3';
AutorunConfig.InternalSpikeDetection.FilterArtefactDepth = '200';

AutorunConfig.InternalSpikeDetection.FilterSpikeinSameWaveform = true; % false for no Filtering
AutorunConfig.InternalSpikeDetection.TimeSpantoCombineIndices = '0.001'; % in s

%% Spike Sorting
AutorunConfig.CreateSpikeSorting.Sorter = 'SpyKING CIRCUS 2'; % which Spike sorter was used to analyze your data? Options: 'Mountainsort 5' OR 'SpyKING CIRCUS 2' OR 'WaveClus 3'
AutorunConfig.CreateSpikeSorting.OpenSpikeInterface = '1';
AutorunConfig.CreateSpikeSorting.Preprocess = '1';
AutorunConfig.CreateSpikeSorting.PlotTraces = '0';
AutorunConfig.CreateSpikeSorting.PlotSortingResults = '0';
AutorunConfig.CreateSpikeSorting.LoadSorting = '0';
AutorunConfig.CreateSpikeSorting.KeepConsoleOpen = '1';
%%%%%%%%%%%%%%%%%%%%%%%%%%% For Spike Sorting Settings see below!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JUST for WaveClus 3!!!!!
AutorunConfig.InternalSpikeDetection.WaveClus3_SpikeSortingType = 'AllChannelTogether'; %% 'AllChannelTogether' OR IndividualChannel

%% 5.2 Save for SpikeSorting
%______________________________________________________________________________________________________
AutorunConfig.SaveforSpikeSorting.Sorter = 'SpikeInterface'; % which Spike sorter was used to analyze your data? Options: 'External Kilosort GUI' OR 'SpikeInterface' (for Mountainsort 5 and SpyKING CIRCUS 2 within SpikeInterface)
AutorunConfig.SaveforSpikeSorting.SaveFormat = 'double'; % 'int32' or 'int16' for external Kilosort GUI OR "double" as char for SpikeInterface
AutorunConfig.SaveforSpikeSorting.Dataset = 'Raw Data'; %'Raw Data' OR 'Preprocessed Data' to determine which part of the dataset is saved
%% 5.2 Load from SpikeSorting
%______________________________________________________________________________________________________
AutorunConfig.LoadfromSpikeSorting.Sorter = 'Mountainsort 5'; % which Spike sorter was used to analyze your data? Options: 'Kilosort 4 external GUI' OR 'Kilosort 3 external GUI' OR 'Mountainsort 5' OR 'SpyKING CIRCUS 2' OR 'WaveClus 3'
AutorunConfig.LoadfromSpikeSorting.ScalingFactor = []; % ONLY FOR KILOSORT: char, This is the 'int16' scaling factor for conversion of kilosort amplitudes represented as integers back to mV. 
% If you know the sclaing factor, specify here - if not leave empty (recommended). The scalingfactor will be
% automatically created and applied when you saved data for kilosort before.

% Wrap up by correcting dimensions to show in textarea of autorun window
if strcmp(DisplayOrder,"Get Settings")
    AutorunConfig.FunctionOrder = AutorunConfig.FunctionOrder';
end

%% Spike Sorter Settings
%% Mountainsort 5
AutorunConfig.CreateSpikeSorting.ParameterStructure.MS5 = struct('scheme', '2', ...
                      'detect_threshold', 5, ...
                      'detect_sign', -1, ...
                      'detect_time_radius_msec', 0.5, ...
                      'snippet_T1', 20, ...
                      'snippet_T2', 20, ...
                      'npca_per_channel', 3, ...
                      'npca_per_subdivision', 10, ...
                      'snippet_mask_radius', 250, ...
                      'scheme1_detect_channel_radius', 150, ...
                      'scheme2_phase1_detect_channel_radius', 200, ...
                      'scheme2_detect_channel_radius', 50, ...
                      'scheme2_max_num_snippets_per_training_batch', 200, ...
                      'scheme2_training_duration_sec', 300, ...
                      'scheme2_training_recording_sampling_mode', 'uniform', ...
                      'scheme3_block_duration_sec', 1800, ...
                      'freq_min', 300, ...
                      'freq_max', 6000, ...
                      'filter', false, ...
                      'whiten', true, ...
                      'delete_temporary_recording', true, ...
                      'n_jobs', 4, ...
                      'chunk_duration', '1s', ...
                      'progress_bar', true, ...
                      'mp_context', 'None', ...
                      'max_threads_per_process', 1);
%% SpykingCircus 2
AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2 = struct('general', struct('ms_before', 2, ...
                                        'ms_after', 2, ...
                                        'radius_um', 150), ...
                      'sparsity', struct('method', 'snr', ...
                                         'amplitude_mode', 'peak_to_peak', ...
                                         'threshold', 0.25), ...
                      'filtering', struct('freq_min', 150, ...
                                          'freq_max', 7000, ...
                                          'ftype', 'bessel', ...
                                          'filter_order', 2), ...
                      'detection', struct('peak_sign', 'neg', ...
                                          'detect_threshold', 7), ...
                      'selection', struct('method', 'uniform', ...
                                          'n_peaks_per_channel', 5000, ...
                                          'min_n_peaks', 100000, ...
                                          'select_per_channel', false, ...
                                          'seed', 42), ...
                      'apply_motion_correction', true, ...
                      'motion_correction', struct('preset', 'nonrigid_fast_and_accurate'), ...
                      'merging', struct('similarity_kwargs', struct('method', 'cosine', ...
                                                                    'support', 'union', ...
                                                                    'max_lag_ms', 0.2), ...
                                        'correlograms_kwargs', struct(), ...
                                        'auto_merge', struct('min_spikes', 10, ...
                                                             'corr_diff_thresh', 0.25)), ...
                      'clustering', struct('legacy', true), ...
                      'matching', struct('method', 'wobble'), ...
                      'apply_preprocessing', true, ...
                      'matched_filtering', true, ...
                      'cache_preprocessing', struct('mode', 'memory', ...
                                                     'memory_limit', 0.5, ...
                                                     'delete_cache', true), ...
                      'multi_units_only', false, ...
                      'job_kwargs', struct('n_jobs', 0.8), ...
                      'debug', false);