This folder contains the following functions with respective Header:

 ###################################################### 

File: Analyse_Main_Window_LowPassFilter_SpikeRate.m
%________________________________________________________________________________________

%% Function to applie a low-pass Butterworth filter with zero phase distortion to spike rate

% Inputs:
% 1. SpikeRate - Vector of spike rates to be filtered as 1x nbins double vector.
% 2. cutoffFreq - is hard coded at line 29 -- but preserved if changed to manual input from GUI or somewhere else, as double.
% 3. samplingRate - Sampling rate of the SpikeRate as double in Hz.
% 4. filterOrder - Order of the Butterworth filter as double.
% 5. BinSize - not necessary here, but maybe for autosetting cutoff and
% filter order?!

% Output:
% 1. filteredData: 1 x nbins double Low-pass filtered SpikeRate .

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Spike_Rate.m
%________________________________________________________________________________________

%% Main Function to calculate and plot Spike Rate for the main window data plot

% NOTE: LockYLim option determines, whether there should be a global limit
% for the y axis. If set to 1, the current ylim is compared to the max of
% ylim of previous spike rate plots. If current ylims exceed the previous ylims,
% global ylim is set to current. Otherwise global ylim remains unchanged. 

% NOTE: Spike rate gets low pass filtered, when the duration for each bin
% is too small (smaller than 0.03s) to avoid artificially high spike rates

% Inputs:
% 1: Data: structure with field Data.Spikes for spike data and Data.Info
% for preprocessing infos
% 2. CurrentTimePoints: first sample indicie of data plotted in main window
% data plot as double 
% 3. TimeRangeViewBox: char; field in the top right of the main window that shows
% the duration of the data plotted to extract duration of the recording,
% i.e. '1.532s' -- dont forget the s at the end!!
% 4. BinRange: Number of bins as char, i.e. '100'
% 5. Figure: axes object of figure to plot in
% 6. TimeRangetoPlot: Time vector as double with one time point for each
% sample of Data
% 7. LockYLim: 1 or 0 as double. 1 to only update ylim when current ylim
% exceeds global ylim from Spike_Rate_Window
% 8: SampleRate: in Hz as double (i.e. Data.Info.NativeSamplingRate)
% 9. Channelselection: 1 x 2 double vector with channels to plot. [1,10]
% means channel 1 to 10 
% 10. Basically same as CurrentTimePoints -- ToDo
% 11. Basically same as CurrentTimePoints + length(TimeRangetoPlot) -- ToDo
% 12. PreprocDataPlotCheckBox: value of checkbox in main window to plot
% preprocessed data. This is necessary to handle downsampled data if it should exist


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

