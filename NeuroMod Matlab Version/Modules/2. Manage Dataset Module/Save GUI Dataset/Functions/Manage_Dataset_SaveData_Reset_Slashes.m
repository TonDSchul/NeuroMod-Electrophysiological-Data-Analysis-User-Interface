function Info = Manage_Dataset_SaveData_Reset_Slashes(Info)

%________________________________________________________________________________________
%% Function to replace dashes within paths

% Used if path would be the wrong format in python with dashes in the wrong direction
% converts \ to / 

% Input Arguments:
% 1. Info: Metadata struc from Data structure (Data.Info)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Recursively replace \ with / in all char or string fields

if isstruct(Info)
    fn = fieldnames(Info);
    for i = 1:numel(Info)
        for k = 1:numel(fn)
            Info(i).(fn{k}) = Manage_Dataset_SaveData_Reset_Slashes(Info(i).(fn{k}));
        end
    end

elseif iscell(Info)
    for i = 1:numel(Info)
        Info{i} = Manage_Dataset_SaveData_Reset_Slashes(Info{i});
    end

elseif ischar(Info)
    Info = strrep(Info, '\', '/');

elseif isstring(Info)
    Info = replace(Info, "\", "/");
end
