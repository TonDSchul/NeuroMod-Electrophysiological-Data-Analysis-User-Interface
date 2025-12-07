function Execute_Autorun_Export_Data(AutorunConfig,CurrentAnalysisWindow,Data,executableFolder,CurrentAnalysis,CurrentPlotData,ExportedAlready)

if isempty(CurrentPlotData)
    warning("No analysis data found to export! Please check the order of modules in your config file!")
    return;
end

if contains(CurrentAnalysisWindow,"Continuous")
    TimeRangePlot = Data.Time(end);
else
    if isfield(Data.Info,'EventRelatedDataTimeRange')
        TimeRangePlot = Data.Info.EventRelatedDataTimeRange(end);
    else
        warning("No event analysis data found to export! Please check the order of modules in your config file!")
        return;
    end
end

if contains(CurrentAnalysisWindow,"Continuous Spikes")   
    if contains(CurrentAnalysis,"Template") || contains(CurrentAnalysis,"Templates")
        return;
    end

    StartTime = 0;
    %% Always
    if ExportedAlready==0 && ~contains(CurrentAnalysisWindow,"Unit")
        % Spike Rate over Time
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," All Spikes Spike Rate over Time ",CurrentAnalysis));
        % Spike Rate over Channel
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," All Spikes Spike Rate over Channel ",CurrentAnalysis));
    end

    if contains(CurrentAnalysisWindow,"Unit")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," Spike Rate Unit over Time ",CurrentAnalysis));
    end

    if contains(CurrentAnalysisWindow,"Unit")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," Unit Spike Times ",CurrentAnalysis));
    else
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," Spike Times ",CurrentAnalysis));
    end
end

if contains(CurrentAnalysisWindow,"Continuous Static Spectrum")  
    StartTime = 0;
    if ExportedAlready==0
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Static_Spectrum ",CurrentAnalysis));
    elseif ExportedAlready==1 && ~contains(CurrentAnalysis,"Individual")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Static_Spectrum ",CurrentAnalysis));
    end
end

if contains(CurrentAnalysisWindow,"Continuous Unit")  
    TimeRangePlot = size(Data.Spikes.Waveforms,2)/Data.Info.NativeSamplingRate;
    StartTime = 0;

    if contains(CurrentAnalysis,"Waveform")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous Unit(s) Waveform Analysis Plot"));
    elseif contains(CurrentAnalysis,"ISI")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous Unit(s) ISI Analysis Plot"));
    elseif contains(CurrentAnalysis,"Auto")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous Unit(s) Autocorrelogram Analysis Plot"));
    end
end
