function [Phases,PhasesUnwrapped] = Analyse_Main_Window_Hilbert_Echt_Wavelet(Data,Method,ChannelToCompare,Samplefrequency,Cutoff,ECHTFilterorder,AllActiveChannel)

%________________________________________________________________________________________

%% Function to compute phase angle time series and amplitude envelope for a signal using different methods 

% The wavelet convolution method is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Inputs:
% 1. Data: nchannel x ntime matrix with the signal
% 2. Method: Which method the user selcts to compute the phase angles,
% either "Endpoint Corrected Hilbert Transform" OR "Hilbert Transform" OR "Wavelet Convolution"
% 3. ChannelToCompare: double vector, the two channel seelcted for phase
% angle differen polar plot in unit circle
% 4. Samplefrequency: double, in Hz. Not from Data.Info bc it was
% autodetected before if data was downsampled
% 5. Cutoff: 1x2 double, narrowband cutoff frequency for ecHT Method!
% 6. ECHTFilterorder: double, filter order of narrowband for ecHT method

% Outputs:
% 1. Phases: nchannel x ntime phase angle time series
% 2. PhasesUnwrapped: nchannel x ntime amplitude envelops
% 3. FilterSettings: cutoff frequency (lowe, higher)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

[ChannelToCompare] = Organize_Convert_ActiveChannel_to_DataChannel(AllActiveChannel,ChannelToCompare,'MainPlot');

if strcmp(Method,"Endpoint Corrected Hilbert Transform")
    Phases = zeros(size(Data,1),size(Data,2));
    PhasesUnwrapped = zeros(size(Data,1),size(Data,2)-1);
    
    FilterSettings.Filt_LF = Cutoff(1);
    FilterSettings.Filt_HF = Cutoff(2);

    if isempty(ChannelToCompare)
        for nchannel = 1:size(Data,1)
            analytic_signal = echt(Data(nchannel,:), FilterSettings.Filt_LF, FilterSettings.Filt_HF, Samplefrequency, size(Data,2),ECHTFilterorder);
            Phases(nchannel,:) = angle(analytic_signal);
            PhasesUnwrapped(nchannel,:) = diff(unwrap(Phases(nchannel,:)))/(2*pi/Samplefrequency);
        end
    else
        analytic_signal = echt(Data(ChannelToCompare,:), FilterSettings.Filt_LF, FilterSettings.Filt_HF, Samplefrequency, size(Data,2),ECHTFilterorder);
        Phases = angle(analytic_signal);
        PhasesUnwrapped = diff(unwrap(Phases))/(2*pi/Samplefrequency);
    end

elseif strcmp(Method,"Hilbert Transform")

    Phases = zeros(size(Data,1),size(Data,2));
    PhasesUnwrapped = zeros(size(Data,1),size(Data,2)-1);
    
    if isempty(ChannelToCompare)
        for nchannel = 1:size(Data,1)
            analytic_signal = hilbert(Data(nchannel,:));
            Phases(nchannel,:) = angle(analytic_signal);
            PhasesUnwrapped(nchannel,:) = diff(unwrap(Phases(nchannel,:)))/(2*pi/Samplefrequency);
        end
    else
        analytic_signal = hilbert(Data(ChannelToCompare,:));
        Phases = angle(analytic_signal);
        PhasesUnwrapped = diff(unwrap(Phases))/(2*pi/Samplefrequency);
    end
elseif strcmp(Method,"Wavelet Convolution")
    
    numCycles = ECHTFilterorder; % commonly used value (5–8)
    cent_freq = Cutoff(1) + ((Cutoff(2)-Cutoff(1))/2);
    s = numCycles / (2*pi*cent_freq);  % standard deviation of Gaussian envelope

    Phases = zeros(size(Data,1),size(Data,2));
    PhasesUnwrapped = zeros(size(Data,1),size(Data,2)-1);

    % create a complex Morlet wavelet
    
    time      = -3*s : 1/Samplefrequency : 3*s;
    s         = 8/(2*pi*cent_freq);
    wavelet   = exp(2*1i*pi*cent_freq.*time) .* exp(-time.^2./(2*s^2));
    half_wavN = (length(time)-1)/2;
    
    % FFT parameters
    nWave = length(time);
    nData = size(Data,2);
    nConv = nWave + nData - 1;
    
    % FFT of wavelet (check nfft)
    waveletX = fft(wavelet,nConv);
    waveletX = waveletX ./ max(waveletX);
    
    if isempty(ChannelToCompare)
        for nchannel = 1:size(Data,1)
            dataX = fft(squeeze(Data(nchannel,:)),nConv);
            analytic_signal = ifft(waveletX.*dataX,nConv);
            analytic_signal = analytic_signal(half_wavN+1:end-half_wavN);
            Phases(nchannel,:) = angle(analytic_signal);
            PhasesUnwrapped(nchannel,:) = diff(unwrap(Phases(nchannel,:)))/(2*pi/Samplefrequency);
        end
    else
        dataX = fft(squeeze(Data(ChannelToCompare,:)),nConv);
        analytic_signal = ifft(waveletX.*dataX,nConv);
        analytic_signal = analytic_signal(half_wavN+1:end-half_wavN);
        Phases = angle(analytic_signal);
        PhasesUnwrapped = diff(unwrap(Phases))/(2*pi/Samplefrequency);
    end
end