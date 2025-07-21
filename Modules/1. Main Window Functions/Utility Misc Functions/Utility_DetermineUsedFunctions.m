function [AllFiles] = Utility_DetermineUsedFunctions()
% Define your script file
scriptFile = 'Extract_Events_Module_Display_Neuralynx_EventInfo.m'; % Replace with your script filename

% Get the list of required function files
[usedFiles, ~] = matlab.codetools.requiredFilesAndProducts(scriptFile);

AllFiles = string;
for i = 1:length(usedFiles)
    dashindex = strfind(usedFiles{i},'\');
    AllFiles(i) = convertCharsToStrings(usedFiles{i}(dashindex(end)+1:end));
end

