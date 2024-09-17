function [fieldData] = Extract_Events_Module_Display_Neuralynx_EventInfo(event)

%________________________________________________________________________________________
%% Function show event datain the extract data window text area - convert from dataframe to stringarray

%Gets called after event data for neuralynx was loaded to diplay the
%results

% Inputs: 
% 1.event: Dataframe holding event data. Usually contains event samples,
% event times, event names and event types -- directly comes from fieldtrip
% ft_read_events function

% Outputs:
% 1. fieldData: Data/Text to show in TextArea

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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