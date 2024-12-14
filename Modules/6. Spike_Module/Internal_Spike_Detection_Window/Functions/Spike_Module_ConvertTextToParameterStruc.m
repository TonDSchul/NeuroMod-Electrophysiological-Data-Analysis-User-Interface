function [Struc] = Spike_Module_ConvertTextToParameterStruc(Text,Sorter)

if strcmp(Sorter,"Mountainsort 5")  
    % Get the updated Text
    updatedText = Text; % Cell array of strings (one string per line)
    
    % Initialize an empty structure
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
                
                % Assign to the structure
                Struc.(key) = value;
            end
        end
    end

elseif strcmp(Sorter,"SpykingCircus 2") 
    
    Struc = struct(); % Initialize the output structure
    currentField = ''; % Track the current top-level field

    for i = 1:numel(Text)
        line = strtrim(Text{i}); % Trim leading/trailing spaces
        
        % Skip empty lines
        if isempty(line)
            continue;
        end
        
        % Split the line at the first occurrence of ':'
        splitLine = split(line, ':');
        key = strtrim(splitLine{1}); % Extract the key
        value = ''; % Default value if none provided

        if numel(splitLine) > 1
            value = strtrim(strjoin(splitLine(2:end), ':')); % Join remaining parts if ':' is in the value
        end

        % Check if the line defines a new top-level field
        if isempty(value)
            % Start a new top-level field
            currentField = key;
            Struc.(currentField) = struct();
        else
            % Handle key-value pairs under the current top-level field
            if isempty(currentField)
                error('Key-value pair found before defining a top-level field.');
            end

            % Convert value to appropriate type
            if strcmpi(value, 'true')
                value = true;
            elseif strcmpi(value, 'false')
                value = false;
            elseif ~isnan(str2double(value))
                value = str2double(value);
            else
                % Remove surrounding single or double quotes if present
                value = replace(value, ["'", '"'], '');
            end

            % Assign the key-value pair to the current field
            Struc.(currentField).(key) = value;
        end
    end

end