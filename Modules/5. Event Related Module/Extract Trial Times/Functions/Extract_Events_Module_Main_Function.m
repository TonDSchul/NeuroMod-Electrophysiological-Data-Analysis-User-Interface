function [Data,EventChannelDropDown,RHDAllChannelData,ExtractedRHDEventsFlag,Eventstodelete,texttoshow] = Extract_Events_Module_Main_Function(Data,EventInfo,Path,RecordingType,FileTypeDropDown,Threshold,InputChannelSelection,ExtractedRHDEventsFlag,TextArea2Object,RHDAllChannelData,executablefolder,startTimestamp,TimeAroundEvent,AdditionalEventInfo,EventsToCombine)

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
% 13. Eventstodelete: Indices of Data.Events that had to be deleted (i.e. due to all triggers being outside of time or smt like this)
% 14. TimeAroundEvent: double, 1x2 vecor with time before and after trigger
% (both positive)

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

TextArea2Object.Value = "";
EventChannelDropDown = [];
Eventstodelete = [];
texttoshow = [];

%% First maintaining GUI main data structure by deleting previous event data
if isfield(Data,'Events') && isfield(Data,'EventRelatedData')
    msgbox("Warning: Event trigger and event related data where already extracted. Previous data will be overwritten!");
elseif isfield(Data,'Events')
    msgbox("Warning: Event trigger where already extracted. Previous data will be overwritten!");
end

if isfield(Data,'Events')
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Events");
end

%% If Intan Recording System selected
if strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"IntanDat")
    %% Check if any of the event channel types are available
    % Issue warnings if necessary
    %if strcmp(RecordingType,"IntanDat")
        if strcmp(FileTypeDropDown,"Digital Inputs")
            if isfield(EventInfo,'DIChannel')
                if isempty(EventInfo.DIChannel) | EventInfo.DIChannel == 0
                    msgbox("Error: No Event Channel found.");
                    disp("Error: No Event Channel found.");
                    TextArea2Object.Value = ("Error: No Event Channel found.");
                    return;
                end
            else
                msgbox("Error: No Event Channel found.");
                disp("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        elseif strcmp(FileTypeDropDown,"Analog Input")
            if isfield(EventInfo,'ADCChannel')
                if isempty(EventInfo.ADCChannel) | EventInfo.ADCChannel == 0
                    msgbox("Error: No Event Channel found.");
                    disp("Error: No Event Channel found.");
                    TextArea2Object.Value = ("Error: No Event Channel found.");
                    return;
                end
            else
                msgbox("Error: No Event Channel found.");
                disp("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        elseif strcmp(FileTypeDropDown,"AUX Inputs")
            if isfield(EventInfo,'AUXChannel')
                if isempty(EventInfo.AUXChannel) | EventInfo.AUXChannel == 0
                    msgbox("Error: No Event Channel found.");
                    disp("Error: No Event Channel found.");
                    TextArea2Object.Value = ("Error: No Event Channel found.");
                    return;
                end
            else
                msgbox("Error: No Event Channel found.");
                disp("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        elseif strcmp(FileTypeDropDown,"DIN Inputs")
            if isfield(EventInfo,'DINChannel')
                if isempty(EventInfo.DINChannel) | EventInfo.DINChannel == 0
                    msgbox("Error: No Event Channel found.");
                    disp("Error: No Event Channel found.");
                    TextArea2Object.Value = ("Error: No Event Channel found.");
                    return;
                end
            else
                msgbox("Error: No Event Channel found.");
                disp("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        end
    %end
    %% Extract Costum Channel Names and extract data if rhd file format
    % If not already extracted: Extract all event infos including data
    % itself
    if strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 1 %% ExtractedRHDEventsFlag == 1 means that Intan_RHD2000_Data_Extraction gets called with "Info" input argument
        [RhdFilePaths] = LoadIntanRHDFiles(Path);
        LastDashIndex = find(RhdFilePaths == '\');
        RHDPath = RhdFilePaths(1:LastDashIndex(end));
        RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
        ExtractedRHDEventsFlag = 1;
        [~,~,~,~,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Info",TextArea2Object);
        if strcmp(FileTypeDropDown,"Digital Inputs")
            EventInfoField = EventInfo.DIChannel;
        elseif strcmp(FileTypeDropDown,"Analog Input")
            EventInfoField = EventInfo.ADCChannel;
        elseif strcmp(FileTypeDropDown,"AUX Inputs")
            EventInfoField = EventInfo.AUXChannel;
        elseif strcmp(FileTypeDropDown,"DIN Inputs")
            EventInfoField = EventInfo.DINChannel;
        end

    elseif strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 0
        TextArea2Object.Value = "Extracting Event Input Channel from RHD file";
        [RhdFilePaths] = LoadIntanRHDFiles(Path);
        LastDashIndex = find(RhdFilePaths == '\');
        RHDPath = RhdFilePaths(1:LastDashIndex(end));
        RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
        if strcmp(FileTypeDropDown,"Digital Inputs")
            EventInfoField = EventInfo.DIChannel;
        elseif strcmp(FileTypeDropDown,"Analog Input")
            EventInfoField = EventInfo.ADCChannel;
        elseif strcmp(FileTypeDropDown,"AUX Inputs")
            EventInfoField = EventInfo.AUXChannel;
        elseif strcmp(FileTypeDropDown,"DIN Inputs")
            EventInfoField = EventInfo.DINChannel;
        end
        [~,RHDAllChannelData.board_adc_data,~,RHDAllChannelData.board_dig_in_data,~,~,~,RHDAllChannelData.aux_input_data,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",TextArea2Object);
        ExtractedRHDEventsFlag = 1;
        TextArea2Object.Value = "Event Channel Extraction finished";
        % If already extracted: just get info about nr and kind of channel avalablie
    end
    %% Extract Costum Channel Names and extract data if .dat file format
    if strcmp(RecordingType,"IntanDat")
        [~,~,~,~,InfoRhd,~] = CheckIntanDatFiles(Path);
        % Load Rhd Info file
        if strcmp(FileTypeDropDown,"Digital Inputs")
            EventInfoField = EventInfo.DIChannel;
            [~,~,~,RHDAllChannelData.board_dig_in_data,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
        elseif strcmp(FileTypeDropDown,"Analog Input")
            EventInfoField = EventInfo.ADCChannel;
            [~,~,~,RHDAllChannelData.board_adc_data,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
        elseif strcmp(FileTypeDropDown,"AUX Inputs")
            EventInfoField = EventInfo.AUXChannel;
            [~,~,~,RHDAllChannelData.aux_input_data,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
        elseif strcmp(FileTypeDropDown,"DIN Inputs")
            EventInfoField = EventInfo.DINChannel;
            [~,~,~,RHDAllChannelData.din_input_data,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
        end
    end
    
    EventInfoType = EventInfo.EventType;

    %% Start Event Extraction with parameters found above
    [Data] = Extract_Events_Module_Extract_Events_Intan(Data,FileTypeDropDown,EventInfoField,Path,str2double(Threshold),InputChannelSelection,RHDAllChannelData,EventInfoType);

%% Analyze Open Ephys Data
elseif strcmp(RecordingType,"Open Ephys")

    addpath(genpath("."));
    
    %% Get Nr of node based on GUI string input
    [stringArray] = Utility_Extract_Contents_of_Folder(Path);
    FolderIndicieWithEphysData = [];
    for foldercontents = 1:length(stringArray)
        if contains(stringArray(foldercontents),'Record Node')
            if isfolder(strcat(Path,'\',stringArray(foldercontents)))
                FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
            end
        end
    end
    AvailableNode = stringArray(FolderIndicieWithEphysData);
    Nodenr = find(AvailableNode==FileTypeDropDown);

    NoddeID = [];
    StateSelection = Threshold;
 
    if ~isempty(startTimestamp)
        startTimestamp = round(Data.Info.startTimestamp*Data.Info.NativeSamplingRate);
    else
        msgbox("Warning: No acquisition start time stamp found. Cannot correct trigger times if recording and aquistion start are different.")
    end
    
    [Data.Events,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Data,Path,"All",Nodenr,NoddeID,InputChannelSelection,StateSelection,startTimestamp,Data.Info.AllRecordingIndicies);
    
    % account for time being cut (cut start and cut end) ------ ONLY FOR
    % OPEN EPHYS!! FOR OTHERS THIS IS MANAGED BELOW
    for i = 1:length(Data.Events)
        if isfield(Data.Info,'CutStart')
            index = round(sum(Data.Info.CutStart) * Data.Info.NativeSamplingRate); % convert in samples
            EventsToDelete = Data.Events{i} <= index;
            if sum(EventsToDelete)>0
                Data.Events{i}(EventsToDelete) = []; % Delete indicies smaller than start
                Data.Events{i} = Data.Events{i} - index; %substract number of indicies before first event that are cut away so that events are scaled o new ime range
                disp(strcat("Event Nr. ",num2str(i),": Start time of dataset was cut. First ",num2str(sum(EventsToDelete))," trigger are deleted!"));
            end
        end
        if isfield(Data.Info,'CutEnd')
            EventsToDelete = Data.Events{i} > length(Data.Time);
            if sum(EventsToDelete)>0
                Data.Events{i}(EventsToDelete) = []; % Delete indicies smaller than start
                disp(strcat("Event Nr. ",num2str(i),": Stop time of dataset was cut. Last ",num2str(sum(EventsToDelete))," trigger are deleted!"));
            end
        end
    end

    if ~isfield(Data.Info,'CutEnd') && ~ isfield(Data.Info,'CutStart')
        % Can be the case that sample number of events exceed data recording. 
        % Search for those events and delete
        for nevents = 1:length(Data.Events)
            if sum(Data.Events{nevents}>length(Data.Time))>0
                msgbox(strcat("Extracted trigger data for selected channel ", num2str(nevents)," contains ",num2str(sum(Data.Events{nevents}>length(Data.Time)))," samples outside of time range which are deleted. This can be due to an incorrect start timestamp of your recording."))
                Data.Events{nevents}(Data.Events{nevents}>length(Data.Time)) = [];
            end
        end
    end

elseif strcmp(RecordingType,"Neuralynx")

    [event,Texttoshow] = Extract_Events_Module_Load_Neuralynx_Events(Data,Path);
        
    if isempty(event)
        msgbox("No Neuralynx events could be extracted from file!");
        return;
    end
    
    [Data.Events,EventChannelNames] = Extract_Events_Module_Neuralynx_Manage_Events_Main(event,Data,InputChannelSelection);

elseif strcmp(RecordingType,"TDT Tank Data")

    [Data.Events,EventChannelNames,Error] = Extract_Events_Module_Extract_TDT_Events(EventInfo,FileTypeDropDown,InputChannelSelection);
    
    if Error == 1
        msgbox("No TDT events could be extracted from file!");
        return;
    end
elseif strcmp(RecordingType,"Spike2")
    
    %% Check whether Json library is installed necessray to analyze this format
    FolderWithPathVariable = strcat(executablefolder,'\Modules\MISC\Variables (do not edit)\CEDS64Path.mat');
    
    [selectedFolder] = Manage_Dataset_Check_Spike2CED64_Path(executablefolder,FolderWithPathVariable);

    % Load library
    cedpath = selectedFolder;
    addpath(cedpath);
    CEDS64LoadLib(cedpath);
    
    % Get the contents of the folder
    contents = dir(Path);   
    % Check each item in the folder
    Filenametoload = [];
    for i = 1:length(contents)
        item = contents(i);
        
        % Skip the current and parent directory entries
        if strcmp(item.name, '.') || strcmp(item.name, '..')
            continue;
        end
        % Check if the item is a .dat file
        [~, ~, ext] = fileparts(item.name);
        if strcmp(ext, '.smrx')
            Filenametoload = item.name;

        end
    end
    Error = 0;
    if isempty(Filenametoload)
        msgbox("Error: No .smrx file found in Path.")
        Error = 1;
    end

    if Error == 0
        % Complete path to specific file in the selected folder
        FullDataPath = convertStringsToChars(fullfile(Path,Filenametoload));
        
        % Extract general infos
        fhand1 = CEDS64Open(FullDataPath);
        
        maxTimeTicks = CEDS64ChanMaxTime(fhand1, 1)+1; % +1 so the read gets the last point
            
        EventData = cell(1,length(InputChannelSelection));
    
        % Extract channel wise data. Loops until all channel analyzed
        for nchannel = 1:length(InputChannelSelection)
            
            texttoshow = strcat("Extracting Event Channel ",num2str(InputChannelSelection(nchannel)));
            TextArea2Object.Value = [TextArea2Object.Value;texttoshow];
            pause(0.2);
            
            %% Somehow the tick and time output is the same. Moreover, output seems to be in ms. So output*1000/length of channel = 50kHz Sampling Rate
            [~, TempData, ~] = CEDS64ReadWaveF(fhand1, InputChannelSelection(nchannel), maxTimeTicks, 0, maxTimeTicks);
            if isempty(TempData)   
                continue;
            end
    
            EventData{nchannel} = TempData;
            clear TempData
        end
    
        EventInfoType = EventInfo.EventType;

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,[],"Spike2",str2double(Threshold),EventData,EventInfoType);

    end

elseif strcmp(RecordingType,"NEO")
    Error = 0;
    if sum(EventInfo.event_samples>length(Data.Time))>0
        msgbox("Warning: Trigger outside of max time range found. Check whether you selected and loaded event data from the correct recording. Events outside of time range are deleted.");
        
        EventInfo.event_labels(EventInfo.event_samples>length(Data.Time)) = [];
        EventInfo.event_channels(EventInfo.event_samples>length(Data.Time)) = [];
        EventInfo.event_samples(EventInfo.event_samples>length(Data.Time)) = [];
        
        TempUniqueChannel = unique(EventInfo.event_channels);
        InputChannelSelection(~ismember(InputChannelSelection,TempUniqueChannel)) = [];
        
        %DeletedChannelIndices = find(~ismember(InputChannelSelection,TempUniqueChannel));

        if isempty(EventInfo.event_samples) || isempty(InputChannelSelection)
            msgbox("Warning: All trigger indicies had to be deleted.");
            [Data,~] = Organize_Delete_Dataset_Components(Data,"Events");
            return;
        end
    end
    
    EventChannelNames = cell(1,length(InputChannelSelection));
    for i = 1:length(InputChannelSelection)
        EventChannelNames{i} = convertStringsToChars(strcat("Event Ch ",num2str(InputChannelSelection(i))));
    end
    
    if Error == 0
        UniqueChannel = unique(EventInfo.event_channels);
        SelecteChannelIndice = ismember(UniqueChannel,InputChannelSelection);
        
        UniqueChannel(SelecteChannelIndice==0) = [];
        Data.Events = cell(1,sum(SelecteChannelIndice));
        DeleteIndice = [];
        
        for neventchannel = 1:length(UniqueChannel)
            CurrentChannelIndice = EventInfo.event_channels == UniqueChannel(neventchannel);
            
            if sum(CurrentChannelIndice)>0
                Data.Events{neventchannel} = EventInfo.event_samples(CurrentChannelIndice); % adjust by recording time stamp!
            else
                Data.Events{neventchannel} = [];
                DeleteIndice = [DeleteIndice,neventchannel];
            end
        end
        
        if ~isempty(DeleteIndice)
            Data.Events(DeleteIndice) = [];
            EventChannelNames(DeleteIndice) = [];
        end
    end
end

%% Wrap Up and Cleaning
if isfield(Data,'Events') 
    if ~isempty(Data.Events)
        Eventstodelete = [];
        for i = 1:length(Data.Events)

            EventsSmallerZero = Data.Events{i}<=0;
            
            if sum(EventsSmallerZero)>0
                Data.Events{i}(EventsSmallerZero) = [];
                msgbox(strcat("Found and deleted ",num2str(sum(EventsSmallerZero))," trigger indicies smaller or equal to 0. For Open Ephys recordings this can be due to extracting a limited number of recordings for node A while extracting events from node B from which all recordings are analysze (nwb). This can lead to correct event times as long as events from node B lie outside of time range of node A. In doubt please try a different node and/or load all recordings from current node!"));
            end

            if ~isempty(Data.Events{i})
                if ~strcmp(RecordingType,"Open Ephys")% Done above
                    % account for time being cut (cut start and cut end)
                    if isfield(Data.Info,'CutStart')
                        index = round(sum(Data.Info.CutStart) * Data.Info.NativeSamplingRate); % convert in samples
        
                        EventsToDelete = Data.Events{i} <= index;

                        if sum(EventsToDelete)>0
                            Data.Events{i}(EventsToDelete) = []; % Delete indicies smaller than start
                            Data.Events{i} = Data.Events{i} - index; %substract number of indicies before first event that are cut away so that events are scaled o new ime range
                            disp(strcat("Event Nr. ",num2str(i),": Start time of dataset was cut. First ",num2str(sum(EventsToDelete))," triggers are deleted!"));
                        end
                    end
            
                    if isfield(Data.Info,'CutEnd')
                        EventsToDelete = Data.Events{i} >= length(Data.Time);
                        if sum(EventsToDelete)>0
                            Data.Events{i}(EventsToDelete) = []; % Delete indicies smaller than start
                            disp(strcat("Stop time of dataset was cut. First ",num2str(sum(EventsToDelete))," triggers are deleted!"));
                        end
                    end
                end

                Data.Info.EventChannelNames = {};
                Data.Info.EventChannelType = [];
                
                % Add Event Channel Names
                if strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"IntanDat")
                    for nevents = 1:length(Data.Events)
                        if strcmp(FileTypeDropDown,"AUX Inputs")
                            Data.Info.EventChannelNames{nevents} = ChannelNames.Aux{InputChannelSelection(nevents)};
                            Data.Info.EventChannelType = "AUX Inputs";
                            EventChannelDropDown = Data.Info.EventChannelNames;
                        elseif strcmp(FileTypeDropDown,"Analog Input")
                            Data.Info.EventChannelNames{nevents}  = ChannelNames.Analog{InputChannelSelection(nevents)} ;
                            Data.Info.EventChannelType = "Analog Input";
                            EventChannelDropDown = Data.Info.EventChannelNames;
                        elseif strcmp(FileTypeDropDown,"Digital Inputs")
                            Data.Info.EventChannelNames{nevents}  = ChannelNames.Digital{InputChannelSelection(nevents)} ;
                            Data.Info.EventChannelType = "Digital Inputs";
                            EventChannelDropDown = Data.Info.EventChannelNames;
                        elseif strcmp(FileTypeDropDown,"DIN Inputs")
                            Data.Info.EventChannelNames{nevents}  = ChannelNames.Digital{InputChannelSelection(nevents)} ;
                            Data.Info.EventChannelType = "DIN Inputs";
                            EventChannelDropDown = Data.Info.EventChannelNames;
                        end
                    end
                elseif strcmp(RecordingType,"Open Ephys")
                    EventChannelDropDown = {};
                    for nevents = 1:length(Data.Events)
                        Data.Info.EventChannelNames{nevents} = convertStringsToChars(Info.EventChannelName{nevents});
                        Data.Info.EventChannelType = strcat(AvailableNode(Nodenr)," TTL");
                        EventChannelDropDown{nevents} = Data.Info.EventChannelNames{nevents};
                    end
                elseif strcmp(RecordingType,"Neuralynx")
                    EventChannelDropDown = {};
                    Data.Info.EventChannelNames = EventChannelNames;
                    Data.Info.EventChannelType = ".nev";
                elseif strcmp(RecordingType,"TDT Tank Data")
                    EventChannelDropDown = {};
                    Data.Info.EventChannelNames = EventChannelNames;
                    Data.Info.EventChannelType = FileTypeDropDown;

                elseif strcmp(RecordingType,"NEO")

                    Data.Info.EventChannelType = "NEO";
                    EventChannelDropDown = {};
                    Data.Info.EventChannelNames = EventChannelNames;

                elseif strcmp(RecordingType,"Spike2")
                    Data.Info.Spike2EventChannelToTake = convertStringsToChars(Data.Info.Spike2EventChannelToTake);

                    Spike2EventChannelToTake = str2double(strsplit(Data.Info.Spike2EventChannelToTake,','));

                    EventChannelDropDown = {};
                    for nevents = 1:length(Data.Events)
                        Data.Info.EventChannelNames{nevents} = convertStringsToChars(strcat("Data Channel ",num2str(Spike2EventChannelToTake(nevents))));
                        EventChannelDropDown{nevents} = convertStringsToChars(Data.Info.EventChannelNames{nevents});
                    end
                    Data.Info.EventChannelType = strcat("Event Channel ",num2str(nevents));
                end
                
                if i == 1
                    TextArea2Object.Value = strcat("Event Extraction succesfull. Found ",num2str(length(Data.Events{i}))," Trigger for Event Channel ",Data.Info.EventChannelNames{i});
                else
                    TextArea2Object.Value = [TextArea2Object.Value;strcat("Event Extraction succesfull. Found ",num2str(length(Data.Events{i}))," Trigger for Event Channel ",Data.Info.EventChannelNames{i})];
                end
            end
    
            if isempty(Data.Events{i})
                Eventstodelete = [Eventstodelete,i];
            end
        end
    
        if ~isempty(Eventstodelete) 
            msgbox(strcat("Warning: Event(s) ",num2str(Eventstodelete)," contain no trigger indicies and are deleted"));
            
            if length(Eventstodelete)==length(Data.Events) % If all events empty
                msgbox("No Trigger found!");
                [Data,~] = Organize_Delete_Dataset_Components(Data,"Events");
                TextArea2Object.Value = "No Trigger found!";
                EventChannelDropDown = [];
                pause(0.2);
                return;
            else
                Data.Events(Eventstodelete) = [];
                Data.Info.EventChannelNames(Eventstodelete) = [];
                EventChannelDropDown = Data.Info.EventChannelNames;
            end
        end

    else % If events empty
        msgbox("No Trigger found!");
        [Data,~] = Organize_Delete_Dataset_Components(Data,"Events");
        TextArea2Object.Value = "No Trigger found!";
        EventChannelDropDown = [];
        pause(0.2);
        return;
    end
else
    msgbox("No Trigger found!");
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Events");
    Eventstodelete = InputChannelSelection;
    TextArea2Object.Value = "No Trigger found!";
    EventChannelDropDown = [];
    pause(0.2);
    return;
end

%% ----------------------- Combine event channel if selected ----------------------------

if ~isempty(EventsToCombine)
    if strcmp(Data.Info.RecordingType,"Open Ephys")
        [Data] = Extract_Events_Module_Combine_Events(Data,EventsToCombine,AdditionalEventInfo.InputChannelNumber,InputChannelSelection,Eventstodelete);
    else
        [Data] = Extract_Events_Module_Combine_Events(Data,EventsToCombine,EventInfo.InputChannelNumber,InputChannelSelection,Eventstodelete);
    end
end

%% ----------------------- Last Step: Check if trials violate time limts----------------------------

[Data,Data.Events,texttoshow] = Extract_Events_Module_Check_Violating_Trigger(Data,Data.Events,TimeAroundEvent);



