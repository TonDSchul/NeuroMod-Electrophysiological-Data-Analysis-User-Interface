function [ECHT_Phases,HILBERT_Phases,ECHTResultUnwrap,HILBERT_PhasesUnwrap,Samplefrequency,FilterSettings] = Analyse_Main_Window_Apply_ECHT(MainplotData,Info,SelectedChannel,NarrowbandCutoffLowerHigher,NarrowbandFilterOrder,NarrowBandApplied,DataTypeDropDown)


Cutoff = str2double(strsplit(NarrowbandCutoffLowerHigher,','));
SelectedChannel = str2double(SelectedChannel);
filterorder = str2double(NarrowbandFilterOrder);

% select data
DataToCompute = MainplotData(SelectedChannel,:);
OriginalDataToCompute = MainplotData(SelectedChannel,:);

Downsampleflag = 0;
if isfield(Info,'DownsampledSampleRate') && strcmp(DataTypeDropDown,'Preprocessed Data')
    Downsampleflag = 1;
end

Resampleanyway = 0;
if strcmp(DataTypeDropDown,'Raw Data')
    if NarrowBandApplied == 1 && Downsampleflag == 1
        Resampleanyway = 1;
    end
end

Samplefrequency = Info.NativeSamplingRate;

if NarrowBandApplied == 0 || Resampleanyway == 1
    if Downsampleflag == 0
        
        %% resample and narrowband filter
        if Info.NativeSamplingRate>1000
            %% 1. Low Pass and downsample
            [DataToCompute, B, A] = ft_preproc_lowpassfilter(double(DataToCompute), Info.NativeSamplingRate, 300, 4, 'but', 'twopass', 'no', [],'hamming', [], 'no', 'no');
            
            FsTarget = 1000;
            DownsampleFactor = round(Info.NativeSamplingRate/FsTarget);
            DataToCompute = downsample(DataToCompute,DownsampleFactor);
            
            Samplefrequency = FsTarget;

        end
        %% 1. Narrowband filter
        % filter parameters
        nyquist = Samplefrequency/2;
        
        % filter kernel
        filtkern = fir1(filterorder,Cutoff/nyquist);

        % apply the filter to the data
        DataToCompute = filtfilt(filtkern,1,double(DataToCompute));   
    else
        %% Take raw data and resample and narrowband filter
        
        Samplefrequency = Info.DownsampledSampleRate;

        %% 1. Narrowband filter
        % filter parameters
        nyquist = Samplefrequency/2;
        
        % filter kernel
        filtkern = fir1(filterorder,Cutoff/nyquist);

        % apply the filter to the data
        DataToCompute = filtfilt(filtkern,1,double(DataToCompute));   

    end
else
    if Downsampleflag == 0
        %% just downsample
        if Info.NativeSamplingRate>1000
            DownsampleFactor = round(Info.NativeSamplingRate/1000);
            DataToCompute = downsample(DataToCompute,DownsampleFactor);
            Samplefrequency = 1000;
        end
    else
        %% Do nothing
        Samplefrequency = Info.DownsampledSampleRate;
    end
end 
%% ------------------------------------------------------------------------------

% Initialze boundary frequencies for bandpass filter
FilterSettings.Filt_LF = Cutoff(1);
FilterSettings.Filt_HF = Cutoff(2);

% Apply ECHT Method
ECHTResult = echt(DataToCompute, FilterSettings.Filt_LF, FilterSettings.Filt_HF, Samplefrequency, length(DataToCompute));

% Instantaneous phase (radians)
ECHT_Phases = angle(ECHTResult);

analytic_signal = hilbert(DataToCompute);
HILBERT_Phases = angle(analytic_signal);

ECHTResultUnwrap = diff(unwrap(ECHT_Phases))/(2*pi/Samplefrequency);
HILBERT_PhasesUnwrap = diff(unwrap(HILBERT_Phases))/(2*pi/Samplefrequency);


