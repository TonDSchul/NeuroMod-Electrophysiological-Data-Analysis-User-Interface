function Spike_Module_Start_SpikeInterface_Sorting(Data,SpikeInterfaceParameter,executableFolder,SpikeSortinBinPath,SelectedSorter,ManualSelection,ParameterStructure)

[pythonPath] = Spike_Module_Check_Load_Conda_Python_exe(executableFolder);
SpikeInterfaceScriptPath = strcat(executableFolder,'\Modules\SpikeInterface\SpikeInterface_Sorting.py');

if isempty(SpikeInterfaceParameter)
    SpikeInterfaceParameter.OpenSpikeInterface = 1;
    SpikeInterfaceParameter.Preprocess = 1;
    SpikeInterfaceParameter.PlotTraces = 0;
    SpikeInterfaceParameter.PlotSortingResults = 0;
    SpikeInterfaceParameter.JustOpenSpikeInterfaceGUI = 0;
    SpikeInterfaceParameter.LoadSorting = 0;
    SpikeInterfaceParameter.MultipleRecordings = 0;
    SpikeInterfaceParameter.Sorter = SelectedSorter;
    SpikeInterfaceParameter.KeepConsoleOpen = 0;
else
    SpikeInterfaceParameter.JustOpenSpikeInterfaceGUI = 0;
end

% path
if ManualSelection == 0
    dashindex = find(SpikeSortinBinPath=='\');
    TempSpikeSortinBinPath = SpikeSortinBinPath(1:dashindex(end)-1);
    file_path = TempSpikeSortinBinPath;
else
    if SpikeInterfaceParameter.MultipleRecordings == 0
        dashindex = find(SpikeSortinBinPath=='\');
        TempSpikeSortinBinPath = SpikeSortinBinPath(1:dashindex(end)-1);
        file_path = TempSpikeSortinBinPath;
    else
        file_path = SpikeSortinBinPath;
    end
end

SampleRate = Data.Info.NativeSamplingRate;
NumChannel = size(Data.Raw,1);
ypitch = Data.Info.ChannelSpacing;

%% Set all variables needed
VerChannelOffset = str2double(Data.Info.ProbeInfo.VertOffset);
HorChannelOffset = str2double(Data.Info.ProbeInfo.HorOffset);
NumberRows = str2double(Data.Info.ProbeInfo.NrRows);
RowOffset = double(Data.Info.ProbeInfo.OffSetRows);
RowOffsetDistance = str2double(Data.Info.ProbeInfo.OffSetRowsDistance);

ActiveChannel = sprintf('%d,', Data.Info.ProbeInfo.ActiveChannel - 1);
ActiveChannel(end) = [];  % remove final comma
AllChannel = str2double(Data.Info.ProbeInfo.NrChannel);

yCoords = sprintf('%d,', Data.Info.ProbeInfo.ycoords);
xCoords = sprintf('%d,', Data.Info.ProbeInfo.xcoords);
if yCoords(end)==','
    yCoords(end) = [];
end
if xCoords(end)==','
    xCoords(end) = [];
end

SortingParameters = Spike_Module_Sorting_Parameter_To_JSON(SelectedSorter,ParameterStructure,file_path);

%% Save Parameter for sorting script to load
GUIparams = struct();

GUIparams.file_path = file_path;
GUIparams.MultipleRecordings = SpikeInterfaceParameter.MultipleRecordings;
GUIparams.SelectedSorter = SelectedSorter;

GUIparams.Preprocess = SpikeInterfaceParameter.Preprocess;
GUIparams.LoadSorting = SpikeInterfaceParameter.LoadSorting;
GUIparams.OpenSpikeInterface = SpikeInterfaceParameter.OpenSpikeInterface;
GUIparams.PlotSortingResults = SpikeInterfaceParameter.PlotSortingResults;
GUIparams.JustOpenSpikeInterfaceGUI = SpikeInterfaceParameter.JustOpenSpikeInterfaceGUI;

GUIparams.SampleRate = SampleRate;
GUIparams.NumChannel = NumChannel;
GUIparams.ypitch = ypitch;

GUIparams.KeepConsoleOpen = SpikeInterfaceParameter.KeepConsoleOpen;
GUIparams.PlotTraces = SpikeInterfaceParameter.PlotTraces;

GUIparams.VerChannelOffset = VerChannelOffset;
GUIparams.HorChannelOffset = HorChannelOffset;
GUIparams.NumberRows = NumberRows;
GUIparams.RowOffset = RowOffset;
GUIparams.RowOffsetDistance = RowOffsetDistance;

GUIparams.AllChannel = AllChannel;
GUIparams.ActiveChannel = ActiveChannel;
GUIparams.xCoords = xCoords;
GUIparams.yCoords = yCoords;

%% Save
PathTosaveTempParams = fullfile(TempSpikeSortinBinPath,'GUIParams.json');

jsonStr = jsonencode(GUIparams, 'PrettyPrint', true);

% Define output file path
jsonFilePath = PathTosaveTempParams;  % or specify full path directly

% Write JSON to file
fid = fopen(jsonFilePath, 'w');
if fid == -1
    error('Cannot create JSON file: %s', jsonFilePath);
end
fwrite(fid, jsonStr, 'char');
fclose(fid);

clear GUIparams
disp("Successfully saved GUI params for SpikeInterface script to load.")

pause(1)

command = sprintf('"%s" "%s" "%s"', ...
    pythonPath, SpikeInterfaceScriptPath, PathTosaveTempParams);

% Execute the Python script
[status, cmdout] = system(command);

% Check status

if status == 0
    disp('Python script executed successfully:');
    disp(cmdout);
    % Auto load results

    dashindex = find(file_path=='\');
    TempFilePath = file_path(1:dashindex(end)-1);
    
    msgbox("Spike Sorting succesfull! Results can now be laoded using the 'Load Sorting Results' window or by selecting 'Load Sorting Results' in the 'Options' dropdown menu of the 'Spike Detection and Sorting Window'.")

else
    disp('Error executing Python script:');
    disp(cmdout);
end