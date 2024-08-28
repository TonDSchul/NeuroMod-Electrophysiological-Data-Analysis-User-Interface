function [Data,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Events_Kilosort_Spikes_Manage_Analysis_Plots(Data,EventRangeEditField,Figure,AnalysisTypeDropDown,SpikeRateNumBinsEditField,TextArea,rgbMatrix,numCluster,ClustertoshowDropDown,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,BaselineNormalizeCheckBox,TimeWindowSpiketriggredLFPEditField,Figure2,Figure3,TwoORThreeD)

%% Bc of Spike triggered avg this has to be computed again (to get spike time stamps not normalized to event time)

if strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',1);
else
    [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',0);
end

if Error == 1
    return;
end

%% Prepare Plots
if strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Kilosort",1,TimeWindowSpiketriggredLFPEditField);
else
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Kilosort",0,TimeWindowSpiketriggredLFPEditField);
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

if strcmp(AnalysisTypeDropDown,"Spike Map")
    if ~strcmp(ClustertoshowDropDown,"All") && ~strcmp(ClustertoshowDropDown,"Non")
        Spikes_Plot_Spike_Times("Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,"Non",[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing)
    end
    Spikes_Plot_Spike_Times("Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,ClustertoshowDropDown,[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing)
    Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
    end
elseif strcmp(AnalysisTypeDropDown,"Spike Rate Heatmap")
    Event_Spikes_Plot_Heatmap_Spike_Rate(SpikeTimes,SpikePositions,Figure,Data.Info.NativeSamplingRate,PlotInfo.time_bin_size,PlotInfo.depth_edges,PlotInfo.time_edges,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),0,BaselineNormalizeCheckBox,PlotInfo.NormWindow,ClustertoshowDropDown,SpikeCluster,rgbMatrix,PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,"Kilosort",TwoORThreeD)
    Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
    end
elseif strcmp(AnalysisTypeDropDown,"Spike Triggered Average")
    
    [TempData,~] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelsToPlot,"Kilosort",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD);
    
    %% No again normalized to event time for spike rate

    [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',0);
   
    if Error == 1
        return;
    end
    
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Kilosort",0,TimeWindowSpiketriggredLFPEditField);

    Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)

    %% Prepare Plots
    [PlotInfo,SpikeTimes,SpikePositions,~,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Kilosort",0,TimeWindowSpiketriggredLFPEditField);

    Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),"Non",SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot);
    
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
    end

    if isempty(TempData) % if not preprocessed
       Data = [];
    else
        Data = TempData; % if preprocessed
    end

elseif strcmp(AnalysisTypeDropDown,"ISI")
    % some Spikeindicies are ngative to account for event time. This has to
    % be undone
    TempSpikeTimes = SpikeTimes + PlotInfo.TimearoundEvent(1);

    %%!!! ISI has top be done per Trial and Channel!!! Otherwise there will be
    %%artefacts from the time difference of the end of channel 1 to the start of channel 2 or
    %%event 1 to 2

    ISI = [];

    for nevent = 1:length(PlotInfo.EventRange)
        SpikesIndicies = SpikeEvents == nevent;
        TempEventSpikeTimes = TempSpikeTimes(SpikesIndicies==1);

        ISI = [ISI;abs(diff(sort(TempEventSpikeTimes)))];
    end

    bins = 0:0.003:0.5;  % Define 1 ms bins.

    set(Figure, 'YDir', 'normal');
    % Get the counts for each bin using histcounts
    [Counts, ~] = histcounts(ISI, bins);
    ISIProbability = Counts./length(ISI);

    bar(Figure,ISIProbability,'FaceColor','r', 'EdgeColor', 'k')
    title(Figure,'ISI Probability Distribution All Channel Together', 'FontSize', 14);
    xlim(Figure,[0 length(Counts)]);
    ylim(Figure,[0 max(ISIProbability,[],'all')]);
    
    title(Figure,'ISI Probability Distribution', 'FontSize', 14);

    %% No again normalized to event time for spike rate

    [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Kilosort',0);
   
    if Error == 1
        return;
    end

    %% Prepare Plots
    [PlotInfo,SpikeTimes,SpikePositions,~,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Kilosort",0,TimeWindowSpiketriggredLFPEditField);

    Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),"Non",SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot);
    
    if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
        Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)
    end
end  