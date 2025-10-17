function Event_Spikes_Resize_Figures(MainFigure,SpikeRateTimeFig,SpikeRateChannelFig,AnalysisMethod,Cluster)

if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
    if ~strcmp(Cluster,"All")
        MainFigure.Position = [370,62,1030,840]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.532678284182306,0.532678284182306];
        % 
        SpikeRateTimeFig.Position = [400,2,1020,245];
        SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.18614711033275,0.18614711033275];
    else
        MainFigure.Position = [389,71,1010,820]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.522678284182306,0.522678284182306];
        % 
        SpikeRateTimeFig.Position = [400,2,1020,245];
        SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.18614711033275,0.18614711033275];

    end
else
    MainFigure.Position = [372,71,1015,840]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.522678284182306,0.522678284182306];
    % 
    SpikeRateTimeFig.Position = [400,2,1020,245];
    SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.18614711033275,0.18614711033275];
end
