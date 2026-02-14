function [CurrentClim,CurrentPlotData] = Event_Module_Spectrogram2(Data,EventRelatedData,Window,BaselineNormalize,BaselineWindow,TF,CurrentClim,Figure,SampleRate,PlotAppearance,Time,CurrentPlotData,TwoORThreeD)

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
% 6. TF.FreqRange: char, comma separated numbers with start and stop
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

%% Define spec parameter
Window = str2double(Window);
Window = round(Window);
nfft = 2^nextpow2(length(EventRelatedData));   % good default
wspec = hamming(Window);
Noverlap = Window/2;
Freqs = linspace(TF.FreqRange(1),TF.FreqRange(3),TF.FreqRange(2));
%Freqs = TF.FreqRange(1):TF.FreqRange(2):TF.FreqRange(3);

%% Spec and conversion
[Magni,TFFreqs,TFTime] = spectrogram(EventRelatedData, wspec, Noverlap, Freqs, SampleRate);   % compute magnitude in Hz
SPower = abs(Magni).^2;
SdB = 10*log10(SPower + eps); % in db

TimeToPlot = linspace(Time(1), Time(end), length(TFTime));

%% Baseline Norm.
if BaselineNormalize
    BaselineTime = str2double(strsplit(BaselineWindow,','));
    BaselineIndicies = TimeToPlot >= BaselineTime(1) & TimeToPlot <= BaselineTime(2);

    baseline = mean(SdB(:, BaselineIndicies), 2); % mean across pre-stimulus time
    SdB = SdB - baseline;  % broadcasting along time
end

%% Plot
SpectroHandle = findobj(Figure, 'Tag', 'SpectroImsc');

if strcmp(TwoORThreeD,"ThreeD")

    delete(SpectroHandle)
    SpectroHandle = findobj(Figure, 'Tag', 'SpectroImsc');

    if isempty(SpectroHandle)
        % First-time creation
        surf(Figure, TimeToPlot, TFFreqs, SdB,'EdgeColor', 'none', 'Tag', 'SpectroImsc');
    else
        % Update existing image
        set(SpectroHandle, 'XData', TimeToPlot, ...
                  'YData', TFFreqs, ...
                  'CData', SdB);
    end
    view(Figure,45,45);
    box(Figure, 'off');
    grid(Figure, 'off');
else
    if isempty(SpectroHandle)
        % First-time creation
        imagesc(Figure, TimeToPlot, TFFreqs, SdB, 'Tag', 'SpectroImsc');
    else
        % Update existing image
        set(SpectroHandle, 'XData', TimeToPlot, ...
                  'YData', TFFreqs, ...
                  'CData', SdB);
    end
end

%% Plot Event line
EventHandle = findobj(Figure, 'Tag', 'EventLine');
if length(EventHandle)>1
    delete(EventHandle(2:end));
end

if strcmp(TwoORThreeD,"ThreeD")
    % Define the Y and Z ranges
    Y = [TFFreqs(1), TFFreqs(end)];
    Z = [min(SdB(~isinf(SdB)),[],'all'), max(SdB(~isinf(SdB)),[],'all')];  
    
    % Create a plane through Y and Z
    [YGrid, ZGrid] = meshgrid(Y, Z);
    
    XGrid = zeros(size(YGrid));
    
    if isempty(EventHandle)
        eventLine=surf(Figure,XGrid, YGrid, ZGrid, 'FaceColor', PlotAppearance.TFWindow.TriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
    else
        set(EventHandle(1),'XData',XGrid,'YData', YGrid,'ZData', ZGrid, 'FaceColor', PlotAppearance.TFWindow.TriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
        eventLine = EventHandle(1);
    end

else
    if isempty(EventHandle)
        eventLine = line(Figure,[0,0],[min(TFFreqs) max(TFFreqs)],'Color',PlotAppearance.TFWindow.TriggerColor ,'LineWidth',PlotAppearance.TFWindow.TriggerLineWidth,'Tag', 'EventLine');
    else
        set(EventHandle(1),'XData',[0,0],'YData',[min(TFFreqs) max(TFFreqs)],'Tag','Events');
        eventLine = EventHandle(1);
    end
end

axis(Figure, 'xy');% correct orientation

CurrentClim(1) = min(SdB(~isinf(SdB)),[],'all');
CurrentClim(2) = max(SdB(~isinf(SdB)),[],'all');
cbar_handle=colorbar('peer',Figure,'location','EastOutside');
cbar_handle.Label.String = PlotAppearance.TFWindow.CLabel;
cbar_handle.Label.Rotation = 270;
cbar_handle.Color = 'k';  
cbar_handle.Label.Color = 'k';        % Sets the color of the label text
Figure.XLabel.Color = [0 0 0];
Figure.YLabel.Color = [0 0 0];       
Figure.YColor = 'k';  
Figure.XColor = 'k';  
Figure.Title.Color = 'k';  
Figure.Box ="off";

title(Figure,strcat("Time Frequency Power as ",TF.AnalysisType," for Channel ",num2str(TF.SingleChannelSelected)));
xlabel(Figure,PlotAppearance.TFWindow.XLabel), ylabel(Figure,PlotAppearance.TFWindow.YLabel)
ylim(Figure,[TFFreqs(1) TFFreqs(end)])
xlim(Figure,[Time(1),Time(end)])
clim(Figure,CurrentClim)

% Save data for export
CurrentPlotData.TFPowerXData = TimeToPlot;
CurrentPlotData.TFPowerYData = TFFreqs;
CurrentPlotData.TFPowerCData = SdB;
CurrentPlotData.TFPowerType = strcat("Time Frequency Power Window ",num2str(Window));
CurrentPlotData.TFPowerXTicks = Figure.XTickLabel;

% Add legend only once
if isempty(findobj(Figure, 'Type', 'legend'))
    % Create legend with imagesc and event line
    legendHandle = legend(eventLine, {'Trigger'});
    set(legendHandle, 'HandleVisibility', 'off');
end