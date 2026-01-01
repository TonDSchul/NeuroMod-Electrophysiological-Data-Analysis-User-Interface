function [Data] = Manage_Dataset_Module_OnlyTake_Specified_Channel(Data,ChannelSelectionField)

if isempty(ChannelSelectionField)
    ChannelToExtract = 1:size(Data.Raw,1);
else

    if contains(ChannelSelectionField,',')
        if ~contains(ChannelSelectionField,'[') || ~contains(ChannelSelectionField,']')
            if ~contains(ChannelSelectionField,'[')
                ChannelSelectionField = strcat('[',ChannelSelectionField);
            end
            if ~contains(ChannelSelectionField,']')
                ChannelSelectionField = strcat(ChannelSelectionField,']');
            end
        end
    end
    try 
        ChannelToExtract = eval(ChannelSelectionField);
    catch
        ChannelToExtract = 1:size(Data.Raw,1);
    end
end

if length(ChannelToExtract) > size(Data.Raw,1)
    ChannelMissmatch = strcat("Nr Channel found in recording: ",num2str(length(ChannelToExtract)),"; Nr channel found in dataset: ",num2str(size(Data.Raw,1)));
    msgbox(strcat(ChannelMissmatch," Specified number of channel to extract is bigger than the amount of channels found in recording. Please adjust the number of channel to extract accordingly."));
    error(strcat(ChannelMissmatch," Specified number of channel to extract is bigger than the amount of channels found in recording. Please adjust the number of channel to extract accordingly."));
end

if length(ChannelToExtract) > length(Data.Info.ProbeInfo.ActiveChannel)
    ChannelMissmatch = strcat("Nr Channel found in recording: ",num2str(length(ChannelToExtract)),"; Nr channel defined as active: ",num2str(length(Data.Info.ProbeInfo.ActiveChannel)));
    msgbox(strcat(ChannelMissmatch," Specified number of channel to extract is bigger than the amount of active channel in probe design. Please adjust the number of channel to extract accordingly."));
    error(strcat(ChannelMissmatch," Specified number of channel to extract is bigger than the amount of active channel in probe design. Please adjust the number of channel to extract accordingly."));
end

if sum(ChannelToExtract > size(Data.Raw,1))
    msgbox("Found channel number(s) to extract exceeding the available number of channel within the recording. Please adjust the number of channel to extract accordingly.");
    error("Found channel number(s) to extract exceeding the available number of channel within the recording. Please adjust the number of channel to extract accordingly.");
end

AllChannel = 1:size(Data.Raw,1);

SelectedChannel = ismember(AllChannel,ChannelToExtract);

Data.Raw = Data.Raw(SelectedChannel,:);