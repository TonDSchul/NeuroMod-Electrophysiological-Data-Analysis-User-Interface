This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_Calculate_Spikes_Times_In_Bin.m
%________________________________________________________________________________________
%% Function calculate the amount of spikes within a bin of time
% Note: If Samplingrate = 1 as input, spike rate is given as number of
% spikes per bin. When you input a proper Samplingrate > 1, this function
% returns the spike rate in Hz for each bin

% This function is called in the Event_Spikes_Plot_Spike_Rate,
% Continous_Spikes_Plot_Spike_Rate and 

% Inputs:
% 1. SpikeTimes: nspikes x 1 double with indicie if each spike in samples
% 2. SpikePositions: nspikes x 1 double with position of spike in um -- no
% needed yet but always useful
% 3: NumBins: Number of bins as double
% 4: BinSize: Size of each bin as double in samples
% 5: Samplingrate: as double in Hz
% 6. SpikeRateType: either "SpikeRateoverTime" or "SpikeRateoverChannel"

%Outputs:
% 1. SpikesPerBin: 1 x nbins double; If Samplingrate = 1 as input, spike rate is given as number of
% spikes per bin. When you input a proper Samplingrate > 1, this function
% returns the spike rate in Hz for each bin


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Check_For_Curation.m
%________________________________________________________________________________________

%%  Function to check whether manualy curation can be determined by new_cluster_id.json file being present

% This gets called in the
% 'Manage_Dataset_Module_Extract_Raw_Recording_Main' function when Intan is
% identified as the recording system

% Input:
% 1. Data: mian window data structure
% 2. SorterPath: char, path to the spike sorting results

% Output: 
% 1. Curation: 1 or 0 whether curation could be determined (1) or not (0)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Prepare_WaveForm_Window_and_Analysis.m
%________________________________________________________________________________________
%% Function to calculate and plot the selected number of waveforms to plot

% This function is called in the unit analysis window to prepare and check data for
% plotting

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% F1, F2.. = figure handles for figures 1 to 3 for current plot
% U1, U2.. = app.UnitSelection.Value for all 3 of those objects in the app
% window
% W1, W2.. = app.WaveSelection.Value for all 3 of those objects in the app
% window
% 3. Type: string representing what was changed by the user, either "U1" or
% "U2" or "U3" --> U1 when first unit input field was changed, U2 for
% second and so on
% 4. SpikeWindow: "EventWindow" when started from the event module,
% "ContinousWindow" when started from the continous module
% 5. TimeLagField: App widnow field with user input of time lag range in ms -
% single char, i.e. '20' for -20:20ms time lag

% Outputs

% 1. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 2. Waves: 1x3 cell array, each cell contains the nr of waveforms for a plot as a 1 x nunits vector
% 3. Wavefigs: structure, each field is a figure object handle to plot waveforms in
% 4. ISIfigs: structure, each field is a figure object handle to plot ISI's in
% 5. AutoCfigs: structure, each field is a figure object handle to plot Autocorrelogram in
% 6. SpikeTimes: nspikes x 1 with spike times in samples
% 7. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 8. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 9. SpikeWaveforms: nspikes x ntimewaveform matrix holding waveform for each
% spike
% 10. SpikeChannel: nspikes x 1 with nr of channel for each spike

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Prepare_WaveForm_Window_and_Analysis_Check_Inputs.m
%________________________________________________________________________________________
%% Function to check inputs for waveform plots in unit analyisis windows

% This function is called in the unit analysis window to prepare and check data for
% plotting. If the inputs have the wrong format, they are checked and
% autochanged if format was violated.

% Inputs:
% 1. W1: char, irst (most left)
% app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 2. W2: char, second (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 3. W3: char, third (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 4. BinSize: char, editfield of nr of bins to show
% 5. ISIMaxTime : char, editfield of max time for ISI to plot

% Outputs
% 1. W1: char, irst (most left)
% app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 2. W2: char, second (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 3. W3: char, third (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 4. BinSize: char, editfield of nr of bins to show
% 5. ISIMaxTime : char, editfield of max time for ISI to plot


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Set_Up_Spike_Analysis_Windows.m
%________________________________________________________________________________________
%% Function to prepare all spike analysis windows on startup
% This function fills in standard values and individual options to select in windows based on
% data components

% This function is called on startup of all spike analysis windows

% Inputs:
% 1. app: app object containing all components to fill out. This is the
% respective app window of the analysis the user selects
% 2. WindowType: not used yet. Can pass exact type of window openend if
% necessary
% 3. EventWindow: Either "EventWindow" when this function is called on startup
% of a event spike analysis window. "Non" otherwise

% Outputs
% 1. app: app object with individual fields having a char added to their
% Value fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Spike_Triggered_Average.m
%________________________________________________________________________________________
%% Function to prepare and execute spike triggered average analysis
% This function organizes inputs, checks for proper filtering of data (low pass and downsampled)
% and calls the functions to calculate and plot the Spike triggered average

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. SpikeTimes: nspikes x 1 with spike times in samples
% 3. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 4. Figure: handle to plot object to plot in 
% 5. ChannelSelection: 1x2 channelselcteion [from, to], i.e [1,10] for
% channel 1 to 10
% 6. appWindow: string, "Continous" or "Events", depending what module is
% executing this function
% 7. TextArea: text area object of window to plot nr of spikes and cluster
% in
% 8. TimeWindowSpiketriggredLFP: 1x2 double with time window to extract STA
% from
% 8. Plot: double, 1 to plot data, 0 if only computation required
% 9. TwoORThreeD: either "TwoD" or "ThreeD" for 2d or 3d plot
% 10. ClustertoShow: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 11. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 12.PreservePlotChannelLocations: double, 1 or 0 whether to preserve
% original spacing between active channel (in case of inactiove islands between active channel)

% Outputs
% 1. Data: data structure from the main window holding spike data
% 2. mnLFP: ndepth x ntime field triggered average
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spikes_Module_Get_Waveforms.m
%________________________________________________________________________________________
%% Function to extract biggest spike waveforms with amplitudes of each spike already given.

% This function is executed after Spike Detection and after loading
% kilosort spike data to extract waveforms for all spikes in a nspike x ntimewaveforms matrix.
% When average waveform over channel is selected as analyisis method, this
% function is also called to extract waveforms in a nchannel x nspikes x
% ntimewaveform matrix. (Waveform over all channel fo each spike)

% Inputs: 
% 1. Data: data structure from the main window holding spike data
% 2. SpikeTimes: nspikes x 1 with spike times in samples
% 3. SpikePositions: nspikes x 1 with nr of channel for each spike 
% 4. WaveFormType: "AverageWaveforms" for Waveform over all channel fo each
% spike when average waveform over channel analysis is selected OR
% something else for nspikes x ntimewaveform matrix

% Outputs:
% 1. Waveforms: nspikes x ntime  OR nchannel x nspikes x ntime 
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted --> i.e. when so close to time limits, that waveform cannot be
% extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spikes_Plot_Spike_Times.m
%________________________________________________________________________________________
%% Function to plot spike times with amplitude color coding
% This function uses a functions from the spike repository from Cortex Lab on Github: https://github.com/cortex-lab/spikes
%Function used: plotDriftmap -- function was modified to fit the purpose of this Toolbox

% This function is called on startup of the event spike windows and continous spike windows to plot the
% spike map or when the user selects spike map as visualization

% Inputs:
% 1. Type: Type of spike window calling this function: Either "Continous" OR "Eventrelated"
% 2. rgb_matrix: nunits x 3 double with rgb values to give unit plots
% colors
% 3. Time: 1 x ntime double with time in seconds
% 4. SpikeTimes: nspikes x 1 double with just spike time (in seconds) within the
% channelrange (negativ for spikes before event)
% 5. SpikePositions: nspikes x 1 double with spikeposition in um within the
% channelrange (for internal spikes: nchannel*Channelspacing)
% 6. SpikeCluster: nspikes x 1 double with unit/cluster indicie for spike
% as integer - for internal: just 1 since no clustering is done
% 7. SpikeAmps: nspikes x 1 double with just spike amplitudes within the
% channelrange
% 8. ChannelPositions: nchannelx2 double. :,1 is x coordinate (all 0 for
% linear probe), :,2 is y coordinate (cahnneldepth in um)
% 9. Figure: Figure axes handle to plot in
% 10. numCluster: double, number of cluster/units
% 11. Clustertoshow: char, 'All' OR 'Non' or number as char like '1' for
% unit 1
% 12. PlotEvents: 1 to plot eventlines, 0 if not
% 13. EventIndicies: 1xnevents double with indicies of events to plot (in samples)
% 14. ChannelSelection: 1x2 double with channelselction, i.e. [1,10] for
% channel 1 to 10
% 15. ChannelSpacing: double in um, from Data.Info.ChannelSpacing
% 16. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

%Output
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

