function UpdatedSortingparameter = Spike_Module_replaceMethodValues(OldSortingparameter, NewMethodValues)

%________________________________________________________________________________________
%% Function to take method field values from spykingcircus 2 parameterstructure to take as method values of the inputted structure

% Inputs:
% 1. OldSortingparameter: SpykingCircus 2 parameter structure 
% 2. NewMethodValues: 1x4 cell array which each cell holding a method field
% value 

% Outputs
% 1. UpdatedSortingparameter: spike sorting parameter structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% Same as Spike_Module_extractMethodValues in terms of searching in a
% nested structure 

    % Replaces all occurrences of the "method" field in the structure

    index = 1; 

    % Helper function to recursively update the structure
    function s = traverseAndReplace(s)
        fields = fieldnames(s);
        for i = 1:numel(fields)
            if strcmp(fields{i}, 'method')

                s.(fields{i}) = NewMethodValues{index};
                index = index + 1;
            elseif isstruct(s.(fields{i}))

                s.(fields{i}) = traverseAndReplace(s.(fields{i}));
            end
        end
    end


    UpdatedSortingparameter = traverseAndReplace(OldSortingparameter);

end