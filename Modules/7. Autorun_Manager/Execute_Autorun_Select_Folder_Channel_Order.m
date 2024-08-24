function [AutorunConfig,NumIterations,LoadedData] = Execute_Autorun_Select_Folder_Channel_Order(AutorunConfig,FunctionOrder)

%________________________________________________________________________________________
%% This function lets the user select a folder, check its contents and save it along with other variables 
% This function is called when the user selects a folder in the autorun manager window

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute

% Output:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected with added field
% AutorunConfig.selected_folder and AutorunConfig.FolderContents if
% recording system is intan
% 2. NumIterations: double, max number of folder and therefore iterations
% found, when multiple folder are suppossed to be analyzed
% 3. LoadedData: true if data is loaded, false if not (not loaded here!)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

NumIterations = [];
LoadedData = [];

if find(FunctionOrder == "Extract_Raw_Recording")
    LoadedData = false;
else
    LoadedData = true;
end

%______________________________________________________________________________________________________
%% 1. Select Folder with Data, get folder contents 
%______________________________________________________________________________________________________
if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
    msgbox("Please select a folder containing a folder for each recording");

    %% Ask for Folder
    % Prompt the user to select a folder
    selected_folder = uigetdir;
    
    % Check if the user pressed the "Cancel" button
    if selected_folder == 0
        disp('User pressed cancel');
        return;
        %error('Operation canceled.')
    else
        disp(['Selected folder: ', selected_folder]);
    end

    AutorunConfig.selected_folder = selected_folder;

    AutorunConfig.FolderContents = [];
    %% Extract Folder contents
    [AutorunConfig.FolderContents] = Execute_Autorun_Check_Selected_Folder(selected_folder);

    if isempty(AutorunConfig.FolderContents)
        error("Selected folder does not contain non-empty subfolders. Exiting")
    end

    NumIterations = numel(AutorunConfig.FolderContents);
   
else

    %if find(FunctionOrder == "Extract_Raw_Recording")
        msgbox("Please select a single folder containing your recording");

        %% Ask for Folder
        % Prompt the user to select a folder
        selected_folder = uigetdir;
        
        % Check if the user pressed the "Cancel" button
        if selected_folder == 0
            disp('User pressed cancel');
            return;
        else
            disp(['Selected folder: ', selected_folder]);
        end
    
        if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan")
            [containsFiles] = Execute_Autorun_Config_Check_Intan_Folder_Contents(selected_folder,AutorunConfig);
        elseif strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
            [stringArray] = Utility_Extract_Contents_of_Folder(selected_folder);
            FolderIndicieWithEphysData = [];
            for foldercontents = 1:length(stringArray)
                if contains(stringArray(foldercontents),'Record Node')
                    if isfolder(strcat(selected_folder,'\',stringArray(foldercontents)))
                        FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
                    end
                end
            end
            if isempty(FolderIndicieWithEphysData)
                containsFiles = false;
            else
                containsFiles = true;
            end
        end

        if containsFiles == false
            msgbox("Selected folder does not contain recording files. Exiting")
            error("Selected folder does not contain recording files. Exiting")
        end

        AutorunConfig.selected_folder = selected_folder;
        
        NumIterations = 1; 
end
