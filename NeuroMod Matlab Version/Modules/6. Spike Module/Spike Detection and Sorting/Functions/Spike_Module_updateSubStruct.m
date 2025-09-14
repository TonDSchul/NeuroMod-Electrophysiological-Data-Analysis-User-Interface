function UpdatedParameterStructure = Spike_Module_updateSubStruct(OldParameterStructure, ParamName, ParamValue)

%________________________________________________________________________________________

%% Function to check for subfields in a nested structure -- only spykingcircus
% Used in searching through a structure (from text area) to extract
% a parametername and its value in the SorterParameter structure. 

% called in Spike_Module_ConvertTextToParameterStruc.m if param

% Input:
% 1. ParameterStrcuture: Parameter structure from text area
% 2. ParamName: string, field name searched for
% 3. ParamValue: value of ParamName if found (bc called recursively)

% Output: 
% 1. UpdatedParameterStructure: Parameter structure with the ParamValue
% added to the ParamName field of the structure if found

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

    UpdatedParameterStructure = OldParameterStructure;
    fields = fieldnames(OldParameterStructure);
    for i = 1:numel(fields)
        if isstruct(OldParameterStructure.(fields{i}))
            UpdatedParameterStructure.(fields{i}) = Spike_Module_updateSubStruct(OldParameterStructure.(fields{i}), ParamName, ParamValue);
        elseif strcmp(fields{i}, ParamName)
            UpdatedParameterStructure.(fields{i}) = ParamValue;
            return;
        end
    end
end