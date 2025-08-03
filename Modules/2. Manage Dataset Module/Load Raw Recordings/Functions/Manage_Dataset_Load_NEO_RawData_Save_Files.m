function [Data,SampleRate,HeaderInfo,RecordingType,Time,texttoshow] = Manage_Dataset_Load_NEO_RawData_Save_Files(NeoSaveFolder,RecordingType)

%________________________________________________________________________________________

%% function load the files that are saved automatically when extracting a recording with NEO

% This gets called after the python scriupt extracting the recording
% finished. In this script, a .dat file is saved with all channel data, a
% .mat file with metadata and a .txt file with logger information about the
% extraction process
% The python script auto creates a folder in the same directory as the
% recording folder is in called "RecordingFolder Neo SaveFile" where
% RecordingFolder is the name of the recording folder

% Input:
% 1. NeoSaveFolder: char, recording location selected by the user when
% extracting data
% 2. RecordingType: char, data format selected when extracting data with
% neo

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

if strcmp(RecordingType,"Plexon") || strcmp(RecordingType,"Blackrock") || strcmp(RecordingType,"NeuroExplorer")
    ModifiedSaveFile = strcat(NeoSaveFolder," Neo SaveFile");
else
    dashindice = find(NeoSaveFolder == '\');
    Foldername = NeoSaveFolder(dashindice(end)+1:end);
    ModifiedSaveFile = strcat(NeoSaveFolder(1:dashindice(end)),Foldername," Neo SaveFile");
end

if ~isfolder(ModifiedSaveFile)
    warning(strcat("NEO Output folder could not be found! After succesfull data extraction with NEO, data is saved in folder: ",ModifiedSaveFile))
    Data = [];
    SampleRate = [];
    HeaderInfo = [];
    RecordingType = [];
    Time = [];
    texttoshow = strcat("NEO Output folder could not be found! After succesfull data extraction with NEO, data is saved in folder: ",ModifiedSaveFile);
    return;
end

MetadataLocation = strcat(ModifiedSaveFile,'\NEO_Saved_MetaData.mat');
LoggerLocation = strcat(ModifiedSaveFile,'\Logger.txt');
DatLocation = strcat(ModifiedSaveFile,'\NEO_Saved_Channel_Data.dat');

%% ------------------------------ Load Logger Data ------------------------------

if isfile(LoggerLocation)
    fid = fopen(LoggerLocation, 'r');
else
    warning("Error: Logger.txt file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/Logger.txt'!")
    Data = [];
    SampleRate = [];
    HeaderInfo = [];
    RecordingType = [];
    Time = [];
    texttoshow = "Error: Logger.txt file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/Logger.txt'!";
    return;
end
line = fgetl(fid);

SuccesfulLastLogger = 0;
DetectedFormat = [];
DetectedMethod = [];
texttoshow = strings;

texttoshow(1) = "Data logger content from NEO python script: ";

while ischar(line)
    
    texttoshow = [texttoshow;line];

    if contains(line,'Finished')
        SuccesfulLastLogger = 1;
    end
    if contains(line,'class:')
        doubleindex = strfind(line,':');
        DetectedFormat = line(doubleindex+1:end);
    end
    if contains(line,'Method')
        doubleindex = strfind(line,':');
        DetectedMethod = line(doubleindex+1:end);
    end

    line = fgetl(fid);
end

fclose(fid);

if SuccesfulLastLogger == 0
    warning("Neo Data Extraction was not succesfull! Returning.")
    Data = [];
    SampleRate = [];
    HeaderInfo = [];
    RecordingType = [];
    Time = [];
    return;
end

%% ------------------------------ Load Metadata ------------------------------
try
    load(MetadataLocation)
catch
    warning("NEO_Saved_MetaData.mat file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/NEO_Saved_MetaData.mat'!")
    Data = [];
    SampleRate = [];
    HeaderInfo = [];
    RecordingType = [];
    Time = [];
    texttoshow = ["NEO_Saved_MetaData.mat file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/NEO_Saved_MetaData.mat'!";"";texttoshow];
    return;
end
% load channel data
HeaderInfo.NeoSaveFolder = NeoSaveFolder;
if ~isempty(DetectedFormat)
    HeaderInfo.FileType = DetectedFormat;
else
    HeaderInfo.FileType = "Not Defined";
end

RecordingType = "NEO";
Time = 0:1/sampling_rate:(double(n_samples)-1)*(1/sampling_rate);
SampleRate = sampling_rate;

%% ------------------------------ Load Channel Data ------------------------------
h = waitbar(0, 'Preparing Data to load...', 'Name','Preparing Data to load...');
msg = sprintf('Preparing Data to Save... (%d%% done)', 25);
waitbar(25, h, msg);

nchan = double(n_channels);
ntime = double(n_samples);

FileIdentifier = fopen(DatLocation,'r');

if FileIdentifier == -1
    warning("NEO_Saved_Channel_Data.dat file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/NEO_Saved_Channel_Data.dat'!")
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

if isempty(DetectedMethod)
    DetectedMethod = 1;
else
    DetectedMethod = str2double(DetectedMethod);
end

if DetectedMethod == 1
    mmf = memmapfile(DatLocation, ...
        'Format', {'single', [ntime, nchan], 'x'});
    
    Data = mmf.Data.x(1:dN,1:nchan);
    Data = Data';
else
    mmf = memmapfile(DatLocation, ...
        'Format', {'single', [nchan, ntime], 'x'});
    
    Data = mmf.Data.x(1:nchan,1:dN);
end

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

msg = sprintf('Loading Data... (%d%% done)', 100);
waitbar(100, h, msg);

fclose(FileIdentifier);
close(h);


