function [StartDepth,StopDepth] = Spike_Module_Analysis_Determine_Depths(Data,PreservePlotChannelLocations,CurrentlyActiveChannel)

if strcmp(Data.Info.SpikeType,"Internal")
    if PreservePlotChannelLocations
        FakeChannelRange = 1:str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows);
        FakeYpositions = (FakeChannelRange-1)*Data.Info.ChannelSpacing;
        StartDepth = min(FakeYpositions(Data.Info.ProbeInfo.ActiveChannel(CurrentlyActiveChannel)));
        StopDepth = max(FakeYpositions((Data.Info.ProbeInfo.ActiveChannel(CurrentlyActiveChannel))));
    else
        FakeChannelRange = 1:length(CurrentlyActiveChannel);
        FakeYpositions = (FakeChannelRange-1)*Data.Info.ChannelSpacing;
        StartDepth = min(FakeYpositions);
        StopDepth = max(FakeYpositions);
    end
else
    % if spike sorter results in um
    if PreservePlotChannelLocations
        FakeChannelRange = 1:str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows);
        FakeYpositions = (FakeChannelRange-1)*Data.Info.ChannelSpacing;
        StartDepth = min(FakeYpositions(Data.Info.ProbeInfo.ActiveChannel(CurrentlyActiveChannel)));
        StopDepth = max(FakeYpositions((Data.Info.ProbeInfo.ActiveChannel(CurrentlyActiveChannel))));
    else
        FakeChannelRange = 1:length(CurrentlyActiveChannel);
        FakeYpositions = (FakeChannelRange-1)*Data.Info.ChannelSpacing;
        StartDepth = min(FakeYpositions);
        StopDepth = max(FakeYpositions);
    end
end