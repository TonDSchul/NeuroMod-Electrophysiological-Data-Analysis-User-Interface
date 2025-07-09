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
end