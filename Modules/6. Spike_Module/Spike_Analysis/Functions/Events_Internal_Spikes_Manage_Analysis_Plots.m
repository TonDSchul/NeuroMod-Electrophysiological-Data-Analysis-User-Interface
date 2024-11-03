function [TempData,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField,CurrentPlotData] = Events_Internal_Spikes_Manage_Analysis_Plots(Data,EventRangeEditField,Figure,AnalysisTypeDropDown,SpikeRateNumBinsEditField,TextArea,rgbMatrix,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,BaselineNormalizeCheckBox,TimeWindowSpiketriggredLFPEditField,Figure2,Figure3,TwoORThreeD,ClustertoshowDropDown,numCluster,CurrentPlotData,SpikeBinSettings,PlotAppearance,ActiveChannel)

%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for event internal spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some event internal spikes analysis has to be done and plotted

% Inputs:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field
% 2. EventRangeEditField: user input for events to show, char 'from, to',
% i.e. '1,10' for events 1 to 10;
% 3. Figure: figure object handle to main plot in the middle of the window
% 4. AnalysisTypeDropDown: string, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR Channel Waveforms OR
% "Average Waveforms Across Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 5. SpikeRateNumBinsEditField: user input for number of bins of spike rate plots, char,
% i.e. '100' for 100 bins
% 6. TextArea: internal event spike app window textarea to show number of
% spikes and cluster
% 7. rgbMatrix: nwavefors x 3 matrix, with RGB values for each waveform/template to
% be plotted to ensure consistency of colors
% 8. ChannelSelectionforPlottingEditField: user input for cahnnel to show, char 'from, to',
% i.e. '1,10' for channel 1 to 10;
% 9. BaselineWindowStartStopinsEditField: user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.2,0' for -200ms to 0ms timw window as baseline
% 10. BaselineNormalizeCheckBox: check box whether baseline normalization should be applied. BaselineNormalizeCheckBox.Value is either
% 1 if checked or 0 if not
% 11. TimeWindowSpiketriggredLFPEditField:  user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.05,0.2' for -5ms to 200ms timw window as baseline
% 12. Figure2: figure object handle to plot spike rate over time 
% 13. Figure3: figure object handle to plot spike rate over time 
% 14. TwoORThreeDchar: either "TwoD" or "ThreeD" for 2d or 3d plot
% 15. numCluster: double, number of different units/cluster found in spike
% sorting
% 16. ClustertoShowDropDown: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 17. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. Data: main app data structure 
% 2. ChannelSelectionforPlottingEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 3. EventRangeEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 4. SpikeRateNumBinsEditField: same as input to show auto
% changes if they were made (i.e. more channel selected than available)
% 5. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Bc of Spike triggered avg this has to be computed again (to get spike time stamps not normalized to event time)
TempData = [];

%% Prepare Plots
if strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Internal",1,TimeWindowSpiketriggredLFPEditField,SpikeBinSettings,ActiveChannel);
else
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Internal",0,TimeWindowSpiketriggredLFPEditField,SpikeBinSettings,ActiveChannel);
end

% Check for errros
if strcmp(AnalysisTypeDropDown,"Spike Rate Heatmap") && PlotInfo.ChannelsToPlot(1) == PlotInfo.ChannelsToPlot(2)
    msgbox("Error: at least two channel necessary!")
    return;
end

% Check for errros
if strcmp(AnalysisTypeDropDown,"Spike Triggered Average") && PlotInfo.ChannelsToPlot(1) == PlotInfo.ChannelsToPlot(2)
    msgbox("Error: at least two channel necessary!")
    return;
end

if min(SpikeCluster)==0
    SpikeCluster = SpikeCluster+1;
end

% Convert in um

SpikePositions = (SpikePositions-1)*Data.Info.ChannelSpacing;

if strcmp(AnalysisTypeDropDown,"Spike Map")
    
    if ~strcmp(ClustertoshowDropDown,"All") && ~strcmp(ClustertoshowDropDown,"Non")
        CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,"Non",[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    end
    
    CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,ClustertoshowDropDown,[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    
    CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance);
    
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance);
    end

elseif strcmp(AnalysisTypeDropDown,"Spike Rate Heatmap")
    
    CurrentPlotData = Event_Spikes_Plot_Heatmap_Spike_Rate(SpikeTimes,SpikePositions,Figure,Data.Info.NativeSamplingRate,PlotInfo.time_bin_size,PlotInfo.depth_edges,PlotInfo.time_edges,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),0,BaselineNormalizeCheckBox,PlotInfo.NormWindow,ClustertoshowDropDown,SpikeCluster,rgbMatrix,PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,"Kilosort",TwoORThreeD,CurrentPlotData,PlotAppearance);
    
    CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance);
    
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance);
    end

elseif strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    
    if ~strcmp(ClustertoshowDropDown,"All") && ~strcmp(ClustertoshowDropDown,"Non")
        ClustertoShowIndicie = str2double(ClustertoshowDropDown);
        SpikesinCluster = SpikeCluster == ClustertoShowIndicie;
        SpikeTimes = SpikeTimes(SpikesinCluster==1);
        SpikePositions = SpikePositions(SpikesinCluster==1);
    end
    
    [TempData,~,CurrentPlotData] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelsToPlot,"Events",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD,ClustertoshowDropDown,CurrentPlotData,PlotAppearance);
    
    % Spike Rate -- extract events again with last input being 0
    [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',0);

    if Error == 1
        return;
    end

    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Internal",0,TimeWindowSpiketriggredLFPEditField,SpikeBinSettings,ActiveChannel);
    
    SpikePositions = (SpikePositions-1)*Data.Info.ChannelSpacing;

    CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),"Non",SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance);
    
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance);
    end

elseif strcmp(AnalysisTypeDropDown,"Spike Field Coherence")

    % [~,mLFP] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelsToPlot,"Internal",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,0);
    % 
    % N = length(SpikeTimes);
    % % Initialize variables to store spectra
    % SYY = zeros(N/2+1, 1);   % Field spectrum
    % SNN = zeros(N/2+1, 1);   % Spike spectrum
    % SYN = zeros(N/2+1, 1);   % Cross spectrum, initialized as complex
    % 
    % % Loop over each trial
    % for nevents = 1:length(PlotInfo.EventRange)
    %     % Hanning taper the field and compute its FFT
    %     yf = fft((mLFP(nevents,:) - mean(mLFP(nevents,:))) .* hanning(N));
    % 
    %     % Compute FFT of the spikes (without tapering)
    %     nf = fft(n(nevents,:) - mean(n(nevents,:)));
    % 
    %     % Accumulate the spectra over trials
    %     SYY = SYY + real(yf(1:N/2+1) .* conj(yf(1:N/2+1))) / K;
    %     SNN = SNN + real(nf(1:N/2+1) .* conj(nf(1:N/2+1))) / K;
    %     SYN = SYN + (yf(1:N/2+1) .* conj(nf(1:N/2+1))) / K;
    % end
    % 
    % % Compute coherence
    % cohr = abs(SYN) ./ sqrt(SYY) ./ sqrt(SNN);
    % 
    % % Frequency axis for plotting
    % f = (0:N/2) / (N * dt);
end