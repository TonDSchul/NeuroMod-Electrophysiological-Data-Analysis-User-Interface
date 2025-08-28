function  [Success] = Manage_Dataset_Module_Start_Phy(Data,executableFolder)

%________________________________________________________________________________________

%% This function starts the python script LoadWithNeo.py to extract a recording with Neuralensemble NEO

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. executableFolder: char, path in which NeuroMod was opened, from main
% window

% Output: 
% 1. Success: double, 1 or 0 whether script succesfully finished

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Success = 0;

warning("Under certain circumstances it is necessary to press enter in the Matlab command window after the python code finished, for Matlab to respond again!")

[PhyPython_Conda_Environment_Path] = Manage_Dataset_Load_Phy_Conda_Python_exe(executableFolder);

fullPythonExe = PhyPython_Conda_Environment_Path;
resultsFolder = Data.Info.SorterPath;
batFile = strcat(executableFolder,'\Modules\MISC\Variables (do not edit)\launch_phy.bat');

% Example path: C:\Users\tonyd\anaconda3\envs\phy2\python.exe
% Extract environment name ("phy2") and conda root
[envPath, ~, ~] = fileparts(fullPythonExe);       % strip python.exe
[envsPath, PhyEnvName] = fileparts(envPath);      % strip env name
[condaRoot, envsFolder] = fileparts(envsPath);    % strip "envs"

if ~strcmpi(envsFolder, 'envs')
    error('Selected python.exe is not inside a conda environment.');
end

% Path to conda.bat
CondaBat = fullfile(condaRoot, 'condabin', 'conda.bat');

% % do the rest
fid = fopen(batFile,'w');
fprintf(fid, '@echo off\n');
fprintf(fid, 'call "%s" activate %s\n', CondaBat, PhyEnvName);
fprintf(fid, 'cd /d "%s"\n', resultsFolder);
fprintf(fid, 'phy template-gui params.py\n');  % Launch the GUI
fprintf(fid, 'pause\n');  % Keeps the window open in case of errors
fclose(fid);

system(['start "" "' batFile '"']);