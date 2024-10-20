function [Data,Header,SampleRate] = Open_Ephys_Load_All_Formats(DATA_PATH,nRecordNodes,SelectedRecordNode)

%________________________________________________________________________________________

%% This is the main function to extract Open Ephys TempData 
% This function utilizes functions and some analysis workflows as well as
% example data from the analysis-tools Github project from jsiegle
% available at https://github.com/open-ephys/analysis-tools as well as the open-ephys-matlab-tools
% Matlab file exchange project https://de.mathworks.com/matlabcentral/fileexchange/122372-open-ephys-matlab-tools

% functions necessary from these sources that are used here were not modified, this code is
% self written based on the load_all_formats function in the example
% folder
% functions used: 1. Session

% This gets called in the
% 'Manage_Dataset_Module_Extract_Raw_Recording_Main' function when Open Ephys is
% identified as the recording system

% Input:
% 1. DATA_PATH: path as char to folder containing the recording
% 2: nRecordNodes: double number of recording nodes found in the selected
% recordingfolder (basically nr of folder contents of open ephys recording folder)
% 3. SelectedRecordNode: Index number as double, which recording node was
% selected for analysis. This is basically the index of folder contents
% that are supposed to be analysed
% i.e.: foldercontents = ["Record Node 101", "Record Node 105", "Record
% Node 113"] --> nRecordNodes = 3
% If user selects Record Node 105 as the node to analyze in the extract raw
% data app window, SelectedRecordNode = 2

% Output: 
% 1. TempData: nchannel x ntimespoints single matrix with extracted raw data
% 2. TempHeader: structure containing header infos of recording. This get TempData.Info later
% 3. SampleRate: Sample Rate as double in Hz

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Data = [];
Header = [];
TempData = [];
ContinousStream = [];
TempHeader = [];

Header.startTimestamp = [];

SampleRate = [];

% "Import" matlab-tools
addpath(genpath("."));

% % Test parameters used (either manually or via python-tools script)
RECORDING_FORMATS_TO_TEST = ["Binary", "NWB2", "Open Ephys"];

count = 1;

h = waitbar(0, 'Extracting Data...', 'Name','Extracting Data...');

% Create a session (loads all data from the most recent recording)
session = Session(DATA_PATH);

% Iterate over the record nodes to access data

node = session.recordNodes{SelectedRecordNode};

% Starting and stopped recording (but not acquisition) in the GUI will initiate a new "recording."
% --> check wheter aquisition was started

NumRecordingIndex = length(node.recordings);

if NumRecordingIndex>1

    disp(strcat("Found ",num2str(NumRecordingIndex)," recordings. Please select whether to extract them seperately or together!"));

    OERecordings = OE_Multiple_Recording_Selection(NumRecordingIndex);
    
    uiwait(OERecordings.SelectRecordingWindowUIFigure);
    
    if isvalid(OERecordings)
        NumRecordingIndex = length(OERecordings.SelectedRecordings);
        AllRecordingIndicies = OERecordings.SelectedRecordings;
        delete(OERecordings);
    else
        disp("Error: No valid recording selection found. Proceeding with analysing all recordings.")
        AllRecordingIndicies = 1:NumRecordingIndex;
    end
    
else
    NumRecordingIndex = 1;
    AllRecordingIndicies = 1;
    disp("One recording found and extracted.");
end

for RecordingIndex = 1:NumRecordingIndex

    disp(strcat("Extracting Recording ",num2str(AllRecordingIndicies(RecordingIndex))))

    % Get the first recording 
    recording = node.recordings{1,AllRecordingIndicies(RecordingIndex)};
    
    % Iterate over all data streams in the recording 
    streamNames = recording.continuous.keys();
    
    if isempty(streamNames)
        if NumRecordingIndex>1
            disp("Error: No stream names found. Skipping Recording!");
            continue;
        else
            disp("Error: No stream names found. Please select a different Recording Node!");
            return;
        end
    end
    
    if isempty(recording.continuous)
        if NumRecordingIndex>1
            disp("Error: No continous data found. Skipping Recording!");
            continue;
        else
            disp("Error: No continous data found. Please select a different Recording Node!");
            return;
        end
    end
    
    disp(strcat("Num of Processor ID's: ",num2str(length(streamNames))));
    
    if length(streamNames)>1 %% Not yet implemented but importantn for neuropixels
        disp("Can not handle multiple Processor ID's yet!! Taking first processor ID only.")
        streamIndex = 1;
    else
        streamIndex = 1;
    end
    
    for k = 1:1 % --- To Do: for neuropixels necesary to support multiple streams
        streamName = streamNames{streamIndex};
        
        % 1. Get the continuous data from the current stream/recording
        ContinousStream = recording.continuous(streamName);
    
        if strcmp(node.format,'Binary')
    
            TempHeader = ContinousStream.metadata;
            
            % Delete Info fields saved as cells that can not be displayed
            % as information 
            % Get all field names of the structure
            fields = fieldnames(TempHeader);
    
            % Loop through each field
            for o = 1:numel(fields)
                fieldName = fields{o};
    
                % Check if the field contains a cell
                if iscell(TempHeader.(fieldName))
                    % Delete the field
                    TempHeader = rmfield(TempHeader, fieldName);
                end
            end
    
            %% Differentiate TempData and peripheral (ADC) channel
            DataChannel = [];
            NoDataChannel = [];
            for i = 1:length(ContinousStream.metadata.names)
                if contains(ContinousStream.metadata.names{i},'CH')
                    DataChannel = [DataChannel,i];
                else
                    NoDataChannel = [NoDataChannel,i];
                end
            end
  
            disp(strcat("Found ",num2str(length(NoDataChannel))," peripheral input channel"));
            TempData = single(ContinousStream.samples(DataChannel,:));
    
            %% Convert int16 to mV
            Temp = node.recordings{1, 1};
            if isprop(Temp,'info')
                if isfield(Temp.info.continuous.channels,'bit_volts')
                    Bits = Temp.info.continuous.channels.bit_volts;
                    TempData = (TempData.*Bits)./1000; % convert uV in mV
                    TempHeader.Bit_Volts = Bits;
                    disp(strcat("Bit_Volts Property for AD conversion to mV found."));
                else
                    disp(strcat("Bit_Volts Property for AD conversion to mV not found. TempData can only be shown as integers"));
                end
            end
    
            %% Define TempHeader
            TempHeader.startTimestamp = ContinousStream.metadata.startTimestamp;
            TempHeader.NrChannel = size(TempData,1);
            TempHeader.num_data_points = size(TempData,2);
            TempHeader.Format = node.format;
            TempHeader.RecordingNode = node.name;
            TempHeader.AllRecordingIndicies = AllRecordingIndicies;
            SampleRate = ContinousStream.metadata.sampleRate;% Gets added to info in main function
    
        elseif strcmp(node.format,'NWB')
        
            TempHeader = ContinousStream.metadata;
    
            DataChannelIndicie = TempHeader.conversion==TempHeader.conversion(1);
    
            TempData = single(ContinousStream.samples(DataChannelIndicie,:));
    
            BitConversions = TempHeader.conversion(DataChannelIndicie); % Convert Volt in mV
            
            % Dont get info which channel are adc. Therefore, bit conversion is
            % used -- different for data and adc. Assumption: first conversion
            % is for first data channel.
            % Alternativly: data channel conversion has more elements, but prb.
            % even less robust
            
            %% Convert int16 to mV
            if isfield(TempHeader,'conversion')
                disp(strcat("Bit_Volts Property for AD conversion to mV found in conversion field of header info. Field is renamed into 'Bit_Volts'"));
                for i = 1:length(BitConversions)
                    TempData(i,:) = (TempData(i,:).*BitConversions(i)).*1000; % Convert Volt in mV
                end
                TempHeader.Bit_Volts = TempHeader.conversion;
                % Delete 'field2' from the structure
                TempHeader = rmfield(TempHeader, 'conversion');
            else
                disp(strcat("Bit_Volts Property for AD conversion to mV not found. TempData can only be shown as integers"));
            end
    
            %% Define TempHeader
            TempHeader.Format = node.format;
            TempHeader.RecordingNode = node.name;
            TempHeader.NrChannel = size(TempData,1);
            TempHeader.num_data_points = size(TempData,2);
            TempHeader.AllRecordingIndicies = AllRecordingIndicies;

            % Cant find SR in header info, therefore its calculated
            % Sample number for one second rec. length
            TimetoGetSample = ContinousStream.timestamps(1)+1; %one second
            [~,MinIndicie] = min(abs(ContinousStream.timestamps-TimetoGetSample));
            
            if ContinousStream.timestamps(end)-ContinousStream.timestamps(1) > 1
                SampleRate = (MinIndicie-1)/1;
                SampleRate = round(SampleRate/10000) * 10000;
            else
                msgbox("Error: Recording has to be longer than one second!")
            end
    
        elseif strcmp(node.format,'OpenEphys')
            %% This contains relevant header infos (samplerate and bit_volts) for this format
            TempHeader = recording.streams((streamName));
    
            % Differentiate TempData and peripheral (ADC) channel
            DataChannel = [];
            NoDataChannel = [];
            for i = 1:length(TempHeader.channels)
                if contains(TempHeader.channels{1,i}.name,"CH")
                    DataChannel = [DataChannel,i];
                else
                    NoDataChannel = [NoDataChannel,i];
                end
            end
            
            disp(strcat("Found ",num2str(length(NoDataChannel))," peripheral input channel"));
            %% Get TempData
            TempData = single(ContinousStream.samples(DataChannel,:));
            %% Convert int16 to mV
            for i = 1:length(DataChannel)
                TempData(i,:) = (TempData(i,:).*TempHeader.channels{1,DataChannel(i)}.bitVolts)./1000; % Convert uV in mV
            end
            %% Define TempHeader
            TempHeader.Format = node.format;
            TempHeader.RecordingNode = node.name;
            TempHeader.startTimestamp = ContinousStream.metadata.startTimestamp;
            TempHeader.Bit_Volts = TempHeader.channels{1,DataChannel(1)}.bitVolts;
            TempHeader.NrChannel = size(TempData,1);
            TempHeader.num_data_points = size(TempData,2);
            TempHeader.AllRecordingIndicies = AllRecordingIndicies;
            SampleRate = TempHeader.sampleRate;
    
        end
               
        count = count + 1;
    
        msg = sprintf('Extracting Data... (%d%% done)', 50);
        waitbar(0.5, h, msg);
    
    end % Stream name
    
    %% Combine multiple recordings
    % Header only once
    if RecordingIndex == 1
        Header.NumRecordings = 1;
        Header = TempHeader;
    else
        Header.startTimestamp = [Header.startTimestamp,TempHeader.startTimestamp];
        Header.NumRecordings = RecordingIndex;
    end

    Data = [Data,TempData];

    TempHeader = [];
    TempData = [];
    ContinousStream = [];

end % Nr Recordings

%% if conversion not yet found: prb just nwb recording node. Then bitvolts is saves as conversion in conversion field

if ~isfield(Header,'Bit_Volts')
    disp(strcat("Bit_Volts Property for AD conversion to mV not found. TempData can only be shown as integers"));
end

msg = sprintf('Extracting Data... (%d%% done)', 100);
waitbar(1, h, msg);

if exist('h','var')
    close(h);
end
