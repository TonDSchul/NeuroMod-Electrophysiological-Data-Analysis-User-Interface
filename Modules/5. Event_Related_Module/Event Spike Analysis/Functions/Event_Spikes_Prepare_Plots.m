function [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,BaselineWindowField,ChannelSelectionField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionField,BaselineWindowField,SpikeRateNumBinsEditField,SpikeType,SpikeTriggereAverage,SpikeTriggeredAverageField,SpikeBinSettings,ActiveChannel)
%________________________________________________________________________________________
%% Function to prepare plots for internal and kilosort event spike analysis

% This function is called in the
% Events_Internal_Spike_Window and Events_Kilosort_Spike_Window app
% windows when something new has to be plotted. It prepares everything for
% the function that selects plotting functions based on input
% This means it checks the correct format of inputs, corrects it with
% standard values if necessary and pools them in a structure accessed later
% for analysis and plotting. This function also selects the spikes in the
% channalerange

% Inputs:

% 1. Data: main window app structure with Data.Info and Data.Spikes fields
% 2. EventRangeEditField: text field of app containing event range userinput as char in
% the field EventRangeEditField.Value, like '1,10' for events 1 to 10
% 3. ChannelSelectionField: text field of app containing channel range userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10
% 4. BaselineWindowField: text field of app containing basline window range userinput as char in
% the field ChannelEditField.Value, like '-0.005,0' for channel -0.005s to 0s
% 5. SpikeRateNumBinsEditField: text field of app containing basline num bins for spike rate userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins
% 6. SpikeType: Type of spikes of dataset, either 'Kilosort' OR 'Internal'
% (from Data.Info.SpikeTpe)
% 7. SpikeTriggereAverage: 1 if spiked triggered average is computed, 0
% otherwise
% 8. SpikeTriggeredAverageField: field of app window holding time range for
% spiked triggered average, as char, i.e. '-0.05,0.2'
% 9. SpikeBinSettings: structure, save numbins in time and depth domain for spike
% rate heatmap plot -- see Spike_Module_Set_Up_Spike_Analysis_Windows.m for
% standard. 

%Outputs:

% 1. PlotInfo: structure holding gathered info about user input, contains
% fields: PlotInfo.TimearoundEvent,PlotInfo.EventNr,PlotInfo.EventRange,PlotInfo.ChannelsToPlot,PlotInfo.Time,PlotInfo.ChannelNr,PlotInfo.SpikeRateNumBins,PlotInfo.depth_bin_size,PlotInfo.time_bin_size ,PlotInfo.depth_edges,PlotInfo.time_edges , PlotInfo.NormWindow
% 2. SpikeTimes: nspikes x 1 double with just spike indicies within the
% channelrange
% 3.SpikePositions: nspikes x 1 double with spike poisiton spike indicies within the
% channelrange (in um)
% 4.SpikeAmplitude: nspikes x 1 double with just spike amplitudes indicies within the
% channelrange
% 5. SpikeCluster: nspikes x 1 double with just spike cluster ID's indicies within the
% channelrange
% 6. SpikeEvents: nspikes x 1 double with just event identity (integers)
% 7. BaselineWindowField: text field of app containing basline window range userinput as char in
% the field ChannelEditField.Value, like '-0.005,0' for channel -0.005s to 0s
% 8. ChannelSelectionField: text field of app containing channel range userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10
% 9. EventRangeEditField: text field of app containing event range userinput as char in
% the field EventRangeEditField.Value, like '1,10' for events 1 to 10
% 10. SpikeRateNumBinsEditField: text field of app containing basline num bins for spike rate userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


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
%%% TODO: Delete component, not used anymore!
[ChannelSelectionField] = Utility_SimpleCheckInputs(ChannelSelectionField,"Two",strcat('1,',num2str(size(Data.EventRelatedData,1))),1,0);

%% NrEvents to plot

if contains(EventRangeEditField,',')
    if ~contains(EventRangeEditField,'[') || ~contains(EventRangeEditField,']')
        EventRangeEditField = strcat('[',EventRangeEditField,']');
    end
end

[SpikeTriggeredAverageField] = Utility_SimpleCheckInputs(SpikeTriggeredAverageField,"Two",strcat('-0.005,0.2'),0,0);

%% Time Range Spike Triggered Average

commaindicie = find(SpikeTriggeredAverageField == ',');
PlotInfo.TimeWindowSpiketriggredLFP(1) = str2double(SpikeTriggeredAverageField(1:commaindicie(1)-1));
PlotInfo.TimeWindowSpiketriggredLFP(2) = str2double(SpikeTriggeredAverageField(commaindicie(1)+1:end));

%% Convert GUI inputs 
spaceindicie = strfind(Data.Info.EventRelatedDataTimeRange,' ');
PlotInfo.TimearoundEvent(1) = str2double(Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
PlotInfo.TimearoundEvent(2) = str2double(Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));

PlotInfo.EventNr = eval(EventRangeEditField);
PlotInfo.EventRange = eval(EventRangeEditField);

[PlotInfo.ChannelsToPlot] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainPlot');

PlotInfo.Time = -PlotInfo.TimearoundEvent(1):1/Data.Info.NativeSamplingRate:PlotInfo.TimearoundEvent(2);

PlotInfo.SpikeRateNumBins = str2double(SpikeRateNumBinsEditField);

%% Delete Data based on Channelselection
if strcmp(SpikeType,"Kilosort") || strcmp(SpikeType,"SpikeInterface")
    UinquePos = unique(Data.Spikes.ChannelPosition(:,1));

    if numel(UinquePos)>=2
        [TempSpikeTimes,TempSpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(Data.EventRelatedSpikes.SpikeTimes,Data.EventRelatedSpikes.DataCorrectedSpikePositions,Data.Info.ChannelSpacing,PlotInfo.ChannelsToPlot,"Kilosort",Data.Info.ProbeInfo.ActiveChannel);
    else
        [TempSpikeTimes,TempSpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(Data.EventRelatedSpikes.SpikeTimes,Data.EventRelatedSpikes.SpikePositions,Data.Info.ChannelSpacing,PlotInfo.ChannelsToPlot,"Kilosort",Data.Info.ProbeInfo.ActiveChannel);
    end
else
    [TempSpikeTimes,TempSpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(Data.EventRelatedSpikes.SpikeTimes,Data.EventRelatedSpikes.SpikePositions,Data.Info.ChannelSpacing,PlotInfo.ChannelsToPlot,"Internal",Data.Info.ProbeInfo.ActiveChannel);
end

if ~isempty(SelectedChannelIndicies)
    TempSpikeAmplitude = Data.EventRelatedSpikes.SpikeAmps(SelectedChannelIndicies==0);
    TempEvents = Data.EventRelatedSpikes.SpikeEvents(SelectedChannelIndicies==0);

    if strcmp(SpikeType,"Kilosort") || strcmp(SpikeType,"SpikeInterface")
        TempSpikeCluster = Data.EventRelatedSpikes.SpikeCluster(SelectedChannelIndicies==0);
        if min(Data.EventRelatedSpikes.SpikeCluster)==0 
            TempSpikeCluster = TempSpikeCluster+1;
        end
    else
         if strcmp(Data.Info.Sorter,'WaveClus')
            TempSpikeCluster = Data.EventRelatedSpikes.SpikeCluster(SelectedChannelIndicies==0);
            if min(Data.EventRelatedSpikes.SpikeCluster)==0 
                TempSpikeCluster = TempSpikeCluster+1;
            end
         else
            TempSpikeCluster = zeros(1,length(TempSpikePositions))';
         end
    end
else
    TempSpikeAmplitude = Data.EventRelatedSpikes.SpikeAmps;
    TempEvents = Data.EventRelatedSpikes.SpikeEvents;

    if strcmp(SpikeType,"Kilosort") || strcmp(SpikeType,"SpikeInterface")
        TempSpikeCluster = Data.EventRelatedSpikes.SpikeCluster;
        if min(Data.EventRelatedSpikes.SpikeCluster)==0 
            TempSpikeCluster = TempSpikeCluster+1;
        end
    else
         if strcmp(Data.Info.Sorter,'WaveClus')
            TempSpikeCluster = Data.EventRelatedSpikes.SpikeCluster;
            if min(Data.EventRelatedSpikes.SpikeCluster)==0 
                TempSpikeCluster = TempSpikeCluster+1;
            end
         else
            TempSpikeCluster = zeros(1,length(TempSpikePositions))';
         end
    end
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

if strcmp(SpikeType,"Internal")
    SpikePositions = (SpikePositions-1)*Data.Info.ChannelSpacing;
end

SpikeAmplitude = TempSpikeAmplitude(EventIndicies==1);
SpikeCluster = TempSpikeCluster(EventIndicies==1);
SpikeEvents = TempEvents(EventIndicies==1);

%% Convert Spike Times in seconds and normalize time to negative time event start
if SpikeTriggereAverage == 1 % For spike triggered average we need spike sample indicies, not time points in seconds
    SpikeTimes = (SpikeTimes/Data.Info.NativeSamplingRate);
else
    SpikeTimes = (SpikeTimes/Data.Info.NativeSamplingRate)-PlotInfo.TimearoundEvent(1);
end

%% Initialize Plot Info for heatmap
% Define bin sizes
numchannel = length(PlotInfo.ChannelsToPlot);

PlotInfo.depth_bin_size = SpikeBinSettings.depth_bin_size; %20; % Depth bin size
PlotInfo.time_bin_size = SpikeBinSettings.time_bin_size; % app.GeneralSettings.Time bin size in seconds

% Define bin edges
PlotInfo.depth_edges = 0:PlotInfo.depth_bin_size:numchannel*Data.Info.ChannelSpacing;
PlotInfo.time_edges = -PlotInfo.TimearoundEvent(1):PlotInfo.time_bin_size:PlotInfo.TimearoundEvent(2);

commaindicie = strfind(BaselineWindowField.Value,",");
PlotInfo.NormWindow(1) = str2double(BaselineWindowField.Value(1:commaindicie-1));
PlotInfo.NormWindow(2) = str2double(BaselineWindowField.Value(commaindicie+1:end));