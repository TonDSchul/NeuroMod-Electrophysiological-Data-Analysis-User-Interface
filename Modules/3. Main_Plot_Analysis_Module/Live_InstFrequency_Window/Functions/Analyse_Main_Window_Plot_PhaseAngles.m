function  [GlobalYlim,CurrentPlotData] = Analyse_Main_Window_Plot_PhaseAngles(Figure1,Figure2,Phases,PhasesUnwrapped,AdjustedDownsampleRate,CurrentTime,GlobalYlim,LockYLIM,ColorMap,Method,PlotAppearance,CurrentPlotData)

%% -------- PLOT Phase Angle Time Series ---------------
%% Hilbert Transform
if strcmp(Method,"Hilbert Transform")

    Hilbert_handle = findobj(Figure1, 'Tag', 'Hilbert_handle');
    ECHT_handle = findobj(Figure1, 'Tag', 'ECHT_handle');

    if ~isempty(ECHT_handle)
        delete(ECHT_handle)
    end

    CurrentTimeHilbert = CurrentTime(1):1/AdjustedDownsampleRate:CurrentTime(1)+((size(Phases,2)-1)/AdjustedDownsampleRate);
    
    if length(Hilbert_handle)>size(Phases,1)
        delete(Hilbert_handle(size(Phases,1)+1:end));
        Hilbert_handle = findobj(Figure1, 'Tag', 'Hilbert_handle');
    end

    if isempty(Hilbert_handle)
        for nchannel = 1:size(Phases,1)
            line(Figure1,CurrentTimeHilbert, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','Hilbert_handle');
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
            set(Hilbert_handle(nchannel),'XData',CurrentTimeHilbert ,'YData', Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','Hilbert_handle');
        end
        if length(Hilbert_handle)<size(Phases,1)
            for nchannel = length(Hilbert_handle)+1:size(Phases,1)
                line(Figure1,CurrentTimeHilbert, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','Hilbert_handle');
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
    
    CurrentTimeEcht = CurrentTime(1):1/AdjustedDownsampleRate:CurrentTime(1)+((size(Phases,2)-1)/AdjustedDownsampleRate);
    
    if length(ECHT_handle)>size(Phases,1)
        delete(ECHT_handle(size(Phases,1)+1:end));
        ECHT_handle = findobj(Figure1, 'Tag', 'ECHT_handle');
    end

    if isempty(ECHT_handle)
        for nchannel = 1:size(Phases,1)
            line(Figure1,CurrentTimeEcht, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','ECHT_handle');
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
            set(ECHT_handle(nchannel),'XData',CurrentTimeEcht ,'YData', Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','ECHT_handle');
        end
        if length(ECHT_handle)<size(Phases,1)
            for nchannel = length(ECHT_handle)+1:size(Phases,1)
                line(Figure1,CurrentTimeEcht, Phases(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PATimeSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','ECHT_handle');
            end
        end
    end

end

%% -------- PLOT Amplitude of complex result ---------------
%%% Unwraped angles

%% Hilbert Transform
if strcmp(Method,"Hilbert Transform")

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
            line(Figure2,CurrentTimeHilbert(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
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
            set(HilbertUnwrap_handle(nchannel),'XData',CurrentTimeHilbert(1:size(PhasesUnwrapped,2)) ,'YData', PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
        end
        if length(HilbertUnwrap_handle)<size(PhasesUnwrapped,1)
            for nchannel = length(HilbertUnwrap_handle)+1:size(PhasesUnwrapped,1)
                line(Figure2,CurrentTimeHilbert(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','HilbertUnwrap_handle');
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
            line(Figure2,CurrentTimeEcht(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','ECHTUnwrap_handle');
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
            set(ECHTUnwrap_handle(nchannel),'XData',CurrentTimeEcht(1:size(PhasesUnwrapped,2)) ,'YData', PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth, 'Color', ColorMap(nchannel,:),'Tag','ECHTUnwrap_handle');
        end
        if length(ECHTUnwrap_handle)<size(PhasesUnwrapped,1)
            for nchannel = length(ECHTUnwrap_handle)+1:size(PhasesUnwrapped,1)
                line(Figure2,CurrentTimeEcht(1:size(PhasesUnwrapped,2)), PhasesUnwrapped(nchannel,:), 'LineWidth', PlotAppearance.PhaseSyncPlots.PAAmpSeriesWidth,'Color', ColorMap(nchannel,:),'Tag','ECHTUnwrap_handle');
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

%% save plotted data in case user wants to save 
if exist("CurrentTimeEcht","var")
    CurrentPlotData.PhaseAngleTimesXData = CurrentTimeEcht;
elseif exist("CurrentTimeHilbert","var")
    CurrentPlotData.PhaseAngleTimesXData = CurrentTimeHilbert;
end
CurrentPlotData.PhaseAngleTimesSyncYData = Phases;
CurrentPlotData.PhaseAngleTimesSyncCData = [];
CurrentPlotData.PhaseAngleTimesSyncType = "Phase Angle Time Series";
CurrentPlotData.PhaseAngleTimesSyncXTicks = Figure1.XTickLabel;

%% save plotted data in case user wants to save 
if exist("CurrentTimeEcht","var")
    CurrentPlotData.PhaseAmplitudeEnvelopeXData = CurrentTimeEcht;
elseif exist("CurrentTimeHilbert","var")
    CurrentPlotData.PhaseAmplitudeEnvelopeXData = CurrentTimeHilbert;
end
CurrentPlotData.PhaseAmplitudeEnvelopeYData = PhasesUnwrapped;
CurrentPlotData.PhaseAmplitudeEnvelopeCData = [];
CurrentPlotData.PhaseAmplitudeEnvelopeType = "All to All Active Channel Synhcronization Strength (Avg phase differences vector lengths)";
CurrentPlotData.PhaseAmplitudeEnvelopeXTicks = Figure2.XTickLabel;