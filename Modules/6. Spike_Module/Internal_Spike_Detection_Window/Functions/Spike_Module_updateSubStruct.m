function structOut = Spike_Module_updateSubStruct(structIn, paramName, paramValue)
    % Recursive helper function to update nested structures
    structOut = structIn;
    fields = fieldnames(structIn);
    for i = 1:numel(fields)
        if isstruct(structIn.(fields{i}))
            structOut.(fields{i}) = Spike_Module_updateSubStruct(structIn.(fields{i}), paramName, paramValue);
        elseif strcmp(fields{i}, paramName)
            structOut.(fields{i}) = paramValue;
            return;
        end
    end
end