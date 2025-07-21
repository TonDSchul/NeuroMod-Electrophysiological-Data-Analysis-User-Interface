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
    if strcmp(type,'xlim') || strcmp(type,'ylim')
        commaindicie = find(value==',');

        LowerLimit = value(1:commaindicie(1)-1);
        UpperLimit = value(commaindicie(1)+1:end);

        StringtoEval = strcat(type,'(UIAxes,[',LowerLimit,',',UpperLimit,']);');
        eval(StringtoEval);

    elseif strcmp(type,'Fontsize')
        StringtoEval = strcat('UIAxes.FontSize =',value,';');
        eval(StringtoEval);
    elseif ~strcmp(type,'BackgroundColor')
        StringtoEval = strcat(type,'(UIAxes,','"',value,'"',');');
        eval(StringtoEval);
    end
    
else
    if strcmp(type,'MainBackgroundColor')
        UIAxes.Color = value;
    elseif strcmp(type,'TimeBackgroundColor')
        UIAxes.Color = value;
    else
        error('Invalid property type for UIAxes in updateUIAxesProperty');
    end
end
