function [Data,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Events_Internal_Spikes_Manage_Analysis_Plots(Data,EventRangeEditField,Figure,AnalysisTypeDropDown,SpikeRateNumBinsEditField,TextArea,rgbMatrix,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,BaselineNormalizeCheckBox,TimeWindowSpiketriggredLFPEditField,Figure2,Figure3,TwoORThreeD,ClustertoshowDropDown,numCluster)

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
    
    [TempData,~] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelsToPlot,"Internal",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD);
    
    % Spike Rate -- extract events again with last input being 0
     [Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(Data,'Internal',0);

    if Error == 1
        return;
    end

    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,"Internal",0,TimeWindowSpiketriggredLFPEditField);
    
    Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"BinsizeChangeInitial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr(1):PlotInfo.EventNr(2)),"Non",SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot)

    if isempty(TempData) % if not preprocessed
        Data = [];
    else
        Data = TempData; % if preprocessed
    end
    
elseif strcmp(AnalysisTypeDropDown,"ISI (All Channel together)") || strcmp(AnalysisTypeDropDown,"ISI (Over Channel)")
    
    % some Spikeindicies are ngative to account for event time. This has to
    % be undone
    TempSpikeTimes = SpikeTimes + PlotInfo.TimearoundEvent(1);

    %%!!! ISI has top be done per Trial and Channel!!! Otherwise there will be
    %%artefacts from the time difference of the end of channel 1 to the start of channel 2 or
    %%event 1 to 2
    if strcmp(AnalysisTypeDropDown,"ISI (All Channel together)")
        ISI = [];
    elseif strcmp(AnalysisTypeDropDown,"ISI (Over Channel)")
        ISI = cell(1,PlotInfo.ChannelNr);
    end

    for nchannel = 1:PlotInfo.ChannelNr
        for nevent = 1:length(PlotInfo.EventRange)
            SpikesIndicies = SpikeEvents == nevent;
            SpikesIndicies = SpikesIndicies + SpikePositions == (nchannel*Data.Info.ChannelSpacing);
            SpikesIndicies(SpikesIndicies>1) = 1;
            TempEventSpikeTimes=TempSpikeTimes(SpikesIndicies==1);

            if strcmp(AnalysisTypeDropDown,"ISI (All Channel together)")
                ISI = [ISI;abs(diff(sort(TempEventSpikeTimes)))];
            elseif strcmp(AnalysisTypeDropDown,"ISI (Over Channel)")
                ISI{nchannel} = [ISI{nchannel};abs(diff(sort(TempEventSpikeTimes)))];
            end
        end
    end

    bins = 0:0.003:0.5;  % Define 1 ms bins.
    if strcmp(AnalysisTypeDropDown,"ISI (All Channel together)")
        set(Figure, 'YDir', 'normal');
        % Get the counts for each bin using histcounts
        [Counts, ~] = histcounts(ISI, bins);
        ISIProbability = Counts./length(ISI);
    elseif strcmp(AnalysisTypeDropDown,"ISI (Over Channel)")
        set(Figure, 'YDir', 'reverse');
        Counts = zeros(nchannel,length(bins)-1);
        ISIProbability = zeros(nchannel,length(bins)-1);
        for nchannel = 1:length(ISI)
            % Get the counts for each bin using histcounts
            [Counts(nchannel,:), ~] = histcounts(ISI{nchannel}, bins);
            ISIProbability(nchannel,:) = Counts(nchannel,:)./length(ISI{nchannel});
        end
    end

    if strcmp(AnalysisTypeDropDown,"ISI (All Channel together)")
        bar(Figure,ISIProbability,'FaceColor','r', 'EdgeColor', 'k')
        title(Figure,'ISI Probability Distribution All Channel Together', 'FontSize', 14);
        xlim(Figure,[0 length(Counts)]);
        ylim(Figure,[0 max(ISIProbability)]);

    elseif strcmp(AnalysisTypeDropDown,"ISI (Over Channel)")
        surf(Figure,ISIProbability)
        imagesc(Figure,ISIProbability)

        imagesc(Figure,bins,0:0.01:1,ISIProbability);
        title(Figure,'ISI Probability Distribution All Channel Together', 'FontSize', 14);
        xlim(Figure,[bins(1) bins(end)]);
        ylim(Figure,[0 max(ISIProbability,[],'all')]);
    end

    title(Figure,'ISI Probability Distribution', 'FontSize', 14);

elseif strcmp(AnalysisTypeDropDown,"Spike Field Coherence")

    [~,mLFP] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelsToPlot,"Internal",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,0);

    N = length(SpikeTimes);
    % Initialize variables to store spectra
    SYY = zeros(N/2+1, 1);   % Field spectrum
    SNN = zeros(N/2+1, 1);   % Spike spectrum
    SYN = zeros(N/2+1, 1);   % Cross spectrum, initialized as complex
    
    % Loop over each trial
    for nevents = 1:length(PlotInfo.EventRange)
        % Hanning taper the field and compute its FFT
        yf = fft((mLFP(nevents,:) - mean(mLFP(nevents,:))) .* hanning(N));
        
        % Compute FFT of the spikes (without tapering)
        nf = fft(n(nevents,:) - mean(n(nevents,:)));
        
        % Accumulate the spectra over trials
        SYY = SYY + real(yf(1:N/2+1) .* conj(yf(1:N/2+1))) / K;
        SNN = SNN + real(nf(1:N/2+1) .* conj(nf(1:N/2+1))) / K;
        SYN = SYN + (yf(1:N/2+1) .* conj(nf(1:N/2+1))) / K;
    end
    
    % Compute coherence
    cohr = abs(SYN) ./ sqrt(SYY) ./ sqrt(SNN);
    
    % Frequency axis for plotting
    f = (0:N/2) / (N * dt);
end