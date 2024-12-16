function methodValues = Spike_Module_extractMethodValues(inputStruct)
    % Extracts all occurrences of the "method" field values from the structure.
    % Returns a 1x4 cell array containing the values of each "method" field.
    
    methodValues = {};
    methodPaths = {}; % To track the paths for debugging

    % Helper function to recursively search the structure
    function traverseStruct(s, path)
        fields = fieldnames(s);
        for i = 1:numel(fields)
            currentPath = strcat(path, '.', fields{i});
            if strcmp(fields{i}, 'method')
                % Save the value and its path
                methodValues{end+1} = s.(fields{i}); %#ok<AGROW>
                methodPaths{end+1} = currentPath; %#ok<AGROW>
            elseif isstruct(s.(fields{i}))
                % Recursively traverse nested structures
                traverseStruct(s.(fields{i}), currentPath);
            end
        end
    end

    % Start traversal from the root of the structure
    traverseStruct(inputStruct, '');

    % Debug: Ensure exactly 4 "method" values are extracted
    if numel(methodValues) ~= 4
        warning('Expected 4 "method" values, but found %d.', numel(methodValues));
    end

    % Ensure output is a 1x4 cell array
    methodValues = reshape(methodValues, 1, numel(methodValues));
end