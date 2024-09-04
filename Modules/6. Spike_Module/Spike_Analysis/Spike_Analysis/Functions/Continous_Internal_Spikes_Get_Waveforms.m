function [Waveforms,BiggestSpikeIndicies] = Continous_Internal_Spikes_Get_Waveforms(Data,SpikeTimes,Amplitudes,SpikePositions,SpikeCluster,ChannelSelection,NRWaveformsToExtract,AllSpikes,Plot,Figure,WaveformsToPlot)

%________________________________________________________________________________________
%% Function to extract biggest spike waveforms with amplitudes of each spike already given.

% This function is executed every time some waveform analysis has to be
% done. Extraction is fast enough for that. 
% Note: Code extracts n number of biggest wavforms found, with n being the
% specified nr by the user. Gets saved in main window Data structure, but
% overwritten everytime here

%gets called whenever the user selects an analysis in the cont. internal spikes window that requires waveforms

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

%% Set up to Extract Waveforms of these Amplitudes
% Not necessary to distinguish to downsampled data since waveforms are
% extracted from raw data if preprocessed data is downsampled
% if Downsample == 0
%     TimePoints = Data.Info.NativeSamplingRate/1000;
% else
%     TimePoints = Data.Info.DownsampledSampleRate/1000;
% end

% Spike Positions start at 0. Howver they get accessed in a loop and
% compared to channel, so need to be 1
% ZeroPosition = SpikePositions == 0;
% if sum(ZeroPosition)>1
%     SpikePositions = SpikePositions+1;
% end

if ~Plot
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
    
    TimePoints = Data.Info.NativeSamplingRate/1000;
    
    % If weird circumstances ensure minimum
    if TimePoints*2+1 < 50
        TimePoints = 25;
    end
    
    ChannelRange = ChannelSelection(1):ChannelSelection(2);
    LengthWaveform = TimePoints*2+1;
    
    Waveforms = NaN(length(SpikeTimes),LengthWaveform);

    %% Set up to extract Biggest Amplitudes
    
    % Initialize a cell array to store indices of the top NRWaveformsToExtract amplitudes per channel
    
    BiggestSpikeIndicies = zeros(length(SpikeTimes),1);
           
    % Extract Corresponding waveforms
    for nwaves = 1:length(SpikeTimes) 
        if isfield(Data,'Preprocessed') && ~isfield(Data.Info,'DownsampleFactor')
            if SpikeTimes(nwaves)-TimePoints > 0 && SpikeTimes(nwaves)+TimePoints <= size(Data.Preprocessed,2)
                Waveforms(nwaves,1:LengthWaveform) = Data.Preprocessed(SpikePositions(nwaves),SpikeTimes(nwaves)-TimePoints:SpikeTimes(nwaves)+TimePoints);
                BiggestSpikeIndicies(nwaves) = 1;
            else
                Waveforms(nwaves,1:LengthWaveform) = NaN;
            end
        else
            if SpikeTimes(nwaves)-TimePoints > 0 && SpikeTimes(nwaves)+TimePoints <= size(Data.Raw,2)
                Waveforms(nwaves,1:LengthWaveform) = Data.Raw(SpikePositions(nwaves),SpikeTimes(nwaves)-TimePoints:SpikeTimes(nwaves)+TimePoints);
                BiggestSpikeIndicies(nwaves) = 1;
            else
                Waveforms(nwaves,1:LengthWaveform) = NaN;
            end
        end
    end
end % if ~Plot



