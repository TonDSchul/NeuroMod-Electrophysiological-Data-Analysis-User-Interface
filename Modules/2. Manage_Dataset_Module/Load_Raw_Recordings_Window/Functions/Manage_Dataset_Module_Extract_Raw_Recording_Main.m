function [Data,HeaderInfo,SampleRate,RecordingType,Time] = Manage_Dataset_Module_Extract_Raw_Recording_Main(RecordingSystem,FileType,SelectedFolder,TextArea,executablefolder,AdditionalAmpFactor,NrChannel,NrRows)

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
% 7. NrChannel: from probe layout windoiw, just for spike2

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
    [Data,HeaderInfo,SampleRate,RecordingType] = Manage_Dataset_Extract_Intan_Data(FileType,SelectedFolder,TextArea);
    
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
    
    [Data,HeaderInfo,SampleRate] = Manage_Dataset_Extract_Open_Ephys_Data(SelectedFolder,length(CorrectedContents),SelectedFolderindicie);
    
    RecordingType = "Open Ephys";

    HeaderInfo.RecordingType = "Open Ephys";

    HeaderInfo.NrChannel = size(Data,1);

    if isempty(Data)
        Time = [];
        return;
    end

%% Use Fieldtrip functions to extract Neuralynx data formats. First load Header and then data
elseif strcmp(RecordingSystem,"Neuralynx")
    TextArea.Value = "Extracting Data for Neuralynx Recording System. Please wait until this window closes and a data plot appears in the main window. If you dont have MATLAB importer mex files, this can take a while.";
    pause(0.2);
        
    [HeaderInfo] = ft_read_header(SelectedFolder);

    if isempty(HeaderInfo)
        Data = [];
        SampleRate = [];
        RecordingType = [];
        Time = [];
        return;
    end

    SampleRate = HeaderInfo.Fs;    

    [Data] = ft_read_data(SelectedFolder,'headerinfo',HeaderInfo);

    if isempty(Data)
        Data = [];
        SampleRate = [];
        RecordingType = [];
        Time = [];
        return;
    end

    Data = single(Data);

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
    
    if exist(FolderWithPathVariable, 'file') == 2
        fileExists = true;
    else
        fileExists = false;
    end
    
    % If not installed let the user select the installation folder if he
    % installs it
    if fileExists == false
        msgbox("'Spike2 MATLAB SON Interface' library not found. To analyze Spike2 .smrx files, you need to install this library available at 'https://ced.co.uk/upgrades/spike2matson'. Please install and select the 'CEDS64ML' folder thats installed. You only need to do this once.");
        % Use the uigetdir function to open the file explorer dialog
        selectedFolder = uigetdir();
    
        % Check if the user canceled the dialog
        if selectedFolder == 0
            disp('Folder selection was canceled.');
            selectedFolder = '';
        else
            disp(['Selected folder: ', selectedFolder]);
        end
        savefilepath = strcat(executablefolder,'\Modules\MISC\Variables (do not edit)\CEDS64Path.mat');
        save(savefilepath,'selectedFolder')
    else % If json interface found load path to it when its a valid path
        load(FolderWithPathVariable,'selectedFolder');

        if ~isfolder(selectedFolder)
            delete(FolderWithPathVariable)
            msgbox("'Spike2 MATLAB SON Interface' library not found. To analyze Spike2 .smrx files, you need to install this library available at 'https://ced.co.uk/upgrades/spike2matson'. Please install and select the 'CEDS64ML' folder thats installed. You only need to do this once.");
            % Use the uigetdir function to open the file explorer dialog
            selectedFolder = uigetdir();
        
            % Check if the user canceled the dialog
            if selectedFolder == 0
                disp('Folder selection was canceled.');
                selectedFolder = '';
            else
                disp(['Selected folder: ', selectedFolder]);
            end
            savefilepath = strcat(executablefolder,'\Modules\MISC\Variables (do not edit)\CEDS64Path.mat');
            save(savefilepath,'selectedFolder')
        end
    end
    
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
    
    Data = [];
    nchannel = true;
    currentchan = 0;
    hSpike2 = waitbar(0, 'Extracting Spike2 Data...', 'Name','Extracting Spike2 Data...');
    % Extract channel wise data. Loops until all channel analyzed
    while nchannel == true
        
        currentchan = currentchan+1;

        texttoshow = strcat("Extracting Channel ",num2str(currentchan));
        TextArea.Value = [TextArea.Value;texttoshow];
        pause(0.2);

        %% Somehow the tick and time output is the same. Moreover, output seems to be in ms. So output*1000/length of channel = 50kHz Sampling Rate
        [~, TempData, ~] = CEDS64ReadWaveF(fhand1, currentchan, maxTimeTicks, 0, maxTimeTicks);
        if isempty(TempData)
            nchannel = false;    
            continue;
        end
            
        Data(currentchan,1:length(TempData)) = TempData;
        clear TempData
        % Update the progress bar
        fraction = currentchan/(NrChannel*NrRows); %
        msg = sprintf('Extracting Spike2 Data... (%d%% done)', round(100*fraction));
        waitbar(fraction, hSpike2, msg);
    end
    close(hSpike2);

    % Delte Event Channel
    if ~isempty(Spike2EventChannelToTake) && ~isnan(Spike2EventChannelToTake(1))
        msgbox('Spike2 Event Channel deleted from Raw Data');
        Data(Spike2EventChannelToTake,:) = [];
        for i = 1:length(Spike2EventChannelToTake)
            if i ~=1
                HeaderInfo.Spike2EventChannelToTake = [HeaderInfo.Spike2EventChannelToTake,',',num2str(Spike2EventChannelToTake(i))];
            else
                HeaderInfo.Spike2EventChannelToTake = num2str(Spike2EventChannelToTake(i));
            end
        end
    end

    SampleRate = round(size(Data,2)/dSeconds);

end

%% Recording Type independent variables and processing

% Create time vector
Time = double(0:(1/SampleRate):(size(Data,2)-1)/SampleRate);

% % Apply additional amplification
if ~isempty(AdditionalAmpFactor)
    disp("Additional Amplification was applied to data")
    Data = Data.*str2double(AdditionalAmpFactor);
end
