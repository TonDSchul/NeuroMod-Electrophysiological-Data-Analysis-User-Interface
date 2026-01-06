function [TimeToExtractField,ChannelToExtractField] = Manage_Dataset_Check_Time_Channel_Fields(TimeToExtractField,ChannelToExtractField,event)

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