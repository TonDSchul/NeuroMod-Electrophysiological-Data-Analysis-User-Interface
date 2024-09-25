function [Data,CurrentPlotData] = Continous_Kilosort_Spikes_Manage_Analysis_Plots(Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,Waveforms,WaveformChannel,CluterPositions,Figure,TypeofAnalysis,TextArea,Eventstoshow,rgbMatrix,numCluster,ClusterToShow,Figure2,Figure3,TwoORThreeD,CurrentPlotData,PlotAppearance)

%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for continous internal spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some continous kilosort spikes analysis has to be done and plotted

% Inputs:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field
% 2. PlotInfo: structure containing user selected parameter for analysis.
% fields: PlotInfo.Ploteve nts, PlotInfo.PlotInfo.SpikeRateNumBins,
% PlotInfo.PlotInfo.ChannelSelection all as double, comes from
% Continous_Spikes_Prepare_Plots function
% 3. SpikePositions = N x 1 double or single with spike poisiton (integer specifying channel) of each spike
% (analyzed in internal spike detection) 
% 4. SpikeAmps = N x 1 double or single with amplitudes of each spike
% (analyzed in internal spike detection) to get biggest amplitude
% 5. SpikeTimes nspikes x 1 double with indcies of each spike
% 6. CluterPositions = N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) NOTE: for internal spikes, no
% units get analyse. Therefore this vector has to be made up of just 1 
% 7. Figure: figure axes handle to plot spike times with amplitude
% colorscaling
% 8. TypeofAnalysis: string, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR "Waveforms from Raw Data" OR
% "Average Waveforms Across Channel" OR "Waveforms Templates" OR "Template from Max Amplitude Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 9: TextArea: object to app window text area showing number of spikes and
% cluster
% 10: Eventstoshow -- currently not used -- would be char of event channel
% name
% 11. rgbMatrix: nwaveforms x 3 double with rgb values for each waveform
% plotted
% 12. numCluster: double, number of individual untis/cluster
% 13. ClusterToShow: either single double number or chars 'All' OR 'Non'
% 14. Figure2: figure axes handle for spike rate over time 
% 15. Figure3: figure axes handle for spike rate over channel 
% 16. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 17. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Output:
% 1. Data: main window data structure with time vector (Data.Time) and Info
% field
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% When an error occured before plotting, spike times will be a string
% saying "Error"
if isstring(SpikeTimes)
    msgbox("No Spikes found with selected Parameter. Nothing is plotted.")
    return;
end

if min(CluterPositions)==0
    CluterPositions = CluterPositions+1;
end

if strcmp(TypeofAnalysis,"Spike Map")
    set(Figure, 'YDir','reverse');

    if ~strcmp(ClusterToShow,"All") && ~strcmp(ClusterToShow,"Non")
        CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Continous",rgbMatrix,Data.Time,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,Data.Spikes.ChannelPosition,Figure,numCluster,"Non",PlotInfo.Plotevents,PlotInfo.EventData,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    end

    CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Continous",rgbMatrix,Data.Time,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,Data.Spikes.ChannelPosition,Figure,numCluster,ClusterToShow,PlotInfo.Plotevents,PlotInfo.EventData,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    CurrentPlotData = Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,Figure2,Figure3,"Initial",rgbMatrix,ClusterToShow,PlotInfo.SpikeRateNumBins,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
end

if strcmp(TypeofAnalysis,"SpikeRateBinSizeChange")
    % Check whether Spike Times are indicies or time points. Convert into
    % time points
    if length(find(mod(SpikeTimes(:), 1) == 0)) == length(SpikePositions)
        SpikeTimes = SpikeTimes/Data.Info.NativeSamplingRate;
    end
    CurrentPlotData = Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,Figure2,Figure3,"Initial",rgbMatrix,ClusterToShow,PlotInfo.SpikeRateNumBins,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
end

if strcmp(TypeofAnalysis,"Average Waveforms Across Channel")
    % Select Cluster spike infos
    if ~isnan(PlotInfo.Units)
        ClustertoShow = PlotInfo.Units;
        WavesinCluster = CluterPositions == ClustertoShow;
        ClusterWaveforms = Waveforms(:,WavesinCluster==1,:);
    else
        ClusterWaveforms = Waveforms;
    end
    
    % Find n number of biggest waveforms
    % Prepare: Waveforms in 3d matrix (nchannel,nwaves,ntime) for spike
    % waveform over depth plots. Here we need the spike waveform of the
    % channel the spike was detected in.
    NumWaveForms = length(PlotInfo.Waveforms(1):PlotInfo.Waveforms(2));
    Waveformstoplot = NaN(size(ClusterWaveforms,2),size(ClusterWaveforms,3));
    
    %% Get max waveforms 
    for nwaves = 1:size(ClusterWaveforms,2)
        ChannelSelection = double(Data.Spikes.SpikeChannel(nwaves));
        Waveformstoplot(nwaves,:) = squeeze(ClusterWaveforms(ChannelSelection,nwaves,:));       
    end

    [MaxValue,~] = max(Waveformstoplot,[],2);
    [~,MaxIndex] = maxk(MaxValue,NumWaveForms);
    
    if isempty(MaxIndex)
        msgbox("No Spikes found for selected parameter!");
        return;
    end
    
    WaveFormSelection = ClusterWaveforms(:,MaxIndex,:);
    
    MeanWaveForm = NaN(1,size(WaveFormSelection,1),size(WaveFormSelection,3));
    
    % If only one wave, dimensions change
    if size(WaveFormSelection,2)>1
        MeanWaveForm(1,:,:) = squeeze(mean(WaveFormSelection,2));
    else
        MeanWaveForm(1,:,:) = squeeze(WaveFormSelection);
    end
   
    %% Just Some Channel Selected
    MeanWaveForm = MeanWaveForm(1,PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:);
    
    CurrentPlotData = Continous_Spikes_Plot_Average_Waveforms(Figure,Data,PlotInfo.ChannelSelection,PlotInfo.Units(1),MeanWaveForm,Data.Info.ChannelSpacing,"Kilosort",PlotInfo.Waveforms,TwoORThreeD,CurrentPlotData);
end

if strcmp(TypeofAnalysis,"Waveforms from Raw Data")
    CurrentPlotData = Continous_Spikes_Plot_Waveforms(Data,SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,PlotInfo,ClusterToShow,Figure,CurrentPlotData);
end

if strcmp(TypeofAnalysis,"Waveforms Templates")
    if ~strcmp(ClusterToShow,"All") && ~strcmp(ClusterToShow,"Non")
        CurrentPlotData = Continous_Kilosort_Spikes_Plot_Spike_Templates(Figure,Data,PlotInfo.ChannelSelection,PlotInfo.Units,rgbMatrix,CurrentPlotData);
    end
end

if strcmp(TypeofAnalysis,"Spike Amplitude Density Along Depth")
    
    if ~strcmp(ClusterToShow,"All") && ~strcmp(ClusterToShow,"Non")
        % Select Units
        ClusterToPlot = CluterPositions==PlotInfo.Units;
        SpikeAmps = SpikeAmps(ClusterToPlot==1);
        SpikePositions = SpikePositions(ClusterToPlot==1);
    end

    set(Figure, 'YDir', 'reverse');

    ChannelRange = PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2);

    %% basic quantification of spiking plot
    depthBins = 0:length(ChannelRange)*Data.Info.ChannelSpacing/150:(length(ChannelRange))*Data.Info.ChannelSpacing;
    ampBins = 0:max(SpikeAmps)/100:max(SpikeAmps);
    recordingDur = Data.Time(end);

    %SpikePositions = SpikePositions-Data.Info.ChannelSpacing;

    [pdfs, cdfs] = computeWFampsOverDepth(SpikeAmps, SpikePositions, ampBins, depthBins, recordingDur);
    plotWFampCDFs(pdfs, cdfs, ampBins, depthBins, "PDF", Figure,Data.Spikes.ChannelPosition(length(ChannelRange),2),Data.Info.ChannelSpacing,"Kilosort",TwoORThreeD,ClusterToShow);
   
    depthX = depthBins(1:end-1)+mean(diff(depthBins))/2;
    ampX = ampBins(1:end-1)+mean(diff(ampBins))/2;
    CurrentPlotData.MainXData = ampX;
    CurrentPlotData.MainYData = depthX;
    CurrentPlotData.MainCData = pdfs;
    CurrentPlotData.MainType = strcat("Continous Kilosort Spikes: Spike Amplitude Density Along Depth");
    CurrentPlotData.MainXTicks = Figure.XTickLabel;
end

if strcmp(TypeofAnalysis,"Cumulative Spike Amplitude Density Along Depth")

    if ~strcmp(ClusterToShow,"All") && ~strcmp(ClusterToShow,"Non")
        % Select Units
        ClusterToPlot = CluterPositions==PlotInfo.Units;
        SpikeAmps = SpikeAmps(ClusterToPlot==1);
        SpikePositions = SpikePositions(ClusterToPlot==1);
    end
    
    set(Figure, 'YDir', 'reverse');
    
    %% basic quantification of spiking plot
    ChannelRange = PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2);
    depthBins = 0:length(ChannelRange)*Data.Info.ChannelSpacing/150:(length(ChannelRange))*Data.Info.ChannelSpacing;
    ampBins = 0:max(SpikeAmps)/100:max(SpikeAmps);
    recordingDur = Data.Time(end);

    %SpikePositions = SpikePositions-Data.Info.ChannelSpacing;

    [pdfs, cdfs] = computeWFampsOverDepth(SpikeAmps, SpikePositions, ampBins, depthBins, recordingDur);
    plotWFampCDFs(pdfs, cdfs, ampBins, depthBins, "CDF", Figure,Data.Spikes.ChannelPosition(length(ChannelRange),2),Data.Info.ChannelSpacing,"Kilosort",TwoORThreeD,ClusterToShow);
                    
    depthX = depthBins(1:end-1)+mean(diff(depthBins))/2;
    ampX = ampBins(1:end-1)+mean(diff(ampBins))/2;
    CurrentPlotData.MainXData = ampX;
    CurrentPlotData.MainYData = depthX;
    CurrentPlotData.MainCData = cdfs;
    CurrentPlotData.MainType = strcat("Continous Kilosort Spikes: Cumulative Spike Amplitude Density Along Depth");
    CurrentPlotData.MainXTicks = Figure.XTickLabel;
end

if strcmp(TypeofAnalysis,"Template from Max Amplitude Channel")
    CurrentPlotData = Continous_Kilosort_Spikes_Plot_Biggest_Amplitude_Spike(Figure,Data,PlotInfo.Units,rgbMatrix,CurrentPlotData);
end

if strcmp(TypeofAnalysis,"Spike Triggered LFP")

    if ~isnan(PlotInfo.Units)
        ClustertoShowIndicie = PlotInfo.Units;
        SpikesinCluster = CluterPositions == ClustertoShowIndicie;
        SpikeTimes = SpikeTimes(SpikesinCluster==1);
        SpikePositions = SpikePositions(SpikesinCluster==1);
    end

    [TempData,~,CurrentPlotData] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelSelection,"Continous",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD,ClusterToShow,CurrentPlotData,PlotAppearance);
    
    if isempty(TempData) % if not preprocessed
        Data = [];
    else
        Data = TempData; % if preprocessed
    end

    texttoshow = [strcat("Number of Spikes: ",num2str(length(SpikeTimes)));...
    strcat("Number of Cluster: ",num2str(length(unique(CluterPositions))))];
    
    TextArea.Value = texttoshow;
end             
