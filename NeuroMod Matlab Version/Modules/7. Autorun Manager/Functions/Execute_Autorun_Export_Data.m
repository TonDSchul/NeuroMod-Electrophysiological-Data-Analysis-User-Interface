function Execute_Autorun_Export_Data(AutorunConfig,CurrentAnalysisWindow,Data,executableFolder,CurrentAnalysis,CurrentPlotData,ExportedAlready)

%% Check if data available
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

%% Export results from cont. spike analysis
if contains(CurrentAnalysisWindow,"Continuous Spikes")   
    if contains(CurrentAnalysis,"Template") || contains(CurrentAnalysis,"Templates")
        return;
    end

    StartTime = 0;
    %% Always
    if ExportedAlready==0 && ~contains(CurrentAnalysisWindow,"Unit")
        % Spike Rate over Time
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," All Spikes Spike Rate over Time ",CurrentAnalysis),1);
        % Spike Rate over Channel
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," All Spikes Spike Rate over Channel ",CurrentAnalysis),1);
    end

    if contains(CurrentAnalysisWindow,"Unit")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," Spike Rate Unit over Time ",CurrentAnalysis),1);
    end

    if contains(CurrentAnalysisWindow,"Unit")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," Unit Spike Times ",CurrentAnalysis),1);
    else
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous ",Data.Info.Sorter," Spike Times ",CurrentAnalysis),1);
    end
end

%% Export results from Static Spectrum analysis
if contains(CurrentAnalysisWindow,"Continuous Static Spectrum")  
    StartTime = 0;
    if ExportedAlready==0
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Static_Spectrum ",CurrentAnalysis),1);
    elseif ExportedAlready==1 && ~contains(CurrentAnalysis,"Individual")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Static_Spectrum ",CurrentAnalysis),1);
    end
end

%% Export results from Continuous Unit analysis
if contains(CurrentAnalysisWindow,"Continuous Unit")  
    TimeRangePlot = size(Data.Spikes.Waveforms,2)/Data.Info.NativeSamplingRate;
    StartTime = 0;
    if contains(CurrentAnalysis,"Waveform")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous Unit(s) Waveform Analysis Plot"),1);
    elseif contains(CurrentAnalysis,"ISI")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous Unit(s) ISI Analysis Plot"),1);
    elseif contains(CurrentAnalysis,"Auto")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,strcat("Continuous Unit(s) Autocorrelogram Analysis Plot"),1);
    end
end

if contains(CurrentAnalysisWindow,"Event ERP") && ~contains(CurrentAnalysisWindow,"Grid") 
    TimeRangePlot = Data.Info.EventRelatedDataTimeRange(end);
    StartTime = 0;
    
    Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format, executableFolder,TimeRangePlot,StartTime,"Event Related Potential over Events",1);
    Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format, executableFolder,TimeRangePlot,StartTime,"Event Related Potential over Channel",1);
end

if contains(CurrentAnalysisWindow,"Event ERP") && contains(CurrentAnalysisWindow,"Grid") 
    TimeRangePlot = Data.Info.EventRelatedDataTimeRange(end);
    StartTime = 0;
    
    Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format, executableFolder,TimeRangePlot,StartTime,"Event Related Potential over Grid",1);
end


if contains(CurrentAnalysisWindow,"Event CSD")  
    TimeRangePlot = Data.Info.EventRelatedDataTimeRange(end);
    StartTime = 0;
    
    Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format, executableFolder,TimeRangePlot,StartTime,"Current Source Density Analysis",1);
end


if contains(CurrentAnalysisWindow,"Event Related Static Spectrum")  
    TimeRangePlot = Data.Info.EventRelatedDataTimeRange(end);
    StartTime = 0;
    
    if strcmp(CurrentAnalysis,"Band Power Individual Channel")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,"Event Related Static Spectrum Individual Channel",1);
    elseif strcmp(CurrentAnalysis,"Band Power over Depth")
        Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,"Event Related Static Spectrum over Depth",1);
    end
end

if contains(CurrentAnalysisWindow,"Event TF")  
   
    PlotMethods = string(strsplit(CurrentAnalysis,','));
    
    TimeRangePlot = Data.Info.EventRelatedDataTimeRange(end);
             
    StartTime = 0;
    
    if contains(PlotMethods,"Single Channel ERP Spectogram")
        AddonName = "Event Related Single Channel ERP Spectogram";
    else
        AddonName = strcat("Event Related Time Varying Wavelet Coherence"," ",AutorunConfig.AnalyseEventDataModule.CoherenceAnalysis);
    end
    
    % if contains(PlotMethods(1),"Time Varying")
    %     AddonName = strcat(AddonName," ",AutorunConfig.AnalyseEventDataModule.CoherenceAnalysis);
    % end

    Utility_Get_Plot_Data(CurrentPlotData,Data,AutorunConfig.Export.Format,executableFolder,TimeRangePlot,StartTime,AddonName,1);

end