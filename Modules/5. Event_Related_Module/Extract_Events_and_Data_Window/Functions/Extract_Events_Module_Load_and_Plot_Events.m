function Extract_Events_Module_Load_and_Plot_Events(EventInfo,FilePaths,Figure,SelectedEventChannelNames,AllChannelNames,Data,RHDAllChannelData,DownsampleRate)

%________________________________________________________________________________________
%% Function load and plot event data in the show event data window (opened in the extract events window)

% This function gets called by Extract_Events_Module_Show_ChannelPlots.m
% and gets event data from that function to plot it

% Inputs: 
% 1. EventInfo: comes from the 'Extract_Events_Module_Determine_Available_EventChannel' function.
%    contains recording system specific infos about events.
% 2. FilePaths: contents of folder in which events were searched for (ncontens x 1 cell array with each cell containing a string)
% 3. Figure: figure axes handle to plot event data in
% 4. SelectedEventChannelNames: char, name of the event type (i.e. for Intan: Digital Inputs)
% 5. AllChannelNames: Anmes if all possible name of the event types
% 6. Data: main data structure from main window (mainly fot Data.Info field)
% 7. RHDAllChannelData: Just If Intan .rhd: events are extracted ones, then saved in this
% variable to be able to show again without having to extract again. Just
% for Intan.rhd bc it takes by far the longest
% 8. DownsampleRate: string, desired new sampling rate in Hz after
% downsampling

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


%% Get original channel names
if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")
    for i = 1:length(AllChannelNames)
        if strcmp(SelectedEventChannelNames,AllChannelNames{i})
            InputChannelSelection = i;
        end
    end
end
% extract data for .data files
if strcmp(Data.Info.RecordingType,"IntanDat")
    %% Load Data
    FileIdentifier = fopen(FilePaths{EventInfo(InputChannelSelection)},'r');
    
    InputChannelData = fread(FileIdentifier, 'uint16');
    
    InputChannelData = single(InputChannelData); %analog input to Volt (not mV!)

    % for rhd was already extracted (to not load data every time this
    % function is called) -- eaier to load at start ups
elseif strcmp(Data.Info.RecordingType,"IntanRHD")
    InputChannelData = single(RHDAllChannelData(InputChannelSelection,:));
    clear("RHDAllChannelData");
elseif strcmp(Data.Info.RecordingType,"Open Ephys") || strcmp(Data.Info.RecordingType,"Neuralynx")
    InputChannelData = EventInfo;
elseif strcmp(Data.Info.RecordingType,"Spike2")
    InputChannelData = EventInfo{1};
    if size(InputChannelData,1)>1
        InputChannelData = InputChannelData';
    end
end

%% If cutstart or cutend:
if ~strcmp(Data.Info.RecordingType,"Open Ephys") % for open ephys done in Show_ChannelPlots function
    if isfield(Data.Info,'CutStart')
        index = round(sum(Data.Info.CutStart) * Data.Info.NativeSamplingRate); % convert in samples
        InputChannelData(1:index) = [];
        % EventsToDelete = InputChannelData <= index;
        % InputChannelData(EventsToDelete) = []; % Delete indicies smaller than start
        % InputChannelData = InputChannelData - index; %substract number of indicies before first event that are cut away so that events are scaled o new ime range
    end
    
    if isfield(Data.Info,'CutEnd')
        index = round(sum(Data.Info.CutEnd) * Data.Info.NativeSamplingRate); % convert in samples
        InputChannelData(end-index:end) = []; % Delete indicies smaller than start
    end
end
%% Downsample if not empty
if ~isempty(DownsampleRate)
    DownsampleRate = str2double(DownsampleRate);
    DownsampleFactor = round(Data.Info.NativeSamplingRate/DownsampleRate);
    InputChannelData = downsample(InputChannelData,DownsampleFactor);
    Time = downsample(Data.Time,DownsampleFactor);
else
    Time = Data.Time;
end

%% Plot Data

EventPlotHandles = findobj(Figure, 'Type', 'line', 'Tag', 'Events');
if length(EventPlotHandles)>1
    delete(EventPlotHandles(2:end));
end

EventPlotHandles = findobj(Figure, 'Type', 'line', 'Tag', 'Events');

xlabel(Figure,"Time [s]")
ylabel(Figure,"Signal [V]")
if strcmp(Data.Info.RecordingType,"IntanDat") || strcmp(Data.Info.RecordingType,"IntanRHD")
    title(Figure,strcat("Signal in V from Channel ",AllChannelNames{InputChannelSelection}));
elseif strcmp(Data.Info.RecordingType,"Open Ephys")
    title(Figure,strcat("Signal in V from Node ",AllChannelNames," Line ",SelectedEventChannelNames));
elseif strcmp(Data.Info.RecordingType,"Spike2")
    title(Figure,strcat("Signal in V from Node ",AllChannelNames," Channel ",SelectedEventChannelNames));
end

xlim(Figure,[Time(1) Time(end)]);

if isempty(EventPlotHandles)
    line(Figure,Time(1:length(InputChannelData)),InputChannelData,'LineWidth',1.5,'Color','b', 'Tag', 'Events');
else
    set(EventPlotHandles(1), 'XData', Time(1:length(InputChannelData)), 'YData', double(InputChannelData), 'Color', 'b', 'Tag', 'Events');
end