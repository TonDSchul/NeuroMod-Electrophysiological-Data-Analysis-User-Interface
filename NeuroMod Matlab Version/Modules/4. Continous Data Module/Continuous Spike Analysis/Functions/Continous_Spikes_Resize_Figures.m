function Continous_Spikes_Resize_Figures(MainFigure,SpikeRateTimeFig,SpikeRateChannelFig,AnalysisMethod,Cluster)


if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
    if ~strcmp(Cluster,"All")
        MainFigure.Position = [320,115,1017,735]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.513678284182306,0.513678284182306];
        % 
        SpikeRateTimeFig.Position = [375,12,990,240];
        SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.204711033275,0.204711033275];
    else
        MainFigure.Position = [282,135,1057,690]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.480678284182306,0.480678284182306];
        % 
        SpikeRateTimeFig.Position = [300,18,1067,243];
        SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17614711033275,0.17614711033275];

    end
elseif strcmp(AnalysisMethod,"Average Waveforms Across Channel") || strcmp(AnalysisMethod,"Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Cumulative Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Spike Triggered LFP")
    MainFigure.Position = [335,110,1000,780]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.475678284182306,0.475678284182306];
    % 
    SpikeRateTimeFig.Position = [282,15,1083,243];
    SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17614711033275,0.17614711033275];
else
    MainFigure.Position = [285,120,1050,760]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.435678284182306,0.435678284182306];
    % 
    SpikeRateTimeFig.Position = [282,15,1083,243];
    SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17614711033275,0.17614711033275];
end
