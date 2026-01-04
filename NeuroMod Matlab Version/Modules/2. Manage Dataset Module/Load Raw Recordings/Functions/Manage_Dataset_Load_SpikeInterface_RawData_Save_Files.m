function [Data,SampleRate,HeaderInfo,RecordingType,Time,texttoshow] = Manage_Dataset_Load_SpikeInterface_RawData_Save_Files(SISaveFolder,TimeAndChannelToExtract)

%________________________________________________________________________________________

%% function load the files that are saved automatically when extracting a recording with SpikeInterface

% This gets called after the python scriupt extracting the recording
% finished. In this script, a .dat file is saved with all channel data, a
% .mat file with metadata and a .txt file with logger information about the
% extraction process
% The python script auto creates a folder in the same directory as the
% recording folder is in called "RecordingFolder SpikeInterface SaveFile" where
% RecordingFolder is the name of the recording folder

% Input:
% 1. SISaveFolder: char, recording location selected by the user when
% extracting data

% Output: 
% 1. Data: nchannel x ntimespoints single matrix with extracted raw data
% 2. SampleRate: Sample Rate as double in Hz
% 3. HeaderInfo: structure containing header infos of recording. This get Data.Info later
% 4. RecordingType: string, either "IntanDat" OR "IntanRHD", capturing the
% recording format
% 5. Time: 1 x nsamples vector with time for each sample in seconds
% 6. texttoshow: char, Logger.txt contents to show them in the window text
% area as information


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% ------------------------------ Get file locations of automatic save locations ------------------------------

dashindice = find(SISaveFolder == '\');
Foldername = SISaveFolder(dashindice(end)+1:end);
ModifiedSaveFile = strcat(SISaveFolder(1:dashindice(end)),Foldername," Neo SaveFile");
texttoshow = [];

if ~isfolder(ModifiedSaveFile)
    warning(convertStringsToChars(strcat("SpikeInterface output folder could not be found! After succesfull data extraction with SpikeInterface, data is saved in folder: ",ModifiedSaveFile)))
    Data = [];
    SampleRate = [];
    HeaderInfo = [];
    RecordingType = [];
    Time = [];
    texttoshow = strcat("SpikeInterface output folder could not be found! After succesfull data extraction with SpikeInterface, data is saved in folder: ",ModifiedSaveFile);
    return;
end

MetadataLocation = strcat(ModifiedSaveFile,'\SI_Saved_MetaData.mat');
DatLocation = strcat(ModifiedSaveFile,'\SI_Saved_Channel_Data.dat');

%% ------------------------------ Load Metadata ------------------------------
    try
        load(MetadataLocation)
    catch
        warning("SI_Saved_MetaData.mat file could not be openend. Make sure it is in the standard directory 'RecordingName + SpikeInterface SaveFile/SI_Saved_MetaData.mat'!")
        Data = [];
        SampleRate = [];
        HeaderInfo = [];
        RecordingType = [];
        Time = [];
        if ~isempty(texttoshow)
            texttoshow = ["SI_Saved_MetaData.mat file could not be openend. Make sure it is in the standard directory 'RecordingName + SpikeInterface SaveFile/SI_Saved_MetaData.mat'!";"";texttoshow];
        else
            texttoshow = ["SI_Saved_MetaData.mat file could not be openend. Make sure it is in the standard directory 'RecordingName + SpikeInterface SaveFile/SI_Saved_MetaData.mat'!";""];
        end

        return;
    end

    HeaderInfo.NeoSaveFolder = SISaveFolder;
    HeaderInfo.FileType = "Maxwell MEA .h5";
    HeaderInfo.MEACoords = channel_locations;
    HeaderInfo.ChannelIDS = str2double(string(channel_ids));
    
    RecordingType = "SpikeInterface Maxwell MEA .h5";
    Time = 0:1/sampling_rate:(double(n_samples)-1)*(1/sampling_rate);
    SampleRate = sampling_rate;

    texttoshow = "Loaded metadata from Maxwell MEA .h5 recording.";

%% ------------------------------ Load Channel Data ------------------------------

if exist('acqu_start_samples','var')
    HeaderInfo.startTimestamp = acqu_start_samples;
else
    HeaderInfo.startTimestamp = 1;
end

%% ------------------------------ Costum GUI files ------------------------------
h = waitbar(0, 'Preparing Data to load...', 'Name','Preparing Data to load...');
msg = sprintf('Preparing Data to load... (%d%% done)', 25);
waitbar(25, h, msg);

nchan = double(n_channels);
ntime = double(n_samples);

FileIdentifier = fopen(DatLocation,'r');

if FileIdentifier == -1
    warning("SI_Saved_Channel_Data.dat file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/SI_Saved_Channel_Data.dat'!")
    Data = [];
    SampleRate = [];
    HeaderInfo = [];
    RecordingType = [];
    Time = [];
    return;
end

msg = sprintf('Loading Data... (%d%% done)', 50);
waitbar(50, h, msg);
    
dN = ntime;

% mmf = memmapfile(DatLocation, ...
%     'Format', {'single', [nchan, ntime], 'x'});

mmf = memmapfile(DatLocation, ...
    'Format', {'single', [nchan, ntime], 'x'});

Data = mmf.Data.x(1:nchan,1:ntime);    

fclose(FileIdentifier);
    
% assure channel by time
if size(Data,1)>size(Data,2)
    Data = Data';
end

texttoshow = [texttoshow;"";"Loaded channeld data from Maxwell MEA .h5 recording."];

%% Convert in mV depending on unit 
if exist('units',"var")
    if strcmp(units(1,:),'uV')
        Data = single(Data) / 1000; % in mv
        disp("Loaded data converted from uV to mV.")
    elseif strcmp(units(1,:),'mV')
        Data = single(Data) * 1;
        disp("Loaded data already in mV.")
    elseif strcmp(units(1,:),'V')
        Data = single(Data) * 1000;
        disp("Loaded data converted from V to mV.")
    else
        Data = single(Data);
        warning("Metadata does not contain the units of the recording data (mV,V or uV) to convert to mV. Data is not scaled automatically and may not be in mV!")
    end
else
    Data = single(Data);
    warning("Metadata does not contain the units of the recording data (mV,V or uV) to convert to mV. Data is not scaled automatically and may not be in mV!")
end

HeaderInfo.TimeAndChannelToExtract = TimeAndChannelToExtract;

msg = sprintf('Loading Data... (%d%% done)', 100);
waitbar(100, h, msg);

close(h);


