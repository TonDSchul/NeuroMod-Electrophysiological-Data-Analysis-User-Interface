function [Events,EventChannelNames,Error] = Extract_Events_Module_Extract_TDT_Events(EventInfo,FileTypeDropDown,InputChannelSelection,State)

Error = [];
TriggerTye = [];
EventChannelNames = [];
Events = [];

if strcmp(FileTypeDropDown,'TDT Trigger scalars:Evnt') 
    TriggerTye = 'sE';
elseif strcmp(FileTypeDropDown,'TDT Trigger scalars:Tria') 
    TriggerTye = 'sT';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Evnt') 
    TriggerTye = 'eE';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Tria') 
    TriggerTye = 'eTr';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Brst') 
    TriggerTye = 'eB';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Stro') 
    TriggerTye = 'eS';
elseif strcmp(FileTypeDropDown,'TDT Trigger epocs:Tick') 
    TriggerTye = 'eT';
end

if isempty(TriggerTye)
    disp("Could not determine trigger type")
    Error = 1;
    return;
end

Laufvariable=1;
for i = 1:length(InputChannelSelection)
    if strcmp(TriggerTye,"eE") || strcmp(TriggerTye,"eTr") || strcmp(TriggerTye,"eS") || strcmp(TriggerTye,"eB") || strcmp(TriggerTye,"eT")
            if strcmp(State,"Trigger Onset")
                CurrentEventChannelIndice = EventInfo.(TriggerTye).OnsetChannelIdentities == InputChannelSelection(i);
            else
                CurrentEventChannelIndice = EventInfo.(TriggerTye).OffsetChannelIdentities == InputChannelSelection(i);
            end
    else
        CurrentEventChannelIndice = EventInfo.(TriggerTye).ChannelIdentities == InputChannelSelection(i);
    end
    
    
    if sum(CurrentEventChannelIndice)>0
        if strcmp(TriggerTye,"eE") || strcmp(TriggerTye,"eTr") || strcmp(TriggerTye,"eS") || strcmp(TriggerTye,"eB") || strcmp(TriggerTye,"eT")
            if strcmp(State,"Trigger Onset")
                Events{Laufvariable} = EventInfo.(TriggerTye).OnsetTimestamps(CurrentEventChannelIndice);
            else
                Events{Laufvariable} = EventInfo.(TriggerTye).OffsetTimestamps(CurrentEventChannelIndice);
            end
        else
            Events{Laufvariable} = EventInfo.(TriggerTye).Timestamps(CurrentEventChannelIndice);
        end
        if size(Events{Laufvariable},1)>size(Events{Laufvariable},2)
            Events{Laufvariable} = Events{Laufvariable}';
        end
        EventChannelNames{Laufvariable} = convertStringsToChars(strcat(FileTypeDropDown," Ch ",num2str(InputChannelSelection(i))));
        Laufvariable = Laufvariable+1;
    else
        disp("Selected input channel selection nr ",num2str(InputChannelSelection(i)),"contains no valid trigger.")
    end
    
end

