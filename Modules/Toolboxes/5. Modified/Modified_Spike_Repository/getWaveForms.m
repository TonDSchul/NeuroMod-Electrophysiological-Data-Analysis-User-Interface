function wf = getWaveForms(wfWin,TextBox,Data,SpikeTimes,SpikeClusters,PlotInfo)
%% This function stems from the Spike repository on Github at https://github.com/cortex-lab/spikes and was modified to be used with the GUI 
%% Original function header:
% function wf = getWaveForms(gwfparams)
%
% Extracts individual spike waveforms from the raw datafile, for multiple
% clusters. Returns the waveforms and their means within clusters.
%
% Contributed by C. Schoonover and A. Fink
%
% % EXAMPLE INPUT
% gwfparams.dataDir = '/path/to/data/';    % KiloSort/Phy output folder
% gwfparams.fileName = 'data.dat';         % .dat file containing the raw 
% gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
% nCh = 32;                      % Number of channels that were streamed to disk in .dat file
% wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
% NumWaveformsToExtract = 2000;                    % Number of waveforms per unit to pull out
% SpikeTimes =    [2,3,5,7,8,9]; % Vector of cluster spike times (in samples) same length as .spikeClusters
% SpikeClusters = [1,2,1,1,1,2]; % Vector of cluster IDs (Phy nomenclature)   same length as .spikeTimes
%
% % OUTPUT
% wf.unitIDs                               % [nClu,1]            List of cluster IDs; defines order used in all wf.* variables
% wf.spikeTimeKeeps                        % [nClu,nWf]          Which spike times were used for the waveforms
% wf.waveForms                             % [nClu,nWf,nCh,nSWf] Individual waveforms
% wf.waveFormsMean                         % [nClu,nCh,nSWf]     Average of all waveforms (per channel)
%                                          % nClu: number of different clusters in .spikeClusters
%                                          % nSWf: number of samples per waveform
%
% % USAGE
% wf = getWaveForms(gwfparams);

% ----- Modfied by Tony de Schultz % Department systemsphysiology of learning, LIN Magdeburg.
% Take Data structure for data to extract waveforms from, as well as
% inputting GUI info for number of waveforms, units to analyse and to
% display progress in GUI windows

% Load .dat and KiloSort/Phy output
%fileName = fullfile(gwfparams.dataDir,gwfparams.fileName); 

nCh = size(Data,1);

wfNSamples = length(-wfWin(1):wfWin(end));
NumWaveformsToExtract = numel(PlotInfo.Waveforms(1):PlotInfo.Waveforms(2));
chMap = 1:size(Data,1);               % Order in which data was streamed to disk; must be 1-indexed for Matlab
nChInMap = size(Data,1);

% Read spike time-centered waveforms
unitIDs = unique(SpikeClusters);
numUnits = PlotInfo.Units;
spikeTimeKeeps = nan(1,NumWaveformsToExtract);
waveForms = nan(1,NumWaveformsToExtract,nChInMap,wfNSamples);
waveFormsMean = nan(1,nChInMap,wfNSamples);

for curUnitInd=1
    curUnitID = unitIDs(PlotInfo.Units);
    curSpikeTimes = SpikeTimes(SpikeClusters==curUnitID);
    curUnitnSpikes = size(curSpikeTimes,1);
    spikeTimesRP = curSpikeTimes(randperm(curUnitnSpikes));
    spikeTimeKeeps(curUnitInd,1:min([NumWaveformsToExtract curUnitnSpikes])) = sort(spikeTimesRP(1:min([NumWaveformsToExtract curUnitnSpikes])));
    for curSpikeTime = 1:min([NumWaveformsToExtract curUnitnSpikes])
        if spikeTimeKeeps(curUnitInd,curSpikeTime)-wfWin(1) > 0 && spikeTimeKeeps(curUnitInd,curSpikeTime)+wfWin(end) < size(Data,2)
            waveForms(curUnitInd,curSpikeTime,:,:) = Data(1:nCh,spikeTimeKeeps(curUnitInd,curSpikeTime)-wfWin(1):spikeTimeKeeps(curUnitInd,curSpikeTime)+wfWin(end));
        end
    end
    if size(waveForms,2) > 1
        waveFormsMean(curUnitInd,:,:) = squeeze(nanmean(waveForms(curUnitInd,:,:,:),2));
    else
        waveFormsMean(curUnitInd,:,:) = squeeze(waveForms(curUnitInd,:,:,:));
    end
    TextBox.Value{1} = ['Completed Extraction for ' int2str(curUnitInd) ' units of ' int2str(numUnits) '.'];
    disp(['Completed ' int2str(curUnitInd) ' units of ' int2str(numUnits) '.']);
    pause(0.01);
end


% Package in wf struct
wf.unitIDs = unitIDs;
wf.spikeTimeKeeps = spikeTimeKeeps;
wf.waveForms = waveForms;
wf.waveFormsMean = waveFormsMean;

end
