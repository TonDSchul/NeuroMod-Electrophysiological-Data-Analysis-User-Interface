function [selectedFolder] = Manage_Dataset_Check_Spike2CED64_Path(executablefolder,FolderWithPathVariable)

%________________________________________________________________________________________

%% Function to check whether the path to the Spike2 Matlab SON interface is present

% when wanting to extract spike 2 data, this library is necessary. We need
% to know the path this was installed in. When wanting to extract Spike2
% data the first time in NeuroMod, the user is asked for that path and it
% is saved in a variable in GUI_Path/Modules/MISC/Variables/CEDS64Path.mat.
% After this, this variable is searched for and the path in it is check (whether it exists)

% Input:
% 1. executablefolder:folder in which current NeuroMod instance was started
% from
% 2. FolderWithPathVariable: Path to variable GUI_Path/Modules/MISC/Variables/CEDS64Path.mat.

% Output: 
% 1. selectedFolder: char, folder with the Spike2 Matlab SON interface if
% user had to select it (in other words when it wasnt present already)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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