function MethodValues = Spike_Module_extractMethodValues(Parameterstrcuture)

%________________________________________________________________________________________
%% Function called when spike parameter text area was changed for spykingcircus 2

% SpykingCircus 2 parameter structure has 4 fields called 'method' for
% different categories. When the user changes parameters in the textare,
% these get extracted in a 1x4 cell array to save their identity. The first
% cell is the first method value and so on. Output methodValues is input
% for Spike_Module_replaceMethodValues after the text was converted to a
% strcuture to properly deal with mehtod values

% Inputs:
% 1. Parameterstrcuture: Parameterstrcuture holding SpykingCircus2 parameter

% Outputs
% 1. MethodValues: 1x4 cell array holding the values for all 4 mehtod fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% Searching through a nested structure:
    
    MethodValues = {};
    
    % recursively search the structure
    function traverseStruct(s, path)
        fields = fieldnames(s);
        for i = 1:numel(fields)
            currentPath = strcat(path, '.', fields{i});
            if strcmp(fields{i}, 'method')
                % Save value and path of method field - dont edit comments
                % below!!
                MethodValues{end+1} = s.(fields{i}); %#ok<AGROW>
            elseif isstruct(s.(fields{i}))
                % go through netsed structure
                traverseStruct(s.(fields{i}), currentPath);
            end
        end
    end
    
    % Start going through structure
    traverseStruct(Parameterstrcuture, '');
        
    % Ensure output is a 1x4 cell array
    MethodValues = reshape(MethodValues, 1, numel(MethodValues));

end