function [CurrentPlotData] = Analyse_Main_Window_Spike_Rate(Data,BinRange,Figure,TimeRangetoPlot,LockYLim,Samplingrate,Channelselection,CurrentTimeStartIndicie,CurrentTimeEndIndicie,PreprocDataPlotCheckBox,LowPassSpikeRate,CutoffFreque,FilterOrder,CurrentPlotData,PlotAppearance,StartIndex,StopIndex)

%________________________________________________________________________________________

%% Main Function to calculate and plot Spike Rate for the main window data plot

% NOTE: LockYLim option determines, whether there should be a global limit
% for the y axis. If set to 1, the current ylim is compared to the max of
% ylim of previous spike rate plots. If current ylims exceed the previous ylims,
% global ylim is set to current. Otherwise global ylim remains unchanged. 

% NOTE: Spike rate gets low pass filtered, when the duration for each bin
% is too small (smaller than 0.03s) to avoid artificially high spike rates

% Inputs:
% 1: Data: structure with field Data.Spikes for spike data and Data.Info
% for preprocessing infos
% 4. BinRange: Number of bins as char, i.e. '100'
% 5. Figure: axes object of figure to plot in
% 6. TimeRangetoPlot: Time vector as double with one time point for each
% sample of Data
% 7. LockYLim: 1 or 0 as double. 1 to only update ylim when current ylim
% exceeds global ylim from Spike_Rate_Window
% 8: SampleRate: in Hz as double (i.e. Data.Info.NativeSamplingRate)
% 9. Channelselection: 1 x 2 double vector with channels to plot. [1,10]
% means channel 1 to 10 
% 10. CurrentTimeStartIndicie: Start indices of time window--- not used
% here but maybe usefull!
% 11. CurrentTimeEndIndicie: Stop indices of time window--- not used
% here but maybe usefull!
% 12. PreprocDataPlotCheckBox: value of checkbox in main window to plot
% preprocessed data. This is necessary to handle downsampled data if it should exist
% 13. LowPassSpikeRate: 1 to low pass filter spike rate, 0 otherwise
% 14. CutoffFreque - comes from spike rate app window public property "CutoffFreque". Right now its empty as standard. This means cutoff is
% autocalculated in Analyse_Main_Window_LowPassFilter_SpikeRate.m;
% 15. FilterOrder: Low Pass filter order as doublee
% 16. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 17. PlotAppearance: structure holding information about plot appearances
% the user can select

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Pull Data from GUI
% Extract Spikes within time window in main window plot
% When kilosort: take kilosort spike times instead of spikes plotted in
% main window (Kilosort spikes cant ne fully displayed in the main window overlaying the channel data since they are in between channels. For plotting they are just assigned to the nearest channel)

if str2double(Data.Info.ProbeInfo.NrRows)>=2 && ~strcmp(Data.Info.SpikeType,"Internal")
    SpikePositions = Data.Spikes.DataCorrectedSpikePositions(:,2); 
else
    SpikePositions = Data.Spikes.SpikePositions(:,2);
end

if PreprocDataPlotCheckBox == 1 && isfield(Data.Info,'DownsampleFactor')  
    SpikeTimes = Data.Spikes.SpikeTimes./Data.Info.DownsampleFactor;
else
    SpikeTimes = Data.Spikes.SpikeTimes;
end

%% Determine Spikes in Window
SpikesinWindow = SpikeTimes >=StartIndex & SpikeTimes <= StopIndex;
 
if sum(SpikesinWindow)>=1
    SpikeTimes = SpikeTimes(SpikesinWindow==1);
    SpikeTimes = SpikeTimes-double(StartIndex+1);
    SpikePositions = SpikePositions(SpikesinWindow==1);
else
    SpikeTimes = [];
end

%% Only select Spikes in selected Channelrange

[SpikeTimes,~,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("SpikeRate",Data.Info,SpikeTimes,SpikePositions,Data.Info.ChannelSpacing,Channelselection,Data.Info.SpikeType,Data.Info.ProbeInfo.ActiveChannel);

%% Caluclate Spike Rate in Hz over all Channel
numbins = round(BinRange); 
binsize = floor(numel(TimeRangetoPlot)/numbins); % in samples
Timerangebin = binsize/Samplingrate;

[SpikesPerBin] = Spike_Module_Calculate_Spikes_Times_In_Bin(SpikeTimes,[],numbins,binsize,Samplingrate,"SpikeRateoverTime",[],[]);

%% Divide by Channel Number 
SpikesPerBin = SpikesPerBin./length(Channelselection);

%% Low Pass filter results, bc of small bin sizes 

if LowPassSpikeRate == 1
    Samplefrequency = round(1/Timerangebin);
    filteredSpikeRate = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikesPerBin, CutoffFreque, Samplefrequency, FilterOrder, numbins);
else
    filteredSpikeRate = SpikesPerBin;
end

%% Set up figure and plot

Timeofbins =linspace(TimeRangetoPlot(1),TimeRangetoPlot(end),numbins);

hBar = findobj(Figure, 'Type', 'bar', 'Tag', 'Barobject');

if length(hBar)>numbins && ~isempty(hBar) 
    delete(hBar(numbins+1:end));
    hBar = findobj(Figure, 'Type', 'bar', 'Tag', 'Barobject');
end

if~isempty(hBar)
    %SpikeYLim = max(hBar.YData);
    SpikeYLim = ylim(Figure);
end

if isempty(hBar)
    bar(Figure,filteredSpikeRate,'FaceColor', PlotAppearance.LiveSpikeRateWindow.BarColor, 'EdgeColor', PlotAppearance.LiveSpikeRateWindow.BarColor, 'Tag', 'Barobject')  
    
    title(Figure,strcat("Spike Rate of Main Window Time Range"));
    xlabel(Figure,strcat(PlotAppearance.LiveSpikeRateWindow.XLabel,"; ",num2str(Timerangebin),'s per bin'))
    ylabel(Figure,PlotAppearance.LiveSpikeRateWindow.YLabel);
    Figure.FontSize = PlotAppearance.LiveSpikeRateWindow.FontSize;

    xlim(Figure,[1,length(Timeofbins)])

    Figure.XLabel.Color = [0 0 0];
    Figure.YLabel.Color = [0 0 0];       
    Figure.YColor = 'k';  
    %UIAxes.XTickLabelMode = 'auto';
    Figure.XColor = 'k';  
    Figure.Title.Color = 'k';  
    Figure.Box ="off";
    
else
    set(hBar, 'YData', filteredSpikeRate,'FaceColor', PlotAppearance.LiveSpikeRateWindow.BarColor, 'EdgeColor', PlotAppearance.LiveSpikeRateWindow.BarColor, 'Tag', 'Barobject');
    %% Ylim
    currentYlim(1) = 0;
    currentYlim(2) = max(filteredSpikeRate);
    
    if LockYLim== 1
        if ~isempty(SpikeYLim)
            if abs(currentYlim(2)) > abs(SpikeYLim(2))
                Figure.YLim = currentYlim;
            else
                Figure.YLim = SpikeYLim;
            end
        else
            Figure.YLim = currentYlim;
        end
    else
        Figure.YLim = currentYlim;
    end
end

xticks(Figure, 1:length(Timeofbins));
% Set the x-axis tick labels to the time vector
xticklabels(Figure, cellstr(num2str(Timeofbins(:), '%.2f')));
xlim(Figure,[1,length(Timeofbins)])
%% save plotted data in case user wants to save 
CurrentPlotData.LiveSpikeXData = 1:length(filteredSpikeRate);
CurrentPlotData.LiveSpikeYData = filteredSpikeRate;
CurrentPlotData.LiveSpikeCData = [];
CurrentPlotData.LiveSpikeType = strcat("Spike Rate with ",num2str(Timerangebin),"s per Bin");
CurrentPlotData.LiveSpikeXTicks = Figure.XTickLabel;