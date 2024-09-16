function [Data,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField,CurrentPlotData] = Events_Internal_Spikes_Manage_Analysis_Plots(Data,EventRangeEditField,Figure,AnalysisTypeDropDown,SpikeRateNumBinsEditField,TextArea,rgbMatrix,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,BaselineNormalizeCheckBox,TimeWindowSpiketriggredLFPEditField,Figure2,Figure3,TwoORThreeD,ClustertoshowDropDown,numCluster,CurrentPlotData)

%% Bc of Spike triggered avg this has to be computed again (to get spike time stamps not normalized to event time)
if strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',1);
else
    [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',0);
end

if Error == 1
    return;
end

%% Prepare Plots
if strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Internal",1,TimeWindowSpiketriggredLFPEditField);
else
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Internal",0,TimeWindowSpiketriggredLFPEditField);
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

if strcmp(AnalysisTypeDropDown,"Spike Map")
    
    if ~strcmp(ClustertoshowDropDown,"All") && ~strcmp(ClustertoshowDropDown,"Non")
        CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,"Non",[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,CurrentPlotData);
    end
    
    CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,ClustertoshowDropDown,[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,CurrentPlotData);
    
    CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData);
    
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData);
    end

elseif strcmp(AnalysisTypeDropDown,"Spike Rate Heatmap")
    
    CurrentPlotData = Event_Spikes_Plot_Heatmap_Spike_Rate(SpikeTimes,SpikePositions,Figure,Data.Info.NativeSamplingRate,PlotInfo.time_bin_size,PlotInfo.depth_edges,PlotInfo.time_edges,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),0,BaselineNormalizeCheckBox,PlotInfo.NormWindow,ClustertoshowDropDown,SpikeCluster,rgbMatrix,PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,"Kilosort",TwoORThreeD,CurrentPlotData);
    
    CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData);
    
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData);
    end

elseif strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    
    [TempData,~,CurrentPlotData] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelsToPlot,"Events",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD,ClustertoshowDropDown,CurrentPlotData);
    
    % Spike Rate -- extract events again with last input being 0
     [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',0);

    if Error == 1
        return;
    end

    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Internal",0,TimeWindowSpiketriggredLFPEditField);
    
    CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),"Non",SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData);

    if isempty(TempData) % if not preprocessed
        Data = [];
    else
        Data = TempData; % if preprocessed
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