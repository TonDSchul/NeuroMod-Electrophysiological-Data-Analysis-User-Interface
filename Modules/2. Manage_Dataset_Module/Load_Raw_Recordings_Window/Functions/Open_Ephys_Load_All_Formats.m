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

for j = 1:length(node.recordings)

    % Get the first recording 
    recording = node.recordings{1,j};

    % Iterate over all data streams in the recording 
    streamNames = recording.continuous.keys();

    AllIterations = length(node.recordings)*length(streamNames);

    for k = 1:length(streamNames)

        streamName = streamNames{k};
        disp(streamName)

        % 1. Get the continuous data from the current stream/recording
        TempData = recording.continuous(streamName);
        
        Data = TempData.samples;
        %% Convert int16 to mV
        Data = single(Data);
        Temp = node.recordings{1, 1};
        if isprop(Temp,'info')
            if isfield(Temp.info.continuous.channels,'bit_volts')
                Bits = Temp.info.continuous.channels.bit_volts;
                Data = (Data.*Bits)./1000;
            end
        end

        if isempty(SampleRate)
            Header = TempData.metadata;
            if isprop(Temp,'info')
                if isfield(Temp.info.continuous.channels,'bit_volts')
                    Header.Bit_Volts = Temp.info.continuous.channels.bit_volts;
                end
            end

            Header.Nodes = session.recordNodes{SelectedRecordNode};
            fields = fieldnames(Header.Nodes);
            for l = 1:numel(fields)
                Header.(fields{l}) = Header.Nodes.(fields{l});  % Add fields from a to b
            end
            
            % Remove the original field 'subStruct' if you want
            Header = rmfield(Header, 'Nodes');

            % for Broadband Data
            if isfield(TempData.metadata,'sampleRate')
                SampleRate = TempData.metadata.sampleRate;
            else % for Low or High Pass filtered data
                SampleRate = round(length(TempData.timestamps)/TempData.timestamps(end));
            end

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
        end
       
        count = count + 1;

        msg = sprintf('Extracting Data... (%d%% done)', 50);
        waitbar(0.5, h, msg);

    end % Stream name
end % node.recordings

if ~isfield(Header,'Bit_Volts')
    disp("Couldnt find Bit_Volts Property for AD conversion to mV. Searching the other recording nodes.")
    for nNodes = 1:nRecordNodes
        node = session.recordNodes{nNodes};
        for j = 1:length(node.recordings)
            % Get the first recording 
            recording = node.recordings{1,j};
        
            % Iterate over all data streams in the recording 
            streamNames = recording.continuous.keys();
        
            AllIterations = length(node.recordings)*length(streamNames);
        
            for k = 1:length(streamNames)
        
                %% Convert int16 to mV
                Data = single(Data);
                Temp = node.recordings{1, 1};
                if isprop(Temp,'info')
                    if isfield(Temp.info.continuous.channels,'bit_volts')
                        Bits = Temp.info.continuous.channels.bit_volts;
                        Data = (Data.*Bits)./1000;
                    end
                end
                if isprop(Temp,'info')
                    if isfield(Temp.info.continuous.channels,'bit_volts')
                        Header.Bit_Volts = Temp.info.continuous.channels.bit_volts;
                        disp(strcat("Bit_Volts Property for AD conversion to mV found in node nr ",num2str(nNodes)));   
                        msg = sprintf('Extracting Data... (%d%% done)', 100);
                        waitbar(1, h, msg);
                    end
                end
            end
        end
    end
else
    msg = sprintf('Extracting Data... (%d%% done)', 100);
    waitbar(1, h, msg);
end

if ~isfield(Header,'Bit_Volts')
    disp(strcat("Bit_Volts Property for AD conversion to mV not found. Data can only be shown as integers"));
end

if exist('h','var')
    close(h);
end
