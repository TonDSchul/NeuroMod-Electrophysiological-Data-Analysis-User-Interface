function Utility_Extract_Function_Headers_to_txt(folderPath, outputFileName)

%________________________________________________________________________________________
%% Function to search for all function headers in all .m files of a folder and save in a txt. file
% This function can be used to automatically create a README file in each
% folder containing the function headers of each function

% Input Arguments:
% 1. folderPath: Path to the folder holding .m files as char
% 2. outputFileName: Name of the .txt file to save the header infos in (including the .txt file ending)

% Output Arguments:
% 1. stringArray: Contens of folder in a n x 1 string array with n being
% the number of contents

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Check if the folder exists
if ~isfolder(folderPath)
    error('The folder "%s" does not exist.', folderPath);
end

% Get a list of all .m files in the folder
files = dir(fullfile(folderPath, '*.m'));

% Open the output text file for writing
outputFilePath = fullfile(folderPath, outputFileName);
fidOut = fopen(outputFilePath, 'w');

if fidOut == -1
    error('Could not open output file for writing.');
end

% Define the header delimiter
headerDelimiter = '%________________________________________________________________________________________';

fprintf(fidOut, 'This folder contains the following functions with respective Header:\n\n ###################################################### \n\n');

% Loop over each .m file
for i = 1:length(files)
    filePath = fullfile(files(i).folder, files(i).name);
    fidIn = fopen(filePath, 'r');
    
    if fidIn == -1
        warning('Could not open file "%s". Skipping...', files(i).name);
        continue;
    end
    
    % Read the file line by line
    isHeader = false;
    headerLines = {};
    
    while ~feof(fidIn)
        line = fgetl(fidIn);
        if contains(line, headerDelimiter)
            if isHeader
                % If we reach the second delimiter, break out of the loop
                headerLines{end+1} = line; %#ok<AGROW>
                break;
            else
                % Start recording the header
                isHeader = true;
            end
        end
        
        if isHeader
            headerLines{end+1} = line; %#ok<AGROW>
        end
    end
    
    fclose(fidIn);
    
    % Write the header to the output file
    if ~isempty(headerLines)
        fprintf(fidOut, 'File: %s\n', files(i).name);
        for j = 1:length(headerLines)
            fprintf(fidOut, '%s\n', headerLines{j});
        end
        fprintf(fidOut, '\n\n ###################################################### \n\n');
    else
        warning(strcat("Could not identitfy header for ",files(i).name));
    end
end

% Close the output file
fclose(fidOut);

fprintf('Headers extracted to "%s"\n', outputFilePath);
