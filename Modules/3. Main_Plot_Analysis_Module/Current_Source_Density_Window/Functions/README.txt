This folder contains the following functions with respective Header:

 ###################################################### 

File: Analyse_Main_Window_CSD.m
%________________________________________________________________________________________

%% Main Function to calculate and plot current source density (CSD) for the main window data plot

% Note: LockCLim option determines, whether there should be a global limit
% for the colormap. If set to 1, the current clim is compared to the max of
% clim of previous csd plots. If current clims exceed the previous clims,
% global clim is set to current. Otherwise global clim remains unchanged. 

% Inputs:
% 1: hamwidth: Width of Hamm Window to smooth data in time and depth as
% uneven double, recommended: 5
% 2: ChannelSpacing: Channel spacing of probe in um as double
% (Data.Info.ChannelSpacing) NOTE: gets converted in mm!
% 3. ChannelSelection: GUI channel selection field as char, i.e. '1,10' --
% just for title!
% 4. CSDClim: 1 x 2 double, comes from CSD window and captures the clim of previous csd
% plots. This is used to compare to current clim and determine if colormap
% limits have to be changed. Only applies if LockCLim = 1, 
% 5. Figure: axes object of figure to plot CSD in
% DatatoPlot: nchannel x n timepoints single matrix of data to calculate csd with
% 6. TimeRangetoPlot: Time vector as double with one time point for each
% sample of DatatoPlot
% 7. Plottype: string, "Initial" if plotted for first time or if figure handles are
% supposed to be overwritten. "Non" otherwise 
% 8. LockCLim: 1 or 0 as double. 1 to only update clim when current clim
% exceeds global clim from csd window
% 9. TwoORThreeD: string, either "TwoD" or "ThreeD", specifies number of
% dimensions of plot
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. currentClim: global clim - either unchanged from previous csd plot if
% limits were no exceeded or current clim otherwise. 
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Analyse_Main_Window_Compute_CSD.m
%________________________________________________________________________________________

%% Function to calculate current source density (CSD) 
% gets called in 'Analyse_Main_Window_CSD' function

% Inputs:
% 1. dat: nchannel x ntimepoints single data matrix containing data
% 2: ds: Channel spacing of probe in um as double
% (Data.Info.ChannelSpacing) NOTE: gets converted in mm!
% 3: hamwidth: Width of Hamm Window to smooth data in time and depth as
% uneven double, recommended: 5

% Output:
% 1. csd: nchannel x time x csd matrix containing the current source density
% derivatives in mV/mm^2 (Note: one channel is lost!)
% 2. ds: Channel spacing of probe in mm as double

% Author: Michael Lippert, Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

