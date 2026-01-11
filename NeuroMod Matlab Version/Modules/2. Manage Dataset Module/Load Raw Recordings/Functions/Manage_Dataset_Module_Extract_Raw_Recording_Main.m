function [Data,HeaderInfo,SampleRate,RecordingType,Time] = Manage_Dataset_Module_Extract_Raw_Recording_Main(RecordingSystem,FileType,SelectedFolder,TextArea,executablefolder,AdditionalAmpFactor,ActiveChannel,ChannelOrder,TimeAndChannelToExtract)

%________________________________________________________________________________________

%% Main Function coordinating data extraction from raw data

% Saving is performed in chunks to increase performance and values get
% converted to binaries,w hich also increases loading performance 

% Input:
% 1. RecordingSystem: char/string with recordingsystem the recording was
% recorded with. Options: "Intan", "Spike2", "Open Ephys", "Neuralynx"
% 2. FileType: format of recording files. Options: for Intan: Intan .dat,
% Intan .rhd; For Open Ephys: node name of node you want to extract (equals standard folder name of node, like Record Node 101)
% For Spike2: ".smrx"; For Neuralynx: .ncs 
% 3. SelectedFolder: folder as char holding the recording (For open ephys: also recording folder, NOT node folder!)
% 4. TextArea: Textarea object of Extract Raw Data window to show progress of
% loading, empty when called outside of GUI
% 5. executablefolder: path as char to the folder the GUI is saved at (automatically saved by main window on startup of the GUI)
% 6. AdditionalAmpFactor: double, additional amplification raw data is
% multiplied by
% 7. ActiveChannel: double array with all active channel the user defined
% for the probe desing
% 8. ChannelOrder: double array with the channel order the user specified.
% Just to check whether number of elemtents are the same and give a error
% message before data is extracted
% 9. TimeAndChannelToExtract: structure with fields: TimeAndChannelToExtract.TimeToExtract: string, time in seconds (from,to) as comma separated numbers like "0,100" or "0,Inf";
%      

% Output: 
% 1. Data: nchannel x ntimepoints matrix as single 
% 2. HeaderInfo: All infos from the header of the recordings that are later
% saved as Data.Info -- no filed necessary for later. All necessary fields
% are defined manually (ouputs below)
% 3. SampleRate: Sample Rate of the loaded recording in Hz as double+
% 4. RecordingType: char specyfiying the recording system the recording
% comes from. Either "Intan" OR "Open Ephys" OR "Spike2" OP "Neuralynx".
% Basically the same as RecordingSystem, but gets only set correctly when data
% extraction is succesfull. 
% 5. Time: 1 x timepoints double vector with a time in seconds for each data
% sample
                                              
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if ~strcmp(TimeAndChannelToExtract.ChannelToExtract,"All")
    if contains(TimeAndChannelToExtract.ChannelToExtract,']') || contains(TimeAndChannelToExtract.ChannelToExtract,'[')
        TimeAndChannelToExtract.ChannelToExtract(find(TimeAndChannelToExtract.ChannelToExtract==']')) = [];
        TimeAndChannelToExtract.ChannelToExtract(find(TimeAndChannelToExtract.ChannelToExtract=='[')) = [];
    end
    if contains(TimeAndChannelToExtract.ChannelToExtract,',')
        TempChannelToExtract = str2double(strsplit(TimeAndChannelToExtract.ChannelToExtract,','));
    else
        try
            TempChannelToExtract = eval(TimeAndChannelToExtract.ChannelToExtract);
        catch
            msgbox("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
            error("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
        end
    end

    if length(ActiveChannel) ~= length(TempChannelToExtract)
        msgbox("Error: More or less  active channel defined in probe design than channels specified to extract. Please specify to extract as many channel as you have active channel. (Note: Individual channel numbers are NOT individual active channel numbers. They start at 1 and go to the number of channel found in the raw recording.)")
        warning("Error: More or less  active channel defined in probe design than channels specified to extract. Please specify to extract as many channel as you have active channel. (Note: Individual channel numbers are NOT individual active channel numbers. They start at 1 and go to the number of channel found in the raw recording.)");
        warning(strcat("Active channel with ",num2str(length(ActiveChannel))," elements and channel to extract with ",num2str(length(TempChannelToExtract))," elements"));
        Data = [];
        HeaderInfo = [];
        SampleRate = [];
        RecordingType = [];
        Time = [];
        return;
    end
else
    TempChannelToExtract = 1:length(ActiveChannel);
end

if ~isempty(ChannelOrder) && sum(isnan(ChannelOrder))==0
    if length(ChannelOrder) ~= length(TempChannelToExtract)
        msgbox("Error: More or less channel order channel defined in probe design than channels specified to extract. Please specify to extract as many channel as you have channel in your channel order. (Note: Individual channel numbers are NOT individual channel order numbers. They start at 1 and go to the number of channel found in the raw recording.)")
        warning("Error: More or less channel order channel defined in probe design than channels specified to extract. Please specify to extract as many channel as you have channel in your channel order. (Note: Individual channel numbers are NOT individual channel order numbers. They start at 1 and go to the number of channel found in the raw recording.)");
        warning(strcat("Channel order with ",num2str(length(ActiveChannel))," elements and channel to extract with ",num2str(length(TempChannelToExtract))," elements"));
        Data = [];
        HeaderInfo = [];
        SampleRate = [];
        RecordingType = [];
        Time = [];
        return;
    end
end

% If Intan selected as recording system
if strcmp(RecordingSystem,"Intan")
    
    TextArea.Value = "Extracting Data for Intan Recording System";
    pause(0.2);
    
    % Start Data extraction. File type is processed within
    % this funcion (last input argument). Save Recording
    % data as a structure in the mainapp object
    % app is only passed in it to display the progress in
    % the text area
    % Output Data = strucutre with: Data.Raw = ChannelxTime
    % Points raw data
    %                               Data.Time = Timevector
    % Output HeaderInfo = Whatever header info your
    % recording has. 
    [Data,HeaderInfo,SampleRate,RecordingType] = Manage_Dataset_Extract_Intan_Data(FileType,SelectedFolder,TextArea,TimeAndChannelToExtract);
    
    if isempty(Data)
        Time = [];
        return;
    end

%% Open Ephys Matlab Tools to extract ephys recording data
elseif strcmp(RecordingSystem,"Open Ephys")
    
    addpath(genpath("."));

    % get folder contents
    [stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);
    
    %% Search for open ephys data
    FolderIndicieWithEphysData = [];
    
    for foldercontents = 1:length(stringArray)
        if contains(stringArray(foldercontents),'Record Node')
            if isfolder(strcat(SelectedFolder,'\',stringArray(foldercontents)))
                FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
            end
        end
    end

    CorrectedContents = stringArray(FolderIndicieWithEphysData);

    SelectedFolderindicie = find(CorrectedContents == FileType);
    
    [Data,HeaderInfo,SampleRate] = Manage_Dataset_Extract_Open_Ephys_Data(SelectedFolder,length(CorrectedContents),SelectedFolderindicie,TimeAndChannelToExtract);
    
    if length(ActiveChannel)>size(Data,1)
        msgbox(strcat("Recording contains ",num2str(size(Data,1))," amplifier channel but ",num2str(length(ActiveChannel))," active channel where specified in the probe desing. Please change the probe layout so that it has as many active channel as data channel."));
        error(strcat("Recording contains ",num2str(size(Data,1))," amplifier channel but ",num2str(length(ActiveChannel))," active channel where specified in the probe desing. Please change the probe layout so that it has as many active channel as data channel."));
    end

    RecordingType = "Open Ephys";

    HeaderInfo.RecordingType = "Open Ephys";

    HeaderInfo.NrChannel = size(Data,1);

    if isempty(Data)
        Time = [];
        return;
    end

%% Use Fieldtrip functions to extract Neuralynx data formats. First load Header and then data
elseif strcmp(RecordingSystem,"Neuralynx")
    TextArea.Value = "Extracting data for neuralynx recording system. Please wait until this window closes and a data plot appears in the main window. If you dont have MATLAB importer mex files, this can take a while.";
    pause(0.2);
        
    [HeaderInfo] = ft_read_header(SelectedFolder);
    
    HeaderInfo.startTimestamp = double(HeaderInfo.FirstTimeStamp);

    if isempty(HeaderInfo)
        Data = [];
        SampleRate = [];
        RecordingType = [];
        Time = [];
        return;
    end

    SampleRate = HeaderInfo.Fs;    

    %% Determine Channel
    ChannelToExtract = convertStringsToChars(TimeAndChannelToExtract.ChannelToExtract);
    if strcmp(ChannelToExtract,"All")
        numchannel = HeaderInfo.nChans;
        AllChannelInFile = numchannel;
        IndividualChannel = 1:numchannel;
    else
        ChannelToExtract = convertStringsToChars(ChannelToExtract);
        if contains(ChannelToExtract,']') || contains(ChannelToExtract,'[')
            ChannelToExtract(find(ChannelToExtract==']')) = [];
            ChannelToExtract(find(ChannelToExtract=='[')) = [];
        end

        if contains(ChannelToExtract,',')
            IndividualChannel = str2double(strsplit(ChannelToExtract,','));
        else
            try
                IndividualChannel = eval(ChannelToExtract);
            catch
                msgbox("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
                error("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
            end
        end
    end

    %% Determine samples to extract if only specific time points extracted
    SplitString = strsplit(TimeAndChannelToExtract.TimeToExtract,',');
    StartSample = round(str2double(SplitString{1}) * SampleRate);  
    if StartSample == 0
        StartSample = 1;
    end
    if strcmp(SplitString{2},"Inf")
        StopSample = HeaderInfo.nSamples;
    else
        StopSample = round(str2double(SplitString{2}) * SampleRate);  
    end

    if StopSample>HeaderInfo.nSamples
        warning(strcat("Time to extract exceeds length of the selected recording. Taking the whole recording length of ",num2str((HeaderInfo.nSamples-1)/SampleRate)," seconds instead."))
        StopSample = HeaderInfo.nSamples;
    end

    disp(strcat("Ectracting raw data from ",num2str((StartSample-1)/SampleRate)," seconds to ",num2str((StopSample-1)/SampleRate)," seconds"));

    %DataIndicies = StartSample : StopSample;
    
    [Data] = ft_read_data(SelectedFolder,'header',HeaderInfo, 'begsample', StartSample, 'endsample', StopSample);
    
    if isempty(Data)
        Data = [];
        SampleRate = [];
        RecordingType = [];
        Time = [];
        return;
    end

    Data = single(Data(IndividualChannel,:));

    % Convert to mV
    Data = Data ./1000;

    NaNIndicies = isnan(Data);
    SumNAN = sum(NaNIndicies);
    SumNAN = sum(SumNAN);

    [~,b] = find(isnan(Data));
    NaNTimes = unique(b)./SampleRate;

    if SumNAN>0
        msgbox(strcat("Warning: ",num2str(SumNAN)," NaN found in data; TimeRange: ",num2str(NaNTimes(1)),"seconds to ",num2str(NaNTimes(end)),"seconds"));
    end

    % Apply Amplification 64 to translate signal in uV and
    % translate into mV by dividing by 1000
    %Data = Data./1000; %% Durch oder mal, mal schauen

    RecordingType = "Neuralynx";

elseif strcmp(RecordingSystem,"TDT Tank Data")
    
    TextArea.Value = "Extracting Data for TDT Recording System. Please wait until this window closes and a data plot appears in the main window. If you dont have MATLAB importer mex files, this can take a while.";
    
    pause(0.2);

    SelectedLFPAP = [];

    %% Determine Channel
    ChannelToExtract = convertStringsToChars(TimeAndChannelToExtract.ChannelToExtract);
    if strcmp(ChannelToExtract,"All")
        numchannel = [];
        IndividualChannel = [];
    else
        if contains(ChannelToExtract,',')
            numchannel = length(str2double(strsplit(ChannelToExtract,',')));
        else
            try
                numchannel = length(eval(ChannelToExtract));
            catch
                msgbox("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
                error("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
            end
        end
        ChannelToExtract = convertStringsToChars(ChannelToExtract);
        if contains(ChannelToExtract,']') || contains(ChannelToExtract,'[')
            ChannelToExtract(find(ChannelToExtract==']')) = [];
            ChannelToExtract(find(ChannelToExtract=='[')) = [];
        end

        if contains(ChannelToExtract,',')
            IndividualChannel = str2double(strsplit(ChannelToExtract,','));
        else
            try
                IndividualChannel = eval(ChannelToExtract);
            catch
                msgbox("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
                error("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
            end
        end
    end
    
    %% check if wide data stored (preffered)
    Widemeta = TDTbin2mat(SelectedFolder, ...
                  'TYPE', {'streams'}, ...
                  'STORE', {'Wide'}, ...
                  'HEADERS', 1);
    
    if ~isempty(fieldnames(Widemeta.stores))
        SelectedLFPAP = 'Wide';
        %% Determine TIME!(s) to extract if only specific time points extracted
        SplitString = strsplit(TimeAndChannelToExtract.TimeToExtract,',');
        StartSample = round(str2double(SplitString{1}));  
        if strcmp(SplitString{2},"Inf")
            StopSample = Widemeta.stores.Wide.ts(end);
        else
            StopSample = round(str2double(SplitString{2}));  
        end
        
        if StopSample>Widemeta.stores.Wide.ts(end)
            warning(strcat("Time to extract exceeds length of the selected recording. Taking the whole recording length of ",num2str(Widemeta.stores.Wide.ts(end))," seconds instead."))
            StopSample = Widemeta.stores.Wide.ts(end);
        end
    
        disp(strcat("Ectracting raw data from ",num2str(StartSample)," seconds to ",num2str(StopSample)," seconds"));

        if isempty(numchannel) %% all channel
            data = TDTbin2mat(SelectedFolder, 'STORE', 'Wide','T1',StartSample,'T2', StopSample);
        else %% just specified channel
            try
                data = TDTbin2mat(SelectedFolder, 'STORE', 'Wide', 'CHANNEL', IndividualChannel,'T1',StartSample,'T2', StopSample);
            catch ME
                warning('TDTbin2mat failed: %s', ME.message);
                if contains(ME.message,"not found") && contains(ME.message,"Channel")
                    warning("Extracting all channel instead!")
                    data = TDTbin2mat(SelectedFolder, 'STORE', 'Wide','T1',StartSample,'T2', StopSample);
                end
            end
        end
        Data = single(data.streams.Wide.data);
        SampleRate = data.streams.Wide.fs;

    else % no wide data found
        %% check if wide data stored (preffered)
        Wavemeta = TDTbin2mat(SelectedFolder, ...
                      'TYPE', {'streams'}, ...
                      'STORE', {'Wave'}, ...
                      'HEADERS', 1);
        SpikeMeta = TDTbin2mat(SelectedFolder, ...
                      'TYPE', {'streams'}, ...
                      'STORE', {'Spik'}, ...
                      'HEADERS', 1);
        if ~isempty(fieldnames(Wavemeta.stores)) && ~isempty(fieldnames(SpikeMeta.stores))
            % ask what component to extract
            DatatoExtract = [];

            DTDDataTypeWindow = TDT_LFP_or_AP();

            uiwait(DTDDataTypeWindow.TDTDataSelectionUIFigure)
            
            if isvalid(DTDDataTypeWindow)
                if DTDDataTypeWindow.SelectedRecordings == 1
                    SelectedLFPAP = 'Wave';
                else
                    SelectedLFPAP = 'Spik';
                end

                if DTDDataTypeWindow.SelectedRecordings == 1
                    %% Determine TIME!(s) to extract if only specific time points extracted
                    SplitString = strsplit(TimeAndChannelToExtract.TimeToExtract,',');
                    StartSample = round(str2double(SplitString{1}));  
                    if strcmp(SplitString{2},"Inf")
                        StopSample = Wavemeta.stores.Wave.ts(end);
                    else
                        StopSample = round(str2double(SplitString{2}));  
                    end
                    
                    if StopSample>Wavemeta.stores.Wave.ts(end)
                        warning(strcat("Time to extract exceeds length of the selected recording. Taking the whole recording length of ",num2str(Widemeta.stores.Wide.ts(end))," seconds instead."))
                        StopSample = Wavemeta.stores.Wave.ts(end);
                    end

                     if isempty(numchannel) %% all channel
                        data = TDTbin2mat(SelectedFolder, 'STORE', 'Wave','T1',StartSample,'T2', StopSample);
                     else %% just specified channel
                        try
                            data = TDTbin2mat(SelectedFolder, 'STORE', 'Wave', 'CHANNEL', IndividualChannel,'T1',StartSample,'T2', StopSample);
                        catch ME
                            warning('TDTbin2mat failed: %s', ME.message);
                            if contains(ME.message,"not found") && contains(ME.message,"Channel")
                                warning("Extracting all channel instead!")
                                data = TDTbin2mat(SelectedFolder, 'STORE', 'Wave','T1',StartSample,'T2', StopSample);
                            end
                        end
                     end
                     Data = single(data.streams.Wave.data);
                     SampleRate = data.streams.Wave.fs;
                elseif DTDDataTypeWindow.SelectedRecordings == 2
                    %% Determine TIME!(s) to extract if only specific time points extracted
                    SplitString = strsplit(TimeAndChannelToExtract.TimeToExtract,',');
                    StartSample = round(str2double(SplitString{1}));  
                    if strcmp(SplitString{2},"Inf")
                        StopSample = SpikeMeta.stores.Spik.ts(end);
                    else
                        StopSample = round(str2double(SplitString{2}));  
                    end
                    
                    if StopSample>SpikeMeta.stores.Spik.ts(end)
                        warning(strcat("Time to extract exceeds length of the selected recording. Taking the whole recording length of ",num2str(Widemeta.stores.Wide.ts(end))," seconds instead."))
                        StopSample = SpikeMeta.stores.Spik.ts(end);
                    end

                    if isempty(numchannel) %% all channel
                        data = TDTbin2mat(SelectedFolder, 'STORE', 'Spik','T1',StartSample,'T2', StopSample);
                     else %% just specified channel
                        try
                            data = TDTbin2mat(SelectedFolder, 'STORE', 'Spik', 'CHANNEL', IndividualChannel,'T1',StartSample,'T2', StopSample);
                        catch ME
                            warning('TDTbin2mat failed: %s', ME.message);
                            if contains(ME.message,"not found") && contains(ME.message,"Channel")
                                warning("Extracting all channel instead!")
                                data = TDTbin2mat(SelectedFolder, 'STORE', 'Spik','T1',StartSample,'T2', StopSample);
                            end
                        end
                     end
                     Data = single(data.streams.Spik.data);
                     SampleRate = data.streams.Spik.fs;
                end
            else
                Data = [];
                SampleRate = [];
                RecordingType = [];
                Time = [];
                return;
            end
            
            try
                delete(DTDDataTypeWindow)
            end
        else
            Data = [];
            SampleRate = [];
            RecordingType = [];
            Time = [];
            return;
        end

    end

    HeaderInfo = data.info;
    HeaderInfo.Fs = SampleRate;

    HeaderInfo.SelectedRecordingTdT = SelectedLFPAP;

    if size(Data,1)>size(Data,2)
        Data = Data';
        Data = Data*1000; % convert in mV
    end

    RecordingType = "TDT Tank Data";
    

elseif strcmp(RecordingSystem,"Spike GLX")

    [Data,HeaderInfo,SampleRate,RecordingType] = Manage_Dataset_Extract_SpikeGLX(SelectedFolder,TimeAndChannelToExtract);

%% Use Fieldtrip functions to extract Plexon data formats. First load Header and then data
elseif strcmp(RecordingSystem,"Plexon")
    % TextArea.Value = "Extracting Data for Plexon Recording System. Please wait until this window closes and a data plot appears in the main window. If you dont have MATLAB importer mex files, this can take a while.";
    % pause(0.2);
    % 
    % [HeaderInfo] = ft_read_header(SelectedFolder);
    % 
    % if isempty(HeaderInfo)
    %     Data = [];
    %     SampleRate = [];
    %     RecordingType = [];
    %     Time = [];
    %     return;
    % end
    % 
    % SampleRate = HeaderInfo.Fs;    
    % 
    % [Data] = ft_read_data(SelectedFolder,'headerinfo',HeaderInfo);
    % 
    % if isempty(Data)
    %     Data = [];
    %     SampleRate = [];
    %     RecordingType = [];
    %     Time = [];
    %     return;
    % end
    % 
    % Data = single(Data);
    % 
    % % Convert to mV
    % Data = Data ./1000;
    % 
    % NaNIndicies = isnan(Data);
    % SumNAN = sum(NaNIndicies);
    % SumNAN = sum(SumNAN);
    % 
    % [~,b] = find(isnan(Data));
    % NaNTimes = unique(b)./SampleRate;
    % 
    % if SumNAN>0
    %     msgbox(strcat("Warning: ",num2str(SumNAN)," NaN found in data; TimeRange: ",num2str(NaNTimes(1)),"seconds to ",num2str(NaNTimes(end)),"seconds"));
    % end
    % 
    % % Apply Amplification 64 to translate signal in uV and
    % % translate into mV by dividing by 1000
    % %Data = Data./1000; %% Durch oder mal, mal schauen
    % 
    % RecordingType = "Plexon";

elseif strcmp(RecordingSystem,"Spike2")

    %% Determine Channel
    ChannelToExtract = convertStringsToChars(TimeAndChannelToExtract.ChannelToExtract);
    if strcmp(ChannelToExtract,"All")
        numchannel = [];
    else
        if contains(ChannelToExtract,',')
            numchannel = length(str2double(strsplit(ChannelToExtract,',')));
        else
            try
                numchannel = length(eval(ChannelToExtract));
            catch
                msgbox("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
                error("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
            end
        end

        ChannelToExtract = convertStringsToChars(ChannelToExtract);
        if contains(ChannelToExtract,']') || contains(ChannelToExtract,'[')
            ChannelToExtract(find(ChannelToExtract==']')) = [];
            ChannelToExtract(find(ChannelToExtract=='[')) = [];
        end

        if contains(ChannelToExtract,',')
            IndividualChannel = str2double(strsplit(ChannelToExtract,','));
        else
            try
                IndividualChannel = eval(ChannelToExtract);
            catch
                msgbox("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
                error("Format entered in channel to extract edit field could not be determined. Please use Matlab expressions only!");
            end
        end
    end
    

    Spike2EventChannel = [];
    Spike2EventChannelToTake = [];

    Spike2EventChannelWindow = Spike2_Select_Event_Channel(Spike2EventChannel);

    uiwait(Spike2EventChannelWindow.Spike2SelectEventChannelUIFigure);

    if isvalid(Spike2EventChannelWindow)
        Spike2EventChannelToTake = Spike2EventChannelWindow.SpikeEventChannel;
    end

    delete(Spike2EventChannelWindow);

    TextArea.Value = "Extracting Data for Spike2 Recording System. Please wait until this window closes and a data plot appears in the main window.";
    pause(0.2);

    RecordingType = "Spike2";

    HeaderInfo.RecordingType = "Spike2";

    [stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);
    
    % Use regular expression to extract filenames ending with '.smrx'
    smrxFiles = regexp(stringArray, '\S+\.smrx', 'match');
    nonEmptyIndices = find(~cellfun(@isempty, smrxFiles));
    
    %% Check whether Json library is installed necessray to analyze this format
    FolderWithPathVariable = strcat(executablefolder,'\Modules\MISC\Variables (do not edit)\CEDS64Path.mat');
        
    [selectedFolder] = Manage_Dataset_Check_Spike2CED64_Path(executablefolder,FolderWithPathVariable);
    
    % Load library
    cedpath = selectedFolder;
    addpath(cedpath);
    CEDS64LoadLib(cedpath);
    
    % Complete path to specific file in the selected folder
    FullDataPath = convertStringsToChars(fullfile(SelectedFolder,stringArray(nonEmptyIndices)));
    
    % Extract general infos
    fhand1 = CEDS64Open(FullDataPath);
    
    maxTimeTicks = CEDS64ChanMaxTime(fhand1, 1)+1; % +1 so the read gets the last point
    [ dSeconds ] = CEDS64TicksToSecs( fhand1, maxTimeTicks );
    
    % get number channel numebr
    maxChan = CEDS64MaxChan(fhand1);

    activeChans = false(1, maxChan);
    
    for ch = 1:maxChan
        chType = CEDS64ChanType(fhand1, ch);
        if chType ~= 0
            activeChans(ch) = true;
        end
    end
    
    numChannels = sum(activeChans);
    
    Data = [];
    nchannel = true;
    currentchan = 0;
    hSpike2 = waitbar(0, 'Extracting Spike2 Data...', 'Name','Extracting Spike2 Data...');
    % Extract channel wise data. Loops until all channel analyzed
    
    %% Determine samples to extract if only specific time points extracted
    [~, TempData, ~] = CEDS64ReadWaveF(fhand1, 1, maxTimeTicks, 0, maxTimeTicks);
    SampleRate = round(length(TempData)/dSeconds);
    SplitString = strsplit(TimeAndChannelToExtract.TimeToExtract,',');
    StartSample = round(str2double(SplitString{1}) * SampleRate);  
    if StartSample == 0
        StartSample = 1;
    end
    if strcmp(SplitString{2},"Inf")
        StopSample = length(TempData);
    else
        StopSample = round(str2double(SplitString{2}) * SampleRate);  
    end
    
    if StopSample>length(TempData)
        warning(strcat("Time to extract exceeds length of the selected recording. Taking the whole recording length of ",num2str((length(TempData)-1)/SampleRate)," seconds instead."))
        StopSample = length(TempData);
    end

    disp(strcat("Ectracting raw data from ",num2str((StartSample-1)/SampleRate)," seconds to ",num2str((StopSample-1)/SampleRate)," seconds"));
    
    CurrentDataChannel = 1;

    while nchannel == true
        currentchan = currentchan+1;

        % skip if current channel indicie is event channel
        if ~isempty(Spike2EventChannelToTake) && ~isnan(Spike2EventChannelToTake(1))
            if sum(currentchan == Spike2EventChannelToTake)>0
                warning(strcat("Channel ",num2str(currentchan)," skipped since it was specified as an event channel."));
                continue;
            end
        end

        % skip if current channel is not specified.
        if ~isempty(numchannel) 
            if sum(currentchan == IndividualChannel)==0
                warning(strcat("Channel ",num2str(currentchan)," skipped."));
                % Exit while loop when finished
                if currentchan>numChannels
                    nchannel = false; 
                end
                continue;
            end
        end
        texttoshow = strcat("Extracting Channel ",num2str(currentchan));
        TextArea.Value = [TextArea.Value;texttoshow];
        pause(0.2);
        
        %% Only extract time specified by user
        if contains(TimeAndChannelToExtract.TimeToExtract,',')
            if ~contains(TimeAndChannelToExtract.TimeToExtract,'Inf')
                Timetoextract = str2double(strsplit(TimeAndChannelToExtract.TimeToExtract,','));
            else
                TempTimetoextract = str2double(strsplit(TimeAndChannelToExtract.TimeToExtract,','));
                Timetoextract(1) = TempTimetoextract(1);
                Timetoextract(2) = dSeconds; 
            end
        else
            Timetoextract = eval(TimeAndChannelToExtract.TimeToExtract);
        end
        
        i64From = CEDS64SecsToTicks(fhand1, Timetoextract(1));
        i64To   = CEDS64SecsToTicks(fhand1, Timetoextract(2));
        
        [iRead, TempData, i64Time] = CEDS64ReadWaveF(fhand1, currentchan, maxTimeTicks, i64From, i64To);
        
        if isempty(TempData)
            if ~isempty(Spike2EventChannelToTake) && ~isnan(Spike2EventChannelToTake(1))
                if sum(currentchan == Spike2EventChannelToTake)==0
                    warning(strcat("Empty data channel found that was not specified as event channel (channel ",num2str(currentchan),")"))
                end
            else
                warning(strcat("Empty data channel found that was not specified as event channel (channel ",num2str(currentchan),")"))
            end

            if isempty(TempData)
                nchannel = false;    
                continue;
            end
        end
            
        Data(CurrentDataChannel,1:length(TempData)) = TempData';
        CurrentDataChannel = CurrentDataChannel + 1;
        clear TempData
        % Update the progress bar

        fraction = currentchan/(length(ActiveChannel)); %
        msg = sprintf('Extracting Spike2 Data... (%d%% done)', round(100*fraction));
        waitbar(fraction, hSpike2, msg);
    end
    close(hSpike2);

    % Delte Event Channel
    if ~isempty(Spike2EventChannelToTake) && ~isnan(Spike2EventChannelToTake(1))
        % msgbox('Spike2 Event Channel deleted from Raw Data');
        % Data(Spike2EventChannelToTake,:) = [];
        for i = 1:length(Spike2EventChannelToTake)
            if i ~=1
                HeaderInfo.Spike2EventChannelToTake = [HeaderInfo.Spike2EventChannelToTake,',',num2str(Spike2EventChannelToTake(i))];
            else
                HeaderInfo.Spike2EventChannelToTake = num2str(Spike2EventChannelToTake(i));
            end
        end
    end

end

%% Add time and channel to extract to header info
HeaderInfo.TimeAndChannelToExtract = TimeAndChannelToExtract;

%% Recording Type independent variables and processing

% Create time vector
Time = double(0:(1/SampleRate):(size(Data,2)-1)/SampleRate);

% % Apply additional amplification
if ~isempty(AdditionalAmpFactor)
    disp("Additional Amplification was applied to data")
    Data = Data.*str2double(AdditionalAmpFactor);
end
