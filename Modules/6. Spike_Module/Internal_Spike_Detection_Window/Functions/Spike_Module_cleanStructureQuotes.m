function cleanedStruct = Spike_Module_cleanStructureQuotes(inputStruct)
    % Recursively removes leading and trailing single quotes from string values
    % while preserving logical values and other types.
    
    cleanedStruct = inputStruct;
    fields = fieldnames(inputStruct);
    
    for i = 1:numel(fields)
        fieldValue = inputStruct.(fields{i});
        
        if isstruct(fieldValue)
            % Recursively clean nested structures
            cleanedStruct.(fields{i}) = Spike_Module_cleanStructureQuotes(fieldValue);
        elseif ischar(fieldValue)
            % Remove leading and trailing single quotes from string values
            if startsWith(fieldValue, "'") && endsWith(fieldValue, "'")
                TempField = extractBetween(fieldValue, 2, strlength(fieldValue) - 1);
                cleanedStruct.(fields{i}) = TempField{1};
            end
        elseif islogical(fieldValue)
            % Preserve logical values (true/false) as is
            cleanedStruct.(fields{i}) = fieldValue;
        else
            % Preserve other types (e.g., numeric) as is
            cleanedStruct.(fields{i}) = fieldValue;
        end
    end
