function [TempData,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField,CurrentPlotData] = Events_Spikes_Manage_Analysis_Plots(Data,EventRangeEditField,Figure,AnalysisTypeDropDown,SpikeRateNumBinsEditField,TextArea,rgbMatrix,numCluster,ClustertoshowDropDown,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,BaselineNormalizeCheckBox,TimeWindowSpiketriggredLFPEditField,Figure2,Figure3,TwoORThreeD,CurrentPlotData,SpikeBinSettings,PlotAppearance,ActiveChannel,EventDataType,EventChannelName,Autorun,PreservePlotChannelLocations)

%________________________________________________________________________________________
%% Function to organize and select analysis and plot functions for event kilosort spikes based on user input
% This function uses a functions from the spike repository from Cortex lab on Github: https://github.com/cortex-lab/spikes
% Function used: computeWFampsOverDepth
%                plotWFampCDFs
%                spikeTrigLFP

% This function is executed every time some event kilosort spikes analysis has to be done and plotted

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
% 8. numCluster: double, number of different units/cluster found in spike
% sorting
% 9. ClustertoShowDropDown: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 10. ChannelSelectionforPlottingEditField: user input for cahnnel to show, char 'from, to',
% i.e. '1,10' for channel 1 to 10;
% 11. BaselineWindowStartStopinsEditField: user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.2,0' for -200ms to 0ms timw window as baseline
% 12. BaselineNormalizeCheckBox: check box whether baseline normalization should be applied. BaselineNormalizeCheckBox.Value is either
% 1 if checked or 0 if not
% 13. TimeWindowSpiketriggredLFPEditField:  user input for time range of baseline window (for spike rate heatmap), char 'from, to',
% i.e. '-0.05,0.2' for -5ms to 200ms timw window as baseline
% 14. Figure2: figure object handle to plot spike rate over time 
% 15. Figure3: figure object handle to plot spike rate over time 
% 16. TwoORThreeDchar, either "TwoD" or "ThreeD" for 2d or 3d plot
% 17. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 18. SpikeBinSettings: structure, save numbins in time and depth domain for spike
% rate heatmap plot -- see Spike_Module_Set_Up_Spike_Analysis_Windows.m for
% standard. 
% 19. EventDataType: char, either 'Raw Event Related Data' or 'Preprocessed
% Event Related Data'. 
% 20. EventChannelName: char, name of the event channel for which event
% related spiokes are extracted
% 21. Autorun: double, 1 or 0 whether fucntion is executed in autorun
% functions
% 22.PreservePlotChannelLocations: double, 1 or 0 whether to preserve
% original spacing between active channel (in case of inactiove islands between active channel)

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

TempData = [];

%% Prepare Plots
if strcmp(AnalysisTypeDropDown,"Spike Triggered LFP")
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,Data.Info.SpikeType,1,TimeWindowSpiketriggredLFPEditField,SpikeBinSettings,ActiveChannel,PreservePlotChannelLocations);
else
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,Data.Info.SpikeType,0,TimeWindowSpiketriggredLFPEditField,SpikeBinSettings,ActiveChannel,PreservePlotChannelLocations);
end

% Check for errros
if strcmp(AnalysisTypeDropDown,"Spike Rate Heatmap") && PlotInfo.ChannelsToPlot(1) == PlotInfo.ChannelsToPlot(end)
    msgbox("Error: at least two channel necessary!")
    return;
end

% Check for errros
if strcmp(AnalysisTypeDropDown,"Spike Triggered LFP") && PlotInfo.ChannelsToPlot(1) == PlotInfo.ChannelsToPlot(end)
    msgbox("Error: at least two channel necessary!")
    return;
end

if strcmp(AnalysisTypeDropDown,"Spike Map")
    
    % plot spike times
    if strcmp(Data.Info.Sorter,'Mountainsort5') || strcmp(Data.Info.Sorter,'SpykingCircus2')
        SpikeAmplitude(SpikeAmplitude<0)=abs(SpikeAmplitude(SpikeAmplitude<0));
    end
    
    if ~strcmp(ClustertoshowDropDown,"All") && ~strcmp(ClustertoshowDropDown,"Non")
        CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,"Non",[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    end
    CurrentPlotData = Spikes_Plot_Spike_Times(Data,"Eventrelated",rgbMatrix,PlotInfo.Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmplitude,Data.Spikes.ChannelPosition,Figure,numCluster,ClustertoshowDropDown,[],[],PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,CurrentPlotData,PlotAppearance);
    
    % Set properties
    Figure.YLabel.Color = [0 0 0];
    Figure.YColor = [0 0 0];
    
elseif strcmp(AnalysisTypeDropDown,"Spike Rate Heatmap")
    
    CurrentPlotData = Event_Spikes_Plot_Heatmap_Spike_Rate(Data,SpikeTimes,SpikePositions,Figure,Data.Info.NativeSamplingRate,PlotInfo.time_bin_size,PlotInfo.depth_edges,PlotInfo.time_edges,length(PlotInfo.EventNr),0,BaselineNormalizeCheckBox,PlotInfo.NormWindow,ClustertoshowDropDown,SpikeCluster,rgbMatrix,PlotInfo.ChannelsToPlot,Data.Info.ChannelSpacing,"Kilosort",TwoORThreeD,CurrentPlotData,PlotAppearance);
    
elseif strcmp(AnalysisTypeDropDown,"Spike Triggered LFP")
    
    if ~strcmp(ClustertoshowDropDown,"All") && ~strcmp(ClustertoshowDropDown,"Non")
        ClustertoShowIndicie = str2double(ClustertoshowDropDown);
        SpikesinCluster = SpikeCluster == ClustertoShowIndicie;
        SpikeTimes = SpikeTimes(SpikesinCluster==1);
        SpikePositions = SpikePositions(SpikesinCluster==1);
    end
    
    if isempty(SpikeTimes)
        disp("No spikes for selected unit within selected channel range found!");
        return;
    end

    [TempData,~,CurrentPlotData] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,PlotInfo.ChannelsToPlot,"Events",TextArea,PlotInfo.TimeWindowSpiketriggredLFP,1,TwoORThreeD,ClustertoshowDropDown,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations);
    
    %% No again normalized to event time for spike rate
    if ~isempty(TempData) % if not preprocessed
        Data = TempData; % if preprocessed
    end
    
    %% -------------------- Extract Event Related Spike Data --------------------
    if strcmp(Data.Info.SpikeType,"Internal")
        [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Internal",0,EventDataType,EventChannelName);
    else
        [Data,~] = Event_Spikes_Extract_Event_Related_Spikes(Data,"Kilosort",0,EventDataType,EventChannelName);
    end
    
    [PlotInfo,SpikeTimes,SpikePositions,SpikeAmplitude,SpikeCluster,SpikeEvents,~,ChannelSelectionforPlottingEditField,EventRangeEditField,SpikeRateNumBinsEditField] = Event_Spikes_Prepare_Plots(Data,EventRangeEditField,ChannelSelectionforPlottingEditField,BaselineWindowStartStopinsEditField,SpikeRateNumBinsEditField,Data.Info.SpikeType,1,TimeWindowSpiketriggredLFPEditField,SpikeBinSettings,ActiveChannel,PreservePlotChannelLocations);

end  

CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"Initial",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations);
if ~strcmp(ClustertoshowDropDown,'Non') && ~strcmp(ClustertoshowDropDown,'All')
    CurrentPlotData = Event_Spikes_Plot_Spike_Rate(Data,PlotInfo.Time,"NewCluster",rgbMatrix,SpikeTimes,SpikePositions,SpikeCluster,length(PlotInfo.EventNr),ClustertoshowDropDown,SpikeRateNumBinsEditField,Figure2,Figure3,Data.Spikes.ChannelPosition,Data.Info.NativeSamplingRate,PlotInfo.ChannelsToPlot,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations);
end
if strcmp(Data.Info.SpikeType,"Internal")
    yyaxis(Figure2, 'right');
    ylabel(Figure2,'Spike Rate [Hz]');
end

if strcmp(AnalysisTypeDropDown,"Spike Map") || strcmp(AnalysisTypeDropDown,"Spike Rate Heatmap") || strcmp(AnalysisTypeDropDown,"Spike Triggered LFP")
    
    % Custome YLabel
    [StartDepth,StopDepth,~,~] = Spike_Module_Analysis_Determine_Depths(Data,PreservePlotChannelLocations,Data.Info.ProbeInfo.ActiveChannel(PlotInfo.ChannelsToPlot));

    if sum(ismember(Figure.YLim,[StartDepth ,StopDepth]))<2
        Figure.YLim = [StartDepth ,StopDepth];
    end
    Utility_Set_YAxis_Depth_Labels(Data,Figure,[],ActiveChannel,PreservePlotChannelLocations)
end

if Autorun == 0
    % Resize Figures based on analysis and whether cbar is necessary
    Event_Spikes_Resize_Figures(Figure,Figure2,Figure3,AnalysisTypeDropDown,ClustertoshowDropDown);
end
