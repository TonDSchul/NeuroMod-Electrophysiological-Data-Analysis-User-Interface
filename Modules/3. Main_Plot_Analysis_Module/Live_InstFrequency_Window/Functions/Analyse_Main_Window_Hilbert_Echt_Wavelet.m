function [Phases,PhasesUnwrapped] = Analyse_Main_Window_Hilbert_Echt_Wavelet(Data,Method,ChannelToCompare,Samplefrequency,Cutoff,ECHTFilterorder)

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