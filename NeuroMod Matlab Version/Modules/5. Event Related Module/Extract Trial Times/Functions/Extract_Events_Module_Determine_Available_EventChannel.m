function [EventInfo,FileEndingsExist,FilePaths,texttoshow,Info] = Extract_Events_Module_Determine_Available_EventChannel(Data,Path,FileType)

%________________________________________________________________________________________
%% Function to determine which event channel are contained in a recording (for Intan, Neuralynx and open ephys)

%gets called when the user starts the event extraction window. It first
%searches automatically in the original data path if it can find event
%data. It is necessary for the event extraction main function since it
%flags the contens of the folder containing suitable event data in the
%supported format. 

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the info structure with infos about extracted events.
% 2. Path: char path to folder containing the recording (Data.Info.Data_Path)
% 3. FileType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type. -- not required anymore but prb
% useful in future

% Outputs:
% 1. EventInfo: Contains fields: .DIChannel; .ADCChannel and .AUXChannel.
% The capture the indicie of the folder contents, which represent data for
% digital, analog and aux channel. 
% 2. FileEndingsExist: -- just neuralynx, not working yet, dont look at
% 3. FilesIndex: for open ephys: saves nu8mber and index of nodes that
% where found and can be display as file type options in event window
% 4. FilePaths: Paths to all folder contents in a n x 1 cell array
% 5. texttoshow: saves text that shows info about found event channel in
% the event window
% 6. Info: Only when open ephys to save nozes that where found
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% The following code takes the path and the type of recording file type from the app.Mainapp.Info file and sets up the window Information based on this

EventInfo = [];
FileEndingsExist = [];
FilesIndex = [];
FilePaths = [];
texttoshow = [];
Info = [];

%% Intan Event Extraction - IntanDat = Method for multiple files in folder
if strcmp(Data.Info.RecordingType,"IntanDat") 
    
    % EventInfo.DIChannel,EventInfo.ADCChannel and
    % EventInfo.AUXChannel save the how manythed file the
    % input channel are in the selected folder. If Digitial
    % Channel 1 is file 11 in the folder,
    % EventInfo.DIChannel saves a 11. For multiple event
    % channel it saves it as a vector. Same for others
    
    [FilePaths,AmplifierDataIndex,EventInfo,~,~,~] = CheckIntanDatFiles(Path);
    
    if ~isempty(EventInfo)
        FileEndingsExist = 1;
        texttoshow = "Found Input Channel:";
        currentstring = [];
        
        if isfield(EventInfo,'DIChannel')
            for i = 1:length(EventInfo.DIChannel)
                currentstring = FilePaths{EventInfo.DIChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
        if isfield(EventInfo,'ADCChannel')
            for i = 1:length(EventInfo.ADCChannel)
                currentstring = FilePaths{EventInfo.ADCChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
        if isfield(EventInfo,'AUXChannel')
            for i = 1:length(EventInfo.AUXChannel)
                currentstring = FilePaths{EventInfo.AUXChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
        if isfield(EventInfo,'DINChannel')
            for i = 1:length(EventInfo.DINChannel)
                currentstring = FilePaths{EventInfo.DINChannel(i)};
                lastdashindex = strfind(currentstring,"\");
                currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
                texttoshow = [texttoshow;currentstring];
            end
        end
    else
        FileEndingsExist = 0;
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
    end

    if ~isempty(AmplifierDataIndex)
        texttoshow = [texttoshow;"Amplifier Input Channel:"];
        currentelements = length(texttoshow);
    
        for i = 1:length(AmplifierDataIndex)
            currentstring = FilePaths{AmplifierDataIndex(i)};
            lastdashindex = strfind(currentstring,"\");
            currentstring = convertCharsToStrings(currentstring(lastdashindex(end)+1:end));
            texttoshow = [texttoshow;currentstring];
        end
    end

%% IntanDat = Method for single file in folder
elseif strcmp(Data.Info.RecordingType,"IntanRHD") 
    % EventInfo.DIChannel,EventInfo.ADCChannel and
    % EventInfo.AUXChannel save the number of event channel
    % found for the specific input channel type (digital, analog, aux)
    %app.RHDAllChannelData is a structure. It saves the data
    %from each event channel found. Its loaded at the beginning
    %and saved directly to avoid having to load it again
    
    [RHDFilePaths] = LoadIntanRHDFiles(Path);
    RHDFilePaths = convertStringsToChars(RHDFilePaths);
    %% rhd file has to be read in order to know how many events and channel it contains. Output is used to populate the fields in this GUI window
    if ~isempty(RHDFilePaths)
        LastDashIndex = find(RHDFilePaths == '\');
        RHDPath = RHDFilePaths(1:LastDashIndex(end));
        RHDFiles = RHDFilePaths(LastDashIndex(end)+1:end);
        
        FilePaths = RHDPath;

        [~,~,~,~,~,~,~,~,NumChannel] = Intan_RHD2000_Data_Extraction (RHDFiles,RHDPath,"NumChannel",[]);
    
        if NumChannel.num_board_adc_channels == 0 && NumChannel.num_board_dig_in_channels == 0 && NumChannel.aux_input_channels == 0
            % app.TextArea.Value = "Warning: No Event Channel found in this folder. Please select a different folder.";
            FileEndingsExist = 0;
            texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
            return;
        else
            FileEndingsExist = 1;
        end  

        texttoshow = ["Found Input Channel:";""];
    
        if NumChannel.num_board_dig_in_channels > 0
            texttoshow = [texttoshow;strcat(num2str(NumChannel.num_board_dig_in_channels)," Digital Channel")];
            EventInfo.DIChannel = 1:NumChannel.num_board_dig_in_channels;
        else
            texttoshow = [texttoshow;" 0 Digital Channel"];
        end
    
        if NumChannel.num_board_adc_channels > 0
            texttoshow = [texttoshow;strcat(num2str(NumChannel.num_board_adc_channels)," Analog Channel")];
            EventInfo.ADCChannel = 1:NumChannel.num_board_adc_channels;
        else
            texttoshow = [texttoshow;" 0 Analog Channel"];
        end
    
        if NumChannel.aux_input_channels > 0
            texttoshow = [texttoshow;strcat(num2str(NumChannel.aux_input_channels)," Aux Channel")];
            EventInfo.AUXChannel = 1:NumChannel.aux_input_channels;
        else
            texttoshow = [texttoshow;" 0 Aux Channel"];
        end

    else
        FileEndingsExist = 0;
        EventInfo = [];
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
    end
    

elseif strcmp(Data.Info.RecordingType,"Neuralynx") 
    
    % Specify file endings that have to be present in the
    % selected folder to count as a valid source for events.
    [FilePaths] = Utility_Extract_Contents_of_Folder(Path);
    FilesIndex = endsWith(FilePaths, ".nev");
    
    % FileEndingsExist = logical indexing, which indicies have
    % the ending. If all sums are 0, there was no file ending
    
    if sum(FilesIndex)==0
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
        FileEndingsExist = 0;
        EventInfo = [];
    else
        EventInfo.IndexEventFile = find(FilesIndex==1);  
        EventInfo.IndexAllIndex = FilesIndex;
        FileEndingsExist = 1;
    end
    
elseif strcmp(Data.Info.RecordingType,"Open Ephys") 

    if isfield(Data.Info,'startTimestamp')
        startTimestamp = round(Data.Info.startTimestamp*Data.Info.NativeSamplingRate);
    else
        msgbox("Warning: No aquisition start time stamp found. Cannot correct event times if recording and aquistion start are different.")
    end

    [EventInfo,Info] = Extract_Events_Module_Extract_Open_Ephys_Events(Data,Path,"Get Information",[],[],[],[],startTimestamp,Data.Info.AllRecordingIndicies);

    [FilePaths] = Utility_Extract_Contents_of_Folder(Path);

    if ~isempty(EventInfo)
        FileEndingsExist = 1;
        texttoshow = strcat("Finished looking for event channel from: ",Path);
    else
        texttoshow = "Warning: No event data found in folder the dataset was extracted from. Please select a different folder.";
        FileEndingsExist = 0;
        EventInfo = [];
    end

elseif strcmp(Data.Info.RecordingType,"Spike2") 
    if isfield(Data.Info,'Spike2EventChannelToTake')
        if ~isempty(Data.Info.Spike2EventChannelToTake)
            EventInfo.EventChannel = Data.Info.Spike2EventChannelToTake;
            FileEndingsExist = 1;
            texttoshow = strcat("Finished looking for event channel from: ",Path);
        else
            texttoshow = "Warning: No event channel selected when loading the dataset. No events can be extracted";
            FileEndingsExist = 0;
            EventInfo = [];
        end
    else
        texttoshow = "Warning: No event channel selected when loading the dataset. No events can be extracted";
        FileEndingsExist = 0;
        EventInfo = [];
    end

elseif strcmp(Data.Info.RecordingType,"TDT Tank Data") 
    %% get start and stop sample for data extractikon
    if ~strcmp(FileType,'NoDataExtraction')
        if strcmp(Data.Info.SelectedRecordingTdT,"Wide")
            Widemeta = TDTbin2mat(Path, ...
                  'TYPE', {'streams'}, ...
                  'STORE', {'Wide'}, ...
                  'HEADERS', 1);
            %% Determine TIME!(s) to extract if only specific time points extracted
            SplitString = strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,',');
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
        elseif  strcmp(Data.Info.SelectedRecordingTdT,"Wave")
            %% check if wide data stored (preffered)
            Wavemeta = TDTbin2mat(Path, ...
                          'TYPE', {'streams'}, ...
                          'STORE', {'Wave'}, ...
                          'HEADERS', 1);
            %% Determine TIME!(s) to extract if only specific time points extracted
            SplitString = strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,',');
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

        elseif  strcmp(Data.Info.SelectedRecordingTdT,"Spik")
            SpikeMeta = TDTbin2mat(Path, ...
                          'TYPE', {'streams'}, ...
                          'STORE', {'Spik'}, ...
                          'HEADERS', 1);
            %% Determine TIME!(s) to extract if only specific time points extracted
            SplitString = strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,',');
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
        end

        %data = TDTbin2mat(Path);
        data = TDTbin2mat(Path, 'T1',StartSample,'T2', StopSample);

    end
  
    %% File Paths
    [FilePaths] = Utility_Extract_Contents_of_Folder(Path);
    FilesIndex = endsWith(FilePaths, ".sev");
        
    texttoshow = [];
    if ~strcmp(FileType,'NoDataExtraction')
        % Define the possible event categories
        categories = {'epocs','snips','scalars','streams'};
        
        allEvents = strings(0); % initialize empty string array
        
        for c = 1:numel(categories)
            catName = categories{c};
            if isfield(data, catName)
                if ~isempty(data.(catName))
                    eventNames = fieldnames(data.(catName));
                    if strcmp(catName,'streams')
                        for i = 1:length(eventNames)
                            if strcmp(eventNames{i},'Stim')
                                % prepend the category name for clarity
                                allEvents = [allEvents; strcat(catName, ":", string(eventNames{i}))];
                              
                            end
                        end
                    else
                        if ~isempty(eventNames)
                            % prepend the category name for clarity
                            allEvents = [allEvents; strcat(catName, ":", string(eventNames))];
                        end
                    end
                end
            end
        end
        
        FileEndingsExist = 1;
        if isempty(allEvents)
            texttoshow = "Warning: No event channel data component found!";
            FileEndingsExist = 0;
            EventInfo = [];
        end
        
        if find(allEvents=='scalars:Evnt')
            uniquechannel = double(unique(data.scalars.Evnt.chan));
            EventInfo.sE.EventChannel = uniquechannel;
            EventInfo.Type{1} = 'scalars:Evnt';
            EventInfo.sE.ChannelIdentities = [];
            EventInfo.sE.Timestamps = [];
            for i = 1:length(uniquechannel)
                IndiceCurrentChannel = data.scalars.Evnt.chan==uniquechannel(i);
                EventInfo.sE.Timestamps = [EventInfo.sE.Timestamps,round(data.scalars.Evnt.ts(IndiceCurrentChannel).*Data.Info.NativeSamplingRate)];
                EventInfo.sE.ChannelIdentities  = [EventInfo.sE.ChannelIdentities,data.scalars.Evnt.chan(IndiceCurrentChannel)];
            end
            % Correct Infite time points
            InfIndice = EventInfo.sE.Timestamps==Inf;
            EventInfo.sE.Timestamps(InfIndice) = [];
            EventInfo.sE.ChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end

            texttoshow = "Event data of type scalars:Evnt found!";
        end
    
        if find(allEvents=='scalars:Tria')
            uniquechannel = double(unique(data.scalars.Tria.chan));
            EventInfo.sT.EventChannel = uniquechannel;
            EventInfo.sT.ChannelIdentities = [];
            EventInfo.sT.Timestamps = [];
            for i = 1:length(uniquechannel)
                IndiceCurrentChannel = data.scalars.Tria.chan==uniquechannel(i);
                EventInfo.sT.Timestamps = [EventInfo.sT.Timestamps,round(data.scalars.Tria.ts(IndiceCurrentChannel).*Data.Info.NativeSamplingRate)];
                EventInfo.sT.ChannelIdentities  = [EventInfo.sT.ChannelIdentities,data.scalars.Tria.chan(IndiceCurrentChannel)];
            end
            if ~isfield(EventInfo,'Type')
                EventInfo.Type{1} = 'scalars:Tria';
            else
                EventInfo.Type{end+1} = 'scalars:Tria';
            end

            % Correct Infite time points
            InfIndice = EventInfo.sT.Timestamps==Inf;
            EventInfo.sT.Timestamps(InfIndice) = [];
            EventInfo.sT.ChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end

            texttoshow = "Event data of type scalars:Evnt found!";
        end
        
        if find(allEvents=='epocs:Evnt')
            EventInfo.eE.EventChannel = 1:length(data.epocs.Evnt);
            EventInfo.eE.OnsetChannelIdentities = [];
            EventInfo.eE.OffsetChannelIdentities = [];
            EventInfo.eE.OnsetTimestamps = [];
            EventInfo.eE.OffsetTimestamps = [];
            for i = 1:length(data.epocs.Evnt)
                EventInfo.eE.OnsetTimestamps = [EventInfo.eE.OnsetTimestamps,round(double(unique(data.epocs.Evnt(i).onset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eE.OffsetTimestamps = [EventInfo.eE.OffsetTimestamps,round(double(unique(data.epocs.Evnt(i).offset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eE.OnsetChannelIdentities  = [EventInfo.eE.OnsetChannelIdentities,zeros(size(round(double(unique(data.epocs.Evnt(i).onset)).*Data.Info.NativeSamplingRate)))+i];
            end

            EventInfo.eE.OffsetChannelIdentities = EventInfo.eE.OnsetChannelIdentities;

            if ~isfield(EventInfo,'Type')
                EventInfo.Type{1} = 'epocs:Evnt';
            else
                EventInfo.Type{end+1} = 'epocs:Evnt';
            end
            
            % Correct Infite time points Onset
            InfIndice = EventInfo.eE.OnsetTimestamps==Inf;
            EventInfo.eE.OnsetTimestamps(InfIndice) = [];
            EventInfo.eE.OnsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
            % Correct Infite time points Offset
            InfIndice = EventInfo.eE.OffsetTimestamps==Inf;
            EventInfo.eE.OffsetTimestamps(InfIndice) = [];
            EventInfo.eE.OffsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end

            texttoshow = "Event data of type epocs:Evnt found!";
        end

        if find(allEvents=='epocs:Tria')
            EventInfo.eTr.EventChannel = 1:length(data.epocs.Tria);
            EventInfo.eTr.OnsetChannelIdentities = [];
            EventInfo.eTr.OffsetChannelIdentities = [];
            EventInfo.eTr.OnsetTimestamps = [];
            EventInfo.eTr.OffsetTimestamps = [];
            for i = 1:length(data.epocs.Tria)
                EventInfo.eTr.OnsetTimestamps = [EventInfo.eTr.OnsetTimestamps,round(double(unique(data.epocs.Tria(i).onset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eTr.OffsetTimestamps = [EventInfo.eTr.OffsetTimestamps,round(double(unique(data.epocs.Tria(i).offset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eTr.OnsetChannelIdentities  = [EventInfo.eTr.OnsetChannelIdentities,zeros(size(round(double(unique(data.epocs.Tria(i).onset)).*Data.Info.NativeSamplingRate)))+i];
            end
            EventInfo.eTr.OffsetChannelIdentities = EventInfo.eTr.OnsetChannelIdentities;
            if ~isfield(EventInfo,'Type')
                EventInfo.Type{1} = 'epocs:Tria';
            else
                EventInfo.Type{end+1} = 'epocs:Tria';
            end

            % Correct Infite time points Onset
            InfIndice = EventInfo.eTr.OnsetTimestamps==Inf;
            EventInfo.eTr.OnsetTimestamps(InfIndice) = [];
            EventInfo.eTr.OnsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
            % Correct Infite time points Offset
            InfIndice = EventInfo.eTr.OffsetTimestamps==Inf;
            EventInfo.eTr.OffsetTimestamps(InfIndice) = [];
            EventInfo.eTr.OffsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
    
            texttoshow = "Event data of type epocs:Tria found!";
        end

        if find(allEvents=='epocs:Brst')
            EventInfo.eB.EventChannel = 1:length(data.epocs.Brst);
            EventInfo.eB.OnsetChannelIdentities = [];
            EventInfo.eB.OffsetChannelIdentities = [];
            EventInfo.eB.OnsetTimestamps = [];
            EventInfo.eB.OffsetTimestamps = [];
            for i = 1:length(data.epocs.Brst)
                EventInfo.eB.OnsetTimestamps = [EventInfo.eB.OnsetTimestamps,round(double(unique(data.epocs.Brst(i).onset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eB.OffsetTimestamps = [EventInfo.eB.OffsetTimestamps,round(double(unique(data.epocs.Brst(i).offset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eB.OnsetChannelIdentities  = [EventInfo.eB.OnsetChannelIdentities,zeros(size(round(double(unique(data.epocs.Brst(i).onset)).*Data.Info.NativeSamplingRate)))+i];
            end
            EventInfo.eB.OffsetChannelIdentities = EventInfo.eB.OnsetChannelIdentities;
            if ~isfield(EventInfo,'Type')
                EventInfo.Type{1} = 'epocs:Brst';
            else
                EventInfo.Type{end+1} = 'epocs:Brst';
            end

            % Correct Infite time points Onset
            InfIndice = EventInfo.eB.OnsetTimestamps==Inf;
            EventInfo.eB.OnsetTimestamps(InfIndice) = [];
            EventInfo.eB.OnsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
            % Correct Infite time points Offset
            InfIndice = EventInfo.eB.OffsetTimestamps==Inf;
            EventInfo.eB.OffsetTimestamps(InfIndice) = [];
            EventInfo.eB.OffsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
    
            texttoshow = "Event data of type epocs:Brst found!";
        end

        if find(allEvents=='epocs:Stro')
            EventInfo.eS.EventChannel = 1:length(data.epocs.Stro);
            EventInfo.eS.OnsetChannelIdentities = [];
            EventInfo.eS.OffsetChannelIdentities = [];
            EventInfo.eS.OnsetTimestamps = [];
            EventInfo.eS.OffsetTimestamps = [];
            for i = 1:length(data.epocs.Stro)
                EventInfo.eS.OnsetTimestamps = [EventInfo.eS.OnsetTimestamps,round(double(unique(data.epocs.Stro(i).onset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eS.OffsetTimestamps = [EventInfo.eS.OffsetTimestamps,round(double(unique(data.epocs.Stro(i).offset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eS.OnsetChannelIdentities  = [EventInfo.eS.OnsetChannelIdentities,zeros(size(round(double(unique(data.epocs.Stro(i).onset)).*Data.Info.NativeSamplingRate)))+i];
            end
            EventInfo.eS.OffsetChannelIdentities = EventInfo.eS.OnsetChannelIdentities;
            if ~isfield(EventInfo,'Type')
                EventInfo.Type{1} = 'epocs:Stro';
            else
                EventInfo.Type{end+1} = 'epocs:Stro';
            end

            % Correct Infite time points Onset
            InfIndice = EventInfo.eS.OnsetTimestamps==Inf;
            EventInfo.eS.OnsetTimestamps(InfIndice) = [];
            EventInfo.eS.OnsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
            % Correct Infite time points Offset
            InfIndice = EventInfo.eS.OffsetTimestamps==Inf;
            EventInfo.eS.OffsetTimestamps(InfIndice) = [];
            EventInfo.eS.OffsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
    
            texttoshow = "Event data of type epocs:Stro found!";
        end
        
        if find(allEvents=='epocs:Tick')
            EventInfo.eT.EventChannel = 1:length(data.epocs.Tick);
            EventInfo.eT.OnsetChannelIdentities = [];
            EventInfo.eT.OffsetChannelIdentities = [];
            EventInfo.eT.OnsetTimestamps = [];
            EventInfo.eT.OffsetTimestamps = [];
            for i = 1:length(data.epocs.Tick)
                EventInfo.eT.OnsetTimestamps = [EventInfo.eT.OnsetTimestamps,round(double(unique(data.epocs.Tick(i).onset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eT.OffsetTimestamps = [EventInfo.eT.OffsetTimestamps,round(double(unique(data.epocs.Tick(i).offset)).*Data.Info.NativeSamplingRate)];% in samples
                EventInfo.eT.OnsetChannelIdentities  = [EventInfo.eT.OnsetChannelIdentities,zeros(size(round(double(unique(data.epocs.Tick(i).onset)).*Data.Info.NativeSamplingRate)))+i];
            end
            EventInfo.eT.OffsetChannelIdentities = EventInfo.eT.OnsetChannelIdentities;
            if ~isfield(EventInfo,'Type')
                EventInfo.Type{1} = 'epocs:Tick';
            else
                EventInfo.Type{end+1} = 'epocs:Tick';
            end

            % Correct Infite time points Onset
            InfIndice = EventInfo.eT.OnsetTimestamps==Inf;
            EventInfo.eT.OnsetTimestamps(InfIndice) = [];
            EventInfo.eT.OnsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
            % Correct Infite time points Offset
            InfIndice = EventInfo.eT.OffsetTimestamps==Inf;
            EventInfo.eT.OffsetTimestamps(InfIndice) = [];
            EventInfo.eT.OffsetChannelIdentities(InfIndice) = [];
            if sum(InfIndice)>0
                disp("Inf sample found and deleted!")
            end
    
            texttoshow = "Event data of type epocs:Tick found!";
        end
    end
end           