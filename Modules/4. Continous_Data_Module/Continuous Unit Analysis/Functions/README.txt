This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_Calculate_Plot_ISI.m
%________________________________________________________________________________________
%% Function to calculate and plot the ISI of a number of spikes

% This function is called in the unit analysis window when the ISI has to
% be computed

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. SpikeTimes: nspikes x 1 with spike times in samples
% 3. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 4. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 5. SpikeChannel: nspikes x 1 with nr of channel for each spike
% 6. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 7. Waves: 1x3 cell array, each cell contains the nr of waveforms for a plot as a 1 x nunits vector
% 8. figs: structure, each field is a figure object handle to plot in
% 9. NumBins: nr bins for ISI, as double
% 10. MaxISITime: Max ISI to be displayed in bar plot, as double in seconds
% 11. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. ISIs: ISI for seelcted time range that is plotted, 1 x nbins vector
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Waveforms_Plot_Waveforms.m
%________________________________________________________________________________________
%% Function to calculate and plot the selected number of waveforms to plot

% This function is called in the unit analysis window when the ISI has to
% be computed

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 3. Waveforms: nspikes x ntimewaveform matrix holding waveform for each
% spike
% 4. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 5. Waves: 1x3 cell array, each cell contains the nr of waveforms to plot as a 1 x nwaveforms vector
% 6. figs: structure, each field is a figure object handle to plot in
% 7. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spikes_Module_AutoCorrelogram.m
%________________________________________________________________________________________
%% Function to calculate and plot the Autocorrelogram for all spikes

% This function is called in the unit analysis window when the ISI has to
% be computed

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. SpikeTimes: nspikes x 1 with spike times in samples
% 3. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 4. SpikeChannel: nspikes x 1 with nr of channel for each spike
% 5. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 6. figs: structure, each field is a figure object handle to plot in
% 7. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 8. NumBins: nr bins for ISI, as double
% 9. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 10. TimeLag: double, Time lag in ms. I.e. 20 for -20 to 20ms

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

