function [RhdFilePaths] = LoadIntanRHDFiles(Path)

%________________________________________________________________________________________

%% This function searches through folder contents containing an Intan recording and collects path to .rhd files that are available in that folder

% This function is basically checking the contents of a folder when
% extracting Intan data recording as .rhd files. With this format, the
% folder should just contain a single .rhd file

% Input:
% 1. Path: char of path to folder containing .dat files of intan
% recording

% Output: 
% 1. RhdFilePaths: full file path as char to the rhd file found

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

selectedFolder = Path;

% Initialize an empty cell array to store file paths

RhdFilePaths = [];

% Function to recursively find and save CSV file paths
function findFilesInFolder(folder)
    % Get a list of all files and folders in the current folder
    contents = dir(folder);
    
    % Loop through the contents of the folder
    for i = 1:length(contents)
        item = contents(i);
        
        % Check if the item is a directory and not '.' or '..'
        if item.isdir && ~ismember(item.name, {'.', '..'})
            % Recursively call the function for subfolders
            findFilesInFolder(fullfile(folder, item.name));
        elseif endsWith(item.name, '.rhd')
            filePath = fullfile(folder, item.name);
            RhdFilePaths = filePath;
        end
    end
end

% Start the recursive search process from the selected folder
findFilesInFolder(selectedFolder);

end