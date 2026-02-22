function [Events,EventChannelNames,Error] = Extract_Events_Module_Maxwell_MEA(Data,FullPath,EventType,EventInputChannel,TriggerType)

%________________________________________________________________________________________

%% Function to extract Maxwell MEA .h5 event data stored in bits or eventdata

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% 2. FullPath: char to maxwell recording folder
% 3. EventType: char, "Bits Group" or "Event Group" from which part of the
% recording object events are extracted
% 4. EventInputChannel: double vector with channel indicies to extract
% 5. TriggerType: char, either "Trigger Onset" or "Trigger Offset"

% Output
% 1.Events: cell array with each cell being a 1 x nevents vector with
% samples
% 2. EventChannelNames: cell array with char for each event channel holding its name 
% 3. Error: double 1 or 0 whether error occured

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Error = 0;
Events = [];
EventChannelNames = [];

%% Check install
try
    info = h5info(FullPath);
catch
    msgbox(strcat("Error: Could not read file in ",FullPath,".Either the required compression.dll file is not installed or the dataset moved location."));
    Error = 1;
    return;
end

%% Get event data from bits values

if strcmp(EventType,"Bits Group")

    FullTimeStamps = h5read(FullPath, '/data_store/data0000/groups/routed/frame_nos');

    try
        bits_data = h5read(FullPath, '/bits/0');   % or '/bits/0000' depending on file
        Events{1} = double(bits_data.frameno) - double(FullTimeStamps(1));
        EventChannelNames{1} = 'Trigger Channel 1';
        Events{1} = Events{1}';
        if strcmp(TriggerType,"Trigger Onset")
            Events{1} = Events{1}(1:2:end);
        elseif strcmp(TriggerType,"Trigger Offset")
            Events{1} = Events{1}(2:2:end);
        end
    catch
        try
            bits_data = h5read(FullPath, '/bits/0000');   % or '/bits/0000' depending on file
            Events{1} = double(bits_data.frameno) - double(FullTimeStamps(1));
            EventChannelNames{1} = 'Trigger Channel 1';
            Events{1} = Events{1}';
            if strcmp(TriggerType,"Trigger Onset")
                Events{1} = Events{1}(1:2:end);
            elseif strcmp(TriggerType,"Trigger Offset")
                Events{1} = Events{1}(2:2:end);
            end
        catch
            warning("Could not access bits data for event times. Only relevant if event information is present.")
            Events = [];
            EventChannelNames = [];
            return;
        end
    end
else

    FullTimeStamps = h5read(FullPath, '/data_store/data0000/groups/routed/frame_nos');

    events = h5read(FullPath, '/data_store/data0000/events');
    Events = {};
    event_frameno  = events.frameno;
    event_type     = events.eventtype;
    event_id       = events.eventid;
    event_message  = events.eventmessage;
    
    if isempty(EventInputChannel)
        EventInputChannel = 1:length(unique(event_id));
    end

    for i = 1:length(EventInputChannel)
        EventIndcies = event_id == EventInputChannel(i);
        if ~isempty(EventIndcies)
            Events{end+1} = double(event_frameno(EventIndcies)) - double(FullTimeStamps(1));
            if size(Events{end},1)>size(Events{end},2)
                Events{end} = Events{end}';
                if strcmp(TriggerType,"Trigger Onset")
                    Events{end} = Events{end}(1:2:end);
                elseif strcmp(TriggerType,"Trigger Offset")
                    Events{end} = Events{end}(2:2:end);
                end
            end

            EventChannelNames{end+1} = strcat('Trigger Channel ',num2str(i));
        end
    end
end

