function  [Success] = Manage_Dataset_Module_Start_Phy(Data,executableFolder)

%________________________________________________________________________________________

%% This function starts the python script LoadWithNeo.py to extract a recording with Neuralensemble NEO

% Input:
% 1. SelectedPath: char, path to the recording folder selected
% 2. executableFolder: char, from main window app, folder gui file is executed
% from
% 3. JustLoadDatFile: double/logical 1 or 0 whether to just load data
% without the need to start NEO
% 4. KeepPythonOpen: logical/double 1 or 0 whether to keep the python
% console open after script finished until user pressed enter
% 5. RecordingSystemSelection: char, recording type from
% Data.Info.RecordingSystem
% 6. FormatToSaveandReadintoMatlab: char from the extract raw recording
% window which format to use (see python script which ones)
% 7. IsNP1: double 1 or 0 whether open ephys recording is a NP 1.0 recording
% 8. DataPartToextract: double, if IsNP1 == 1, user selected whether to
% extract LFP or AP data: 1 = LFO data, 2 = AP Data

% note: when extracting events, add the char EventAnalysis is added to the
% end of the char FormatToSaveandReadintoMatlab to show the NEO script to
% just extract events

% Output: 
% 1. Success: double, 1 or 0 whether script succesfully finished

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Success = 0;

warning("Under certain circumstances it is necessary to press enter in the Matlab command window after the python code finished, for Matlab to respond again!")

[PhyPython_Conda_Environment_Path] = Manage_Dataset_Load_Phy_Conda_Python_exe(executableFolder);

% Example variables
PhyPythonEnvPath = PhyPython_Conda_Environment_Path;  % python.exe inside your phy environment
resultsFolder    = Data.Info.SorterPath;
paramsFile       = fullfile(resultsFolder, 'params.py');

PhyEnvName    = 'phy2';
batFile       = 'C:\Users\tonyd\launch_phy.bat';

CondaBat = 'C:\Users\tonyd\anaconda3\condabin\conda.bat';

fid = fopen(batFile,'w');
fprintf(fid, '@echo off\n');
fprintf(fid, 'call "%s" activate %s\n', CondaBat, PhyEnvName);
fprintf(fid, 'cd /d "%s"\n', resultsFolder);
fprintf(fid, 'phy template-gui params.py\n');  % Launch the GUI
fprintf(fid, 'pause\n');  % Keeps the window open in case of errors
fclose(fid);


system(['start "" "' batFile '"']);
