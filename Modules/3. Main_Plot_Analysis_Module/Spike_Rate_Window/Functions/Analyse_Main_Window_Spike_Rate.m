function Analyse_Main_Window_Spike_Rate(Data,CurrentTimePoints,TimeRangeViewBox,BinRange,Figure,TimeRangetoPlot,LockYLim,Samplingrate,Channelselection,CurrentTimeStartIndicie,CurrentTimeEndIndicie,PreprocDataPlotCheckBox,DownsampleSPikeRate,CutoffFreque,FilterOrder)

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
% 2. CurrentTimePoints: first sample indicie of data plotted in main window
% data plot as double 
% 3. TimeRangeViewBox: char; field in the top right of the main window that shows
% the duration of the data plotted to extract duration of the recording,
% i.e. '1.532s' -- dont forget the s at the end!!
% 4. BinRange: Number of bins as char, i.e. '100'
% 5. Figure: axes object of figure to plot in
% 6. TimeRangetoPlot: Time vector as double with one time point for each
% sample of Data
% 7. LockYLim: 1 or 0 as double. 1 to only update ylim when current ylim
% exceeds global ylim from Spike_Rate_Window
% 8: SampleRate: in Hz as double (i.e. Data.Info.NativeSamplingRate)
% 9. Channelselection: 1 x 2 double vector with channels to plot. [1,10]
% means channel 1 to 10 
% 10. Basically same as CurrentTimePoints -- ToDo
% 11. Basically same as CurrentTimePoints + length(TimeRangetoPlot) -- ToDo
% 12. PreprocDataPlotCheckBox: value of checkbox in main window to plot
% preprocessed data. This is necessary to handle downsampled data if it should exist


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Pull Data from GUI
% Extract Spikes within time window in main window plot
% When kilosort: take kilosort spike times instead of spikes plotted in
% main window (Kilosort spikes cant ne fully displayed in the main window overlaying the channel data since they are in between channels. For plotting they are just assigned to the nearest channel)

if PreprocDataPlotCheckBox == 1 && isfield(Data.Info,'DownsampleFactor')  
    TimeDuration = str2double(TimeRangeViewBox(1:end-1));
    StartIndex = uint64(CurrentTimePoints);
    StopIndex = StartIndex+uint64(round(TimeDuration*Data.Info.DownsampledSampleRate));
    SpikeTimes = Data.Spikes.SpikeTimes./Data.Info.DownsampleFactor;
    SpikePositions = Data.Spikes.SpikePositions(:,2);
else
    TimeDuration = str2double(TimeRangeViewBox(1:end-1));
    StartIndex = uint64(CurrentTimePoints);
    StopIndex = StartIndex+uint64(round(TimeDuration*Samplingrate));
    SpikeTimes = Data.Spikes.SpikeTimes;
    SpikePositions = Data.Spikes.SpikePositions(:,2);
end

if PreprocDataPlotCheckBox == 1 && isfield(Data.Info,'DownsampleFactor') 
    Samplingrate = Data.Info.DownsampledSampleRate;
else
    Samplingrate = Data.Info.NativeSamplingRate;
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

[SpikeTimes,SpikePositions,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeTimes,SpikePositions,Data.Info.ChannelSpacing,Channelselection,Data.Info.SpikeType);

%% Caluclate Spike Rate in Hz over all Channel
numbins = round(BinRange); 
binsize = floor(numel(TimeRangetoPlot)/numbins); % in samples
Timerangebin = binsize/Samplingrate;

[SpikesPerBin] = Spike_Module_Calculate_Spikes_Times_In_Bin(SpikeTimes,[],numbins,binsize,Samplingrate,"SpikeRateoverTime");

%% Divide by Channel Number 
SpikesPerBin = SpikesPerBin./length(Channelselection(1):Channelselection(2));

%% Low Pass filter results, bc of small bin sizes 

if DownsampleSPikeRate == 1
    Samplefrequency = 1/Timerangebin;
    filteredSpikeRate = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikesPerBin, CutoffFreque, Samplefrequency, FilterOrder, numbins);
else
    filteredSpikeRate = SpikesPerBin;
end

%% Set up figure and plot
TitleChannelRange = strcat(num2str(Channelselection(1)),":",num2str(Channelselection(2)));
title(Figure,strcat("Spike Rate of Main Window Time Range Channel: ",TitleChannelRange))
Timeofbins = TimeRangetoPlot(1)+(Timerangebin/2):Timerangebin:TimeRangetoPlot(end);
xticks(Figure, 1:length(Timeofbins));
% Set the x-axis tick labels to the time vector
xticklabels(Figure, cellstr(num2str(Timeofbins(:), '%.2f')));
xlabel(Figure,strcat("Time [s]; ",num2str(Timerangebin),'s per bin'))
hBar = findobj(Figure, 'Type', 'bar', 'Tag', 'Barobject');
xlim(Figure,[1,length(Timeofbins)])

if~isempty(hBar)
    %previousYLim = max(hBar.YData);
    previousYLim = ylim(Figure);
end

if length(hBar)>numbins && ~isempty(hBar) 
    delete(hBar(numbins+1:end));
    hBar = findobj(Figure, 'Type', 'bar', 'Tag', 'Barobject');
end

if isempty(hBar)
    bar(Figure,filteredSpikeRate,'black', 'Tag', 'Barobject')  
    ylabel(Figure,"Spike Rate [Hz]")
else
    set(hBar, 'YData', filteredSpikeRate, 'Tag', 'Barobject');
    if LockYLim == 1
        % Get the current y-axis limits
        if previousYLim(2)<max(filteredSpikeRate)
            ylim(Figure,[0 max(filteredSpikeRate)]);
        elseif previousYLim(2)>=max(filteredSpikeRate)
            ylim(Figure,previousYLim);
        end
    else
        ylim(Figure,[0 max(filteredSpikeRate)]);
    end
end
