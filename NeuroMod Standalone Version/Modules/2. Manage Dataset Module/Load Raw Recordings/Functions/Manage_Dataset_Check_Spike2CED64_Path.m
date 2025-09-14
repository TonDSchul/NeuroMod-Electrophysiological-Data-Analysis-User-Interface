function [selectedFolder] = Manage_Dataset_Check_Spike2CED64_Path(executablefolder,FolderWithPathVariable)
% If not installed let the user select the installation folder if he
% installs it

if exist(FolderWithPathVariable, 'file') == 2
    fileExists = true;
else
    fileExists = false;
end

if fileExists == false
    msgbox("'Spike2 MATLAB SON Interface' library not found. To analyze Spike2 .smrx files, you need to install this library available at 'https://ced.co.uk/upgrades/spike2matson'. Please install and select the 'CEDS64ML' folder thats installed with this library. You only need to do this once.");
    % Use the uigetdir function to open the file explorer dialog
    selectedFolder = uigetdir();

    % Check if the user canceled the dialog
    if selectedFolder == 0
        disp('Folder selection was canceled.');
        selectedFolder = '';
    else
        disp(['Selected folder: ', selectedFolder]);
    end
    savefilepath = strcat(executablefolder,'\Modules\MISC\Variables (do not edit)\CEDS64Path.mat');
    save(savefilepath,'selectedFolder')
else % If json interface found load path to it when its a valid path
    load(FolderWithPathVariable,'selectedFolder');

    if ~isfolder(selectedFolder)
        delete(FolderWithPathVariable)
        msgbox("'Spike2 MATLAB SON Interface' library not found. To analyze Spike2 .smrx files, you need to install this library available at 'https://ced.co.uk/upgrades/spike2matson'. Please install and select the 'CEDS64ML' folder thats installed with this library. You only need to do this once.");
        % Use the uigetdir function to open the file explorer dialog
        selectedFolder = uigetdir();
    
        % Check if the user canceled the dialog
        if selectedFolder == 0
            disp('Folder selection was canceled.');
            selectedFolder = '';
        else
            disp(['Selected folder: ', selectedFolder]);
        end
        savefilepath = strcat(executablefolder,'\Modules\MISC\Variables (do not edit)\CEDS64Path.mat');
        save(savefilepath,'selectedFolder')
    end
end