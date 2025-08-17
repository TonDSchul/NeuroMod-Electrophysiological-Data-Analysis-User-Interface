function folderPath = Manage_Dataset_SaveData_SpikeInterfaceNumpy(Data,DatasetType,SaveEvents)

%% ------------------------- Select folder and file to save -------------------------

[filename, filepath] = uiputfile('*.bin', 'Save File');

% Check if the user canceled the operation
if isequal(filename,0) || isequal(filepath,0)
    disp('User canceled the operation.');
    return;
end

folderPath = fullfile(filepath, filename);

%% ------------------------- Prepare Data and save folder -------------------------
if strcmp(DatasetType,'Raw Data')
    SampleRate = Data.Info.NativeSamplingRate;
    SaveDataRaw = double(Data.Raw);
else
    if isfield(Data.Info,'DownsampledSampleRate')
        SampleRate = Data.Info.DownsampledSampleRate;
    else
        SampleRate = Data.Info.NativeSamplingRate;
    end
    SaveDataRaw = double(Data.Preprocessed);
end

folderPath = convertStringsToChars(folderPath);
% Check if the folder exists
dashindex = find(folderPath=='\');
TempfolderPath = folderPath(1:dashindex(end));
if ~exist(TempfolderPath, 'dir')
    mkdir(TempfolderPath);  % Create the folder
    fprintf('Folder created: %s\n', TempfolderPath);
else
    fprintf('Folder already exists: %s\n', TempfolderPath);
end

%% ------------------------- Save Channel Data -------------------------
h = waitbar(0, 'Saving data for SpikeInterface...', 'Name','Saving data for SpikeInterface...');
cN = 100;  % number of chunks
dN = size(SaveDataRaw,2); % total number of samples

% Compute chunk indices safely
chunkEdges = round(linspace(1, dN+1, cN+1));  % 1..dN+1, always works

fidRaw = fopen(folderPath, 'wb');

for chunkIdx = 1:cN
    % Update progress bar
    waitbar(chunkIdx/cN, h, sprintf('Saving data... (%d%% done)', round(100*chunkIdx/cN)));

    % Current chunk
    chunkData = SaveDataRaw(:, chunkEdges(chunkIdx):chunkEdges(chunkIdx+1)-1);

    % Write chunk
    fwrite(fidRaw, chunkData, 'double');
end

fclose(fidRaw);
close(h);

%% ------------------------- Create and Save Meta Data -------------------------

nChannels = size(SaveDataRaw,1);

% create Metadata struc
metadata = struct();
metadata.SampleRate = SampleRate;
metadata.num_channels = size(SaveDataRaw,1);
metadata.dtype = 'float64'; % double in python = float64
metadata.time_axis = 'samples';
metadata.channel_ids = 1:nChannels;
metadata.channel_groups = ones(1,nChannels);
ModifiedPath = Data.Info.Data_Path;
ModifiedPath(find(Data.Info.Data_Path == '\')) = '/';
metadata.Path = ModifiedPath;
metadata.RecordingType = convertStringsToChars(Data.Info.RecordingType);
metadata.ChannelSpacing = Data.Info.ChannelSpacing;
metadata.num_data_points = num2str(Data.Info.num_data_points);
metadata.startTimestamp = Data.Info.startTimestamp;
metadata.Channelorder = Data.Info.Channelorder;
% Probe Info
metadata.NrChannel = Data.Info.ProbeInfo.NrChannel;
metadata.NrRows = Data.Info.ProbeInfo.NrRows;
metadata.VertOffset = Data.Info.ProbeInfo.VertOffset;
metadata.HorOffset = Data.Info.ProbeInfo.HorOffset;
metadata.ActiveChannel = Data.Info.ProbeInfo.ActiveChannel ;

metadata.SwitchTopBottomChannel = Data.Info.ProbeInfo.SwitchTopBottomChannel;
metadata.SwitchLeftRightChannel = Data.Info.ProbeInfo.SwitchLeftRightChannel;
metadata.FlipLoadedData = Data.Info.ProbeInfo.FlipLoadedData;

metadata.OffSetRows = Data.Info.ProbeInfo.OffSetRows;
metadata.OffSetRowsDistance = Data.Info.ProbeInfo.OffSetRowsDistance;

if isfield(Data.Info.ProbeInfo,'CompleteAreaNames')
    metadata.CompleteAreaNames = Data.Info.ProbeInfo.CompleteAreaNames;
    metadata.ShortAreaNames = Data.Info.ProbeInfo.ShortAreaNames;
    metadata.AreaDistanceFromTip = Data.Info.ProbeInfo.AreaDistanceFromTip;
end

if SaveEvents
    if isfield(Data,'Events')
        % Create a cell array instead of struct array
        EventStructCell = cell(1,numel(Data.Events));
        for nevents = 1:numel(Data.Events)
            EventStructCell{nevents} = struct(...
                'event_channel_name', Data.Info.EventChannelNames{nevents}, ...
                'times', Data.Events{nevents} ...
            );
        end
        metadata.EventStruct = EventStructCell;  % save as cell array
        disp("Event data was added to the Meta_Data.json file!")
    else
        disp("No event data was found to add to .json file!")
    end
end

% actually save metadata
MetaDataPath = strcat(filepath,'/Meta_Data.json');
fid = fopen(MetaDataPath,'w');
fprintf(fid, jsonencode(metadata));
fclose(fid);

%% ------------------------- Create and Save Probe Data -------------------------

Probe = Manage_Dataset_SavedData_ExportProbeToJSON(Data);

json_text = jsonencode(Probe);
ProbeDataPath = strcat(filepath,'/probe.json');
fid = fopen(ProbeDataPath,'w');
fwrite(fid, json_text, 'char');
fclose(fid);