function [Data] = Manage_Dataset_Module_OnlyTake_Specified_Channel(Data)

if length(Data.Info.ProbeInfo.ActiveChannel) > size(Data.Raw,1)
    msgbox("Number of active channel is bigger than the amount of channels found in recording. Please adjust the number of active channel accordingly.");
    error("Number of active channel is bigger than the amount of channels found in recording. Please adjust the number of active channel accordingly.");
end

if sum(Data.Info.ProbeInfo.ActiveChannel > size(Data.Raw,1))
    msgbox("Found active channel number(s) exceeding the available number of channel within the recording. Please adjust the active channel accordingly.");
    error("Found active channel number(s) exceeding the available number of channel within the recording. Please adjust the active channel accordingly.");
end

AllChannel = 1:size(Data.Raw,1);

SelectedChannel = ismember(AllChannel,Data.Info.ProbeInfo.ActiveChannel);

Data.Raw = Data.Raw(SelectedChannel,:);