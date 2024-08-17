function [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,SpikeType)

Error = 0;

if isempty(Data.Spikes)
    msgbox("No Kilosort Data found.");
    Error = 1;
    return;
end

if ~isfield(Data.Info,'EventRelatedDataTimeRange')
    msgbox("Error: Please first extract event related data to specify a time window for events.");
    Error = 1;
    return;
end

%% Extract Event Related Spikes from Kilosort
for i = 1:length(Data.Info.EventChannelNames)
    if strcmp(Data.Info.EventRelatedDataChannel,Data.Info.EventChannelNames{i})
        EventtoShow = i;
    end
end

spaceindicie = strfind(Data.Info.EventRelatedDataTimeRange," ");
TimearoundEvent(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
TimearoundEvent(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));

% if strcmp(SpikeType,"Internal")
%     % Time around event
%     NumSamplesBefore = TimearoundEvent(1);
%     NumSamplesAfter = TimearoundEvent(2);
% else
    % Time around event
    NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.NativeSamplingRate);
    NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.NativeSamplingRate);
% end

Data.EventRelatedSpikes.SpikeTimes = [];
Data.EventRelatedSpikes.SpikePositions = [];
Data.EventRelatedSpikes.SpikeCluster = [];
Data.EventRelatedSpikes.SpikeEvents = [];
Data.EventRelatedSpikes.SpikeAmps = [];

% Convert Event indicies in time 
% if strcmp(SpikeType,"Internal")
    % Events = Data.Events{EventtoShow}./Data.Info.NativeSamplingRate;
    % SpikeTimes = Data.Spikes.SpikeTimes./Data.Info.NativeSamplingRate;
Events = Data.Events{EventtoShow};
SpikeTimes = Data.Spikes.SpikeTimes;
% else
%     Events = Data.Events{EventtoShow};
%     SpikeTimes = Data.Spikes.SpikeTimes;
% end

% Loop over event indicies (trials)
for nevents = 1:size(Data.EventRelatedData,2)
    % Extracts Spike Times from Kilosort Spike
    % positions within event range
    SpikeIndicieWithinCurrentEvent = SpikeTimes > Events(nevents)-NumSamplesBefore & SpikeTimes <= Events(nevents)+NumSamplesAfter;

    % EventsSpikeeTimes
    TempSpikeTimes = SpikeTimes(SpikeIndicieWithinCurrentEvent==1);
    TempSpikeTimes = TempSpikeTimes - (Events(nevents) - NumSamplesBefore); % Scaled to event (Time 0)
    
    Data.EventRelatedSpikes.SpikeTimes = [Data.EventRelatedSpikes.SpikeTimes;TempSpikeTimes];
    Data.EventRelatedSpikes.SpikePositions = [Data.EventRelatedSpikes.SpikePositions;Data.Spikes.SpikePositions(SpikeIndicieWithinCurrentEvent==1,2)];
    Data.EventRelatedSpikes.SpikeAmps = [Data.EventRelatedSpikes.SpikeAmps;Data.Spikes.SpikeAmps(SpikeIndicieWithinCurrentEvent==1)];
    Data.EventRelatedSpikes.SpikeEvents = [Data.EventRelatedSpikes.SpikeEvents;zeros(sum(SpikeIndicieWithinCurrentEvent),1)+nevents];

    if strcmp(SpikeType,"Kilosort")
        Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;Data.Spikes.SpikeCluster(SpikeIndicieWithinCurrentEvent==1)];
    else
        Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;zeros(sum(SpikeIndicieWithinCurrentEvent),1)]; 
    end

    if sum(Data.EventRelatedSpikes.SpikeTimes(Data.EventRelatedSpikes.SpikeTimes<=0)) > 0
        Data.EventRelatedSpikes.SpikeTimes(Data.EventRelatedSpikes.SpikeTimes<=0) = 1;
    end
 
end


