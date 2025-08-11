function [NewParameterStrcuture] = Spike_Module_ConvertTextToParameterStruc(Text,Sorter,SC2Parameter)

%________________________________________________________________________________________
%% Function to convert text containing all fields and values of spike sorting parameter text back to a strcuture

% uses Spike_Module_updateSubStruct.m only for spykingcircus

% Inputs:
% 1. Text: text containing all spike sorting parameter settings 
% 2. Sorter: string, selected sorter, "Mountainsort 5" OR "SpyKING CIRCUS 2"
% OR "Kilosort 4"
% 3. SC2Parameter: only when sorter = "SpyKING CIRCUS 2"; standard spike sorting settings structure --> only values
% that changed are interchanged!

% Outputs
% 1. NewParameterStrcuture: spike sorting parameter structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if strcmp(Sorter,"Mountainsort 5")  

    NewParameterStrcuture = struct();

    for i = 1:numel(Text)
        line = strtrim(Text{i}); % Get the line and trim whitespace
        if contains(line, ':')
            % Split into key and value
            keyValue = split(line, ':');
            if numel(keyValue) == 2
                key = strtrim(keyValue{1}); % Extract key
                value = strtrim(keyValue{2}); % Extract value
                
                % Convert value to appropriate type
                if strcmpi(value, 'true')
                    value = true;
                elseif strcmpi(value, 'false')
                    value = false;
                elseif ~isnan(str2double(value)) 
                    value = str2double(value);
                end
                
                % Assign to the Struc
                NewParameterStrcuture.(key) = value;
            end
        end
    end

elseif strcmp(Sorter,"SpyKING CIRCUS 2") 

    NewParameterStrcuture = SC2Parameter; % Initialize updated structure

    for i = 1:length(Text)

        line = strtrim(Text{i}); % Get current line and trim whitespace

        if contains(line, ':') % Check if the line contains a ':'
            
            tokens = split(line, ':');

            if length(tokens) == 2 && ~isempty(tokens{1}) && ~isempty(tokens{2}) 

                paramName = strtrim(tokens{1}); % Name before the ':'
                paramValueStr = strtrim(tokens{2}); % Value after the ':'

                % Convert the value to numeric if possible, otherwise leave as string
                paramValue = str2double(paramValueStr);
                if isnan(paramValue) % Conversion was not succesful
                    if isstring(paramValueStr)
                        paramValue = convertStringsToChars(paramValueStr); % Keep as string
                    else
                        paramValue = paramValueStr; % Keep as string 
                    end
                end

                % Check if the parameter name exists in the structure
                if isfield(NewParameterStrcuture, paramName)
                    NewParameterStrcuture.(paramName) = paramValue;
                else
                    % Recursively check sub-structures
                    NewParameterStrcuture = Spike_Module_updateSubStruct(NewParameterStrcuture, paramName, paramValue);
                end
            end
        end
    end

elseif strcmp(Sorter,"Kilosort 4") 
    
    % Get the current content of the TextArea
    lines = Text;

    % Initialize the structure
    NewParameterStrcuture = struct();

    % Process each line
    for i = 1:numel(lines)
        line = strtrim(lines{i}); % Get the line and trim whitespace
        if contains(line, ':') % Check if the line contains a colon
            parts = split(line, ':'); % Split into name and value
            name = strtrim(parts{1}); % Variable name
            value = strtrim(parts{2}); % Corresponding value

            % Convert the value to the appropriate type
            if strcmpi(value, 'true') || strcmpi(value, 'false')
                NewParameterStrcuture.(name) = double(strcmpi(value, 'true')); % Logical to double
            elseif ~isempty(regexp(value, '^\d+(\.\d+)?$', 'once'))
                NewParameterStrcuture.(name) = str2double(value); % Numeric
            elseif startsWith(value, '[') && endsWith(value, ']')
                NewParameterStrcuture.(name) = str2num(value); %#ok<ST2NM> % Convert array
            elseif strcmpi(value, 'None')
                NewParameterStrcuture.(name) = 'None'; % Treat 'None' as empty
                %Struc.(name) = []; % Treat 'None' as empty
            else
                NewParameterStrcuture.(name) = value; % Leave as string
            end
        end
    end
end