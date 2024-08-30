This folder contains the following functions with respective Header:

 ###################################################### 

File: Preprocessing_Events_Add_Preprocessing_Info.m
%________________________________________________________________________________________
%% Function to take preprocessing options for event related data and save them in Data.Info
% This function populates main window Data.Info field 
% Gets called after preprocessing step was applied to dataset

% Note: Since preprocessing was already applied when this function is called, the Data.Info structure 
% already contains the specific kind of preprocessing applied as
% Data.Info.EventRelatedPreprocessing (as char)
% It can contain following options: 'TrialRejectionChannel' OR
% 'ChannelRejectionTrials' OR 'ArtefactRejectionChannel' OR
% 'ArtefactRejectionTrials' OR 'ArtefactRejectionTimeRange'. It is important here because
% prepro steps can be applied multiple times. Therefore Data.Info
% fields with event prepro info is NOT overwritten. Instead it takes the old
% fields and adds new parameter to it.

% Inputs: 
% 1.Data: Main Window data structure with the info field.
% 2. EventRelatedPreprocessingType: char, type of preprocessing applied;
% Options: 'Artefact Rejection' OR 'Channel Rejection' OR 'Trial Rejection'
% 3. ChannelSelection: 1 x 2 double for which channel preprocessiing step was applied
% i.e. [1,10] for channel 1 to 10
% 4. TrialSelection: 1 x 2 double for which events preprocessiing step was applied
% i.e. [1,10] for events 1 to 10
% 5. TimeRangeArtefact: 1 x 2 double capturing the stop and start time of
% the artefact rejection step if applied
% i.e. [1,10] for events 1 to 10

% Outputs:
% 1.Data: Main Window data structure with the info field.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Events_Channel_Rejection.m
%________________________________________________________________________________________
%% Function to execute channel rejection and interpolation event preprocessing step
% This function modifes the Data.EventRelatedData or
% Data.PreprocessedEventRelatedData if prepro was already applied

% Inputs: 
% 1. EventRelatedData: nchannel x nevents x ntime single matrix with event
% related data
% 2. Time: double time vector, same length as ntime, in seconds
% 3. Channel: 1x2 double with channel to be deleted, i.e. [1,10] for
% channel 1 to 10 
% 4. ChannelSpacing: double in um (Data.Info.ChannelSpacing)
% 5. Figure: axes object of channel rejection prepro app window to plot
% result in
% 6. Type: selects if results should be plotted, Otions: 'InterpolatedOnly' OR 'PlotOnly' OR 'All'

% Outputs:
% 1. EventRelatedData: nchannel x nevents x ntime single matrix with modified event related data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Events_Check_Inputs_Artefact_Rejection.m
%________________________________________________________________________________________
%% Function to check each input the user has to make in the artefact rejection app window
% This function takes inputs from GUI as Input.Value structure. The value
% field saves what the user selcts as a char. I.e. TrialSelection.Value =
% '1,10' if user wants events/trials 1 to 10. If input violates format
% rules, selection gets autoreplaced by standard values and ouputted, so
% that autochange gets visible in app window

% called when the user clicks on the 'Interpolate Artefact Window' button of the artefact rejection window

% Inputs: 
% 1. Data: main window data structure with Data.EventRelatedData and if
% applicable Data.PreprocessedEventRelatedData
% 2. ChannelSelection: Has to contain field value containing a char with
% the selection user made, i.e. ChannelSelection.Value = '1,10' for events 1
% to 10
% 3. TimeWindow: Has to contain field value containing a char with
% the selection user made, i.e. TimeWindow.Value = '1,10' for events 1
% to 10
% 4. TrialSelection: Has to contain field value containing a char with
% the selection user made, i.e. TrialSelection.Value = '1,10' for events 1
% to 10
% 5. EventTime: time vector in seconds for event related data, same length
% as ntime of event related data ('real' time with negative values)

% Outputs: -- if error was deteccted, these values are different to the
% input values
% 1. ChannelSelection: Has to contain field value containing a char with
% the selection user made, i.e. ChannelSelection.Value = '1,10' for events 1
% to 10
% 2. TimeWindow: Has to contain field value containing a char with
% the selection user made, i.e. TimeWindow.Value = '1,10' for events 1
% to 10
% 3. TrialSelection: Has to contain field value containing a char with
% the selection user made, i.e. TrialSelection.Value = '1,10' for events 1
% to 10
% 4. EventTime: time vector in seconds for event related data, same length
% as ntime of event related data ('real' time with negative values)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Events_Plot_and_Apply_Trial_Rejection.m
%________________________________________________________________________________________
%% Function to apply and plot event/trial rejection
% This function simply deletes events selected and replots the broandband
% and ERP plot 

% called when the user enters a value in the trial rejection edit field of
% the trial rejection window

% Inputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with event
% related data
% 2. Time: 1 x ntime double with time values for each time point of event
% realted data ('real' time with negative values)
% 3. Type: char, determines what is done her, Either 'OnlyReject' OR 'RejectandPlot' OR 'Plot'
% 4. TopFigure: Figure axes handle to top figure of trial rejection window
% plotting ERP
% 5. BottomFigure: Figure axes handle to bottom figure of trial rejection window
% plotting broadband signal
% 6. ChannelSelection: Channel to plot; char with single number like '10' NOTE: Only for Plotting! Rejection
% is done for all channel automatically
% 7. TrialsToReject: char with trial selection of preprocessing window, as
% char, i.e. '1,10' for events 1 to 10

% Outputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with modified event
% related data
% 2. Error: double, 1 if error occured and preprocessing was not applied, 0
% otherwise -- occurs when event selection format wrong

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Events_PopulateInfoText.m
%________________________________________________________________________________________
%% Function to show what preprocessing steps were applied already to event related data in windoww the user selects the prepro step

% called when some preprocessing step was applied or when window to select
% prepro steps is opened

% Inputs: 
% 1. TextArea: text object of prepro selection window supposed to show the
% prepro infos (shown when string or char is saved as TextArea.Value)
% 2. Data: main app data structure with Data.PreprocessedEventRelatedData, 
% Data.EventRelatedPreprocessing and Data.Info fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Preprocessing_Events_Reject_and_Plot_Artefacts.m
%________________________________________________________________________________________
%% Function to check each input the user has to make in the artefact rejection app window
% This function takes inputs from GUI as Input.Value structure. The value
% field saves what the user selcts as a char. I.e. TrialSelection.Value =
% '1,10' if user wants events/trials 1 to 10. If input violates format
% rules, selection gets autoreplaced by standard values and ouputted, so
% that autochange gets visible in app window

% called when the user clicks on the 'Interpolate Artefact Window' button of the artefact rejection window

% Inputs: 
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with event
% related data
% 2. ChannelSelection: 1x2 double channel selection of user for what channel to do the
% correction, i.e. [1,10] for channel 1 to 10 
% 3. TrialsofInterest: 1x2 double event selection of user for what events to do the
% correction, i.e. [1,10] for events 1 to 10 
% 5. Time: time vector in seconds for event related data, same length
% as ntime of event related data ('real' time with negative values)
% 6. TimeWindin: 1x2 double time window selection in seconds for what time
% window artefact rejection is applied. Format: [starttime stoptime], like [-0.005 0.005] to reject and
% interpolate data from -0.005 to 0.005 seconds
% 7. Figure1: figure axes handle to plot of ERP plot (top left)
% 8. Figure2: figure axes handle to plot of rejected ERP plot (bottom left)
% 9. Figure3: figure axes handle to plot of ERP for all channe (right plot)
% 10. ChanneltoPlot: char, single channel to plot erp's on the left, like
% '10' to plot channel 10, NOTE: Only for plotting! Channelselection
% happens through the channelselection edit field and variable
% 11. ChannelSpacing: as double in um, in Data.Info.Channelspacing
% 12. InterpolationMethod: string, method to apply to data in timewin;
% Option: "Linear Interpolation" 
% 13. Type: char, determines what is done here, Options: 'DeleteandPlot' (interpolates data for bottom plot, sets NaN for top plot) OR
% 'Interpolating' (just sets data in timwin to NaN for top ERP plot)
% 14. colorMap: nchannel x 3 double matrix with rgb values for the color
% of each channel for the plot on the right side
% 15. WhattoPlot: char, determines what is plotted here, Options: 'ERP' OR 'ERPAllChannel' OR 'InterpolationPlot' OR 'All'

% Outputs: -- if error was deteccted, these values are different to the
% input values
% 1. EventRelatedData: nchannel x ntrials x ntime single matrix with modified event
% related data
% ERP: 1x ntime single vector with ERP data (mean over channel and events)
% ERPs: nchannel x ntime single vector with ERP data for each channel (mean over events)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

