function [Data,LoadDataPath,SelectedFolder] = Execute_Autorun_Set_Up_Folder(AutorunConfig,Data,nRecordings,LoadDataPath)

% Prepare Folder Selections 
if strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
elseif strcmp(AutorunConfig.ExtractMultipleRecordings,"on") && strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
    SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
else
    SelectedFolder = AutorunConfig.selected_folder;
end

if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan")
    [containsFiles] = Execute_Autorun_Config_Check_Intan_Folder_Contents(SelectedFolder,AutorunConfig);

    if containsFiles == false
        Data = [];
        LoadDataPath = [];
        return;
    end
elseif strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
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
        LoadDataPath = [];
        return;
    end

end