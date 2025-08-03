function [Events,EventChannelNames] = Extract_Events_Module_Neuralynx_Manage_Events_Main(event,Data,InputChannelSelection)

EventChannelNames = {};
Events = {};

EventSamples = double(cell2mat({event.sample}));
EventValues = double(cell2mat({event.value}));

EventChannelNames = cell(1,length(InputChannelSelection));
for i = 1:length(InputChannelSelection)
    EventChannelNames{i} = convertStringsToChars(strcat("Event Ch ",num2str(InputChannelSelection(i))));
end

UniqueChannel = unique(EventValues);
SelecteChannelIndice = UniqueChannel==InputChannelSelection;

UniqueChannel(SelecteChannelIndice==0) = [];
Events = cell(1,sum(SelecteChannelIndice));
DeleteIndice = [];


for neventchannel = 1:length(UniqueChannel)
    CurrentChannelIndice = EventValues == UniqueChannel(neventchannel);
    
    if sum(CurrentChannelIndice)>0
        Events{neventchannel} = double(EventSamples(CurrentChannelIndice));
    else
        Events{neventchannel} = [];
        DeleteIndice = [DeleteIndice,neventchannel];
    end
end

if ~isempty(DeleteIndice)
    if length(DeleteIndice) == length(Events)
        msgbox("Error: No trigger for selected channel remain/found! Please select different input event channel!");
        return;
    else
        msgbox(strcat("Warning: Event channel",num2str(DeleteIndice)," are deleted since they dont contain valid event trigger!"));
        Events(DeleteIndice) = [];
    end
end
