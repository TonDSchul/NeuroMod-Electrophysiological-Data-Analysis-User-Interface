function Continous_Spikes_Resize_Figures(MainFigure,SpikeRateTimeFig,SpikeRateChannelFig,AnalysisMethod,Cluster)


if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
    if ~strcmp(Cluster,"All")
        MainFigure.Position = [320,115,1017,735]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.513678284182306,0.513678284182306];
        % 
        % SpikeRateTimeFig.Position = [375,12,990,240];
        % SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.204711033275,0.204711033275];
    else
        MainFigure.Position = [282,135,1057,690]; % x y width height
        MainFigure.PlotBoxAspectRatio = [1,0.480678284182306,0.480678284182306];
        % 
        % SpikeRateTimeFig.Position = [300,18,1067,243];
        % SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17614711033275,0.17614711033275];

    end
elseif strcmp(AnalysisMethod,"Average Waveforms Across Channel") || strcmp(AnalysisMethod,"Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Cumulative Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Spike Triggered LFP")
    MainFigure.Position = [335,110,1000,780]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.475678284182306,0.475678284182306];
    % 
    % SpikeRateTimeFig.Position = [282,15,1083,243];
    % SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17614711033275,0.17614711033275];
else
    MainFigure.Position = [285,120,1050,760]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.435678284182306,0.435678284182306];
    % 
    % SpikeRateTimeFig.Position = [282,15,1083,243];
    % SpikeRateTimeFig.PlotBoxAspectRatio = [1,0.17614711033275,0.17614711033275];
end

%% Ensure hor and vert allignment of lower plot in respective to upperm plot --> just set position of main plot, the allign rest around it
ax1 = MainFigure;
ax2 = SpikeRateTimeFig;
% Make sure layout updates
drawnow;

inner1 = ax1.InnerPosition;
inner2 = ax2.InnerPosition;

% Horizontal alignment
inner2(1) = inner1(1);
inner2(3) = inner1(3);

% Vertical alignment (stack directly under top plot)
inner2(2) = inner1(2) - inner2(4)/2.5;  % place bottom plot directly below top

% Apply new position
ax2.InnerPosition = inner2;


%% Ensure horizontal and vertical alignment of right plot relative to upper main plot
ax1 = MainFigure;            % upper-left plot
ax3 = SpikeRateChannelFig;   % right plot

% Make sure layout updates
drawnow;

inner1 = ax1.InnerPosition;
inner3 = ax3.InnerPosition;

% Horizontal alignment → start where main plot ends
inner3(1) = inner1(1) + inner1(3);   % left edge = right edge of main plot

% Vertical alignment → same vertical span as main plot
inner3(2) = inner1(2)+inner2(4)/1.54;               % same bottom edge
inner3(3) = 300;               % WIDTH
inner3(4) = 479;               % HEIGHT

% Apply new position
ax3.InnerPosition = inner3;