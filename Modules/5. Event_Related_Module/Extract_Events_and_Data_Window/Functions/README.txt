This folder contains the following functions with respective Header:

 ###################################################### 

File: Event_Module_Extract_Event_Related_Data.m
%________________________________________________________________________________________
%% Function to extract event related data as a nchannel x nevents x ntime matrix

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the infio structure with infos about extracted events.
% 2. EventChannel: Name of the event channel you want to calculate the ERD
% data for; as char; i.e. 'DIN-04' (saved in Data.Info.EventChannelNames)
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
%data

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the info structure with infos about extracted events.
% 2. Path: char path to folder containing the recording (Data.Info.Data_Path)
% 3. TextAreaObject: app window textarea to show infpramtion about fpund
%channel in -- shows progress and path
% 4. TextArea_2Object: app window textarea to show infpramtion about fpund
%channel in -- shows found channel names and infos
% 5. FileType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.

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
% all foldercontents found) -- usefull but not used yet
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

% This function actually loads event files (.data files only! .rhd are loaded when gui started to show info about it)and passes 1 x ntime vector of
% event data into Extract_Events_Module_Extract_Event_Indicies_Intan
% function to extract event indicies exceeding a treshold

%gets called in the Extract_Events_Module_Main_Function function when the user starts the event extraction for intan data

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

File: Extract_Events_Module_Extract_Open_Ephys_Events.m
%________________________________________________________________________________________

Info = [];
Events = {};

% Create a session (loads all data from the most recent recording)
session = Session(Path);

Info.NodeNrs = length(session.recordNodes);

%% If Exctract event window is opened, just get indos about available events from all available nodes. -- Loops through all of them
if strcmp(WhatToDo,"Get Information")
    Events = cell(1,length(session.recordNodes));
    
    for k = 1:length(session.recordNodes)
            
        node = session.recordNodes{k};
        
        for j = 1:length(node.recordings)
        
            % Get the first recording 
            recording = node.recordings{1,j};
        
            %% Handle Event Data
            % 3. Overlay all available event data
            eventProcessors = recording.ttlEvents.keys();
            for p = 1:length(eventProcessors)
                processor = eventProcessors{p};
                events = recording.ttlEvents(processor);
    
                if ~isempty(events.line)
                    Info.AvailabelNodes{k} = k;
                    Events{k} = events;
                end
            end  
        end % node.recordings
    end

    EventstoDeltete = [];
    for i = 1:length(Events)
        if isempty(Events{i})
            EventstoDeltete = [EventstoDeltete,i];
        end
    end
    if ~isempty(EventstoDeltete)
        Events(EventstoDeltete) = [];
        Info.AvailabelNodes(EventstoDeltete) = [];
    end
end

%% Extract actual events
% -- here, not all nodes get analyzed but those that are selected by the
% user
if strcmp(WhatToDo,"All")
    node = session.recordNodes{NodeNr};
    Events = {};
    
    for j = 1:length(node.recordings)
    
        % Get the first recording 
        recording = node.recordings{1,j};
    
        %% Handle Event Data
        % 3. Overlay all available event data
        eventProcessors = recording.ttlEvents.keys();
        for p = 1:length(eventProcessors)
            processor = eventProcessors{p};
            events = recording.ttlEvents(processor);
    
            if ~isempty(events.line)
                if isprop(events,'nodeID')
                    if length(unique(events.nodeID)) > 1
                        warning("Multiple Node IDs found. Only extracting events for the first one");
                    end
                    NodeIdIndicies = events.nodeID == events.nodeID(1);
                    if isprop(events,'sample_number')
                        sampleNumber = events.sample_number(NodeIdIndicies==1);
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = events.sampleNumber(NodeIdIndicies==1);
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('events.',fieldname));
                            end
                        end
                    end
                elseif isprop(events,'processor_id')
                    if length(unique(events.processor_id)) > 1
                        warning("Multiple processor IDs found. Only extracting events for the first one");
                    end
                    NodeIdIndicies = events.processor_id == events.processor_id(1);
                    if isprop(events,'sample_number')
                        sampleNumber = events.sample_number(NodeIdIndicies==1);
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = events.sampleNumber(NodeIdIndicies==1);
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('events.',fieldname));
                            end
                        end
                    end
                elseif isprop(events,'nodeId')
                    if length(unique(events.nodeId)) > 1
                        warning("Multiple Node IDs found. Only extracting events for the first one");
                    end
                    NodeIdIndicies = events.nodeId == events.nodeId(1);
                    if isprop(events,'sample_number')
                        sampleNumber = events.sample_number(NodeIdIndicies==1);
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = events.sampleNumber(NodeIdIndicies==1);
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('events.',fieldname));
                            end
                        end
                    end
                else
                    NodeIdIndicies = zeros(length(events.line),1)+1;
                    if isprop(events,'sample_number')
                        sampleNumber = events.sample_number(NodeIdIndicies==1);
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = events.sampleNumber(NodeIdIndicies==1);
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('events.',fieldname));
                            end
                        end
                    end
                end

                eventlines = events.line(NodeIdIndicies==1);
                states = events.state(NodeIdIndicies==1);
    
                for nevents = 1:length(InputChannelSelection) %% Loop over different event inputs
                    if ~isempty(eventlines)
                        
                        EventLines = eventlines == InputChannelSelection(nevents);
                        TempSampleNumber = sampleNumber(EventLines==1);
                        TempEventState = states(EventLines==1);
                        TempEventStateIndicies = double(TempEventState) == str2double(StateSelection);
                        
                        allsamples = double(TempSampleNumber(TempEventStateIndicies == 1));
                        
                        zerosample = allsamples == 0;

                        if sum(zerosample)>0
                            msgbox("Warning: Sample Nr 0 found and deleted");
                            allsamples(zerosample==1) = [];
                        end

                        Events{nevents} = allsamples';
                        
                        Info.NrEventChannel = recording.ttlEvents.Count;
                        Info.EventChannelName{nevents} = strcat("Event Input Line ",num2str(InputChannelSelection(nevents)));
                        Info.EventChannelType = strcat("Recording Node ", num2str(NodeNr)," TTL");
                        %% Event ChannelNames

                    else
                        Events = [];
                    end
                end
                
            end
        end  
    end % node.recordings
end % WhatToDo == "All"


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

File: Extract_Events_Module_Show_ChannelPlots.m
%________________________________________________________________________________________
%% Function to plot event data of a selected event channel 
% this function searches on startup through possible events and polots data
% for the first event channel found. Otherwise it plots/returns info that
% no data found for specified channel

% gets called when the user clicks on "Show Input Channel Plots" in the
% extract data windiw and opens the Show_Event_Channel_Window app.

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

