function Continous_Spikes_Resize_Figures(MainFigure,SpikeRateTimeFig,SpikeRateChannelFig,AnalysisMethod,Cluster)

if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
    if ~strcmp(Cluster,"All")
        MainFigure.Position = [338,123,998,715]; % heigth width xpos ypos
        MainFigure.PlotBoxAspectRatio = [1,0.509678284182306,0.509678284182306];
        % 
        SpikeRateTimeFig.Position = [355,10,1011,243];
        SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.19614711033275,0.19614711033275];
    else
        

    end
elseif strcmp(AnalysisMethod,"Average Waveforms Across Channel") || strcmp(AnalysisMethod,"Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Cumulative Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Spike Triggered LFP")
    MainFigure.Position = [338,123,998,715]; % heigth width xpos ypos
    MainFigure.PlotBoxAspectRatio = [1,0.509678284182306,0.509678284182306];
    % 
    SpikeRateTimeFig.Position = [343,9,1022,205];
    SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17014711033275,0.17014711033275];
else
    MainFigure.Position = [266,120,1070,760]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.435678284182306,0.435678284182306];
    % 
    SpikeRateTimeFig.Position = [282,15,1083,243];
    SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17614711033275,0.17614711033275];
end
