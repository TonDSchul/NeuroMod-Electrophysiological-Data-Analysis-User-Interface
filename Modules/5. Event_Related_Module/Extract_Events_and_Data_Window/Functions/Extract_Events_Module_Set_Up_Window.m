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
% Only on Startup/Folder Change
if strcmp(TimeOfExecution,"ChangedEventChannelType") 
    EventChannelName = app.FileTypeDropDown.Value;
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
    elseif strcmp(Data.Info.RecordingType,"Spike2")
        app.TextArea_2.Value = texttoshow;
        NumChannel = 1;
        ExistChangedEventChannelType = 1;
    elseif strcmp(Data.Info.RecordingType,"Open Ephys")
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

        EventIndicie = [];
        Nodefolder = FilePaths(FolderIndicieWithEphysData);
        for i = 1:length(Nodefolder)
            if strcmp(Nodefolder(i),EventChannelName)
                EventIndicie = i;
            end
        end

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
    end

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
    else
        if strcmp(Data.Info.RecordingType,"Spike2")
            % Initialize an empty string
            ChannelSelctionToShow = '';
            ChannelEventLineNames = unique(EventInfo{1}.line);
            % Loop through numbers from 1 to 10
            for i = 1:length(ChannelEventLineNames)
                % Append each number to the string
                ChannelSelctionToShow = [ChannelSelctionToShow, num2str(ChannelEventLineNames(i))];
                
                % If it's not the last number, add a comma
                if i < length(unique(EventInfo{1}.line))
                    ChannelSelctionToShow = [ChannelSelctionToShow, ','];
                end
            end   
            app.InputChannelSelectionEditField.Value = ChannelSelctionToShow;
            app.NrInputChinfolderEditField.Value = num2str(length(ChannelSelctionToShow));
        else
            ChannelSelctionToShow = '';
            for i = 1:NumChannel
                % Append each number to the string
                if i ~= 1
                    ChannelSelctionToShow = [ChannelSelctionToShow,',',num2str(i)];
                else
                    ChannelSelctionToShow = [ChannelSelctionToShow, num2str(i)];
                end
            end   
            app.InputChannelSelectionEditField.Value = ChannelSelctionToShow;
            app.NrInputChinfolderEditField.Value = num2str(NumChannel);
        end

        if strcmp(Data.Info.RecordingType,"Open Ephys")
            for o = 1:length(EventInfo)
                if isstruct(EventInfo{o})
                    FirstStrucindice = o;
                    break;
                end
            end

            tableText = evalc('disp(EventInfo{1})');  % Convert table to string
            
            % delte unwanted parts of the char
            cutpartsindicies = find(tableText =='>');
            tableText(1:cutpartsindicies(end)) = [];
            tableText = ['line;  SampleNumber;  TimeStamp;  NodeID;  state',tableText];
            % Display the text in the Text Area
            app.TextArea_2.Value = tableText;
        end
        return;
    end
end

%% Set up text areas
if strcmp(TimeOfExecution,"Initial")  
    if isempty(EventInfo) || FileEndingsExist == 0
        if strcmp(Data.Info.RecordingType,"Spike2")
            app.TextArea_2.Value = "Warning: No event channel selected when extracting dataset. No events can be looded";
            app.TextArea.Value = strcat("No Event Channel can be extracted from: ",Path);
        else
            app.TextArea_2.Value = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
            app.TextArea.Value = strcat("No Event Channel found in Path: ",Path);
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
        if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")
            % Fill Text Area showing channels found
            app.TextArea_2.Value = texttoshow;
        elseif strcmp(Data.Info.RecordingType,"Open Ephys")
            for o = 1:length(EventInfo)
                if isstruct(EventInfo{o})
                    FirstStrucindice = o;
                    break;
                end
            end

            tableText = evalc('disp(EventInfo{1})');  % Convert table to string
            
            % delte unwanted parts of the char
            cutpartsindicies = find(tableText =='>');
            TemptableText = [];

            if ~isempty(cutpartsindicies)
                tableText(1:cutpartsindicies(end)) = [];
            end

            for i = 1:length(EventInfo{1}.Properties.VariableNames)
                if i == 1
                    TemptableText = [TemptableText,EventInfo{1}.Properties.VariableNames{i}];
                else
                    TemptableText = [TemptableText,',',' ',' ',EventInfo{1}.Properties.VariableNames{i}];
                end
            end

            tableText = [TemptableText,tableText];
            % Display the text in the Text Area
            if isfield(Data.Info,'startTimestamp')
                app.TextArea_2.Value = [strcat("Start Time Stamp of event recording: ",num2str(Data.Info.startTimestamp));"";tableText];
            else
                app.TextArea_2.Value = ["No Aquisition Start time stamp found. Cannot correct event times if recording and aquistion start are different";"";tableText];
            end

            
        end
    end
end

%% Set up edit fields and dropdown menus
% Analyse how many input event channel exist
if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")  
    % get strings of channel 
    for i = 1:length(app.EventInfo)
        if isfield(app.EventInfo,'DIChannel')
            EventChannelName = 'Digital Inputs';
            NumChannel = length(app.EventInfo.DIChannel);
        elseif isfield(app.EventInfo,'ADCChannel')
            EventChannelName = 'Analog Input';
            NumChannel = length(app.EventInfo.ADCChannel);
        elseif isfield(app.EventInfo,'AUXChannel')
            EventChannelName = 'AUX Inputs';
            NumChannel = length(app.EventInfo.AUXChannel);
        elseif isfield(app.EventInfo,'DINChannel')
            EventChannelName = 'DIN Inputs';
            NumChannel = length(app.EventInfo.DINChannel);
        end
    end

    ChannelSelctionToShow = [];
    for i = 1:NumChannel
        if i ~= 1
            ChannelSelctionToShow = strcat(ChannelSelctionToShow,',',num2str(i));
        else
            ChannelSelctionToShow = num2str(i);
        end
    end
elseif strcmp(Data.Info.RecordingType,"Open Ephys")
    if ~isempty(EventInfo)
        NumChannel = length(unique(EventInfo{1}.line));
        % Initialize an empty string
        ChannelSelctionToShow = '';
        ChannelEventLineNames = unique(EventInfo{1}.line);
        % Loop through numbers from 1 to 10
        for i = 1:length(ChannelEventLineNames)
            % Append each number to the string
            ChannelSelctionToShow = [ChannelSelctionToShow, num2str(ChannelEventLineNames(i))];
            
            % If it's not the last number, add a comma
            if i < length(unique(EventInfo{1}.line))
                ChannelSelctionToShow = [ChannelSelctionToShow, ','];
            end
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

        EventChannelName = app.FileTypeDropDown.Items{Info.AvailabelNodes{1}};            
    end

elseif strcmp(Data.Info.RecordingType,"Neuralynx")

    if FileEndingsExist==1

        % check if .nce files found in recording folder
        FilesIndex = {};
        [stringarray] = Utility_Extract_Contents_of_Folder(Path);
        FilesIndex = endsWith(stringarray, ".nev");
        FileEndingsExist = sum(FilesIndex);
        
        Filename = strcat(Path,'\',stringarray{FilesIndex==1});
        
        [event] = Extract_Events_Module_Extract_Events_Neuralynx(Filename,Path);

        [fieldData] = Extract_Events_Module_Display_Neuralynx_EventInfo(event);

        app.TextArea_2.Value = fieldData;

        NumChannel = length(unique({event.type}));
        eventypes = unique({event.type});

        for i = 1:NumChannel
            app.FileTypeDropDown.Items{i} = eventypes{i};
        end

        % Initialize an empty string
        ChannelSelctionToShow = '';

        % Loop through numbers from 1 to 10
        for i = 1:NumChannel
            % Append each number to the string
            ChannelSelctionToShow = [ChannelSelctionToShow, num2str(i)];
            
            % If it's not the last number, add a comma
            if i < NumChannel
                ChannelSelctionToShow = [ChannelSelctionToShow, ','];
            end
        end  
        
        EventChannelName = convertStringsToChars(eventypes{1});

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
    ChannelSelctionToShow = '';

    % Loop through numbers from 1 to 10
    for i = 1:NumChannel
        % Append each number to the string
        ChannelSelctionToShow = [ChannelSelctionToShow, num2str(ChannelRange(i))];
        
        % If it's not the last number, add a comma
        if i < NumChannel
            ChannelSelctionToShow = [ChannelSelctionToShow, ','];
        end
    end  
        
end

app.InputChannelSelectionEditField.Value = ChannelSelctionToShow;
app.FileTypeDropDown.Value = EventChannelName;
app.NrInputChinfolderEditField.Value = num2str(NumChannel);


