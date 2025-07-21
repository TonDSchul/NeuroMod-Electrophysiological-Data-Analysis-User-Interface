This folder contains the following functions with respective Header:

 ###################################################### 

File: Event_Spikes_Extract_Event_Related_Spikes.m
%________________________________________________________________________________________

%% Function to extract spikes within specified range around events
% This function takes all spikes and sorts for those in the event range
% every time, the window for event spike analysis is opened. It is saved as
% Data.EventRelatedSpikes structure, which gets overwritten every time

% This function gets called in the main window when the user clicks on run
% for event spike analysis (Internal and Kilosort)

% Input:
% 1. Data: main window data structure containing Spike Data and Data.Info for event
% infos (like the time range)
% 2. SpikeType: Type of spikes available, Options: 'Kilosort' OR
% 'Internal', from Data.Info.SpikeType
% 3. SpikeTriggereAverage: double, Either 1 to indicate that SpikeTriggereAverage
% is plotted. This means, that spike samples are not "normalized" to event
% time range. This enables to extract spike data from raw/preprocessed data. 0
% Otherwise

% Output
% 1. Data: main window data structure with added field Data.EventRelatedSpikes
% 2. Error: double, 1 if error occured, 0 otherwise

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Event_Spikes_Plot_Heatmap_Spike_Rate.m
%________________________________________________________________________________________

%% Function to compute and plot spike rate over depth (as a Heatmap)
% This function takes all spikes and sorts for those in the event range
% every time, the window for event spike analysis is opened. It is saved as
% Data.EventRelatedSpikes structure, which gets overwritten every time

% This function gets called in the main window when the user clicks on run
% for event spike analysis (Internal and Kilosort)

% Input:
% 1. SpikeTimes: nspikes x 1 double in seconds. Spike time before event is
% negativ
% 2. SpikePositions: nspikes x 1 double with spike positions (in um) - for
% internal: channelnr * ChannelSpacing
% 3. Figure: Figure axes object to plot in
% 4. SR: SampleRate as double in Hz
% 5. time_bin_size: double, Bin size in seconds
% 6. depth_edges: edges of depth bins (in um)
% 7. time_edges: edges of depth bins (in s)
% 8. nevents: number of events to divide spike rate by to normalize for a
% single trial/event
% 9. eventtime: double, Time in seconds to plot event line at (default at 0s)
% 10. Normalize: 1 to basline normalized, 0 if not
% 11. NormWindow: 1x2 double with min and max of time range (in seconds with negativ possible)
% 12. Clustertoshow: char, 'Non' OR 'All' or a single number like '4' for
% unit 4
% 13. ClusterIdentity: nspikes x 1 double with unit identitiy for each spike
% 14. rgbMatrix: nunits x 3 double with rgb values 
% 15. ChannelsToPlot: 1 x 2 double with channel to plot, i.e. [1,10] for
% channel 1 to 10 
% 16. ChannelSpacing: in um from Data.Info.ChannelSpacing
% 17. appWindow: char, 'Kilosort' OR 'Internal' to see which window it
% comes from
% 18. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 19. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Event_Spikes_Plot_Spike_Rate.m
%________________________________________________________________________________________

%% Function to compute and plot spike rate over for all channel combined and for individual channel over the whole time range
% This function takes spikes over all channel, calculates spike rate for
% all channel and the normalizes by channel nr. and event nr.

% This function gets called in the main window when the user clicks on run
% for event spike analysis (Internal and Kilosort)

% Input:
% 1. Data: main window data structure with Data.Info field
% 2. Time: 1 x ntime time points in seconds
% 3. Type: char when this function is called, "Initial" on startup and when plotting completly new OR "BinsizeChangeInitial" when just num bins change OR "NewCluster" when just the clusterselection in window changed
% 4. rgbMatrix: nunits x 3 double with rgb values for unit colors
% 5. SpikeTimes: nspikes x 1 double with spike indicies (in samples)
% 6. SpikePositions: nspikes x 1 double with spike positions (in um) - for
% internal: channelnr * ChannelSpacing
% 7. SpikeCluster: nspikes x 1 double with spike cluster identity (integer,
% 1-indexed)-
% 8. NumEvents: double, number of events to normaloze spike rate
% 9. Clustertoshow: char, 'Non' OR 'All' or a single number like '4' for
% unit 4
% 10. NumBins: double, number of bins to divide time in for spike rate per bin
% 11. SpikeRateTimeFigure: Figure axes for figure to plot spike rate over
% time in
% 12. SpikeRateChannelFigure:Figure axes for figure to plot spike rate over
% channel in
% 13. KilosortChannelPos: not used here. 
% 14. SampleRate: double in Hz
% 15. ChannelToPlot: 1x2 double with channel to plot, i.e. [1,10] for
% channel 1 to 10
% 16. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Event_Spikes_Prepare_Plots.m
%________________________________________________________________________________________
%% Function to prepare plots for internal and kilosort event spike analysis

% This function is called in the
% Events_Internal_Spike_Window and Events_Kilosort_Spike_Window app
% windows when something new has to be plotted. It prepares everything for
% the function that selects plotting functions based on input
% This means it checks the correct format of inputs, corrects it with
% standard values if necessary and pools them in a structure accessed later
% for analysis and plotting. This function also selects the spikes in the
% channalerange

% Inputs:

% 1. Data: main window app structure with Data.Info and Data.Spikes fields
% 2. EventRangeEditField: text field of app containing event range userinput as char in
% the field EventRangeEditField.Value, like '1,10' for events 1 to 10
% 3. ChannelSelectionField: text field of app containing channel range userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10
% 4. BaselineWindowField: text field of app containing basline window range userinput as char in
% the field ChannelEditField.Value, like '-0.005,0' for channel -0.005s to 0s
% 5. SpikeRateNumBinsEditField: text field of app containing basline num bins for spike rate userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins
% 6. SpikeType: Type of spikes of dataset, either 'Kilosort' OR 'Internal'
% (from Data.Info.SpikeTpe)
% 7. SpikeTriggereAverage: 1 if spiked triggered average is computed, 0
% otherwise
% 8. SpikeTriggeredAverageField: field of app window holding time range for
% spiked triggered average, as char, i.e. '-0.05,0.2'
% 9. SpikeBinSettings: structure, save numbins in time and depth domain for spike
% rate heatmap plot -- see Spike_Module_Set_Up_Spike_Analysis_Windows.m for
% standard. 

%Outputs:

% 1. PlotInfo: structure holding gathered info about user input, contains
% fields: PlotInfo.TimearoundEvent,PlotInfo.EventNr,PlotInfo.EventRange,PlotInfo.ChannelsToPlot,PlotInfo.Time,PlotInfo.ChannelNr,PlotInfo.SpikeRateNumBins,PlotInfo.depth_bin_size,PlotInfo.time_bin_size ,PlotInfo.depth_edges,PlotInfo.time_edges , PlotInfo.NormWindow
% 2. SpikeTimes: nspikes x 1 double with just spike indicies within the
% channelrange
% 3.SpikePositions: nspikes x 1 double with spike poisiton spike indicies within the
% channelrange (in um)
% 4.SpikeAmplitude: nspikes x 1 double with just spike amplitudes indicies within the
% channelrange
% 5. SpikeCluster: nspikes x 1 double with just spike cluster ID's indicies within the
% channelrange
% 6. SpikeEvents: nspikes x 1 double with just event identity (integers)
% 7. BaselineWindowField: text field of app containing basline window range userinput as char in
% the field ChannelEditField.Value, like '-0.005,0' for channel -0.005s to 0s
% 8. ChannelSelectionField: text field of app containing channel range userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10
% 9. EventRangeEditField: text field of app containing event range userinput as char in
% the field EventRangeEditField.Value, like '1,10' for events 1 to 10
% 10. SpikeRateNumBinsEditField: text field of app containing basline num bins for spike rate userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Events_Internal_Spikes_Manage_Analysis_Plots.m
%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for event internal spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some event internal spikes analysis has to be done and plotted

% Inputs:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field
% 2. EventRangeEditField: user input for events to show, char 'from, to',
% i.e. '1,10' for events 1 to 10;
% 3. Figure: figure object handle to main plot in the middle of the window
% 4. AnalysisTypeDropDown: string, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR Channel Waveforms OR
% "Average Waveforms Across Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 5. SpikeRateNumBinsEditField: user input for number of bins of spike rate plots, char,
% i.e. '100' for 100 bins
% 6. TextArea: internal event spike app window textarea to show number of
% spikes and cluster
% 7. rgbMatrix: nwavefors x 3 matrix, with RGB values for each waveform/template to
% be plotted to ensure consistency of colors
% 8. ChannelSelectionforPlottingEditField: user input for cahnnel to show, char 'from, to',
% i.e. '1,10' for channel 1 to 10;
% 9. BaselineWindowStartStopinsEditField: user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.2,0' for -200ms to 0ms timw window as baseline
% 10. BaselineNormalizeCheckBox: check box whether baseline normalization should be applied. BaselineNormalizeCheckBox.Value is either
% 1 if checked or 0 if not
% 11. TimeWindowSpiketriggredLFPEditField:  user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.05,0.2' for -5ms to 200ms timw window as baseline
% 12. Figure2: figure object handle to plot spike rate over time 
% 13. Figure3: figure object handle to plot spike rate over time 
% 14. TwoORThreeDchar: either "TwoD" or "ThreeD" for 2d or 3d plot
% 15. numCluster: double, number of different units/cluster found in spike
% sorting
% 16. ClustertoShowDropDown: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 17. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. Data: main app data structure 
% 2. ChannelSelectionforPlottingEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 3. EventRangeEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 4. SpikeRateNumBinsEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 5. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Events_Spikes_Manage_Analysis_Plots.m
%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for event kilosort spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some event kilosort spikes analysis has to be done and plotted

% Inputs:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field
% 2. EventRangeEditField: user input for events to show, char 'from, to',
% i.e. '1,10' for events 1 to 10;
% 3. Figure: figure object handle to main plot in the middle of the window
% 4. AnalysisTypeDropDown: string, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR Channel Waveforms OR
% "Average Waveforms Across Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 5. SpikeRateNumBinsEditField: user input for number of bins of spike rate plots, char,
% i.e. '100' for 100 bins
% 6. TextArea: internal event spike app window textarea to show number of
% spikes and cluster
% 7. rgbMatrix: nwavefors x 3 matrix, with RGB values for each waveform/template to
% be plotted to ensure consistency of colors
% 8. numCluster: double, number of different units/cluster found in spike
% sorting
% 9. ClustertoShowDropDown: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 10. ChannelSelectionforPlottingEditField: user input for cahnnel to show, char 'from, to',
% i.e. '1,10' for channel 1 to 10;
% 11. BaselineWindowStartStopinsEditField: user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.2,0' for -200ms to 0ms timw window as baseline
% 12. BaselineNormalizeCheckBox: check box whether baseline normalization should be applied. BaselineNormalizeCheckBox.Value is either
% 1 if checked or 0 if not
% 13. TimeWindowSpiketriggredLFPEditField:  user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.05,0.2' for -5ms to 200ms timw window as baseline
% 14. Figure2: figure object handle to plot spike rate over time 
% 15. Figure3: figure object handle to plot spike rate over time 
% 16. TwoORThreeDchar, either "TwoD" or "ThreeD" for 2d or 3d plot
% 17. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 18. SpikeBinSettings: structure, save numbins in time and depth domain for spike
% rate heatmap plot -- see Spike_Module_Set_Up_Spike_Analysis_Windows.m for
% standard. 

% Outputs:
% 1. Data: main app data structure 
% 2. ChannelSelectionforPlottingEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 3. EventRangeEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 4. SpikeRateNumBinsEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 5. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

