This folder contains the following functions with respective Header:

 ###################################################### 

File: Analyse_Main_Window_Static_Power_Spectrum.m
%________________________________________________________________________________________

%% Function to compute static power spectrum of a signal using pwelch method
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

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Continous_Power_Spectrum_Over_Depth.m
%________________________________________________________________________________________

%% Function to compute static power spectrum over probe depth
% This function contains and uses functions from the Spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes. 
% They are saved in: GUIPath/Modules/6.Spike_Module/Spike_Analysis/Modified_Spike_Repository and are modified to
% fit the purpose of this GUI
% Functions used from the Spike repository: 
% lfpBandPower
% plotLFPpower -- all modified for the purpose of this GUI

% NOTE: PowerSpecResults holds the results of the computations. If its not
% empty, its not computed again since it takes a long time. In this case
% the output BandPower is replaced by PowerSpecResults.

% NOTE: PowerSpecResults has a field for raw data and preprocessed data,
% since the spectrum can be computed for both 

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
% 12. ActiveChannel: double vector containing channel active in the probe
% view window

% Outputs:
% 1. PowerSpecResults: results of current computation or previously executed
%computation save in current GUI instance
% 2. BandPower: Current analysis results. Replaced by PowerSpecResults if
% already computed
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

