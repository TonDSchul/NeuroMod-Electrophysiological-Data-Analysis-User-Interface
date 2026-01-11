function [Data,InputChannelData] = Extract_Events_Module_Extract_Event_Indicies_Intan(Data,ChannelPath,InputChannelType,Threshold,InputChannelData,EventInfoType)

%________________________________________________________________________________________
%% Function that takes 1 x nrecordingtime event data and searches for events

% This function thresholds the event data signal. When the signal is
% exceeding a threshold, the indicie is saved. 
% Since many consecutive indicies can be bigger than the treshold, from each sequence only the first indicie is saved.

%gets called by the Extract_Events_Module_Extract_Events_Intan function
%when the user starts event extraction

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data and
% the info structure.
% 2. ChannelPath: 1 x n vector with indicies of event channel (indicies of
% all foldercontents found) -- usefull but not used here
% 3. InputChannelType: type of event to look for; for Intan: "Digital Inputs" or "Analog Input" or "AUX
% Inputs"; For Open Ephys: "Record Node 101" --> This is what is selected
% at standard in the GUI as File Type.
% 4. Threshold: double representing threshold for idientifying events -->
% signal has to be >= threshold
% 5. InputChannelData: 1 x ntime data for each event channel of the specified InputChannelType
% 6. EventInfoType: char, Either 'Event Onset' or 'Event Offset' to
% determine whether rising or falling edge should be detected
% Outputs:
% 1. Data: Data structure with added field:
% Data.Events{1:neventchannelfound} containing a 1 x nevents vector with
% event indicies in samples. Data.Info gets also info about channelnames and InputChannelType
% 2. InputChannelData: 1 x ntime data for each event channel of the
% specified InputChannelType; transposed and converted to rising edge if
% necessary -- not used yet

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Check if all specified Event Channel are non empty

%% Convert Falling Edge in Rising Edge

for numchannels = 1:length(InputChannelData)
    
    if isempty(InputChannelData{numchannels})
        msgbox(strcat("Warning: Event Channel ",num2str(numchannels)," is empty. Please delete this channel from the channel selection in the extract events window and start again. Stopping"));
        if isfield(Data,'Events')
            fieldsToDelete = {'Events'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
        end
        return;
    end

    if size(InputChannelData{numchannels},2) == 1
        InputChannelData{numchannels} = InputChannelData{numchannels}(:)';
    end

end

%% Extract Distinct events
% Thresholding: Is current value above the treshold, the value before
% that under the treshold and the value after that above the treshold?

Data.Events = cell(1,length(InputChannelData));

for numchannels = 1:length(InputChannelData)   
    % Find the indices of elements greater than the threshold

    aboveThreshold = InputChannelData{numchannels} >= Threshold;

    belowThreshold = InputChannelData{numchannels} < Threshold;

    if sum(aboveThreshold) == length(InputChannelData{numchannels}) || sum(belowThreshold) == length(InputChannelData{numchannels}) % --> if no value smaller than threshold: ill defined, no events captured
        msgbox(strcat("No value smaller than threshold: ill defined, no trigger captured for event channel",num2str(numchannels))); 
        Data.Events{numchannels} = [];
    else
        if strcmp(EventInfoType,'Rising Edge')
            % Detect rising edge 
            for i = 2:length(aboveThreshold)
                if aboveThreshold(i-1) == 0 && aboveThreshold(i) == 1
                    Data.Events{numchannels} = [Data.Events{numchannels}, i];
                end
            end
        elseif strcmp(EventInfoType,'Falling Edge')
            % Detect falling edge 
            for i = 2:length(aboveThreshold)
                if belowThreshold(i-1) == 0 && belowThreshold(i) == 1
                    if i ~= 1
                        Data.Events{numchannels} = [Data.Events{numchannels}, i];
                    end
                end
            end
        end
    end
end

for numevents = 1:length(Data.Events)
    if length(Data.Events{numevents}) > 1000
        msgbox(strcat("Warning: Event Channel ",num2str(numevents)," has extracted more than 1000 events. If this is not expected try to change the threshold accordingly.")); 
    end
end
