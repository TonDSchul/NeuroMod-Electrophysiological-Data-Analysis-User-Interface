This folder contains the following functions with respective Header:

 ###################################################### 

File: Event_Module_Extract_Event_Related_Data.m
%________________________________________________________________________________________
%% Function to extract event related data as a nchannel x nevents x ntime matrix

% Channel x trials x time matrix is extracted on the fly as needed, but
% saved in the app.Data structure after each extraction and can be
% retrieved from there

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the infio structure with infos about extracted events.
% 2. EventChannel: Name of the event channel you want to calculate the ERD
% data for; as char; i.e. 'DIN-04' for Intan (saved in Data.Info.EventChannelNames)
% 3. TimeRange: double 1x2 vector with time before, then a space then time after (in seconds, both positive)
% 5. DataToExtractFrom: Type of data you want to extract event snippets for, as char either
% "Preprocessed Data" or "Raw Data"
% 6. EventDataType: char, 'Raw Event Related Data" or "Preprocessed Event
% Related Data". If the latter is selected, channel interpolation and trial
% rejection are added to the normal event related data and saved in a
% separate field in the second half of this code

% Outputs:
% 1. Data: Data object passed here with added field: Data.EventRelatedData
% and adeed infos to Data.Info
% 2. TimearoundEvent: 1 x 2 double containing time before and time after
% event (both positive!)
% 3. ExcludedTrials: double array with indices of Data.Events that could no
%t be included in event related data due to time violations (i. when cutting time and trigger to close to start/stop of the recoding)
% 4 TooLarge: struc, TooLarge.Event; TooLarge.Event = event indice for event related data too large to process;

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Add_EventRelatedInfo.m
%________________________________________________________________________________________
%% Function to add Data.Info fields about event related data

% This is the only information saved permanently when extracting events about event
% related data

% Inputs: 
% 1. Data: Data structure with raw data, preprocessed data, event data and
% the infio structure with infos about extracted events.
% 2. TimeWindowBefore: char, pre stimulus time range specified by user
% 3. TimeWindowAfter: char, post stimulus time range specified by user

% Outputs:
% 1. Data: Data object passed here with added field:
% EventRelatedDataTimeRange and EventRelatedActiveChannel
% and adeed infos to Data.Info

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Check_Violating_Trigger.m
%________________________________________________________________________________________

%% Function to check whether event sample time points acquired violate time limits when extracting trial data (event related data)
% i.e trigger at 0.2 seconds before recording ends with a trila time of 0.5
% seconds after the trigger

% user is asked whether to delete those indices. This makes everything
% cleaner for sure, but everything still works without it!

% executed as last function in the extracting event data from a recording
% pipeline of the extract trigger times windwo

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% Events: cell array, each cell containing a a x 1 event sample vector
% TimeAroundEvent: 1 x 2 vector with time before (1) and after (2) each
% event trigger in seconds - both positive!

% Output
% 1. Data: Main window data strucure with all relevant dataset compontntes
% 2. Events: cell array, each cell containing a a x 1 event sample vector -
% cleaned or uncleaned depending on user selction
% 3. texttoshow: char, text to show when trigger where deleted in extract
% trial times window.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Combine_Events.m
%________________________________________________________________________________________

%% Function to combine multiple event channel into one 

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% Events: cell array, each cell containing a a x 1 event sample vector
% EventsToCombine: struc with fields: CombinedChannel: vector with event channel numbers specified by the user
% to combine
%                                     CombinedIdentity: original identies
%                                     since user can edit event nrs to
%                                     extract
% CompleteEventChannelSelection: Not used anymore
% ActualUserEventChannelSelection: vector with all event channel numbers to
% compare against EventsToCombine
% Eventstodelete: NOT USED ANYMORE

% Output
% 1. Data: Main window data strucure with changed Data.Events and
% Data.Info fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Correct_For_TimeToExtract.m
%________________________________________________________________________________________

%% Function that takes event indices (time stamps in respect to whole recording) and changes them to fit into the time range the user choose to extract
% substracts number of samples recording extraction was started at, deletes
% samples <= 0 and > num_samples

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% TimeAndChannelToExtract: struc with fields:  TimeToExtract (comma
% separated like 0,Inf) 

% Output
% 1. Data: Main window data strucure with changed Data.Events and
% Data.Info fields
% 2. texttoshow: string, info text about was was deleted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Costume_Trigger_Identity.m
%________________________________________________________________________________________

%% Function that takes an event channel and splits it into multiple differen event channels

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% CostumeChannelIdentityInfo: struc with fields:  
% AllIdentities: vector with numbers from laoded txt or csv file designating
% individual event channel for each indice
%and UniqueIdentities: cell array with string holding event channel name
%defined in loaded txt or csv file

% Output
% 1. Data: Main window data strucure with changed Data.Events and
% Data.Info fields
% 2. Error: double, 1 or 0 whether an error occured

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
% 6. EventInfoType: char, Either 'Event Onset' or 'Event Offset' to
% determine whether rising or falling edge should be detected

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
% 8. EventInfoType: char, Either 'Event Onset' or 'Event Offset' to
% determine whether rising or falling edge should be detected

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
% 1. Data: Data structure from main dataset
% 2. Path: path as char to folder containing the recording
% 3: WhatToDo: as string detetmines mode, see above, Otions: "Get
% Information" OR "All" (also extract events)
% 4. NodeNr: Indicie of recording node the user selects; indicie = position in
% folder --> with three nodes, content of folder has 3 string elements.
% Indicie is the indice of these 3 elements that was seleceted
% 5. NoddeID: Not used yet, maybe necessary in future (saves node nr as double, i.e. 101)
% 6. InputChannelSelection: 1 x n double with indicie of which events that
% were identified should be analyzed. if 3 event lines saved (3 events),
% this would be [1,2,3] to extract indicies of all 3 of them
% 7. StateSelection: char with a number (either '1' or '0', events can have state of 0 or 1).
% User can specify this in the event extraction window
% 8. FirstTimeStampinSample: double in samples, TimeStamp of start of recording respective to
% the aquisition start. Found in Data.Info
% 9. AllRecordingIndicies: vector of recording indicies selected at data
% extraction. Basically holds which recordings the user wanted to
% concatonate


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

File: Extract_Events_Module_Extract_TDT_Events.m
%________________________________________________________________________________________

%% This function extracts event data from TDT recordings loaded with the TDTMatlabSDK

% NOTE: event data from actual raw recording is extracted and saved in the
% variable EventInfo in the
% Extract_Events_Module_Determine_Available_EventChannel.m function. This
% function here just organizes/analysis this output

% Input:
% 1. EventInfo: struc, with those fileds for each event data type: EventInfo.eTr.OnsetChannelIdentities = [];
            %EventInfo.eTr.OffsetChannelIdentities = [];
            %EventInfo.eTr.OnsetTimestamps = [];
            %EventInfo.eTr.OffsetTimestamps = []; The name of the second
            %structure field is based on which event type was detected!
% FileTypeDropDown: char, value/user selection from the input channel type dorpdown on top
% InputChannelSelection: double vector with all channel from the event type
% above
% State: char, either 'Trigger Onset' OR 'Trigger Offset'

% Output: 
% 1. Events: cell array, with each cell containing a double 1 x n vecotr
% with samples of events
% EventChannelNames: cell with one char per cell designating the name of
% the event channel for each cell in 1. 
% Error: double 1 or 0 whether error occured

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Load_Neuralynx_Events.m
%________________________________________________________________________________________
%% Function load and plot event data in the show event data window (opened in the extract events window)

% This function gets called by Extract_Events_Module_Show_ChannelPlots.m
% and gets event data from that function to plot it

% Inputs: 
% 1. Data: main window data structure
% 2. NeuralynxRecordingPath: char, path to neuralynx recording folder (saved when recording is extracted)

% Outputs:
% 1.event: struc with event information (event samples, idendities etc)
% shown in extract event times window
% 2. Texttoshow: string with some information if events found and if in
% proper time range

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
% 12. startTimestamp: Only for open ephys!! start time of recording in
% seconds to substract from event times which are present in respect to
% aquisition start, not recording start
% 13. TimeAroundEvent: double, 1x2 vecor with time before and after trigger
% (both positive)
% 15. AdditionalEventInfo: struc with fields: InputChannelNumber with event
% channels numbers the user specified and field states: 1 or 0 which
% trigger state is extracted 
% 15. EventsToCombine: struc with fields: CombinedChannel: vector with event channel numbers specified by the user
% to combine
%                                     CombinedIdentity: original identies
%                                     since user can edit event nrs to
%                                     extract

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
% 5. Eventstodelete: double vector with all event indicies that where deteleted (if so). After event extraction, event data is 'cleaned'
% meaning all trigger violating time limits/ custom time extractions 
% 6. texttoshow: string holding info about what was extracted and done (like deleted trigger due to time violations)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Maxwell_MEA.m
%________________________________________________________________________________________

%% Function to extract Maxwell MEA .h5 event data stored in bits or eventdata

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% 2. FullPath: char to maxwell recording folder
% 3. EventType: char, "Bits Group" or "Event Group" from which part of the
% recording object events are extracted
% 4. EventInputChannel: double vector with channel indicies to extract
% 5. TriggerType: char, either "Trigger Onset" or "Trigger Offset"

% Output
% 1.Events: cell array with each cell being a 1 x nevents vector with
% samples
% 2. EventChannelNames: cell array with char for each event channel holding its name 
% 3. Error: double 1 or 0 whether error occured

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_NEO_Determine_Available_EventChannel.m
%________________________________________________________________________________________

%% Function to determined event channel extracted with NEO when amplifier data was extracted

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% 2. Path: char to recording parent folder holding the folder, event and
% amplifier channel was saved to by the NEO script

% Output
% 1. NeoEventStartTimeStamp: double, time stamp (samples) event acquistion
% was started (substracted from event times)
% 2. EventInfo: struc with all infos to found events
% 3. EventDataLocation: char, file name of .mat file holding event data
% saved by the NEO script
% 4. texttoshow: string, information whether files where found and
% events could be loaded

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Neuralynx_Manage_Events_Main.m
%________________________________________________________________________________________

%% Function to extract event information from EventInfo structure and save in main window Data structure

% Input:
% 1. event: struc with event informations, fields: event.sample and
% event.value (state)
% 2. Data: Main window data strucure with all relevant dataset compontntes
% 3. InputChannelSelection: vector with event channel numbers to extract

% Output
% 1.Events: cell array with each cell being a 1 x nevents vector with
% samples
% 2. EventChannelNames: cell array with char for each event channel holding its name 

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
% 6. DownsampleRate: string with downsamplerate specified by the user
% 7. executablefolder: char, folder NeuroMod was started in
% 8. StateOption: char, for trigger onset/offset, see below for options

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Extract_Events_Module_Start_NEO_EventExtraction.m
%________________________________________________________________________________________
%% Function to start neo for event extraction when a folder was selected manually by the user

% Inputs: 
% 1. Data: main window data structure
% 2. executablefolder: char, folder NeuroMod was started from
% 3. SelectedPath: char, path to event files selected by user
% 4. NEOParameter: struc with some information for NEO

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

