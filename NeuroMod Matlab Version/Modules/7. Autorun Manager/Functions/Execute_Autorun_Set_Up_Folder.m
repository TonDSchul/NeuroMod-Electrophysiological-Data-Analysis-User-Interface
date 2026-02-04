function [Data,SelectedFolder] = Execute_Autorun_Set_Up_Folder(AutorunConfig,Data,nRecordings)

%________________________________________________________________________________________
%% This function takes the folder the user selected, chekcs for contents and modifies them for easier use later on
% Purpose is so that later functions can easily access standard folder structure that is created during the autorun
% which differs between open ephys and intan recordings bc of their stanrad
% folder structure AND to have an additional measure to check whther folder
% selected by user contains what is expected for the selected parameter

% This function is called in the
% Execute_Autorun_Continous_Data_Module_Functions folder before the data
% extraction or loading begins

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 3. Data: main data structure 
% 4. nRecordings: double, max number of folder iterated through
% 5. LoadedData: true if data is loaded, false if not (not loaded here!)

%Outputs:
% 1. Data: main data structure
% 3. SelectedFolder: char, modified folder 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% Prepare Folder Selections 
if strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
elseif strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
elseif strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Neuralynx")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
elseif strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Spike2")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
elseif strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && contains(AutorunConfig.ExtractRawRecording.RecordingsSystem,"NEO")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
elseif strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"TDT Tank Data")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
elseif strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"SpikeInterface MEA Maxwell .h5")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
else
    SelectedFolder = AutorunConfig.selected_folder;
end
    
if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
    %% Search for open ephys data
    [stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);
    FolderIndicieWithEphysData = [];
    for foldercontents = 1:length(stringArray)
        if contains(stringArray(foldercontents),'Record Node')
            if isfolder(strcat(SelectedFolder,'\',stringArray(foldercontents)))
                FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
            end
        end
    end

    if isempty(FolderIndicieWithEphysData) % if no open ephys data found
        Data = [];
        return;
    end

end