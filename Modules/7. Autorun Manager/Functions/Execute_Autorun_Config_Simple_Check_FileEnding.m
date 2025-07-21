function [containsFiles] = Execute_Autorun_Config_Simple_Check_FileEnding(Folder,FileEnding)

%________________________________________________________________________________________
%% This function checks whether a folder has files with the specified file extension

% Inputs:
% 1. Folder: char, path to the folder that has to be checked
% 2. FileEnding: char, file extension to check for, i.e. '.dat'

% Output:
% 1. containsFiles: true if file(s) with file extension was found, 0 if not

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% Get the contents of the folder
contents = dir(Folder);

% Initialize a flag to indicate if .dat files are found
containsFiles = false;

% Check each item in the folder
for i = 1:length(contents)
    item = contents(i);
    
    % Skip the current and parent directory entries
    if strcmp(item.name, '.') || strcmp(item.name, '..')
        continue;
    end
    
    % Check if the item is a .dat file
    [~, ~, ext] = fileparts(item.name);
    if strcmp(ext, FileEnding)
        containsFiles = true;
        break;
    end
end