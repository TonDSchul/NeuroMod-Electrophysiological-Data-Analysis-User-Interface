function [NeoEventStartTimeStamp,EventInfo,EventDataLocation,texttoshow] = Extract_Events_Module_NEO_Determine_Available_EventChannel(Data,Path)

% Search standard folder with results
texttoshow = [];
EventInfo = [];
NeoEventStartTimeStamp = 1;
EventDataLocation = [];

% differentiate between foramts requiring paths and files
if contains(Data.Info.FileType,"Plexon") || contains(Data.Info.FileType,"Blackrock") || contains(Data.Info.FileType,"Explorer")
    ModifiedSaveFile = strcat(Path," Neo SaveFile");
else
    dashindice = find(Path == '\');
    Foldername = Path(dashindice(end)+1:end);
    ModifiedSaveFile = strcat(Path(1:dashindice(end)),Foldername," Neo SaveFile");
end

if ~isfolder(ModifiedSaveFile)
    warning(strcat("NEO Output folder could not be found! After succesfull data extraction with NEO, data is saved in folder: ",ModifiedSaveFile))
    texttoshow = strcat("NEO Output folder could not be found! After succesfull data extraction with NEO, data is saved in folder: ",ModifiedSaveFile);
    return;
end

EventDataLocation = strcat(ModifiedSaveFile,'\NEO_Saved_EventData.mat');

% if events there
if isfile(EventDataLocation)
    %load
    load(EventDataLocation)
    % check if all variables present
    a = 0;
    if exist('event_channels','var')
        a = a+1;
    end
    if exist('event_labels','var')
        a = a+1;
    end
    if exist('event_samples','var')
        a = a+1;
    end
    
    if a < 3
        warning(strcat("One of the following variables could not be loaded: event_channels,event_labels,event_samples from ",EventDataLocation));
        texttoshow = strcat("One of the following variables could not be loaded: event_channels,event_labels,event_samples from ",EventDataLocation);
        return
    end
    % throw out start and stop time
    DeleteIndice = zeros(size(event_channels));
    matchIdxstart = find(strcmp(event_labels, 'Starting Recording'));
    matchIdxstop = find(strcmp(event_labels, 'Stopping Recording'));
    
    if ~isempty(matchIdxstart)
        DeleteIndice(matchIdxstart)=1;
    end
    if ~isempty(matchIdxstop)
        DeleteIndice(matchIdxstart)=1;
    end

    if ~isempty(matchIdxstart)
        NeoEventStartTimeStamp = double(event_samples(matchIdxstart));
        if NeoEventStartTimeStamp == 0
            NeoEventStartTimeStamp = 1;
        end
    else
        NeoEventStartTimeStamp = 1;
    end
    
    if sum(DeleteIndice)>0
        event_channels(DeleteIndice==1) = [];
        event_labels(DeleteIndice==1) = [];
        event_samples(DeleteIndice==1) = [];
    end

    % see if there are events and how many 
    EventInfo.NumEvents = length(event_labels);
    EventInfo.event_channels = double(event_channels);
    EventInfo.event_labels =  event_labels;
    
    EventInfo.event_samples = (double(event_samples)-NeoEventStartTimeStamp)+1;

    % create info text to show
    texttoshow = strings(EventInfo.NumEvents, 1);
    
    texttoshow(1) = "Following event channel, event labels(not completly shown!) and even times found:";
    texttoshow(2) = strcat("(Number of event events found across all channel: ",num2str(EventInfo.NumEvents),") with start time stamp: ",num2str(NeoEventStartTimeStamp));
    texttoshow(3) = "";

    for i = 1:EventInfo.NumEvents
        ch = EventInfo.event_channels(i);
        if length(EventInfo.event_labels{i}) >= 14
            label = string(EventInfo.event_labels{i}(1:14));
        else
            label = string(EventInfo.event_labels{i});
        end

        time = EventInfo.event_samples(i);
        texttoshow(i+3) = sprintf('Chan.: %d | Label: %s | Sample Nr.: %d', ch, label, time);
    end

else
    warning(strcat("Could not find .mat file with saved event data at: ",EventDataLocation));
    texttoshow = strcat("Could not find .mat file with saved event data at: ",EventDataLocation);
    return
end
