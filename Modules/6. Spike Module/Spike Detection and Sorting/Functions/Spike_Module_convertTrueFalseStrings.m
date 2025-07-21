function updatedStruct = Spike_Module_convertTrueFalseStrings(inputStruct)

%________________________________________________________________________________________
%% Function to convert true back to false if the user selcted so --> only when sorter = SpykingCircus 2
%% Just cleans up an unknown error occuring earlier

%% cleans quotes from values

% Inputs:
% 1. inputStruct: spike sorting parameter structure

% Outputs
% 1. updatedStruct: spike sorting parameter structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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
