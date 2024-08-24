function [fieldData] = Extract_Events_Module_Display_Neuralynx_EventInfo(event)

%% Events is a 1xn structure and has to be converted to display contents in Textfield
    % Get the field names of the structure
    fieldNames = fieldnames(event);

    fieldData = cell(length(event)+1,1);

    % Loop through each field and extract the data
    for i = 1:length(fieldNames)
        % Extract the field data
        TempfieldData = {event.(fieldNames{i})};
        
        % Convert field data to string array
        if ~isempty(TempfieldData{1})
            if isnumeric(TempfieldData{1}(1))
                for o = 1:length(TempfieldData)
                    if i ~= 1
                        TempfieldData{o} = convertStringsToChars(num2str(TempfieldData{o}));
                        fieldData{o+1} = [fieldData{o+1},' ; ',TempfieldData{o}];
                    else
                        TempfieldData{o} = convertStringsToChars(num2str(TempfieldData{o}));
                        fieldData{o+1} = [fieldData{o+1},TempfieldData{o}];
                    end
                end
            else
                for o = 1:length(TempfieldData)
                    if i ~= 1
                        fieldData{o+1} = [fieldData{o+1},' ; ',convertStringsToChars(TempfieldData{o})];
                    else
                        fieldData{o+1} = [fieldData{o+1},convertStringsToChars(TempfieldData{o})];
                    end
                end
            end
        else
            for o = 1:length(TempfieldData)
                if i ~= 1
                    fieldData{o+1} = [fieldData{o+1},' ; ','NaN'];
                else
                    fieldData{o+1} = [fieldData{o+1},'NaN'];
                end
            end
        end
    end

    for i = 1: length(fieldNames)
        if i ~= 1
            fieldData{1} = [fieldData{1},' ; ',fieldNames{i}];
        else
            fieldData{1} = [fieldData{1},fieldNames{i}];
        end
    end