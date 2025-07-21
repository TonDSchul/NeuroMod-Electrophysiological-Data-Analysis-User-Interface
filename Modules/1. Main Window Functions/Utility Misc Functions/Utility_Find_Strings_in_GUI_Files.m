function Utility_Find_Strings_in_GUI_Files()

% Define the folder to search
folderPath = 'C:\Users\tonyd\Documents\LIN\PhD\Proj. Ephys GUI';

% Define the string to search for
searchString = input('Enter the string to search for: ', 's');

% Get all .m and .mlapp files in the folder
fileList = dir(fullfile(folderPath, '**', '*.*'));
fileList = fileList(endsWith({fileList.name}, {'.m', '.mlapp'}));

% Initialize results
results = [];

% Loop through each file
for k = 1:length(fileList)
    % Get the full file path
    filePath = fullfile(fileList(k).folder, fileList(k).name);
    
    % Read the file content
    try
        % Special handling for .mlapp files
        if endsWith(filePath, '.mlapp')
            % Extract the code from the .mlapp file
            mlappContent = extractMlappCode(filePath);
            fileContent = mlappContent;
        else
            % Read .m file content
            fileContent = fileread(filePath);
        end
        
        % Search for the string
        if contains(fileContent, searchString)
            fprintf('Found "%s" in %s\n', searchString, filePath);
            results = [results; {filePath}]; %#ok<AGROW>
        end
    catch ME
        % Display any errors encountered while reading files
        fprintf('Could not read file: %s\nError: %s\n', filePath, ME.message);
    end
end

% Display summary
if isempty(results)
    %disp('No matches found.');
else
    disp('Matches found in the following files:');
    disp(results);
end

% Helper function to extract code from .mlapp files
function code = extractMlappCode(mlappPath)
    % Open the .mlapp file as a zip archive
    tempDir = tempname;
    unzip(mlappPath, tempDir);
    
    % Locate the "code.m" file in the unzipped folder
    codeFilePath = fullfile(tempDir, 'code.m');
    if isfile(codeFilePath)
        code = fileread(codeFilePath);
    else
        %error('Unable to find code in .mlapp file.');
    end
    
    % Clean up temporary directory
    rmdir(tempDir, 's');
end

end