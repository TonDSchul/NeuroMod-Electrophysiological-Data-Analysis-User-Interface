function [Events,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Path,WhatToDo,NodeNr,NoddeID,InputChannelSelection,StateSelection,FirstTimeStampinSample,AllRecordingIndicies)

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
% 7. FirstTimeStampinSample: double in seconds, TimeStamp of start of recording respective to
% the aquisition start. Found in Data.Info
% 8. AllRecordingIndicies: vector of recording indicies selected at data
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

Info = [];
Events = {};

% Create a session (loads all data from the most recent recording)
session = Session(Path);

Info.NodeNrs = length(session.recordNodes);


%% If Exctract event window is opened, just get indos about available events from all available nodes. -- Loops through all of them
if strcmp(WhatToDo,"Get Information")
    Events = cell(1,length(session.recordNodes));
    TempEvents = cell(1,length(session.recordNodes));
    Info.startTimestamp = cell(1,length(session.recordNodes));

    Info.AvailabelNodes = cell(1,length(session.recordNodes));
    % Get the first recording 

    for k = 1:length(session.recordNodes)
        
        node = session.recordNodes{k};
        if length(node.recordings)>1
            disp(strcat("Found ",num2str(length(node.recordings))," Recordings. Taking recordings ", num2str(AllRecordingIndicies)," which got define when data was extracted."))
        end

        for nrrecordings = 1:length(AllRecordingIndicies)
        
            % Get the first recording 
            recording = node.recordings{1,AllRecordingIndicies(nrrecordings)};

            % Iterate over all data streams in the recording 
            streamNames = recording.continuous.keys();
            streamName = streamNames{1};
            % 1. Get the continuous data from the current stream/recording
            ContinousStream = recording.continuous(streamName);
            if strcmp(node.format,'OpenEphys') || strcmp(node.format,'Binary')
                Info.startTimestamp{k}(nrrecordings) = ContinousStream.metadata.startTimestamp;
            elseif strcmp(node.format,'NWB')
                TempHeader = ContinousStream.metadata;
                Info.startTimestamp{k}(nrrecordings) = TempHeader.startTimestamp;
            end

            %% Handle Event Data
            % 3. Overlay all available event data
            eventProcessors = recording.ttlEvents.keys();
            if length(eventProcessors)>1
                disp("Multiple event processors found. Only one supported at a time. At standard, first processor is selected. Go to Extract_Events_Module_Extract_Open_Ephys_Events line 86 to change!")
                eventProcessors = eventProcessors{1};
            end

            for p = 1:length(eventProcessors)
                processor = eventProcessors{p};
                events = recording.ttlEvents(processor);
    
                if ~isempty(events.line)
                    if nrrecordings == 1 % --> only dataframe of first recording with events get saved. This is bc its not straighforward to concatonate two data frames and this is only to show some event infos in the app window
                        if ~isempty(events)
                            Info.AvailabelNodes{k} = k;
                            Events{k} = events;
                        else
                            if ~isempty(Info.AvailabelNodes{k})
                                Info.AvailabelNodes{k} = [];
                            end
                            if ~isfield(Events{k},'line')
                                Events{k}.line = [];
                                Events{k}.Properties = [];
                                Events{k}.nodeId = [];
                                Events{k}.sample_number = [];
                                Events{k}.state = [];
                                Events{k}.timestamp = [];
                            end
                        end
                    end
                    if nrrecordings > 1
                        Info.AvailabelNodes{k} = k;
                        TempEvents{k}.line = [Events{k}.line;events.line];
                        if isprop(events,'nodeId')
                            TempEvents{k}.nodeId = [Events{k}.nodeId;events.nodeId];
                        elseif isprop(events,'processor_id')
                            TempEvents{k}.nodeId = [Events{k}.nodeId;events.processor_id];
                        else
                            TempEvents{k}.nodeId = [];
                        end
                        TempEvents{k}.sample_number = [Events{k}.sample_number;events.sample_number];
                        TempEvents{k}.state = [Events{k}.state;events.state];
                        TempEvents{k}.timestamp = [Events{k}.timestamp;events.timestamp];
                        TempEvents{k}.Properties = events.Properties;
                        Events(k) = [];
                        Events{k} = TempEvents{k};
                        TempEvents(k) = [];
                    end
                else
                    if ~isempty(Info.AvailabelNodes{k})
                        Info.AvailabelNodes{k} = [];
                    end

                    if ~isfield(Events{k},'line')
                        Events{k}.Properties = [];
                        Events{k}.line = [];
                        Events{k}.nodeId = [];
                        Events{k}.sample_number = [];
                        Events{k}.state = [];
                        Events{k}.timestamp = [];
                    end
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
        if isfield(Info,'AvailabelNodes')
            Info.AvailabelNodes(EventstoDeltete) = [];
        else
            disp("No Events found");
        end
    end
end

%% Extract actual events
% -- here, not all nodes get analyzed but those that are selected by the
% user

if strcmp(WhatToDo,"All")
    node = session.recordNodes{NodeNr};
    Events = {};
    
    if length(node.recordings)>1
        disp(strcat("Found ",num2str(length(node.recordings))," Recordings. Taking recordings ", num2str(AllRecordingIndicies)," which got define when data was extracted."))
    end

    % Strcuture capturing event sample over recordings
    sampleNumber = [];
    eventlines = [];
    states = [];

    for nrrecordings = 1:length(AllRecordingIndicies)
        
        NodeIdIndicies = [];

        % Get the first recording 
        recording = node.recordings{1,AllRecordingIndicies(nrrecordings)};
        
        %% Handle Event Data
        % 3. Overlay all available event data
        eventProcessors = recording.ttlEvents.keys();

        if ~isempty(eventProcessors)
            if length(eventProcessors)>1
                disp("Multiple event procesors found. Only one supported at a time. First one is autoselected.")
            end
            Processortotake = 1;
        else
            Processortotake = 0;
        end

        for p = 1:Processortotake
            processor = eventProcessors{p};
            events = recording.ttlEvents(processor);
    
            if ~isempty(events.line)
                if isprop(events,'nodeID')
                    if length(unique(events.nodeID)) > 1
                        warning("Multiple Node IDs found. Only extracting events for the first one");
                    end
                    NodeIdIndicies = events.nodeID == events.nodeID(1);
                    if isprop(events,'sample_number')
                        sampleNumber = [sampleNumber;double(events.sample_number(NodeIdIndicies==1))];
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = [sampleNumber;double(events.sampleNumber(NodeIdIndicies==1))];
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('[sampleNumber;double(events.',fieldname,')];'));
                            end
                        end
                    end
                elseif isprop(events,'processor_id')
                    if length(unique(events.processor_id)) > 1
                        warning("Multiple processor IDs found. Only extracting events for the first one");
                    end
                    NodeIdIndicies = events.processor_id == events.processor_id(1);
                    if isprop(events,'sample_number')
                        sampleNumber = [sampleNumber;double(events.sample_number(NodeIdIndicies==1))];
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = [sampleNumber;double(events.sampleNumber(NodeIdIndicies==1))];
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('[sampleNumber;double(events.',fieldname,')];'));
                            end
                        end
                    end
                elseif isprop(events,'nodeId')
                    if length(unique(events.nodeId)) > 1
                        warning("Multiple Node IDs found. Only extracting events for the first one");
                    end
                    NodeIdIndicies = events.nodeId == events.nodeId(1);
                    if isprop(events,'sample_number')
                        sampleNumber = [sampleNumber;double(events.sample_number(NodeIdIndicies==1))];
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = [sampleNumber;double(events.sampleNumber(NodeIdIndicies==1))];
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('[sampleNumber;double(events.',fieldname,')];'));
                            end
                        end
                    end
                else
                    NodeIdIndicies = zeros(length(events.line),1)+1;
                    if isprop(events,'sample_number')
                        sampleNumber = [sampleNumber;double(events.sample_number(NodeIdIndicies==1))];
                    elseif isprop(events,'sampleNumber')
                        sampleNumber = [sampleNumber;double(events.sampleNumber(NodeIdIndicies==1))];
                    else
                        for nprops = 1:length(events.Properties.VariableNames)
                            if ~isempty(strfind(events.Properties.VariableNames{nprops},'sample'))
                                fieldname = events.Properties.VariableNames{nprops};
                                sampleNumber = eval(strcat('[sampleNumber;double(events.',fieldname,')];'));
                            end
                        end
                    end
                end % prop name (ffile format)
            end % ~isempty events
        end % Processors (always 1 at the moment)

        if ~isempty(FirstTimeStampinSample) && ~isempty(sampleNumber)
            sampleNumber = sampleNumber - FirstTimeStampinSample(nrrecordings);
        else
            disp("Warning: Could not substract first timestamp of recording start from event times. This is normal if recording was started immediately or doesn not contain events. If this is not the reason, event times can lie outside of time limits without the first timestamp correction!")
        end

        if ~isempty(NodeIdIndicies) && ~isempty(events.line)
            eventlines = [eventlines,events.line(NodeIdIndicies==1)];
            states = [states,events.state(NodeIdIndicies==1)];
        end

    end % node.recordings

    %% fill the actaul event cell array holding all event indicies - note: starttimestamp already substracted before!
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
    
            %% If data aquistion is started after recording start, the time stamp the recording starts with is unequal 0. 
            % Time vecor is created automatically starting with 0, so its not
            % influenced by this. Event times hoevwer have to be adjusted
            
            Info.NrEventChannel = recording.ttlEvents.Count;
            Info.EventChannelName{nevents} = strcat("Event Input Line ",num2str(InputChannelSelection(nevents)));
            Info.EventChannelType = strcat("Recording Node ", num2str(NodeNr)," TTL");
            %% Event ChannelNames
    
        else
            Events = [];
        end
    end
            
end % WhatToDo == "All"


