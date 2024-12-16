function updatedStruct = Spike_Module_convertTrueFalseStrings(inputStruct)
    % Recursively converts 'true'/'false' string values to 1/0 in a structure
    updatedStruct = inputStruct;
    fields = fieldnames(inputStruct);
    
    for i = 1:numel(fields)
        fieldValue = inputStruct.(fields{i});
        
        if isstruct(fieldValue)
            % Recursively process nested structures
            updatedStruct.(fields{i}) = Spike_Module_convertTrueFalseStrings(fieldValue);
        elseif ischar(fieldValue)
            % Convert 'true' to 1 and 'false' to 0
            if strcmpi(fieldValue, 'true')
                updatedStruct.(fields{i}) = 1;
            elseif strcmpi(fieldValue, 'false')
                updatedStruct.(fields{i}) = 0;
            end
        end
    end
end