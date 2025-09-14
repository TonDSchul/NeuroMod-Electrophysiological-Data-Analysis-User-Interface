function [Data] = Extract_Events_Module_Extract_Events_Intan(Data,Filetype,InputChannelIndicie,FolderPath,Threshold,InputChannelSelection,RHDAllChannelData,EventInfoType)

%________________________________________________________________________________________
%% Function to coordinate Intan Event Extraction

% This function actually loads event files (.dat files only! .rhd are loaded when gui started to show info about it) and passes 1 x ntime vector of
% event data into Extract_Events_Module_Extract_Event_Indicies_Intan
% function to extract event indicies exceeding a treshold

% gets called in the Extract_Events_Module_Main_Function function when the user starts the event extraction for intan data

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data and
% the info structure.
% 2. FileType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 3. InputChannelIndicie: 1 x n double vector with indicies of event channel (indicies of
% all foldercontents found)
% 4. FolderPath: path to folder holding event recordings as char
% 5. Threshold: double representing threshold for idientifying events -->
% signal has to be >= threshold
% 6. InputChannelSelection: 1 x n vector containing indicies of event channels found for specified type (analog, digital and so on) 
% 7. RHDAllChannelData: NOTE!! ONLY IF .RHD file format analyzed! saves field
% RHDAllChannelData.board_dig_in_data containing event data (NOTE!! as a nevents x ntime matrix), since the file had
% to be loaded earlier already to know what can be shown as otions in the
% GUI. --> not as nicely doable as with individual .dat files for each
% event
% 8. EventInfoType: char, Either 'Event Onset' or 'Event Offset' to
% determine whether rising or falling edge should be detected

% Outputs:
% 1. Data: Data structure with added field:
% Data.Events{1:neventchannelfound} containing a 1 x nevents vector with
% event indicies in samples. Data.Info gets also info about channelnames and InputChannelType

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

Data.Events = [];

if strcmp(Filetype, "Digital Inputs")

    if strcmp(Data.Info.RecordingType,"IntanDat")
        InputChannelData = {};

        [DatFilePaths,~,~,~,~,~] = CheckIntanDatFiles(FolderPath);
        
        for i = 1:length(InputChannelSelection)
            
            FileIdentifier = fopen(DatFilePaths{InputChannelIndicie(InputChannelSelection(i))},'r');
            
            InputChannelData{i} = fread(FileIdentifier, 'int16');

            InputChannelData{i} = single(InputChannelData{i});

        end

        if isfield(Data.Info,'CutStart')
            if ~isempty(Data.Info.CutStart)
                NumSamples = Data.Info.CutStart;
            end
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputChannelData,EventInfoType);

    elseif strcmp(Data.Info.RecordingType,"IntanRHD")

        InputDatatoextract={};
        for i = 1:length(InputChannelSelection)
            InputDatatoextract{i} = RHDAllChannelData.board_dig_in_data(InputChannelSelection(i),:);
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputDatatoextract,EventInfoType);

    end

elseif strcmp(Filetype, "Analog Input")

    if strcmp(Data.Info.RecordingType,"IntanDat")
        % Get board mode and corresponding scaling factors
        RHDFile = strcat(Data.Info.Data_Path,'\info.rhd');
        
        if isfile(RHDFile)
            RhDfid = fopen(RHDFile, 'r');
            if RhDfid ~= -1
                data_file_main_version_number = fread(RhDfid, 1, 'int16');
                data_file_secondary_version_number = fread(RhDfid, 1, 'int16');
            else
                data_file_main_version_number = 0;
                data_file_secondary_version_number = 0;
            end
        
            board_mode = 0;
            if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 3) ...
                || (data_file_main_version_number > 1))
                board_mode = fread(RhDfid, 1, 'int16');
            end
        else
            Warning("No .rhd file found to get board mode. This can lead to unexpected behavior. (Taking standard mode 0)")
            board_mode = 0;
        end

        InputChannelData = cell(1,length(InputChannelSelection));

        [DatFilePaths,~,~,~,~,~] = CheckIntanDatFiles(FolderPath);
        
        for i = 1:length(InputChannelSelection)
            
            FileIdentifier = fopen(DatFilePaths{InputChannelIndicie(InputChannelSelection(i))},'r');
            
            InputChannelData{i} = fread(FileIdentifier, 'int16');
            % Apply scaling
            if (board_mode == 1)
                InputChannelData{i} = 152.59e-6 * (InputChannelData{i}); % units = volts
            elseif (board_mode == 13) % Intan Recording Controller
                InputChannelData{i} = 312.5e-6 * (InputChannelData{i}); % units = volts    
            else
                InputChannelData{i} = 50.354e-6 * InputChannelData{i}; % units = volts
            end
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputChannelData,EventInfoType);

    elseif strcmp(Data.Info.RecordingType,"IntanRHD")
        
        InputDatatoextract={};
        for i = 1:length(InputChannelSelection)
            InputDatatoextract{i} = RHDAllChannelData.board_adc_data(InputChannelSelection(i),:);
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputDatatoextract,EventInfoType);

    end
elseif strcmp(Filetype, "AUX Inputs")

    if strcmp(Data.Info.RecordingType,"IntanDat")

        InputChannelData = {};

        [DatFilePaths,~,~,~,~,~] = CheckIntanDatFiles(FolderPath);
        
        for i = 1:length(InputChannelSelection)
            
            FileIdentifier = fopen(DatFilePaths{InputChannelIndicie(InputChannelSelection(i))},'r');
            
            InputChannelData{i} = fread(FileIdentifier, 'int16');

            InputChannelData{i} = single(InputChannelData{i}.* 0.0000374); %analog input to Volt (not mV!)
            
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputChannelData,EventInfoType);

    elseif strcmp(Data.Info.RecordingType,"IntanRHD")
        
        InputDatatoextract={};
        for i = 1:length(InputChannelSelection)
            InputDatatoextract{i} = RHDAllChannelData.aux_input_data(InputChannelSelection(i),:);
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputDatatoextract,EventInfoType);

    end

elseif strcmp(Filetype, "DIN Inputs")

    if strcmp(Data.Info.RecordingType,"IntanDat")
        InputChannelData = {};

        [DatFilePaths,~,~,~,~,~] = CheckIntanDatFiles(FolderPath);
        
        for i = 1:length(InputChannelSelection)
            
            FileIdentifier = fopen(DatFilePaths{InputChannelIndicie(InputChannelSelection(i))},'r');
            
            InputChannelData{i} = fread(FileIdentifier, 'int16');

            InputChannelData{i} = single(InputChannelData{i}); 

        end

        if isfield(Data.Info,'CutStart')
            if ~isempty(Data.Info.CutStart)
                NumSamples = Data.Info.CutStart;
            end
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputChannelData,EventInfoType);

    elseif strcmp(Data.Info.RecordingType,"IntanRHD")

        InputDatatoextract={};
        for i = 1:length(InputChannelSelection)
            InputDatatoextract{i} = RHDAllChannelData.board_dig_in_data(InputChannelSelection(i),:);
        end

        [Data,~] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,InputChannelIndicie,Filetype,Threshold,InputDatatoextract,EventInfoType);

    end
       
end
