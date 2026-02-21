function  [GlobalYlim,CurrentPlotData] = Analyse_Main_Window_Plot_PhaseAngles(Data,Figure1,Figure2,Phases,PhasesUnwrapped,AdjustedDownsampleRate,CurrentTime,GlobalYlim,LockYLIM,ColorMap,Method,PlotAppearance,CurrentPlotData,EventData,SelectedEventIndice,EventPlot,ShowAnayzedData,DataToCompute)

%________________________________________________________________________________________

%% Function to plot a phase angle time series for a given number of channel

% Inputs:
% 1. Data: Main window data object containing all relevant data components
% 2. Figure1: handle to figure object to plot phase angle timer series in 
% 3. Figure2: handle to figure object to amplitude envelope or data that
% was analyzed
% 4. Phases: 1 x n vector with phase angle time series in degree (from Analyse_Main_Window_Hilbert_Echt_Wavelet.m)
% 5. PhasesUnwrapped: 1 x n vector with amplitude envelope time series in degree (from Analyse_Main_Window_Hilbert_Echt_Wavelet.m)
% 6. AdjustedDownsampleRate: sample rate in Hz, adjusted bc it can it was
% potentially downsampled additionally to a new sample rate
% 7. CurrentTime: 1 x n time vector of currently viewed data snippet ( in respect to whole recording time)
% 8. GlobalYlim: 1 x 2 double with highest ylim values since the window was
% opened for the first time to lock ylim to that value as long as 
% LockYLIM = 1
% 9. LockYLIM: double either 1 or 0 whether to to lock the ylim to GlobalYlim
% 10. ColorMap: nchannel x 3 parula colormap
% 11. Method: Which method the user selcts to compute the phase angles,
% either "Endpoint Corrected Hilbert Transform" OR "Hilbert Transform" OR "Wavelet Convolution"
% 12. PlotAppearance: structure holding information about plot appearances
% the user can select
% 13. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 14. EventData: double vector with indices at which event trigger of the
% currently selected event channel happen (selected in main widnow) -->
% checks whether a trigger is within current window and plots the event
% time
% 15. SelectedEventIndice: indice of event channel being selected in
% respect to cell array in Data.Info.EventChannelNames
% 16. EventPlot: char, if 'Events' triggers is plotted if within data
% snippet, comes from main app window
% 17. ShowAnayzedData: double, 1 or 0, whether to plot amplitude envelope
% (if 0) or data snippet analysis was based on
% 18. DataToCompute: nchannel x time matric with data snippet to analyze (just used for dimensions)

% Outputs
% 1. GlobalYlim: 1 x 2 double with highest ylim values since the window was
% opened for the first time to lock ylim to that value as long as 
% LockYLIM = 1
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if isempty(PhasesUnwrapped)
    msgbox("Too few samples to compute phase. Please increase the time analyzed!");
    return;
end
%CurrentTime = CurrentTime(1):1/AdjustedDownsampleRate:CurrentTime(1)+((size(Phases,2)-1)/AdjustedDownsampleRate);

%% -------- PLOT Phase Angle Time Series ---------------
%% Hilbert Transform
if strcmp(Method,"Hilbert Transform") || strcmp(Method,"Wavelet Convolution")

    Hilbert_handle = findobj(Figure1, 'Tag', 'Hilbert_handle');
    ECHT_handle = findobj(Figure1, 'Tag', 'ECHT_handle');

    if ~isempty(ECHT_handle)
        delete(ECHT_handle)
    end

    if length(Hilbert_handle)>size(Phases,1)
        delete(Hilbert_handle(size(Phases,1)+1:end));
        Hilbert_handle = findobj(Figure1, 'Tag', 'Hilbert_handle');
    end

    if isempty(Hilbert_handle)
        for nchannel = 1:size(Phases,1)
            line(Figure1,CurrentTime, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','Hilbert_handle');
        end
        xlabel(Figure1,PlotAppearance.PhaseSyncPlots.PATimeSeriesXLabel);
        ylabel(Figure1,PlotAppearance.PhaseSyncPlots.PATimeSeriesYLabel);
        title(Figure1,PlotAppearance.PhaseSyncPlots.PATimeSeriesTitle);
        Figure1.FontSize = PlotAppearance.PhaseSyncPlots.PATimeSeriesFontSize;
        Figure1.Color = PlotAppearance.PhaseSyncPlots.PATimeSeriesBackgroundColor;
        Figure1.XLabel.Color = 'k';
        Figure1.XColor = 'k';  
        Figure1.Title.Color = 'k';  
        Figure1.Box ="off";
    else
        for nchannel = 1:length(Hilbert_handle)
            set(Hilbert_handle(nchannel),'XData',CurrentTime ,'YData', Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','Hilbert_handle');
        end
        if length(Hilbert_handle)<size(Phases,1)
            for nchannel = length(Hilbert_handle)+1:size(Phases,1)
                line(Figure1,CurrentTime, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','Hilbert_handle');
            end
        end
    end
%% Echt Mehtod
elseif strcmp(Method,"Endpoint Corrected Hilbert Transform")
    
    ECHT_handle = findobj(Figure1, 'Tag', 'ECHT_handle');
    Hilbert_handle = findobj(Figure1, 'Tag', 'Hilbert_handle');

    if ~isempty(Hilbert_handle)
        delete(Hilbert_handle)
    end
    
    CurrentTime = CurrentTime(1):1/AdjustedDownsampleRate:CurrentTime(1)+((size(Phases,2)-1)/AdjustedDownsampleRate);
    
    if length(ECHT_handle)>size(Phases,1)
        delete(ECHT_handle(size(Phases,1)+1:end));
        ECHT_handle = findobj(Figure1, 'Tag', 'ECHT_handle');
    end

    if isempty(ECHT_handle)
        for nchannel = 1:size(Phases,1)
            line(Figure1,CurrentTime, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','ECHT_handle');
        end
        xlabel(Figure1,PlotAppearance.PhaseSyncPlots.PATimeSeriesXLabel);
        ylabel(Figure1,PlotAppearance.PhaseSyncPlots.PATimeSeriesYLabel);
        title(Figure1,PlotAppearance.PhaseSyncPlots.PATimeSeriesTitle);
        Figure1.FontSize = PlotAppearance.PhaseSyncPlots.PATimeSeriesFontSize;
        Figure1.Color = PlotAppearance.PhaseSyncPlots.PATimeSeriesBackgroundColor;
        Figure1.XLabel.Color = 'k';
        Figure1.XColor = 'k';  
        Figure1.Title.Color = 'k';  
        Figure1.Box ="off";
    else
        for nchannel = 1:length(ECHT_handle)
            set(ECHT_handle(nchannel),'XData',CurrentTime ,'YData', Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','ECHT_handle');
        end
        if length(ECHT_handle)<size(Phases,1)
            for nchannel = length(ECHT_handle)+1:size(Phases,1)
                line(Figure1,CurrentTime, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','ECHT_handle');
            end
        end
    end

end

%% -------- PLOT analyzed signal ---------------
if ShowAnayzedData == 1
    HilbertUnwrap_handle = findobj(Figure2, 'Tag', 'HilbertUnwrap_handle');
    ECHTUnwrap_handle = findobj(Figure2, 'Tag', 'ECHTUnwrap_handle');
    
    CurrentTime = CurrentTime(1):1/AdjustedDownsampleRate:CurrentTime(1)+((size(DataToCompute,2)-1)/AdjustedDownsampleRate);

    if ~isempty(ECHTUnwrap_handle)
        delete(ECHTUnwrap_handle)
    end
    if length(HilbertUnwrap_handle)>size(DataToCompute,1)
        delete(HilbertUnwrap_handle(size(DataToCompute,1)+1:end));
        HilbertUnwrap_handle = findobj(Figure2, 'Tag', 'HilbertUnwrap_handle');
    end

    if isempty(HilbertUnwrap_handle)
        for nchannel = 1:size(DataToCompute,1)
            line(Figure2,CurrentTime(1:size(DataToCompute,2)), DataToCompute(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
        end
        xlabel(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpXLabel);
        ylabel(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpYLabel);
        title(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpTitle);
        Figure2.FontSize = PlotAppearance.PhaseSyncPlots.PAAmpFontSize;
        Figure2.Color = PlotAppearance.PhaseSyncPlots.PAAmpBackgroundColor;
        Figure2.XLabel.Color = 'k';
        Figure2.XColor = 'k';  
        Figure2.Title.Color = 'k';  
        Figure2.Box ="off";
    else
        for nchannel = 1:length(HilbertUnwrap_handle)
            set(HilbertUnwrap_handle(nchannel),'XData',CurrentTime(1:size(DataToCompute,2)) ,'YData', DataToCompute(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
        end
        if length(HilbertUnwrap_handle)<size(DataToCompute,1)
            for nchannel = length(HilbertUnwrap_handle)+1:size(DataToCompute,1)
                line(Figure2,CurrentTime(1:size(DataToCompute,2)), DataToCompute(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
            end
        end
    end
    xlim(Figure2,[CurrentTime(1),CurrentTime(end)])
    xlim(Figure1,[CurrentTime(2),CurrentTime(end)])
end

if ShowAnayzedData == 0
%% -------- PLOT Amplitude of complex result ---------------
%%% Unwraped angles

%% Hilbert Transform
    if strcmp(Method,"Hilbert Transform") || strcmp(Method,"Wavelet Convolution")
    
        HilbertUnwrap_handle = findobj(Figure2, 'Tag', 'HilbertUnwrap_handle');
        ECHTUnwrap_handle = findobj(Figure2, 'Tag', 'ECHTUnwrap_handle');
    
        if ~isempty(ECHTUnwrap_handle)
            delete(ECHTUnwrap_handle)
        end
    
        if length(HilbertUnwrap_handle)>size(PhasesUnwrapped,1)
            delete(HilbertUnwrap_handle(size(PhasesUnwrapped,1)+1:end));
            HilbertUnwrap_handle = findobj(Figure2, 'Tag', 'HilbertUnwrap_handle');
        end
        
        if isempty(HilbertUnwrap_handle)
            
            for nchannel = 1:size(PhasesUnwrapped,1)
                line(Figure2,CurrentTime(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
            end
            xlabel(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpXLabel);
            ylabel(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpYLabel);
            title(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpTitle);
            Figure2.FontSize = PlotAppearance.PhaseSyncPlots.PAAmpFontSize;
            Figure2.Color = PlotAppearance.PhaseSyncPlots.PAAmpBackgroundColor;
            Figure2.XLabel.Color = 'k';
            Figure2.XColor = 'k';  
            Figure2.Title.Color = 'k';  
            Figure2.Box ="off";
        else
            for nchannel = 1:length(HilbertUnwrap_handle)
                set(HilbertUnwrap_handle(nchannel),'XData',CurrentTime(1:size(PhasesUnwrapped,2)) ,'YData', PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
            end
            if length(HilbertUnwrap_handle)<size(PhasesUnwrapped,1)
                for nchannel = length(HilbertUnwrap_handle)+1:size(PhasesUnwrapped,1)
                    line(Figure2,CurrentTime(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
                end
            end
        end
        
        ylim(Figure2,[min(PhasesUnwrapped,[],'all'),max(PhasesUnwrapped,[],'all')])
        if ~LockYLIM
            GlobalYlim = [min(PhasesUnwrapped,[],'all'),max(PhasesUnwrapped,[],'all')];
        end
    
    %% Echt Mehtod
    elseif strcmp(Method,"Endpoint Corrected Hilbert Transform")
        
        ECHTUnwrap_handle = findobj(Figure2, 'Tag', 'ECHTUnwrap_handle');
        HilbertUnwrap_handle = findobj(Figure2, 'Tag', 'HilbertUnwrap_handle');
    
        if ~isempty(HilbertUnwrap_handle)
            delete(HilbertUnwrap_handle)
        end
    
        if length(ECHTUnwrap_handle)>size(PhasesUnwrapped,1)
            delete(ECHTUnwrap_handle(size(PhasesUnwrapped,1)+1:end));
            ECHTUnwrap_handle = findobj(Figure2, 'Tag', 'ECHTUnwrap_handle');
        end
    
        if isempty(ECHTUnwrap_handle)
            for nchannel = 1:size(PhasesUnwrapped,1)
                line(Figure2,CurrentTime(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','ECHTUnwrap_handle');
            end
            xlabel(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpXLabel);
            ylabel(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpYLabel);
            title(Figure2,PlotAppearance.PhaseSyncPlots.PAAmpTitle);
            Figure2.FontSize = PlotAppearance.PhaseSyncPlots.PAAmpFontSize;
            Figure2.Color = PlotAppearance.PhaseSyncPlots.PAAmpBackgroundColor;
            Figure2.XLabel.Color = 'k';
            Figure2.XColor = 'k';  
            Figure2.Title.Color = 'k';  
            Figure2.Box ="off";
        else
    
            for nchannel = 1:length(ECHTUnwrap_handle)
                set(ECHTUnwrap_handle(nchannel),'XData',CurrentTime(1:size(PhasesUnwrapped,2)) ,'YData', PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','ECHTUnwrap_handle');
            end
            if length(ECHTUnwrap_handle)<size(PhasesUnwrapped,1)
                for nchannel = length(ECHTUnwrap_handle)+1:size(PhasesUnwrapped,1)
                    line(Figure2,CurrentTime(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','ECHTUnwrap_handle');
                end
            end
        end
    
        ylim(Figure2,[min(PhasesUnwrapped,[],'all'),max(PhasesUnwrapped,[],'all')])
        if ~LockYLIM
            GlobalYlim = [min(PhasesUnwrapped,[],'all'),max(PhasesUnwrapped,[],'all')];
        end
    end
    
    xlim(Figure1,[CurrentTime(1),CurrentTime(end)])
    xlim(Figure2,[CurrentTime(1),CurrentTime(end)])
end

%% -------- Control Global Ylim ---------------
if LockYLIM
    if isempty(GlobalYlim)
        Lim1 = [min(PhasesUnwrapped) max(PhasesUnwrapped),min(PhasesUnwrapped) max(PhasesUnwrapped)];
        GlobalYlim = [min(Lim1) max(Lim1)];
    else
        Lim1 = [min(PhasesUnwrapped) max(PhasesUnwrapped),min(PhasesUnwrapped) max(PhasesUnwrapped)];
        CurrentYlim = [min(Lim1) max(Lim1)];
        
        checkvar = 0;
        if CurrentYlim(1) < GlobalYlim(1)
            GlobalYlim(1) = CurrentYlim(1);
            checkvar = checkvar + 1;
        end
        if CurrentYlim(2) > GlobalYlim(2)
            GlobalYlim(2) = CurrentYlim(2);
            checkvar = checkvar + 1;
        end
        
        ylim(Figure2,GlobalYlim);
        
    end
end

if ShowAnayzedData == 1
    ylim(Figure2,[min(DataToCompute,[],'all') max(DataToCompute,[],'all')]);
    ylabel(Figure2,'Signal [mV]')
    title(Figure2,'Analyzed Signal All Active Channel')
else
    ylabel(Figure2,'Frequency [Hz]')
    title(Figure2,'Instantaneous Frequency')
end

%% --------------- Handle Events ---------------

if strcmp(EventPlot,"Events")
    Analyse_Main_Window_Plot_Events(Figure1,Data,CurrentTime,EventData,min(Phases,[],'all'),max(Phases,[],'all'),AdjustedDownsampleRate,SelectedEventIndice)
    Analyse_Main_Window_Plot_Events(Figure2,Data,CurrentTime,EventData,GlobalYlim(1),GlobalYlim(2),AdjustedDownsampleRate,SelectedEventIndice)
else
    Eventline_handles = findobj(Figure1,'Type', 'line', 'Tag', 'Events');
    delete(Eventline_handles); 
    Eventline_handles = findobj(Figure2,'Type', 'line', 'Tag', 'Events');
    delete(Eventline_handles); 
end

%% save plotted data in case user wants to save 

CurrentPlotData.PhaseAngleTimesXData = CurrentTime;
CurrentPlotData.PhaseAngleTimesSyncYData = Phases;
CurrentPlotData.PhaseAngleTimesSyncCData = [];
CurrentPlotData.PhaseAngleTimesSyncType = "Phase Angle Time Series";
CurrentPlotData.PhaseAngleTimesSyncXTicks = Figure1.XTickLabel;

%% save plotted data in case user wants to save 

CurrentPlotData.PhaseAmplitudeEnvelopeXData = CurrentTime;
CurrentPlotData.PhaseAmplitudeEnvelopeYData = PhasesUnwrapped;
CurrentPlotData.PhaseAmplitudeEnvelopeCData = [];
CurrentPlotData.PhaseAmplitudeEnvelopeType = "All to All Active Channel Synhcronization Strength (Avg phase differences vector lengths)";
CurrentPlotData.PhaseAmplitudeEnvelopeXTicks = Figure2.XTickLabel;