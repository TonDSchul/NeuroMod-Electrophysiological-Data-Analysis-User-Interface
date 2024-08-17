function [Data,TimearoundEvent] = Event_Module_Extract_Event_Related_Data(Data,EventChannel,TimeWindowBefore,TimeWindowAfter,DatatoUse)

%________________________________________________________________________________________
%% Function to extract event related data as a nchannel x nevents x ntime matrix

% Inputs: 
% 1.Data: Data structure with raw data, preprocessed data, event data and
% the infio structure with infos about extracted events.
% 2. EventChannel: Name of the event channel you want to calculate the ERD
% data for; as char; i.e. 'DIN-04' (saved in Data.Info.EventChannelNames)
% 3. TimeWindowBefore: Time in seconds to take before each event as double,
% always positive!
% 4. TimeWindowAfter: Time in seconds to take after each event as double,
% always positive!
% 5. DatatoUse: Type of data you want to extract event snippets for, as char either
% "Preprocessed" or "Raw"

% Outputs:
% 1. Data: Data object passed here with added field: Data.EventRelatedData
% and adeed infos to Data.Info
% 2. TimearoundEvent: 1 x 2 double containing time before and time after
% event (both positive!)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


TimearoundEvent = [];
EventChannelNr = [];

if isfield(Data,'EventRelatedData')
    if ~isempty(Data.EventRelatedData)
        msgbox("Existing event related data found and overwritten");
        Data.EventRelatedData = [];
        fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
end

if isfield(Data,'PreprocessedEventRelatedData')
    if ~isempty(Data.PreprocessedEventRelatedData)
        msgbox("Existing preprocessed event related data found and deleted");
        fieldsToDelete = {'PreprocessedEventRelatedData'};
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'EventRelatedPreprocessing'};
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
end

for i = 1:length(Data.Info.EventChannelNames)
    if strcmp(EventChannel,Data.Info.EventChannelNames{i})
        EventChannelNr = i;
    end
end

if isempty(Data.Events{EventChannelNr})
    msgbox("No Events found for this channel");
    return;
end

TimearoundEvent(1) = str2double(TimeWindowBefore);
TimearoundEvent(2) = str2double(TimeWindowAfter);

% Time around event
if strcmp(DatatoUse,"Raw")
    NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.NativeSamplingRate);
    NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.NativeSamplingRate);
    % Handling Downsampled data
elseif strcmp(DatatoUse,"Preprocessed") && isfield(Data.Info,'DownsampledSampleRate')
    NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.DownsampledSampleRate);
    NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.DownsampledSampleRate);
    TempOriginalEvents = Data.Events;
    Data.Events{EventChannelNr} = round(Data.Events{EventChannelNr}./Data.Info.DownsampleFactor);
    
elseif strcmp(DatatoUse,"Preprocessed") && ~isfield(Data.Info,'DownsampledSampleRate')
    NumSamplesBefore = round(TimearoundEvent(1)*Data.Info.NativeSamplingRate);
    NumSamplesAfter = round(TimearoundEvent(2)*Data.Info.NativeSamplingRate);
end

ntimepoints = NumSamplesBefore+NumSamplesAfter+1;

h = waitbar(0, 'Extracting Events...', 'Name','Extracting Events...');

if strcmp(DatatoUse,"Raw")
    Data.EventRelatedData = NaN(size(Data.Raw,1),length(Data.Events{EventChannelNr}),ntimepoints);
    %Data.EventRelatedData = single(NaN(size(Data.Raw,1),length(Data.Events{EventChannelNr}),ntimepoints));
    % Loop over event indicies (trials)
    for nevents = 1:length(Data.Events{EventChannelNr})
        if Data.Events{EventChannelNr}(nevents)-NumSamplesBefore > 0 && Data.Events{EventChannelNr}(nevents)+NumSamplesAfter <= size(Data.Raw,2)
            Data.EventRelatedData(1:size(Data.Raw,1),nevents,1:ntimepoints) = Data.Raw(:,Data.Events{EventChannelNr}(nevents)-NumSamplesBefore:Data.Events{EventChannelNr}(nevents)+NumSamplesAfter);    
        else
            disp(strcat("Warning: Event",num2str(nevents)," cannot be included since the time before or after the event is violating time limits"))
        end

        % Update the progress bar
        fraction = nevents/length(Data.Events{EventChannelNr});
        msg = sprintf('Extracting Events... (%d%% done)', round(100*fraction));
        waitbar(fraction, h, msg);

    end
elseif strcmp(DatatoUse,"Preprocessed")
    Data.EventRelatedData = NaN(size(Data.Preprocessed,1),length(Data.Events{EventChannelNr}),ntimepoints);
    % Loop over event indicies (trials)
    for nevents = 1:length(Data.Events{EventChannelNr})
        if Data.Events{EventChannelNr}(nevents)-NumSamplesBefore > 0 && Data.Events{EventChannelNr}(nevents)+NumSamplesAfter <= size(Data.Preprocessed,2)
            Data.EventRelatedData(1:size(Data.Preprocessed,1),nevents,1:ntimepoints) = Data.Preprocessed(:,Data.Events{EventChannelNr}(nevents)-NumSamplesBefore:Data.Events{EventChannelNr}(nevents)+NumSamplesAfter);    
        else
            disp(strcat("Warning: Event",num2str(nevents)," cannot be included since the time before or after the event is violating time limits"))
        end

        % Update the progress bar
        fraction = nevents/length(Data.Events{EventChannelNr});
        msg = sprintf('Extracting Events... (%d%% done)', round(100*fraction));
        waitbar(fraction, h, msg);

    end
end

%% Event Data is NaN padded and events not firtting in time frames remain NaN. They have to be deleted
DeleteIndicie = [];
for nTrials = 1:size(Data.EventRelatedData,2)
    if isnan(Data.EventRelatedData(:,nTrials,:))
        DeleteIndicie = [DeleteIndicie,nTrials];
    end
end

Data.EventRelatedData(:,DeleteIndicie,:) = [];

if strcmp(DatatoUse,"Preprocessed") && isfield(Data.Info,'DownsampledSampleRate')
    Data.Events = TempOriginalEvents;
    clear TempOriginalEvents;
end

Data.Info.EventRelatedDataChannel = Data.Info.EventChannelNames{EventChannelNr};
Data.Info.EventRelatedDataType = DatatoUse;
Data.Info.EventRelatedDataTimeRange = [TimeWindowBefore,' ',TimeWindowAfter];
Data.EventRelatedData = single(Data.EventRelatedData);

close(h);