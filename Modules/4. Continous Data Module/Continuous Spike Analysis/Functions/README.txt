This folder contains the following functions with respective Header:

 ###################################################### 

File: Continous_Spikes_Check_Inputs.m
%________________________________________________________________________________________
%% Function to check, GUI inputs when Kilosort spikes analyzed. 
% This function chekcs the proper format of inputs. It takes the
% text editfields from the respective app window and checks the .Value char
% saved in it. If it obeys format, it is return as is. If not, it gets
% replaced by a standard value that also gets visible in the GUI. The
% function also checks whether there are too many channel, units and
% waveforms selected for a certain analysis which can not be plotted.

% This function gets called in the Continous_Spikes_Prepare_Plots function

% Inputs:
% 1. Data: main window data structure with time vector (Data.Time), raw data (for channel) and Info
% field
% 2. ChannelEditField: object holding app text with the field Value containing a char of the user input. Correct format: ChannelEditField.Value = '1,10' for channel 1 to 10. 
% 3. WaveformEditField: object holding app text with the field Value containing a char of the user input. Correct format: WaveformEditField.Value = '1,10' for waveforms 1 to 10. 
% 5. SpikeAnalysisType: Name as char of analysis done, Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR "Waveforms from Raw Data" OR
% "Average Waveforms Across Channel" OR "Waveforms Templates" OR "Template from Max Amplitude Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 6. SpikeRateBinsEditField: object holding app text with the field Value containing a char of the user input. Correct format: SpikeRateBinsEditField.Value = '100'

% Output:
% 1. ChannelEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 
% 2. WaveformEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 
% 3. Error: Indicates if an error happened consisting of too many channel,
% units and waveforms selcted which would result in a 3d matrix. Then the
% code stops and the user gets a message
% 4: SpikeRateBinsEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Delete_Spikes_Not_In_ChannelRange.m
%________________________________________________________________________________________
%% Function to take spike times and delete indicies outside of selected channel range

% This function is called whenever spike data is plotted to determine
% spikes in selcted channelrange/depth in the
% Continous_Spikes_Prepare_Plots function

% Inputs:
% 1. SpikeTimes: nspikes x 1 double in seconds
% 2. SpikePositions: nspikes x 1 double with position of spike in um (for internal spikes: nchannel * ChannelSpacing)
% 3: ChannelSpacing: as double in um (from Data.Info.ChannelSpacing)
% 4: Channel_Selection: 1 x 2 double with channelselction of user, i.e.
% [1,10] for channel 1 to 10
% 5: SpikeType: type of spike data as char, either 'Internal' OR 'Kilosort'

%Outputs:
% 1. SpikeTimes: nspikes x 1 double with indicie of each spike in samples
% in the selected range
% 2. SpikePositions: nspikes x 1 double with position of spike in um in the selected range 
% 3. SelectedChannelIndicies: nspikes x 1 logical with a 1 for spikes in
% range, 0 otherwise. This is used outside of this function to also delete
% indiceis in Spikes.Amps and Spikes.SpikeCluster or Spikes.Clusterposition

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Manage_Analysis_Plots.m
%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for continous internal spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some continous kilosort spikes analysis has to be done and plotted

% Inputs:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field
% 2. PlotInfo: structure containing user selected parameter for analysis.
% fields: PlotInfo.Ploteve nts, PlotInfo.PlotInfo.SpikeRateNumBins,
% PlotInfo.PlotInfo.ChannelSelection all as double, comes from
% Continous_Spikes_Prepare_Plots function
% 3. SpikePositions = N x 1 double or single with spike poisiton (integer specifying channel) of each spike
% (analyzed in internal spike detection) 
% 4. SpikeAmps = N x 1 double or single with amplitudes of each spike
% (analyzed in internal spike detection) to get biggest amplitude
% 5. SpikeTimes nspikes x 1 double with indcies of each spike
% 6. CluterPositions = N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: for internal spikes, no
% units get analyse. Therefore this vector has to be made up of just 1 
% 7. Figure: figure axes handle to plot spike times with amplitude
% colorscaling
% 8. TypeofAnalysis: string, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR "Waveforms from Raw Data" OR
% "Average Waveforms Across Channel" OR "Waveforms Templates" OR "Template from Max Amplitude Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 9: TextArea: object to app window text area showing number of spikes and
% cluster
% 10: Eventstoshow -- currently not used -- would be char of event channel
% name
% 11. rgbMatrix: nwaveforms x 3 double with rgb values for each waveform
% plotted
% 12. numCluster: double, number of individual untis/cluster
% 13. ClusterToShow: either single double number or chars 'All' OR 'Non'
% 14. Figure2: figure axes handle for spike rate over time 
% 15. Figure3: figure axes handle for spike rate over channel 
% 16. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 17. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Plot_Average_Waveforms.m
%________________________________________________________________________________________
%% Function to plot average waveforms over each channel for a single unit

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots and Continous_Internal_Spikes_Manage_Analysis_Plots function

%NOTE: it takes a nchannel x ntimewaveforms matrix as input,
%where the mean was already claculated over each waveform 

% Inputs:
% 1. Figure: fugire aces handle to plot in
% 2. Data: main window app structure (just needed for Data.Info to get samplerate)
% 3. ChannelSelection: 1x2 double with channelselection of user, i.e. [1,10]
% for channel 1 to 10 
% 4. UnitstoPlot: number of unit selected as double (just for title) 
% 5. MeanWaveform: nchannel x ntime matrix holding averaged waveform for
% each channel
% 6. ChannelSpacing: in um as double, from Data.Info.ChannelSpacing
% 7. SpikeType: char, Type of spike to analyse, either 'Kilosort' OR 'Internal'
% 8. WaveformsToPlot: 1x2 double with waveformselection of user, i.e. [1,10]
% for 10 waveforms
% 9. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Plot_Biggest_Amplitude_Spike.m
%________________________________________________________________________________________
%% Function to plot biggest template of waveforms
% Note: Each unit has a template for each channel. What is plotted here is
% the biggest of those templates

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots function

% Inputs:
% 1. Figure: Figure axes handle top plot in 
% 2. Data: main window data structure with Data.Spikes and Data.Info field; Data.Spikes with field Data.Spikes.BiggestAmplWaveform
% 4. units: unitselection as double, for title (waveform already extracted for just that unit)
% 5. rgbMatrix: ntemplates x 3 double with rgb values for each template 
% 6. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Plot_Spike_Rate.m
%________________________________________________________________________________________

%% Function to plot spike rate from kilosortData over time and over Channel
% Input:
% 1. Data: Data structure containing KilosortData
% 2. SpikeTimes nspikes x 1 double in seconds
% 3. SpikePositions = N x 1 double or single in um
% 4. CluterPositions = N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: if no spike clustering for
% internal spikes, all spikecluster are 1
% 5. TimeSpikeFigure: Figure handle to app.UIaxes_3 Spike Rate over time 
% 6. TemplateFigure: Figure handle to app.UIaxes_5 Spike Rate over channel 
% 7. Type: "Initial" when plotting for the first time after resetting,
% BinsizeChangeInitial when binsize was changed, "Non" when nothing
% 8. rgb_matrix: RGB values for each cluster to show them in different colors
% 9. numCluster: Number of clusters (saved under app.numCluster within Analyse_Kilosort_Window)
% 10. ClustertoShow: Number of cluster the user selected to highlight in their color. Can
% be "All" to show all cluster in their color, "Non" to show no colors or a
% number as a string to show only that cluster. 
% 11. numBins: Number of bins selectd in the analysis window (string or char)
% 12. ChannelSelection: 1x2 double with channel [from to], i.e. [1,10] for
% channel 1 to 10 
% 13. ChannelSpacing: as double in um, not required yet but always helpful
% to have
% 14. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Plot_Spike_Templates.m
%________________________________________________________________________________________
%% Function to plot template of spikes for each channel selected
% Note: Each unit has a template for each channel.

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots function

% Inputs:
% 1. Figure: Figure axes handle top plot in 
% 2. Data: main window data structure with Data.Spikes and Data.Info field; Data.Spikes with field Data.Spikes.BiggestAmplWaveform
% 3. ChannelSelection: 1x2 double with channel to plot the waveforms for,
% i.e. [1,10] for channel 1 to 10
% 4. units: unitselection as double (1-indexed!)
% 5. rgbMatrix: ntemplates x 3 double with rgb values for each template 
% 6. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Plot_Waveforms.m
%________________________________________________________________________________________
%% Function to plot spike rate from kilosortData over time and over Channel

% NOTE: This function takes waveforms of all spikes, the number of waveforms to
% plot and only plots the n biggest waveforms!

% Input:
% 1. Data: Data structure containing KilosortData
% 2. SpikeTimes nspikes x 1 double in seconds
% 3. SpikePositions = N x 1 double or single in um
% 4. SpikeCluster = N x 1 double or single with cluster/unit identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: if no spike clustering for
% internal spikes, all spikecluster are 1
% 5. Waveforms: nspikes x ntimewaveform matrix with waveforms for each
% spike
% 6. PlotInfo: structure containing user selected parameter for analysis. Comes from Continous_Spikes_Prepare_Plots.m function
% 7. ClusterSelection: Number of cluster the user selected to highlight in their color. Can
% be "All" to show all cluster in their color, "Non" to show no colors or a
% number as a string to show only that cluster. 
% 8. Figure: figure object handle to plot data in
% 9. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Continous_Spikes_Prepare_Plots.m
%________________________________________________________________________________________
%% Function to prepare plots for internal and kilosort continous spike analysis

% This function is called in the
% Continous_Kilosort_Spike_Window and Continous_Internal_Spike_Window app
% windows when something new has to be plotted. It prepares everything for
% the function that selects plotting functions based on input
% This means it checks the correct format of inputs, corrects it with
% standard values if necessary and pools them in a structure accessed later
% for analysis and plotting

% Inputs:
% 1. Data: main window app structure with Data.Info and Data.Spikes fields
% 2. ChannelEditField: text field of app containing userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10
% 3. WaveformEditField: text field of app containing userinput as char in
% the field WaveformEditField.Value, like '1,10' for waveforms 1 to 10
% 4. ClustertoshowDropDown: text field of app containing userinput as char in
% the field UnitsEditField.Value, like '1' for unit 1
% 5. DifferentInput -  not used now. Can be used to determine specific type
% of input at a certain time point
% 6. SpikeType: Type of spikes of dataset, either 'Kilosort' OR 'Internal'
% (from Data.Info.SpikeTpe)
% 7. SpikeAnalysisType: text field of app containing userinput as char in
% the field UnitsEditField.Value, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR "Waveforms from Raw Data" OR
% "Average Waveforms Across Channel" OR "Waveforms Templates" OR "Template from Max Amplitude Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 8. SpikeRateNumBinsEditField: text field of app containing userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins
% 9. TimeWindowSpiketriggredLFPEditField: text field of app containing userinput as char in
% the field TimeWindowSpiketriggredLFPEditField.Value, like '-0.005,0.2' 
% 10. ExecuteInGUI: Equals 1 if this function is called within the GUI, NOT
% the Autorun
% 11. Eventstoshow: char indicating the event to show in the plot; Either 'Non' or char with event channel name, like 'DIN-04'
% 12: Waveforms: nspikes x ntimewaveforms matrix with waveforms for each
% spikes (spikes in Data.Spikes.Waveforms)

%Outputs:
% 1. SpikeTimes: nspikes x 1 double in seconds and within the
% channelrange
% 2.SpikePositions: nspikes x 1 double with spike poisiton spike indicies within the
% channelrange (in um)
% 3.SpikeAmps: nspikes x 1 double with just spike amplitudes indicies within the
% channelrange
% 4. CluterPositions: nspikes x 1 double with just spike cluster ID's indicies within the
% channelrange
% 5. ChannelPosition: nchannel x 2 double matrix; :,1 = x ccordinates which are
% all 0 since this i s a single shank probe, :,2 = y coordinates/ channel
% depths in um
% 6. PlotInfo: structure holding gathered info about user input, contains
% field: PlotInfo.Units, PlotInfo.ChannelSelection;, PlotInfo.Waveforms, PlotInfo.NrWaveformsToExtract;, PlotInfo.SpikeRateNumBins
% 7. ChannelEditField: text field of app containing userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10 --
% corrected if format was wrong
% 8. WaveformEditField: text field of app containing userinput as char in
% the field WaveformEditField.Value, like '1,10' for waveforms 1 to 10 --
% corrected if format was wrong
% 9. UnitsEditField: text field of app containing userinput as char in
% the field UnitsEditField.Value, like '1' for unit 1 --
% corrected if format was wrong
% 10. SpikeRateNumBinsEditField: text field of app containing userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins --
% corrected if format was wrong
% 11. TimeWindowSpiketriggredLFPEditField: text field of app containing userinput as char in
% the field TimeWindowSpiketriggredLFPEditField.Value, like '-0.005,0.2' --
% corrected if format was wrong
% 12. WaveformChannel: if order of waveforms changed or waveforms deleted,
% this has to be capture in the channel for each waveform too. Unchanged,
% channel info comes from Data.Spikes.SpikePositions. Not necessary yet but
% usefull to have ready.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

