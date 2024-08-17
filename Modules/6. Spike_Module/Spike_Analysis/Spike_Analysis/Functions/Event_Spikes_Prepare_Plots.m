function [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,BaselineWindowField,ChannelSelectionField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionField,BaselineWindowField,SpikeRateNumBinsEditField,SpikeType)
%% Nr of bins

%% Spike Rate NUmbins
% Loop through each character in the string
for i = 1:length(SpikeRateNumBinsEditField)
    % Check if the current character is not a digit
    if ~isstrprop(SpikeRateNumBinsEditField(i), 'digit')
        % Set the variable to 1 and exit the loop
        SpikeRateNumBinsEditField = '100';
        break;
    end
end

if str2double(SpikeRateNumBinsEditField) < 0 
    SpikeRateNumBinsEditField = '100';
end

%% NrChannels to plot

[ChannelSelectionField] = Utility_SimpleCheckInputs(ChannelSelectionField,"Two",strcat('1,',num2str(size(Data.EventRelatedData,1))));

%% NrEvents to plot

[EventRangeEditField] = Utility_SimpleCheckInputs(EventRangeEditField,"Two",strcat('1,',num2str(size(Data.EventRelatedData,2))));

%% Convert GUI inputs 
spaceindicie = strfind(Data.Info.EventRelatedDataTimeRange,' ');
PlotInfo.TimearoundEvent(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
PlotInfo.TimearoundEvent(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));

commaindicie = strfind(EventRangeEditField,",");
PlotInfo.EventNr(1) = str2double(EventRangeEditField(1:commaindicie-1));
PlotInfo.EventNr(2) = str2double(EventRangeEditField(commaindicie+1:end));
PlotInfo.EventRange = PlotInfo.EventNr(1):PlotInfo.EventNr(2);

commaindicie = find(ChannelSelectionField==',');
PlotInfo.ChannelsToPlot(1) = str2double(ChannelSelectionField(1:commaindicie(1)-1));
PlotInfo.ChannelsToPlot(2) = str2double(ChannelSelectionField(commaindicie(1)+1:end));

PlotInfo.Time = -PlotInfo.TimearoundEvent(1):1/Data.Info.NativeSamplingRate:PlotInfo.TimearoundEvent(2);


PlotInfo.SpikeRateNumBins = str2double(SpikeRateNumBinsEditField);

%% Delete Data based on Channelselection
if strcmp(SpikeType,"Kilosort")
    [TempSpikeTimes,TempSpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(Data.EventRelatedSpikes.SpikeTimes,Data.EventRelatedSpikes.SpikePositions,Data.Info.ChannelSpacing,PlotInfo.ChannelsToPlot,"Kilosort");
else
    [TempSpikeTimes,TempSpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(Data.EventRelatedSpikes.SpikeTimes,Data.EventRelatedSpikes.SpikePositions,Data.Info.ChannelSpacing,PlotInfo.ChannelsToPlot,"Internal");
end

TempSpikeAmplitude = Data.EventRelatedSpikes.SpikeAmps(SelectedChannelIndicies);
TempEvents = Data.EventRelatedSpikes.SpikeEvents(SelectedChannelIndicies);

if strcmp(SpikeType,"Kilosort")
    TempSpikeCluster = Data.EventRelatedSpikes.SpikeCluster(SelectedChannelIndicies);
else
    TempSpikeCluster = zeros(1,length(TempSpikePositions))';
end

%% Select Data based on Event Selecion
PlotInfo.ChannelNr = size(Data.EventRelatedData,1);

TempEventIndicies = zeros(length(TempEvents),1);
for i = 1:length(PlotInfo.EventRange)
    TempEventIndicies = TempEventIndicies + (TempEvents == PlotInfo.EventRange(i));
end
EventIndicies = zeros(length(TempEventIndicies),1);
EventIndicies(TempEventIndicies>=1) = 1;

SpikeTimes = TempSpikeTimes(EventIndicies==1);
SpikePositions = TempSpikePositions(EventIndicies==1);
SpikeAmplitude = TempSpikeAmplitude(EventIndicies==1);
SpikeCluster = TempSpikeCluster(EventIndicies==1);
SpikeEvents = TempEvents(EventIndicies==1);

%% Convert Spike Times in seconds and normalize time to event start
SpikeTimes = (SpikeTimes/Data.Info.NativeSamplingRate)-PlotInfo.TimearoundEvent(1);

%% Initialize Plot Info for heatmap
% Define bin sizes
numchannel = length(PlotInfo.ChannelsToPlot(1):PlotInfo.ChannelsToPlot(2));
PlotInfo.depth_bin_size = Data.Info.ChannelSpacing; %20; % Depth bin size
PlotInfo.time_bin_size = 0.006; % app.GeneralSettings.Time bin size in seconds
% Define bin edges
PlotInfo.depth_edges = 0:Data.Info.ChannelSpacing:numchannel*Data.Info.ChannelSpacing;
PlotInfo.time_edges = -PlotInfo.TimearoundEvent(1):PlotInfo.time_bin_size:PlotInfo.TimearoundEvent(2);

commaindicie = strfind(BaselineWindowField.Value,",");
PlotInfo.NormWindow(1) = str2double(BaselineWindowField.Value(1:commaindicie-1));
PlotInfo.NormWindow(2) = str2double(BaselineWindowField.Value(commaindicie+1:end));