function Extract_Events_Molue_Start_NEO_EventExtraction(Data,executablefolder,SelectedPath,NEOParameter)

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