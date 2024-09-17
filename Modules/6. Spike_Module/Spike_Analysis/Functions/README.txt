This folder contains the following functions with respective Header:

 ###################################################### 

File: Continous_Internal_Spikes_Check_Inputs.m
%________________________________________________________________________________________
%% Function to cheks whther user inputs for cintinous internal spike analysis are correct

% This function takes textfield objects of the cont. spike window, checks
% the input and replaces the value with a standard value when there is a
% format error. Output variables are taken directly as new values for
% textfield to visualzie autochange to standaradvalue if format error
% detected

%gets called in the Continous_Spikes_Prepare_Plots function

% Inputs: 
% 1.Data: Data structure with raw data for channel number used as standardvalue
% 2. ChannelEditField: char with channel selection of user. 
% 3. WaveformEditField: char with waveform selection of user. 
% 4. SpikeRateNumBinsEditField: char with spike rate bins selection of user. 
%-- all of the inputs have to be in the forma '1,10' with positive integers
%and so on.

% Outputs:
% 1. ChannelEditField: char with channel selection of user. 
% 2. WaveformEditField: char with waveform selection of user. 
% 3. SpikeRateNumBinsEditField: char with spike rate bins selection of user. 
%-- only changed when format error

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Internal_Spikes_Manage_Analysis_Plots.m
%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for continous internal spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some continous internal spikes analysis has to be done and plotted

% Inputs:
% 1. TypeofAnalysis: string, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR Channel Waveforms OR
% "Average Waveforms Across Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 2. Data: main window data structure with time vector (Data.Time) and Info
% field
% 3. SpikeTimes nspikes x 1 double with spike times in seconsd of each spike
% 4. SpikePositions = N x 1 double or single with spike poisiton (integer specifying channel) of each spike
% (analyzed in internal spike detection) 
% 5. CluterPositions = N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: for internal spikes, no
% units get analyse. Therefore this vector has to be made up of just 1 
% 6. SpikeAmps = N x 1 double or single with amplitudes of each spike
% (analyzed in internal spike detection) to get biggest amplitude
% 7. PlotInfo: structure containing user selected parameter for analysis.
% fields: PlotInfo.Plotevents, PlotInfo.PlotInfo.SpikeRateNumBins,
% PlotInfo.PlotInfo.ChannelSelection all as double, comes from
% Continous_Spikes_Prepare_Plots function
% 8. TextArea: object of app window to show info text in
% 9. ChannelPosition: nchannel x 2 capturing x and y values of each channel
% in um -- since only linear probes are supported, :,1 are all 0, just :,2
% contains values
% 10. Figure: figure axes handle to plot spike times with amplitude
% colorscaling
% 11. Figure2: figure axes handle for spike rate over time 
% 12. Figure3: figure axes handle for spike rate over channel 
% 13. RGBMatrix: nwaveforms x 3 double with rgb values for each waveform
% plotted
% 14. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 15. ClustertoShowDropDown: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 16. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Kilosort_Spikes_Check_Inputs.m
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

File: Continous_Kilosort_Spikes_Manage_Analysis_Plots.m
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

File: Continous_Kilosort_Spikes_Plot_Biggest_Amplitude_Spike.m
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

File: Continous_Kilosort_Spikes_Plot_Spike_Templates.m
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

File: Events_Kilosort_Spikes_Manage_Analysis_Plots.m
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
% EventWindow: Either "EventWindow" when this function is called on startup
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

% Outputs
% 1. Data: data structure from the main window holding spike data
% 2. mnLFP: ndepth x ntime field triggered average
% 3. CurrentPlotData: structure in which analysis results are saved in
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

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
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

