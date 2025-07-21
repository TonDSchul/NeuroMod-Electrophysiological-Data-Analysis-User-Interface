function [Data] = Preprocess_ApplyStimArtefactRejection(Data,Info,Events,PreproInfo,SampleRate,Downsampled)

%________________________________________________________________________________________

%% Function apply stimulation artefact rejection (interpolation) to the dataset
% This function is called in the Preprocess_Module_Apply_Pipeline.m
% function when the user added artefact rejection to the preprocessing
% pipeline and executes the pipeline. It interpolates all data points
% around event indicie of a selected input event channel holding time
% points of the stimulation

% Input:
% 1. Data: Either Data.Raw or Data.Preprocessed data, depending on whether its the
% fist preprocessing step or not. If yes, pass raw data, otherwise
% preprocessed data
% 2. Info: Data.Info structure of main dataset
% 3. Events: Data.Events field of main dataset; 1 x number events cell array with each cell containing the
% indicies of extracted events. 
% 4. PreproInfo: strcuture holding the infos about added preprocessing
% steps (paramater to apply), comes from
% Preprocess_Module_Construct_Pipeline.m when adding a step to the pipeline

% Output: 
% 1. Data: Either corrected Data.Raw or correctr Data.Preprocessed data from the main dataset, depending on whether its the first preprocessing step . 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Determine selected channel
% not necesary i startup but later: get event number user selected
SelectedEventIndicie = [];
for neventchannel = 1:length(Info.EventChannelNames)
    if strcmp(PreproInfo.StimArtefactChannel,Info.EventChannelNames{neventchannel})
        SelectedEventIndicie = neventchannel;
    end
end

%% Correct Dta around Channel

Eventsoutside = [];
numtimepoints = round((abs(PreproInfo.TimeAroundStimArtefact(1))+abs(PreproInfo.TimeAroundStimArtefact(2)))*SampleRate)+1;
TimeBefore(1) = abs(PreproInfo.TimeAroundStimArtefact(1)*SampleRate);
TimeAfter(1) = abs(PreproInfo.TimeAroundStimArtefact(2)*SampleRate);

AffectedChannel = 1:size(Data,1);

for i = 1:length(PreproInfo.ArtefactRejectedTrigger)
    % get current event incide and downsample if necesasry
    nevents = PreproInfo.ArtefactRejectedTrigger(i);
    CurrentEventIndice = Events{SelectedEventIndicie}(nevents);

    if Downsampled
        CurrentEventIndice = round(CurrentEventIndice/PreproInfo.DownsampleFactor);
    end

    if CurrentEventIndice-PreproInfo.TimeAroundStimArtefact(1) > 0 && CurrentEventIndice+PreproInfo.TimeAroundStimArtefact(2) < size(Data,2)
        for nchannel = AffectedChannel
            
            % Interpolate Data
            InterpolationValue(1) = Data(AffectedChannel(nchannel),(CurrentEventIndice-TimeBefore)-1); % First value before time window taken for interpolation
            InterpolationValue(2) = Data(AffectedChannel(nchannel),(CurrentEventIndice+TimeAfter)+1); % First value after time window taken for interpolation
            
            InterpolationSample(1) = (CurrentEventIndice-TimeBefore)-1; % First value before time window taken for interpolation
            InterpolationSample(2) = (CurrentEventIndice+TimeAfter)+1; % First value after time window taken for interpolation
            InterpolationRange = InterpolationSample(1)+1:InterpolationSample(2)-1;

            InterpolatedData = interp1(InterpolationSample, InterpolationValue, InterpolationRange, 'linear');

            % Swap Data with Interpolated Data
            Data(AffectedChannel(nchannel),InterpolationRange) = InterpolatedData;
        end
    else
        Eventsoutside = [Eventsoutside,nevents];
    end
end

if ~isempty(Eventsoutside)
    msgbox(strcat("Boundaries for event nr. ",num2str(Eventsoutside)," violate time limits. Data around event not extracted."))
end
