function [EventInfo,FileEndingsExist,FilesIndex,DatFilePaths,texttoshow] = Extract_Events_Module_Determine_Available_EventChannel(Data,Path,TextAreaObject,TextArea_2Object,FileType)

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
% 4. DatFilePaths: Paths to all folder contents of intan recordings in a n x 1 cell array
% 5. texttoshow: saves text that shows info about found event channel in
% the event window

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% The following code takes the path and the type of recording file type from the app.Mainapp.Info file and sets up the window Information based on this

EventInfo.DIChannel = [];
EventInfo.ADCChannel = [];
EventInfo.AUXChannel = [];
FileEndingsExist = [];
FilesIndex = [];
DatFilePaths = [];
texttoshow = [];

%% Intan Event Extraction - IntanDat = Method for multiple files in folder
if strcmp(Data.Info.RecordingType,"IntanDat") 
    
    % EventInfo.DIChannel,EventInfo.ADCChannel and
    % EventInfo.AUXChannel save the how manythed file the
    % input channel are in the selected folder. If Digitial
    % Channel 1 is file 11 in the folder,
    % EventInfo.DIChannel saves a 11. For multiple event
    % channel it saves it as a vector
    
    [DatFilePaths,AmplifierDataIndex,AllChannel,~,~,~] = LoadIntanDatFiles(Path);
    
    TextAreaObject.Value = "Extracting Events Indicies. Please wait until this message dissappears";
    pause(0.2);

    %% dat fil eith input event channel has to be read in order to know how many events and channel it contains. Output is used to populate the fields in this GUI window
    [EventInfo.DIChannel,EventInfo.ADCChannel,EventInfo.AUXChannel,texttoshow] = Extract_Events_Module_Organize_Window_Intan_Dat([],DatFilePaths,"Initial",EventInfo.DIChannel,EventInfo.ADCChannel,EventInfo.AUXChannel,AllChannel,AmplifierDataIndex,FileType);

    TextAreaObject.Value = strcat("Finished looking for event channel from: ",Path);
    TextArea_2Object.Value = texttoshow;
    pause(0.2);
    
%% IntanDat = Method for single file in folder
elseif strcmp(Data.Info.RecordingType,"IntanRHD") 
    % EventInfo.DIChannel,EventInfo.ADCChannel and
    % EventInfo.AUXChannel save the number of event channel
    % found for the specific input channel type (digital, analog, aux)
    %app.RHDAllChannelData is a structure. It saves the data
    %from each event channel found. Its loaded at the beginning
    %and saved directly to avoid having to load it again

    [RhdFilePaths] = LoadIntanRHDFiles(Path);

    %% rhd file has to be read in order to know how many events and channel it contains. Output is used to populate the fields in this GUI window
    [EventInfo.DIChannel,EventInfo.ADCChannel,EventInfo.AUXChannel,~,texttoshow] = Extract_Events_Module_Organize_Window_Intan_RHD([],RhdFilePaths,"Initial",EventInfo.DIChannel,EventInfo.ADCChannel,EventInfo.AUXChannel,FileType);

    %% Initialize the first things shown in GUI: Digital Channel

    TextAreaObject.Value = strcat("Finished looking for event channel from: ",RhdFilePaths);
    pause(0.2);

    TextArea_2Object.Value = texttoshow;
    pause(0.2);

elseif strcmp(Data.Info.RecordingType,"Neuralynx") 
    
    % Specify file endings that have to be present in the
    % selected folder to count as a valid source for events.
    FilesIndex = {};
    [texttoshow] = Utility_Extract_Contents_of_Folder(Path);
    FilesIndex{1} = endsWith(texttoshow, ".nev");
    FilesIndex{2} = endsWith(texttoshow, ".ncs");
    FilesIndex{3} = endsWith(texttoshow, ".nse");
    FilesIndex{4} = endsWith(texttoshow, ".nts");
    FilesIndex{5} = endsWith(texttoshow, ".nrd");
    FilesIndex{6} = endsWith(texttoshow, ".dma");

    FileEndingsExist = 0;
    % FileEndingsExist = logical indexing, which indicies have
    % the ending. If all sums are 0, there was no file ending
    for i = 1:length(FilesIndex)
        FileEndingsExist = FileEndingsExist+sum(FilesIndex{i});
    end
    
    TextAreaObject.Value = strcat("Finished looking for event channel from: ",RhdFilePaths);
    pause(0.2);

    % Write folder contents in the textbox
    TextArea_2Object.Value = texttoshow;
    pause(0.2);

elseif strcmp(Data.Info.RecordingType,"Open Ephys") 

    [EventInfo,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Path,"Get Information",[],[],[]);
    FilesIndex = Info.NodeNrs;
    if ~isempty(EventInfo)
        TextAreaObject.Value = strcat("Finished looking for event channel from: ",Path);
        pause(0.2);
    end

end           