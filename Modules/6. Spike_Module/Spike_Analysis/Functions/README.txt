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

File: Continous_Internal_Spikes_Get_Biggest_Amplitude_and_Waveforms.m
%________________________________________________________________________________________
%% Function to extract biggest spike waveforms with amplitudes of each spike already given.

% This function is executed every time some waveform analysis has to be
% done. Extraction is fast enough for that. 
% Note: Code extracts n number of biggest wavforms found, with n being the
% specified nr by the user. Gets saved in main window Data structure, but
% overwritten everytime here

%gets called whenever the user selects an analysis in the cont. internal spikes window that requires waveforms

% Inputs: 
% 1. Data = needs to contain raw or preprocessed data to extract wveforms
% from
% 2. SpikeTimes nspikes x 1 double with spike times in samples of each spike
% 3. Amplitudes = N x 1 double or single with amplitudes of each spike
% (analyzed in internal spike detection) to get biggest amplitude
% 4. SpikePositions = N x 1 double or single with spike poisiton (integer specifying channel) of each spike
% (analyzed in internal spike detection) 
% 5. ChannelSelection = 2 x 1 double or single; from , to like [1,10] for
% channel 1 to 10 
% 6. NRWaveformsToExtract: -- not used here
% 7. Downsample:  -- not used here
% 8. Plot: char, specifies if waveforms should be plotted
% 9. Figure: figure axes handle to plot waveforms on
% 10. WaveformsToPlot: 1x2 double specifying how man waveforms should be
% analysed, i.e. [1,10] for 10 waveforms

% Outputs:
% 1. Waveforms: nchannel x nwaveforms x ntime matrix saving each extract
% waveform
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Internal_Spikes_Manage_Analysis_Plots.m
%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for continous internal spikes based on user input
% This function uses a functions from the spike repository from Nick
% Steinmetz on Github: https://github.com/cortex-lab/spikes
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
% 4. UnitsEditField: object holding app text with the field Value containing a char of the user input. Correct format: UnitsEditField.Value = '1,10' for units 1 to 10. 
% 5. SpikeAnalysisType: Name as char of analysis done, Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR "Waveforms from Raw Data" OR
% "Average Waveforms Across Channel" OR "Waveforms Templates" OR "Template from Max Amplitude Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 6. SpikeRateBinsEditField: object holding app text with the field Value containing a char of the user input. Correct format: SpikeRateBinsEditField.Value = '100'

% Output:
% 1. ChannelEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 
% 3. WaveformEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 
% 4. UnitsEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 
% 5. Error: Indicates if an error happened consisting of too many channel,
% units and waveforms selcted which would result in a 3d matrix. Then the
% code stops and the user gets a message
% 6: SpikeRateBinsEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Kilosort_Spikes_Check_and_Extract_Waveforms.m
%________________________________________________________________________________________
%% Function to extract waveforms of kilosort spikes from raw or preprocessed data
% This function is executed every time some continous kilosort spikes
% analysis containing waveforms is executed
% This function uses a functions from the spike repository from Nick
% Steinmetz on Github: https://github.com/cortex-lab/spikes
% Function used: getWaveForms

% Inputs:
% 1. Data: main window data structure with Data.Spikes , Data.Time and
% Data.Info
% 2. TextArea: app window text object to show number of cluster and spikes
% found
% 3. SpikeTimes: nspikes x 1 double in seconds
% 4. SpikeClusters: N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) 
% 5. PlotInfo: 

%Output:
% 1. Data: main window data structure with added field
% Data.Spikes.Waveforms as Unit x waveforms x channel 
% 2. app window text object to show number of cluster and spikes
% found

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Kilosort_Spikes_Manage_Analysis_Plots.m
%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for continous internal spikes based on user input
% This function uses a functions from the spike repository from Nick
% Steinmetz on Github: https://github.com/cortex-lab/spikes
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

% Output:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field

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

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Continous_Kilosort_Spikes_Plot_Raw_Waveforms.m
%________________________________________________________________________________________
%% Function to plot waveforms that where extracted for Kilosort spikes
% Note: For each spike the specified nr of waveforms over all selected channel are plotted

% This function is called in the
% Continous_Kilosort_Spikes_Manage_Analysis_Plots function

% Inputs:
% 1. Figure: Figure axes handle top plot in 
% 2. Data: main window data structure with Data.Spikes and Data.Info field; Data.Spikes with field Data.Spikes.Waveforms.waveForms
% 3. ChannelSelection: 1x2 double with channel to plot the waveforms for,
% i.e. [1,10] for channel 1 to 10
% 4. units: unitselection as double, for title (waveform already extracted for just that unit)
% 5. Waveforms: 1x2 double with wavefor selection of user, i.e. [1,10] for
% 10 waveforms

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

% Inputs:
% 1. Figure: fugire aces handle to plot in
% 2. Data: main window app structure (just needed for Data.Info to get samplerate)
% 3. ChannelSelection: 1x2 double with channelselection of user, i.e. [1,10]
% for channel 1 to 10 
% 4. UnitstoPlot: number of unit selected as double (just for title) 
% 5. MeanWaveform: depending on whether one or multiple channel selected
% either a 3d double matrix with nunit x nchannel x ntime or 2D matrix (1x1xntime)
% 6. ChannelSpacing: in um as double, from Data.Info.ChannelSpacing
% 7. SpikeType: char, Type of spike to analyse, either 'Kilosort' OR 'Internal'
% 8. WaveformsToPlot: 1x2 double with waveformselection of user, i.e. [1,10]
% for 10 waveforms

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
% (analyzed in internal spike detection) NOTE: for internal spikes, no
% units get analyse. Therefore this vector has to be made up of just 1 
% 5. TimeSpikeFigure: Figure handle to app.UIaxes_3 Spike Rate over time 
% 6. TemplateFigure: Figure handle to app.UIaxes_5 Spike Rate over channel 
% 7. Type: "Initial" when plotting for the first time after resetting,
% BinsizeChangeInitial when binsize was changed, "Non" when nothing
% 8. rgb_matrix: RGB values for each cluster to show them in different colors
% 9. numCluster: Number of clusters (saved under app.numCluster within Analyse_Kilosort_Window)
% 10. ClustertoShow: Number of cluster the user selected to highlight in their color. Can
% be "All" to show all cluster in their color, "Non" to show no colors or a
% number as a string to show only that cluster. Indexing starts with 0!
% 11. numBins: Number of bins selectd in the analysis window (string or char)

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
% 4. UnitsEditField: text field of app containing userinput as char in
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
% 1-indexed)- for internal spikes: all 1 since no clustering is done
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
% for analysis and plotting

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

%Outputs:
% 6. PlotInfo: structure holding gathered info about user input, contains
% fields: PlotInfo.TimearoundEvent,PlotInfo.EventNr,PlotInfo.EventRange,PlotInfo.ChannelsToPlot,PlotInfo.Time,PlotInfo.ChannelNr,PlotInfo.SpikeRateNumBins,PlotInfo.depth_bin_size,PlotInfo.time_bin_size ,PlotInfo.depth_edges,PlotInfo.time_edges , PlotInfo.NormWindow
% 1. SpikeTimes: nspikes x 1 double with just spike indicies within the
% channelrange
% 2.SpikePositions: nspikes x 1 double with spike poisiton spike indicies within the
% channelrange (in um)
% 3.SpikeAmplitude: nspikes x 1 double with just spike amplitudes indicies within the
% channelrange
% 4. SpikeCluster: nspikes x 1 double with just spike cluster ID's indicies within the
% channelrange
% 5. SpikeEvents: nspikes x 1 double with just event identity (integers)
% 6. BaselineWindowField: text field of app containing basline window range userinput as char in
% the field ChannelEditField.Value, like '-0.005,0' for channel -0.005s to 0s
% 7. ChannelSelectionField: text field of app containing channel range userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10
% 8. EventRangeEditField: text field of app containing event range userinput as char in
% the field EventRangeEditField.Value, like '1,10' for events 1 to 10
% 9. SpikeRateNumBinsEditField: text field of app containing basline num bins for spike rate userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins

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

%Outputs:
% 2. SpikesPerBin: 1 x nbins double; If Samplingrate = 1 as input, spike rate is given as number of
% spikes per bin. When you input a proper Samplingrate > 1, this function
% returns the spike rate in Hz for each bin


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
% .Value fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Spike_Triggered_Average.m
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

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spikes_Plot_Spike_Times.m
%________________________________________________________________________________________
%% Function to plot spike times with amplitude color coding
% This function uses a functions from the spike repository from Nick
% Steinmetz on Github: https://github.com/cortex-lab/spikes
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

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

