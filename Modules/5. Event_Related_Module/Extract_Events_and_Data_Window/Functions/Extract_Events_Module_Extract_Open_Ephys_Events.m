function [Events,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Data,Path,WhatToDo,NodeNr,NoddeID,InputChannelSelection,StateSelection,FirstTimeStampinSample,AllRecordingIndicies)

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
% 8. FirstTimeStampinSample: double in seconds, TimeStamp of start of recording respective to
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

Info = [];
Events = {};

% Create a session (loads all data from the most recent recording)
session = Session(Path);

Info.NodeNrs = length(session.recordNodes);

NeuropixelsRecording = [];
if isfield(Data.Info,'NeuropixelProbe')
    NeuropixelsRecording = 1;
end

%% If Exctract event window is opened, just get indos about available events from all available nodes. -- Loops through all of them
if strcmp(WhatToDo,"Get Information")
    Events = cell(1,length(session.recordNodes));
    TempEvents = cell(1,length(session.recordNodes));
    Info.startTimestamp = cell(1,length(session.recordNodes));

    Info.AvailabelNodes = cell(1,length(session.recordNodes));
    % Get the first recording 

    disp(strcat("Found ",num2str(length(session.recordNodes))," Nodes."))

    for nNode = 1:length(session.recordNodes)
        
        disp(strcat("Searching Node ",num2str(nNode)," for event data"));

        % Get nodes
        node = session.recordNodes{nNode};

        if strcmp(node.name,Data.Info.RecordingNode) 
            NrRecordingsinNode = AllRecordingIndicies;
             if length(node.recordings)>1
                disp(strcat("Found ",num2str(length(node.recordings))," Recordings. Taking recordings ", num2str(AllRecordingIndicies)," which got define when data was extracted."))
            end
        else
            NrRecordingsinNode = 1:length(node.recordings);
            if ~isequal(NrRecordingsinNode, AllRecordingIndicies)
                warning('Selected number of recordings for extracted node not the same as for current node. Proceeding to extract all recordings from that node. If you extracted data from another node and only selected a subset of recordings, time scales between node events can be different!! The exception CAN be .nwb format. Multiple recordings will always be extracted together and only be visible as a single recording! In doubt, extract all recordings found and repeat.')
                disp(strcat("Found ",num2str(length(node.recordings))," recordings. Taking all of them for event extraction."));
            else
                if length(node.recordings)>1
                    disp(strcat("Found ",num2str(length(node.recordings))," Recordings. Taking recordings ", num2str(AllRecordingIndicies)," which got define when data was extracted."))
                end
            end
        end

        for nrrecordings = 1:length(NrRecordingsinNode)
        
            % Get the first recording 
            recording = node.recordings{1,NrRecordingsinNode(nrrecordings)};

            % Iterate over all data streams in the recording 
            streamNames = recording.continuous.keys();
            streamName = streamNames{1};

            % 1. Get the continuous data from the current stream/recording
            ContinousStream = recording.continuous(streamName);

            if strcmp(node.format,'OpenEphys') || strcmp(node.format,'Binary')
                Info.startTimestamp{nNode}(nrrecordings) = ContinousStream.metadata.startTimestamp;
            elseif strcmp(node.format,'NWB')
                TempHeader = ContinousStream.metadata;
                Info.startTimestamp{nNode}(nrrecordings) = TempHeader.startTimestamp;
            end

            %% Handle Event Data
            % 3. Overlay all available event data
            eventProcessors = recording.ttlEvents.keys();
            
            ProcessorIndex = 1;

            if length(eventProcessors)>1 && isempty(NeuropixelsRecording)
                disp("Multiple event processors found. Only one supported at a time. At standard, first processor is selected. Go to Extract_Events_Module_Extract_Open_Ephys_Events.m to change!")
            elseif NeuropixelsRecording == 1 % NP 1.0 Recording
                ProcessorIndex = [];
                for i = 1:length(eventProcessors)
                    if strcmp(Data.Info.streamName,eventProcessors{i})
                        ProcessorIndex = i;
                    end
                end

                if isempty(ProcessorIndex)
                    ProcessorIndex = 1;
                    warning('Processor ID saved during data extraction is not part of event processor IDs in Extract_Events_Module_Extract_Open_Ephys_Events.m. Taking first event processor found.')
                end
            end

            eventProcessors = eventProcessors{ProcessorIndex};

            for p = 1:1 % Always 1 so far

                events = recording.ttlEvents(eventProcessors);
                
                if ~isempty(FirstTimeStampinSample) && ~isempty(events.sample_number)
                    events.sample_number = double(events.sample_number) - FirstTimeStampinSample(nrrecordings);
                    events.timestamp = events.timestamp - (FirstTimeStampinSample(nrrecordings)/Data.Info.NativeSamplingRate);
                    if nrrecordings >= 2
                        RecordingTimeSamples = Data.Info.RecordingTime*Data.Info.NativeSamplingRate;
                        events.sample_number = double(events.sample_number) + sum(RecordingTimeSamples(1:nrrecordings-1));
                        events.timestamp = events.timestamp + sum(Data.Info.RecordingTime(1:nrrecordings-1));
                    end
                else
                    disp("Warning: Could not substract first timestamp of recording start from event times. This is normal if recording was started immediately or doesn not contain events. If this is not the reason, event times can lie outside of time limits without the first timestamp correction!")
                end

                % Found Events
                if ~isempty(events.line)
                    % first recording index
                    if nrrecordings == 1 % --> only dataframe of first recording with events get saved. This is bc its not straighforward to concatonate two data frames and this is only to show some event infos in the app window
                        if ~isempty(events)
                            Info.AvailabelNodes{nNode} = nNode;
                            Events{nNode} = events;
                        else
                            % if ~isempty(Info.AvailabelNodes{nNode})
                            %     Info.AvailabelNodes{nNode} = [];
                            % end
                            if isempty(Events{nNode})
                                Events{nNode}.line = [];
                                Events{nNode}.Properties = [];
                                Events{nNode}.nodeId = [];
                                Events{nNode}.processor_id = [];
                                Events{nNode}.sample_number = [];
                                Events{nNode}.state = [];
                                Events{nNode}.timestamp = [];
                            end
                        end
                    end

                    % Second, third... recording, if available
                    if nrrecordings > 1
                        Info.AvailabelNodes{nNode} = nNode;
                        
                        TempEvents{nNode}.line = [Events{nNode}.line;events.line];
                        if isprop(events,'nodeId')
                            TempEvents{nNode}.nodeId = [Events{nNode}.nodeId;events.nodeId];
                        elseif isprop(events,'processor_id')
                            TempEvents{nNode}.processor_id = [Events{nNode}.processor_id;events.processor_id];
                        else
                            TempEvents{nNode}.nodeId = [];
                        end
                        TempEvents{nNode}.sample_number = [Events{nNode}.sample_number;events.sample_number];
                        TempEvents{nNode}.state = [Events{nNode}.state;events.state];
                        TempEvents{nNode}.timestamp = [Events{nNode}.timestamp;events.timestamp];
                        TempEvents{nNode}.Properties = events.Properties;
                        Events(nNode) = [];
                        Events{nNode} = TempEvents{nNode};
                        TempEvents(nNode) = [];
                    end
                else
                    if isempty(Events{nNode})
                        Events{nNode}.Properties = [];
                        Events{nNode}.line = [];
                        Events{nNode}.nodeId = [];
                        Events{nNode}.processor_id = [];
                        Events{nNode}.sample_number = [];
                        Events{nNode}.state = [];
                        Events{nNode}.timestamp = [];
                    end
                end % isempty(lines)
            end  % Processors
        end % node.recordings

        if isempty(Events{nNode})
            if ~isempty(Info.AvailabelNodes{nNode})
                Info.AvailabelNodes{nNode} = [];
                disp(strcat("No Events in Node ",num2str(nNode)," found"));
            end
        else
            if isstruct(Events{nNode})
                if ~isfield(Events{nNode},'line')
                    if ~isempty(Info.AvailabelNodes{nNode})
                        Info.AvailabelNodes{nNode} = [];
                        disp(strcat("No Events in Node ",num2str(nNode)," found"));
                    end
                end
            else
                if ~isprop(Events{nNode},'line')
                    if ~isempty(Info.AvailabelNodes{nNode})
                        Info.AvailabelNodes{nNode} = [];
                        disp(strcat("No Events in Node ",num2str(nNode)," found"));
                    end
                end
            end
        end
    end

    % Cleaning 
    for i = 1:length(Events)
        if isfield(Events{i},'processor_id')
            if isempty(Events{i}.processor_id)
                % Remove the 'Age' field
                Events{i} = rmfield(Events{i}, 'processor_id');
            end
        end
        if isfield(Events{i},'nodeId')
            if isempty(Events{i}.nodeId)
                % Remove the 'Age' field
                Events{i} = rmfield(Events{i}, 'nodeId');
            end
        end
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
    
    if strcmp(node.name,Data.Info.RecordingNode) 
        NrRecordingsinNode = AllRecordingIndicies;
         if length(node.recordings)>1
            disp(strcat("Found ",num2str(length(node.recordings))," Recordings. Taking recordings ", num2str(AllRecordingIndicies)," which got define when data was extracted."))
        end
    else
        NrRecordingsinNode = 1:length(node.recordings);
        if ~isequal(NrRecordingsinNode, AllRecordingIndicies)
            warning('Selected number of recordings for extracted node not the same as for current node. Proceeding to extract all recordings from that node. If you extracted data from another node and only selected a subset of recordings, time scales between node events can be different!! The exception CAN be .nwb format. Multiple recordings will always be extracted together and only be visible as a single recording! In doubt, extract all recordings found and repeat.')
            disp(strcat("Found ",num2str(length(node.recordings))," recordings. Taking all of them for event extraction."));
        else
            if length(node.recordings)>1
                disp(strcat("Found ",num2str(length(node.recordings))," Recordings. Taking recordings ", num2str(AllRecordingIndicies)," which got define when data was extracted."))
            end
        end
    end

    % Strcuture capturing event sample over recordings
    sampleNumber = [];
    eventlines = [];
    states = [];

    for nrrecordings = 1:length(NrRecordingsinNode)
        
        disp(strcat("Extracting events from recording number ",num2str(nrrecordings)));

        NodeIdIndicies = [];

        % Get the first recording 
        recording = node.recordings{1,NrRecordingsinNode(nrrecordings)};
        
        %% Handle Event Data
        % 3. Overlay all available event data
        eventProcessors = recording.ttlEvents.keys();
            
        ProcessorIndex = 1;

        if length(eventProcessors)>1 && isempty(NeuropixelsRecording)
            disp("Multiple event processors found. Only one supported at a time. At standard, first processor is selected. Go to Extract_Events_Module_Extract_Open_Ephys_Events.m to change!")
        elseif NeuropixelsRecording == 1 % NP 1.0 Recording
            ProcessorIndex = [];
            for i = 1:length(eventProcessors)
                if strcmp(Data.Info.streamName,eventProcessors{i})
                    ProcessorIndex = i;
                end
            end
            if isempty(ProcessorIndex)
                ProcessorIndex = 1;
                warning('Processor ID saved during data extraction is not part of event processor IDs in Extract_Events_Module_Extract_Open_Ephys_Events.m. Taking first event processor found.')
            end
        end

        eventProcessors = eventProcessors{ProcessorIndex};

        for p = 1:1 % always 1 so far

            events = recording.ttlEvents(eventProcessors);
    
            if ~isempty(FirstTimeStampinSample) && ~isempty(events.sample_number)
                events.sample_number = double(events.sample_number) - FirstTimeStampinSample(nrrecordings);
                events.timestamp = events.timestamp - (FirstTimeStampinSample(nrrecordings)/Data.Info.NativeSamplingRate);
                if nrrecordings >= 2
                    RecordingTimeSamples = Data.Info.RecordingTime*Data.Info.NativeSamplingRate;
                    events.sample_number = double(events.sample_number) + sum(RecordingTimeSamples(1:nrrecordings-1));
                    events.timestamp = events.timestamp + sum(Data.Info.RecordingTime(1:nrrecordings-1));
                end
            else
                if isempty(events.sample_number)
                    disp(strcat("No events found for recording ",num2str(nrrecordings)));
                else
                    Warning("Could not substract first timestamp of recording start from event times. This is normal if recording was started immediately or doesn not contain events. If this is not the reason, event times can lie outside of time limits without the first timestamp correction!")
                end
            end 

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

        if ~isempty(NodeIdIndicies) && ~isempty(events.line)
            if size(events.line,1) < size(events.line,2)
                eventlines = [eventlines,events.line(NodeIdIndicies==1)];
                states = [states,events.state(NodeIdIndicies==1)];
            else
                eventlines = [eventlines;events.line(NodeIdIndicies==1)];
                states = [states;events.state(NodeIdIndicies==1)];
            end
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


