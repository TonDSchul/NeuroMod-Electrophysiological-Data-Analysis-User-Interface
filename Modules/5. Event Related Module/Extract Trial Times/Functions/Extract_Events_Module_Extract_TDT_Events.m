function [Events,EventChannelNames,Error] = Extract_Events_Module_Extract_TDT_Events(EventInfo,FileTypeDropDown,InputChannelSelection)

Error = [];
EventDataTye = [];
EventChannelNames = [];
Events = [];

if strcmp(FileTypeDropDown,'TDT Trigger scalars:Evnt') 
    EventDataTye = 'sE';
elseif strcmp(FileTypeDropDown,'TDT Trigger scalars:Tria') 
    EventDataTye = 'sT';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Evnt') 
    EventDataTye = 'eE';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Tria') 
    EventDataTye = 'eT';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Brst') 
    EventDataTye = 'eB';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Stro') 
    EventDataTye = 'eS';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Tick') 
    EventDataTye = 'eT';
end

if isempty(EventDataTye)
    disp("Could not determine trigger type")
    Error = 1;
    return;
end

Laufvariable=1;
for i = 1:length(InputChannelSelection)
    CurrentEventChannelIndice = EventInfo.(EventDataTye).ChannelIdentities == InputChannelSelection(i);
    
    if sum(CurrentEventChannelIndice)>0
        Events{Laufvariable} = EventInfo.(EventDataTye).Timestamps(CurrentEventChannelIndice);
        if size(Events{Laufvariable},1)>size(Events{Laufvariable},2)
            Events{Laufvariable} = Events{Laufvariable}';
        end
        EventChannelNames{Laufvariable} = convertStringsToChars(strcat(FileTypeDropDown," Ch ",num2str(InputChannelSelection(i))));
        Laufvariable = Laufvariable+1;
    else
        disp("Selected input channel selection nr ",num2str(InputChannelSelection(i)),"contains no valid trigger.")
    end
    
end

