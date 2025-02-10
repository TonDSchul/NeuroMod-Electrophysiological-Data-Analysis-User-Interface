function Utility_DeleteUnusedFunctions()
% Define the folder containing the 1000 functions
folderPath = 'C:\Users\tonyd\Desktop\1. FieldTrip'; % Change this to your actual folder path

% Get a list of all .m files in the folder and subfolders
fileList = dir(fullfile(folderPath, '**', '*.m'));
load("RemainingFuncs.mat")
% Define the necessary function names (string array)
necessaryFunctions = RemainingFuncs; % Replace with your actual function list
a = 0;
b = 0;
% Loop through each file and delete if not in the necessary list
for i = 1:length(fileList)
    % Extract function name from file name (without extension)
    [~, funcName, ~] = fileparts(fileList(i).name);
    if ~strcmp(funcName(end-1:end),'.m')
        funcName = strcat(funcName,'.m');
    end
    
    funcName = convertCharsToStrings(funcName);
    
    % Check if the function is NOT in the necessary list
    if ~ismember(funcName, necessaryFunctions)
        b = b +1;
        % Get the full file path
        filePath = fullfile(fileList(i).folder, fileList(i).name);
        
        % Delete the file
        delete(filePath);
        fprintf('Deleted: %s\n', filePath);
    else
        a = a+1;
    end
end

disp(strcat(num2str(a)," Functions recognized"))
disp(strcat(num2str(b)," Functions NOT recognized and deleted"))
disp('Cleanup complete.');


