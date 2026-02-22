function Event_Spikes_Resize_Figures(MainFigure,SpikeRateTimeFig,SpikeRateChannelFig,AnalysisMethod,Cluster)

%________________________________________________________________________________________
%% Function to set position and aspect ration of figures in event spike analysis window so that spike rates are alligned with the main plot in the middle

% Inputs:
% 1. MainFigure : app.UIAxes object to the plot in the middle
% 2. SpikeRateTimeFig: app.UIAxes object to the plot spike rate over time
% (under main plot in the middle)
% 3. SpikeRateChannelFig: app.UIAxes object to the plot spike rate over
% channel (to the right of the main plot in the middle)
% 4. AnalysisMethod: char, Analysis plot choosen in cont spike analysis window,
% see below
% 5. Cluster: NOT USED YET

% Output:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if ~strcmp(AnalysisMethod,"Spike Tirggered Average")
    MainFigure.Position = [347,115,1043,729]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.539678284182306,0.539678284182306];
else
    MainFigure.Position = [372,71,1015,840]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.522678284182306,0.522678284182306];
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
inner3(2) = inner1(2)+inner2(4)/1.62;               % same bottom edge
inner3(3) = 300;               % WIDTH
inner3(4) = 517;               % HEIGHT

% Apply new position
ax3.InnerPosition = inner3;