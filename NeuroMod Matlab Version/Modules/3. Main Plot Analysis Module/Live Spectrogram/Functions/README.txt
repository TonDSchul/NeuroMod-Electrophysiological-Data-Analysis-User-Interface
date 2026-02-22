This folder contains the following functions with respective Header:

 ###################################################### 

File: Analyse_Main_Window_Live_Spectrogram2.m
%________________________________________________________________________________________
%% Function to create a spectrogram (for live analysis) with the corresponding matlab function for the main window data (or custom time points if decoupled from main window)


% Input Arguments:
% 1. Data: mian window data structure
% 2. DataToShow: channel by time matrix with data to analyze
% 3. EventsToShow: double vector with event indicies i9n currently selected
% time window
% 4. ChannelToPlot: char, number of channel to analyze
% 5. Window: char, number of samples in each spectogram window
% 6. FrequencyRange: char, comma separated numbers with start and stop
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

File: Analyse_Main_Window_Wavelet_Coherence.m
%________________________________________________________________________________________
%% Function to conducr wavelet coherence analysis

% Input Arguments:


% Output:

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

