function Utility_Show_Info_Loaded_Data(app)

%________________________________________________________________________________________
%% Function to show all contents of the Data.Info object in the textarea on the bottom left of the main window 
% This function gets called whenever Data.Info is modified to update the
% recording infomation textarea. It rearranges the Data.Info structure so
% that subfields get primary fields that can be shown as is and converts
% double values to strings

% Input Arguments:
% 1. app: main window app object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

TempInfo = app.Data.Info;

if isfield(TempInfo,'EventChannelNames')
    TempInfo.EventChannelNames = string(app.Data.Info.EventChannelNames);
end

% Initialize an empty string to store the information
infoString = '';

% Iterate over the fields of the structure
fields = fieldnames(TempInfo);
for i = 1:numel(fields)

    fieldName = fields{i};
    fieldValue = TempInfo.(fieldName);
    % dont show info about these fields...too long!
    if strcmp(fieldName,'EventRelatedTime')
        continue;
    end
    if strcmp(fieldName,'ChannelIDS')
        continue;
    end
    if strcmp(fieldName,'ChannelToExtract')
        continue;
    end
    if strcmp(fieldName,'ChannelOrder')
        continue;
    end
    if strcmp(fieldName,'HighPassStatistics')
        continue;
    end
    if strcmp(fieldName,'MEACoords')
        continue;
    end

    if isstruct( fieldValue ) 
        if isfield(app.Data.Info,'EventRelatedPreprocessing')
            EventRelatedfields = fieldnames(fieldValue);
            for k = 1:numel(EventRelatedfields)
                fieldName = EventRelatedfields{k};
                if isfield(app.Data.Info.EventRelatedPreprocessing,fieldName)
                    fieldValue = app.Data.Info.EventRelatedPreprocessing.(fieldName);
                    if isnumeric(fieldValue)
                        infoString = sprintf('%s%s: %s\n', infoString, fieldName, num2str(fieldValue));
                    else
                        try
                            a = convertStringsToChars(fieldValue);
                            if length(a)>100
                                TempfieldValue = strcat('More than 100 Char Elements');
                                infoString = sprintf('%s%s: %s\n', infoString, fieldName, TempfieldValue);
                            else
                                infoString = sprintf('%s%s: %s\n', infoString, fieldName, fieldValue);
                            end
                        catch
                            infoString = sprintf('%s%s: %s\n', infoString, fieldName, fieldValue);
                        end
                    end
                end
            end
        end

        if isfield(app.Data.Info,'ProbeInfo')
            if ~isstruct(fieldValue)
                continue;
            end
            ProbeInfofields = fieldnames(fieldValue);
            for k = 1:numel(ProbeInfofields)
                fieldName = ProbeInfofields{k};
                if isfield(app.Data.Info.ProbeInfo,fieldName)
                    fieldValue = app.Data.Info.ProbeInfo.(fieldName);
                    if isnumeric(fieldValue)
                        if length(fieldValue)<32
                            infoString = sprintf('%s%s: %s\n', infoString, fieldName, num2str(fieldValue));
                        else
                            infoString = sprintf('%s%s: %s\n', infoString, fieldName, strcat(num2str(length(fieldValue)),' Elements'));
                        end
                    else
                        if ~iscell(fieldValue)
                            infoString = sprintf('%s%s: %s\n', infoString, fieldName, fieldValue);
                        end
                    end
                end
            end
        end
        
    elseif isstring( fieldValue ) || ischar( fieldValue )
        if ~isempty(fieldValue)
            if strcmp(fieldName,"EventChannelNames")
                concatenatedString = join(fieldValue, ',');
                infoString = sprintf('%s%s: %s\n', infoString, fieldName, concatenatedString);
            else
                infoString = sprintf('%s%s: %s\n', infoString, fieldName, fieldValue);
            end
        end
    else
        if ~isempty(fieldValue)
            if isnumeric(fieldValue)
                infoString = sprintf('%s%s: %s\n', infoString, fieldName, num2str(fieldValue));
            end
        end
    end
end

% Set the content of the app text area to the information string
app.TextArea.Value = infoString;
