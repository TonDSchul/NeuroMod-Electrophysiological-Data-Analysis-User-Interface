function [Phases,PhasesUnwrapped,FilterSettings] = Analyse_Main_Window_CalculatePhaseAngles(DataToCompute,Cutoff,Samplefrequency,AlreadyComputed,Method)

%% ------------------------------------------------------------------------------

FilterSettings = [];

if strcmp(Method,"Endpoint Corrected Hilbert Transform")
    % Initialze boundary frequencies for bandpass filter
    FilterSettings.Filt_LF = Cutoff(1);
    FilterSettings.Filt_HF = Cutoff(2);
    
    % Apply ECHT Method
    if AlreadyComputed == 0
        analytic_signal = zeros(size(DataToCompute,1),size(DataToCompute,2));
        Phases = zeros(size(DataToCompute,1),size(DataToCompute,2));
        PhasesUnwrapped = zeros(size(DataToCompute,1),size(DataToCompute,2)-1);
        
        for nchannel = 1:size(DataToCompute,1)
            analytic_signal(nchannel,:) = echt(DataToCompute(nchannel,:), FilterSettings.Filt_LF, FilterSettings.Filt_HF, Samplefrequency, size(DataToCompute,2));
            Phases(nchannel,:) = angle(analytic_signal(nchannel,:));
            PhasesUnwrapped(nchannel,:) = diff(unwrap(Phases(nchannel,:)))/(2*pi/Samplefrequency);
        end
    else
        Phases = DataToCompute;
        PhasesUnwrapped = diff(unwrap(Phases))/(2*pi/Samplefrequency);
    end

elseif strcmp(Method,"Hilbert Transform")
    %% Hilbert Transform
    if AlreadyComputed == 0
        analytic_signal = zeros(size(DataToCompute,1),size(DataToCompute,2)); 
        Phases = zeros(size(DataToCompute,1),size(DataToCompute,2)); 
        PhasesUnwrapped = zeros(size(DataToCompute,1),size(DataToCompute,2)-1); 
        
        for nchannel = 1:size(DataToCompute,1)
            analytic_signal(nchannel,:) = hilbert(DataToCompute(nchannel,:));
            Phases(nchannel,:) = angle(analytic_signal(nchannel,:));
            PhasesUnwrapped(nchannel,:) = diff(unwrap(Phases(nchannel,:)))/(2*pi/Samplefrequency);
        end
    else
        Phases = DataToCompute;
        PhasesUnwrapped = diff(unwrap(Phases))/(2*pi/Samplefrequency);
    end
end





