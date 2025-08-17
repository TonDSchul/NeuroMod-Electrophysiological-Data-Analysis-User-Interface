function [Data] = Manage_Dataset_Module_Load_SpikeInterface(DataPath)

dashindex = find(DataPath=='\');

GeneralPath = strcat(DataPath(1:dashindex(end)-1));

MetaDataPath = strcat(GeneralPath,'\Meta_Data.json');

%% -------------------- Load Meta Data --------------------
jsonText = fileread(MetaDataPath);
MetaDataStruct = jsondecode(jsonText);

ModifiedPath = MetaDataStruct.Path;
ModifiedPath(find(ModifiedPath == '/')) = '\';

% MetaData
Data.Info.NativeSamplingRate = MetaDataStruct.SampleRate;
Data.Info.RecordingType = MetaDataStruct.RecordingType;
Data.Info.ChannelSpacing = MetaDataStruct.ChannelSpacing;
Data.Info.SpikeType = 'Non';
Data.Info.Data_Path = ModifiedPath;
Data.Info.NrChannel = MetaDataStruct.num_channels;
Data.Info.num_data_points = str2double(MetaDataStruct.num_data_points);
Data.Info.startTimestamp = MetaDataStruct.startTimestamp;
Data.Info.Channelorder = MetaDataStruct.Channelorder;

% ProbeInfo
Data.Info.ProbeInfo.NrChannel = MetaDataStruct.NrChannel;
Data.Info.ProbeInfo.NrRows = MetaDataStruct.NrRows;
Data.Info.ProbeInfo.VertOffset = MetaDataStruct.VertOffset;
Data.Info.ProbeInfo.HorOffset = MetaDataStruct.HorOffset;
Data.Info.ProbeInfo.ActiveChannel = MetaDataStruct.ActiveChannel;

Data.Info.ProbeInfo.SwitchTopBottomChannel = MetaDataStruct.SwitchTopBottomChannel;
Data.Info.ProbeInfo.SwitchLeftRightChannel = MetaDataStruct.SwitchLeftRightChannel;
Data.Info.ProbeInfo.FlipLoadedData = MetaDataStruct.FlipLoadedData;

Data.Info.ProbeInfo.OffSetRows = MetaDataStruct.OffSetRows;
Data.Info.ProbeInfo.OffSetRowsDistance = MetaDataStruct.OffSetRowsDistance;

if isfield(MetaDataStruct,'CompleteAreaNames')
    Data.Info.ProbeInfo.CompleteAreaNames = MetaDataStruct.CompleteAreaNames;
    Data.Info.ProbeInfo.ShortAreaNames = MetaDataStruct.ShortAreaNames;
    Data.Info.ProbeInfo.AreaDistanceFromTip = MetaDataStruct.AreaDistanceFromTip;
end

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

%% Load Data
% initialize

Data.Raw = NaN(Data.Info.NrChannel,Data.Info.num_data_points);
% load
mmf = memmapfile(DataPath, ...
    'Format', {'double', [Data.Info.NrChannel Data.Info.num_data_points], 'x'});

Data.Raw = mmf.Data(1).x;

