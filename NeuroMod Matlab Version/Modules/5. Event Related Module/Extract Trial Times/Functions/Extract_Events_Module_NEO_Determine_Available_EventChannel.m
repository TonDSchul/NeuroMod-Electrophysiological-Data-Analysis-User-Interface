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
MatlabNeoConversionLocation = strcat(ModifiedSaveFile,'\NEOMatlabConversion.mat');

%% --------------- First Load saved event data .mat file if events saved as costum file ------------------
CostumeEventFilePresent = 0;
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

    CostumeEventFilePresent = 1;
    disp("Loaded event data from custom Neo exported .mat format.")
end

if CostumeEventFilePresent == 0 && isfile(MatlabNeoConversionLocation)
    %load
    load(MatlabNeoConversionLocation)

    SampleRate = block.segments{1}.analogsignals{1}.sampling_rate;

    CostumeEventFilePresent = 1;
    
    event_channels = [];
    event_labels = [];
    event_samples = [];
    event_labels{1} = [];
    
    Laufvariable = 1;
    for i = 1:length(block.segments{1}.events)
        
        if isempty(block.segments{1}.events{Laufvariable}.times)
            Laufvariable = Laufvariable+1;
            continue
        end
        if strcmp(block.segments{1}.events{Laufvariable}.times_units,'ms')
            event_samples = [event_samples,round((block.segments{1}.events{Laufvariable}.times/1000) * SampleRate)];
        else
            event_samples = [event_samples,round(block.segments{1}.events{Laufvariable}.times * SampleRate)];
        end

        event_channels = [event_channels,zeros(size(block.segments{1}.events{Laufvariable}.times))+Laufvariable];
        
        for j = 1:length(block.segments{1}.events{Laufvariable}.times)
            if isempty(event_labels{1})
                event_labels{1} = [convertStringsToChars(num2str(Laufvariable))];
            else
                event_labels{end+1} = [convertStringsToChars(num2str(Laufvariable))];
            end
        end

        Laufvariable = Laufvariable+1;
    end

    disp("Loaded event data exported with official NEO IO .mat format.")

end

if CostumeEventFilePresent == 1
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
        if isfield(Data.Info,'Acquisition_start_samples')
            NeoEventStartTimeStamp = double(Data.Info.Acquisition_start_samples);
        else
            if isfield(Data.Info,'startTimestamp')
                NeoEventStartTimeStamp = double(Data.Info.startTimestamp);
            end
        end
    end
    
    if sum(DeleteIndice)>0
        event_channels(DeleteIndice==1) = [];
        event_labels(DeleteIndice==1) = [];
        event_samples(DeleteIndice==1) = [];
    end
    
    if isempty(event_samples)
        EventInfo = [];
        msgbox("After selecting start and stop time stamps, no trigger remain!")
        return;
    end
    
    %% Correct for different timetoextract
    if contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,',')
        if ~contains(Data.Info.TimeAndChannelToExtract.TimeToExtract,'Inf')
            Timetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
        else
            TempTimetoextract = str2double(strsplit(Data.Info.TimeAndChannelToExtract.TimeToExtract,','));
            Timetoextract(1) = TempTimetoextract(1);
            Timetoextract(2) = Data.Time(end); 
        end
    else
        Timetoextract = eval(Data.Info.TimeAndChannelToExtract.TimeToExtract);
    end
     % convert to samples
    Timetoextract = round(Timetoextract*Data.Info.NativeSamplingRate);
    if Timetoextract(1)==0
        Timetoextract(1) = 1;
    end
    
    %% Actually correct for specific time to extract
    event_samples = double(event_samples);
    event_samples = event_samples - (Timetoextract(1)-1);
    IndiciesSmallerTime = event_samples<=0;
    event_samples(event_samples<=0) = [];
    event_labels(IndiciesSmallerTime) = [];
    event_channels(IndiciesSmallerTime) = [];

    if ~isfield(Data.Info,'CutEnd') && ~isfield(Data.Info,'CutStart')
        if sum(event_samples > length(Data.Time))>0
            currentsamples = (double(event_samples)-NeoEventStartTimeStamp)+1;
            DeletedIndices = find(currentsamples > length(Data.Time));
            if ~isempty(DeletedIndices)
                event_channels(DeletedIndices) = [];
                event_labels(DeletedIndices) = [];
                event_samples(DeletedIndices) = [];
                msgbox(strcat(num2str(length(DeletedIndices))," trigger outside of time window found that are deleted!"));
            end
        end
        
        if isempty(event_samples)
            EventInfo = [];
            msgbox("After deleting trigger outside of time window, no trigger remain!")
            return;
        end
    end
    
    % %% Actually correct for specific time to extract
    % event_samples = double(event_samples);
    % IndiciesBiggerTime = event_samples>Timetoextract(2);
    % event_samples(event_samples>Timetoextract(2)) = [];
    % event_labels(IndiciesBiggerTime) = [];
    % event_channels(IndiciesBiggerTime) = [];
    
    %% DO it again with samples bigger than time
    
    if contains(Data.Info.FileType,'OpenEphys') || contains(Data.Info.FileType,'Open Ephys')
        % see if there are events and how many 
        EventInfo.NumEvents = length(event_labels);
        EventInfo.event_channels = str2double(event_labels);
        %EventInfo.event_labels =  event_labels;
        for q = 1:length(event_channels)
            EventInfo.event_labels{q} =  num2str(double(event_channels(q)));
        end
        %EventInfo.event_labels =  mat2cell(double(event_channels));
    else
        % see if there are events and how many 
        EventInfo.NumEvents = length(event_labels);
        EventInfo.event_channels = double(event_channels);
        EventInfo.event_labels =  event_labels;
    end
    
    EventInfo.event_samples = round((double(event_samples)-NeoEventStartTimeStamp)+1);
    
    % create info text to show
    texttoshow = strings(EventInfo.NumEvents, 1);
    
    texttoshow(1) = "Following event channel, event labels (not completly shown!) and even times found:";
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

else % no save file found

    warning(strcat("Could not find .mat file with saved event data at: ",MatlabNeoConversionLocation)," or ",EventDataLocation);
    texttoshow = strcat("Could not find .mat file with saved event data at: ",MatlabNeoConversionLocation," or ",EventDataLocation);
    return
    
end

