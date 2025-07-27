function [Data,TimearoundEvent] = Event_Module_Extract_Event_Related_Data(Data,EventChannel,TimearoundEvent,DataToExtractFrom,EventDataType)

%________________________________________________________________________________________
%% Function to extract event related data as a nchannel x nevents x ntime matrix

% Channel x trials x time matrix is extracted on the fly as needed, but
% saved in the app.Data structure after each extraction and can be
% retrieved from there

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the infio structure with infos about extracted events.
% 2. EventChannel: Name of the event channel you want to calculate the ERD
% data for; as char; i.e. 'DIN-04' for Intan (saved in Data.Info.EventChannelNames)
% 3. TimeRange: double 1x2 vector with time before, then a space then time after (in seconds, both positive)
% 5. DataToExtractFrom: Type of data you want to extract event snippets for, as char either
% "Preprocessed Data" or "Raw Data"
% 6. EventDataType: char, 'Raw Event Related Data" or "Preprocessed Event
% Related Data". If the latter is selected, channel interpolation and trial
% rejection are added to the normal event related data and saved in a
% separate field in the second half of this code

% Outputs:
% 1. Data: Data object passed here with added field: Data.EventRelatedData
% and adeed infos to Data.Info
% 2. TimearoundEvent: 1 x 2 double containing time before and time after
% event (both positive!)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

EventChannelNr = [];

%-------------------------------------------------------------------
%% ---------------- Check Up and Event channel Indice ----------------
%-------------------------------------------------------------------

if isfield(Data,'EventRelatedData')
    fieldsToDelete = {'EventRelatedData'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
end 
% get Data.Events indice of selected event channel
for i = 1:length(Data.Info.EventChannelNames)
    if strcmp(EventChannel,Data.Info.EventChannelNames{i})
        EventChannelNr = i;
    end
end

if isempty(Data.Events{EventChannelNr})
    msgbox("No Events found for this channel");
    return;
end

%-------------------------------------------------------------------
%% ---------------- Convert Time Around Event in Number of Samples ----------------
%-------------------------------------------------------------------

if strcmp(DataToExtractFrom,"Raw Data")
    NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.NativeSamplingRate);
    NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.NativeSamplingRate);
    % Handling Downsampled data
elseif strcmp(DataToExtractFrom,"Preprocessed Data") && isfield(Data.Info,'DownsampledSampleRate')
    NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.DownsampledSampleRate);
    NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.DownsampledSampleRate);
    TempOriginalEvents = Data.Events;
    Data.Events{EventChannelNr} = round(Data.Events{EventChannelNr}./Data.Info.DownsampleFactor);
    
elseif strcmp(DataToExtractFrom,"Preprocessed Data") && ~isfield(Data.Info,'DownsampledSampleRate')
    NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.NativeSamplingRate);
    NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.NativeSamplingRate);
end

ntimepoints = NumSamplesBefore+NumSamplesAfter+1;

if strcmp(EventDataType,"Preprocessed Event Related Data")
    h = waitbar(0, 'Extracting Preprocessed Event Related Data...', 'Name','Extracting Preprocessed Event Related Data...');
else
    h = waitbar(0, 'Extracting Event Related Data...', 'Name','Extracting Event Related Data...');
end

%-------------------------------------------------------------------
%% ---------------- Start Data Extraction ----------------
%-------------------------------------------------------------------
if strcmp(DataToExtractFrom,"Raw Data")
    % Initialize
    Data.EventRelatedData = NaN(size(Data.Raw,1),length(Data.Events{EventChannelNr}),ntimepoints);
    % Loop over event indicies (trials)
    for nevents = 1:length(Data.Events{EventChannelNr})
        if Data.Events{EventChannelNr}(nevents)-NumSamplesBefore > 0 && Data.Events{EventChannelNr}(nevents)+NumSamplesAfter <= size(Data.Raw,2)
            Data.EventRelatedData(1:size(Data.Raw,1),nevents,1:ntimepoints) = Data.Raw(:,Data.Events{EventChannelNr}(nevents)-NumSamplesBefore:Data.Events{EventChannelNr}(nevents)+NumSamplesAfter);    
        else
            warning(strcat("Warning: Event",num2str(nevents)," cannot be included since the time before or after the event is violating time limits"))
        end

        % Update the progress bar
        fraction = nevents/length(Data.Events{EventChannelNr});
        if strcmp(EventDataType,"Preprocessed Event Related Data")
            msg = sprintf('Extracting Preprocessed Event Related Data... (%d%% done)', round(100*fraction));
        else
            msg = sprintf('Extracting Event Related Data... (%d%% done)', round(100*fraction));
        end
        waitbar(fraction, h, msg);
    end
elseif strcmp(DataToExtractFrom,"Preprocessed Data")
    % Initialize
    Data.EventRelatedData = NaN(size(Data.Preprocessed,1),length(Data.Events{EventChannelNr}),ntimepoints);
    % Loop over event indicies (trials)
    for nevents = 1:length(Data.Events{EventChannelNr})
        % save data within sample number range
        if Data.Events{EventChannelNr}(nevents)-NumSamplesBefore > 0 && Data.Events{EventChannelNr}(nevents)+NumSamplesAfter <= size(Data.Preprocessed,2)
            Data.EventRelatedData(1:size(Data.Preprocessed,1),nevents,1:ntimepoints) = Data.Preprocessed(:,Data.Events{EventChannelNr}(nevents)-NumSamplesBefore:Data.Events{EventChannelNr}(nevents)+NumSamplesAfter);    
        else
            warning(strcat("Warning: Event",num2str(nevents)," cannot be included since the time before or after the event is violating time limits"))
        end

        % Update the progress bar
        fraction = nevents/length(Data.Events{EventChannelNr});
        if strcmp(EventDataType,"Preprocessed Event Related Data")
            msg = sprintf('Extracting Preprocessed Event Related Data... (%d%% done)', round(100*fraction));
        else
            msg = sprintf('Extracting Event Related Data... (%d%% done)', round(100*fraction));
        end
        waitbar(fraction, h, msg);
    end
end

%-------------------------------------------------------------------
%% ---------------- Remains from old code, still in since initialization with NaN ----------------
%-------------------------------------------------------------------
% does not occur anymore! 
DeleteIndicie = [];
for nTrials = 1:size(Data.EventRelatedData,2)
    if isnan(Data.EventRelatedData(:,nTrials,:))
        DeleteIndicie = [DeleteIndicie,nTrials];
    end
end

Data.EventRelatedData(:,DeleteIndicie,:) = [];

if strcmp(DataToExtractFrom,"Preprocessed Data") && isfield(Data.Info,'DownsampledSampleRate')
    Data.Events = TempOriginalEvents;
    clear TempOriginalEvents;
end

Data.EventRelatedData = single(Data.EventRelatedData);

close(h);

%-------------------------------------------------------------------
%% ---------------- Preprocessed Event Related Data On The Fly ----------------
%-------------------------------------------------------------------
if strcmp(EventDataType,"Preprocessed Event Related Data")
    if ~isfield(Data.Info,'EventRelatedPreprocessing')
        warning('No prepro information added for event related data but preprocessing requested. Step is skipped instead.')
        return;
    end
        
    %% ---------------- Delete Trials ----------------
    if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials')
        % Find rejection indices for the currently selected event channel
        Namevector = split(string(Data.Info.EventRelatedPreprocessing.TrialRejectionEventChannelNames), ',');
        TrialrejectionindiciesCurrentChannel = find(Namevector == EventChannel);
        % Select trials if event channel found
        if ~isempty(TrialrejectionindiciesCurrentChannel)
            TrialsToReject = Data.Info.EventRelatedPreprocessing.TrialRejectionTrials(TrialrejectionindiciesCurrentChannel);
        else
            TrialsToReject = [];
        end
        
        %% ---------------- Create Prepro Dataset ----------------
        Data.PreprocessedEventRelatedData = Data.EventRelatedData;
        
        if ~isempty(TrialsToReject)
            Data.PreprocessedEventRelatedData(:,TrialsToReject,:) = [];
        end
    end
    %% ---------------- Interpolate Channel ----------------
    if isfield(Data.Info.EventRelatedPreprocessing,'ChannelRejectionChannel')
         % Find rejection indices for the currently selected event channel
        Namevector = split(string(Data.Info.EventRelatedPreprocessing.ChannelRejectionEventChannelNames), ',');
        ChannelrejectionindiciesCurrentChannel = find(Namevector == EventChannel);
        % Select trials if event channel found
        if ~isempty(ChannelrejectionindiciesCurrentChannel)
            ChanneltoReject = Data.Info.EventRelatedPreprocessing.ChannelRejectionChannel(ChannelrejectionindiciesCurrentChannel);
        else
            ChanneltoReject = [];
        end
        
        if isfield(Data,'PreprocessedEventRelatedData')
            %% ---------------- Create Prepro Dataset ----------------
            [Data.PreprocessedEventRelatedData] = Preprocessing_Events_Interpolate_Channel(Data.PreprocessedEventRelatedData,ChanneltoReject);
        else
            [Data.PreprocessedEventRelatedData] = Preprocessing_Events_Interpolate_Channel(Data.EventRelatedData,ChanneltoReject);
        end

    end
end
