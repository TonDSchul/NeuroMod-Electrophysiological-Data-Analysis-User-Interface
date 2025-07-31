function [Data,SampleRate,HeaderInfo,RecordingType,Time] = Manage_Dataset_Load_NEO_RawData_Save_Files(NeoSaveFolder)

%% first load .mat file
load(strcat(NeoSaveFolder,'/NeoRawData/NEO_Saved_MetaData.mat'))

HeaderInfo.NeoSaveFolder = NeoSaveFolder;
%HeaderInfo.FileType = RecordingFormat;

RecordingType = "NEO";
%% Now load .dat file
NeoDATSaveFolder = strcat(NeoSaveFolder,'/NeoRawData/NEO_Saved_Channel_Data.dat');
fid = fopen(NeoDATSaveFolder, 'rb');
Data = fread(fid, [n_channels, Inf], 'float32');  % read as float32, reshape to channels x samples
fclose(fid);

SampleRate = sampling_rate;
Time = 0:1/SampleRate:(size(Data,2)-1)*1/SampleRate;