function [StringFileContents,EventInfo] = Import_Events_Read_File(EventInfo,EventNamesField)

%________________________________________________________________________________________
%% Function to add imported events to the main window data structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if ~isempty(EventInfo)
    EventInfo = [];
end

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
    if startsWith(line, "Event Nr")
        % Split by commas
        parts = split(line, ',');
        pointindicie = find(parts{1}==':');
        
        parts{1} = parts{1}(pointindicie+1:end);
       
        % Extract numeric part (skip the first element which is the label)
        numericValues = str2double(parts(1:end));
        
        % Store in events cell
        Testdata{end+1} = numericValues;
    end
end

for i = 1:length(Testdata)
    Testdata{i} = Testdata{i}';
end

% Initialize a string array to hold each block of output
StringFileContents = strings(0, 1);  % Empty column vector of strings

% Loop through all events
for idx = 1:numel(Testdata)
    % Get the data
    data = Testdata{idx};

    % Convert to comma-separated string
    dataStr = strjoin(string(data), ', ');

    % Add header and data as separate lines
    StringFileContents(end+1) = sprintf('Event Nr: %d', idx);
    StringFileContents(end+1) = dataStr;
end

EventInfo.Path = NewPath;
EventInfo.NumberEvents = length(Testdata);
EventInfo.TempEvents = Testdata;
EventInfo.EventNames = EventNamesField;