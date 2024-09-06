function [Waveforms,BiggestSpikeIndicies] = Spikes_Module_Get_Waveforms(Data,SpikeTimes,SpikePositions,WaveFormType)

%________________________________________________________________________________________
%% Function to extract biggest spike waveforms with amplitudes of each spike already given.

% This function is executed after Spike Detection and after loading
% kilosort spike data

% Inputs: 
% 1. Data = needs to contain raw or preprocessed data to extract wveforms
% from
% 2. SpikeTimes nspikes x 1 double with spike times in samples of each spike
% 3. Amplitudes = N x 1 double or single with amplitudes of each spike
% (analyzed in internal spike detection) to get biggest amplitude
% 4. SpikePositions = N x 1 double or single with spike poisiton (integer specifying channel) of each spike
% (analyzed in internal spike detection) 
% 5. ChannelSelection = 2 x 1 double or single; from , to like [1,10] for
% channel 1 to 10 
% 6. NRWaveformsToExtract: -- not used here
% 7. AllSpikes:  1 to save waveforms for all spikes, 0 for just nr of
% waveforms specified in WaveformsToPlot
% 8. Plot: char, specifies if waveforms should be plotted
% 9. Figure: figure axes handle to plot waveforms on
% 10. WaveformsToPlot: 1x2 double specifying how man waveforms should be
% analysed, i.e. [1,10] for 10 waveforms

% Outputs:
% 1. Waveforms: nchannel x nwaveforms x ntime matrix saving each extract
% waveform
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if isfield(Data,'Preprocessed') 
    if isfield(Data.Info,'FilterMethod') 
        if ~strcmp(Data.Info.FilterMethod,'High-Pass')
            msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms");
        end
    else
        msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms");
    end
else
    msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms");
end

% Rough automatic num samples for spikes
TimePoints = Data.Info.NativeSamplingRate/1000;

% If weird circumstances ensure minimum
if TimePoints*2+1 < 50
    TimePoints = 25;
end

LengthWaveform = TimePoints*2+1;

%% Set up to extract Biggest Amplitudes

h = waitbar(0, 'Extracting Spike Waveforms...', 'Name', 'Extracting Spike Waveforms...');

% Determine datatype
usePreprocessed = isfield(Data, 'Preprocessed') && ~isfield(Data.Info, 'DownsampleFactor');
DataField = 'Raw';
if usePreprocessed
    DataField = 'Preprocessed';
end

if strcmp(WaveFormType,"AverageWaveforms")
    % Extract Waveforms over all channel from each spike indice
    % for average waveform over depth. For normal waveform plots, only the
    % spike indicies and waveforms of the channel it was found in are computed

    Waveforms = single(NaN(size(Data.Raw,1),length(SpikeTimes),LengthWaveform));
    BiggestSpikeIndicies = zeros(length(SpikeTimes),1);

    for nwaves = 1:length(SpikeTimes)
        % Time Points to extract
        startIdx = SpikeTimes(nwaves) - TimePoints;
        endIdx = SpikeTimes(nwaves) + TimePoints;
        
        % Extract data of time points, mark non-NaN waveform with 1 in BiggestSpikeIndicies
        if startIdx > 0 && endIdx <= size(Data.(DataField), 2)
            Waveforms(:, nwaves, :) = Data.(DataField)(:, startIdx:endIdx);
            BiggestSpikeIndicies(nwaves) = 1;
        else
            Waveforms(:, nwaves, :) = NaN;
        end
    
        % update waitbar every 100 iterations to reduce overhead
        if mod(nwaves, 100) == 0 || nwaves == length(SpikeTimes)
            fraction = nwaves / length(SpikeTimes);
            msg = sprintf('Extracting Spike Waveforms... (%d%% done)', round(100 * fraction));
            waitbar(fraction, h, msg);
        end
    end

else
    % Otherwise just extract waveform from the corresponding Channel it was
    % found in
    %Convert SpikePosition to Channelindicie
    %SpikePositions = (SpikePositions./Data.Info.ChannelSpacing)+1;
    Waveforms = single(NaN(length(SpikeTimes),LengthWaveform));
    BiggestSpikeIndicies = zeros(length(SpikeTimes),1);

    for nwaves = 1:length(SpikeTimes)
        % Time Points to extract
        startIdx = SpikeTimes(nwaves) - TimePoints;
        endIdx = SpikeTimes(nwaves) + TimePoints;
        
        % Extract data of time points, mark non-NaN waveform with 1 in BiggestSpikeIndicies
        if startIdx > 0 && endIdx <= size(Data.(DataField), 2)
            Waveforms(nwaves, :) = Data.(DataField)(SpikePositions(nwaves), startIdx:endIdx);
            BiggestSpikeIndicies(nwaves) = 1;
        else
            Waveforms(nwaves, :) = NaN;
        end
    
        % update waitbar every 100 iterations to reduce overhead
        if mod(nwaves, 100) == 0 || nwaves == length(SpikeTimes)
            fraction = nwaves / length(SpikeTimes);
            msg = sprintf('Extracting Spike Waveforms... (%d%% done)', round(100 * fraction));
            waitbar(fraction, h, msg);
        end
    end
end
close(h);

