function [Data,ToKeep] = Spike_Module_Spike_Detection(Data,Detectionmethod,Type,STDThreshold,DepthFilter,Tolerance, ArtefactDepth, TimeOffSetFilter, TimeOffset)
%________________________________________________________________________________________

%% Function to extract Data.Spikes from preprocessed (high pass filtered) data using thresholding
%% NOTE: Only negative spikes are etracted, data amplitude therefore has to be smaller than threshold and biggest amplitude is the smallest value
% Input:
% 1. Data: Data structure containing high pass filtered preprocessed data as a Channel x Time matrix in Data.Preprocessed field.
% High pass filter required!
% 2. Detectionmethod: Thresholding Method. Options: "Quiroga Method" OR "Threshold: Mean - Std" OR "Threshold: Median - Std"; 
% 3. Type: Method to compute mean and std with. Options: "All Channel" OR "Individual Ch."
% 4. STDThreshold: Number of std's signal has to deviate from mean to count
% as spike. Standard: 4; Can vary depending on type selected
% 5. Filter: true or false, specify whether vertical artefacts should be
% filtered (same spike times +/- tolerance time over more channel then
% specified as ArtefactDepth are rejected) --> i.e. same spike time over 10
% Channel are deleted
% 6. Tolerance: Tolerance of vertical spike artefacts in samples as double. For example 3 means: spike time +/- 3 samples to the left and right over specified depth are counted as artefacts 
% 7. ArtefactDepth: Depth over which same spike times have to occur to count
% as a artefact, in um and as double

% Output: 
% 1. Data structure with added field 'Spikes' (Data.Spikes), called
% using app.Data.Spikes in GUI
% 2. ToKeep: strcuture saving information about spike filtering (when
% enabled) with deleting indicies and so on. Not implemented yet, thought
% of as a possibility for continous artefact rejection

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Check exisiting spike data. Already existing Data is deleted!
if isfield(Data,'Spikes')
    msgbox("Warning: Spike data already part of the dataset. Exisitng data will be removed.");
    Data.Spikes = [];
    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end

    if isfield(Data.Info,'SpikeSorting')
        fieldsToDelete = {'SpikeSorting'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'SpikeDetectionNrStd')
        fieldsToDelete = {'SpikeDetectionNrStd'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'SpikeDetectionThreshold')
        fieldsToDelete = {'SpikeDetectionThreshold'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    Data.Info.SpikeType = "Non";
end          
   
%% Spike Structure has to be same as for Kilosort. Parameters not applicable to this spike analyiss are the following: (they stay empty)
Data.Spikes.SpikeCluster = [];
Data.Spikes.SpikeTemplates = [];
Data.Spikes.templates_ind = [];
Data.Spikes.templates = [];
Data.Spikes.spike_detection_templates = [];
Data.Spikes.pc_features = [];
Data.Spikes.pc_feature_ind = [];
Data.Spikes.kept_spikes = [];
%% Field that can and/or have to be populated:
Data.Spikes.SpikeTimes = [];
Data.Spikes.SpikeAmps = [];
Data.Spikes.SpikeChannel = [];
Data.Spikes.ChannelMap = [];
Data.Spikes.ChannelPosition = [];
Data.Spikes.SpikePositions = [];

% Initiate waitbar 
h = waitbar(0, 'Extracting Spike Indicies...', 'Name','Extracting Spike Indicies...');
cN  = size(Data.Preprocessed,1);

%% Check which method and parameters selceted
if strcmp(Detectionmethod,"Threshold: Mean - Std")
    %% Correlated Noise: Mean of signal
    if strcmp(Type,"All Channel")
        CN = mean(Data.Preprocessed,'all');
        CNSTD = std2(Data.Preprocessed);
    end
    
    for nchannel = 1:size(Data.Preprocessed,1) % Channel
       indices = [];
       % Update the progress bar
       fraction = nchannel/cN;
       msg = sprintf('Extracting Spike Indicies... (%d%% done)', round(100*fraction));
       waitbar(fraction, h, msg);
    
        % Mean and std based on input 
        if strcmp(Type,"All Channel")
            Threshold = CN+STDThreshold.*CNSTD;
            indices = find(Data.Preprocessed(nchannel,:) < -Threshold);
        elseif strcmp(Type,"Individual Ch.")
            CN = mean(Data.Preprocessed(nchannel,:));
            CNSTD = std(Data.Preprocessed(nchannel,:));
            Threshold = CN+STDThreshold.*CNSTD;
            indices = find(Data.Preprocessed(nchannel,:) < -Threshold);
        end
        
        %% Spikes can have multiple consecutive samples below the threshold. Only one can be kept. Here, the smallest amplitude indicies is kept
        % Now only take the max of each consecutive sequence of indicies
        % found

        ToleranceDoubleWaveform = round(Data.Info.NativeSamplingRate*TimeOffset);
        
        % Initialize the cell array to store the start and end values of each sequence
        minMaxSpikes = [];
        currentGroup = indices(1); % Start with the first spike in a new group
        
        for i = 2:length(indices)
            % Check if the current index is within tolerance of the last index in the current group
            if abs(indices(i) - indices(i - 1)) <= ToleranceDoubleWaveform
                % If within tolerance, add it to the current group
                currentGroup = [currentGroup, indices(i)];
            else
                % Save only the smallest and largest values of the current group
                minMaxSpikes = [minMaxSpikes; currentGroup(1), currentGroup(end)];
                % Start a new group with the current spike
                currentGroup = indices(i);
            end
        end
        
        % Add the smallest and largest values of the last group
        TempSequences = [minMaxSpikes; currentGroup(1), currentGroup(end)];

        SpikeIndiciesBiggestWaveform = NaN(size(TempSequences,1),1);

        for nSequences = 1:size(TempSequences,1)
            if TempSequences(nSequences,1) ~= TempSequences(nSequences,2)
                % minimum = spike peak for current sequence
                [~,BiggestSequenceAmplitudes] = min(Data.Preprocessed(nchannel,TempSequences(nSequences,1):TempSequences(nSequences,2)));
                % indicie is in respect to range the minimum was searched
                % for. Has to be adjusted to the total recording legnth
                BiggestSequenceAmplitudes = TempSequences(nSequences,1)+(BiggestSequenceAmplitudes);
                
                SpikeIndiciesBiggestWaveform(nSequences) = BiggestSequenceAmplitudes;
            else
                if Data.Preprocessed(nchannel,TempSequences(nSequences,1)-2 > 0 && TempSequences(nSequences,1)+2 <= length(Data.Time))
                    [~,BiggestSequenceAmplitudes] = min(Data.Preprocessed(nchannel,TempSequences(nSequences,1)-2:TempSequences(nSequences,1)+2));
    
                    FinalBiggestSequenceAmplitudes = (TempSequences(nSequences,1)-2)+(BiggestSequenceAmplitudes);

                    SpikeIndiciesBiggestWaveform(nSequences) = FinalBiggestSequenceAmplitudes;
                else
                    SpikeIndiciesBiggestWaveform(nSequences) = TempSequences(nSequences,1);
                end
            end
        end

        SpikeTimes = SpikeIndiciesBiggestWaveform;
        Data.Spikes.SpikeTimes = [Data.Spikes.SpikeTimes;SpikeTimes];
        Data.Spikes.SpikeAmps = [Data.Spikes.SpikeAmps,abs(Data.Preprocessed(nchannel,SpikeTimes))];
        Data.Spikes.SpikePositions = [Data.Spikes.SpikePositions,zeros(1,length(SpikeTimes))+nchannel];
            
    end 
    Data.Spikes.SpikeChannel = Data.Spikes.SpikePositions;

elseif strcmp(Detectionmethod,"Threshold: Median - Std")
    %% Correlated Noise: Mean of signal

    if strcmp(Type,"All Channel")
        CN = median(Data.Preprocessed,'all');
        CNSTD = std2(Data.Preprocessed);
    end

    for nchannel = 1:size(Data.Preprocessed,1) % Channel
        indices = [];
        % Update the progress bar
       fraction = nchannel/cN;
       msg = sprintf('Extracting Spike Indicies... (%d%% done)', round(100*fraction));
       waitbar(fraction, h, msg);
    
        % Mean
        if strcmp(Type,"All Channel")
            Threshold = CN+STDThreshold.*CNSTD;
            indices = find(Data.Preprocessed(nchannel,:) < -Threshold);

        elseif strcmp(Type,"Individual Ch.")
            CN = median(Data.Preprocessed(nchannel,:));
            CNSTD = std(Data.Preprocessed(nchannel,:));
            Threshold = CN+STDThreshold.*CNSTD;
            indices = find(Data.Preprocessed(nchannel,:) < -Threshold);
        end
       
        %% Spikes can have multiple consecutive samples below the threshold. Only one can be kept. Here, the smallest amplitude indicies is kept
        % Now only take the max of each consecutive sequence of indicies
        % found
        
        ToleranceDoubleWaveform = round(Data.Info.NativeSamplingRate*TimeOffset);
        
        % Initialize the cell array to store the start and end values of each sequence
        minMaxSpikes = [];
        currentGroup = indices(1); % Start with the first spike in a new group
        
        for i = 2:length(indices)
            % Check if the current index is within tolerance of the last index in the current group
            if abs(indices(i) - indices(i - 1)) <= ToleranceDoubleWaveform
                % If within tolerance, add it to the current group
                currentGroup = [currentGroup, indices(i)];
            else
                % Save only the smallest and largest values of the current group
                minMaxSpikes = [minMaxSpikes; currentGroup(1), currentGroup(end)];
                % Start a new group with the current spike
                currentGroup = indices(i);
            end
        end
        
        % Add the smallest and largest values of the last group
        TempSequences = [minMaxSpikes; currentGroup(1), currentGroup(end)];

        SpikeIndiciesBiggestWaveform = NaN(size(TempSequences,1),1);

        for nSequences = 1:size(TempSequences,1)
            if TempSequences(nSequences,1) ~= TempSequences(nSequences,2)
                % minimum = spike peak for current sequence
                [~,BiggestSequenceAmplitudes] = min(Data.Preprocessed(nchannel,TempSequences(nSequences,1):TempSequences(nSequences,2)));
                % indicie is in respect to range the minimum was searched
                % for. Has to be adjusted to the total recording legnth
                BiggestSequenceAmplitudes = TempSequences(nSequences,1)+(BiggestSequenceAmplitudes);
                
                SpikeIndiciesBiggestWaveform(nSequences) = BiggestSequenceAmplitudes;
            else
                if Data.Preprocessed(nchannel,TempSequences(nSequences,1)-2 > 0 && TempSequences(nSequences,1)+2 <= length(Data.Time))
                    [~,BiggestSequenceAmplitudes] = min(Data.Preprocessed(nchannel,TempSequences(nSequences,1)-2:TempSequences(nSequences,1)+2));
    
                    FinalBiggestSequenceAmplitudes = (TempSequences(nSequences,1)-2)+(BiggestSequenceAmplitudes);

                    SpikeIndiciesBiggestWaveform(nSequences) = FinalBiggestSequenceAmplitudes;
                else
                    SpikeIndiciesBiggestWaveform(nSequences) = TempSequences(nSequences,1);
                end
            end
        end

        SpikeTimes = SpikeIndiciesBiggestWaveform;
        Data.Spikes.SpikeTimes = [Data.Spikes.SpikeTimes;SpikeTimes];
        Data.Spikes.SpikeAmps = [Data.Spikes.SpikeAmps,abs(Data.Preprocessed(nchannel,SpikeTimes))];
        Data.Spikes.SpikePositions = [Data.Spikes.SpikePositions,zeros(1,length(SpikeTimes))+nchannel];
            
    end
    Data.Spikes.SpikeChannel = Data.Spikes.SpikePositions;

elseif strcmp(Detectionmethod,"Quiroga Method")

    if strcmp(Type,"All Channel")
        medianAbsSignal = median(abs(Data.Preprocessed),'all');
    end

    for nchannel = 1:size(Data.Preprocessed,1) % Channel
       indices = [];
       % Update the progress bar
       fraction = nchannel/cN;
       msg = sprintf('Extracting Spike Indicies... (%d%% done)', round(100*fraction));
       waitbar(fraction, h, msg);

        if strcmp(Type,"All Channel")
            % Compute the threshold using the Quian Quiroga method
            Threshold = (medianAbsSignal / 0.6745) * STDThreshold;
            indices = find(Data.Preprocessed(nchannel,:) < -Threshold);
        elseif strcmp(Type,"Individual Ch.")
            medianAbsSignal = median(abs(Data.Preprocessed(nchannel,:)));
            % Compute the threshold using the Quian Quiroga method
            Threshold = (medianAbsSignal / 0.6745) * STDThreshold;
            indices = find(Data.Preprocessed(nchannel,:) < -Threshold);
        end

        %% Spikes can have multiple consecutive samples below the threshold. Only one can be kept. Here, the smallest amplitude indicies is kept
        % Now only take the max of each consecutive sequence of indicies
        % found

        if TimeOffSetFilter
            ToleranceDoubleWaveform = round(Data.Info.NativeSamplingRate*TimeOffset);
        else
            ToleranceDoubleWaveform = 1;
        end

        % Initialize the cell array to store the start and end values of each sequence
        minMaxSpikes = [];
        currentGroup = indices(1); % Start with the first spike in a new group
        
        for i = 2:length(indices)
            % Check if the current index is within tolerance of the last index in the current group
            if abs(indices(i) - indices(i - 1)) <= ToleranceDoubleWaveform
                % If within tolerance, add it to the current group
                currentGroup = [currentGroup, indices(i)];
            else
                % Save only the smallest and largest values of the current group
                minMaxSpikes = [minMaxSpikes; currentGroup(1), currentGroup(end)];
                % Start a new group with the current spike
                currentGroup = indices(i);
            end
        end
        
        % Add the smallest and largest values of the last group
        TempSequences = [minMaxSpikes; currentGroup(1), currentGroup(end)];

        SpikeIndiciesBiggestWaveform = NaN(size(TempSequences,1),1);

        for nSequences = 1:size(TempSequences,1)
            if TempSequences(nSequences,1) ~= TempSequences(nSequences,2)
                % minimum = spike peak for current sequence
                [~,BiggestSequenceAmplitudes] = min(Data.Preprocessed(nchannel,TempSequences(nSequences,1):TempSequences(nSequences,2)));
                % indicie is in respect to range the minimum was searched
                % for. Has to be adjusted to the total recording legnth
                BiggestSequenceAmplitudes = TempSequences(nSequences,1)+(BiggestSequenceAmplitudes);
                
                SpikeIndiciesBiggestWaveform(nSequences) = BiggestSequenceAmplitudes;
            else
                if Data.Preprocessed(nchannel,TempSequences(nSequences,1)-2 > 0 && TempSequences(nSequences,1)+2 <= length(Data.Time))
                    [~,BiggestSequenceAmplitudes] = min(Data.Preprocessed(nchannel,TempSequences(nSequences,1)-2:TempSequences(nSequences,1)+2));
    
                    FinalBiggestSequenceAmplitudes = (TempSequences(nSequences,1)-2)+(BiggestSequenceAmplitudes);

                    SpikeIndiciesBiggestWaveform(nSequences) = FinalBiggestSequenceAmplitudes;
                else
                    SpikeIndiciesBiggestWaveform(nSequences) = TempSequences(nSequences,1);
                end
            end
        end

        SpikeTimes = SpikeIndiciesBiggestWaveform;
        Data.Spikes.SpikeTimes = [Data.Spikes.SpikeTimes;SpikeTimes];
        Data.Spikes.SpikeAmps = [Data.Spikes.SpikeAmps,abs(Data.Preprocessed(nchannel,SpikeTimes))];
        Data.Spikes.SpikePositions = [Data.Spikes.SpikePositions,zeros(1,length(SpikeTimes))+nchannel];
      
    end
    Data.Spikes.SpikeChannel = Data.Spikes.SpikePositions;
end

%% If no Spikes found, fields are empty. Delete field
if isempty(Data.Spikes.SpikeTimes)
    fieldsToDelete = {'Spikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
    msgbox("Warning: No Spikes found.");
    Data.Info.SpikeType = 'Non';
    close(h);
    ToKeep = [];
    return;
end

close(h);

%% Wrap up: Prepare all necessary fields of Spike structure.
Data.Spikes.ChannelPosition(1:size(Data.Preprocessed,1),1) = 0;
Data.Spikes.ChannelPosition(1:size(Data.Preprocessed,1),2) = Data.Info.ChannelSpacing:Data.Info.ChannelSpacing:Data.Info.ChannelSpacing*size(Data.Preprocessed,1);
Data.Spikes.SpikeTimes = Data.Spikes.SpikeTimes';
Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps';
Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel';
Data.Spikes.ChannelMap = 1:size(Data.Preprocessed,1);
Data.Spikes.ChannelMap = Data.Spikes.ChannelMap';
TempSpikePositions = Data.Spikes.SpikePositions';
Data.Spikes.SpikePositions = [];
Data.Spikes.SpikePositions(1:length(TempSpikePositions),1) = 0;
Data.Spikes.SpikePositions(1:length(TempSpikePositions),2) = TempSpikePositions;

%% Filter Spike Data if selected
ToKeep = [];
if DepthFilter == true
    [Data,ToKeep] = Spike_Module_FilterSpikes(Data, Tolerance, ArtefactDepth, Data.Info.ChannelSpacing);
end

%% Wrap up by extracting the amplitude and waveform of each spike for later plotting
Data.Info.SpikeDetectionThreshold = Threshold;
Data.Info.SpikeDetectionNrStd = STDThreshold;
Data.Info.SpikeType = 'Internal';

%% Lastly extract Waveforms
% Extract Waveforms
[Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,Data.Spikes.SpikePositions(:,2),"NormalWaveforms");
% Remove NaN from Waveforms
% Some SPikes can be removed when they are too close to the edge of the
% recording to have a complete waveform
if sum(SpikesWithWaveform)>0
    NumSpikeRemoved = length(find(SpikesWithWaveform==0));
    if NumSpikeRemoved>0
        msgbox(strcat("Warning: ",num2str(NumSpikeRemoved)," Spikes removed bc they are too close to the time limits"))
    end
    Data.Spikes.SpikeTimes = Data.Spikes.SpikeTimes(SpikesWithWaveform==1);
    Data.Spikes.SpikePositions(SpikesWithWaveform==0,:) = [];
    Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps(SpikesWithWaveform==1);
    Data.Spikes.Waveforms(SpikesWithWaveform==0,:) = [];
    Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel(SpikesWithWaveform==1);
    if isfield(Data.Spikes,'SpikeCluster')
        if ~isempty(Data.Spikes.SpikeCluster)
            Data.Spikes.SpikeCluster = Data.Spikes.SpikeCluster(SpikesWithWaveform==1);
        end
    end
end






