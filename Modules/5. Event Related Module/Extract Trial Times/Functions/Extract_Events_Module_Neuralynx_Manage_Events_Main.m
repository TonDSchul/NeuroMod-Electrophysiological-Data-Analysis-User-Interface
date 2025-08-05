function [Events,EventChannelNames] = Extract_Events_Module_Neuralynx_Manage_Events_Main(event,Data,InputChannelSelection)

EventChannelNames = {};
Events = {};

%% --------------- Get data from event cell ------------------
EventSamples = double(cell2mat({event.sample}));
EventValues = double(cell2mat({event.value}));

%% --------------- Create event channel names ------------------
EventChannelNames = cell(1,length(InputChannelSelection));
for i = 1:length(InputChannelSelection)
    EventChannelNames{i} = convertStringsToChars(strcat("Event Ch ",num2str(InputChannelSelection(i))));
end

%% --------------- Get indice of input channel selected ------------------
UniqueChannel = unique(EventValues);
SelecteChannelIndice = ismember(UniqueChannel,InputChannelSelection);

%% --------------- Delete inidces not in input channel range ------------------
UniqueChannel(SelecteChannelIndice==0) = [];
Events = cell(1,sum(SelecteChannelIndice));
DeleteIndice = [];

%% --------------- Loop over remaining event channel , save their indices in differenct cells------------------
for neventchannel = 1:length(UniqueChannel)
    CurrentChannelIndice = EventValues == UniqueChannel(neventchannel);
    
    if sum(CurrentChannelIndice)>0
        Events{neventchannel} = double(EventSamples(CurrentChannelIndice));
    else
        Events{neventchannel} = [];
        DeleteIndice = [DeleteIndice,neventchannel];
    end
end
%% --------------- Wrap up ------------------

if ~isempty(DeleteIndice)
    if length(DeleteIndice) == length(Events)
        msgbox("Error: No trigger for selected channel remain/found! Please select different input event channel!");
        return;
    else
        msgbox(strcat("Warning: Event channel",num2str(DeleteIndice)," are deleted since they dont contain valid event trigger!"));
        Events(DeleteIndice) = [];
    end
end
