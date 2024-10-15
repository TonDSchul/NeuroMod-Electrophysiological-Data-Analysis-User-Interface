function [Data,Header,SampleRate] = Open_Ephys_Load_All_Formats(DATA_PATH,nRecordNodes,SelectedRecordNode)

%________________________________________________________________________________________

%% This is the main function to extract Open Ephys Data 
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
% 1. Data: nchannel x ntimespoints single matrix with extracted raw data
% 2. Header: structure containing header infos of recording. This get Data.Info later
% 3. SampleRate: Sample Rate as double in Hz

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Data = [];
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
if length(node.recordings)>1
    disp("Error: Only one recording at a time supported. Selecting just the first one! If you want to change it, go to function Open_Ephys_Load_All_Formats, line 64 and change the NodeIndex variable")
    NodeIndex = 1;
else
    NodeIndex = 1;
end

% Get the first recording 
recording = node.recordings{1,NodeIndex};

% Iterate over all data streams in the recording 
streamNames = recording.continuous.keys();

if isempty(streamNames)
    disp("Error: No stream names found. Please select a different Recording Node!");
    return;
end

if isempty(recording.continuous)
    disp("Error: No continous data found. Please select a different Recording Node!");
    return;
end

disp("Num of Processor ID's: ",num2str(length(streamNames)));

if length(streamNames)>1 %% Not yet implemented but importantn for neuropixels
    disp("Can not handle multiple Processor ID's yet!! Skipping Node.")
end

for k = 1:length(streamNames) % if node contains continous data. It can have multiple processor streams

    streamName = streamNames{k};
    
    % 1. Get the continuous data from the current stream/recording
    TempData = recording.continuous(streamName);

    if strcmp(node.format,'Binary')

        Header = TempData.metadata;
        
        % Delete Info fields saved as cells that can not be displayed
        % as information 
        % Get all field names of the structure
        fields = fieldnames(Header);

        % Loop through each field
        for o = 1:numel(fields)
            fieldName = fields{o};

            % Check if the field contains a cell
            if iscell(Header.(fieldName))
                % Delete the field
                Header = rmfield(Header, fieldName);
            end
        end

        %% Differentiate Data and peripheral (ADC) channel
        DataChannel = [];
        NoDataChannel = [];
        for i = 1:length(TempData.metadata.names)
            if contains(TempData.metadata.names{i},'CH')
                DataChannel = [DataChannel,i];
            else
                NoDataChannel = [NoDataChannel,i];
            end
        end

        
        disp(strcat("Found ",num2str(length(NoDataChannel))," peripheral input channel"));
        Data = single(TempData.samples(DataChannel,:));

        %% Convert int16 to mV
        Temp = node.recordings{1, 1};
        if isprop(Temp,'info')
            if isfield(Temp.info.continuous.channels,'bit_volts')
                Bits = Temp.info.continuous.channels.bit_volts;
                Data = (Data.*Bits)./1000; % convert uV in mV
                Header.Bit_Volts = Bits;
                disp(strcat("Bit_Volts Property for AD conversion to mV found."));
            else
                disp(strcat("Bit_Volts Property for AD conversion to mV not found. Data can only be shown as integers"));
            end
        end

        %% Define Header
        Header.startTimestamp = TempData.metadata.startTimestamp;
        Header.NrChannel = size(Data,1);
        Header.num_data_points = size(Data,2);
        Header.Format = node.format;
        Header.RecordingNode = node.name;
        SampleRate = TempData.metadata.sampleRate;% Gets added to info in main function

    elseif strcmp(node.format,'NWB')
    
        Header = TempData.metadata;

        DataChannelIndicie = Header.conversion==Header.conversion(1);

        Data = single(TempData.samples(DataChannelIndicie,:));

        BitConversions = Header.conversion(DataChannelIndicie); % Convert Volt in mV
        
        % Dont get info which channel are adc. Therefore, bit conversion is
        % used -- different for data and adc. Assumption: first conversion
        % is for first data channel.
        % Alternativly: data channel conversion has more elements, but prb.
        % even less robust
        
        %% Convert int16 to mV
        if isfield(Header,'conversion')
            disp(strcat("Bit_Volts Property for AD conversion to mV found in conversion field of header info. Field is renamed into 'Bit_Volts'"));
            for i = 1:length(BitConversions)
                Data(i,:) = (Data(i,:).*BitConversions(i)).*1000; % Convert Volt in mV
            end
            Header.Bit_Volts = Header.conversion;
            % Delete 'field2' from the structure
            Header = rmfield(Header, 'conversion');
        else
            disp(strcat("Bit_Volts Property for AD conversion to mV not found. Data can only be shown as integers"));
        end

        %% Define Header
        Header.Format = node.format;
        Header.RecordingNode = node.name;
        Header.NrChannel = size(Data,1);
        Header.num_data_points = size(Data,2);
        
        TimeInRecording = TempData.timestamps(end)-TempData.timestamps(1);
        SampleRate = round(length(TempData.timestamps)/TimeInRecording); % Gets added to info in main function

    elseif strcmp(node.format,'OpenEphys')
        %% This contains relevant header infos (samplerate and bit_volts) for this format
        TempHeader = recording.streams((streamName));

        % Differentiate Data and peripheral (ADC) channel
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
        %% Get Data
        Data = single(TempData.samples(DataChannel,:));
        %% Convert int16 to mV
        for i = 1:length(DataChannel)
            Data(i,:) = (Data(i,:).*TempHeader.channels{1,DataChannel(i)}.bitVolts)./1000; % Convert uV in mV
        end
        %% Define Header
        Header.Format = node.format;
        Header.RecordingNode = node.name;
        Header.startTimestamp = TempData.metadata.startTimestamp;
        Header.Bit_Volts = TempHeader.channels{1,DataChannel(1)}.bitVolts;
        Header.NrChannel = size(Data,1);
        Header.num_data_points = size(Data,2);
        SampleRate = TempHeader.sampleRate;

    end
           
    count = count + 1;

    msg = sprintf('Extracting Data... (%d%% done)', 50);
    waitbar(0.5, h, msg);

end % Stream name

%% if conversion not yet found: prb just nwb recording node. Then bitvolts is saves as conversion in conversion field

if ~isfield(Header,'Bit_Volts')
    disp(strcat("Bit_Volts Property for AD conversion to mV not found. Data can only be shown as integers"));
end

msg = sprintf('Extracting Data... (%d%% done)', 100);
waitbar(1, h, msg);

if exist('h','var')
    close(h);
end
