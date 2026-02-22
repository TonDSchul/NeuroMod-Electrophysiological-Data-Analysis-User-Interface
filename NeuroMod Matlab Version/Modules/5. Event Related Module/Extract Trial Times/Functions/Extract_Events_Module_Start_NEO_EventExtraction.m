function Extract_Events_Module_Start_NEO_EventExtraction(Data,executablefolder,SelectedPath,NEOParameter)

%________________________________________________________________________________________
%% Function to start neo for event extraction when a folder was selected manually by the user

% Inputs: 
% 1. Data: main window data structure
% 2. executablefolder: char, folder NeuroMod was started from
% 3. SelectedPath: char, path to event files selected by user
% 4. NEOParameter: struc with some information for NEO

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

[NEOPython_Conda_Environment_Path] = Manage_Dataset_Load_NEO_Conda_Python_exe(executablefolder);

warning("Under certain circumstances it is necessary to press enter in the Matlab command window after the python code finished, for Matlab to respond again!")

NeoScriptPath = strcat(executablefolder,'\Modules\Neo\LoadWithNeo.py');

Format = strcat(NEOParameter.Format,"EventExtraction");

command = sprintf('"%s" "%s" "%s" "%d" "%d" "%s"', ...
        NEOPython_Conda_Environment_Path, NeoScriptPath, SelectedPath, double(NEOParameter.KeepOpen), 0, Format);
    
% Execute the Python script
[status, cmdout] = system(command);

% Check status

if status == 0
    disp('Python script executed successfully:');
    disp(cmdout);
    Success = 1;
else
    disp('Error executing Python script:');
    disp(cmdout);
end