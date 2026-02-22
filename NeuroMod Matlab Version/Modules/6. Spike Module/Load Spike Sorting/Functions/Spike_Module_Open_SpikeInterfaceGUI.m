function Spike_Module_Open_SpikeInterfaceGUI(Data,executableFolder,Sorter)

%________________________________________________________________________________________

%% Not used anymore, was experimental, maybe updated and implemented

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% needs same environmental pythonexe than spikeinterface
[pythonPath] = Spike_Module_Check_Load_Conda_Python_exe(executableFolder);

SpikeInterfaceScriptPath = strcat(executableFolder,'\Modules\SpikeInterface\SpikeInterface_Sorting.py');

SpikeInterfaceParameter.OpenSpikeInterface = 1;
SpikeInterfaceParameter.Preprocess = 1;
SpikeInterfaceParameter.PlotTraces = 0;
SpikeInterfaceParameter.PlotSortingResults = 0;
SpikeInterfaceParameter.JustOpenSpikeInterfaceGUI = 1;
SpikeInterfaceParameter.LoadSorting = 1;
SpikeInterfaceParameter.MultipleRecordings = 0;
SpikeInterfaceParameter.Sorter = Sorter;
SpikeInterfaceParameter.KeepConsoleOpen = 0;

% path
if app.ManualSelection == 0
    dashindex = find(app.SpikeSortinBinPath=='\');
    TempSpikeSortinBinPath = app.SpikeSortinBinPath(1:dashindex(end)-1);
    file_path = TempSpikeSortinBinPath;
else
    if SpikeInterfaceParameter.MultipleRecordings == 0
        dashindex = find(app.SpikeSortinBinPath=='\');
        TempSpikeSortinBinPath = app.SpikeSortinBinPath(1:dashindex(end)-1);
        file_path = TempSpikeSortinBinPath;
    else
        file_path = app.SpikeSortinBinPath;
    end
end

SampleRate = app.Mainapp.Data.Info.NativeSamplingRate;
NumChannel = size(app.Mainapp.Data.Raw,1);
ypitch = app.Mainapp.Data.Info.ChannelSpacing;

% Build the command string
VerChannelOffset = str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset);
HorChannelOffset = str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset);
NumberRows = str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows);
RowOffset = double(app.Mainapp.Data.Info.ProbeInfo.OffSetRows);
RowOffsetDistance = str2double(app.Mainapp.Data.Info.ProbeInfo.OffSetRowsDistance);

if strcmp(Sorter,"Mountainsort 5")
    % Loop over all fields
    fields = fieldnames(app.ParameterStructure.MS5);
    for i = 1:numel(fields)
        field = fields{i}; % Get the field name
        value = app.ParameterStructure.MS5.(field); % Get the field value
        
        if ischar(value) % Only process strings
            % Remove leading and trailing single/double quotes
            value = strip(value, '"');
            value = strip(value, '''');
            
            % Check if the value is 'None'
            if strcmpi(value, 'None')
                app.ParameterStructure.MS5.(field) = []; % Convert to empty
            else
                app.ParameterStructure.MS5.(field) = value; % Assign the cleaned value back
            end
        end
    end
    % Convert Sorter Parameter into dictionary
    SortingParameters = jsonencode(app.ParameterStructure.MS5);
elseif strcmp(Sorter,"SpyKING CIRCUS 2")
    app.ParameterStructure.SC2 = Spike_Module_cleanStructureQuotes(app.ParameterStructure.SC2);
    app.ParameterStructure.SC2 = Spike_Module_convertTrueFalseStrings(app.ParameterStructure.SC2);
    % Loop over all fields
    fields = fieldnames(app.ParameterStructure.SC2);
    for i = 1:numel(fields)
        field = fields{i}; % Get the field name
        value = app.ParameterStructure.SC2.(field); % Get the field value
        
        if ischar(value) % Only process strings
            % Remove leading and trailing single/double quotes
            value = strip(value, '"');
            value = strip(value, '''');
            
            % Check if the value is 'None'
            if strcmpi(value, 'None')
                app.ParameterStructure.SC2.(field) = []; % Convert to empty
            else
                app.ParameterStructure.SC2.(field) = value; % Assign the cleaned value back
            end
        end
    end
    % Convert Sorter Parameter into dictionary
    SortingParameters = jsonencode(app.ParameterStructure.SC2);
elseif strcmp(Sorter,"Kilosort 4")
    % Loop over all fields
    fields = fieldnames(app.ParameterStructure.KS4);
    for i = 1:numel(fields)
        field = fields{i}; % Get the field name
        value = app.ParameterStructure.KS4.(field); % Get the field value
        
        if ischar(value) % Only process strings
            % Remove leading and trailing single/double quotes
            value = strip(value, '"');
            value = strip(value, '''');
            
            % Check if the value is 'None'
            if strcmpi(value, 'None')
                app.ParameterStructure.KS4.(field) = []; % Convert to empty
            else
                app.ParameterStructure.KS4.(field) = value; % Assign the cleaned value back
            end
        end
    end

    % Convert Sorter Parameter into dictionary
    SortingParameters = jsonencode(app.ParameterStructure.KS4);
end

% Save JSON to a temporary file
if isfile(fullfile(file_path, 'sorting_parameters.json'))
    delete(fullfile(file_path, 'sorting_parameters.json'))
end
jsonFilePath = fullfile(file_path, 'sorting_parameters.json');
fid = fopen(jsonFilePath, 'w');
fwrite(fid, SortingParameters, 'char');
fclose(fid);

command = sprintf('"%s" "%s" "%s" %d "%s" %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d', ...
    pythonPath, SpikeInterfaceScriptPath, file_path, SpikeInterfaceParameter.MultipleRecordings, Sorter, ...
    SpikeInterfaceParameter.Preprocess, SpikeInterfaceParameter.LoadSorting, SpikeInterfaceParameter.OpenSpikeInterface, ...
    SpikeInterfaceParameter.PlotSortingResults, SpikeInterfaceParameter.JustOpenSpikeInterfaceGUI, SampleRate, NumChannel, ypitch, SpikeInterfaceParameter.KeepConsoleOpen, SpikeInterfaceParameter.PlotTraces,VerChannelOffset,HorChannelOffset,NumberRows,RowOffset,RowOffsetDistance);