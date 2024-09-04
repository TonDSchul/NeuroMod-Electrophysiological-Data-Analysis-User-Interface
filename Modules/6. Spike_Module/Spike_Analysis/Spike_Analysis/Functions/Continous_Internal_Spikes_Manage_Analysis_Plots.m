function [Data] = Continous_Internal_Spikes_Manage_Analysis_Plots(TypeofAnalysis,Data,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,PlotInfo,TextArea,ChannelPosition,Figure,Figure2,Figure3,RGBMatrix,TwoORThreeD)

%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for continous internal spikes based on user input
% This function uses a functions from the spike repository from Nick
% Steinmetz on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some continous internal spikes analysis has to be done and plotted

% Inputs:
% 1. TypeofAnalysis: string, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR Channel Waveforms OR
% "Average Waveforms Across Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 2. Data: main window data structure with time vector (Data.Time) and Info
% field
% 3. SpikeTimes nspikes x 1 double with spike times in seconsd of each spike
% 4. SpikePositions = N x 1 double or single with spike poisiton (integer specifying channel) of each spike
% (analyzed in internal spike detection) 
% 5. CluterPositions = N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: for internal spikes, no
% units get analyse. Therefore this vector has to be made up of just 1 
% 6. SpikeAmps = N x 1 double or single with amplitudes of each spike
% (analyzed in internal spike detection) to get biggest amplitude
% 7. PlotInfo: structure containing user selected parameter for analysis.
% fields: PlotInfo.Plotevents, PlotInfo.PlotInfo.SpikeRateNumBins,
% PlotInfo.PlotInfo.ChannelSelection all as double, comes from
% Continous_Spikes_Prepare_Plots function
% 8. TextArea: object of app window to show info text in
% 9. ChannelPosition: nchannel x 2 capturing x and y values of each channel
% in um -- since only linear probes are supported, :,1 are all 0, just :,2
% contains values
% 10. Figure: figure axes handle to plot spike times with amplitude
% colorscaling
% 11. Figure2: figure axes handle for spike rate over time 
% 12. Figure3: figure axes handle for spike rate over channel 
% 13. RGBMatrix: nwaveforms x 3 double with rgb values for each waveform
% plotted


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if isstring(SpikeTimes)
    msgbox("No Spikes found with selected Parameter. Nothing is plotted.")
    return;
end

if strcmp(TypeofAnalysis,"Spike Map")
    set(Figure,'xticklabel',{[]});
end

if strcmp(TypeofAnalysis,"Spike Map")
    set(Figure, 'YDir','reverse');
    Spikes_Plot_Spike_Times("Continous",RGBMatrix,Data.Time,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,ChannelPosition,Figure,1,'Non',PlotInfo.Plotevents,PlotInfo.EventData,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing)
    Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,Figure2,Figure3,"Initial",RGBMatrix,'Non',PlotInfo.SpikeRateNumBins,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing) 
end

if strcmp(TypeofAnalysis,"SpikeRateBinSizeChange")
    if length(find(mod(SpikeTimes(:), 1) == 0)) == length(SpikePositions)
        SpikeTimes = SpikeTimes/Data.Info.NativeSamplingRate;
    end
    Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,Figure2,Figure3,"Initial",RGBMatrix,'Non',PlotInfo.SpikeRateNumBins,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing) 
end

if strcmp(TypeofAnalysis,"Channel Waveforms")
    
    if ~isfield(Data.Info,'DownsampleFactor')
        DownsampleFactor = 0;
    else
        DownsampleFactor = 1;
    end

  
end

if strcmp(TypeofAnalysis,"Average Waveforms Across Channel")

    if ~isfield(Data.Info,'DownsampleFactor')
        DownsampleFactor = 0;
    else
        DownsampleFactor = 1;
    end
    
    % if unitselected und cluster da
    %     Clustertoshow = Data.Spikes.SpikeCluster == SelectedCluster;
    %     WaveForms = 
    % else

    % end

    %% calculate mean waveform
    WaveformRange = PlotInfo.Waveforms(1):PlotInfo.Waveforms(2);
    
    Plotdata = squeeze(Data.Spikes.Waveforms(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),WaveformRange,:));

    if ndims(Plotdata)==2
        if size(Plotdata,1) ~= 1
            if length(WaveformRange)>1
                MeanWave = squeeze(mean(Plotdata,1,'omitnan'));
            else
                MeanWave = Plotdata';
            end
        else
            MeanWave = Plotdata;
        end
    elseif ndims(Plotdata)==3
        if PlotInfo.ChannelSelection(1)~=PlotInfo.ChannelSelection(2)
            if size(Plotdata,2)>1
                MeanWave = squeeze(mean(Plotdata,2,'omitnan'));
            else
                MeanWave = squeeze(Plotdata)';
            end
        else
            if size(Plotdata,2)>1
                MeanWave = squeeze(mean(Plotdata,1,'omitnan'));
            else
                MeanWave = squeeze(Plotdata)';
            end
        end
    end

    Meanwaveform = NaN(1,size(MeanWave,1),size(MeanWave,2));
    Meanwaveform(1,:,:) = MeanWave;

    Continous_Spikes_Plot_Average_Waveforms(Figure,Data,PlotInfo.ChannelSelection,1,Meanwaveform,Data.Info.ChannelSpacing,"Internal",PlotInfo.Waveforms,TwoORThreeD);
end

%% basic quantification of spiking plot
if strcmp(TypeofAnalysis,"Spike Amplitude Density Along Depth")

    set(Figure, 'YDir', 'reverse');
    
    ChannelRange = PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2);
    %% basic quantification of spiking plot
    depthBins = 0:length(ChannelRange)*Data.Info.ChannelSpacing/150:length(ChannelRange)*Data.Info.ChannelSpacing;
    ampBins = 0:max(SpikeAmps)/100:max(SpikeAmps);
    recordingDur = Data.Time(end);
    
    % bc the first bin checked is zero and first channeldepth is zero,
    % but values have to be bigger than zero --> channel one not shown -->
    % add a little artificial depth of 0.5 um
    SpikePositions = SpikePositions+0.5;
    [pdfs, cdfs] = computeWFampsOverDepth(SpikeAmps, SpikePositions, ampBins, depthBins, recordingDur);
    plotWFampCDFs(pdfs, cdfs, ampBins, depthBins, "PDF", Figure,ChannelPosition(length(ChannelRange),2),Data.Info.ChannelSpacing,"Internal",TwoORThreeD);
end

if strcmp(TypeofAnalysis,"Cumulative Spike Amplitude Density Along Depth")
    set(Figure, 'YDir', 'reverse');
    
    ChannelRange = PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2);
    %% basic quantification of spiking plot
    depthBins = 0:length(ChannelRange)*Data.Info.ChannelSpacing/150:length(ChannelRange)*Data.Info.ChannelSpacing;
    ampBins = 0:max(SpikeAmps)/100:max(SpikeAmps);
    recordingDur = Data.Time(end);
    % bc the first bin checked is zero and first channeldepth is zero,
    % but values have to be bigger than zero --> channel one not shown -->
    % add a little artificial depth of 0.5 um
    SpikePositions = SpikePositions+0.5;
    [pdfs, cdfs] = computeWFampsOverDepth(SpikeAmps, SpikePositions, ampBins, depthBins, recordingDur);
    plotWFampCDFs(pdfs, cdfs, ampBins, depthBins, "CDF", Figure,ChannelPosition(length(ChannelRange),2),Data.Info.ChannelSpacing,"Internal",TwoORThreeD);
                    
end

if strcmp(TypeofAnalysis,"Spike Triggered LFP")

    [TempData] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelSelection,"Kilosort",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD);
    
    if isempty(TempData) % if not preprocessed
        Data = [];
    else
        Data = TempData; % if preprocessed
    end

    texttoshow = ["Number of Spikes found: ";num2str(length(SpikeTimes))];

    TextArea.Value = texttoshow;
end
