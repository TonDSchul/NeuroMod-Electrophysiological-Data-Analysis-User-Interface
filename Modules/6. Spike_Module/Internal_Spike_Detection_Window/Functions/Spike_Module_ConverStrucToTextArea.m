function [Text] = Spike_Module_ConverStrucToTextArea(Struc,Sorter)

if strcmp(Sorter,"Mountainsort 5")  
    % Convert the structure to a readable string
    fields = fieldnames(Struc);
    Text = "";
    for i = 1:numel(fields)
        field = fields{i};
        value = Struc.(field);
        if ischar(value)
            Text = sprintf('%s%s: %s\n', Text, field, value);
        elseif isnumeric(value) || islogical(value)
            Text = sprintf('%s%s: %g\n', Text, field, value);
        end
    end
elseif strcmp(Sorter,"SpykingCircus 2") 

    level = 2;
    Text = "";
    fields = fieldnames(Struc);
    indent = repmat('    ', 1, level); % 4 spaces per level
    for i = 1:numel(fields)
        field = fields{i};
        value = Struc.(field);
        if isstruct(value)
            % Recursive call for nested structures
            Text = sprintf('%s%s%s:\n%s', ...
                Text, indent, field, Spike_Module_ConverStrucToTextArea(value,Sorter));
        else
            % Format non-struct values
            if ischar(value)
                formattedValue = sprintf("'%s'", value);
            elseif isnumeric(value) || islogical(value)
                formattedValue = mat2str(value);
            end
            Text = sprintf('%s%s%s: %s\n', ...
                Text, indent, field, formattedValue);
        end
    end
elseif strcmp(Sorter,"Kilosort 4") 
    
    % Initialize an empty cell array to hold the formatted strings
    params_cell = {};
    
    % Loop through the fields of the structure
    fields = fieldnames(Struc);
    for i = 1:numel(fields)
        field = fields{i};
        value = Struc.(field);
        
        % Convert value to string
        if islogical(value)
            value_str = mat2str(value);  % for boolean values
        elseif isempty(value)
            value_str = 'None';  % for empty arrays
        else
            value_str = mat2str(value);  % general case for other types
        end
        
        % Create the field: value string and store it in the cell array
        params_cell{end+1} = sprintf('%s: %s', field, value_str);
    end
    Text = params_cell;
end