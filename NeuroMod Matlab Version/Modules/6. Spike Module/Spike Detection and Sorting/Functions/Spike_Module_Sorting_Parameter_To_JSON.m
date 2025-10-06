function SortingParameters = Spike_Module_Sorting_Parameter_To_JSON(Sorter,ParameterStructure,file_path)

if strcmp(Sorter,"Mountainsort 5")
    % Loop over all fields
    fields = fieldnames(ParameterStructure.MS5);
    for i = 1:numel(fields)
        field = fields{i}; % Get the field name
        value = ParameterStructure.MS5.(field); % Get the field value
        
        if ischar(value) % Only process strings
            % Remove leading and trailing single/double quotes
            value = strip(value, '"');
            value = strip(value, '''');
            
            % Check if the value is 'None'
            if strcmpi(value, 'None')
                ParameterStructure.MS5.(field) = []; % Convert to empty
            else
                ParameterStructure.MS5.(field) = value; % Assign the cleaned value back
            end
        end
    end
    % Convert Sorter Parameter into dictionary
    SortingParameters = jsonencode(ParameterStructure.MS5);
elseif strcmp(Sorter,"SpyKING CIRCUS 2")
    ParameterStructure.SC2 = Spike_Module_cleanStructureQuotes(ParameterStructure.SC2);
    ParameterStructure.SC2 = Spike_Module_convertTrueFalseStrings(ParameterStructure.SC2);
    % Loop over all fields
    fields = fieldnames(ParameterStructure.SC2);
    for i = 1:numel(fields)
        field = fields{i}; % Get the field name
        value = ParameterStructure.SC2.(field); % Get the field value
        
        if ischar(value) % Only process strings
            % Remove leading and trailing single/double quotes
            value = strip(value, '"');
            value = strip(value, '''');
            
            % Check if the value is 'None'
            if strcmpi(value, 'None')
                ParameterStructure.SC2.(field) = []; % Convert to empty
            else
                ParameterStructure.SC2.(field) = value; % Assign the cleaned value back
            end
        end
    end
    % Convert Sorter Parameter into dictionary
    SortingParameters = jsonencode(ParameterStructure.SC2);
elseif strcmp(Sorter,"Kilosort 4")
    % Loop over all fields
    fields = fieldnames(ParameterStructure.KS4);
    for i = 1:numel(fields)
        field = fields{i}; % Get the field name
        value = ParameterStructure.KS4.(field); % Get the field value
        
        if ischar(value) % Only process strings
            % Remove leading and trailing single/double quotes
            value = strip(value, '"');
            value = strip(value, '''');
            
            % Check if the value is 'None'
            if strcmpi(value, 'None')
                ParameterStructure.KS4.(field) = []; % Convert to empty
            else
                ParameterStructure.KS4.(field) = value; % Assign the cleaned value back
            end
        end
    end

    % Convert Sorter Parameter into dictionary
    SortingParameters = jsonencode(ParameterStructure.KS4);
end

% Save JSON to a temporary file
if isfile(fullfile(file_path, 'sorting_parameters.json'))
    delete(fullfile(file_path, 'sorting_parameters.json'))
end
jsonFilePath = fullfile(file_path, 'sorting_parameters.json');
fid = fopen(jsonFilePath, 'w');
fwrite(fid, SortingParameters, 'char');
fclose(fid);