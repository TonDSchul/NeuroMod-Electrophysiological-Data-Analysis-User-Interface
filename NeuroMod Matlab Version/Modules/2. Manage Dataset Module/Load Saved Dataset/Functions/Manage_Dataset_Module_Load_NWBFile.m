function [Data,Textbox] = Manage_Dataset_Module_Load_NWBFile(FullDataPath)

%________________________________________________________________________________________

%% This function loads data saved in NeuroMod in the .nwb format using the MatNWB Toolbox

% Input:
% 1. FullDataPath: char, path to the .nwb file

% Output: 
% 1. Data: main app data structure holding all relevant data components
% 2. Textbox: char, result to show in the app text area. 

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

h = waitbar(0, 'Loading .nwb file...', 'Name','Loading .nwb file...');
msg = sprintf('Loading .nwb file... (%d%% done)', 25);
waitbar(25, h, msg);

%% Read the file
nwb = nwbRead(FullDataPath);

ephys_ts = nwb.acquisition.get('ElectricalSeries1');

msg = sprintf('Loading .nwb file... (%d%% done)', 50);
waitbar(50, h, msg);
%% Load Info mat file

MatInfoFolder = strcat(FullDataPath(1:end-4),'_NWB_Info.mat');

if isfile(MatInfoFolder)
    load(MatInfoFolder)
    try
        Data.Info = Info;
    catch   
        msgbox("Info file saved by NeuroMod not found in loaded .mat file. Make sure the saved variable is called Info!")
        error("Info file saved by NeuroMod not found in loaded .mat file. Make sure the saved variable is called Info!")
    end
else
    msgbox("Info .mat file could not be found! It is saved along with the data when saving with NeuroMod (saves a variable called Info equivalent to Data.Info).")
    error("Info file saved by NeuroMod not found in loaded .mat file. Make sure the saved variable is called Info!")
end

Data.Time = 0:1/Data.Info.NativeSamplingRate:(double(Data.Info.num_data_points)-1)*(1/Data.Info.NativeSamplingRate);

if isfield(Data,'Spikes')
    fieldsToDelete = {'Spikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
end
Data.Info.SpikeType = 'Non';
Data.Info.Sorter = 'Non';

msg = sprintf('Loading .nwb file... (%d%% done)', 75);
waitbar(75, h, msg);

%% Load Event Data
% Get list of all intervals (event channels)
eventNames = nwb.intervals.keys;

% Initialize container for loaded events
Data.Events = cell(1, length(eventNames));

for i = 1:length(eventNames)
    ti = nwb.intervals.get(eventNames{i});  % get the TimeIntervals object

    % Read start times (in seconds)
    start_times = ti.start_time.data.load();  

    % Optionally read stop times if needed
    stop_times = ti.stop_time.data.load();

    % Read labels
    label_vector = ti.vectordata.get('label');
    labels = label_vector.data.load();

    % Save in your Data.Events structure
    % For simplicity, just save the start times (like your original code)
    Data.Events{i} = round(start_times * Data.Info.NativeSamplingRate)';  

    % If you want to keep labels too:
    % Data.EventLabels{i} = labels;
end

%% Read data
Data.Raw = ephys_ts.data.load();

if isprop(ephys_ts,'data_unit')
    if strcmp(ephys_ts.data_unit,'volts')
        % Convert back in mV 
        Data.Raw = Data.Raw * 1000;
        disp("Converting data from volt to mV.")
    end
end

if isfield(Data,'Events')
    if isempty(Data.Events)
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
end

msg = sprintf('Loading .nwb file... (%d%% done)', 100);
waitbar(100, h, msg);
close(h)