function [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,SpikeType,SpikeTriggereAverage,EventDataType,EventChannelName)

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
% 4. EventDataType: char, either 'Raw Event Related Data' or 'Preprocessed
% Event Related Data'. 
% 5.EventChannelName: char, name of the event channel to extract event
% related spikes for

% Output
% 1. Data: main window data structure with added field Data.EventRelatedSpikes
% 2. Error: double, 1 if error occured, 0 otherwise

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

h = waitbar(0, 'Extract Event Related Spikes...', 'Name','Extract Event Related Spikes...');

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
    if strcmp(EventChannelName,Data.Info.EventChannelNames{i})
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
Data.EventRelatedSpikes.SpikeChannel = [];
Data.EventRelatedSpikes.SpikeWaveforms = [];
Data.EventRelatedSpikes.DataCorrectedSpikePositions = [];

Events = Data.Events{EventtoShow};
SpikeTimes = Data.Spikes.SpikeTimes;

if strcmp(EventDataType,"Preprocessed Event Related Data")
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials')
        % Find rejection indices for the currently selected event channel
        Namevector = split(string(Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames), ',');
        TrialrejectionindiciesCurrentChannel = find(Namevector == EventChannelName);
        % Select trials if event channel found
        if ~isempty(TrialrejectionindiciesCurrentChannel)
            TrialsToReject = Data.Info.EventRelatedPreprocessing.TrialRejectionTrials(TrialrejectionindiciesCurrentChannel);
        else
            TrialsToReject = [];
        end
        
        AllTrialIdentities = 1:length(Events);

        if ~isempty(TrialsToReject)
            AllTrialIdentities(TrialsToReject) = [];
        end
    else
        AllTrialIdentities = 1:length(Events);
    end

else
    AllTrialIdentities = 1:length(Events);
end

% Loop over event indicies (trials)
for i = 1:length(AllTrialIdentities)
    
    nevents = AllTrialIdentities(i);

    msg = sprintf('Extract Event Related Spikes... (%d%% done)', round(100*(nevents/length(AllTrialIdentities))));
    waitbar(nevents/length(AllTrialIdentities), h, msg);
    
    if strcmp(EventDataType,"Preprocessed Event Related Data")
        if sum(Data.Info.EventRelatedPreprocessing.TrialRejectionTrials == nevents) == 1
            continue;
        end
    end

    % Extracts Spike Times from Kilosort Spike
    % positions within event range
    SpikeIndicieWithinCurrentEvent = SpikeTimes > Events(nevents)-NumSamplesBefore & SpikeTimes <= Events(nevents)+NumSamplesAfter;
    
    if ~ isempty(SpikeIndicieWithinCurrentEvent)
        % EventsSpikeeTimes
        TempSpikeTimes = SpikeTimes(SpikeIndicieWithinCurrentEvent==1);
        
        if SpikeTriggereAverage == 0
            TempSpikeTimes = TempSpikeTimes - (Events(nevents) - NumSamplesBefore); % Scaled to event (Time 0)
        end
        
        Data.EventRelatedSpikes.SpikeTimes = [Data.EventRelatedSpikes.SpikeTimes;TempSpikeTimes];
        Data.EventRelatedSpikes.SpikePositions = [Data.EventRelatedSpikes.SpikePositions;Data.Spikes.SpikePositions(SpikeIndicieWithinCurrentEvent==1,2)];
        Data.EventRelatedSpikes.SpikeAmps = [Data.EventRelatedSpikes.SpikeAmps;Data.Spikes.SpikeAmps(SpikeIndicieWithinCurrentEvent==1)];
        Data.EventRelatedSpikes.SpikeEvents = [Data.EventRelatedSpikes.SpikeEvents;zeros(sum(SpikeIndicieWithinCurrentEvent),1)+i];
        Data.EventRelatedSpikes.SpikeChannel = [Data.EventRelatedSpikes.SpikeChannel;Data.Spikes.SpikeChannel(SpikeIndicieWithinCurrentEvent==1)];
        Data.EventRelatedSpikes.SpikeWaveforms = [Data.EventRelatedSpikes.SpikeWaveforms;Data.Spikes.Waveforms(SpikeIndicieWithinCurrentEvent==1,:)];
        
        UinquePos = unique(Data.Spikes.ChannelPosition(:,1));

        if isfield(Data.Info,'Sorter')
            if ~strcmp(Data.Info.Sorter,"Non")
                if numel(UinquePos)>=2 
                    Data.EventRelatedSpikes.DataCorrectedSpikePositions = [Data.EventRelatedSpikes.DataCorrectedSpikePositions;Data.Spikes.DataCorrectedSpikePositions(SpikeIndicieWithinCurrentEvent==1,2)];
                end
            end
        end

        if strcmp(SpikeType,"Kilosort") || isfield(Data.Info,'SpikeSorting')
            Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;Data.Spikes.SpikeCluster(SpikeIndicieWithinCurrentEvent==1)];
        elseif strcmp(SpikeType,"Internal")
            if strcmp(Data.Info.Sorter,'WaveClus')
                Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;Data.Spikes.SpikeCluster(SpikeIndicieWithinCurrentEvent==1)];
            else
                Data.EventRelatedSpikes.SpikeCluster = [Data.EventRelatedSpikes.SpikeCluster;zeros(sum(SpikeIndicieWithinCurrentEvent),1)]; 
            end
        end
    
        if sum(Data.EventRelatedSpikes.SpikeTimes(Data.EventRelatedSpikes.SpikeTimes<=0)) > 0
            Data.EventRelatedSpikes.SpikeTimes(Data.EventRelatedSpikes.SpikeTimes<=0) = 1;
        end
    end
end

if ~isempty(h)
    close(h);
end


