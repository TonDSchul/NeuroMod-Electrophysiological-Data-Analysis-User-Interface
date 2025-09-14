function Data = Extract_Events_Module_Add_EventRelatedInfo(Data,TimeWindowBefore,TimeWindowAfter)
    
    Data.Info.EventRelatedDataTimeRange = convertStringsToChars(strcat(TimeWindowBefore," ",TimeWindowAfter)) ;
    Data.Info.EventRelatedActiveChannel = Data.Info.ProbeInfo.ActiveChannel;