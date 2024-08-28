function [containsFiles] = Execute_Autorun_Config_Simple_Check_FileEnding(Folder,FileEnding)
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