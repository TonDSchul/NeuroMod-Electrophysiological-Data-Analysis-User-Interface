function Extract_Events_Module_Set_Up_Window(app,Data,EventInfo,Path,FilePaths,FileEndingsExist,texttoshow,TimeOfExecution,Info)

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

ExistChangedEventChannelType = 0;

%% Only on Folder Change -- no neuralynx yet, only one event supported (called trigger)
if strcmp(TimeOfExecution,"ChangedEventChannelType") 
    
    % Selected field - digital inputs is standard
    EventChannelName = app.FileTypeDropDown.Value;

    %% Intan recordings
    if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")
        if strcmp(EventChannelName,"Digital Inputs")
            if isfield(app.EventInfo,'DIChannel')
                NumChannel = length(app.EventInfo.DIChannel);
                ExistChangedEventChannelType = 1;
            end
        elseif strcmp(EventChannelName,"Analog Input")
            if isfield(app.EventInfo,'ADCChannel')
                NumChannel = length(app.EventInfo.ADCChannel);
                ExistChangedEventChannelType = 1;
            end
        elseif strcmp(EventChannelName,"AUX Inputs")
            if isfield(app.EventInfo,'AUXChannel')
                NumChannel = length(app.EventInfo.AUXChannel);
                ExistChangedEventChannelType = 1;
            end
        elseif strcmp(EventChannelName,"DIN Inputs")
            if isfield(app.EventInfo,'DINChannel')
                NumChannel = length(app.EventInfo.DINChannel);
                ExistChangedEventChannelType = 1;
            end
        end
        app.TextArea_2.Value = texttoshow;
    
        %% TDT Tank Data
    elseif strcmp(Data.Info.RecordingType,"TDT Tank Data")
        
        EventDataTye = [];

        if strcmp(app.FileTypeDropDown.Value,'TDT Trigger scalars:Evnt') 
            EventDataTye = 'sE';
        elseif strcmp(app.FileTypeDropDown.Value,'TDT Trigger scalars:Tria') 
            EventDataTye = 'sT';
        elseif strcmp(app.FileTypeDropDown.Value,'TDT Trigger epocs:Evnt') 
            EventDataTye = 'eE';
        elseif strcmp(app.FileTypeDropDown.Value,'TDT Trigger epocs:Tria') 
            EventDataTye = 'eT';
        elseif strcmp(app.FileTypeDropDown.Value,'TDT Trigger epocs:Brst') 
            EventDataTye = 'eB';
        elseif strcmp(app.FileTypeDropDown.Value,'TDT Trigger epocs:Stro') 
            EventDataTye = 'eS';
        elseif strcmp(app.FileTypeDropDown.Value,'TDT Trigger epocs:Tick') 
            EventDataTye = 'eT';
        end
        
        % Create header
        lines = ["Channel | Sample"];
        
        % Loop through events and build rows
        for i = 1:numel(EventInfo.(EventDataTye).ChannelIdentities)
            line = sprintf('%d | %d', EventInfo.(EventDataTye).ChannelIdentities(i), EventInfo.(EventDataTye).Timestamps(i));
            lines(end+1) = string(line);
        end

        app.TextArea_2.Value = lines;
        
        NumChannel = length(EventInfo.(EventDataTye).EventChannel);
        
        % Get unique values
        % app.FileTypeDropDown.Items = {};
        % for i = 1:length(EventInfo.Type)
        %     app.FileTypeDropDown.Items{i} = convertStringsToChars(strcat("TDT Trigger ",EventInfo.Type{i}));
        % end

        % Initialize an empty string
        ChannelSelectionToShow = '';

        % Loop through numbers from 1 to 10
        for i = 1:NumChannel
            % Append each number to the string
            ChannelSelectionToShow = [ChannelSelectionToShow, num2str(EventInfo.(EventDataTye).EventChannel(i))];
            
            % If it's not the last number, add a comma
            if i < NumChannel
                ChannelSelectionToShow = [ChannelSelectionToShow, ','];
            end
        end  
        
        EventChannelName = app.FileTypeDropDown.Items{1};

        ExistChangedEventChannelType = 1;
        
        app.InputChannelSelectionEditField.Value = ChannelSelectionToShow;
        % app.FileTypeDropDown.Value = EventChannelName;

    %% Spike 2 recording
    elseif strcmp(Data.Info.RecordingType,"Spike2")
        
        app.TextArea_2.Value = texttoshow;
        NumChannel = 1;
        ExistChangedEventChannelType = 1;

    %% OE Recordings
    elseif strcmp(Data.Info.RecordingType,"Open Ephys")
        % This holds the index of nodes containing events
        %% Search for open ephys data
        FolderIndicieWithEphysData = [];
        % Filepaths is string array with folder contens. need to filter our
        % record node info
        for foldercontents = 1:length(FilePaths)
            if contains(FilePaths(foldercontents),'Record Node')
                if isfolder(strcat(Path,'\',FilePaths(foldercontents)))
                    FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
                end
            end
        end
        % Get indicie of folder corresponding to currently selected event
        EventIndicie = [];
        Nodefolder = FilePaths(FolderIndicieWithEphysData);
        for i = 1:length(Nodefolder)
            if strcmp(Nodefolder(i),EventChannelName)
                EventIndicie = i;
            end
        end

        % Set ExistChangedEventChannelType true or false, depending on
        % whether nodes were found
        if isempty(EventIndicie)
            ExistChangedEventChannelType = 0;
        end

        for i = 1:length(Info.AvailabelNodes)
            if find(EventIndicie==Info.AvailabelNodes{i})
                ExistChangedEventChannelType = 1;
                NumChannel = length(unique(EventInfo{i}.line));
                break;
            else
                ExistChangedEventChannelType = 0;
            end
        end
    end % loop through recording systems

    %% Get Channel names, channel nr. and fill into GUI

    % If selected channel not available
    if ExistChangedEventChannelType == 0 % Only on Startup/Folder Change
        msgbox(strcat("No Event Channel of Type ",app.FileTypeDropDown.Value," found!"));
        app.NrInputChinfolderEditField.Value = "";
        app.InputChannelSelectionEditField.Value = "";
        pause(0.2);
        if strcmp(Data.Info.RecordingType,"Open Ephys")
            app.TextArea_2.Value = strcat("No Event Channel of Type ",app.FileTypeDropDown.Value," found!");
        end
        return;

    % If selected channel available
    else
        %% Fill GUI with found Info OE
        if strcmp(Data.Info.RecordingType,"Open Ephys")
            Nodetoshow = [];
            for i = 1:length(app.FileTypeDropDown.Items)
                if strcmp(app.FileTypeDropDown.Value,app.FileTypeDropDown.Items{i})
                    Nodetoshow = i;
                end
            end
            % To set nr of channel field
            NumChannel = length(unique(EventInfo{Nodetoshow}.line));
            % Initialize an empty string
            ChannelSelectionToShow = '';
            ChannelEventLineNames = double(unique(EventInfo{Nodetoshow}.line));
            % Loop through numbers from 1 to 10
            for i = 1:length(ChannelEventLineNames)
                % Append each number to the string
                ChannelSelectionToShow = [ChannelSelectionToShow, num2str(ChannelEventLineNames(i))];
                
                % If it's not the last number, add a comma
                if i < length(double(unique(EventInfo{Nodetoshow}.line)))
                    ChannelSelectionToShow = [ChannelSelectionToShow, ','];
                end
            end  
            
            %% Show Channel Info in TextArea
            Nodetoshow = [];
            for i = 1:length(app.FileTypeDropDown.Items)
                if strcmp(app.FileTypeDropDown.Value,app.FileTypeDropDown.Items{i})
                    Nodetoshow = i;
                end
            end

            tableText = evalc('disp(EventInfo{Nodetoshow})');  % Convert table to string
            
            % delte unwanted parts of the char
            cutpartsindicies = find(tableText =='>');
            TemptableText = [];

            if ~isempty(cutpartsindicies)
                tableText(1:cutpartsindicies(end)) = [];
            end

            for i = 1:length(EventInfo{Nodetoshow}.Properties.VariableNames)
                if i == 1
                    TemptableText = [TemptableText,EventInfo{Nodetoshow}.Properties.VariableNames{i}];
                else
                    TemptableText = [TemptableText,',',' ',' ',EventInfo{Nodetoshow}.Properties.VariableNames{i}];
                end
            end

            tableText = [TemptableText,tableText];
            % Display the text in the Text Area
            if isfield(Data.Info,'startTimestamp')
                app.TextArea_2.Value = [strcat("Start time stamp of event recording: ",num2str(Info.startTimestamp{Nodetoshow}));strcat("Number of recordings: ",num2str(length(Data.Info.AllRecordingIndicies)));"";tableText];
            else
                app.TextArea_2.Value = ["No aquisition start time stamp found. Cannot correct event times if recording and aquistion start are different";strcat("Number of recordings: ",num2str(length(Data.Info.AllRecordingIndicies)));"";tableText];
            end

        else %% All recording systems other than OE
            ChannelSelectionToShow = '';
            for i = 1:NumChannel
                % Append each number to the string
                if i ~= 1
                    ChannelSelectionToShow = [ChannelSelectionToShow,',',num2str(i)];
                else
                    ChannelSelectionToShow = [ChannelSelectionToShow, num2str(i)];
                end
            end   
        end
        
        app.InputChannelSelectionEditField.Value = ChannelSelectionToShow;
        app.NrInputChinfolderEditField.Value = num2str(NumChannel);
        
    end 
    % After Done, dont execute code below. This is for startup stuff
    return;
end
    
%% Set up text areas
if strcmp(TimeOfExecution,"Initial")  
    if isempty(EventInfo) || FileEndingsExist == 0
        if strcmp(Data.Info.RecordingType,"Spike2")
            app.TextArea_2.Value = "Warning: No event channel selected when extracting dataset. No events can be looded";
            app.TextArea.Value = strcat("No Event Channel can be extracted from: ",Path);
        else
            if strcmp(Data.Info.RecordingType,"NEO")
                app.TextArea_2.Value = "Warning: No event data found in folder the dataset was extracted to by NEO. Please select a different folder.";
            else
                app.TextArea_2.Value = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
                app.TextArea.Value = strcat("No Event Channel found in Path: ",Path);
            end
        end

        app.NrInputChinfolderEditField.Value = "";
        app.InputChannelSelectionEditField.Value = "";
        Placeholder = {};
        app.FileTypeDropDown.Items = Placeholder;
        app.FileTypeDropDown.Items{1} = '';
        pause(0.2);
        return;
    else
        % Fill Text Area showing path that was searched
        app.TextArea.Value = strcat("Finished looking for event channel from: ",Path);
        if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD") || strcmp(Data.Info.RecordingType,"NEO")
            % Fill Text Area showing channels found
            app.TextArea_2.Value = texttoshow;
        elseif strcmp(Data.Info.RecordingType,"Open Ephys")
            %% show first node from which data was extracted
            %% Search for open ephys data
            FolderIndicieWithEphysData = [];
            for foldercontents = 1:length(FilePaths)
                if contains(FilePaths(foldercontents),'Record Node')
                    if isfolder(strcat(Path,'\',FilePaths(foldercontents)))
                        FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
                    end
                end
            end
    
            Nodetoshowfirst = [];
            Nodefolder = FilePaths(FolderIndicieWithEphysData);
            for i = 1:length(Nodefolder)
                if strcmp(Data.Info.RecordingNode,Nodefolder(i))
                    Nodetoshowfirst = i;
                end
            end

            if isempty(Nodetoshowfirst)
                Nodetoshowfirst = 1;
            end
    
            if ~isempty(EventInfo{Nodetoshowfirst})
                if isprop(EventInfo{Nodetoshowfirst},'line') || isfield(EventInfo{Nodetoshowfirst},'line') 
                    if ~isempty(EventInfo{Nodetoshowfirst}.line)
                        tableText = evalc('disp(EventInfo{Nodetoshowfirst})');  % Convert table to string
                    
                        % delte unwanted parts of the char
                        cutpartsindicies = find(tableText =='>');
                        TemptableText = [];
            
                        if ~isempty(cutpartsindicies)
                            tableText(1:cutpartsindicies(end)) = [];
                        end
            
                        for i = 1:length(EventInfo{Nodetoshowfirst}.Properties.VariableNames)
                            if i == 1
                                TemptableText = [TemptableText,EventInfo{Nodetoshowfirst}.Properties.VariableNames{i}];
                            else
                                TemptableText = [TemptableText,',',' ',' ',EventInfo{Nodetoshowfirst}.Properties.VariableNames{i}];
                            end
                        end
            
                        tableText = [TemptableText,tableText];
                        % Display the text in the Text Area
                        if isfield(Data.Info,'startTimestamp')
                            app.TextArea_2.Value = [strcat("Start time stamp of event recording: ",num2str(Info.startTimestamp{Nodetoshowfirst}));strcat("Number of recordings: ",num2str(length(Data.Info.AllRecordingIndicies)));"";tableText];
                        else
                            app.TextArea_2.Value = ["No aquisition start time stamp found. Cannot correct event times if recording and aquistion start are different";strcat("Number of recordings: ",num2str(length(Data.Info.AllRecordingIndicies)));"";tableText];
                        end
                    else
                        app.TextArea_2.Value = "Warning: No event data found in the selected node. Please select a different record node.";
                    end
                else
                    app.TextArea_2.Value = "Warning: No event data found in the selected node. Please select a different record node.";
                end
            else
                app.TextArea_2.Value = "Warning: No event data found in the selected node. Please select a different record node.";
            end
        end
    end
end

%% Set up edit fields and dropdown menus
% Analyse how many input event channel exist
if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")  
    % get strings of channel 
    app.FileTypeDropDown.Items = {}; 
    NumIter = 1;
    % for i = 1:length(app.EventInfo)
    if isfield(app.EventInfo,'DIChannel')
        EventChannelName = 'Digital Inputs';
        NumChannel = length(app.EventInfo.DIChannel);
        app.FileTypeDropDown.Items{NumIter} = EventChannelName;
        NumIter = NumIter+1;
    end
    if isfield(app.EventInfo,'ADCChannel')
        EventChannelName = 'Analog Input';
        NumChannel = length(app.EventInfo.ADCChannel);
        app.FileTypeDropDown.Items{NumIter} = EventChannelName;
        NumIter = NumIter+1;
    end
    if isfield(app.EventInfo,'AUXChannel')
        EventChannelName = 'AUX Inputs';
        NumChannel = length(app.EventInfo.AUXChannel);
        app.FileTypeDropDown.Items{NumIter} = EventChannelName;
        NumIter = NumIter+1;
    end
    if isfield(app.EventInfo,'DINChannel')
        EventChannelName = 'DIN Inputs';
        NumChannel = length(app.EventInfo.DINChannel);
        app.FileTypeDropDown.Items{NumIter} = EventChannelName;
        NumIter = NumIter+1;
    end
    % end

    ChannelSelectionToShow = [];
    for i = 1:NumChannel
        if i ~= 1
            ChannelSelectionToShow = strcat(ChannelSelectionToShow,',',num2str(i));
        else
            ChannelSelectionToShow = num2str(i);
        end
    end

elseif strcmp(Data.Info.RecordingType,"Open Ephys")
    Nodetoshowfirst = [];
    Nodefolder = FilePaths(FolderIndicieWithEphysData);
    for i = 1:length(Nodefolder)
        if strcmp(Data.Info.RecordingNode,Nodefolder(i))
            Nodetoshowfirst = i;
        end
    end

    if isempty(Nodetoshowfirst)
        Nodetoshowfirst = 1;
    end

    if ~isempty(EventInfo{Nodetoshowfirst}) 
        NumChannel = length(double(unique(EventInfo{Nodetoshowfirst}.line)));
        % Initialize an empty string
        ChannelSelectionToShow = '';
        ChannelEventLineNames = double(unique(EventInfo{Nodetoshowfirst}.line));
        % Loop through numbers from 1 to 10
        for i = 1:length(ChannelEventLineNames)
            % Append each number to the string
            ChannelSelectionToShow = [ChannelSelectionToShow, num2str(ChannelEventLineNames(i))];
            
            % If it's not the last number, add a comma
            if i < length(unique(EventInfo{Nodetoshowfirst}.line))
                ChannelSelectionToShow = [ChannelSelectionToShow, ','];
            end
        end  
    else
        ChannelSelectionToShow = '';
        NumChannel = 0;
    end

    % This holds the index of nodes containing events
    %% Search for open ephys data
    FolderIndicieWithEphysData = [];
    for foldercontents = 1:length(FilePaths)
        if contains(FilePaths(foldercontents),'Record Node')
            if isfolder(strcat(Path,'\',FilePaths(foldercontents)))
                FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
            end
        end
    end

    Nodefolder = FilePaths(FolderIndicieWithEphysData);
    
    placeholder = {};
    app.FileTypeDropDown.Items = placeholder;
    
    for i = 1:Info.NodeNrs
        app.FileTypeDropDown.Items{i} = convertStringsToChars(Nodefolder(i));
    end

    Nodetoshowfirst = [];
    Nodefolder = FilePaths(FolderIndicieWithEphysData);
    for i = 1:length(Nodefolder)
        if strcmp(Data.Info.RecordingNode,Nodefolder(i))
            Nodetoshowfirst = i;
        end
    end

    app.FileTypeDropDown.Value = app.FileTypeDropDown.Items{Nodetoshowfirst};

    EventChannelName = app.FileTypeDropDown.Items{Nodetoshowfirst};      

elseif strcmp(Data.Info.RecordingType,"Neuralynx")

    if FileEndingsExist==1

        [event,Texttoshow] = Extract_Events_Module_Load_Neuralynx_Events(Data,Path);
        
        if isempty(event)
            app.TextArea_2.Value = Texttoshow;
            return;
        end

        [fieldData] = Extract_Events_Module_Display_Neuralynx_EventInfo(event);

        app.TextArea_2.Value = fieldData;
        
        EventChannel = double(cell2mat({event.value}));
        uniqueChannel = unique(EventChannel);
        NumChannel = length(uniqueChannel);
        
        % Get unique values
        app.FileTypeDropDown.Items = {};
        app.FileTypeDropDown.Items{1} = 'Neuralynx Trigger Channel';
       
        % Initialize an empty string
        ChannelSelectionToShow = '';

        % Loop through numbers from 1 to 10
        for i = 1:NumChannel
            % Append each number to the string
            ChannelSelectionToShow = [ChannelSelectionToShow, num2str(uniqueChannel(i))];
            
            % If it's not the last number, add a comma
            if i < NumChannel
                ChannelSelectionToShow = [ChannelSelectionToShow, ','];
            end
        end  
        
        EventChannelName = app.FileTypeDropDown.Items{1};
    end

elseif strcmp(Data.Info.RecordingType,"TDT Tank Data")

    if FileEndingsExist==1
        
        % Check 
       
        if isempty(EventInfo)
            app.TextArea_2.Value = 'No time stamps could be extracted!';
            return;
        end
        
        EventDataTye = [];
        if isfield(EventInfo,'sE')
            EventDataTye = 'sE';
        elseif isfield(EventInfo,'sT')
            EventDataTye = 'sT';
        elseif isfield(EventInfo,'eE')
            EventDataTye = 'eE';
        end
        
        % Create header
        lines = ["Channel | Sample"];
        
        % Loop through events and build rows
        for i = 1:numel(EventInfo.(EventDataTye).ChannelIdentities)
            line = sprintf('%d | %d', EventInfo.(EventDataTye).ChannelIdentities(i), EventInfo.(EventDataTye).Timestamps(i));
            lines(end+1) = string(line);
        end

        app.TextArea_2.Value = lines;
        
        NumChannel = length(EventInfo.(EventDataTye).EventChannel);
        
        % Get unique values
        app.FileTypeDropDown.Items = {};
        for i = 1:length(EventInfo.Type)
            app.FileTypeDropDown.Items{i} = convertStringsToChars(strcat("TDT Trigger ",EventInfo.Type{i}));
        end

        % Initialize an empty string
        ChannelSelectionToShow = '';

        % Loop through numbers from 1 to 10
        for i = 1:NumChannel
            % Append each number to the string
            ChannelSelectionToShow = [ChannelSelectionToShow, num2str(EventInfo.(EventDataTye).EventChannel(i))];
            
            % If it's not the last number, add a comma
            if i < NumChannel
                ChannelSelectionToShow = [ChannelSelectionToShow, ','];
            end
        end  
        
        EventChannelName = app.FileTypeDropDown.Items{1};
    end

elseif strcmp(Data.Info.RecordingType,"Spike2") 
    EventChannelName = [];
    NumChannel = [];
    Placeholder = {};
    app.FileTypeDropDown.Items = Placeholder;
    if ~isempty(app.EventInfo)
        if isfield(app.EventInfo,'EventChannel')
            if ~isempty(app.EventInfo.EventChannel)
                EventChannelName = strcat('Spike2 Channel');
                Placeholder = {};
                app.FileTypeDropDown.Items = {};
                app.FileTypeDropDown.Items{1} = strcat('Spike2 Channel');
            end
        end
    end
    ChannelRange = str2double(strsplit(app.EventInfo.EventChannel,','));
    NumChannel = length(ChannelRange);

     % Initialize an empty string
    ChannelSelectionToShow = '';

    % Loop through numbers from 1 to 10
    for i = 1:NumChannel
        % Append each number to the string
        ChannelSelectionToShow = [ChannelSelectionToShow, num2str(ChannelRange(i))];
        
        % If it's not the last number, add a comma
        if i < NumChannel
            ChannelSelectionToShow = [ChannelSelectionToShow, ','];
        end
    end  

elseif strcmp(Data.Info.RecordingType,"NEO") 
    EventChannelName = [];
    NumChannel = [];
    Placeholder = {};
    app.FileTypeDropDown.Items = Placeholder;
    app.FileTypeDropDown.Items{1} = strcat('NEO IO Trigger Channel');

    EventChannelName = app.FileTypeDropDown.Items{1};

    ChannelRange = unique(double(app.EventInfo.event_channels));
    NumChannel = length(ChannelRange);

     % Initialize an empty string
    ChannelSelectionToShow = '';

    % Loop through numbers from 1 to 10
    for i = 1:NumChannel
        % Append each number to the string
        ChannelSelectionToShow = [ChannelSelectionToShow, num2str(ChannelRange(i))];
        
        % If it's not the last number, add a comma
        if i < NumChannel
            ChannelSelectionToShow = [ChannelSelectionToShow, ','];
        end
    end
        
end

app.InputChannelSelectionEditField.Value = ChannelSelectionToShow;
app.FileTypeDropDown.Value = EventChannelName;
app.NrInputChinfolderEditField.Value = num2str(NumChannel);


