% Main folder to search (change this to your folder path)
mainFolder = 'F:\LIN\PhD\Proj. Ephys GUI\NeuroMod Matlab Version';

% Search string
searchString = 'Manage_Dataset_SaveData_Reset_Slashes';

% Get all .m and .mlapp files recursively
fileList_m     = dir(fullfile(mainFolder, '**', '*.m'));
fileList_mlapp = dir(fullfile(mainFolder, '**', '*.mlapp'));

% Combine into one list
fileList = [fileList_m; fileList_mlapp];

% Initialize cell array for matches
matchingFiles = {};

% Loop through all files
for i = 1:length(fileList)
    filePath = fullfile(fileList(i).folder, fileList(i).name);

    % Read file contents
    try
        fileText = fileread(filePath);
    catch
        warning('Could not read file: %s', filePath);
        continue;
    end

    % Search for the string
    if contains(fileText, searchString)
        matchingFiles{end+1} = filePath; %#ok<SAGROW>
        fprintf('Found in: %s\n', filePath);
    end
end

% Summary3e4
if isempty(matchingFiles)
    disp('No files found containing the specified function call.');
else
    disp('--- Matching Files ---');
    disp(matchingFiles');
end
