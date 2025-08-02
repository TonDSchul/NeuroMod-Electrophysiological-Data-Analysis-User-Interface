function  [Success] = Manage_Dataset_Module_Start_Neo(SelectedPath,executableFolder,JustLoadDatFile,KeepPythonOpen,RecordingSystemSelection)

Success = 0;

warning("Under certain circumstances it is necessary to press enter in the Matlab command window after the python code finished, for Matlab to respond again!")

if JustLoadDatFile == 1
    Success = 1;
    return;
end

[NEOPython_Conda_Environment_Path] = Manage_Dataset_Load_NEO_Conda_Python_exe(executableFolder);

NeoScriptPath = strcat(executableFolder,'\Modules\Neo\LoadWithNeo.py');

command = sprintf('"%s" "%s" "%s" "%d" "%d" "%s"', ...
        NEOPython_Conda_Environment_Path, NeoScriptPath, SelectedPath, double(KeepPythonOpen), double(JustLoadDatFile), RecordingSystemSelection);
    
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