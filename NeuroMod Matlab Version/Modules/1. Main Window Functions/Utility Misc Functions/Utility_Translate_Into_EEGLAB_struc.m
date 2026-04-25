function [Data] =  Utility_Translate_Into_EEGLAB_struc(Signal,PPStep,Data,Downsampling,PreProInfo)

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

%% Create probe layout for interpoaltion of bad channel 
EEG.chanlocs = [];
EEG.filepath = Data.Info.Data_Path;
EEG.filename = Data.Info.Data_Path;

msgbox("Starting Subspace reconstruction. Please see command window for more informaton.");
pause(0.1)
if PreProInfo.EnableChannelCrit == 0
    PreProInfo.ASRChannelCriterion = 'off';
end
if PreProInfo.EnableLineNoiseCrit == 0
    PreProInfo.ASRLineNoiseC = 'off';
end
if PreProInfo.EnableBurstCrit == 0
    PreProInfo.ASRBurstC = 'off';
end
if PreProInfo.EnableWindowCrit == 0
    PreProInfo.WindowC = 'off';
end

[cleanEEG,HP,BUR,removed_channels] = clean_artifacts(EEG,'ChannelCriterion',PreProInfo.ASRChannelCriterion,'LineNoiseCriterion',PreProInfo.ASRLineNoiseC,'BurstCriterion',PreProInfo.ASRBurstC,'WindowCriterion',PreProInfo.WindowC,'Highpass',PreProInfo.ASRHPTransitions);

SaveResults = 1;

if sum(removed_channels)>0
    ChannelIndicies = find(removed_channels==1);

    % firtst ask if user want to deleted channel
    AskForASRChannelDel = Ask_For_ASR_ChannelDeletion(ChannelIndicies);
        
    uiwait(AskForASRChannelDel.ASRChannelDeletionWindowUIFigure);
    % Wait for the app to close
    
    DeleteChannel = 0;
    if isvalid(AskForASRChannelDel)
        if AskForASRChannelDel.DeleteChannel == 0
            disp("No channel are deleted for ASR. Results are not saved.")
            delete(AskForASRChannelDel);
            return;
        else
            DeleteChannel = AskForASRChannelDel.DeleteChannel;
            delete(AskForASRChannelDel);
        end
    else
        SaveResults = 0;
    end
    
    if DeleteChannel
        h2 = waitbar(0, 'Deleting Channel...', 'Name','Preprocessing...');
        msg = sprintf('Deleting Channel... (%d%% done)', round(100*(1/2)));
        waitbar(1/2, h2, msg);
        
        [Data] = Preprocess_Module_ChannelDeletion(Data,ChannelIndicies);
    
        msg = sprintf('Deleting Channel... (%d%% done)', round(100*(1)));
        waitbar(1, h2, msg);
        close(h2);
    else
        SaveResults = 0;
    end
end

if SaveResults
    Data.Preprocessed = single(cleanEEG.data);
    msgbox(strcat("Finished! ",num2str(sum(removed_channels))," channel where removed!"));
end

%vis_artifacts(cleanEEG,EEG);
