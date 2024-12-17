
function [Struc] = Spike_Module_ConvertTextToParameterStruc(Text,Sorter,StartStruc)

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
    % Initialize an empty structure
    Struc = struct();
    
    % Get the content from the TextArea as a string
    textContent = Text;
    
    % Split the text into lines (one line per field-value pair)
    lines = strsplit(textContent, '\n');
    
    % Loop through each line and extract the field and value
    for i = 1:numel(lines)
        line = strtrim(lines{i});
        
        % Skip empty lines
        if isempty(line)
            continue;
        end
        
        % Split each line at the first colon to separate field and value
        idx = find(line == ':', 1);
        if ~isempty(idx)
            field = strtrim(line(1:idx-1));  % Extract field name
            value_str = strtrim(line(idx+1:end));  % Extract value
            
            % Convert the value string back to the appropriate type
            if strcmp(value_str, 'true')
                value = true;
            elseif strcmp(value_str, 'false')
                value = false;
            elseif strcmp(value_str, 'None')
                value = [];
            else
                try
                    value = str2double(value_str);  % Try to convert to number
                    if isnan(value)
                        value = value_str;  % If it's not a number, keep it as a string
                    end
                catch
                    value = value_str;  % In case of error, treat as string
                end
            end
            
            % Assign the value to the structure
            Struc.(field) = value;
        end
    end
end