function  [GlobalYlim] = Analyse_Main_Window_Plot_ECHT(Figure1,Figure2,ECHT_Phases,HILBERT_Phases,ECHTResultUnwrap,HILBERT_PhasesUnwrap,AdjustedDownsampleRate,FilterSettings,CurrentTime,GlobalYlim,LockYLIM)

ECHT_handle = findobj(Figure1, 'Tag', 'ECHT_handle');
Hilbert_handle = findobj(Figure1, 'Tag', 'Hilbert_handle');

CurrentTimeEcht = CurrentTime(1):1/AdjustedDownsampleRate:CurrentTime(1)+((length(ECHT_Phases)-1)/AdjustedDownsampleRate);
CurrentTimeHilbert = CurrentTime(1):1/AdjustedDownsampleRate:CurrentTime(1)+((length(HILBERT_Phases)-1)/AdjustedDownsampleRate);

if isempty(ECHT_handle)
    line(Figure1,CurrentTimeEcht, ECHT_Phases, 'LineWidth', 1.5, 'Color', [0 0.45 0.74],'Tag','ECHT_handle');
    line(Figure1,CurrentTimeHilbert, HILBERT_Phases, 'LineWidth', 1.5,'Color', [0.85 0.33 0.1],'Tag','Hilbert_handle');
    ECHT_handle = findobj(Figure1, 'Tag', 'ECHT_handle');
    Hilbert_handle = findobj(Figure1, 'Tag', 'Hilbert_handle');
else
    set(ECHT_handle,'XData',CurrentTimeEcht ,'YData', ECHT_Phases, 'LineWidth', 1.5, 'Color', [0 0.45 0.74],'Tag','ECHT_handle');
    set(Hilbert_handle,'XData',CurrentTimeHilbert ,'YData', HILBERT_Phases, 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1],'Tag','Hilbert_handle');
end

%%% Unwraped angles
ECHTUnwrap_handle = findobj(Figure2, 'Tag', 'ECHTUnwrap_handle');
HilbertUnwrap_handle = findobj(Figure2, 'Tag', 'HilbertUnwrap_handle');

CurrentTimeEcht = CurrentTimeEcht(1:end-1);
CurrentTimeHilbert = CurrentTimeHilbert(1:end-1);

if isempty(ECHTUnwrap_handle)
    line(Figure2,CurrentTimeEcht, ECHTResultUnwrap, 'LineWidth', 1.5, 'Color', [0 0.45 0.74],'Tag','ECHTUnwrap_handle');
    line(Figure2,CurrentTimeHilbert, HILBERT_PhasesUnwrap, 'LineWidth', 1.5,'Color', [0.85 0.33 0.1],'Tag','HilbertUnwrap_handle');
    ECHTUnwrap_handle = findobj(Figure2, 'Tag', 'ECHT_handle');
    HilbertUnwrap_handle = findobj(Figure2, 'Tag', 'Hilbert_handle');
else
    set(ECHTUnwrap_handle,'XData',CurrentTimeEcht ,'YData', ECHTResultUnwrap, 'LineWidth', 1.5, 'Color', [0 0.45 0.74],'Tag','ECHTUnwrap_handle');
    set(HilbertUnwrap_handle,'XData',CurrentTimeHilbert ,'YData', HILBERT_PhasesUnwrap, 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1],'Tag','HilbertUnwrap_handle');
end

if LockYLIM
    if isempty(GlobalYlim)
        Lim1 = [min(ECHTResultUnwrap) max(ECHTResultUnwrap),min(HILBERT_PhasesUnwrap) max(HILBERT_PhasesUnwrap)];
        GlobalYlim = [min(Lim1) max(Lim1)];
    else
        Lim1 = [min(ECHTResultUnwrap) max(ECHTResultUnwrap),min(HILBERT_PhasesUnwrap) max(HILBERT_PhasesUnwrap)];
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
        if checkvar > 0
            ylim(Figure2,GlobalYlim);
        end
    end
else
    Lim1 = [min(ECHTResultUnwrap) max(ECHTResultUnwrap),min(HILBERT_PhasesUnwrap) max(HILBERT_PhasesUnwrap)];
    ylim(Figure2,[min(Lim1) max(Lim1)]);
end
%ylim(Figure1,[min(HILBERT_Phases) max(HILBERT_Phases)]);