function [Error,SavePath,raw,event,eventdata] = Manage_Dataset_SaveData_FieldTrip(Data,DataType,SaveEvents,SaveFieldTripMat,OpenRawDataBrowser,OpenEventDataBrowser,Autorun,FolderToSave,EventChannel,EventDataType)

%________________________________________________________________________________________

%% This function saves NeuroMod data as a .mat file compatible with FieldTrip

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. DataType: char, either "Raw Data" or "Preprocessed Data" to indicate
% 3. SaveEvents: double 1 or 0 whether to save event data if present
% what component to save
% 4. SaveFieldTripMat: double, 1 or 0 whether mat file is saved (1) for later use in FieldTrip or whether
% this function puts data in a structure to use within NeuroMod
% 5. OpenRawDataBrowser: 1 or 0 to open fieldtrips raw data inspector
% 6. OpenEventDataBrowser: 1 or 0 to open fieldtrips event data inspector
% 7. Autorun: 1 or 0 whether executed in NeuroMod (0) or in batch autorun
% analysis(0)
% 8. FolderToSave: folder to save fieldtrip compatible fiel in
% 9. EventChannel: event channel for which event data is saved along with
% channel data for use in FieldTrip
% 10. EventDataType: char, wither "Raw Event Related Data" or "Preprocessed
% 11. Event Related Data" indicating which one the user wants to save/use

% Output: 
% 1. Error: 1 or 0 whether error occured
% 2. SavePath: path .mat file was actually saved to
% 3. raw: fieldtrip data structure holding metadata and channel data
% 4. event: currently empty
% 5. eventdata: fieldtrip data structure holding event data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

SR = [];
Error = 0;
SavePath = [];

raw = [];
event = [];
eventdata = [];

%% ----------------- Get Save Location -----------------
if SaveFieldTripMat
    if Autorun == "No" || Autorun == "SingleFolder"
        [file, path] = uiputfile('*.mat', 'Save as');
        
        if ~ischar(file) || ~ischar(path)
            disp("No folder selected.")
            return;
        else
            SavePath = fullfile(path,file);
        end
    else
        if isstring(FolderToSave)
            FolderToSave = convertStringsToChars(FolderToSave);
        end
        dashindex = find(FolderToSave=='\');
        path = convertStringsToChars(FolderToSave);
        file = convertStringsToChars(strcat("FieldTrip_",FolderToSave(dashindex(end-2)+1:dashindex(end-1)-1),".mat"));
        
        SavePath = fullfile(path,file);
    end
end
%% Raw/Preprocessed Data
%% ------------------------------------------------------------------------------------------
if strcmp(DataType,"Raw Data")
    raw.fsample  = Data.Info.NativeSamplingRate;                      
    raw.trial    = {Data.Raw};                            
    raw.time     = {Data.Time};   
    raw.label    = arrayfun(@(x) sprintf('chan%d', x), 1:size(Data.Raw,1), 'UniformOutput', false);
    raw.sampleinfo = [1 size(Data.Raw,2)]; % indies trial start to end (continuous = single trial)
else
    if isfield(Data.Info,'DownsampleFactor')
        raw.fsample  = Data.Info.DownsampledSampleRate;                     
        raw.trial    = {Data.Preprocessed};                             
        raw.time     = {Data.TimeDownsampled};   
        raw.label    = arrayfun(@(x) sprintf('chan%d', x), 1:size(Data.Preprocessed,1), 'UniformOutput', false);
        raw.sampleinfo = [1 size(Data.Preprocessed,2)]; % indies trial start to end (continuous = single trial)
    else
        raw.fsample  = Data.Info.NativeSamplingRate;                      
        raw.trial    = {Data.Preprocessed};                             
        raw.time     = {Data.Time};  
        raw.label    = arrayfun(@(x) sprintf('chan%d', x), 1:size(Data.Preprocessed,1), 'UniformOutput', false);
        raw.sampleinfo = [1 size(Data.Preprocessed,2)]; % indies trial start to end (continuous = single trial)
    end
end

raw.cfg = [];

if ~isfield(Data,'Events') && SaveEvents
    warning("Event data selected to save but not present! No event data is saved.");
    if OpenEventDataBrowser == 1
        warning("Selected to open event data in FieldTrip data browser without event data present. Data browser is not opened with event data!")
        OpenEventDataBrowser = 0;
    end
end
if SaveEvents == 0
    warning("Selected to open event data in FieldTrip data browser without event data saved. Data browser is not opened with event data!")
    OpenEventDataBrowser = 0;
end

if isfield(Data,'Events') && SaveEvents
    % If more than one event: select which one to save
    if length(Data.Events)>1 && isempty(EventChannel)
        AppAskForEventWindow = Select_Event_Window(Data);
        
        uiwait(AppAskForEventWindow.SelectEventWindowUIFigure);
        
        if isvalid(AppAskForEventWindow)
            EventChannelToUse = AppAskForEventWindow.SelectedEvent;
            EventRelatedDataType = AppAskForEventWindow.SelectedDataType;
        else
            EventChannelToUse = Data.Info.EventChannelNames{1};
            warning("Could not determine manually selected event channel. Taking event channel 1 as default")
            EventRelatedDataType = "Raw Event Related Data";
        end

        try
            delete(AppAskForEventWindow)
        end
    end
    
    if ~isempty(EventChannel)
        EventChannelToUse = EventChannel;
        EventRelatedDataType = EventDataType;
    end

    EventChannelIndicie = [];
    for nevents = 1:length(Data.Info.EventChannelNames)
        if strcmp(EventChannelToUse,Data.Info.EventChannelNames{nevents})
            EventChannelIndicie = nevents;
            break;
        end
    end

    %% Event Indices
    %% ------------------------------------------------------------------------------------------

    %% -------------------- Set up time -------------------- 
    spaceindicie = strfind(Data.Info.EventRelatedDataTimeRange," ");
    TimearoundEvent(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
    TimearoundEvent(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));
     

    %% Event Related Data
    %% ------------------------------------------------------------------------------------------

    %% -------------------- Set up time -------------------- 
    spaceindicie = strfind(Data.Info.EventRelatedDataTimeRange," ");
    TimearoundEvent(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
    TimearoundEvent(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));

    %% -------------------- Extract Event Related Data -------------------- 
    [Data,~] = Event_Module_Extract_Event_Related_Data(Data,EventChannelToUse,TimearoundEvent,DataType,EventRelatedDataType);

    eventdata = [];
    eventdata.label    = raw.label;
    eventdata.fsample  = raw.fsample;
    eventdata.trial    = {};
    eventdata.time     = {};

    nTrials = size(Data.EventRelatedData,2);
    nSamplesTrial = size(Data.EventRelatedData,3);

    % build time vector relative to event (e.g. -TimeBefore ... +TimeAfter)
    tvec = (-TimearoundEvent(1) : (1/raw.fsample) : (TimearoundEvent(2) - 1/raw.fsample)+(1/raw.fsample));

    for tr = 1:nTrials
        eventdata.trial{tr} = squeeze(Data.EventRelatedData(:,tr,:));   % [nChan × nTime]
        eventdata.time{tr}  = tvec;                                     % [1 × nTime]
    end

    % optional trialinfo: label each trial with event type
    eventdata.trialinfo = [ones(numel(Data.Events{EventChannelIndicie}),1)];

    % add sampleinfo
    eventdata.sampleinfo = zeros(nTrials,2);
    
    trl = zeros(nTrials, 3);
    for tr = 1:nTrials
        % Suppose each event is aligned to sample Data.Events{..}(tr)
        % with TrialRange(1) before and TrialRange(2) after (in seconds)
        startSample = Data.Events{EventChannelIndicie}(tr) - round(TimearoundEvent(1)*raw.fsample +1);
        endSample   = Data.Events{EventChannelIndicie}(tr) + round(TimearoundEvent(2)*raw.fsample) -1 ;
        
        offset = -TimearoundEvent(1);
        trl(tr, :) = [startSample, endSample, offset];

        eventdata.sampleinfo(tr,:) = [startSample endSample];
    end

end

disp("Finished building matlab structure.")

if SaveFieldTripMat
    disp(strcat("Saving .mat file in ",SavePath))
    if isfield(Data,'Events') && SaveEvents
        save(SavePath, 'raw', 'event', 'eventdata', '-v7.3');
    else
        save(SavePath, 'raw', '-v7.3');
    end
end

if OpenRawDataBrowser
    ft_databrowser([], raw);        % browse continuous data
end

if OpenEventDataBrowser
    ft_databrowser([], eventdata);  % browse trial-segmented data
end
