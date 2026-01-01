function [Data,HeaderInfo,SampleRate,RecordingType] = Manage_Dataset_Extract_Intan_Data(Filetype,SelectedFolder,TextArea,TimeAndChannelToExtract)

%________________________________________________________________________________________

%% This is the main function organizing data extraction of Intan data

% This gets called in the
% 'Manage_Dataset_Module_Extract_Raw_Recording_Main' function when Intan is
% identified as the recording system

% Input:
% 1. Filetype: format of intan recording. Either "Intan .dat" or "Intan .rhd"
% 2. SelectedFolder: path as char to folder containing the recording
% 3. TextArea: Textare from app window to display progress -- not used here
% but can be useful in future
% 4. TimeAndChannelToExtract: structure with fields: TimeAndChannelToExtract.TimeToExtract: string, time in seconds (from,to) as comma separated numbers like "0,100" or "0,Inf";
%                                                    TimeAndChannelToExtract.ChannelToExtract = string, comma separated numbers like "1,2,3,4";

% Output: 
% 1. Data: nchannel x ntimespoints single matrix with extracted raw data
% 2. HeaderInfo: structure containing header infos of recording. This get Data.Info later
% 3. SampleRate: Sample Rate as double in Hz
% 4. RecordingType: string, either "IntanDat" OR "IntanRHD", capturing the
% recording format

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Data = [];
num_data_points = [];
texttoshow = "Extracting Data for Intan Recording System";

ChannelToExtract = convertStringsToChars(TimeAndChannelToExtract.ChannelToExtract);

%% Extract .dat Files

disp(strcat("Extracting ", Filetype," files"));

if strcmp(Filetype,"Intan .dat")

    OneFilePerSignalTypeFormat = 0;

    % Load dat file locations
    [DatFilePaths,AmplifierDataIndex,~,~,InfoRhd,~] = CheckIntanDatFiles(SelectedFolder);

    if isscalar(AmplifierDataIndex)
        dashindex = strfind(DatFilePaths{AmplifierDataIndex},'\');
        filename = DatFilePaths{AmplifierDataIndex}(dashindex(end)+1:end);
    
        if contains(filename,'amplifier')
            OneFilePerSignalTypeFormat = 1;
        end
    end

    if isempty(InfoRhd)
        disp("Currently analysed folder is supposed to contain Intan data which was not found! Skipping")
        Data = [];
        HeaderInfo = [];
        SampleRate = [];
        RecordingType = [];
        return;
    end
    
    % Load Rhd Info file
    [~,~,frequency_parameters,~,~,~,~,~] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"NoExtracting",[]);
 
    h = waitbar(0, 'Extracting Data...', 'Name','Extracting Data...');
    
    %% If new rhx format 'One File Per Signal Type'
    if OneFilePerSignalTypeFormat == 1
        
        if strcmp(ChannelToExtract,"All")
            numchannel = frequency_parameters.num_amplifier_channels;
            AllChannelInFile = numchannel;
            IndividualChannel = 1:numchannel;
        else
            
            AllChannelInFile = frequency_parameters.num_amplifier_channels; % just to extract data properly from file
            if contains(ChannelToExtract,']') || contains(ChannelToExtract,'[')
                ChannelToExtract(find(ChannelToExtract==']')) = [];
                ChannelToExtract(find(ChannelToExtract=='[')) = [];
            end
            IndividualChannel = str2double(strsplit(ChannelToExtract,','));
            numchannel = length(IndividualChannel);
        end

        mmf = memmapfile(DatFilePaths{AmplifierDataIndex(1)}, 'Format', 'int16');

        Numdatapointsperchannel = size(mmf.Data,1)/AllChannelInFile;
        Data = zeros(numchannel,Numdatapointsperchannel);
        
        % generate starts (1, 1+step, 1+2*step, ...)
        ChunkStart = (0:AllChannelInFile-1) * Numdatapointsperchannel + 1;
        % ends = starts + step - 1 (same length as ChunkStart)
        ChunkEnd = ChunkStart + Numdatapointsperchannel - 1;

        DataChannel = 1;
        JustExecuteOnes = 0;

        for nchan = 1:AllChannelInFile % Loop through all .dat files found
            
            % if current channel iteration that is loaded 
            if ~ismember(nchan,IndividualChannel)
                fraction = nchan/AllChannelInFile;
                msg = sprintf('Extracting Data... (%d%% done)', round(100*fraction));
                waitbar(fraction, h, msg);
                continue
            else
                if DataChannel == 1
                    JustExecuteOnes = 1;
                end
            end

            % Update the progress bar
            fraction = nchan/AllChannelInFile;
            msg = sprintf('Extracting Data... (%d%% done)', round(100*fraction));
            waitbar(fraction, h, msg);
    
            disp(strcat("Extracting Channel ",num2str(nchan)));
    
            texttoshow = [texttoshow;strcat("Extracting Channel ",num2str(nchan))];
            TextArea = texttoshow;
    
            pause(0.05);
            
            if nchan == 1 || JustExecuteOnes == 1 % First channel: Define additional stuff

                TrueChannel = IndividualChannel(nchan);

                Data(DataChannel,1:Numdatapointsperchannel) = (single(mmf.Data(ChunkStart(TrueChannel):ChunkEnd(TrueChannel)))); % in mV
                
                Data(DataChannel,1:Numdatapointsperchannel) = 0.195 * (Data(DataChannel,1:Numdatapointsperchannel) - 32768);
                
                DataChannel = DataChannel + 1;
                
                if size(Data,1) == 0 || isempty(Data)
                    msgbox("No amplifier channel data found! Data extraction cannot be finished.");
                    TextArea = "No amplifier channel data found! Data extraction cannot be finished.";
                    Data = [];
                    HeaderInfo = [];
                    SampleRate = [];
                    RecordingType = [];
                    return;
                end
    
                % Extract General Information about Digital Inputs
                HeaderInfo = frequency_parameters;
                
                % Create Time vector based on nr of samples and sampling rate
                SampleRate = HeaderInfo.amplifier_sample_rate;
    
            else % if second to last channel just extract data
                
                Data(DataChannel,1:Numdatapointsperchannel) = (single(mmf.Data(ChunkStart(TrueChannel):ChunkEnd(TrueChannel)))); % in mV
                
                Data(DataChannel,1:Numdatapointsperchannel) = 0.195 * (Data(DataChannel,1:Numdatapointsperchannel) - 32768);
                DataChannel = DataChannel + 1;
     
            end
            JustExecuteOnes = 0;
        end

    %% If One file per channel format selected
    else

        if strcmp(ChannelToExtract,"All")
            numchannel = frequency_parameters.num_amplifier_channels;
            AllChannelInFile = numchannel;
            IndividualChannel = 1:numchannel;
        else
            numchannel = length(str2double(strsplit(ChannelToExtract,',')));
            AllChannelInFile = frequency_parameters.num_amplifier_channels; % just to extract data properly from file
            
            ChannelToExtract = convertStringsToChars(ChannelToExtract);
            if contains(ChannelToExtract,']') || contains(ChannelToExtract,'[')
                ChannelToExtract(find(ChannelToExtract==']')) = [];
                ChannelToExtract(find(ChannelToExtract=='[')) = [];
            end

            IndividualChannel = str2double(strsplit(ChannelToExtract,','));
        end
        
        % Predefine Values
        mmf = memmapfile(DatFilePaths{AmplifierDataIndex(1)}, 'Format', 'int16');
        Data = zeros(numchannel,size(mmf.Data,1));
        num_data_points = size(Data,2);
        % Extract General Information about Digital Inputs
        HeaderInfo = frequency_parameters;
        
        % Create Time vector based on nr of samples and sampling rate
        SampleRate = HeaderInfo.amplifier_sample_rate;
        
        DataChannel = 1;

        for nchan = 1:length(AmplifierDataIndex) % Loop through all .dat files found
            % if current channel iteration that is loaded 
            if ~ismember(nchan,IndividualChannel)
                fraction = nchan/AllChannelInFile;
                msg = sprintf('Extracting Data... (%d%% done)', round(100*fraction));
                waitbar(fraction, h, msg);
                continue
            end
            
            % Update the progress bar
            fraction = nchan/AllChannelInFile;
            msg = sprintf('Extracting Data... (%d%% done)', round(100*fraction));
            waitbar(fraction, h, msg);
    
            disp(strcat("Extracting Channel ",num2str(nchan)));
    
            texttoshow = [texttoshow;strcat("Extracting Channel ",num2str(nchan))];
            TextArea = texttoshow;
    
            pause(0.05);
    
            if ~isempty(mmf) % First channel: No need to load in again
                Data(DataChannel,1:end) = (single(mmf.Data).*0.000195)'; % in mV            
                if size(Data,1) == 0 || isempty(Data)
                    msgbox("No Amplifier Channel Data found! Data Extraction cannot be finished.");
                    TextArea = "No Amplifier Channel Data found! Data Extraction cannot be finished.";
                    Data = [];
                    HeaderInfo = [];
                    SampleRate = [];
                    RecordingType = [];
                    return;
                end
                DataChannel = DataChannel+1;

            else % if second to last channel just extract data
                mmf = memmapfile(DatFilePaths{AmplifierDataIndex(nchan)}, 'Format', 'int16');
                Data(DataChannel,1:num_data_points) = (single(mmf.Data).*0.000195)'; % in mV    
                DataChannel = DataChannel+1;
            end
            mmf = [];
        end
    end

    close(h);
 
end

%% Extract .rhd files
if strcmp(Filetype,"Intan .rhd")
        
    texttoshow = [texttoshow;"Extracting Single RHD File. See progress in Matlab command window"];
    TextArea = texttoshow;
    
    % Get number of rhd files in folder and paths
    
    [RhdFilePaths] = LoadIntanRHDFiles(SelectedFolder);
    numFiles = length(RhdFilePaths);

    if numFiles == 1
        Numiters = 1;
        disp("Just one RHD file found.")
    else
        Numiters = numFiles;
        warning("Multiple RHD files found in folder. They are concatonated together assuming they are part of the same recording.")
    end

    %% Loop over rhd files
    for nrhdfiles = 1:Numiters
        
        CurrentFolder = convertStringsToChars(RhdFilePaths(nrhdfiles));
        LastDashIndex = find(CurrentFolder == '\');

        if ~isempty(LastDashIndex)
            RHDPath = CurrentFolder(1:LastDashIndex(end));
            RHDFiles = CurrentFolder(LastDashIndex(end)+1:end);
        else
            msgbox("Error: No .rhd file found in selected folder!")
            Data = [];
            HeaderInfo = [];
            SampleRate = [];
            RecordingType = [];
            return;
        end
        
        [amplifier_data,~,frequency_parameters,~,~,~,~,~] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",TextArea);
        
        if Numiters == 1
            if size(amplifier_data,1) == 0 || isempty(amplifier_data)
                msgbox("No Amplifier Channel Data found! Data Extraction cannot be finished.");
                TextArea = "No Amplifier Channel Data found! Data Extraction cannot be finished.";
                Data = [];
                HeaderInfo = [];
                SampleRate = [];
                RecordingType = [];
                return;
            end
        end
        % Extract General Information about Digital Inputs
        
        if Numiters == 1
            Data = single(amplifier_data);
            num_data_points = size(Data,2);
        else
            Data = [Data,single(amplifier_data)];
        end
    
        % Extract General Information about Digital Inputs
        HeaderInfo = frequency_parameters;
        
        % Create Time vector based on nr of samples and sampling rate
        SampleRate = HeaderInfo.amplifier_sample_rate;

    end
    
    if Numiters > 1
        num_data_points = size(Data,2);
    end
end

if strcmp(Filetype,"Intan .dat")
    RecordingType = "IntanDat";
elseif strcmp(Filetype,"Intan .rhd")
    RecordingType = "IntanRHD";
end

