function [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,SpikeType,SpikeTriggereAverage)

%________________________________________________________________________________________

%% Function to extract spikes within specified range around events
% This function takes all spikes and sorts for those in the event range
% every time, the window for event spike analysis is opened. It is saved as
% Data.EventRelatedSpikes structure, which gets overwritten every time

% This function gets called in the main window when the user clicks on run
% for event spike analysis (Internal and Kilosort)

% Input:
% 1. Data: main window data structure containing Spike Data and Data.Info for event
% infos (like the time range)
% 2. SpikeType: Type of spikes available, Options: 'Kilosort' OR
% 'Internal', from Data.Info.SpikeType
% 3. SpikeTriggereAverage: double, Either 1 to indicate that SpikeTriggereAverage
% is plotted. This means, that spike samples are not "normalized" to event
% time range. This enables to extract spike data from raw/preprocessed data. 0
% Otherwise

% Output
% 1. Data: main window data structure with added field Data.EventRelatedSpikes
% 2. Error: double, 1 if error occured, 0 otherwise

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Error = 0;

if isempty(Data.Spikes)
    msgbox("No Spike Data found.");
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

NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.NativeSamplingRate);
NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.NativeSamplingRate);

Data.EventRelatedSpikes.SpikeTimes = [];
Data.EventRelatedSpikes.SpikePositions = [];
Data.EventRelatedSpikes.SpikeCluster = [];
Data.EventRelatedSpikes.SpikeEvents = [];
Data.EventRelatedSpikes.SpikeAmps = [];

Events = Data.Events{EventtoShow};
SpikeTimes = Data.Spikes.SpikeTimes;

% Loop over event indicies (trials)
for nevents = 1:size(Data.EventRelatedData,2)
    % Extracts Spike Times from Kilosort Spike
    % positions within event range
    SpikeIndicieWithinCurrentEvent = SpikeTimes > Events(nevents)-NumSamplesBefore & SpikeTimes <= Events(nevents)+NumSamplesAfter;

    % EventsSpikeeTimes
    TempSpikeTimes = SpikeTimes(SpikeIndicieWithinCurrentEvent==1);
    
    if SpikeTriggereAverage == 0
        TempSpikeTimes = TempSpikeTimes - (Events(nevents) - NumSamplesBefore); % Scaled to event (Time 0)
    end
    
    Data.EventRelatedSpikes.SpikeTimes = [Data.EventRelatedSpikes.SpikeTimes;TempSpikeTimes];
    Data.EventRelatedSpikes.SpikePositions = [Data.EventRelatedSpikes.SpikePositions;Data.Spikes.SpikePositions(SpikeIndicieWithinCurrentEvent==1,2)];
    Data.EventRelatedSpikes.SpikeAmps = [Data.EventRelatedSpikes.SpikeAmps;Data.Spikes.SpikeAmps(SpikeIndicieWithinCurrentEvent==1)];
    Data.EventRelatedSpikes.SpikeEvents = [Data.EventRelatedSpikes.SpikeEvents;zeros(sum(SpikeIndicieWithinCurrentEvent),1)+nevents];

    if strcmp(SpikeType,"Kilosort")
        Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;Data.Spikes.SpikeCluster(SpikeIndicieWithinCurrentEvent==1)];
    else
        if isfield(Data.Info,'SpikeSorting')
            Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;Data.Spikes.SpikeCluster(SpikeIndicieWithinCurrentEvent==1)];
        else
            Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;zeros(sum(SpikeIndicieWithinCurrentEvent),1)]; 
        end
    end

    if sum(Data.EventRelatedSpikes.SpikeTimes(Data.EventRelatedSpikes.SpikeTimes<=0)) > 0
        Data.EventRelatedSpikes.SpikeTimes(Data.EventRelatedSpikes.SpikeTimes<=0) = 1;
    end
 
end


