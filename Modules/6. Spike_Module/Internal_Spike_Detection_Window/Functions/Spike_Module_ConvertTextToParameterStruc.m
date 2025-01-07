function [Struc] = Spike_Module_ConvertTextToParameterStruc(Text,Sorter,StartStruc)

%________________________________________________________________________________________
%% Function to convert text containing all fields and values of spike sorting parameter strcucture back to a strcuture

%% cleans quotes from values

% Inputs:
% 1. Text: text containing all spike sorting parameter settings 
% 2. Sorter: string, selected sorter, "Mountainsort 5" OR "SpykingCircus 2"
% OR "Kilosort 4"
% 3. StartStruc: only when sorter = "SpykingCircus 2"; standard spike sorting settings structure --> only values
% that changed are interchanged!

% Outputs
% 1. Struc: spike sorting parameter structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if strcmp(Sorter,"Mountainsort 5")  
    % Get the updated Text
    updatedText = Text; % Cell array of strings (one string per line)
    
    % Initialize an empty Struc
    Struc = struct();

    for i = 1:numel(updatedText)
        line = strtrim(updatedText{i}); % Get the line and trim whitespace
        if contains(line, ':')
            % Split into key and value
            keyValue = split(line, ':');
            if numel(keyValue) == 2
                key = strtrim(keyValue{1}); % Extract the key
                value = strtrim(keyValue{2}); % Extract the value
                
                % Convert value to appropriate type
                if strcmpi(value, 'true')
                    value = true;
                elseif strcmpi(value, 'false')
                    value = false;
                elseif ~isnan(str2double(value)) % Check if numeric
                    value = str2double(value);
                else
                    % Leave value as a string
                end
                
                % Assign to the Struc
                Struc.(key) = value;
            end
        end
    end

elseif strcmp(Sorter,"SpykingCircus 2") 
    Struc = StartStruc; % Initialize updated structure

    % Loop through each line in the text area
    for i = 1:length(Text)
        line = strtrim(Text{i}); % Get current line and trim whitespace
        if contains(line, ':') % Check if the line contains a ':'
            % Split into variable name and value
            tokens = split(line, ':');
            if length(tokens) == 2 && ~isempty(tokens{1}) && ~isempty(tokens{2}) 
                paramName = strtrim(tokens{1}); % Name before the ':'
                paramValueStr = strtrim(tokens{2}); % Value after the ':'

                % Convert the value to numeric if possible, otherwise leave as string
                paramValue = str2double(paramValueStr);
                if isnan(paramValue)
                    if isstring(paramValueStr)
                        paramValue = convertStringsToChars(paramValueStr); % Keep as string if conversion fails
                    else
                        paramValue = paramValueStr; % Keep as string if conversion fails
                    end
                end

                % Check if the parameter name exists in the structure
                if isfield(Struc, paramName)
                    % Update the field value
                    Struc.(paramName) = paramValue;
                else
                    % Recursively check sub-structures
                    Struc = Spike_Module_updateSubStruct(Struc, paramName, paramValue);
                end
            end
        end
    end

elseif strcmp(Sorter,"Kilosort 4") 
    
    % Get the current content of the TextArea
    lines = Text;

    % Initialize the structure
    Struc = struct();

    % Process each line
    for i = 1:numel(lines)
        line = strtrim(lines{i}); % Get the line and trim whitespace
        if contains(line, ':') % Check if the line contains a colon
            parts = split(line, ':'); % Split into name and value
            name = strtrim(parts{1}); % Variable name
            value = strtrim(parts{2}); % Corresponding value

            % Convert the value to the appropriate type
            if strcmpi(value, 'true') || strcmpi(value, 'false')
                Struc.(name) = double(strcmpi(value, 'true')); % Logical to double
            elseif ~isempty(regexp(value, '^\d+(\.\d+)?$', 'once'))
                Struc.(name) = str2double(value); % Numeric
            elseif startsWith(value, '[') && endsWith(value, ']')
                Struc.(name) = str2num(value); %#ok<ST2NM> % Convert array
            elseif strcmpi(value, 'None')
                Struc.(name) = 'None'; % Treat 'None' as empty
                %Struc.(name) = []; % Treat 'None' as empty
            else
                Struc.(name) = value; % Leave as string
            end
        end
    end
end