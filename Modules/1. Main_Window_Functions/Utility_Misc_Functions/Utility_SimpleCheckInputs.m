function [Corrected_Input] = Utility_SimpleCheckInputs(Input,Type,StandardValues)

%________________________________________________________________________________________
%% Function to check whether user input into a field like the channelnr obeys format regulations
% This is the primarily used function to check inputs and corrects them when they violate format, since it is more
% robust than 'Organize_CheckProperInput' function.
% Organize_CheckProperInput gets bit by bit replaced in the future 

% Input Arguments:
% 1. Input: input to be checked as char. I diretly pass the app.Button.Value
% 2. Type: string, only working option: "Two". Specifies how many numbers
% are expected in the input
% 3. StandardValues: char containing a value the original input gets
% replaced by when the format is violated

% Output Arguments:
% 1. Corrected_Input: char with either the original input when its format
% is proper, char with standardvalue if format was violated

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if strcmp(Type,"Two")

    % Define the max value from the standard value
    standard_numbers = StandardValues;
    max_standard_value = max(standard_numbers);

    % Check if the Input is a char
    if ischar(Input)
        % Check if the Input matches the pattern of a single number
        match_single = regexp(Input, '^\d+$', 'match');

        if ~isempty(match_single)
            % Convert the single number to a double
            number = str2double(Input);

            % Check if the number is above 0
            if number >= 0
                % Set the Input to 'number,number'
                Input = sprintf('%d,%d', number, number);
            else
                % The number is not above 0, replace with standard value
                Input = StandardValues;
            end
        else
            % Check if the Input matches the pattern of two numbers separated by a comma
            match_double = regexp(Input, '^\d+,\d+$', 'match');

            if ~isempty(match_double)
                % Split the Input by the comma
                numbers = str2double(split(Input, ','));

                % Check if both numbers are above 0
                if numbers(1) >= 0 && numbers(2) >= 0
                    % If the first number is bigger than the second, adjust accordingly
                    if numbers(1) > numbers(2)
                        if numbers(2) - 1 > 0
                            numbers(1) = numbers(2) - 1;
                        else
                            Input = StandardValues;
                        end
                    end

                    % If the second number is smaller than the first, adjust accordingly
                    if numbers(2) < numbers(1)
                        if numbers(1) + 1 <= max_standard_value
                            numbers(2) = numbers(1) + 1;
                        else
                            Input = StandardValues;
                        end
                    end

                    % Update the Input if it hasn't been set to StandardValues
                    if ~isequal(Input, StandardValues)
                        Input = sprintf('%d,%d', numbers(1), numbers(2));
                    end
                else
                    % One or both numbers are not above 0, replace with standard value
                    Input = StandardValues;
                end

                commaindicie = find(StandardValues==',');
                UpperLimit = str2double(StandardValues(commaindicie(1)+1:end));
                if numbers(2) > UpperLimit
                    Input = StandardValues;
                end
            else
                % The Input does not match the pattern, replace with standard value
                Input = StandardValues;
            end
        end

    else
        % The Input is not a char, replace with standard value
        Input = StandardValues;
    end

    % Return the corrected Input
    Corrected_Input = Input;

elseif strcmp(Type,"One")
    if contains(Input,'.')
        Input = StandardValues;
    end
    if isnan(str2double(Input))
        Input = StandardValues;
    end
    if str2double(Input) <= 0
        Input = StandardValues;
    end
    if contains(Input,',')
        Input = StandardValues;
    end

    % Return the corrected Input
    Corrected_Input = Input;
    
end