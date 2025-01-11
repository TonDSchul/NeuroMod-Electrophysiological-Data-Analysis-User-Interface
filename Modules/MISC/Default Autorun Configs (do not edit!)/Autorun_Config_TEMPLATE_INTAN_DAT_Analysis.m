function [AutorunConfig] = Autorun_Config_TEMPLATE_INTAN_DAT_Analysis(DisplayOrder)

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
% 'Extract_Event_Related_Data'
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

% What to execute

AutorunConfig.FunctionOrder = ["Extract_Raw_Recording","Static_Power_Spectrum","Preprocess_Continous_Data","Create_Spike_Sorting","Load_from_SpikeSorting","Continous_Spike_Analysis","Extract_Events","Extract_Event_Related_Data","Event_Spike_Analysis","Preprocess_Continous_Data","Extract_Event_Related_Data","Event_Analysis_ERP","Event_Analysis_CSD"];

% Channel and Events to Analyze
AutorunConfig.ChannelRange = []; % Empty for all channel, otherwise char, '1','2','3','4','5','6'...; Range is from 1 to NrChannel (NOT based on active channel names but number of available channel number!) --> '1,2,3' means first three active channel
AutorunConfig.EventRange = []; % Only necessary if events are extracted and analyzed, Empty for all events, otherwise char, '1,10' for events 1:10; (only two numbers allowed, '1','2','3','4' will not work!)

% General Information
AutorunConfig.StartFromFolder = 1; % specify 2 to skip the first folder in directory selected
AutorunConfig.ExtractMultipleRecordings = "on"; % "on" OR "off"; Set "on" to loop over multiple recordings in a folder (each recording in its own folder within the destination folder selected)

% Figures
AutorunConfig.SaveFigures = "on";
AutorunConfig.SaveFiguresFormat = "png"; % "png" OR "svg" OR "fig"
AutorunConfig.DeleteFigureAfterSaving = "on";

AutorunConfig.AutorunConfigName = "Intan .dat LFP and Spike Analysis";
AutorunConfig.SaveAutorunConfig = "on"; % For later reference, the config variable can be save along with the dataset to trace back parameters with which figures were created
AutorunConfig.twoORthree_D_Plotting = "TwoD"; % string, either "TwoD" OR "ThreeD"
AutorunConfig.AdditionalAmpFactor = []; % Additional signal amplification factor; empty for non, otherwise factor raw data gets multiplied with

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
AutorunConfig.ExtractRawRecording.RecordingsSystem = "Intan"; % Recoring system with which recording was made. 
AutorunConfig.ExtractRawRecording.FileType = "Intan .dat"; % "Intan .dat" OR "Intan .rhd" when RecordingsSystem = "Intan"; 
%______________________________________________________________________________________________________
%% 1.2 Load data saved with GUI
%______________________________________________________________________________________________________
AutorunConfig.LoadData.Format = '.dat'; % DO NOT EDIT! Data format in which data is loaded that was previously saved with the GUI. Input as char, only'.dat' -- .mat NOT supported!
%______________________________________________________________________________________________________
%% 1.3 Save data loaded in GUI
%______________________________________________________________________________________________________
AutorunConfig.SaveData.FileType = '.dat'; % DO NOT EDIT! Data format in which data is saved and can be loaded by the GUI again. Input as char, only'.dat' -- .mat NOT supported!
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

AutorunConfig.PreprocessCont.PreproMethod{1} = ["Filter"]; % Preprocessing method to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd" OR "StimArtefactRejection" OR multiple Inputs like ["Filter","Downsample"]
AutorunConfig.PreprocessCont.PreproMethod{2} = ["Filter"]; % "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd" OR StimArtefactRejection OR multiple Inputs like ["Filter","Downsample"]
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
AutorunConfig.PreprocessCont.CutTimeFromStart = '100'; % How much time in seconds should be cut from the start. Char, '10' will delete the first 10 seconds of the recording
AutorunConfig.PreprocessCont.CutTimeFromEnd = '100'; % How much time in seconds should be cut from the end. Char, '10' will delete the last 10 seconds of the recording
% Only if "ChannelDeletion" is selected as one of the PreproMethods
AutorunConfig.PreprocessCont.DeleteChannel = '1,2,3'; % Which channel should be deleted. Char, '1,2,3' means that the first three active channel get deleted. Same format as AutorunConfig.ChannelRange
% Only if "StimArtefactRejection" is selected as one of the PreproMethods
AutorunConfig.PreprocessCont.ArtefactRejetction.StimArtefactChannel = "DIN-04"; % Event channel which holds the time points of the stimulation. These are equal to the artefact time points
AutorunConfig.PreprocessCont.ArtefactRejetction.TimeAroundArtefact = "-0.05,0.3"; % Time around the artefact for which you want to correct (interpolate) data; in seconds
AutorunConfig.PreprocessCont.ArtefactRejetction.ChannelSelection = []; %char, empty for all channel, otherwise '1,30' for channel 1 to 30 (like AutorunConfig.ChannelRange)
%% 3.2 Static Power Spectrum
%______________________________________________________________________________________________________
AutorunConfig.StaticPowerSpectrum.PlotType = ["Band Power Individual Channel ","Band Power over Depth"]; % Analysis options for static power spectrum analysis. Input either string array or single strig. Options: "Band Power Individual Channel" OR "Band Power over Depth"
AutorunConfig.StaticPowerSpectrum.DataType = "Mean over all Channel"; % Data over which band power analysis over individual channel is calculated. Input as string, Options: "Channel Individually" OR "Mean over all Channel". This is not reuired when no 
AutorunConfig.StaticPowerSpectrum.DataSource = "Raw Data"; % "Raw Data" or "Preprocessed Data"
AutorunConfig.StaticPowerSpectrum.FrequencyRange = '0,1000'; % Frequency Range shown in Power Spectrum analysis. This only affects the plot and has no influence on the analysis. Input as char
AutorunConfig.StaticPowerSpectrum.Channel = '5'; % Channel for which power spectrum should be calculated (char). If DataType is specified as "Mean over all Channel", this input has no effect
%% 3.3 Analyse Spike Data
%______________________________________________________________________________________________________
% Kilosort Plots
AutorunConfig.ContSpikeAnalysis.KilosortPlotType = ["Spike Map","Spike Amplitude Density Along Depth","Cumulative Spike Amplitude Density Along Depth","Average Waveforms Across Channel","Spike Waveforms","Waveform Templates","Template from Max Amplitude Channel"]; % "Spike Map","Spike Amplitude Density Along Depth","Cumulative Spike Amplitude Density Along Depth","Average Waveforms Across Channel","Spike Waveforms","Waveform Templates","Template from Max Amplitude Channel","Spike Triggered LFP"
% Internal Spike Plots
AutorunConfig.ContSpikeAnalysis.InternalSpikePlotType = ["Spike Map","Average Waveforms Across Channel","Spike Amplitude Density Along Depth","Cumulative Spike Amplitude Density Along Depth","Spike Triggered LFP"]; % "Spike Map" OR "Average Waveforms Across Channel" OR "Spike Amplitude Density Along Depth" OR "Cumulative Spike Amplitude Density Along Depth" OR "Spike Waveforms" OR "Spike Triggered LFP"
% For Kilosort AND Internal Spikes:
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
AutorunConfig.ContSpikeAnalysis.Clustertoshow = "Non"; %'All' OR 'Non' OR '1' (or whatever clusternumber you want. Starts with 1!)
AutorunConfig.ContSpikeAnalysis.UnitsToPlot = ["1","2","3","4","5","6"]; % 'All' will create a folder named units with one plot for each unit, for the plots where it matters. Otherwise enter units manualy or leave empty for no unit specific plots. For multiple units as string array i.e. "1,2,3". For single unit single number as char!
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
%% 4.1 Extract Events and Data
%______________________________________________________________________________________________________
% Warning: ChannelOfInterest is the kind of event channel to extract from.
% 'DIN Inputs' only works for .dat Intan files, not .rhd files. If you have
% -rhd files and DIN Inputs, use the "Digital Inputs" argument
AutorunConfig.ExtractEventDataModule.ChannelOfInterest = 'DIN Inputs'; % For Intan Recordings:'Analog Input' OR 'Digital Inputs' OR 'AUX Inputs' OR 'DIN Inputs' as char; 
AutorunConfig.ExtractEventDataModule.EventType = 'Event Onset'; % char, Either 'Event Onset' or 'Event Offset' to determine whether rising or falling edge should be detected
AutorunConfig.ExtractEventDataModule.EventChannelSelection = '1'; %Determines How many and which event channel of the type specified above should be analysed. If you record 5 event channel but only three of them hold data, specify as char i.e '1,2,3' 
AutorunConfig.ExtractEventDataModule.EventSignalThreshold = '0.02'; % Threshold of event signal at which events are extracted as char
AutorunConfig.ExtractEventRelatedDataModule.EventChanneltoUse = []; %Name of the event channel to extract data from. Empty for the first one. Otherwise specify as string, like "DIN-04" or "ADC-01"
AutorunConfig.ExtractEventRelatedDataModule.TimeBeforeEvent = '0.1'; %Time in seconds extracted before events (HAS TO BE POSITIVE!) as char
AutorunConfig.ExtractEventRelatedDataModule.TimeAfterEvent = '0.7'; %Time in seconds extracted after events as char
AutorunConfig.ExtractEventRelatedDataModule.DataSource = "Preprocessed"; %"Raw" OR "Preprocessed" as char
%% 4.2 Prepro event related data
%______________________________________________________________________________________________________
% Trial/Event Deletion
AutorunConfig.PreproEventDataModule.TrialRejection = false; % false if you dont want this step to be executed
AutorunConfig.PreproEventDataModule.TrialsToReject = '1,4'; % char, specify events/trials to be deleted, i.e. '1,10' for trials 1 to 10
% Channel Deletion and Interpolation
AutorunConfig.PreproEventDataModule.ChannelRejection = false;
AutorunConfig.PreproEventDataModule.ChannelToReject = '1,5'; % char with two channel i.e. '1,10' for channel 1 to 10 or 1,1 for just channel 1

%% 4.3 Analyse event related signal
%______________________________________________________________________________________________________
AutorunConfig.AnalyseEventDataModule.DataSource = 'Raw Event Related Data'; % 'Raw Event Related Data' OR 'Preprocessed Event Related Data' as char. Only use "Preprocessed" if you preprocessed event related data before!
% ERP Settings
AutorunConfig.AnalyseEventDataModule.DistanceBetweenChannelPlots = '0.1'; % When multiple ERP are plotted, this is the scaling factor responsible for plotting th channel data apart from each other
AutorunConfig.AnalyseEventDataModule.SingleERPChannel = '7'; % How much is CSD data smoothed in time and space domain? Format: Char
% CSD Settings
AutorunConfig.AnalyseEventDataModule.CSDHammWindow = '7'; % How much is CSD data smoothed in time and space domain? Format: Char
AutorunConfig.AnalyseEventDataModule.tempcolorMap = "parula"; 
% Event Static Spectrum Settings
AutorunConfig.AnalyseEventDataModule.SpectrumPlotType = ["Band Power Individual Channel","Band Power over Depth"]; % string, either "Band Power Individual Channel" and/or "Band Power over Depth"
AutorunConfig.AnalyseEventDataModule.SpectrumDataType = "Mean over all Channel"; % Data over which band power analysis over individual channel is calculated. Input as string, Options: "Channel Individually" OR "Mean over all Channel". This is not reuired when no 
AutorunConfig.AnalyseEventDataModule.SpectrumDataSource = "Raw Event Related Data"; % "Raw Event Related Data" or "Preprocessed Event Related Data"
AutorunConfig.AnalyseEventDataModule.SpectrumFrequencyRange = '0,1000'; % Frequency Range shown in Power Spectrum analysis. This only affects the plot and has no influence on the analysis. Input as char
AutorunConfig.AnalyseEventDataModule.SpectrumChannel = '7'; % Channel for which power spectrum should be calculated (char). If DataType is specified as "Mean over all Channel", this input has no effect
% Time Freqency Power Settings
AutorunConfig.AnalyseEventDataModule.TFFrequencyRange = '2,120,120'; % Frequency range being displayed, input as char in the format: Lowest Frequency, Highest Frequency, Steps
AutorunConfig.AnalyseEventDataModule.TFChannelSelection = '10'; % char, channel to show the Time freuency power plot for
AutorunConfig.AnalyseEventDataModule.TFCycleWidth = '5,9'; % Cycle width as char in format : Lowest Width, Highest Width
AutorunConfig.AnalyseEventDataModule.TFPlotType = ["TF","ITPC"]; % 'Time Frequency' OR 'Intertrial Phase Clustering'; If just one: format is char!
AutorunConfig.AnalyseEventDataModule.TFPlotAddons = ["Total","PhaseLocked","NonPhaseLocked"]; % 'Phase independent' OR 'Phase locked' OR 'Non-phase locked'; If just one: format is char!
%% 4.4 Analyse event related spikes
%______________________________________________________________________________________________________
% Standard Settings
AutorunConfig.AnalyseEventSpikesModule.Plottype = ["Spike Map","Spike Rate Heatmap","Spike Triggered Average"]; %"Spike Map" OR "Spike Rate Heatmap" OR "Spike Triggered Average"

AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.depth_bin_size = []; %if empty: channelspacing is taken
AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.time_bin_size = 0.006; % app.GeneralSettings.Time bin size in seconds; % false if you dont want this step to be executed

AutorunConfig.AnalyseEventSpikesModule.SpikeRateNumBins = '100'; % Number of bins for the spike rate plots
AutorunConfig.AnalyseEventSpikesModule.Normalize = true; % Only for Heatmap and applicable if heatmap as plot type selected
AutorunConfig.AnalyseEventSpikesModule.BaselineWindow = '-0.2,-0.05'; % Window of event related data used to normalize (Before the event trigger)
AutorunConfig.AnalyseEventSpikesModule.TimeSpikeTriggeredAverage = '-0.005,0.1';

AutorunConfig.AnalyseEventSpikesModule.ClusterPlotOptions = "Non"; %'All' OR 'Non' OR '1' (or whatever clusternumber you want. Starts with 1!)
AutorunConfig.AnalyseEventSpikesModule.UnitsToPlot = []; % 'All' will create a folder named units with one plot for each unit, for the plots where it matters. Otherwise enter units manualy or leave empty for no unit specific plots. For multiple units as string array i.e. "1,2,3". For single unit single number as char!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Spike Module
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5.1 Internal Spike Detection
%______________________________________________________________________________________________________
AutorunConfig.InternalSpikeDetection.Detectionmethod = 'Quiroga Method'; % 'Quiroga Method' OR 'Threshold: Mean - Std' OR 'Threshold: Median - Std'
AutorunConfig.InternalSpikeDetection.Type = 'All Channel'; % 'All Channel' OR 'Individual Ch.'
AutorunConfig.InternalSpikeDetection.STDThreshold = '6'; % Number of standard deviations from mean to set threshold.
AutorunConfig.InternalSpikeDetection.Filterspikes = true;
AutorunConfig.InternalSpikeDetection.FilterSpikeTimeOffset = '3';
AutorunConfig.InternalSpikeDetection.FilterArtefactDepth = '200';

AutorunConfig.InternalSpikeDetection.FilterSpikeinSameWaveform = true; % false for no Filtering
AutorunConfig.InternalSpikeDetection.TimeSpantoCombineIndices = '0.001'; % in s

%% Spike Sorting
AutorunConfig.CreateSpikeSorting.Sorter = 'Mountainsort 5'; % which Spike sorter was used to analyze your data? Options: Kilosort4' OR 'Mountainsort 5' OR 'SpykingCircus 2' OR 'WaveClus 3'
AutorunConfig.CreateSpikeSorting.OpenSpikeInterface = '1';
AutorunConfig.CreateSpikeSorting.Preprocess = '1';
AutorunConfig.CreateSpikeSorting.PlotTraces = '0';
AutorunConfig.CreateSpikeSorting.PlotSortingResults = '0';
AutorunConfig.CreateSpikeSorting.LoadSorting = '0';
AutorunConfig.CreateSpikeSorting.KeepConsoleOpen = '0';
%%%%%%%%%%%%%%%%%%%%%%%%%%% For Spike Sorting Settings see below!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JUST for WaveClus 3!!!!!
AutorunConfig.InternalSpikeDetection.WaveClus3_SpikeSortingType = 'AllChannelTogether'; %% 'AllChannelTogether' OR IndividualChannel

%% 5.2 Save for SpikeSorting
%______________________________________________________________________________________________________
AutorunConfig.SaveforSpikeSorting.Sorter = 'SpikeInterface'; % which Spike sorter was used to analyze your data? Options: Kilosort' (for external Kilosort GUI) OR 'SpikeInterface' (for Mountainsort 5, SpykingCircus 2 and Kilosort 4 within SpikeInterface)
AutorunConfig.SaveforSpikeSorting.SaveFormat = 'double'; % 'int32' or 'int16' for external Kilosort GUI OR "double" as char for SpikeInterface
AutorunConfig.SaveforSpikeSorting.Dataset = 'Raw Data'; %'Raw Data' OR 'Preprocessed Data' to determine which part of the dataset is saved
%% 5.2 Load from SpikeSorting
%______________________________________________________________________________________________________
AutorunConfig.LoadfromSpikeSorting.Sorter = 'Mountainsort 5'; % which Spike sorter was used to analyze your data? Options: 'Kilosort SpikeInterface' (Kilosort 4) OR 'Kilosort external GUI' (Kilosort 4) OR 'Mountainsort 5' OR 'SpykingCircus 2' OR 'WaveClus 3'
AutorunConfig.LoadfromSpikeSorting.ScalingFactor = []; % ONLY FOR KILOSORT: char, This is the 'int32' scaling factor for conversion of kilosort amplitudes represented as integers back to mV. 
% If you know the sclaing factor, specify here - if not leave empty (recommended). The scalingfactor will be
% automatically created and aplied when you saved data for kilosort before.

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
                                        'radius_um', 100), ...
                      'sparsity', struct('method', 'snr', ...
                                         'amplitude_mode', 'peak_to_peak', ...
                                         'threshold', 0.25), ...
                      'filtering', struct('freq_min', 150, ...
                                          'freq_max', 7000, ...
                                          'ftype', 'bessel', ...
                                          'filter_order', 2), ...
                      'detection', struct('peak_sign', 'neg', ...
                                          'detect_threshold', 5), ...
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

AutorunConfig.CreateSpikeSorting.ParameterStructure.KS4 = struct( ...
            'batch_size', 60000, ...
            'nblocks', 1, ...
            'Th_universal', 9, ...
            'Th_learned', 8, ...
            'do_CAR', true, ...
            'invert_sign', false, ...
            'nt', 61, ...
            'shift', 'None', ...
            'scale', 'None', ...
            'artifact_threshold', 'None', ...
            'nskip', 25, ...
            'whitening_range', 32, ...
            'highpass_cutoff', 300, ...
            'binning_depth', 5, ...
            'sig_interp', 20, ...
            'drift_smoothing', [0.5, 0.5, 0.5], ...
            'nt0min', 'None', ...
            'dmin', 'None', ...
            'dminx', 32, ...
            'min_template_size', 10, ...
            'template_sizes', 5, ...
            'nearest_chans', 10, ...
            'nearest_templates', 100, ...
            'max_channel_distance', 'None', ...
            'templates_from_data', true, ...
            'n_templates', 6, ...
            'n_pcs', 6, ...
            'Th_single_ch', 6, ...
            'acg_threshold', 0.2, ...
            'ccg_threshold', 0.25, ...
            'cluster_downsampling', 20, ...
            'cluster_pcs', 64, ...
            'x_centers', 'None', ...
            'duplicate_spike_ms', 0.25, ...
            'scaleproc', 'None', ...
            'save_preprocessed_copy', false, ...
            'torch_device', 'auto', ...
            'bad_channels', 'None', ...
            'clear_cache', false, ...
            'save_extra_vars', false, ...
            'do_correction', true, ...
            'keep_good_only', false, ...
            'skip_kilosort_preprocessing', false, ...
            'use_binary_file', 'None', ...
            'delete_recording_dat', true ...
        );