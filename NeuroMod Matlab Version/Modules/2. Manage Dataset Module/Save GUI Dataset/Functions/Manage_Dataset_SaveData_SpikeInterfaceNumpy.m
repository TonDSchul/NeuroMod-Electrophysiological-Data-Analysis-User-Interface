function folderPath = Manage_Dataset_SaveData_SpikeInterfaceNumpy(Data,DatasetType,SaveEvents,Autorun,FolderToSave)

%________________________________________________________________________________________

%% This function saves NeuroMod data as a spikeinterface compatible numpy object 

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. DatasetType: char, either "Raw Data" or "Preprocessed Data"
% 3. SaveEvents: double 1 or 0 whether to save event data if present
% 4. Autorun: 1 or 0 whether executed in NeuroMod (0) or in batch autorun
% analysis(0)
% 5. FolderToSave: folder to save NEO compatible file in


% Output: 
% 1. folderPath: char, path the user selected to save in

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% ------------------------- Select folder and file to save -------------------------

if Autorun == "No" || Autorun == "SingleFolder"
    [filename, filepath] = uiputfile('*.bin', 'Save File');
    
    % Check if the user canceled the operation
    if isequal(filename,0) || isequal(filepath,0)
        disp('User canceled the operation.');
        return;
    end
    
    folderPath = fullfile(filepath, filename);
else
    if isstring(FolderToSave)
        FolderToSave = convertStringsToChars(FolderToSave);
    end
    dashindex = find(FolderToSave=='\');
    filepath = convertStringsToChars(strcat(FolderToSave,'\'));
    filename = convertStringsToChars(strcat("SpikeInterface_",FolderToSave(dashindex(end-2)+1:dashindex(end-1)-1),".bin"));
    
    folderPath = fullfile(filepath,filename);
end

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
metadata.Info = Data.Info;

metadata.Info.Data_Path = strrep(metadata.Info.Data_Path, '\', '/');

ModifiedPath = Data.Info.Data_Path;
ModifiedPath(find(Data.Info.Data_Path == '\')) = '/';
metadata.Path = ModifiedPath;
metadata.Info.DataType = DatasetType;

metadata = Manage_Dataset_SaveData_Reset_Slashes(metadata);

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
MetaDataPath = strcat(filepath,'/',filename(1:end-4),'_Meta_Data.json');
fid = fopen(MetaDataPath,'w');
fprintf(fid, jsonencode(metadata));
fclose(fid);

%% ------------------------- Create and Save Probe Data -------------------------

Probe = Manage_Dataset_SavedData_ExportProbeToJSON(Data);

json_text = jsonencode(Probe);
ProbeDataPath = strcat(filepath,'/',filename(1:end-4),'_probe.json');
fid = fopen(ProbeDataPath,'w');
fwrite(fid, json_text, 'char');
fclose(fid);