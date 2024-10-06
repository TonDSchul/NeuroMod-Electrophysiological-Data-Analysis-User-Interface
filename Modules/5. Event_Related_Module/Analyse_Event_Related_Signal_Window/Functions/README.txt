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

File: Event_Module_Organize_TF_Window_Inputs.m
%________________________________________________________________________________________
%% Function to capture all inputs for the time frequency power calculations and organize them to calculate and plot later

% Called when clicking on Time Frequency Power button in event related signal
% analysis window 

% Inputs: 
% 1.Data: structure with GUI data - not needed here but always useful for
% modifications
% 2. Type: string, determines type of time frequency calculation; options: "Moorlet
% Wavelets" for complex moorlet wavelet convolution with varying cycle
% width OR "Filter Hilbert" For filter hilbert transform. NOTE: TODO: "Filter
% Hilbert" does not fully work yet!
%3. ChannelSelectionDropDown: char with channel to plot from TF window;
%i.e. '1,10' for channel 1 to 10. -- if multiple channel, power is
%calculated over the mean of all channel
% 4. EventNumberSelectionEditField: char with selection which events should
% be part of the calculations, i.e. '1,10' for events 1 to 10. This affects
% the ERP and therefore the phase locked and non phase locked components
% when plotted.
% 5. FrequencyRangeminmaxstepsEditField: char with frequency range for
% which TF is calculated in Hz, i.e. '1,120,100' for 1Hz to 100Hz in 120 steps
% 6. CycleWidthfromto23EditField: char with cycle width for complex moorlet
% wavelet. i.e. '4,9' This addressed the time/frequency tradeoff. The higher the
% frequency, the higher the temporal resolution of the TF analysis. Range determines
% difference in temporal resolution between high and low frequencies, low
% numbers means low temporal resolution, high numbers high temporal
% resolution.
% 7. FilterWidthHzminmaxstepsEditField: char with frequency Range for hilbert filter
% transform narrowband filter. Since this TF analysis is not working yet, this has
% no influence yet., i.e. '10,20'
% 8. FactorFilterOrderChangesforeachFrequEditField: char with filter order
% for hilbert filter transform narrowband filter; i.e. '3';

% Outputs:
% 1. DataChannelRange: Nr of Channel as double
% 2. DataChannelSelected: 1 x 2 vector of selected channel, from to, i.i
% [1,10] for channel 1 to 10 
% 3. EventNrRange: Channel Range as double vector from event 1 to
% last event
% 4. CSD: structure holding parameters for CSD. Of course it is set to
% empty bc here ionly TF is computed. 
% 5. TF: structure holding parameters for TF analysis. With fields:
%TF.Range_cycles: 1x2 double [from,to]
%TF.FreqRange: 1x3 double [from,steps,to]
%TF.FilterRange: 1x2 double [from,to]
%TF.FilterOrder 1x1 double

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
% 1. EventRelatedData: nchannel x nevents n ntimepoints single matrix with
% event related data.
% 2. Figure: Axes handle to figure to plot in
% 3. SampleRate: SampleRate as double in Hz
% 4. DataChannelSelected: 1 x 2 double vector with channels to take, i.e.
% [1,10] for channel 1 to 10, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 4. EventNrRange: 1 x 2 double vector with events to take, i.e.
% [1,10] for events 1 to 10, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 5. TimearoundEvent: 1 x 2 double vector time in seconds before event and after event, i.e.
% [0.2,0.5] for a time range of -0.2 to 0.5 NOTE: first element has to be
% positive, although its a negativ time.
% 6. TF: structure with parameter for TF calculations, comes from
% 'Event_Module_Organize_TF_Window_Inputs' function
% 7. Type: determines signal components for TF analysis: "Total" OR "NonPhaseLocked" OR
% "PhaseLocked"; NonPhaseLocked = Signal - ERP; Phaselocked = ERP; Total =
% both components
% 8. Plottype: "TF" OR "ITPC" to plot either Time frequency power or inter
% trial phase clustering.
% 9. WaveletType: determines type of TF analyisis, either "Moorlet
% Wavelets" OR "Filter Hilbert"; NOTE: TODO: "Filter Hilbert" does not work yet 
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

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

