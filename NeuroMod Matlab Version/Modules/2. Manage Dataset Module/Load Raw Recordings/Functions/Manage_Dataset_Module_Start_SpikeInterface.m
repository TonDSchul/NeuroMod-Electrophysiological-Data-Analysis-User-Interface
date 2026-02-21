function  [Success] = Manage_Dataset_Module_Start_SpikeInterface(SelectedPath,executableFolder,JustLoadDatFile,KeepPythonOpen,RecordingSystemSelection,FormatToSaveandReadintoMatlab,SaveProbeInfo,SaveProbeInfoFormat,TimeToLoad,ChannelToLoad,CorrectDCOffset)

%________________________________________________________________________________________

%% This function starts the python script SILoadMaxwell.py to extract a Maxwell biosystems MEA .h5 recording with SpikeInterface

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
% 7. SaveProbeInfo: 1 or 0 whether to save probe Info
% 8. SaveProbeInfoFormat: char, format to save in, '.mat' OR '.prb'
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

[Python_Conda_Environment_Path] = Spike_Module_Check_Load_Conda_Python_exe(executableFolder);

SIScriptPath = strcat(executableFolder,'\Modules\SpikeInterface\SILoadMaxwell.py');

if iscell(SelectedPath)
    SelectedPath = strjoin(SelectedPath, ',');
end

if ~strcmp(ChannelToLoad,"All")
    ChannelToLoad = num2str(eval(ChannelToLoad));
end

TimeToLoad = convertStringsToChars(TimeToLoad);

%% Save Parameter for sorting script to load
SIparams = struct();

SIparams.SelectedPath = SelectedPath;
SIparams.KeepPythonOpen = KeepPythonOpen;
SIparams.JustLoadDatFile = JustLoadDatFile;
SIparams.RecordingSystemSelection = RecordingSystemSelection;

SIparams.FormatToSaveandReadintoMatlab = FormatToSaveandReadintoMatlab;
SIparams.SaveProbeInfo = SaveProbeInfo;
SIparams.SaveProbeInfoFormat = SaveProbeInfoFormat;
SIparams.TimeToLoad = TimeToLoad;
SIparams.ChannelToLoad = ChannelToLoad;
SIparams.CorrectDCOffset = CorrectDCOffset;

%% Save
PathTosaveTempParams = fullfile(SelectedPath,'SIParams.json');

jsonStr = jsonencode(SIparams, 'PrettyPrint', true);

% Define output file path
jsonFilePath = PathTosaveTempParams;  % or specify full path directly

% Write JSON to file
fid = fopen(jsonFilePath, 'w');
if fid == -1
    error('Cannot create JSON file: %s', jsonFilePath);
end
fwrite(fid, jsonStr, 'char');
fclose(fid);

clear SIparams
disp("Successfully saved GUI params for SpikeInterface script to load.")

pause(1)

command = sprintf('"%s" "%s" "%s"', ...
        Python_Conda_Environment_Path, SIScriptPath, PathTosaveTempParams);

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