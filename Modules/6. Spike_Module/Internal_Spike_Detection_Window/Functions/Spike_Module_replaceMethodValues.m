function updatedStruct = Spike_Module_replaceMethodValues(inputStruct, newMethodValues)
    % Replaces all occurrences of the "method" field in the structure
    % with the corresponding values from newMethodValues (1x4 cell array).

    if numel(newMethodValues) ~= 4
        error('newMethodValues must be a 1x4 cell array.');
    end

    index = 1; % Index for newMethodValues

    % Helper function to recursively update the structure
    function s = traverseAndReplace(s)
        fields = fieldnames(s);
        for i = 1:numel(fields)
            if strcmp(fields{i}, 'method')
                % Replace the "method" field value
                s.(fields{i}) = newMethodValues{index};
                index = index + 1;
            elseif isstruct(s.(fields{i}))
                % Recursively traverse nested structures
                s.(fields{i}) = traverseAndReplace(s.(fields{i}));
            end
        end
    end

    % Start traversal from the root of the structure
    updatedStruct = traverseAndReplace(inputStruct);

    % Debug: Ensure all values are replaced
    if index ~= 5 % We expect 4 replacements
        warning('Expected to replace 4 "method" values, but replaced %d.', index-1);
    end
end