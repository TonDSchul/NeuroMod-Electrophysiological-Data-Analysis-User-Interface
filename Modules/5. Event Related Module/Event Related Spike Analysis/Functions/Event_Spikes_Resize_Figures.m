function Event_Spikes_Resize_Figures(MainFigure,SpikeRateTimeFig,SpikeRateChannelFig,AnalysisMethod,Cluster)

if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
    if ~strcmp(Cluster,"All")
        MainFigure.Position = [389,71,998,820]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.542678284182306,0.542678284182306];
        % 
        SpikeRateTimeFig.Position = [400,2,1020,245];
        SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.18614711033275,0.18614711033275];
    else
        MainFigure.Position = [389,71,998,820]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.542678284182306,0.542678284182306];
        % 
        SpikeRateTimeFig.Position = [400,2,1020,245];
        SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.18614711033275,0.18614711033275];

    end
else
    MainFigure.Position = [389,71,998,820]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.542678284182306,0.542678284182306];
    % 
    SpikeRateTimeFig.Position = [400,2,1020,245];
    SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.18614711033275,0.18614711033275];
end
