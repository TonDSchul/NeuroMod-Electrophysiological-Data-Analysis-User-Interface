function [Data,HeaderInfo,SampleRate,RecordingType] = Manage_Dataset_Extract_SpikeGLX(SelectedFolder,SelectedTimeandChannel)

%________________________________________________________________________________________

%% This is the main function handling extracting data recorded with SpikeGLX
% function uses the SpikeGLX_Datafile_Tools githib repo from https://github.com/jenniferColonell/SpikeGLX_Datafile_Tools
% to get the raw data traces as well as bit to mV conversion factors

% This gets called in the
% 'Manage_Dataset_Module_Extract_Raw_Recording_Main' function

% Input:
% 1. SelectedFolder: path as char to folder containing the recording
% 2. SelectedTimeandChannel: structure with fields: SelectedTimeandChannel.TimeToExtract: string, time in seconds (from,to) as comma separated numbers like "0,100" or "0,Inf";
%                                                    SelectedTimeandChannel.ChannelToExtract = string, comma separated numbers like "1,2,3,4";


% Output: 
% 1. Data: nchannel x ntimespoints single matrix with extracted raw data
% 2. HeaderInfo: structure containing header infos of recording. This get TempData.Info later
% 3. SampleRate: Sample Rate as double in Hz
% 4. RecordingType: char designating recording system used

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

[stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);

APBinIndicies = [];
LPBinIndicies = [];
for i = 1:length(stringArray)
    if endsWith(stringArray(i),'.bin') && contains(stringArray(i),'.ap')
        APBinIndicies = [APBinIndicies,i];
    elseif endsWith(stringArray(i),'.bin') && contains(stringArray(i),'.lf')
        LPBinIndicies = [LPBinIndicies,i];
    end
end

if length(APBinIndicies) > 1 || length(LPBinIndicies) > 1
   msgbox("More than one .bin file containg ap or lf found! Please make sure the selected folder only contains a single recording!");
   error("More than one .bin file containg ap or lf found! Please make sure the selected folder only contains a single recording!");
end

if ~isempty(APBinIndicies) && isempty(LPBinIndicies)
    streamIndex = 2;
elseif isempty(APBinIndicies) && ~isempty(LPBinIndicies)
    streamIndex = 1;
elseif isempty(APBinIndicies) && isempty(LPBinIndicies)
    msgbox("Neither .bin file containing ap nor .bin file containing lf was found. Please make sure you selected to correct folder and recording names contain ap or lf.")
    error("Neither .bin file containing ap nor .bin file containing lf was found. Please make sure you selected to correct folder and recording names contain ap or lf.")
elseif ~isempty(APBinIndicies) && ~isempty(LPBinIndicies)
    SpikeGLXRecordings = Neuropixels1_LFP_or_AP(1);

    uiwait(SpikeGLXRecordings.NPDataTypeUIFigure);
    
    if isvalid(SpikeGLXRecordings)
        streamIndex = SpikeGLXRecordings.SelectedRecordings; % == 1 if LFP data selected, == 2 if AP data selected
        delete(SpikeGLXRecordings);
    else
        disp("Error: Selection of either AP or LFP data failed. LFP data is exctracted by default. Rename 'SelectedStream' variable in Open_Ephys_Load_All_Formats.m")
        streamIndex = 1; % == 1 if LFP data selected, == 2 if AP data selected
    end
end

if streamIndex== 1 %LFP
    FileName = stringArray(LPBinIndicies);
else
    FileName = stringArray(APBinIndicies);
end

HeaderInfo = SGLX_readMeta.ReadMeta(FileName, SelectedFolder);

SampleRate = SGLX_readMeta.SampRate(HeaderInfo);

SelectedTimeandChannel.TimeToExtract = string(strsplit(SelectedTimeandChannel.TimeToExtract,','));
DataTimeToExtract(1) = round(str2double(SelectedTimeandChannel.TimeToExtract(1)) * SampleRate);

if strcmp(SelectedTimeandChannel.TimeToExtract(2),"Inf")
    DataTimeToExtract(2) = SelectedTimeandChannel.TimeToExtract(2);
else
    DataTimeToExtract(2) = round(str2double(SelectedTimeandChannel.TimeToExtract(2)) * SampleRate);
end

nSamp = (DataTimeToExtract(2) - DataTimeToExtract(1))-1;
Data = SGLX_readMeta.ReadBin(DataTimeToExtract(1), nSamp, HeaderInfo,FileName, SelectedFolder);

% convert into mV
chans = SGLX_readMeta.OriginalChans(HeaderInfo);

fI2V = SGLX_readMeta.Int2Volts(HeaderInfo);
[APgain,LFgain] = SGLX_readMeta.ChanGainsIM(HeaderInfo);

if streamIndex== 1 %LFP
    try
        for kk = 1:length(LFgain)
            Data(kk,:) = single(Data(kk,:) * fI2V / LFgain(chans(kk))) *1000; % V in mV
        end
    catch
        Data = single(Data * fI2V / LFgain(1)) *1000; % V in mV
    end
else
    try
        for kk = 1:length(APgain)
            Data(kk,:) = single(Data(kk,:) * fI2V / APgain(chans(kk))) *1000; % V in mV
        end
    catch
        Data = single(Data * fI2V / APgain(1)) *1000; % V in mV
    end
end

% now get rid of reference channel
if isfield(HeaderInfo,'snsApLfSy')
    commaindicie = find(HeaderInfo.snsApLfSy==',');
    if ~isempty(commaindicie)
        referenchannel = str2double(HeaderInfo.snsApLfSy(commaindicie(end)+1:end));
        Data(referenchannel,:) = [];
        disp("Delete reference channel from dataset.");
    else
        warning("Could not read reference channel! It cannot be deleted from the dataset, so there will be one additional channel.");
    end
else
    disp("No info about reference channel found.");
end


RecordingType = "SpikeGLX NP";