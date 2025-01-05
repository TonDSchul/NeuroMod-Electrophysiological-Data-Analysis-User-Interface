function [Data,CurrentPlotData] = Continous_Internal_Spikes_Manage_Analysis_Plots(TypeofAnalysis,Data,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,Waveforms,PlotInfo,TextArea,ChannelPosition,Figure,Figure2,Figure3,RGBMatrix,TwoORThreeD,ClustertoShowDropDown,CurrentPlotData,PlotAppearance)

%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for continous internal spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
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
% 14. TwoORThreeD: char, either "TwoD" or "ThreeD" for 2d or 3d plot
% 15. ClustertoShowDropDown: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 16. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Prepare all
% Check basic requirements of spikes being within channelselection

if isstring(SpikeTimes)
    msgbox("No Spikes found with selected Parameter. Nothing is plotted.")
    return;
end

if ~isnan(PlotInfo.Units)
    if sum(CluterPositions== PlotInfo.Units)<2
        msgbox("No Spikes found for selected parameter and channel! Nothing is plotted.");
        return;
    end
end

% If no spike clustering with internal spikes available
if ~isempty(Data.Spikes.SpikeCluster)
    numCluster = length(unique(Data.Spikes.SpikeCluster));
else
    numCluster = 1;
end

% Convert in um

SpikePositions = (SpikePositions-1)*Data.Info.ChannelSpacing;

%% Execute Selection
%% Spike Map with amplitude color coding

if strcmp(TypeofAnalysis,"Spike Map") 
    if ~isnan(PlotInfo.Units)
        ClustertoShow = num2str(PlotInfo.Units);
        Plottype = "NewCluster";
    else
        ClustertoShow = convertCharsToStrings(ClustertoShowDropDown);
        cla(Figure);
        Plottype = "Initial";
    end

    if ~strcmp(ClustertoShow,"All") && ~strcmp(ClustertoShow,"Non")
        CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Continous",RGBMatrix,Data.Time,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,ChannelPosition,Figure,numCluster,"Non",PlotInfo.Plotevents,PlotInfo.EventData,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    end

    set(Figure, 'YDir','reverse');
    CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Continous",RGBMatrix,Data.Time,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,ChannelPosition,Figure,numCluster,ClustertoShow,PlotInfo.Plotevents,PlotInfo.EventData,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    
    CurrentPlotData = Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,Figure2,Figure3,Plottype,RGBMatrix,ClustertoShow,PlotInfo.SpikeRateNumBins,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance); 
end

%% Spike Rate plots updating

if strcmp(TypeofAnalysis,"SpikeRateBinSizeChange")
    if ~isnan(PlotInfo.Units)
        ClustertoShow = num2str(PlotInfo.Units);
        Plottype = "NewCluster";
    else
        ClustertoShow = convertCharsToStrings(ClustertoShowDropDown);
        Plottype = "Initial";
    end
    % Check whether Spike Times are indicies or time points. Convert into
    % time points
    if length(find(mod(SpikeTimes(:), 1) == 0)) == length(SpikePositions)
        SpikeTimes = SpikeTimes/Data.Info.NativeSamplingRate;
    end
    CurrentPlotData = Continous_Spikes_Plot_Spike_Rate(Data,SpikeTimes,SpikePositions,CluterPositions,Figure2,Figure3,"Initial",RGBMatrix,ClustertoShow,PlotInfo.SpikeRateNumBins,PlotInfo.ChannelSelection,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
end

%% Channel waveforms

if strcmp(TypeofAnalysis,"Spike Waveforms")
    CurrentPlotData = Continous_Spikes_Plot_Waveforms(Data,SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,PlotInfo,ClustertoShowDropDown,Figure,CurrentPlotData);
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

    %% Get max waveforms 
    % Find n number of biggest waveforms
    % Prepare: Waveforms in 3d matrix (nchannel,nwaves,ntime) for spike
    % waveform over depth plots. Here we need the spike waveform of the
    % channel the spike was detected in.
    NumWaveForms = length(PlotInfo.Waveforms(1):PlotInfo.Waveforms(2));
    Waveformstoplot = NaN(size(ClusterWaveforms,2),size(ClusterWaveforms,3));
    for nwaves = 1:size(ClusterWaveforms,2)
        ChannelSelection = ((SpikePositions(nwaves))./Data.Info.ChannelSpacing)+1; % convert um in channelindicies starting with 1
        Waveformstoplot(nwaves,:) = squeeze(ClusterWaveforms(ChannelSelection,nwaves,:));       
    end
    [MaxValue,~] = max(Waveformstoplot,[],2);
    [~,MaxIndex] = maxk(MaxValue,NumWaveForms);
    
    WaveFormSelection = ClusterWaveforms(:,MaxIndex,:);
    
    MeanWaveForm = NaN(1,size(WaveFormSelection,1),size(WaveFormSelection,3));

    % If only one wave, dimensions change
    if size(WaveFormSelection,2)>1
        MeanWaveForm(1,:,:) = squeeze(mean(WaveFormSelection,2));
    else
        MeanWaveForm(1,:,:) = squeeze(WaveFormSelection);
    end
   
    %% Just Some Channel Selected
    MeanWaveForm = MeanWaveForm(1,PlotInfo.ChannelSelection,:);
    
    CurrentPlotData = Continous_Spikes_Plot_Average_Waveforms(Figure,Data,PlotInfo.ChannelSelection,ClustertoShowDropDown,MeanWaveForm,Data.Info.ChannelSpacing,"Internal",PlotInfo.Waveforms,TwoORThreeD,CurrentPlotData);
end

%% basic quantification of spiking plot
if strcmp(TypeofAnalysis,"Spike Amplitude Density Along Depth")
    %% If unit selected
    if ~strcmp(ClustertoShowDropDown,"All") && ~strcmp(ClustertoShowDropDown,"Non")
        SpikesInCluster = CluterPositions == PlotInfo.Units;
        SpikeAmps = SpikeAmps(SpikesInCluster==1);
        SpikePositions = SpikePositions(SpikesInCluster==1);
    end

    set(Figure, 'YDir', 'reverse');
    
    ChannelRange = PlotInfo.ChannelSelection;
    %% basic quantification of spiking plot
    depthBins = 0:(length(ChannelRange)-1)*Data.Info.ChannelSpacing/150:((length(ChannelRange)-1)*Data.Info.ChannelSpacing)+0.5;
    ampBins = 0:max(SpikeAmps)/100:max(SpikeAmps);
    recordingDur = Data.Time(end);
    
    % bc the first bin checked is zero and first channeldepth is zero,
    % but values have to be bigger than zero --> channel one not shown -->
    % add a little artificial depth of 0.5 um
    SpikePositions = SpikePositions+0.5;
    [pdfs, cdfs] = computeWFampsOverDepth(SpikeAmps, SpikePositions, ampBins, depthBins, recordingDur);
    plotWFampCDFs(pdfs, cdfs, ampBins, depthBins, "PDF", Figure,(length(ChannelRange)-1)*Data.Info.ChannelSpacing,Data.Info.ChannelSpacing,"Internal",TwoORThreeD,ClustertoShowDropDown);
    
    depthX = depthBins(1:end-1)+mean(diff(depthBins))/2;
    ampX = ampBins(1:end-1)+mean(diff(ampBins))/2;
    CurrentPlotData.MainXData = ampX;
    CurrentPlotData.MainYData = depthX;
    CurrentPlotData.MainCData = pdfs;
    CurrentPlotData.MainType = strcat("Continous Internal Spikes: Spike Amplitude Density Along Depth");
    CurrentPlotData.MainXTicks = Figure.XTickLabel;
end

if strcmp(TypeofAnalysis,"Cumulative Spike Amplitude Density Along Depth")
    %% If unit selected
    if ~strcmp(ClustertoShowDropDown,"All") && ~strcmp(ClustertoShowDropDown,"Non")
        SpikesInCluster = CluterPositions == PlotInfo.Units;
        SpikeAmps = SpikeAmps(SpikesInCluster==1);
        SpikePositions = SpikePositions(SpikesInCluster==1);
    end

    set(Figure, 'YDir', 'reverse');
    
    ChannelRange = PlotInfo.ChannelSelection;
    %% basic quantification of spiking plot
    depthBins = 0:length(ChannelRange)*Data.Info.ChannelSpacing/150:length(ChannelRange)*Data.Info.ChannelSpacing;
    ampBins = 0:max(SpikeAmps)/100:max(SpikeAmps);
    recordingDur = Data.Time(end);
    % bc the first bin checked is zero and first channeldepth is zero,
    % but values have to be bigger than zero --> channel one not shown -->
    % add a little artificial depth of 0.5 um
    SpikePositions = SpikePositions+0.5;
    [pdfs, cdfs] = computeWFampsOverDepth(SpikeAmps, SpikePositions, ampBins, depthBins, recordingDur);
    plotWFampCDFs(pdfs, cdfs, ampBins, depthBins, "CDF", Figure,(length(ChannelRange)-1)*Data.Info.ChannelSpacing,Data.Info.ChannelSpacing,"Internal",TwoORThreeD,ClustertoShowDropDown);
                    
    depthX = depthBins(1:end-1)+mean(diff(depthBins))/2;
    ampX = ampBins(1:end-1)+mean(diff(ampBins))/2;
    CurrentPlotData.MainXData = ampX;
    CurrentPlotData.MainYData = depthX;
    CurrentPlotData.MainCData = cdfs;
    CurrentPlotData.MainType = strcat("Continous Internal Spikes: Cumulative Spike Amplitude Density Along Depth");
    CurrentPlotData.MainXTicks = Figure.XTickLabel;
end

if strcmp(TypeofAnalysis,"Spike Triggered LFP")

    if ~isnan(PlotInfo.Units)
        ClustertoShowIndicie = PlotInfo.Units;
        SpikesinCluster = CluterPositions == ClustertoShowIndicie;
        SpikeTimes = SpikeTimes(SpikesinCluster==1);
        SpikePositions = SpikePositions(SpikesinCluster==1);
    end

    [TempData,~,CurrentPlotData] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelSelection,"Continous",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD,ClustertoShowDropDown,CurrentPlotData,PlotAppearance);
    
    if ~isempty(TempData) % if preprocessed
        Data = TempData;
    end

    texttoshow = ["Number of Spikes found: ";num2str(length(SpikeTimes))];

    TextArea.Value = texttoshow;
end
