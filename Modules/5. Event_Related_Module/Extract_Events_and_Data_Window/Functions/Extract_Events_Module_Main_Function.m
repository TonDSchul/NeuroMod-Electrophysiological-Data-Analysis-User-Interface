function [Data,EventChannelDropDown,RHDAllChannelData,ExtractedRHDEventsFlag] = Extract_Events_Module_Main_Function(Data,EventInfo,Path,RecordingType,FileTypeDropDown,Threshold,InputChannelSelection,ExtractedRHDEventsFlag,TextArea2Object,RHDAllChannelData)

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

TextArea2Object.Value = "";
EventChannelDropDown = [];

if isfield(Data,'Events')
    msgbox("Warning: Events where already extracted. Previous data will be overwritten!");
    fieldToRemove = 'Events';
    Data = rmfield(Data, fieldToRemove);
    if isfield(Data,'EventChannelType')
        fieldsToDelete = {'EventChannelType'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data,'EventChannelNames')
        fieldsToDelete = {'EventChannelNames'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

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
        [~,~,~,~,InfoRhd,~] = CheckIntanDatFiles(Data.Info.Data_Path);
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

    %% Start Event Extraction with parameters found above
    [Data] = Extract_Events_Module_Extract_Events_Intan(Data,FileTypeDropDown,EventInfoField,Path,str2double(Threshold),InputChannelSelection,RHDAllChannelData);

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
    [Data.Events,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Path,"All",Nodenr,NoddeID,InputChannelSelection,StateSelection);

elseif strcmp(RecordingType,"Neuralynx")

    % check if .nce files found in recording folder
    FilesIndex = {};
    [stringarray] = Utility_Extract_Contents_of_Folder(Path);
    FilesIndex = endsWith(stringarray, ".nev");
    FileEndingsExist = sum(FilesIndex);
    
    Filename = strcat(Path,'\',stringarray{FilesIndex==1});
    
    % extract events
    [event] = Extract_Events_Module_Extract_Events_Neuralynx(Filename,Path);
    
    % Just Select samples of the eventtypoe selected
    eventcell = {event.type};
    selectedfielytypeindicies = zeros(1,length({event.type}))+1;
    for i = 1:length({event.type})
        if strcmp(eventcell{i},FileTypeDropDown)
            selectedfielytypeindicies(i) = 1;
        else
            selectedfielytypeindicies(i) = 0;
        end
    end

    Eventsamples = double(cell2mat({event.sample}));
    Eventsamples(selectedfielytypeindicies==0) = [];

    if ~isempty(Eventsamples) 
        for i = 1:length(Eventsamples)
            Data.Events{1}(i) = double(Eventsamples(i));
        end
        % Event 1 always sample 1
        if Data.Events{1}(1) == 1
            Data.Events{1}(1) = [];
            msgbox("Warning: First sample is always 1 and gets deleted.");
        end
        Zerosamples = Data.Events{1} == 0;

        if sum(Zerosamples) > 0
            Data.Events{1}(Zerosamples==1) = [];
            msgbox("Warning: Indice of zero detected and deleted.")
        end
    else
        Data.Events = [];
    end
end

if isfield(Data,'Events') 
    if ~isempty(Data.Events)
        Eventstodelete = [];
        for i = 1:length(Data.Events)
            if ~isempty(Data.Events{i})
                % account for time being cut (cut start and cut end)
                if isfield(Data.Info,'CutStart')
                    index = round(Data.Info.CutStart * Data.Info.NativeSamplingRate);
    
                    EventsToDelete = Data.Events{i} <= index;
                    Data.Events{i}(EventsToDelete) = []; % Delete indicies smaller than start
                    Data.Events{i} = Data.Events{i} - index; %substract number of indicies before first event that are cut away so that events are scaled o new ime range
                end
        
                if isfield(Data.Info,'CutEnd')
                    EventsToDelete = Data.Events{i} >= length(Data.Time);
                    Data.Events{i}(EventsToDelete) = []; % Delete indicies smaller than start
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
                    for nevents = 1:length(Data.Events)
                        EventChannelDropDown = {};
                        Data.Info.EventChannelNames{nevents} = convertStringsToChars(Info.EventChannelName{nevents});
                        Data.Info.EventChannelType = strcat(AvailableNode(Nodenr)," TTL");
                        EventChannelDropDown{nevents} = Data.Info.EventChannelNames{nevents};
                    end
                elseif strcmp(RecordingType,"Neuralynx")
                    EventChannelDropDown = {};
                    Data.Info.EventChannelNames{1} = FileTypeDropDown;
                    Data.Info.EventChannelType = ".nev";
                    EventChannelDropDown{1} = Data.Info.EventChannelNames{1};
                end
                
                if i == 1
                    TextArea2Object.Value = strcat("Event Extraction succesfull. Found ",num2str(length(Data.Events{i}))," Events for Event Channel ",Data.Info.EventChannelNames{i});
                else
                    TextArea2Object.Value = [TextArea2Object.Value;strcat("Event Extraction succesfull. Found ",num2str(length(Data.Events{i}))," Events for Event Channel ",Data.Info.EventChannelNames{i})];
                end
            end
    
            if isempty(Data.Events{i})
                Eventstodelete = [Eventstodelete,i];
            end
        end
    
        if ~isempty(Eventstodelete) 
            msgbox(strcat("Warning: Events ",num2str(Eventstodelete)," contain no event indicies and are deleted"));
            
            if length(Eventstodelete)==length(Data.Events) % If all events empty
                msgbox("No Events found!");
                fieldsToDelete = {'Events'};
                % Delete fields
                Data = rmfield(Data, fieldsToDelete);
                if isfield(Data.Info,'EventChannelNames')
                    fieldsToDelete = {'EventChannelNames'};
                    % Delete fields
                    Data.Info = rmfield(Data.Info, fieldsToDelete);
                end
                if isfield(Data.Info,'EventChannelType')
                    fieldsToDelete = {'EventChannelType'};
                    % Delete fields
                    Data.Info = rmfield(Data.Info, fieldsToDelete);
                end
                TextArea2Object.Value = "No Events found!";
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
        msgbox("No Events found!");
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        if isfield(Data.Info,'EventChannelNames')
            fieldsToDelete = {'EventChannelNames'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        if isfield(Data.Info,'EventChannelType')
            fieldsToDelete = {'EventChannelType'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        TextArea2Object.Value = "No Events found!";
        EventChannelDropDown = [];
        pause(0.2);
        return;
    end
else
    msgbox("No Events found!");
    if isfield(Data.Info,'EventChannelNames')
        fieldsToDelete = {'EventChannelNames'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data.Info,'EventChannelType')
        fieldsToDelete = {'EventChannelType'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    if isfield(Data,'Events')
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
    TextArea2Object.Value = "No Events found!";
    EventChannelDropDown = [];
    pause(0.2);
    return;
end