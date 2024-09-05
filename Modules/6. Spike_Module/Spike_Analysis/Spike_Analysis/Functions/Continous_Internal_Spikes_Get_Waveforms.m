function [Waveforms,BiggestSpikeIndicies,WaveFormChannel] = Continous_Internal_Spikes_Get_Waveforms(Data,SpikeTimes,Amplitudes,SpikePositions,SpikeCluster,ChannelSelection,NRWaveformsToExtract,AllSpikes,Plot,Figure,WaveformsToPlot)

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

ChannelRange = ChannelSelection(1):ChannelSelection(2);
LengthWaveform = TimePoints*2+1;

WaveFormChannel = [];
%% Set up to extract Biggest Amplitudes

% Initialize a cell array to store indices of the top NRWaveformsToExtract amplitudes per channel

if strcmp(Data.Info.SpikeType,"Internal")
    Waveforms = NaN(length(SpikeTimes),LengthWaveform);
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
elseif strcmp(Data.Info.SpikeType,"Kilosort")
    Waveforms = NaN(length(SpikeTimes),LengthWaveform);
    BiggestSpikeIndicies = zeros(length(SpikeTimes),1);
    % Extract Corresponding waveforms
    for nwaves = 1:length(SpikeTimes)
        % For Kilosort extract for each waveform the data from each channel
        TempWave = NaN(size(Data.Raw,1),LengthWaveform);
        for nchannel = 1:size(Data.Raw,1)
            if isfield(Data,'Preprocessed') && ~isfield(Data.Info,'DownsampleFactor')
                if SpikeTimes(nwaves)-TimePoints > 0 && SpikeTimes(nwaves)+TimePoints <= size(Data.Preprocessed,2)
                    TempWave(nchannel,1:LengthWaveform) = Data.Preprocessed(nchannel,SpikeTimes(nwaves)-TimePoints:SpikeTimes(nwaves)+TimePoints);
                else
                    TempWave(nchannel,1:LengthWaveform) = NaN;
                end
            else
                if SpikeTimes(nwaves)-TimePoints > 0 && SpikeTimes(nwaves)+TimePoints <= size(Data.Raw,2)
                    TempWave(nchannel,1:LengthWaveform) = Data.Raw(nchannel,SpikeTimes(nwaves)-TimePoints:SpikeTimes(nwaves)+TimePoints);
                else
                    TempWave(nchannel,1:LengthWaveform) = NaN;
                end
            end
        end

        [MaxChannelValue,~] = max(TempWave,[],1);
        
        if ~isnan(MaxChannelValue)
            [~,MaxChannelIndicie] = max(MaxChannelValue);
            WaveFormChannel(nwaves) = MaxChannelIndicie;
            Waveforms(nwaves,1:LengthWaveform) = TempWave(MaxChannelIndicie,:);
            BiggestSpikeIndicies(nwaves) = 1;
        else
            Waveforms(nwaves,1:LengthWaveform) = NaN;
            WaveFormChannel(nwaves) = NaN;
        end
    end
end




