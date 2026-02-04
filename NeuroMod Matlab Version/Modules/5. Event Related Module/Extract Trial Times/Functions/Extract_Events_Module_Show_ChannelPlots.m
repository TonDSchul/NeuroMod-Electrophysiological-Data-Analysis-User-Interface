function Extract_Events_Module_Show_ChannelPlots(Data,Channel,Folder,app,RHDAllChannelData,Type,DownsampleRate,executablefolder,StateOption)

%________________________________________________________________________________________
%% Function to plot event data of a selected event channel 

% This function searches on startup of the Show_Event_Channel_Window through possible events and plots data
% for the first event channel found. Otherwise it plots/returns info that
% no data found for specified channel

% gets called when the user clicks on "Show Input Channel Plots" in the
% extract data window and opens the Show_Event_Channel_Window app.

% Inputs: 
% 1.Channel: type of event file to look for; for Intan: "Digital
% Inputs" or "Analog Input" or "AUX"
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 2. Folder: path to folder holding event recordings as char
% 3. app: Show_Event_Channel_Window app object
% 4. RHDAllChannelData: NOTE!! ONLY IF .RHD file format analyzed! saves field
% RHDAllChannelData.board_dig_in_data containing event data (NOTE!! as a nevents x ntime matrix), since the file had
% to be loaded earlier already to know what can be shown as otions in the
% GUI. --> not as nicely doable as with individual .dat files for each
% event
% 5. Type: Determines if this function is executed on Show_Event_Channel_Window startup. If yes, additional infos are loaded. 
% If no, This has to be some other string to only extract necessary information

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% For Intan .dat files (one per channel)
if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")
    if ~isempty(Channel)
        if strcmp(Data.Info.RecordingType,"IntanDat")
            [FilePaths,~,EventInfo,~,InfoRhd,~] = CheckIntanDatFiles(Folder);
            % Load Rhd Info file
            RHDData = [];
            if isempty(app.EventChannelNames)
                [~,~,~,~,~,~,~,~,~,app.EventChannelNames] = Intan_RHD2000_Data_Extraction(InfoRhd(end-7:end),InfoRhd(1:end-8),"Extracting",[]);
            end
        elseif strcmp(Data.Info.RecordingType,"IntanRHD")
            if strcmp(Channel,"DINChannel") || strcmp(Channel,"DIChannel")
                RHDData = RHDAllChannelData.board_dig_in_data;
            elseif strcmp(Channel,"ADCChannel")
                RHDData = RHDAllChannelData.board_adc_data;
            elseif strcmp(Channel,"AUXChannel")
                RHDData = RHDAllChannelData.aux_input_data;
            end

            [RHDFilePaths] = LoadIntanRHDFiles(Folder);
            RHDFilePaths = convertStringsToChars(RHDFilePaths);

            LastDashIndex = find(RHDFilePaths == '\');
            RHDPath = RHDFilePaths(1:LastDashIndex(end));
            RHDFiles = RHDFilePaths(LastDashIndex(end)+1:end);
            
            FilePaths = RHDPath;
            
            if isempty(RHDAllChannelData)
                [~,~,~,~,~,~,~,~,NumChannel,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"Extracting",[]);
            else
                [~,~,~,~,~,~,~,~,NumChannel,ChannelNames] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"NumChannel",[]);
            end

            if NumChannel.num_board_adc_channels == 0 && NumChannel.num_board_dig_in_channels == 0 && NumChannel.aux_input_channels == 0
                msgbox("Warning: No event data found in folder the dataset was extracted from. Please select a different folder.");
                return;
            end

            EventInfo = [];
            RHDEventChannelNames = cell(1,length(ChannelNames));
            
            ChannelNamesfieldnames = fieldnames(ChannelNames);

            for p = 1:length(ChannelNamesfieldnames)
                if strfind(ChannelNamesfieldnames{p},'Digital')
                    if ~isempty(ChannelNames.Digital)
                        app.EventChannelNames.Digital= ChannelNames.Digital;
                        if NumChannel.num_board_dig_in_channels > 0 && ~isfield(EventInfo,'DIChannel')
                            EventInfo.DIChannel = 1:NumChannel.num_board_dig_in_channels;
                        end    
                    end
                elseif strfind(ChannelNamesfieldnames{p},'Analog')
                    if ~isempty(ChannelNames.Analog)
                        app.EventChannelNames.Analog = ChannelNames.Analog;
                        if NumChannel.num_board_adc_channels > 0 && ~isfield(EventInfo,'ADCChannel')
                            EventInfo.ADCChannel = 1:NumChannel.num_board_dig_in_channels;
                        end
                    end
                elseif strfind(ChannelNamesfieldnames{p},'Aux')
                    if ~isempty(ChannelNames.Aux)
                        app.EventChannelNames.Aux = ChannelNames.Aux;
                        if NumChannel.aux_input_channels > 0 && ~isfield(EventInfo,'AUXChannel')
                            EventInfo.AUXChannel = 1:NumChannel.aux_input_channels;
                        end  
                    end
                end
            end
        end
                
        if strcmp(Channel,"DIChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Digital;
            app.FileTypeDropDown.Value = "Digital Inputs";
            ModifiedEventInfo = EventInfo.DIChannel;
        elseif strcmp(Channel,"ADCChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Analog;
            app.FileTypeDropDown.Value = "Analog Inputs";
            ModifiedEventInfo = EventInfo.ADCChannel;
        elseif strcmp(Channel,"AUXChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Aux;
            app.FileTypeDropDown.Value = "AUX Inputs";
            ModifiedEventInfo = EventInfo.AUXChannel;
        elseif strcmp(Channel,"DINChannel")
            app.FileTypeDropDown_2.Items = app.EventChannelNames.Digital;
            app.FileTypeDropDown.Value = "DIN Inputs";
            ModifiedEventInfo = EventInfo.DINChannel;
        end

        [DownsampleRate] = Extract_Events_Module_Load_and_Plot_Events(ModifiedEventInfo,FilePaths,app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown_2.Items,Data,RHDData,DownsampleRate);
    
        if str2double(app.DowsampledSampleRateHzEditField.Value) ~= DownsampleRate
            app.DowsampledSampleRateHzEditField.Value = num2str(DownsampleRate);
        end

    else
        msgbox("No Input Channel found for this recording!");
    end
end

if strcmp(Data.Info.RecordingType,"Open Ephys")

    IsNodeAvailable = 0;
    for i = 1:length(Channel.Info.AvailabelNodes)
        if Channel.Info.AvailabelNodes{i} == Channel.SelectedLineNode
            IsNodeAvailable = i;
            break;
        end
    end

    if IsNodeAvailable ~= 0
        EventInfotoShow = app.EWapp.EventInfo{IsNodeAvailable};
    else
        msgbox("Selected Node contains no events!");
        return;
    end
    % get event number seelctec
    LineIndex = [];
    for i = 1:length(app.FileTypeDropDown_2.Items)
        if strcmp(app.FileTypeDropDown_2.Items{i},app.FileTypeDropDown_2.Value) 
            LineIndex = i;
        end
    end
    
    % Extract samples
    if isprop(EventInfotoShow,'sample_number')
        sampleNumber = EventInfotoShow.sample_number;
    elseif isprop(EventInfotoShow,'sampleNumber')
        sampleNumber = EventInfotoShow.sampleNumber;
    else
        for nprops = 1:length(EventInfotoShow.Properties.VariableNames)
            if ~isempty(strfind(EventInfotoShow.Properties.VariableNames{nprops},'sample'))
                fieldname = EventInfotoShow.Properties.VariableNames{nprops};
                sampleNumber = eval(strcat('EventInfotoShow.',fieldname));
            end
        end
    end
    
    %% Only select events according to user inputs --> event line and state 
    % Select event channel and state equals (1)
    SelectedLineIndicies = EventInfotoShow.line == Channel.LineNumbers(LineIndex);
    
    if strcmp(StateOption,"State = 1")
        SelectedLineIndicies = SelectedLineIndicies+(EventInfotoShow.state == 1);
        SelectedLineIndicies(SelectedLineIndicies==1)=0;
        SelectedLineIndicies(SelectedLineIndicies==2)=1;
        SampleNumber = double(sampleNumber(SelectedLineIndicies==1));
    elseif strcmp(StateOption,"State = 0")
        SelectedLineIndicies = SelectedLineIndicies+(EventInfotoShow.state == 0);
        SelectedLineIndicies(SelectedLineIndicies==1)=0;
        SelectedLineIndicies(SelectedLineIndicies==2)=1;
        SampleNumber = double(sampleNumber(SelectedLineIndicies==1));
    end
    
    if isfield(Data.Info,'CutStart') %% Normalize to new zero timestamp
        SampleNumber = SampleNumber - (sum(Data.Info.CutStart)*Data.Info.NativeSamplingRate);
        SampleNumber(SampleNumber<=0) = [];
    end

    if isfield(Data.Info,'TimeAndChannelToExtract') %% Normalize to new zero timestamp
        if contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,',')
            if ~contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,'Inf')
                Timetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
            else
                TempTimetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
                Timetoextract(1) = TempTimetoextract(1);
                Timetoextract(2) = Data.Time(end); 
            end
        else
            Timetoextract = eval(TimeAndChannelToExtract.TimeToExtract);
        end

        % convert to samples
        Timetoextract = round(Timetoextract*Data.Info.NativeSamplingRate);
        if Timetoextract(1)==0
            Timetoextract(1) = 1;
        end

        SampleNumber = SampleNumber - ((Timetoextract(1)-1));
        SampleNumber(SampleNumber<=0) = [];
    end
    % Include a specific duration of the event to make it clearly visible
    % -- 1ms standard

    %% Normalize Timestamps to acquisition start
    
    Numsamplesevent = round(Data.Info.NativeSamplingRate*0.001);
    %Numsamplesevent = 20;

    SampleEndNumber = SampleNumber+Numsamplesevent;
    EventData = zeros(1,length(Data.Time));
    
    % Just one sample would be visibly different to others. This can be
    % hard to see so I add 1ms to the right of the trigger 
    for i = 1:length(SampleNumber)
        if SampleEndNumber(i)<length(EventData)
            EventData(SampleNumber(i):SampleEndNumber(i)) = 1;
        end
    end
    
    zerosample = SampleNumber == 0;

    if sum(zerosample)>0
        msgbox("Warning: Sample Nr 0 found and deleted");
        SampleNumber(zerosample==1) = [];
    end

   
    [DownsampleRate] = Extract_Events_Module_Load_and_Plot_Events(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate);
    
    if str2double(app.DowsampledSampleRateHzEditField.Value) ~= DownsampleRate
        app.DowsampledSampleRateHzEditField.Value = num2str(DownsampleRate);
    end

end

if strcmp(Data.Info.RecordingType,"Neuralynx")

    EventData = zeros(1,length(Data.Time));
    EventData(Channel.Samples) = 1;

    % Include a specific duration of the event to make it clearly visible
    % -- 2ms standard
    Numsamplesevent = round(Data.Info.NativeSamplingRate*0.002);
    % Just one sample would be visibly different to others. This can be
    % hard to see so I add 1ms to the right of the trigger 
    for i = 1:length(Channel.Samples)
        if Channel.Samples(i)+Numsamplesevent<=length(EventData)
            EventData(Channel.Samples(i):Channel.Samples(i)+Numsamplesevent) = 1;
        elseif Channel.Samples(i)+Numsamplesevent>length(EventData)
            EventData(Channel.Samples(i):end) = 1;
        end
    end

    [DownsampleRate] = Extract_Events_Module_Load_and_Plot_Events(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate);
    
    if str2double(app.DowsampledSampleRateHzEditField.Value) ~= DownsampleRate
        app.DowsampledSampleRateHzEditField.Value = num2str(DownsampleRate);
    end

end

if strcmp(Data.Info.RecordingType,"TDT Tank Data")
    
    EventData = zeros(1,length(Data.Time));
    
    % just input channel selected
    if strcmp(Type,"eE") || strcmp(Type,"eTr") || strcmp(Type,"eS") || strcmp(Type,"eB") || strcmp(Type,"eT")
        if strcmp(StateOption,'Trigger Onset')
            ChannelIndentityIndice = Channel.(Type).OnsetChannelIdentities == RHDAllChannelData;
        else
            ChannelIndentityIndice = Channel.(Type).OffsetChannelIdentities == RHDAllChannelData;
        end
    else
        ChannelIndentityIndice = Channel.(Type).ChannelIdentities == RHDAllChannelData;
    end
    %% Correct for different timetoextract
    if contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,',')
        if ~contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,'Inf')
            Timetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
        else
            TempTimetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
            Timetoextract(1) = TempTimetoextract(1);
            Timetoextract(2) = Data.Time(end); 
        end
    else
        Timetoextract = eval(Data.Info.TimeAndChannelToExtract.TimeToExtract);
    end
    
    % convert to samples
    Timetoextract = round(Timetoextract*Data.Info.NativeSamplingRate);
    if Timetoextract(1)==0
        Timetoextract(1) = 1;
    end
    

    if strcmp(Type,"eE") || strcmp(Type,"eTr") || strcmp(Type,"eS") || strcmp(Type,"eB") || strcmp(Type,"eT")
        if strcmp(StateOption,'Trigger Onset')
            IndiciesToOne = Channel.(Type).OnsetTimestamps(ChannelIndentityIndice);
        else
            IndiciesToOne = Channel.(Type).OffsetTimestamps(ChannelIndentityIndice);
        end
    else
        IndiciesToOne = Channel.(Type).Timestamps(ChannelIndentityIndice);
    end
    
    %% Actually correct for specific time to extract
    IndiciesToOne(IndiciesToOne>Timetoextract(2)) = [];
    IndiciesToOne = IndiciesToOne - (Timetoextract(1)-1);
    
    if isfield(Data.Info,'CutStart')
        StartTime = round(sum(Data.Info.CutStart) * Data.Info.NativeSamplingRate);
        IndiciesToOne = IndiciesToOne - StartTime;
    end

    IndiciesToOne(IndiciesToOne<=0)=[];
    
    IndiciesToOne(IndiciesToOne>length(Data.Time)) = [];

    EventData(IndiciesToOne) = 1;
    
    % Include a specific duration of the event to make it clearly visible
    % -- 2ms standard
    Numsamplesevent = round(Data.Info.NativeSamplingRate*0.002);
    % Just one sample would be visibly different to others. This can be
    % hard to see so I add 1ms to the right of the trigger 
    for i = 1:sum(ChannelIndentityIndice)
        if strcmp(Type,"eE") || strcmp(Type,"eTr") || strcmp(Type,"eS") || strcmp(Type,"eB") || strcmp(Type,"eT")
            if strcmp(StateOption,'Trigger Onset') % Onset
                disp('Trigger Onset')
                if Channel.(Type).OnsetTimestamps(i) ~= 0
                    if Channel.(Type).OnsetTimestamps(i)+Numsamplesevent<=length(EventData)
                        Indicies = Channel.(Type).OnsetTimestamps(i):Channel.(Type).OnsetTimestamps(i)+Numsamplesevent;
                        %Indicies = Indicies - (Timetoextract(1)-1);
                        EventData(Indicies) = 1;
                    elseif Channel.(Type).OnsetTimestamps(i)+Numsamplesevent>length(EventData)
                        Indicies = Channel.(Type).OnsetTimestamps(i);
                        %Indicies = Indicies - (Timetoextract(1)-1);
                        EventData(Indicies:end) = 1;
                    end
                end
            else % Offset
                disp('Trigger Offset')
                if Channel.(Type).OffsetTimestamps(i) ~= 0
                    if Channel.(Type).OffsetTimestamps(i)+Numsamplesevent<=length(EventData)
                        Indicies = Channel.(Type).OffsetTimestamps(i):Channel.(Type).OffsetTimestamps(i)+Numsamplesevent;
                        %Indicies = Indicies - (Timetoextract(1)-1);
                        EventData(Indicies) = 1;
                    elseif Channel.(Type).OffsetTimestamps(i)+Numsamplesevent>length(EventData)
                        Indicies = Channel.(Type).OffsetTimestamps(i);
                        %Indicies = Indicies - (Timetoextract(1)-1);
                        EventData(Indicies:end) = 1;
                    end
                end
            end

        else
            if Channel.(Type).Timestamps(i) ~= 0
                if Channel.(Type).Timestamps(i)+Numsamplesevent<=length(EventData)
                    Indicies = Channel.(Type).Timestamps(i):Channel.(Type).Timestamps(i)+Numsamplesevent;
                    %Indicies = Indicies - (Timetoextract(1)-1);
                    EventData(Indicies) = 1;
                elseif Channel.(Type).Timestamps(i)+Numsamplesevent>length(EventData)
                    Indicies = Channel.(Type).Timestamps(i);
                    %Indicies = Indicies - (Timetoextract(1)-1);
                    EventData(Indicies:end) = 1;
                end
            end
        end
    end

    [DownsampleRate] = Extract_Events_Module_Load_and_Plot_Events(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate);
    
    if str2double(app.DowsampledSampleRateHzEditField.Value) ~= DownsampleRate
        app.DowsampledSampleRateHzEditField.Value = num2str(DownsampleRate);
    end

end

if strcmp(Data.Info.RecordingType,"NEO")
    
    if isfield(Data.Info,'CutStart')
        index = round(sum(Data.Info.CutStart) * Data.Info.NativeSamplingRate); % convert in samples
        Channel.Samples = Channel.Samples - index;
    end

    if isfield(Data.Info,'CutEnd')
        index = round(sum(Data.Info.CutEnd) * Data.Info.NativeSamplingRate); % convert in samples
        Channel.Samples(Channel.Samples>index) = [];
    end

    Channel.Samples(Channel.Samples<=0) = [];

    EventData = zeros(1,length(Data.Time));
    %EventData(Channel.Samples) = 1;

    % Include a specific duration of the event to make it clearly visible
    % -- 2ms standard
    Numsamplesevent = round(Data.Info.NativeSamplingRate*0.002); 
    for i = 1:length(Channel.Samples)
        if Channel.Samples(i)+Numsamplesevent<=length(EventData)
            EventData(Channel.Samples(i):Channel.Samples(i)+Numsamplesevent) = 1;
        elseif Channel.Samples(i)+Numsamplesevent>length(EventData)
            EventData(Channel.Samples(i):end) = 1;
        end
    end
    %% Correct for time cons

    [DownsampleRate] = Extract_Events_Module_Load_and_Plot_Events(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate);
    
    if str2double(app.DowsampledSampleRateHzEditField.Value) ~= DownsampleRate
        app.DowsampledSampleRateHzEditField.Value = num2str(DownsampleRate);
    end

end

if strcmp(Data.Info.RecordingType,"Spike2")
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
        savefilepath = strcat(executablefolder,'\Saved Data\Variables (so not edit)\CEDS64Path.mat');
        save(savefilepath,'selectedFolder')
    else % If json interface found load path to it
        load(FolderWithPathVariable,'selectedFolder');
    end
    
    % Load library
    cedpath = selectedFolder;
    addpath(cedpath);
    CEDS64LoadLib(cedpath);
    
    % Get the contents of the folder
    contents = dir(Folder);   
    Filenametoload = [];
    for i = 1:length(contents)
        item = contents(i);

        if strcmp(item.name, '.') || strcmp(item.name, '..')
            continue;
        end

        [~, ~, ext] = fileparts(item.name);
        if strcmp(ext, '.smrx')
            Filenametoload = item.name;

        end
    end
    Error = 0;
    if isempty(Filenametoload)
        msgbox("Error: No .smrx file found in Path.")
        Error = 1;
    end

    if Error == 0
        % Complete path to specific file in the selected folder
        FullDataPath = convertStringsToChars(fullfile(Folder,Filenametoload));
        
        % Extract general infos
        fhand1 = CEDS64Open(FullDataPath);
        
        maxTimeTicks = CEDS64ChanMaxTime(fhand1, 1)+1; % +1 so the read gets the last point
        [ dSeconds ] = CEDS64TicksToSecs( fhand1, maxTimeTicks );
        ChannelRange = str2double(strsplit(Channel,','));
        EventData = cell(1,1);

        %% Only extract time specified by user
        if contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,',')
            if ~contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,'Inf')
                Timetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
            else
                TempTimetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
                Timetoextract(1) = TempTimetoextract(1);
                Timetoextract(2) = dSeconds; 
            end
        else
            Timetoextract = eval(Data.Info.TimeAndChannelToExtract.TimeToExtract);
        end
        
        i64From = CEDS64SecsToTicks(fhand1, Timetoextract(1));
        i64To   = CEDS64SecsToTicks(fhand1, Timetoextract(2));
        
        h = waitbar(0, 'Extracting Spike 2 Event Channel...', 'Name','Extracting Spike 2 Event Channel...');
        % Extract channel wise data. Loops until all channel analyzed

        fraction = 1/length(ChannelRange);
        msg = sprintf('Extracting Spike 2 Event Channel... (%d%% done)', round(100*fraction));
        waitbar(fraction, h, msg);
        
        %% Somehow the tick and time output is the same. Moreover, output seems to be in ms. So output*1000/length of channel = 50kHz Sampling Rate
        [iRead, TempData, i64Time] = CEDS64ReadWaveF(fhand1, str2double(app.FileTypeDropDown_2.Value), maxTimeTicks, i64From, i64To);
        
        %[~, TempData, ~] = CEDS64ReadWaveF(fhand1, str2double(app.FileTypeDropDown_2.Value), maxTimeTicks, 0, maxTimeTicks);
        if ~isempty(TempData)   
            EventData{1} = TempData;
            EventData{1}(end)=[];
        end
        
        clear TempData
   
        close(h);
    end

    [DownsampleRate] = Extract_Events_Module_Load_and_Plot_Events(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate);
    
    if str2double(app.DowsampledSampleRateHzEditField.Value) ~= DownsampleRate
        app.DowsampledSampleRateHzEditField.Value = num2str(DownsampleRate);
    end

end


if strcmp(Data.Info.RecordingType,"SpikeInterface Maxwell MEA .h5")
    
    Channel.Samples(Channel.Samples<=0) = [];

    EventData = zeros(1,length(Data.Time));
    %EventData(Channel.Samples) = 1;

    % Include a specific duration of the event to make it clearly visible
    % -- 2ms standard
    Numsamplesevent = round(Data.Info.NativeSamplingRate*0.002);
    % Just one sample would be visibly different to others. This can be
    % hard to see so I add 1ms to the right of the trigger 
    for i = 1:length(Channel.Samples)
        if Channel.Samples(i)+Numsamplesevent<=length(EventData)
            EventData(Channel.Samples(i):Channel.Samples(i)+Numsamplesevent) = 1;
        elseif Channel.Samples(i)+Numsamplesevent>length(EventData)
            EventData(Channel.Samples(i):end) = 1;
        end
    end
    %% Correct for time cons

    [DownsampleRate] = Extract_Events_Module_Load_and_Plot_Events(EventData,[],app.UIAxes,app.FileTypeDropDown_2.Value,app.FileTypeDropDown.Value,Data,[],DownsampleRate);
    
    if str2double(app.DowsampledSampleRateHzEditField.Value) ~= DownsampleRate
        app.DowsampledSampleRateHzEditField.Value = num2str(DownsampleRate);
    end
    
end