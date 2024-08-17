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
RHDAllChannelData = [];
ExtractedRHDEventsFlag = [];
EventChannelDropDown = [];

if isfield(Data,'Events')
    f = msgbox("Warning: Events where already extracted. Previous data will be overwritten!");
    fieldToRemove = 'Events';
    Data = rmfield(Data, fieldToRemove);
end

%% If Intan Recording System selected
if strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"IntanDat")
    %% DI Input Channel
    if strcmp(FileTypeDropDown,"Digital Inputs")
        % Issue warnings if necessary
        if strcmp(RecordingType,"IntanDat")
            if isempty(EventInfo.DIChannel) 
                f = msgbox("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        elseif strcmp(RecordingType,"IntanRHD")
            if EventInfo.DIChannel == 0
                f = msgbox("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        end
        % Extract Costum Channel Naames and extract data if rhd
        % files selected
        if strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 0
            TextArea2Object.Value = "Extracting Event Input Channel from RHD file";
            [RhdFilePaths] = LoadIntanRHDFiles(Path);
            LastDashIndex = find(RhdFilePaths == '\');
            RHDPath = RhdFilePaths(1:LastDashIndex(end));
            RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
            ExtractedRHDEventsFlag = 1;
            [~,~,~,RHDAllChannelData.board_dig_in_data,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",TextArea2Object);
            TextArea2Object.Value = "Event Channel Extraction finished";
        elseif strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 1
            [RhdFilePaths] = LoadIntanRHDFiles(Path);
            LastDashIndex = find(RhdFilePaths == '\');
            RHDPath = RhdFilePaths(1:LastDashIndex(end));
            RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
            ExtractedRHDEventsFlag = 1;
            [~,~,~,RHDAllChannelData.board_dig_in_data,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Info",TextArea2Object);
        end
        % Extract Costum Channel Names if .dat
        % files selected (extract rhd info file for that)
        if strcmp(RecordingType,"IntanDat")
            [~,~,~,~,InfoRhd,~] = LoadIntanDatFiles(Data.Info.Data_Path);
            % Load Rhd Info file
            [~,~,~,RHDAllChannelData.board_dig_in_data,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
        end
        % Start Event Extraction
        [Data] = Extract_Events_Module_Extract_Events_Intan(Data,FileTypeDropDown,EventInfo.DIChannel,Path,str2double(Threshold),InputChannelSelection,RHDAllChannelData);
    
    elseif strcmp(FileTypeDropDown,"Analog Input")
        if strcmp(RecordingType,"IntanDat")
            if isempty(EventInfo.ADCChannel) 
                f = msgbox("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        elseif strcmp(RecordingType,"IntanRHD")
            if EventInfo.ADCChannel == 0
                f = msgbox("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        end
        if strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 0
            TextArea2Object.Value = "Extracting Event Input Channel from RHD file";
            [RhdFilePaths] = LoadIntanRHDFiles(Path);
            LastDashIndex = find(RhdFilePaths == '\');
            RHDPath = RhdFilePaths(1:LastDashIndex(end));
            RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
            ExtractedRHDEventsFlag = 1;
            [~,RHDAllChannelData.board_adc_data,~,~,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",TextArea2Object);
            TextArea2Object.Value = "Event Channel Extraction finished";
        elseif strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 1
            [RhdFilePaths] = LoadIntanRHDFiles(Path);
            LastDashIndex = find(RhdFilePaths == '\');
            RHDPath = RhdFilePaths(1:LastDashIndex(end));
            RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
            ExtractedRHDEventsFlag = 1;
            [~,RHDAllChannelData.board_adc_data,~,~,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Info",TextArea2Object);
        end

        % Extract Costum Channel Names if .dat
        % files selected (extract rhd info file for that)
        if strcmp(RecordingType,"IntanDat")
            [~,~,~,~,InfoRhd,~] = LoadIntanDatFiles(Data.Info.Data_Path);
            % Load Rhd Info file
            [~,RHDAllChannelData.board_adc_data,~,~,~,~,~,~,~,ChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
        end

        [Data] = Extract_Events_Module_Extract_Events_Intan(Data,FileTypeDropDown,EventInfo.ADCChannel,Path,str2double(Threshold),InputChannelSelection,RHDAllChannelData);
    
    elseif strcmp(FileTypeDropDown,"AUX Inputs")
        if strcmp(RecordingType,"IntanDat")
            if isempty(EventInfo.AUXChannel) 
                f = msgbox("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        elseif strcmp(RecordingType,"IntanRHD")
            if EventInfo.AUXChannel == 0
                f = msgbox("Error: No Event Channel found.");
                TextArea2Object.Value = ("Error: No Event Channel found.");
                return;
            end
        end

        if strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 0
            TextArea2Object.Value = "Extracting Event Input Channel from RHD file";
            [RhdFilePaths] = LoadIntanRHDFiles(Path);
            LastDashIndex = find(RhdFilePaths == '\');
            RHDPath = RhdFilePaths(1:LastDashIndex(end));
            RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
            ExtractedRHDEventsFlag = 1;
            [~,~,~,~,~,~,~,RHDAllChannelData.aux_input_data,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",TextArea2Object);
            TextArea2Object.Value = "Event Channel Extraction finished";
        elseif strcmp(RecordingType,"IntanRHD") && ExtractedRHDEventsFlag == 1
            [RhdFilePaths] = LoadIntanRHDFiles(Path);
            LastDashIndex = find(RhdFilePaths == '\');
            RHDPath = RhdFilePaths(1:LastDashIndex(end));
            RHDFiles = RhdFilePaths(LastDashIndex(end)+1:end);
            ExtractedRHDEventsFlag = 1;
            [~,~,~,~,~,~,~,RHDAllChannelData.aux_input_data,~,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Info",TextArea2Object);
        end

        % Extract Costum Channel Names if .dat
        % files selected (extract rhd info file for that)
        if strcmp(RecordingType,"IntanDat")
            [~,~,~,~,InfoRhd,~] = LoadIntanDatFiles(Data.Info.Data_Path);
            % Load Rhd Info file
            [~,~,~,~,~,~,~,RHDAllChannelData.aux_input_data,~,ChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
        end

        [Data] = Extract_Events_Module_Extract_Events_Intan(Data,FileTypeDropDown,EventInfo.AUXChannel,Path,str2double(Threshold),InputChannelSelection,RHDAllChannelData);
    
    end

%% Analyze Open Eohys Data
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

    [Data.Events,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Path,"All",Nodenr,NoddeID,InputChannelSelection);

end


%% Handle Event Data structure

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
                    Data.Events{i} = Data.Events{i} - index; %substract number of indicies before first event that are cut away so that 
                %                                                               evens are scaled o new ime range
                    
                end
        
                if isfield(Data.Info,'CutEnd')
                    EventsToDelete = Data.Events{i} >= length(Data.Time);
                    Data.Events{i}(EventsToDelete) = []; % Delete indicies smaller than start
                end
        
                Data.Info.EventChannelNames = {};
                Data.Info.EventChannelType = [];
                
                if strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"IntanDat")
                    for nevents = 1:length(Data.Events)
                        if strcmp(FileTypeDropDown,"AUX Inputs")
                            Data.Info.EventChannelNames{nevents} = ChannelNames.Aux{nevents};
                            Data.Info.EventChannelType = "AUX Inputs";
                            EventChannelDropDown = Data.Info.EventChannelNames;
                        elseif strcmp(FileTypeDropDown,"Analog Input")
                            Data.Info.EventChannelNames{nevents}  = ChannelNames.Analog{nevents} ;
                            Data.Info.EventChannelType = "Analog Input";
                            EventChannelDropDown = Data.Info.EventChannelNames;
                        elseif strcmp(FileTypeDropDown,"Digital Inputs")
                            Data.Info.EventChannelNames{nevents}  = ChannelNames.Digital{nevents} ;
                            Data.Info.EventChannelType = "Digital Inputs";
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
            Data.Events(Eventstodelete) = [];
            Data.Info.EventChannelNames(Eventstodelete) = [];
            EventChannelDropDown = Data.Info.EventChannelNames;
        end

    else % If events empty
        f = msgbox("No Events found!");
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        if isfield(Data.Info,'EventChannelNames')
            fieldsToDelete = {'EventChannelNames'};
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
    TextArea2Object.Value = "No Events found!";
    EventChannelDropDown = [];
    pause(0.2);
    return;
end