function [Events,EventChannelNames,Error] = Extract_Events_Module_Extract_TDT_Events(EventInfo,FileTypeDropDown,InputChannelSelection,State)

%________________________________________________________________________________________

%% This function extracts event data from TDT recordings loaded with the TDTMatlabSDK

% NOTE: event data from actual raw recording is extracted and saved in the
% variable EventInfo in the
% Extract_Events_Module_Determine_Available_EventChannel.m function. This
% function here just organizes/analysis this output

% Input:
% 1. EventInfo: struc, with those fileds for each event data type: EventInfo.eTr.OnsetChannelIdentities = [];
            %EventInfo.eTr.OffsetChannelIdentities = [];
            %EventInfo.eTr.OnsetTimestamps = [];
            %EventInfo.eTr.OffsetTimestamps = []; The name of the second
            %structure field is based on which event type was detected!
% FileTypeDropDown: char, value/user selection from the input channel type dorpdown on top
% InputChannelSelection: double vector with all channel from the event type
% above
% State: char, either 'Trigger Onset' OR 'Trigger Offset'

% Output: 
% 1. Events: cell array, with each cell containing a double 1 x n vecotr
% with samples of events
% EventChannelNames: cell with one char per cell designating the name of
% the event channel for each cell in 1. 
% Error: double 1 or 0 whether error occured

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________
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

