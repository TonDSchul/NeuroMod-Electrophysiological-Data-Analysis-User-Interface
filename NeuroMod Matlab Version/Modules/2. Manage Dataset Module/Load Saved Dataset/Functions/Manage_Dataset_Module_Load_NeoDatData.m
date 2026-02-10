function [Data,Textbox] = Manage_Dataset_Module_Load_NeoDatData(FullDataPath,FullPathInfo)

%________________________________________________________________________________________

%% This function loads data saved in NeuroMod in a NEO compatible .mat file (can be loaded with NEO.io)

% Input:
% 1. FullDataPath: char, path to the .mat file with NEO data
% 2. FullPathInfo: char, path to the .mat file containing the Data.Info
% structure to load back into Neuromod with all necessary info

% Output: 
% 1. Data: main app data structure holding all relevant data components
% 2. Textbox: char, result to show in the app text area. 

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Textbox = [];
Data = [];

%% ------------------------------ Load MetaData ------------------------------
    
h = waitbar(0, 'Loading Neo .dat files...', 'Name','Loading Neo .dat files...');
msg = sprintf('Loading Neo .dat files... (%d%% done)', 25);
waitbar(25, h, msg);

dashindex = find(FullDataPath=='\');

GeneralPath = strcat(FullDataPath(1:dashindex(end)-1));

Filename = strcat(FullDataPath(dashindex(end)+1:end-4));

MetaDataPath = strcat(GeneralPath,'\',Filename,'_NEO_dat_Info.json');

%% -------------------- Load Meta Data --------------------
jsonText = fileread(MetaDataPath);
MetaDataStruct = jsondecode(jsonText);

Data.Info = MetaDataStruct.Info;


Data.Time = 0:1/Data.Info.NativeSamplingRate:(double(Data.Info.num_data_points)-1)*(1/Data.Info.NativeSamplingRate);

%% Load Event Data
% Initialize Events cell array
Data.Events = {};

% Check if EventStruct exists
if isfield(MetaDataStruct, 'EventStruct') && ~isempty(MetaDataStruct.EventStruct)
    nEvents = numel(MetaDataStruct.EventStruct);
    
    % Loop over each event channel
    for ne = 1:nEvents
        Data.Events{ne} = MetaDataStruct.EventStruct(ne).times';   % times for each channel
    end
    
    % Optional: store event channel names
    if isfield(MetaDataStruct.EventStruct, 'event_channel_name')
        Data.Info.EventChannelNames = {MetaDataStruct.EventStruct.event_channel_name};
    end
end


if isfield(Data,'Spikes')
    fieldsToDelete = {'Spikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
end
Data.Info.SpikeType = 'Non';
Data.Info.Sorter = 'Non';

%% Load Data
% initialize
ScalingFactor = MetaDataStruct.ScalingFactor;
Data.Raw = NaN(Data.Info.NrChannel,Data.Info.num_data_points);
% load
mmf = memmapfile(FullDataPath, ...
    'Format', {'int16', [Data.Info.NrChannel Data.Info.num_data_points], 'x'});

Data.Raw = single(mmf.Data(1).x)./ScalingFactor;

% if isa(Data.Raw,"double")
%     Data.Raw = single(Data.Raw);
% end

if isfield(Data,'Events')
    if isempty(Data.Events)
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
end

if isfield(Data.Info,'ScalingFactor')
    fieldsToDelete = {'ScalingFactor'};
    % Delete fields
    Data.Info = rmfield(Data.Info, fieldsToDelete);
end

close(h);
