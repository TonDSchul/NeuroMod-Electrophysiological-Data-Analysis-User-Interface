function [EventInfo,Errormessage,NewPath,outputLines] = Import_Events_Read_File(EventInfo)

%________________________________________________________________________________________
%% Function to read a file holding event time stamps to import

% Inputs:
% 1. EventInfo: output struc of this function in case user clicks to load
% another file but cancels selection --> dont want to erase everything
% loaded before if it was an accident

% Outputs:
% 1 .EventInfo: struc holding event info loaded from selected file with
% fields TempEvents as cell array with time stamps for each event channel
% pretty much the finsihed Data.Events already, just has to be 'cleaned' by
% checking time violations etc. 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if ~isempty(EventInfo)
    EventInfo = [];
end

outputLines = [];
NewPath = [];
Errormessage = [];

%% Get user selcted a csv or txt
% Prompt the user to select a folder
% Open file explorer to select a .csv or .txt file
[filename, pathname] = uigetfile({'*.csv;*.txt', 'CSV and Text Files (*.csv, *.txt)'}, ...
                                 'Select a CSV or TXT file');

% Check if the user canceled the dialog
if isequal(filename, 0)
    disp('Selection canceled.');
    return
else
    NewPath = fullfile(pathname, filename);
end

% Read file lines
lines = readlines(NewPath);
            
% Initialize cell array to hold event vectors
Testdata = {};

% Loop through each line
for i = 1:numel(lines)
    line = strtrim(lines(i));  % Remove leading/trailing whitespace
    if startsWith(line, "Event Nr") || startsWith(line, "Event")
        % Split by commas
        parts = split(line, ',');
        pointindicie = find(parts{1}==':');
        if isempty(pointindicie)
            msgbox("Warning: One line found without a ':' after the event name and before data starts!")
        end

        parts{1} = parts{1}(pointindicie+1:end);
       
        % Extract numeric part (skip the first element which is the label)
        numericValues = str2double(parts(1:end));
        
        % Store in events cell
        Testdata{end+1} = numericValues;
    else
        msgbox("Line found that didnt start with an event name.");
    end
    
end

if isempty(Testdata)
    Errormessage = ("Error: File did not contain expected content. Make sure event/TTL data starts with 'Event Nr 1:' followed by numbers (without spaces) separated with a comma. See the 'Show Example Files' tab on top of this window.");
    return
end

for i = 1:length(Testdata)
    Testdata{i} = Testdata{i}';
end

% Initialize a string array to hold each block of output
outputLines = strings(0, 1);  % Empty column vector of strings

IsMissingNumber = [];
% Loop through all events
for idx = 1:numel(Testdata)
    % Get the data
    data = Testdata{idx};

    % Convert to comma-separated string
    dataStr = strjoin(string(data), ', ');
    
    if ismissing(dataStr)
        IsMissingNumber = idx;
        continue;
    end
    % Add header and data as separate lines
    outputLines(end+1) = sprintf('Event Nr: %d', idx);
    outputLines(end+1) = dataStr;
end

if length(IsMissingNumber) == length(Testdata)
    Errormessage = ("Error: File did not contain expected content (no numbers found after event names, ensure event names are followed by a ':'). Make sure event/TTL data starts with 'Event Nr 1:' followed by numbers (without spaces) separated with a comma. See the 'Show Example Files' tab on top of this window.");
    return
end

NewTestData = {};
if ~isempty(IsMissingNumber)
    for i = 1:numel(Testdata)
        if isempty(find(i == IsMissingNumber))
            if isempty(NewTestData)
                NewTestData{1} = Testdata{i};
            else
                NewTestData{end+1} = Testdata{i};
            end
        end
    end
    Testdata = NewTestData;
end

Errormessage = [];
if isempty(Testdata)
    Errormessage = ("Error: File did not contain expected content. Make sure event/TTL data starts with 'Event Nr 1:' followed by numbers (without spaces) separated with a comma. See the 'Show Example Files' tab on top of this window.");
    
    return
end

EventInfo.NumberEvents = length(Testdata);
EventInfo.TempEvents = Testdata;
EventInfo.EventNames = [];

for i = 1:length(Testdata)
    if i ~= 1
        EventInfo.EventNames = [EventInfo.EventNames,',',strcat('Event TTL Nr. ', num2str(i))];
    else
        EventInfo.EventNames = [EventInfo.EventNames,strcat('Event TTL Nr. ', num2str(i))];
    end
end



