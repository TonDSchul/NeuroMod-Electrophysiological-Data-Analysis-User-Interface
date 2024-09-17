This folder contains the following functions with respective Header:

 ###################################################### 

File: Analyse_Main_Window_Spectral_Density_Estimate.m
%________________________________________________________________________________________

%% Main Function to calculate and plot Spectral Density Estimate for specific frequency ranges for the main window data plot

% Note: LockYLim option determines, whether there should be a global limit
% for the y axis. If set to 1, the current ylim is compared to the max of
% ylim of previous power estimate plots. If current ylims exceed the previous ylims,
% global ylim is set to current. Otherwise global ylim remains unchanged. 

% Inputs:
% 1: Data: nchannel x n timepoints single matrix with data to compute
% frequency specific power estimates
% 2: SampleRate: in Hz as double (i.e. Data.Info.NativeSamplingRate)
% 3. Figure: axes object of figure to plot in
% DatatoPlot: nchannel x n timepoints single matrix of data to calculate csd with
% 4. TimeWindow: Time vector as double with one time point for each
% sample of Data
% 5. PDLim: 1 x 2 double, comes from Spectral_Power_Estimate_Window and
% captures the ylim of previous power plots. This is used to compare to current ylim and determine if y axis
% limits have to be changed. Only applies if LockYLim = 1, 
% 6. LockYLim: 1 or 0 as double. 1 to only update ylim when current ylim
% exceeds global ylim from Spectral_Power_Estimate_Window
% 7. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. currentYlim: global ylim - either unchanged from previous power estimate plot if
% limits were no exceeded or current ylim otherwise. 
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

