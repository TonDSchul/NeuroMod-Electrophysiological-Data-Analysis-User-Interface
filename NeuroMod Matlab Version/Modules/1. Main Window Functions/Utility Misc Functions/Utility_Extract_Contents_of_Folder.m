function [stringArray] = Utility_Extract_Contents_of_Folder(Path)

%________________________________________________________________________________________
%% Function to extract all contents of a selcted folder and output them in a string array for easy use
% This function gets called for example whenever the user makes a folder
% selection and the contents are checked for a proper recording format or
% the contents are shown in a textarea of a gui window

% Input Arguments:
% 1. Path: Path to the folder as char

% Output Arguments:
% 1. stringArray: Contens of folder in a n x 1 string array with n being
% the number of contents

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Display Folder contents in information text box
% Get contents of the folder

contents = dir(Path);

% Initialize a cell array to store file names
fileNames = cell(length(contents), 1);

% Loop through the contents
for i = 1:length(contents)
    % Skip '.' and '..' directories
    if strcmp(contents(i).name, '.') || strcmp(contents(i).name, '..')
        continue;
    end
    
    % Store file name in the cell array
    fileNames{i} = contents(i).name;
end

% Initialize a string array
stringArray = strings(size(fileNames));

% Loop through the cell array and convert each cell to a string
Stringarraysize = 1;
for i = 1:numel(fileNames)
    if ~isempty(fileNames{i})
        stringArray(Stringarraysize) = string(fileNames{i});
        Stringarraysize = Stringarraysize+1;
    end
end
