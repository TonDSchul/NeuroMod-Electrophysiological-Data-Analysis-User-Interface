function [StartDepth,StopDepth,FakeChannelRange,FakeYpositions] = Spike_Module_Analysis_Determine_Depths(Data,PreservePlotChannelLocations,CurrentlyActiveChannel)

[CurrentlyActiveChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,CurrentlyActiveChannel,'MainPlot');

if PreservePlotChannelLocations
    FakeChannelRange = 1:max(Data.Info.ProbeInfo.ActiveChannel);
    FakeYpositions = (FakeChannelRange-1)*Data.Info.ProbeInfo.FakeSpacing;
    StartDepth = min(FakeYpositions(Data.Info.ProbeInfo.ActiveChannel(CurrentlyActiveChannel)));
    StopDepth = max(FakeYpositions((Data.Info.ProbeInfo.ActiveChannel(CurrentlyActiveChannel))));
else
    FakeChannelRange = 1:length(CurrentlyActiveChannel);
    FakeYpositions = (FakeChannelRange-1)*Data.Info.ProbeInfo.FakeSpacing;
    StartDepth = min(FakeYpositions);
    StopDepth = max(FakeYpositions);
end
