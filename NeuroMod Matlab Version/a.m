% Main folder to search (change this to your folder path)
mainFolder = 'F:\LIN\PhD\Proj. Ephys GUI\NeuroMod Matlab Version';

% Search string
searchString = 'Spike_Module_Calculate_Spikes_Times_In_Bin';

% Get all .m files recursively
fileList = dir(fullfile(mainFolder, '**', '*.m'));

% Initialize cell array for matches
matchingFiles = {};

% Loop through all .m files
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

% Summary
if isempty(matchingFiles)
    disp('No files found containing the specified function call.');
else
    disp('--- Matching Files ---');
    disp(matchingFiles');
end
