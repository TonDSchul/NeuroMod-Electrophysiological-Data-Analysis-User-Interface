function Data = Spike_Module_Apply_SpikeInterface_Quality_Metrics(Data,QualityMetrics)

%________________________________________________________________________________________

%% Function to clean loaded spike sorting results from SpikeInterface using quality metrics and user input about thresholds

% Input:
% 1. Data: main window data structure
% 2. QualityMetrics: struc with one field per metric saving the user
% inputted threshold

% Output: 
% 1. Data: main window data structure with cleaned Data.Spikes

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if isfield(QualityMetrics,'SNR')
    if ~isfield(Data.Spikes,'ClusterSNR')
        warning("Cluster SNR quality metric 'cluster_snr.tsv' was not found in sorting results! Step skipped.")
    end
    % get threshold and vorzeichen
    SNR = str2double(QualityMetrics.SNR(2:end));
    Vorzeichen = QualityMetrics.SNR(1);
    % find indicies violating threshold
    ClusIndex = zeros(size(Data.Spikes.ClusterSNR,1),1);
    switch Vorzeichen
        case '<'
            ClusIndex = Data.Spikes.ClusterSNR(:,2) < SNR;
        case '>'
            ClusIndex = Data.Spikes.ClusterSNR(:,2) > SNR;
        case '='
            ClusIndex = Data.Spikes.ClusterSNR(:,2) == SNR;
    end
    % if violations
    if sum(ClusIndex)>0
        % unit id
        ViolatingClus = Data.Spikes.ClusterSNR(ClusIndex,1);

        DeleteIndicies = zeros(size(Data.Spikes.SpikeTimes));
        % loop over violating units
        for nclus = 1:length(ViolatingClus)
            % all indicies of that unit
            AllClusIndicies = Data.Spikes.SpikeCluster == ViolatingClus(nclus);
            if sum(AllClusIndicies)>0
                % save for deletion
                DeleteIndicies(AllClusIndicies==1) = 1;
            end
        end
        % delete and inform
        if sum(DeleteIndicies)>0
            Data.Spikes.SpikeTimes(DeleteIndicies==1) = [];
            Data.Spikes.SpikePositions(DeleteIndicies==1,:) = [];
            Data.Spikes.SpikeAmps(DeleteIndicies==1) = [];
            Data.Spikes.SpikeChannel(DeleteIndicies==1) = [];
            Data.Spikes.SpikeCluster(DeleteIndicies==1) = [];
            disp(strcat("Deleted ",num2str(sum(DeleteIndicies))," spikes from ",num2str(length(ViolatingClus))," cluster violating defined sorting metrics SNR ",QualityMetrics.SNR,"."));
        end
    else
        disp("No SNR violations detected.")
    end
    if isempty(Data.Spikes.SpikeTimes)
        warning("Quality metric SNR deleted all spikes. Set different threshold.")
        msgbox("Quality metric SNR deleted all spikes. Set different threshold.")
    end
end
if isfield(QualityMetrics,'ISIViolationRatio')
    if ~isfield(Data.Spikes,'ISIViolationRatio')
        warning("ISI Violation Ratio quality metric 'cluster_isi_violations_ratio.tsv' was not found in sorting results! Step skipped.")
    end
    % get threshold and vorzeichen
    ISIVIO = str2double(QualityMetrics.ISIViolationRatio(2:end));
    Vorzeichen = QualityMetrics.ISIViolationRatio(1);
    % find indicies violating threshold
    ClusIndex = zeros(size(Data.Spikes.ISIViolationRatio,1),1);
    switch Vorzeichen
        case '<'
            ClusIndex = Data.Spikes.ISIViolationRatio(:,2) < ISIVIO;
        case '>'
            ClusIndex = Data.Spikes.ISIViolationRatio(:,2) > ISIVIO;
        case '='
            ClusIndex = Data.Spikes.ISIViolationRatio(:,2) == ISIVIO;
    end
    % if violations
    if sum(ClusIndex)>0
        % unit id
        ViolatingClus = Data.Spikes.ISIViolationRatio(ClusIndex,1);

        DeleteIndicies = zeros(size(Data.Spikes.SpikeTimes));
        % loop over violating units
        for nclus = 1:length(ViolatingClus)
            % all indicies of that unit
            AllClusIndicies = Data.Spikes.SpikeCluster == ViolatingClus(nclus);
            if sum(AllClusIndicies)>0
                % save for deletion
                DeleteIndicies(AllClusIndicies==1) = 1;
            end
        end
        % delete and inform
        if sum(DeleteIndicies)>0
            Data.Spikes.SpikeTimes(DeleteIndicies==1) = [];
            Data.Spikes.SpikePositions(DeleteIndicies==1,:) = [];
            Data.Spikes.SpikeAmps(DeleteIndicies==1) = [];
            Data.Spikes.SpikeChannel(DeleteIndicies==1) = [];
            Data.Spikes.SpikeCluster(DeleteIndicies==1) = [];
            disp(strcat("Deleted ",num2str(sum(DeleteIndicies))," spikes from ",num2str(length(ViolatingClus))," cluster violating defined sorting metrics ISI Violation Ratio ",QualityMetrics.ISIViolationRatio,"."));
        end
    else
        disp("No ISI Ratio violations detected.")
    end
    if isempty(Data.Spikes.SpikeTimes)
        warning("Quality metric ISI Ratio violations deleted all spikes. Set different threshold.")
        msgbox("Quality metric ISI Ratio violations deleted all spikes. Set different threshold.")
    end
end
if isfield(QualityMetrics,'FiringRange')
    if ~isfield(Data.Spikes,'Cluster_Firing_Range')
        warning("Cluster Firing Range quality metric 'cluster_firing_range.tsv' was not found in sorting results! Step skipped.")
    end
    % get threshold and vorzeichen
    FiringRangeVIO = str2double(QualityMetrics.FiringRange(2:end));
    Vorzeichen = QualityMetrics.FiringRange(1);
    % find indicies violating threshold
    ClusIndex = zeros(size(Data.Spikes.Cluster_Firing_Range,1),1);
    switch Vorzeichen
        case '<'
            ClusIndex = Data.Spikes.Cluster_Firing_Range(:,2) < FiringRangeVIO;
        case '>'
            ClusIndex = Data.Spikes.Cluster_Firing_Range(:,2) > FiringRangeVIO;
        case '='
            ClusIndex = Data.Spikes.Cluster_Firing_Range(:,2) == FiringRangeVIO;
    end
    % if violations
    if sum(ClusIndex)>0
        % unit id
        ViolatingClus = Data.Spikes.Cluster_Firing_Range(ClusIndex,1);

        DeleteIndicies = zeros(size(Data.Spikes.SpikeTimes));
        % loop over violating units
        for nclus = 1:length(ViolatingClus)
            % all indicies of that unit
            AllClusIndicies = Data.Spikes.SpikeCluster == ViolatingClus(nclus);
            if sum(AllClusIndicies)>0
                % save for deletion
                DeleteIndicies(AllClusIndicies==1) = 1;
            end
        end
        % delete and inform
        if sum(DeleteIndicies)>0
            Data.Spikes.SpikeTimes(DeleteIndicies==1) = [];
            Data.Spikes.SpikePositions(DeleteIndicies==1,:) = [];
            Data.Spikes.SpikeAmps(DeleteIndicies==1) = [];
            Data.Spikes.SpikeChannel(DeleteIndicies==1) = [];
            Data.Spikes.SpikeCluster(DeleteIndicies==1) = [];
            disp(strcat("Deleted ",num2str(sum(DeleteIndicies))," spikes from ",num2str(length(ViolatingClus))," cluster violating defined sorting metrics Firing Range ",QualityMetrics.FiringRange,"."));
        end
    else
        disp("No Firing Range violations detected.")
    end
    if isempty(Data.Spikes.SpikeTimes)
        warning("Quality metric Firing Range deleted all spikes. Set different threshold.")
        msgbox("Quality metric Firing Range deleted all spikes. Set different threshold.")
    end
end
if isfield(QualityMetrics,'NoiseRatio')
    if ~isfield(Data.Spikes,'Cluster_Noise_Ratio')
        warning("Cluster Noise Ratio quality metric 'cluster_noise_ratio.tsv' was not found in sorting results! Step skipped.")
    end
    % get threshold and vorzeichen
    NoiseRatioVIO = str2double(QualityMetrics.NoiseRatio(2:end));
    Vorzeichen = QualityMetrics.NoiseRatio(1);
    % find indicies violating threshold
    ClusIndex = zeros(size(Data.Spikes.Cluster_Noise_Ratio,1),1);
    switch Vorzeichen
        case '<'
            ClusIndex = Data.Spikes.Cluster_Noise_Ratio(:,2) < NoiseRatioVIO;
        case '>'
            ClusIndex = Data.Spikes.Cluster_Noise_Ratio(:,2) > NoiseRatioVIO;
        case '='
            ClusIndex = Data.Spikes.Cluster_Noise_Ratio(:,2) == NoiseRatioVIO;
    end
    % if violations
    if sum(ClusIndex)>0
        % unit id
        ViolatingClus = Data.Spikes.Cluster_Noise_Ratio(ClusIndex,1);

        DeleteIndicies = zeros(size(Data.Spikes.SpikeTimes));
        % loop over violating units
        for nclus = 1:length(ViolatingClus)
            % all indicies of that unit
            AllClusIndicies = Data.Spikes.SpikeCluster == ViolatingClus(nclus);
            if sum(AllClusIndicies)>0
                % save for deletion
                DeleteIndicies(AllClusIndicies==1) = 1;
            end
        end
        % delete and inform
        if sum(DeleteIndicies)>0
            Data.Spikes.SpikeTimes(DeleteIndicies==1) = [];
            Data.Spikes.SpikePositions(DeleteIndicies==1,:) = [];
            Data.Spikes.SpikeAmps(DeleteIndicies==1) = [];
            Data.Spikes.SpikeChannel(DeleteIndicies==1) = [];
            Data.Spikes.SpikeCluster(DeleteIndicies==1) = [];
            disp(strcat("Deleted ",num2str(sum(DeleteIndicies))," spikes from ",num2str(length(ViolatingClus))," cluster violating defined sorting metrics Noise Ratio ",QualityMetrics.NoiseRatio,"."));
        end
    else
        disp("No Noise Ratio violations detected.")
    end
    if isempty(Data.Spikes.SpikeTimes)
        warning("Quality metric Noise Ratio deleted all spikes. Set different threshold.")
        msgbox("Quality metric Noise Ratio deleted all spikes. Set different threshold.")
    end
end
if isfield(QualityMetrics,'NoiseCutOff')
    if ~isfield(Data.Spikes,'Cluster_Noise_Cutoff')
        warning("Cluster Noise Cutoff quality metric 'cluster_noise_cutoff.tsv' was not found in sorting results! Step skipped.")
    end
    % get threshold and vorzeichen
    NoiseCutoffVIO = str2double(QualityMetrics.NoiseCutOff(2:end));
    Vorzeichen = QualityMetrics.NoiseCutOff(1);
    % find indicies violating threshold
    ClusIndex = zeros(size(Data.Spikes.Cluster_Noise_Cutoff,1),1);
    switch Vorzeichen
        case '<'
            ClusIndex = Data.Spikes.Cluster_Noise_Cutoff(:,2) < NoiseCutoffVIO;
        case '>'
            ClusIndex = Data.Spikes.Cluster_Noise_Cutoff(:,2) > NoiseCutoffVIO;
        case '='
            ClusIndex = Data.Spikes.Cluster_Noise_Cutoff(:,2) == NoiseCutoffVIO;
    end
    % if violations
    if sum(ClusIndex)>0
        % unit id
        ViolatingClus = Data.Spikes.Cluster_Noise_Cutoff(ClusIndex,1);

        DeleteIndicies = zeros(size(Data.Spikes.SpikeTimes));
        % loop over violating units
        for nclus = 1:length(ViolatingClus)
            % all indicies of that unit
            AllClusIndicies = Data.Spikes.SpikeCluster == ViolatingClus(nclus);
            if sum(AllClusIndicies)>0
                % save for deletion
                DeleteIndicies(AllClusIndicies==1) = 1;
            end
        end
        % delete and inform
        if sum(DeleteIndicies)>0
            Data.Spikes.SpikeTimes(DeleteIndicies==1) = [];
            Data.Spikes.SpikePositions(DeleteIndicies==1,:) = [];
            Data.Spikes.SpikeAmps(DeleteIndicies==1) = [];
            Data.Spikes.SpikeChannel(DeleteIndicies==1) = [];
            Data.Spikes.SpikeCluster(DeleteIndicies==1) = [];
            disp(strcat("Deleted ",num2str(sum(DeleteIndicies))," spikes from ",num2str(length(ViolatingClus))," cluster violating defined sorting metrics Noise Cutoff ",QualityMetrics.NoiseCutOff,"."));
        end
    else
        disp("No Noise Cutoff violations detected.")
    end
    if isempty(Data.Spikes.SpikeTimes)
        warning("Quality metric Noise Cutoff deleted all spikes. Set different threshold.")
        msgbox("Quality metric Noise Cutoff deleted all spikes. Set different threshold.")
    end
end
if isfield(QualityMetrics,'MedianAmplitude')
    if ~isfield(Data.Spikes,'Cluster_Amplitude_Median')
        warning("Median Cluster Amplitude quality metric 'cluster_amplitude_median.tsv' was not found in sorting results! Step skipped.")
    end
    % get threshold and vorzeichen
    ClusterAmplitudeMedianVIO = str2double(QualityMetrics.MedianAmplitude(2:end));
    Vorzeichen = QualityMetrics.MedianAmplitude(1);
    % find indicies violating threshold
    ClusIndex = zeros(size(Data.Spikes.Cluster_Amplitude_Median,1),1);
    switch Vorzeichen
        case '<'
            ClusIndex = Data.Spikes.Cluster_Amplitude_Median(:,2) < ClusterAmplitudeMedianVIO;
        case '>'
            ClusIndex = Data.Spikes.Cluster_Amplitude_Median(:,2) > ClusterAmplitudeMedianVIO;
        case '='
            ClusIndex = Data.Spikes.Cluster_Amplitude_Median(:,2) == ClusterAmplitudeMedianVIO;
    end
    % if violations
    if sum(ClusIndex)>0
        % unit id
        ViolatingClus = Data.Spikes.Cluster_Amplitude_Median(ClusIndex,1);

        DeleteIndicies = zeros(size(Data.Spikes.SpikeTimes));
        % loop over violating units
        for nclus = 1:length(ViolatingClus)
            % all indicies of that unit
            AllClusIndicies = Data.Spikes.SpikeCluster == ViolatingClus(nclus);
            if sum(AllClusIndicies)>0
                % save for deletion
                DeleteIndicies(AllClusIndicies==1) = 1;
            end
        end
        % delete and inform
        if sum(DeleteIndicies)>0
            Data.Spikes.SpikeTimes(DeleteIndicies==1) = [];
            Data.Spikes.SpikePositions(DeleteIndicies==1,:) = [];
            Data.Spikes.SpikeAmps(DeleteIndicies==1) = [];
            Data.Spikes.SpikeChannel(DeleteIndicies==1) = [];
            Data.Spikes.SpikeCluster(DeleteIndicies==1) = [];
            disp(strcat("Deleted ",num2str(sum(DeleteIndicies))," spikes from ",num2str(length(ViolatingClus))," cluster violating defined sorting metrics Median Spike Amplitude ",QualityMetrics.MedianAmplitude,"."));
        end
    else
        disp("No Median Spike Amplitude violations detected.")
    end
    if isempty(Data.Spikes.SpikeTimes)
        warning("Quality metric Median Spike Amplitude deleted all spikes. Set different threshold.")
        msgbox("Quality metric Median Spike Amplitude deleted all spikes. Set different threshold.")
    end
end

