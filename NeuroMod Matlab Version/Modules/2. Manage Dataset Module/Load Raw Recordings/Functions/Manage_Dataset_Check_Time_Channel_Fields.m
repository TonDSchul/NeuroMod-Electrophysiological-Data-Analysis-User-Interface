function [TimeToExtractField,ChannelToExtractField] = Manage_Dataset_Check_Time_Channel_Fields(TimeToExtractField,ChannelToExtractField,event)

%________________________________________________________________________________________

%% Function to check the input edit fields of the extract raw recordings window that set the time to extract and channel to extract

% when wanting to extract spike 2 data, this library is necessary. We need
% to know the path this was installed in. When wanting to extract Spike2
% data the first time in NeuroMod, the user is asked for that path and it
% is saved in a variable in GUI_Path/Modules/MISC/Variables/CEDS64Path.mat.
% After this, this variable is searched for and the path in it is check (whether it exists)

% Input:
% 1. TimeToExtractField: char, user input for time to extract
% 2. ChannelToExtractField: char, user input for channel to extract
% 3. event: holds event info from manipulating the edit field (from
% Matlab). Used is: events.PreviousValue which holds the edit field char
% before it was manipulated

% Output: 
% 1. TimeToExtractField: char, corrected user input for time to extract
% 2. ChannelToExtractField: char, corrected user input for channel to extract
 
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Check time to extract data from edit field entry
if ~isempty(TimeToExtractField)
    if ~contains(TimeToExtractField,',')
        msgbox("Format error. No comma found. Please enter two comma separated numbers to designate start-and stop time data is extracted from. Enter 0,Inf for whole duration.")
        TimeToExtractField = event.PreviousValue;
        return;
    end
    
    SplitString = str2double(strsplit(TimeToExtractField,','));
    
    if isempty(SplitString) || sum(isnan(SplitString))>0
        TimeToExtractField = event.PreviousValue;
        msgbox("Format error. Could not convert numbers. Please enter two comma separated numbers to designate start-and stop time data is extracted from. Enter 0,Inf for whole duration.")
        return;
    end

    if SplitString(1)>SplitString(2)
        TimeToExtractField = event.PreviousValue;
        msgbox("Format error. First number cannot be bigger than second! Please enter two comma separated numbers to designate start-and stop time data is extracted from.")
        return;
    end
    if SplitString(1)<0
        TimeToExtractField = event.PreviousValue;
        msgbox("Format error. Time has to be bigger than or equal to 0! Please enter two comma separated numbers to designate start-and stop time data is extracted from.")
        return;
    end
%% Check channel to extract data from edit field entry
else 
    if ~strcmp(ChannelToExtractField,"All")
        try
            ChannelToExtract = eval(ChannelToExtractField);
        catch
            ChannelToExtractField = event.PreviousValue;
            msgbox("Format error. Could not convert numbers. Please enter Matlab expressions like 1:10 or [1,2,3] or the char 'All' to designate channel to extract.")
            return;
        end
    end
end