This folder contains the following functions with respective Header:

 ###################################################### 

File: Analyse_Main_Plot_Get_PlotIndiciesandData.m
%________________________________________________________________________________________

%% Function to get the data indices and actual data from the part shown in the main window data plot

% Inputs:
% 1. app: Main window app object
% 2. DataTypeDropDown: char, from live phase sync window not main window!! either 'Raw Data' or 'Preprocessed Data'
% depending on what the user selects
% 3. StartIndex: double, Data index (from Data.Raw or Data.Preprocessed) at which the
% data snippet starts -----> only used if first 'if statement block' below
% is not triggered. It checks if data is downsampled in different
% situations and makes adjsutments accordingly
% 4. StopIndex: double, Data index (from Data.Raw or Data.Preprocessed) at which the
% data snippet ends -----> only used if first 'if statement block' below
% is not triggered. It checks if data is downsampled in different
% situations and makes adjsutments accordingly
% 5. Window: char, main window analysis window for which function is called
% 6. CoupleToMainWindow: logical 1 or 0 whether time in the live analysis
% plot is coupled to the main window plot

% Output:
% 1. StartIndex: double, Determined data index (from Data.Raw or Data.Preprocessed) at which the
% data snipeet starts
% 2. StopIndex: double, Determined data index (from Data.Raw or Data.Preprocessed) at which the
% data snipeet ends
% 3. DatatoPlot: channel x time matrix with currently viewed data snippet
% data
% 4. Time: time of current data snippet (in respect to whole recording)
% 5. Samplefrequency: double in Hz. In case data was downsampled
% autodetection here and correct sample rate later on.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_AllToAllSync.m
%________________________________________________________________________________________

%% Function to compute All to All channel phase synchronization 

% The first part of this function is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Inputs:
% 1. Figure3: handle to figure object of phase sync figure to plot in
% 2. Hilbert_Phases: hilbert phase results (in degree) --> angle(analytical hilbert signal)
% 3. PlotAppearance: structure holding information about plot appearances
% the user can select
% 4. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 5. SelectedChannel: ALl channel currently selected in the probe view
% window to compute phase sync for

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Hilbert_Echt_Wavelet.m
%________________________________________________________________________________________

%% Function to compute phase angle time series and amplitude envelope for a signal using different methods 

% The wavelet convolution method is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Inputs:
% 1. Data: nchannel x ntime matrix with the signal
% 2. Method: Which method the user selcts to compute the phase angles,
% either "Endpoint Corrected Hilbert Transform" OR "Hilbert Transform" OR "Wavelet Convolution"
% 3. ChannelToCompare: double vector, the two channel seelcted for phase
% angle differen polar plot in unit circle
% 4. Samplefrequency: double, in Hz. Not from Data.Info bc it was
% autodetected before if data was downsampled
% 5. Cutoff: 1x2 double, narrowband cutoff frequency for ecHT Method!
% 6. ECHTFilterorder: double, filter order of narrowband for ecHT method

% Outputs:
% 1. Phases: nchannel x ntime phase angle time series
% 2. PhasesUnwrapped: nchannel x ntime amplitude envelops
% 3. FilterSettings: cutoff frequency (lowe, higher)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Inst_Freq_Main.m
%________________________________________________________________________________________

%% Main Function to compute almost all phase sync measure available in phase syn analysis window

% Inputs:

% 1. DataToCompute: nchannel x ntime matrix with the signal
% 2. Time: 1 x n time vector with time of curent signal (in respect to whole recording)
% 3. Samplefrequency: double, in Hz. Not from Data.Info bc it was
% autodetected before if data was downsampled
% 4. Figure1: app object handle to figure to plot in --> polar plot for phase
% angles on unit circle
% 5. Figure3: app object handle to figure to plot in --> All to ALl sync plot
% 6. Figure4 : app object handle to figure to plot in --> phase angle time
% series
% 7. Figure5: app object handle to figure to plot in --> Amplitude
% envelope/data
% 8. Data: Main window data object
% 9. ChannelToCompare: 1 x 2 with both channel to compare in polar phase
% angle differences plot
% 10. Cutoff: narrowband cutoff for narrowbnad filter if it has to be
% applied (like for hilber transform), also used as cutoff for ecHT
% narrowband filter
% 11. NarrowbandOrder: double, order for barrowband filter
% 12. ActiveChannel: all currently active channel
% 13. DataTypeDropDown: either 'Raw Data' or 'Preprocessed Data' from live window data to extract from dropdown menu, 
% 14. PlotAppearance: structure holding information about plot appearances
% the user can select
% 15. GlobalYlim: double vector, highest ylim plotted since window was
% opened to lock ylim to biggest y value recorded
% 16. LockYLIM: either 1 or 0, if ylim should be locked to GlobalYlim
% 17. StartIndex: index of data (Data.Raw or Data.Preprocessed) at which
% currently anlyzed data snippet starts
% 18. StopIndex: index of data (Data.Raw or Data.Preprocessed) at which
% currently anlyzed data snippet ends
% 19. WhatToDo: char, what to compute, either 'All' OR 'Startup' OR
% 'AllToAllDifferences' OR 'AnglesEnvelops'
% 20. ColorMap: channel x 3 parula colormap
% 21. Method: Which method the user selcts to compute the phase angles,
% either "Endpoint Corrected Hilbert Transform" OR "Hilbert Transform" OR "Wavelet Convolution"
% 22. ForceFilterOFF: 1 or 0, whether to turn extra narrowband (for example
% for hilbert transform) on or off
% 23. ECHTFilterorder: double, filter order of narrowband for ecHT method
% 24. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 25. EventData: double vector with indices at which event trigger of the
% currently selected event channel happen (selected in main widnow) -->
% checks whether a trigger is within current window and plots the event
% time
% 26. SelectedEventIndice: indicie of event channel being selected in
% respect to cell array in Data.Info.EventChannelNames
% 27. EventPlot: char, either 'Events' to show event times within data
% plots or something else to not show it
% 28. ShowAnayzedData: either 1 or 0 whether to show amplitude envelops (0)
% or show data phase angle analysis is based on (1)
% 29. LowPassSettings: struc with fields: LowPassSettings.Cutoff, LowPassSettings.FilterOrder
% 30. FilterType: Narrowband filter type used, either 'Butter' OR 'FIR'

% Outputs:
% 1. GlobalYlim: double vector, highest ylim plotted since window was
% opened to lock ylim to biggest y value recorded --> if changed here, next
% time available
% 2. texttoshow: text to show filter infoes in of filter steps that where
% applied
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Phase_Angle_Differences_Polar.m
%________________________________________________________________________________________

%% Function to plot phase angle differences between two channel in a polar unit circle plot

% This function is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Inputs:
% 1. Channel1Data: 1 x n vector with data of channel 1 in currentlyx viewed
% data snippet
% 2. Channel2Data: 1 x n vector with data of channel 2 in currentlyx viewed
% data snippet
% 3. Figure1: handle to figure object to plot in
% 4. Time: 1 x n time vector of currently viewed data snippet ( in respect to whole recording time)
% 5. ChannelToCompare: 1x2 double channel numbers of Channel1Data and Channel2Data
% 6. PlotAppearance: structure holding information about plot appearances
% the user can select
% 7. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Plot_Events.m
%________________________________________________________________________________________

%% Function to plot a line when the currently analyzed data snippet for phase sync analysis contains an event trigger 

% Inputs:
% 1. Figure: object to figure that data was plotted in 
% 2. Data: Mian window data object containing all relevant data components
% 3. Time: 1 x n time vector of currently viewed data snippet ( in respect to whole recording time)
% 4. EventData: double vector with indices at which event trigger of the
% currently selected event channel happen (selected in main widnow) -->
% checks whether a trigger is within current window and plots the event
% time
% 5. MinValue: smallest value currently plotted (to know how tall lines has to be)
% 6. MaxValue: smallest value currently plotted (to know how tall lines has to be)
% 7. CurrentSampleRate: double, in Hz. Not from Data.Info bc it was
% autodetected before if data was downsampled
% 8. SelectedEventIndice: indice of event channel being selected in
% respect to cell array in Data.Info.EventChannelNames

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Plot_PhaseAngles.m
%________________________________________________________________________________________

%% Function to plot a phase angle time series for a given number of channel

% Inputs:
% 1. Data: Main window data object containing all relevant data components
% 2. Figure1: handle to figure object to plot phase angle timer series in 
% 3. Figure2: handle to figure object to amplitude envelope or data that
% was analyzed
% 4. Phases: 1 x n vector with phase angle time series in degree (from Analyse_Main_Window_Hilbert_Echt_Wavelet.m)
% 5. PhasesUnwrapped: 1 x n vector with amplitude envelope time series in degree (from Analyse_Main_Window_Hilbert_Echt_Wavelet.m)
% 6. AdjustedDownsampleRate: sample rate in Hz, adjusted bc it can it was
% potentially downsampled additionally to a new sample rate
% 7. CurrentTime: 1 x n time vector of currently viewed data snippet ( in respect to whole recording time)
% 8. GlobalYlim: 1 x 2 double with highest ylim values since the window was
% opened for the first time to lock ylim to that value as long as 
% LockYLIM = 1
% 9. LockYLIM: double either 1 or 0 whether to to lock the ylim to GlobalYlim
% 10. ColorMap: nchannel x 3 parula colormap
% 11. Method: Which method the user selcts to compute the phase angles,
% either "Endpoint Corrected Hilbert Transform" OR "Hilbert Transform" OR "Wavelet Convolution"
% 12. PlotAppearance: structure holding information about plot appearances
% the user can select
% 13. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 14. EventData: double vector with indices at which event trigger of the
% currently selected event channel happen (selected in main widnow) -->
% checks whether a trigger is within current window and plots the event
% time
% 15. SelectedEventIndice: indice of event channel being selected in
% respect to cell array in Data.Info.EventChannelNames
% 16. EventPlot: char, if 'Events' triggers is plotted if within data
% snippet, comes from main app window
% 17. ShowAnayzedData: double, 1 or 0, whether to plot amplitude envelope
% (if 0) or data snippet analysis was based on
% 18. DataToCompute: nchannel x time matric with data snippet to analyze (just used for dimensions)

% Outputs
% 1. GlobalYlim: 1 x 2 double with highest ylim values since the window was
% opened for the first time to lock ylim to that value as long as 
% LockYLIM = 1
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Populate_Processing_Info.m
%________________________________________________________________________________________

%% Function to write into textare of the phase sync window which preprocessing steps where applied automatically

% Inputs:
% 1. FlagActualDownsample: double, 1 or 0 , whether data was downsampled
% or not
% FlagActualLowPass: double, 1 or 0 , whether data was low pass filtered
% or not
% FlagActualBandpassdouble: double, 1 or 0 , whether data was narrowband filtered
% or not
% Samplefrequency: double, sample frequency after downsampling (or no downsampling)
% LowPassSettings: struc with fields: LowPassSettings.Cutoff, LowPassSettings.FilterOrder

% Outputs:
% 1. texttoshow: string to show in the text area object of the phase syn
% window

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

