function [Data,SampleRate,HeaderInfo,RecordingType,Time,texttoshow] = Manage_Dataset_Load_NEO_RawData_Save_Files(NeoSaveFolder,RecordingType,FormatToSaveNEOIn,TimeAndChannelToExtract)

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
% 3. FormatToSaveNEOIn: char, gives info how NEO saved data and how to load
% it, either "Custom files (.dat,.mat)" OR "NEO Format to .mat Conversion"
% 4. TimeAndChannelToExtract: structure with fields: TimeAndChannelToExtract.TimeToExtract: string, time in seconds (from,to) as comma separated numbers like "0,100" or "0,Inf";
% 

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
    if iscell(NeoSaveFolder)
        dashindex = find(NeoSaveFolder{1}=='\');
        Path = NeoSaveFolder{1}(1:dashindex(end)-1);
        ModifiedSaveFile = strcat(Path," Neo SaveFile");
    else
        ModifiedSaveFile = strcat(NeoSaveFolder," Neo SaveFile");
    end
else
    dashindice = find(NeoSaveFolder == '\');
    Foldername = NeoSaveFolder(dashindice(end)+1:end);
    ModifiedSaveFile = strcat(NeoSaveFolder(1:dashindice(end)),Foldername," Neo SaveFile");
end

if ~isfolder(ModifiedSaveFile)
    warning(convertStringsToChars(strcat("NEO Output folder could not be found! After succesfull data extraction with NEO, data is saved in folder: ",ModifiedSaveFile)))
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
MatlabNeoConversionLocation = strcat(ModifiedSaveFile,'\NEOMatlabConversion.mat');

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
if strcmp(FormatToSaveNEOIn,"Custom files (.dat,.mat)")
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
        try
            mmf = memmapfile(DatLocation, ...
                'Format', {'single', [ntime, nchan], 'x'});
            
            Data = mmf.Data.x(1:dN,1:nchan);
        catch
            mmf = memmapfile(DatLocation, ...
                'Format', {'single', [ntime, nchan], 'x'});
    
            Data = mmf.Data(1).x(1:dN, 1:nchan);
        end
        
    else
        mmf = memmapfile(DatLocation, ...
            'Format', {'single', [nchan, ntime], 'x'});
        
        Data = mmf.Data.x(1:nchan,1:dN);    
    end

    fclose(FileIdentifier);
    
else %% ------------------------------ If NEO saved in its Matlab conversion format ------------------------------

%% ------------------------------ Load Neo converted .mat Data ------------------------------
    try
        load(MatlabNeoConversionLocation)
    catch
        warning("NEOMatlabConversion.mat file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/NEOMatlabConversion.mat'!")
        Data = [];
        SampleRate = [];
        HeaderInfo = [];
        RecordingType = [];
        Time = [];
        texttoshow = ["NEOMatlabConversion.mat file could not be openend. Make sure it is in the standard directory 'RecordingName + Neo SaveFile/NEOMatlabConversion.mat'!";"";texttoshow];
        return;
    end

    HeaderInfo.NeoSaveFolder = NeoSaveFolder;
    if ~isempty(DetectedFormat)
        HeaderInfo.FileType = DetectedFormat;
    else
        HeaderInfo.FileType = "Not Defined";
    end
    
    RecordingType = "NEO";
    
    SampleRate = block.segments{1}.analogsignals{1}.sampling_rate;
    [nchan,ntime] = size(block.segments{1}.analogsignals{1}.signal);

    n_samples = max([nchan,ntime]);
    ncahnnel = min([nchan,ntime]);

    Time = 0:1/SampleRate:(double(n_samples)-1)*(1/SampleRate);
    
%% ------------------------------ Load Channel Data ------------------------------
    h = waitbar(0, 'Preparing Data to load...', 'Name','Preparing Data to load...');
    msg = sprintf('Preparing Data to load... (%d%% done)', 25);
    waitbar(25, h, msg);

    msg = sprintf('Preparing Data to load... (%d%% done)', 50);
    waitbar(50, h, msg);
    
    if strcmp(block.segments{1}.analogsignals{1}.t_start_units,'s')
        HeaderInfo.startTimestamp = block.segments{1}.analogsignals{1}.t_start * SampleRate;
    else
        HeaderInfo.startTimestamp = block.segments{1}.analogsignals{1}.t_start;
    end

    Data = block.segments{1}.analogsignals{1}.signal;

    msg = sprintf('Preparing Data to load... (%d%% done)', 75);
    waitbar(75, h, msg);

end

% assure channel by time
if size(Data,1)>size(Data,2)
    Data = Data';
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

%% Add time and channel to extract to header info
HeaderInfo.TimeAndChannelToExtract = TimeAndChannelToExtract;


close(h);


