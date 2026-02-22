This folder contains the following functions with respective Header:

 ###################################################### 

File: Analysis_Hilbert_Inspect_NarrowBand_Filterkernel.m
%________________________________________________________________________________________
%% Function to show the frequency response and filter gains of narrowband filter used for the hilbert filter.

%***********************
%% work in progress, not implemented yet!!!!!!!!!!!!
%***********************

% Inputs: 1.srate: Sampling rate of your signal in Hz as double
%         2.costumfrex: Frequency range of narrowband filter [min freq, max
%         frequ, steps from min to max freq] in Hz double
%         3.orderfactor: Order nr. for filter double
%         4.costumfilter: 1x2 double, Filter Width, Min and max in Hz [min freq, max freq]
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Analyse_Static_Power_Spectrum.m
%________________________________________________________________________________________

%% Function to compute static power spectrum of event related data using pwelch method
% This function organizes data based on GUI inputs, puts them into the
% matlab pwelch function and plots the results. This is plotted at standard
% whenever the power spectrum analysis window is opened

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: Figure: axes handle of a figure to plot results in
% 3: DataType: Char that specifies how data is processed before pwelch.
% Options: "Channel Individually" OR "Mean over all Channel"
% 4: DataSource: string which data to use to compute? Either "Raw Data" or "Preprocessed Data"
% 5: SelectedChannel: 1x2 double with channel over which pwelch is computed
% (when no mean over channel selected). [Start Channel, Stop Channel] = all
% channel from Start Channel to Stop Channel
% 6: ChannelText: String which channel is analyzed -- only if power
% spectrum over individual channel
% 7. FrequencyRangeHzEditField: char, holding frequency range user
% specified in Hz. Format: '1,100' for 1 to 100 Hz
% 8. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 9. PlotAppearance: structure holding current default of plot appearances
% like linewidth
% 10. SelectedEvents: 1 x 2 double holding events user seleted, i.e. [1,10]
% for events 1 to 10 
% 11. DataToExtractFrom: char, either 'Raw Data' or 'Preprocessed Data' to
% designate from which dataset component event related data was extracted
% from
% 12. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 13. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Baseline_Normalize.m
%________________________________________________________________________________________

%% Function to baseline normalize event related data
% takes channel by trials by time matrix with event related data before the
% actual analysis

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: DataToNormalize: channel x trials x time matrix with event related
% data to baseline normalize
% 3. TimeWindow: char with comma separated time range, baseline is calculated
% for i.e. (-0.2,0)
% 4. EventTimeWindow: all time points of event related potential in seconds (app.Data.Info.EventRelatedTime)
% 5. AnalysisType: char, type of event related analysis baseline is normalized
% for, either "ERP" OR "StaticSpec"

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Check_EventInput.m
%________________________________________________________________________________________
%% Function to check whether the selection of trigger in event related analysis windows is proper

% executed on starup of event related LFP analysis windows or when the user
% changes the selction of triggers

% Inputs: 
% 1. EventFieldValue: char, input of user
% 2. Data: main window data object
% 3. EventSelected: char, name of the event channel for which trigger are
% checked
% 4. EventDataType: char, either 'Raw Event Related Data' OR 'Preprocessed
% Event Related Data' -- prepro data can have less trigger
% 5. StartUp: double, 1 or 0 whether this function is execute on window
% startup or not
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Check_Event_Preprocessing.m
%________________________________________________________________________________________
%% Function to check whether event related data was preprocessed to fill selection dropdown menu

% executed when the user changes the for example the event channel
% selection for which Event related data is anylszed. This is bc
% preprocessing is bound to a certain event channel

% Inputs: 
% 1. Data: main window data object
% 2. EventChannelSelection: char, name of the event channel for which trigger are
% checked
% 3. CurrentValue: Currently selected value (either 'Raw Event Related Data' OR 'Preprocessed Event Related Data')
% --> this is so selection of prepro data can be preserved when selecting
% another event channel

% Outputs:
% 1. EventDataTypeField: Determined content of selection dropdown menu (dropdown.Items)
% 2. Value: Current value selected in the selection dropdown menu (dropdown.Value)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Compute_and_Plot_ERP_CSD.m
%________________________________________________________________________________________
%% Function to calculate and plot ERP and CSD for event analysis windows

% Called when clicking on ERP or CSD button in event related signal
% analysis window 

% Inputs: 
% 1. Data: data strcuture of main window, to simplfy inputs later on?!
% 2.Figure: axis handle to figure you want to plot in -- CSD plot or ERP
% all trials plot with mean as black line
% 3.Figure2: axis handle to figure you want to plot in -- ERP
% all channel plot with mean for each channel
% 4. EventRelatedData: nchannel x nevents x ntimepoints single matrix
% containing event related data
% 5. EventTime: double time vector of events with one time in seconds for
% each time point of the EventRelatedData variable (with negativ pre event time)
% 6. DataChannelSelected: 1 x 2 double with channelrange to be plotted;
% [1,10] means channel 1 to 10 
% 7. CSD: structure containing infos for csd: CSD.ChannelSpacing;
% CSD.HammWindow --> IMPORTANT: When empty: ERP plotted, when plopulated: CSD is
% plotted!!! this structure comes from the
% 'Event_Module_Organize_TF_Window_Inputs' function
% 8. rgbcolormap: nplots x 3 double matrix with rgb values for each line
% plotted (only for plotting multiple channel erp's with consistent colors)
% 9. PlotLineSpacing: factor as double that determines the spacing between
% plotted erp lines of different channel
% 10. Type: Detmerines what is plotted, Options: 'SingleERPOnly' for just
% erp plots of one channel over all events OR 'MultipleERPOnly' for just
% erp plot of each channel OR 'All' for both plots
% 11. TwoORThreeD: string, either "TwoD" or "ThreeD" to show plot in 2 or 3
% dimensions
% 12. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 13. PlotAppearance: structure holding info about plot appearances the user
% might have modified.
% 14. ERPChannel: char, Channel for ERP Plot on top
% 15. DataType: char, either 'Raw Event Related Data' or 'Preprocessed Event Related Data'
% 16. SingleChannelPlotType: ERP plot type of single channel plot on top.
% if 0: all trials in grey lines, mean in black line. 0: imagesc plot with
% every trial and ERP overlayed
% 17. EventNr: double, nr of trigger shown. So that in imagsc plot y axis labels
% can be spaced farther if there are many trigger
% 18.PreservePlotChannelLocations: double, 1 or 0 whether to preserve
% original spacing between active channel (in case of inactiove islands between active channel)
% 19. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 20. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds

% Outputs:
% 1. CSDClim
% 2. Trialplot: Handle to single trials of ERP plot for single channel
% 3. Meanplot: Handle to ERP of ERP plot for single channel
% 4. Eventplot: Handle to plotted event line of plots
% 5. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_ERP_IndividualLines.m
%________________________________________________________________________________________
%% Function to plot individual trigger lines and mean (ERP) in ERP analysis window

% Inputs: 
% 1. Data: data strcuture of main window, to simplfy inputs later on?!
% 2. EventRelatedData: nchannel x nevents x ntimepoints single matrix
% containing event related data
% 3.EventNr: double, nr of trigger shown. So that in imagsc plot y axis labels
% can be spaced farther if there are many trigger
% 4. EventTime: double time vector of events with one time in seconds for
% each time point of the EventRelatedData variable (with negativ pre event time)
% 5.Figure: axis handle to figure you want to plot in -- CSD plot or ERP
% all trials plot with mean as black line
% 6. DataType: char, either 'Raw Event Related Data' or 'Preprocessed Event Related Data'
% 7. ERPChannel: char, Channel for ERP Plot on top
% 8. SingleChannelPlotType: ERP plot type of single channel plot on top.
% if 0: all trials in grey lines, mean in black line. 0: imagesc plot with
% every trial and ERP overlayed
% 9. PlotAppearance: structure holding info about plot appearances the user
% might have modified.
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_ERP_MultipleLines.m
%________________________________________________________________________________________
%% Function to plot individual trigger lines and mean (ERP) in ERP analysis window

% Inputs: 
% 1. Data: data strcuture of main window, to simplfy inputs later on?!
% 2. EventRelatedData: nchannel x nevents x ntimepoints single matrix
% containing event related data
% 3. PlotLineSpacing: factor as double that determines the spacing between
% plotted erp lines of different channel
% 4. EventTime: double time vector of events with one time in seconds for
% each time point of the EventRelatedData variable (with negativ pre event time)
% 5. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 6. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds
% 7.Figure2: axis handle to figure on bottom of ERP window
% 8. Type: Detmerines what is plotted, Options: 'SingleERPOnly' for just
% erp plots of one channel over all events OR 'MultipleERPOnly' for just
% erp plot of each channel OR 'All' for both plots
% 9. DataChannelSelected: 1 x 2 double with channelrange to be plotted;
% [1,10] means channel 1 to 10 
% 10. rgbcolormap: nplots x 3 double matrix with rgb values for each line
% plotted (only for plotting multiple channel erp's with consistent colors)
% 11. PlotAppearance: structure holding info about plot appearances the user
% might have modified.
% 12. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Organize_TF_Window_Inputs.m
%________________________________________________________________________________________
%% Function to capture all inputs for the time frequency power calculations and organize them to calculate and plot later

% Called when clicking on Time Frequency Power button in event related signal
% analysis window 

% Inputs: 
% 1.Data: structure with GUI data - not needed here but always useful for
% modifications
% 2. ChannelSelectionDropDown: char with channel to plot from TF window;
%i.e. '1,10' for channel 1 to 10. -- if multiple channel, power is
%calculated over the mean of all channel
% 3. AnalysisType:
% 4. ActiveChannel
% 3. EventNumberSelectionEditField: char with selection which events should
% be part of the calculations, i.e. '1,10' for events 1 to 10. This affects
% the ERP and therefore the phase locked and non phase locked components
% when plotted.
% FrequencyRangeminmaxstepsEditField: char, comma separated numbers with
% min,steps,max frequency in Hz
% CycleWidthfromto23EditField: NOT Used anymore
% TriggerToCompare: char, comma separated numbers with trials to compare in
% wavelet coherence analysis like [1,2]
% ChannelToCompare: char, comma separated numbers with channel to compare in
% wavelet coherence analysis like [1,2]
% NumScales: number of scales for wavelet coherence (same as VoicesPerOctave parameter)

% Outputs:
% 1. TF: struc with all parameters neccessary for plotting event related
% time frequency analysis, see below for fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_PhaseSync_Main.m
%________________________________________________________________________________________
%% Function to manage phase analysis of event related data

% executed when the user changes the for example the event channel
% selection for which Event related data is anylszed. This is bc
% preprocessing is bound to a certain event channel

% Inputs: 
% 1. DataToCompute: channel x trials x time matrix with data to analyse
% 2 Time: 1 x n time vector for event related data
% 3. Figure1: plot figure handle to plot phase angle differences over time on
% unit circle
% 4. Figure3: plot figure handle to plot all to all phase synchronization
% 5. Figure4: plot figure handle to plot phase angle time series over
% channel
% 6. Figure5: plot figure handle to plot phase angle amplitude envelope over
% channel
% 7. Data: main data structure
% 8. ChannelToCompare: double 1 x 2 vector with channel to compare phase
% angles for in the unot circle
% 9. Cutoff
% 10. NarrowbandOrder: double, filter order of narrowband filter applied if
% necessary and for narrowband filter in ecHT method
% 11. ActiveChannel: 1 x n double with all currently active channel in the
% probe view window
% 12. DataTypeDropDown: either 'Raw Event Related Data' or 'Preprocessed Event Related Data' 
% 13. PlotAppearance: struc with appearances of plot components like line
% colors and linewidths
% 14. ColorMap: nchannel x 3 matrix with parula colormap
% 15. Method: char, Which method the user selcts to compute the phase angles,
% either "Endpoint Corrected Hilbert Transform" OR "Hilbert Transform" OR "Wavelet Convolution"
% 16. ForceFilterOFF: double 1 or 0, if 1 then additional filters liek
% narrowband and low pass for downsampling are disabled
% 17. ECHTFilterorder: double, filter order for narrowband in ecHT mehtod
% 18. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 19. WhatToDo: char, what to compute, either 'All' OR 'Startup' OR
% 'AllToAllDifferences' OR 'AnglesEnvelops'
% 20. BasedOnERP: 1 or 0, 1 of analssis is done with mean over all trials
% (ERP) or 0 for supertrial (not implemented yet, only 1 works)
% 21. ShowAnalyzedData: double 1 or 0, 1 to show data phase was calculated
% with rather than phase angle amplitude envelops
% 22. DataTypeSelected: char, dataset to extract event related data from,
% wither 'Raw Data' or 'Preprocessed Data'
% 23. LowPassSettings: struc with fields: LowPassSettings.Cutoff, LowPassSettings.FilterOrder
% 24. FilterType: Narrowband filter type used, either 'Butter' OR 'FIR'
% 25. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 26. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds

% Outputs:
% 1. texttoshow: text to show filter infoes in of filter steps that where
% applied
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Spectrogram2.m
%________________________________________________________________________________________
%% Function to create a spectrogram (for live analysis) with the corresponding matlab function for the main window data (or custom time points if decoupled from main window)


% Input Arguments:
% 1. Data: mian window data structure
% 2. DataToShow: char, either "Raw Data" or "Preprocessed Data" depending
% on what to show the analysis for
% 3. EventsToShow: double vector with event indicies i9n currently selected
% time window
% 4. ChannelToPlot: char, number of channel to analyze
% 5. Window: char, number of samples in each spectogram window
% 6. TF.FreqRange: char, comma separated numbers with start and stop
% frequency to show
% 7. LockCLim: 1 or 0 double, whether to lock the clim to the min or max
% value recording since analysis was started
% 8. DataType: char, type of data shown in the title
% 9. CurrentClim: double vector with highest and lowest c values recorded so far (for lock clim) 
% 10. Figure: app.UIAxes object of live window
% 11. SampleRate: double, sample rate of currently analysed data
% 12. PlotAppearance: struc with all appearances of plot components
% 13. Time: double vector with all time points in s that where analyzed
% 14. CurrentEventChannel: Currently selected event channel in main window
% that for which trigger times are shown in this window too
% 15. PlotEvent: 1 or 0 whether the user selected to plot events in the
% main window
% 16. CurrentPlotData: struc with plotted data being saved for later export
% 17. TwoORThreeD: char, "TwoD" or "ThreeD" depending on what the user
% selected

% Output:
% 1. CurrentClim: double vector with highest and lowest c values recorded so far (for lock clim) 
% 2. CurrentPlotData: struc with plotted data being saved for later export

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Time_Frequency_Hilbert_TimeFrequ_ITPC.m
%________________________________________________________________________________________
%% Function to calculate time frequency power and intertrial phase clustering using a filter hilbert.

%***********************
%% work in progress, not implemented yet!!!!!!!!!!!!
%***********************

% This function is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Note: Only supported for one channel that is specified in the "Channel"
% input. If input data matrix contains only one channel, the "Channel"
% variable has to be 1. All selected trials/events are concatonated to a supertrial. Every calculation is done with this
% supertrial and converted back to the original data format afterwards

% Inputs: 1. Data: Contains data of the currently selected animal, sessions
%                  and condition. Format: 3D Matrix with Channel x Trials x Time Points as
%                  dimensions. 
%         2. srate: Sampling rate in Hz
%         3. time: Vector containing time points (in seconds)
%         4. FreqRange: Frequency range of narrwoband filter [min frequ, max frequ, steps from min to max freq] in Hz
%         5. FilterRange: Filter width of narrowband filter [min freq, max freq] in Hz
%         6. FilterOrder: Order nr. of narrwoband filter
%         7. TrialsofInterest: Trials of the data matrix for which the  calculations are done [from, to]
%         8. Channel: Channel of interest (onyl one!).
%         9. BaselineNormalize: Whether you want your signal to be baseline normalized. 1 = yes, 2 = no. Time window is manually selected in line 48.

% Outputs: 1. tf: Result of the calculation with 4 dimensions. First indice of the first dimension is the result of the time frequency power 
%                 calculation, the second indidce the results of the ITPC. The other three dimensions are [Frequencies x time x power]
%          2. frex: Frequency range for which TF and ITPC was calculated (one dimensional vector) in Hz
%
% Output is plotted in the "Plot_HilbertTimeFrequency" function.
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Time_Frequency_Main.m
%________________________________________________________________________________________
%% Main Function to call correct TF analysis and plotting functions with correct event related data portion based on input in app window

% Called whenever a TF calculation is done to select the right function
% based on what analysis the user selected - first calls analysis function,
% the plotting function

% Inputs: 
% 1. Data: main window data structure
% 2. DataType: type of data event related data was extracted from, either "Raw Data" OR "Preprocessed Data" 
% 3. EventDataType: type of event related data, either "Raw Event Related
% Data" OR "Preprocessed Event Related Data"
% 4. Figure: Axes handle to figure to plot in
% 5. TF: structure with parameter for TF calculations, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 6. Window: char, window size for spectrogram (in samples)
% 7. TwoORThreeD: char, "TwoD" or "ThreeD" depending on what the user
% selected
% 8. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 9. PlotAppearance: structure holding info about plot appearances the user
% might have modified.
% 10. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 11. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds

% Outputs:
% 1. climsTF: clim of current plot, saved by TF window to be able to auto
% clim without calculating again
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Time_Frequency_Plot_Hilbert_TF.m
%________________________________________________________________________________________
%% Function to plot time Frequency power and intertrial phase using filter hilbert transformation

%***********************
%% work in progress, not implemented yet!!!!!!!!!!!!
%***********************

% Inputs: 
% 1. tf: 4D matrix with result of wavelet TF analysis (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 2. frex: Frequency range used for analysis as a 1 x nrfrequencies double  (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 3. time: time vector as double in seconds
% 4. costumfrex: frequency range from to as double vector [1,100] for 1 to
% 100 Hz -- only for ylim
% 5. OneTrial: For ITPC, 1 if only one event/trial plotted, 0 otherwise
% 6. Figure: axes handle to figure to plot in
% 7: BaselineNormalize: 1 if data was baseline normalized, 0 if not
% 8. TFType: "TF" OR "ITPC" to plot either Time frequency power or inter
% trial phase clustering.
% 9. Type: determines signal components for TF analysis: "Total" OR "NonPhaseLocked" OR
% "PhaseLocked"; NonPhaseLocked = Signal - ERP; Phaselocked = ERP; Total =
% both components

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Time_Frequency_Plot_WaveletTF.m
%________________________________________________________________________________________
%% Function to plot time Frequency power and intertrial phase using complex moorlet wavelets with varying wavelet widths 

% gets inputs from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles.m

% Inputs: 
% 1. Figure: axes handle to figure to plot in
% 2. time: time vector as double in seconds
% 3. costumfrex: frequency range from to as double vector [1,100] for 1 to
% 100 Hz -- only for ylim
% 4. tfcycle: 4D matrix with result of wavelet TF analysis (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 5. frexcycle: Frequency range used for analysis as a 1 x nrfrequencies double  (from Event_Module_Time_Frequency_Wavelet_ITPC_Cycles function)
% 6. OneTrial: For ITPC, 1 if only one event/trial plotted, 0 otherwise
% 7. Type: determines signal components for TF analysis: "Total" OR "NonPhaseLocked" OR
% "PhaseLocked"; NonPhaseLocked = Signal - ERP; Phaselocked = ERP; Total =
% both components
% 8. TFType: "TF" OR "ITPC" to plot either Time frequency power or inter
% trial phase clustering.
% 9. ChannelSelection: 1 x 2 double with channel to plot; i.e. [1,10] for
% channel 1 to 10
% 10. EventSelection: 1 x 2 double with events to plot; i.e. [1,10] for
% events 1 to 10
% 11. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs: 
% 1. climsTF: current clim as 1 x 2 vector of plot so that user can set auto clim in the
% GUI without having to calculate again
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Time_Frequency_Wavelet_ITPC_Cycles.m
%________________________________________________________________________________________
%% Function to calculate time Frequency power and intertrial phase using complex moorlet wavelets with varying wavelet widths to 
% tackle the time/frequency tradeoff.

% This function is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Note: If multiple Channels in input data. mean is calculated. All selected trials are concatonated to a supertrial. Every calculation is done with this
% supertrial and converted back to the original data format afterwards

% Inputs: 1. Data: Format: 3D Matrix with Channel x Trials x Time Points as
%                  dimensions. (Mean over channel when multiple channels) 
%         3. time: Vector containing time points (in seconds)
%         4. FreqRange: Frequency range of narrwoband filter [min frequ, max frequ, steps from min to max freq] in Hz
%         5. FilterRange: Filter width of narrowband filter [min freq, max freq] in Hz
%         6. Range_cycles: Range of cycles widths of wavelets (from, to). Range determines the resolution of the time and frequency domain.
%         Higher filter order favors time resolution while frequency resolution suffers. To accomodate this tradeoff, the the higher
%         the frequency the higher the cylce width (higher end of input range) to increase temporal resolution for higher frequencies
%         9. BaselineNorm: Whether you want your signal to be baseline
%         normalized. 1 = yes, 2 = no. Time window is manually selected in
%         line 47. TODO: implement option in GUI

% Outputs: 1. tf: Result of the calculation with 4 dimensions. First indice of the first dimension is the result of the time frequency power 
%                 calculation, the second indidce the results of the ITPC. The other three dimensions are [Frequencies x time x power]
%          2. frex: Frequency range for which TF and ITPC was calculated (one dimensional vector) in Hz
%
% Output is plotted in the "Event_Module_Time_Frequency_Plot_WaveletTF" function.
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Event_Module_Wavelet_Coherence.m
%________________________________________________________________________________________
%% Function to conduct wavelet coherence analysis (either between channel or trials)

% Inputs: 
% 1. Data: main window data structure
% 2. EventRelatedData1: nchannel x nevents x ntimepoints single matrix
% containing event related data for either the first trigger or channel
% selected for coherene
% 3. EventRelatedData2: nchannel x nevents x ntimepoints single matrix
% containing event related data for either the second trigger or channel
% selected for coherene
% 4. Window: char, window size in samples, not used
% 5. BaselineNormalize: not used
% 6. BaselineWindow: not used
% 7. TF: structure with parameter for TF calculations, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 8. CurrentClim: clim of current plot, saved by TF window to be able to auto
% clim without calculating again
% 9. Figure: Axes handle to figure to plot in
% 10. SampleRate: double
% 11. PlotAppearance: structure holding info about plot appearances the user
% might have modified.
% 12. Time: Time vector in seconds of event related data
% 13. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 14. TwoORThreeD: char, "TwoD" or "ThreeD" depending on what the user
% selected


% Output:
% 1. CurrentClim: clim of current plot, saved by TF window to be able to auto
% clim without calculating again
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Event_Power_Spectrum_Over_Depth.m
%________________________________________________________________________________________

%% Function to compute static power spectrum over probe depth for event related data
% This function contains and uses functions from the Spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes. 
% They are saved in: GUIPath/Modules/6.Spike_Module/Spike_Analysis/Modified_Spike_Repository and are modified to
% fit the purpose of this GUI
% Functions used from the Spike repository: 
% lfpBandPower
% plotLFPpower -- all modified for the purpose of this GUI

% NOTE: PowerSpecResults holds the results of the computations. Its not
% used here, bc computation for events is fast  enough to do it on the fly

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: DataSource: string which data to use to compute? Either "Raw Data" or "Preprocessed Data"
% 3: PowerSpecResults: structure, if already computed in current GUI instance: this is non empty and contains the results from the previous calculation.
% So the lengthy computation does not have to happen again and results can be plotted immediately
% 4: Bandpower: saves the current results from the computation for the
% plotting function (is not saved globaly)
% 5. FrequencyRangeHzEditField: char, holding frequency range user
% specified in Hz, Format: '1,100' for 1 to 100Hz
% 6. Figure: figure object to plot power over all frequencies
% 7. Figure_2: figure object to plot bandpower over low frequency ranges on the
% right
% 8. TextArea: app text are to display info in (progress of computing power
% over depth), can be empty if used outside of GUI
% 9. WhattoPlot: string, specifies which of the both plots should be
% plotted; "All" for power over all frequencies and bandpower of low frequency
% parts OR "Just Bandpower" for just bandpower of low frequency
% parts
% 10. TwoORThreeD: string, "TwoD" to show 2D plots OR "ThreeD" to show 3
% dimensional plots
% 11. CurrentPlotData: structure saving results to export.
% 12. SelectedEvents: 1 x 2 double holding events user seleted, i.e. [1,10]
% for events 1 to 10 
% 13. EventDataToExtractFrom: char, name of the event channel, event related
% data is extracted (to set time which depends on downsampling, which depends on whether the user selected raw or preprocessed data)
% 14.PreservePlotChannelLocations: double, 1 or 0 whether to preserve
% original spacing between active channel (in case of inactiove islands between active channel)
% 15. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 16. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds

% Outputs:
% 1. PowerSpecResults: always empty here
% 2. BandPower: Current analysis results. Replaced by PowerSpecResults if
% already computed
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

