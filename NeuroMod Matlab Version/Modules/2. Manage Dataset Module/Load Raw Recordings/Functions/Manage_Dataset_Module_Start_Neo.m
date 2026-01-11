function  [Success] = Manage_Dataset_Module_Start_Neo(SelectedPath,executableFolder,JustLoadDatFile,KeepPythonOpen,RecordingSystemSelection,FormatToSaveandReadintoMatlab,IsNP1,Np1DataPartToextract,TimeToLoad,ChannelToLoad)

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
% 9. TimeToLoad: char, comma separated numbers for specific time like '0,10' or '0,Inf' for whole time range, user input from the GUI
% 10. ChannelToLoad: matlab expressions as char, user input from the GUI

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

if JustLoadDatFile == 1
    Success = 1;
    return;
end

[NEOPython_Conda_Environment_Path] = Manage_Dataset_Load_NEO_Conda_Python_exe(executableFolder);

NeoScriptPath = strcat(executableFolder,'\Modules\Neo\LoadWithNeo.py');

if iscell(SelectedPath)
    SelectedPath = strjoin(SelectedPath, ',');
end

if ~strcmp(ChannelToLoad,"All")
    ChannelToLoad = num2str(eval(ChannelToLoad));
end

TimeToLoad = convertStringsToChars(TimeToLoad);

%% Save Parameter for sorting script to load
NEOparams = struct();

NEOparams.SelectedPath = SelectedPath;
NEOparams.KeepPythonOpen = double(KeepPythonOpen);
NEOparams.JustLoadDatFile = double(JustLoadDatFile);

NEOparams.RecordingSystemSelection = RecordingSystemSelection;
NEOparams.FormatToSaveandReadintoMatlab = FormatToSaveandReadintoMatlab;
NEOparams.IsNP1 = IsNP1;
NEOparams.Np1DataPartToextract = Np1DataPartToextract;
NEOparams.TimeToLoad = TimeToLoad;
NEOparams.ChannelToLoad = ChannelToLoad;

%% Save

PathTosaveTempParams = fullfile(SelectedPath,'NEOParams.json');

jsonStr = jsonencode(NEOparams, 'PrettyPrint', true);

% Define output file path
jsonFilePath = PathTosaveTempParams;  % or specify full path directly

% Write JSON to file
fid = fopen(jsonFilePath, 'w');
if fid == -1
    error('Cannot create JSON file: %s', jsonFilePath);
end
fwrite(fid, jsonStr, 'char');
fclose(fid);

disp("Successfully saved NEO params for data extraction script to load.")

pause(2)
command = sprintf('"%s" "%s" "%s"', ...
        NEOPython_Conda_Environment_Path, NeoScriptPath, PathTosaveTempParams);

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

clear NEOparams