function [OutputSignal] =  Utility_Translate_Into_EEGLAB_struc(Signal,PPStep,Data,Downsampling,PreProInfo)

%________________________________________________________________________________________
%% Function to convert GUI data structure in to strcuture readable by eeglab 


% This function is executed when the user wants to conduct artefact
% subspace reconstruction in the preprocessing window

% Inputs: 
% 1. Signal: channel x times matrix to do rejection for
% 2. PPStep: double, number of the current preprocessing step applied (in which ASR is executed)
% 3. Data: main app data structure with all relevant data components
% 4. Downsampling: double, 1 if data was downsampled before
% 5. PreProInfo: structure holding prepro information for each step
% applied -- also ASR info


% Outputs:
% 1. OutputSignal: channel x times matrix with cleaned dataset

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


EEG.data = Signal; % Assign the input data to the EEG structure

if Downsampling == 1
    EEG.srate = PreProInfo.DownsampledSampleRate; % Set the sampling rate (example value)%%
    EEG.nbchan = size(Data.Preprocessed, 1); % Number of channels
    EEG.pnts = size(Data.Preprocessed, 2); % Number of data points
    EEG.times = Data.TimeDownsampled;
    EEG.xmin = 0;
    EEG.xmax = Data.TimeDownsampled(end);
else
    if PPStep == 1
        EEG.nbchan = size(Data.Raw, 1); % Number of channels
        EEG.pnts = size(Data.Raw, 2); % Number of data points
        EEG.srate = Data.Info.NativeSamplingRate; % Set the sampling rate (example value)
    else
        EEG.nbchan = size(Data.Preprocessed, 1); % Number of channels
        EEG.pnts = size(Data.Preprocessed, 2); % Number of data points
        EEG.srate = Data.Info.NativeSamplingRate; % Set the sampling rate (example value)
    end
    EEG.times = Data.Time;
    EEG.xmin = 0;
    EEG.xmax = Data.Time(end);
end

EEG.trials = 1;

EEG.event = [];  % default state
EEG.urevent = [];
EEG.etc = [];
EEG.chanlocs = [];
EEG.filepath = Data.Info.Data_Path;
EEG.filename = Data.Info.Data_Path;

msgbox("Starting Subspace reconstruction. Please see command window for more informaton.");

[cleanEEG,HP,BUR,removed_channels] = clean_artifacts(EEG,'LineNoiseCriterion',PreProInfo.ASRLineNoiseC,'BurstCriterion',PreProInfo.ASRBurstC,'WindowCriterion','off','Highpass',PreProInfo.ASRHPTransitions);

%[cleanEEG,HP,BUR,removed_channels] = clean_artifacts(EEG);

OutputSignal = cleanEEG.data;
msgbox(strcat("Finished! ",num2str(sum(removed_channels))," channel where removed!"));

%vis_artifacts(cleanEEG,EEG);
