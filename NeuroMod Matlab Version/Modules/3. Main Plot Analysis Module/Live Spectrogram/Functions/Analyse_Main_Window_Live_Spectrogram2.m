function [CurrentClim,CurrentPlotData] = Analyse_Main_Window_Live_Spectrogram2(Data,DataToShow,EventsToShow,ChannelToPlot,Window,FrequencyRange,LockCLim,DataType,CurrentClim,Figure,SampleRate,PlotAppearance,Time,CurrentEventChannel,PlotEvent,CurrentPlotData,TwoORThreeD)

%________________________________________________________________________________________
%% Function to create a spectrogram (for live analysis) with the corresponding matlab function for the main window data (or custom time points if decoupled from main window)


% Input Arguments:
% 1. Data: mian window data structure
% 2. DataToShow: char, either "Raw Data" or "Preprocessed Data" depending
% on what to show the analysis for
% 3. EventsToShow: double vector with event indicies i9n currently selected
% time window
% 4. ChannelToPlot: char, number of channel to analyze
% 5. Window: char, number of samples in each spectogram window
% 6. FrequencyRange: char, comma separated numbers with start and stop
% frequency to show
% 7. LockCLim: 1 or 0 double, whether to lock the clim to the min or max
% value recording since analysis was started
% 8. DataType: char, type of data shown in the title
% 9. CurrentClim: double vector with highest and lowest c values recorded so far (for lock clim) 
% 10. Figure: app.UIAxes object of live window
% 11. SampleRate: double, sample rate of currently analysed data
% 12. PlotAppearance: struc with all appearances of plot components
% 13. Time: double vector with all time points in s that where analyzed
% 14. CurrentEventChannel: Currently selected event channel in main window
% that for which trigger times are shown in this window too
% 15. PlotEvent: 1 or 0 whether the user selected to plot events in the
% main window
% 16. CurrentPlotData: struc with plotted data being saved for later export
% 17. TwoORThreeD: char, "TwoD" or "ThreeD" depending on what the user
% selected

% Output:
% 1. CurrentClim: double vector with highest and lowest c values recorded so far (for lock clim) 
% 2. CurrentPlotData: struc with plotted data being saved for later export

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Window = str2double(Window);
Window = round(Window);
OriginalChannel = ChannelToPlot;
ChannelToPlot = str2double(ChannelToPlot);
[ChannelToPlot] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ChannelToPlot,'MainPlot');

nfft = 2^nextpow2(Window);   % good default
noverlap = round(0.75 * Window);
FrequencyRange = str2double(strsplit(FrequencyRange,','));

SpectroData = DataToShow(ChannelToPlot,:);

[S,F,T] = spectrogram(SpectroData, Window, noverlap, nfft, SampleRate);   % compute values

if length(T)<=1
    msgbox("Window length too big for amount of time analysed!")
    warning("Window length too big. ")
    return;
end

TimeToPlot = linspace(Time(1), Time(end), length(T));

[~,ClosestFreqs(1)] = min(abs(F-FrequencyRange(1)));
[~,ClosestFreqs(2)] = min(abs(F-FrequencyRange(2)));

SpectroHandle = findobj(Figure, 'Tag', 'SpectroImsc');

if strcmp(TwoORThreeD,"ThreeD")

    delete(SpectroHandle)
    SpectroHandle = findobj(Figure, 'Tag', 'SpectroImsc');

    if isempty(SpectroHandle)
        % First-time creation
        surf(Figure, TimeToPlot, F(ClosestFreqs(1):ClosestFreqs(2))', 20*log10(abs(S(ClosestFreqs(1):ClosestFreqs(2),:))),'EdgeColor', 'none', 'Tag', 'SpectroImsc');
    else
        % Update existing image
        set(SpectroHandle, 'XData', TimeToPlot, ...
                  'YData', F(ClosestFreqs(1):ClosestFreqs(2)), ...
                  'CData', 20*log10(abs(S(ClosestFreqs(1):ClosestFreqs(2),:))));
    end
    view(Figure,45,45);
    box(Figure, 'off');
    grid(Figure, 'off');
else
    if isempty(SpectroHandle)
        % First-time creation
        imagesc(Figure, TimeToPlot, F(ClosestFreqs(1):ClosestFreqs(2)), 20*log10(abs(S(ClosestFreqs(1):ClosestFreqs(2),:))), 'Tag', 'SpectroImsc');
    else
        % Update existing image
        set(SpectroHandle, 'XData', TimeToPlot, ...
                  'YData', F(ClosestFreqs(1):ClosestFreqs(2)), ...
                  'CData', 20*log10(abs(S(ClosestFreqs(1):ClosestFreqs(2),:))));
    end
end

axis(Figure, 'xy');% correct orientation

xlim(Figure,[TimeToPlot(1) TimeToPlot(end)])
ylim(Figure,[FrequencyRange(1),FrequencyRange(2)]);
xlabel(Figure, PlotAppearance.LiveSpectrogramWindow.XLabel);
ylabel(Figure, PlotAppearance.LiveSpectrogramWindow.YLabel);
title(Figure, strcat(DataType," ",PlotAppearance.LiveSpectrogramWindow.Title," ",OriginalChannel));

Currentmin = min(20*log10(abs(S)),[],'all');
Currentmax = max(20*log10(abs(S)),[],'all');

if ~isempty(CurrentClim)
    if LockCLim
        if Currentmax>CurrentClim(2)
            CurrentClim(2) = Currentmax;
        end
        if Currentmin<CurrentClim(1)
            CurrentClim(1) = Currentmin;
        end
        clim(Figure,CurrentClim);
    else
        clim(Figure, [Currentmin Currentmax]);
    end
else
    CurrentClim = [Currentmin Currentmax];
end

%% --------------- Handle Events ---------------
if strcmp(PlotEvent,'Events')
    Analyse_Main_Window_Plot_Events(Figure,Data,Time,EventsToShow,FrequencyRange(1),FrequencyRange(2),SampleRate,CurrentEventChannel)
else
    Eventline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Events');
    delete(Eventline_handles); 
end

% Save data for export
CurrentPlotData.LiveSpectroXData = TimeToPlot;
CurrentPlotData.LiveSpectroYData = F;
CurrentPlotData.LiveSpectroCData = 20*log10(abs(S));
CurrentPlotData.LiveSpectroType = "Live Main Window Spectrogram";
CurrentPlotData.LiveSpectroXTicks = Figure.XTickLabel;