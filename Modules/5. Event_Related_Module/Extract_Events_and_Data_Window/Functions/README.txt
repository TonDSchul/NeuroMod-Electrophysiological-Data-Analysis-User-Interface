This folder contains the following functions with respective Header:

 ###################################################### 

File: Event_Module_Extract_Event_Related_Data.m
%________________________________________________________________________________________
%% Function to extract event related data as a nchannel x nevents x ntime matrix

% It is only computed once and the saved in the Data structure. Either
% extracted from Raw or Preprocessed Data and for one event channel. 

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the infio structure with infos about extracted events.
% 2. EventChannel: Name of the event channel you want to calculate the ERD
% data for; as char; i.e. 'DIN-04' for Intan (saved in Data.Info.EventChannelNames)
% 3. TimeWindowBefore: Time in seconds to take before each event as double,
% always positive!
% 4. TimeWindowAfter: Time in seconds to take after each event as double,
% always positive!
% 5. DatatoUse: Type of data you want to extract event snippets for, as char either
% "Preprocessed" or "Raw"

% Outputs:
% 1. Data: Data object passed here with added field: Data.EventRelatedData
% and adeed infos to Data.Info
% 2. TimearoundEvent: 1 x 2 double containing time before and time after
% event (both positive!)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Determine_Available_EventChannel.m
%________________________________________________________________________________________
%% Function to determine which event channel are contained in a recording (for Intan, Neuralynx and open ephys)

%gets called when the user starts the event extraction window. It first
%searches automatically in the original data path if it can find event
%data. It is necessary for the event extraction main function since it
%flags the contens of the folder containing suitable event data in the
%supported format. 

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the info structure with infos about extracted events.
% 2. Path: char path to folder containing the recording (Data.Info.Data_Path)
% 3. FileType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type. -- not required anymore but prb
% useful in future

% Outputs:
% 1. EventInfo: Contains fields: .DIChannel; .ADCChannel and .AUXChannel.
% The capture the indicie of the folder contents, which represent data for
% digital, analog and aux channel. 
% 2. FileEndingsExist: -- just neuralynx, not working yet, dont look at
% 3. FilesIndex: for open ephys: saves nu8mber and index of nodes that
% where found and can be display as file type options in event window
% 4. FilePaths: Paths to all folder contents in a n x 1 cell array
% 5. texttoshow: saves text that shows info about found event channel in
% the event window
% 6. Info: Only when open ephys to save nozes that where found
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Display_Neuralynx_EventInfo.m
%________________________________________________________________________________________
%% Function show event datain the extract data window text area - convert from dataframe to stringarray

%Gets called after event data for neuralynx was loaded to diplay the
%results

% Inputs: 
% 1.event: Dataframe holding event data. Usually contains event samples,
% event times, event names and event types -- directly comes from fieldtrip
% ft_read_events function

% Outputs:
% 1. fieldData: Data/Text to show in TextArea

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Extract_Event_Indicies_Intan.m
%________________________________________________________________________________________
%% Function that takes 1 x nrecordingtime event data and searches for events

% This function thresholds the event data signal. When the signal is
% exceeding a threshold, the indicie is saved. 
% Since many consecutive indicies can be bigger than the treshold, from each sequence only the first indicie is saved.

%gets called by the Extract_Events_Module_Extract_Events_Intan function
%when the user starts event extraction

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data and
% the info structure.
% 2. ChannelPath: 1 x n vector with indicies of event channel (indicies of
% all foldercontents found) -- usefull but not used here
% 3. InputChannelType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 4. Threshold: double representing threshold for idientifying events -->
% signal has to be >= threshold
% 5. InputChannelData: 1 x ntime data for each event channel of the specified InputChannelType

% Outputs:
% 1. Data: Data structure with added field:
% Data.Events{1:neventchannelfound} containing a 1 x nevents vector with
% event indicies in samples. Data.Info gets also info about channelnames and InputChannelType
% 2. InputChannelData: 1 x ntime data for each event channel of the
% specified InputChannelType; transposed and converted to rising edge if
% necessary -- not used yet

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Extract_Events_Intan.m
%________________________________________________________________________________________
%% Function to coordinate Intan Event Extraction

% This function actually loads event files (.dat files only! .rhd are loaded when gui started to show info about it) and passes 1 x ntime vector of
% event data into Extract_Events_Module_Extract_Event_Indicies_Intan
% function to extract event indicies exceeding a treshold

% gets called in the Extract_Events_Module_Main_Function function when the user starts the event extraction for intan data

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data and
% the info structure.
% 2. FileType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 3. InputChannelIndicie: 1 x n double vector with indicies of event channel (indicies of
% all foldercontents found)
% 4. FolderPath: path to folder holding event recordings as char
% 5. Threshold: double representing threshold for idientifying events -->
% signal has to be >= threshold
% 6. InputChannelSelection: 1 x n vector containing indicies of event channels found for specified type (analog, digital and so on) 
% 7. RHDAllChannelData: NOTE!! ONLY IF .RHD file format analyzed! saves field
% RHDAllChannelData.board_dig_in_data containing event data (NOTE!! as a nevents x ntime matrix), since the file had
% to be loaded earlier already to know what can be shown as otions in the
% GUI. --> not as nicely doable as with individual .dat files for each
% event

% Outputs:
% 1. Data: Data structure with added field:
% Data.Events{1:neventchannelfound} containing a 1 x nevents vector with
% event indicies in samples. Data.Info gets also info about channelnames and InputChannelType

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Extract_Events_Neuralynx.m
%________________________________________________________________________________________
%% Function to extract event Data from Neuralynx recordings

% This function gets caled when neurylynx events are supposed to be
% extracted. It calls the fieldtrip ft_read_event and ft_read_header
% functions for event data extraction

% Inputs: 
% 1.Filename: char, Name of the event file (.nve)
% 2.Path: char, direcory containing the event data

% Outputs:
% 1. event: 1x1 dataframe with sample times, time points, event types, event
% trigger information and so on. 


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Extract_Open_Ephys_Events.m
%________________________________________________________________________________________
%% Function to extract events from open ephys data

% This function utilizes functions and some analysis workflows as well as
% example data from the analysis-tools Github project from jsiegle
% available at https://github.com/open-ephys/analysis-tools as well as the open-ephys-matlab-tools
% Matlab file exchange project https://de.mathworks.com/matlabcentral/fileexchange/122372-open-ephys-matlab-tools

% functions necessary from these sources that are used here were not modified, this code is
% self written based on the load_all_formats function in the example
% folder
% functions used: 1. Session; 2. eventProcessors

% NOTE: depending on the node and prb. version of Open Ephys recording GUI,
% particular field names where event indicies are saved can vary. The code
% down below checks for all known to me, but can be uncomplete. It only
% checks events for the node selected in the event extraction window
% NOTE: This code has two modi: first just retriving infomation, like the
% dataframe and second to actually extract and save event data

% This gets called when the user clicks on event extraction in the event
% extraction window and open ephys is recording format

% Input:
% 1. Path: path as char to folder containing the recording
% 2: WhatToDo: as string detetmines mode, see above, Otions: "Get
% Information" OR "All" (also extract events)
% 3. NodeNr: Indicie of recording node the user selects; indicie = position in
% folder --> with three nodes, content of folder has 3 string elements.
% Indicie is the indice of these 3 elements that was seleceted
% 4. NoddeID: Not used yet, maybe necessary in future (saves node nr as double, i.e. 101)
% 5. InputChannelSelection: 1 x n double with indicie of which events that
% were identified should be analyzed. if 3 event lines saved (3 events),
% this would be [1,2,3] to extract indicies of all 3 of them
% 6. StateSelection: char with a number (either '1' or '0', events can have state of 0 or 1).
% User can specify this in the event extraction window

% Output: 
% 1. Events: 1 x nevents cell array with each cell containing a
% 1 x Nreventindicies double vector with event indicies (as samples).
% Data.Events{2} is the second event input line found containing a 1x50
% vector for 50 trials/events found with values 1231,135125,2454988 and so
% on as samples when they happended
% 2. Info: structure saving infos about extraction that get saved in main
% Data.Info stucture

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Load_and_Plot_Events.m
%________________________________________________________________________________________
%% Function load and plot event data in the show event data window (opened in the extract events window)

% This function gets called by Extract_Events_Module_Show_ChannelPlots.m
% and gets event data from that function to plot it

% Inputs: 
% 1. EventInfo: comes from the 'Extract_Events_Module_Determine_Available_EventChannel' function.
%    contains recording system specific infos about events.
% 2. FilePaths: contents of folder in which events were searched for (ncontens x 1 cell array with each cell containing a string)
% 3. Figure: figure axes handle to plot event data in
% 4. SelectedEventChannelNames: char, name of the event type (i.e. for Intan: Digital Inputs)
% 5. AllChannelNames: Anmes if all possible name of the event types
% 6. Data: main data structure from main window (mainly fot Data.Info field)
% 7. RHDAllChannelData: Just If Intan .rhd: events are extracted ones, then saved in this
% variable to be able to show again without having to extract again. Just
% for Intan.rhd bc it takes by far the longest
% 8. DownsampleRate: string, desired new sampling rate in Hz after
% downsampling

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Main_Function.m
%________________________________________________________________________________________
%% Function to coordinate Intan Event Extraction

% This organizes which function gets executed based on the recording
% system, file type and event channelselection the user made in the event
% data extraction window.

%gets called when the user starts the event extraction

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data and
% the info structure.
% 2. EventInfo: Contains fields: .DIChannel; .ADCChannel and .AUXChannel.
% The capture the indicie of the folder contents, which represent data for
% digital, analog and aux channel. 
% 3. Path: path to folder holding event recordings as char
% 4. RecordingType: char of recordingsystem. saved in Data.Info.RecordingType
% 5. FileTypeDropDown: type of event to look for; for Intan: "Digital
% Inputs" or "Analog Input" or "AUX"
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 6. Threshold: double representing threshold for idientifying events -->
% signal has to be >= threshold
% 7. InputChannelSelection: 1 x n vector containing indicies of event channels found for specified type (analog, digital and so on) 
% 8. ExtractedRHDEventsFlag: When recordingsystem = Intan RHD file, all event data is fully loaded
% when the event extraction window opens. Since this takes long, it is only
% done ones and then saved. To signal that it was already analyzed, this
% variables is set to 1. Otherwise 0 as double.
% 9: TextArea of event data extraction window showing the evens found
% 10. RHDAllChannelData: NOTE!! ONLY IF .RHD file format analyzed! saves field
% RHDAllChannelData.board_dig_in_data containing event data (NOTE!! as a nevents x ntime matrix), since the file had
% to be loaded earlier already to know what can be shown as otions in the
% GUI. --> not as nicely doable as with individual .dat files for each
% event
% 11. executablefolder: char with the path to the currently execute GUI
% instance, comes from public property in main window

% Outputs:
% 1. Data: Data structure with added field:
% Data.Events{1:neventchannelfound} containing a 1 x nevents vector with
% event indicies in samples. Data.Info gets also info about channelnames and InputChannelType
% 2. EventChannelDropDown: cell array containing chars with event channel
% names for which indicies were found to display in lower right button
% dropdown menu of main window. This way the user can select for which event the
% indicies are shown in the plot.
% 3. RHDAllChannelData: NOTE!! ONLY IF .RHD file format analyzed! saves field
% RHDAllChannelData.board_dig_in_data containing event data (NOTE!! as a nevents x ntime matrix), since the file had
% to be loaded earlier already to know what can be shown as otions in the
% GUI. --> not as nicely doable as with individual .dat files for each
% event
% 4. ExtractedRHDEventsFlag: When recordingsystem = Intan RHD file, all event data is fully loaded
% when the event extraction window opens. Since this takes long, it is only
% done ones and then saved. To signal that it was already analyzed, this
% variables is set to 1. Otherwise 0 as double.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Organize_Window_Intan_RHD.m
%________________________________________________________________________________________
%% Function show found event channel infos in the event extraction window for Intan .rhd recordings

% gets called by the Extract_Events_Module_Determine_Available_EventChannel
% function on startup of the event extraction window, when the folder supposed to contain event data gets
% changed and when the type of event file is changed in the extract events window (Digital, Analog and Aux inputs for intan, "Record Node 101" or whatever node contains events of interest for Open Ephys)

% Inputs: 
% 1.app: app object containing the components of the extract events window.
% 2. RhdFilePaths: NOTE: only non empty on startup and folder change; 1xn
% cell array with each cell containing a string with a single content of
% the selected folder
% 3: Type: char, 'Initial' to populate textare in window on startup and
% folder change; When event filetype change some other string to just
% update the app.NrInputChinfolderEditField,
% app.AnalogThresholdVEditField and app.InputChannelSelectionEditField
% fields
% 4. DIChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Digital events as 1xn double array
% 5. ADCChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Analog events as 1xn double array
% 6. AUXChannel:empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Aux events as 1xn double array
% 9. ChannelType: selected filetype in the main window (Digital, Analog and Aux inputs for intan, "Record Node 101" or whatever node contains events of interest for Open Ephys)

% Outputs:
% 1. DIChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Digital events as 1xn double array
% 2. ADCChannel: empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Analog events as 1xn double array
% 3. AUXChannel:empty on startup and folder change; when event file type
% change: contains indicies of RHDFilePaths with path to the event file for
% Aux events as 1xn double array
% 4. AllChannel: empty on event file type
% change; on startup contains indicies of RHDFilePaths with path to the all event file types as 1xn double array
% 5: FoundChannelString: string array holding names of all event files (and in some cases amplifier files)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Set_Up_Window.m
%________________________________________________________________________________________
%% Function to set up the events app window

%gets called on startup of the extract event data window, populates fields
%of window

% Inputs: 
% 1.app : main windwow app structure
% 1.Data: Data structure with raw data, preprocessed data and
% the info structure.
% 2. EventInfo: Contains fields: .DIChannel; .ADCChannel and .AUXChannel.
% The capture the indicie of the folder contents, which represent data for
% digital, analog and aux channel. 
% 3. Path: path to folder holding event recordings as char
% 4. FilePaths: nfolderconents x 1 cell array with each cell containing a
% string.
% 5. FileEndingsExist: double, either 1 or 0 - 1 if ending exists
% 6. texttoshow: app text area to show info in
% 7. TimeOfExecution: string, Indicates when this function was called;
% Options: "ChangedEventChannelType" OR "Initial"
% 8. Info: only relevant for open ephys recordings

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Show_ChannelPlots.m
%________________________________________________________________________________________
%% Function to plot event data of a selected event channel 

% This function searches on startup of the Show_Event_Channel_Window through possible events and plots data
% for the first event channel found. Otherwise it plots/returns info that
% no data found for specified channel

% gets called when the user clicks on "Show Input Channel Plots" in the
% extract data window and opens the Show_Event_Channel_Window app.

% Inputs: 
% 1.Channel: type of event file to look for; for Intan: "Digital
% Inputs" or "Analog Input" or "AUX"
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 2. Folder: path to folder holding event recordings as char
% 3. app: Show_Event_Channel_Window app object
% 4. RHDAllChannelData: NOTE!! ONLY IF .RHD file format analyzed! saves field
% RHDAllChannelData.board_dig_in_data containing event data (NOTE!! as a nevents x ntime matrix), since the file had
% to be loaded earlier already to know what can be shown as otions in the
% GUI. --> not as nicely doable as with individual .dat files for each
% event
% 5. Type: Determines if this function is executed on Show_Event_Channel_Window startup. If yes, additional infos are loaded. 
% If no, This has to be some other string to only extract necessary information

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

