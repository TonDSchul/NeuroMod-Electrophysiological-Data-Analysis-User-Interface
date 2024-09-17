function [EventInfo,FileEndingsExist,FilePaths,texttoshow,Info] = Extract_Events_Module_Determine_Available_EventChannel(Data,Path,FileType)

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
% 5. FileType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
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

%% The following code takes the path and the type of recording file type from the app.Mainapp.Info file and sets up the window Information based on this

EventInfo = [];
FileEndingsExist = [];
FilesIndex = [];
FilePaths = [];
texttoshow = [];
Info = [];

%% Intan Event Extraction - IntanDat = Method for multiple files in folder
if strcmp(Data.Info.RecordingType,"IntanDat") 
    
    % EventInfo.DIChannel,EventInfo.ADCChannel and
    % EventInfo.AUXChannel save the how manythed file the
    % input channel are in the selected folder. If Digitial
    % Channel 1 is file 11 in the folder,
    % EventInfo.DIChannel saves a 11. For multiple event
    % channel it saves it as a vector. Same for others
    
    [FilePaths,AmplifierDataIndex,EventInfo,~,~,~] = CheckIntanDatFiles(Path);
    
    if ~isempty(EventInfo)
        FileEndingsExist = 1;
        texttoshow = "Found Input Channel:";
        currentstring = [];
        
        if isfield(EventInfo,'DIChannel')
            for i = 1:length(EventInfo.DIChannel)
                currentstring = FilePaths{EventInfo.DIChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
        if isfield(EventInfo,'ADCChannel')
            for i = 1:length(EventInfo.ADCChannel)
                currentstring = FilePaths{EventInfo.ADCChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
        if isfield(EventInfo,'AUXChannel')
            for i = 1:length(EventInfo.AUXChannel)
                currentstring = FilePaths{EventInfo.AUXChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
        if isfield(EventInfo,'DINChannel')
            for i = 1:length(EventInfo.DINChannel)
                currentstring = FilePaths{EventInfo.DINChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
    else
        FileEndingsExist = 0;
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
    end

    if ~isempty(AmplifierDataIndex)
        texttoshow(end+1) = "Amplifier Input Channel:";
        currentelements = length(texttoshow);
    
        for i = 1:length(AmplifierDataIndex)
            currentstring = FilePaths{AmplifierDataIndex(i)};
            lastdashindex = strfind(currentstring,"\");
            currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
            texttoshow = [texttoshow;currentstring];
        end
    end

%% IntanDat = Method for single file in folder
elseif strcmp(Data.Info.RecordingType,"IntanRHD") 
    % EventInfo.DIChannel,EventInfo.ADCChannel and
    % EventInfo.AUXChannel save the number of event channel
    % found for the specific input channel type (digital, analog, aux)
    %app.RHDAllChannelData is a structure. It saves the data
    %from each event channel found. Its loaded at the beginning
    %and saved directly to avoid having to load it again
    
    [RHDFilePaths] = LoadIntanRHDFiles(Path);
    
    %% rhd file has to be read in order to know how many events and channel it contains. Output is used to populate the fields in this GUI window
    if ~isempty(RHDFilePaths)
        LastDashIndex = find(RHDFilePaths == '\');
        RHDPath = RHDFilePaths(1:LastDashIndex(end));
        RHDFiles = RHDFilePaths(LastDashIndex(end)+1:end);
        
        FilePaths = RHDPath;

        [~,~,~,~,~,~,~,~,NumChannel] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"NumChannel",[]);
    
        if NumChannel.num_board_adc_channels == 0 && NumChannel.num_board_dig_in_channels == 0 && NumChannel.aux_input_channels == 0
            % app.TextArea.Value = "Warning: No Event Channel found in this folder. Please select a different folder.";
            FileEndingsExist = 0;
            texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
            return;
        else
            FileEndingsExist = 1;
        end  

        texttoshow = ["Found Input Channel:";""];
    
        if NumChannel.num_board_dig_in_channels > 0
            texttoshow = [texttoshow;strcat(num2str(NumChannel.num_board_dig_in_channels)," Digital Channel")];
            EventInfo.DIChannel = 1:NumChannel.num_board_dig_in_channels;
        else
            texttoshow = [texttoshow;" 0 Digital Channel"];
        end
    
        if NumChannel.num_board_adc_channels > 0
            texttoshow = [texttoshow;strcat(num2str(NumChannel.num_board_adc_channels)," Analog Channel")];
            EventInfo.ADCChannel = 1:NumChannel.num_board_adc_channels;
        else
            texttoshow = [texttoshow;" 0 Analog Channel"];
        end
    
        if NumChannel.aux_input_channels > 0
            texttoshow = [texttoshow;strcat(num2str(NumChannel.aux_input_channels)," Aux Channel")];
            EventInfo.AUXChannel = 1:NumChannel.aux_input_channels;
        else
            texttoshow = [texttoshow;" 0 Aux Channel"];
        end

    else
        FileEndingsExist = 0;
        EventInfo = [];
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
    end
    

elseif strcmp(Data.Info.RecordingType,"Neuralynx") 
    
    % Specify file endings that have to be present in the
    % selected folder to count as a valid source for events.
    [FilePaths] = Utility_Extract_Contents_of_Folder(Path);
    FilesIndex = endsWith(FilePaths, ".nev");
    
    % FileEndingsExist = logical indexing, which indicies have
    % the ending. If all sums are 0, there was no file ending
    
    if sum(FilesIndex)==0
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
        FileEndingsExist = 0;
        EventInfo = [];
    else
        EventInfo.IndexEventFile = find(FilesIndex==1);  
        EventInfo.IndexAllIndex = FilesIndex;
        FileEndingsExist = 1;
    end
    
elseif strcmp(Data.Info.RecordingType,"Open Ephys") 

    [EventInfo,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Path,"Get Information",[],[],[]);

    [FilePaths] = Utility_Extract_Contents_of_Folder(Path);

    if ~isempty(EventInfo)
        FileEndingsExist = 1;
        texttoshow = strcat("Finished looking for event channel from: ",Path);
    else
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
        FileEndingsExist = 0;
        EventInfo = [];
    end

elseif strcmp(Data.Info.RecordingType,"Spike2") 
    if isfield(Data.Info,'Spike2EventChannelToTake')
        if ~isempty(Data.Info.Spike2EventChannelToTake)
            EventInfo.EventChannel = Data.Info.Spike2EventChannelToTake;
            FileEndingsExist = 1;
            texttoshow = strcat("Finished looking for event channel from: ",Path);
        else
            texttoshow = "Warning: No event channel selected when loading the dataset. No events can be extracted";
            FileEndingsExist = 0;
            EventInfo = [];
        end
    else
        texttoshow = "Warning: No event channel selected when loading the dataset. No events can be extracted";
        FileEndingsExist = 0;
        EventInfo = [];
    end
end           