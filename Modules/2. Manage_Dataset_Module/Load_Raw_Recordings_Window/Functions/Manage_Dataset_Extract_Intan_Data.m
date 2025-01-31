function [Data,HeaderInfo,SampleRate,RecordingType] = Manage_Dataset_Extract_Intan_Data(Filetype,SelectedFolder,TextArea)

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

%% Extract .dat Files

disp(strcat("Extracting ", Filetype," files"));

if strcmp(Filetype,"Intan .dat")
    % Load dat file locations
    [DatFilePaths,AmplifierDataIndex,~,~,InfoRhd,~] = CheckIntanDatFiles(SelectedFolder);
    % Load Rhd Info file
    [~,~,frequency_parameters,~,~,~,~,~] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"NoExtracting",[]);
 
    h = waitbar(0, 'Extracting Data...', 'Name','Extracting Data...');
    cN = length(AmplifierDataIndex);  % number of steps/chunks

    for nchan = 1:length(AmplifierDataIndex) % Loop through all .dat files found

       % Update the progress bar
       fraction = nchan/cN;
       msg = sprintf('Extracting Data... (%d%% done)', round(100*fraction));
       waitbar(fraction, h, msg);

        disp(strcat("Extracting Channel ",num2str(nchan)));

        texttoshow = [texttoshow;strcat("Extracting Channel ",num2str(nchan))];
        TextArea = texttoshow;

        pause(0.05);

        if nchan == 1 % First channel: Define additional stuff
           
            mmf = memmapfile(DatFilePaths{AmplifierDataIndex(nchan)}, 'Format', 'int16');

            Data = zeros(length(AmplifierDataIndex),size(mmf.Data,1));

            Data(nchan,1:end) = (single(mmf.Data).*0.000195)'; % in mV
            
            num_data_points = size(Data,2);
            
            if size(Data,1) == 0 || isempty(Data)
                msgbox("No Amplifier Channel Data found! Data Extraction cannot be finished.");
                TextArea = "No Amplifier Channel Data found! Data Extraction cannot be finished.";
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
            
            mmf = memmapfile(DatFilePaths{AmplifierDataIndex(nchan)}, 'Format', 'int16');
            Data(nchan,1:num_data_points) = mmf.Data';
            Data(nchan,1:num_data_points) = single(Data(nchan,1:num_data_points)).*0.000195; % in mV
 
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
        
        [amplifier_data,~,frequency_parameters,~,~,t_dig,~,~] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",TextArea);
        
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

