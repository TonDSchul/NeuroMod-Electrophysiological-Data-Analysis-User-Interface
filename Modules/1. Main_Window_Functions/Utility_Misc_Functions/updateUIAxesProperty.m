function updateUIAxesProperty(UIAxes, type, value)
%________________________________________________________________________________________
%% Function responsible to change figure properties when the user right-clicks on a figure and inputs a new propertie value

% Input Arguments:
% 1. UIAxes: Axis handle of figure for which a property has to be changed
% 2. type: Type of property changed as string, like "xlim" or "ylim" (normal matlab commands)
% 3. value: the value the user inputted replacing the old peroperty value,
% as string

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Check if type is a valid property of UIAxes
if isprop(UIAxes, type)
    % Set the specified property to the given value
    %set(UIAxes, type, value);

    % StringtoEval = strcat('UIAxes.',type,' = ',value,';');
    % eval(StringtoEval);
    if strcmp(type,"xlim") || strcmp(type,"ylim")
        StringtoEval = strcat(type,'(UIAxes,',value,');');
        eval(StringtoEval);
    else
        StringtoEval = strcat(type,'(UIAxes,','"',value,'"',');');
        eval(StringtoEval);
    end
    
else
    error('Invalid property type for UIAxes');
end
