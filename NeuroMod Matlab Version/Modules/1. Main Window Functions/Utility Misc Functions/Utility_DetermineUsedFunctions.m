function [AllFiles] = Utility_DetermineUsedFunctions()

%________________________________________________________________________________________
%% Function to determine which functions are part of a scriupt being executed

% Output: AllFiles = liost with all function names

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Define your script file
scriptFile = 'Extract_Events_Module_Display_Neuralynx_EventInfo.m'; % Replace with your script filename

% Get the list of required function files
[usedFiles, ~] = matlab.codetools.requiredFilesAndProducts(scriptFile);

AllFiles = string;
for i = 1:length(usedFiles)
    dashindex = strfind(usedFiles{i},'\');
    AllFiles(i) = convertCharsToStrings(usedFiles{i}(dashindex(end)+1:end));
end

