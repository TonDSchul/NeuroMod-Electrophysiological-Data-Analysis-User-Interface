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
% 5: SelectedChannel: 1X2 double with channel over which pwelch is computed
% (when no mean over channel selected). [Start Channel, Stop Channel] = all
% channel from Start Channel to Stop Channel
% 6: ChannelText: String which channel is analyzed -- only if power
% spectrum over individual channel

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Continous_Power_Spectrum_Over_Depth.m
%________________________________________________________________________________________

%% Function to compute static power spectrum over probe depth
% This function contains and uses functions from the Spike repository from Nick Steinmetz on Github at https://github.com/cortex-lab/spikes. 
% They are saved in: GUIPath/Modules/6.Spike_Module/Spike_Analysis/Modified_Spike_Repository and are modified to
% fit the purpose of this GUI
% Functions used from the Spike repository: 
% lfpBandPower
% plotLFPpower -- all modified for the purpose of this GUI

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: DataSource: string which data to use to compute? Either "Raw Data" or "Preprocessed Data"
% 3: PowerSpecResults: structure, if already computed in current GUI instance: this is non empty and contains the results from the previous calculation.
% So the lengthy computation does not have to happen again and results can be plotted immediately
% 4: Bandpower saves the results from the computation if they should take
% place 

% Outputs:
%PowerSpecResults = results of current computation or previously executed
%computation save in current GUI instance
%BandPower 

% NOTE: PowerSpecResults has a field for raw data and preprocessed data,
% since the spectrum can be computed for both 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

