function Continous_Spikes_Resize_Figures(MainFigure,SpikeRateTimeFig,SpikeRateChannelFig,AnalysisMethod,Cluster)

%________________________________________________________________________________________
%% Function to set position and aspect ration of figures in cont. spike analysis window so that spike rates are alligned with the main plot in the middle

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

if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
    MainFigure.Position = [320,122,1017,715]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.51678284182306,0.511678284182306];
elseif strcmp(AnalysisMethod,"Average Waveforms Across Channel") || strcmp(AnalysisMethod,"Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Cumulative Spike Amplitude Density Along Depth") || strcmp(AnalysisMethod,"Spike Triggered LFP")
    MainFigure.Position = [335,111,1000,785]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.475678284182306,0.475678284182306];
else
    MainFigure.Position = [285,120,1050,760]; % x y width height
    MainFigure.PlotBoxAspectRatio = [1,0.435678284182306,0.435678284182306];
end

if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
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
    inner2(2) = inner1(2) - inner2(4)/2.38;  % place bottom plot directly below top
    
    % Apply new position
    ax2.InnerPosition = inner2;
else
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
    inner2(2) = inner1(2) - inner2(4)/2.38;  % place bottom plot directly below top
    
    inner2(2) = inner2(2)+15; % yposition

    % Apply new position
    ax2.InnerPosition = inner2;
end


if strcmp(AnalysisMethod,"Spike Map") || strcmp(AnalysisMethod,"SpikeRateBinSizeChange")
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
    inner3(2) = inner1(2)+inner2(4)/1.65;               % same bottom edge
    inner3(3) = 300;               % WIDTH
    inner3(4) = 484;               % HEIGHT
    
    inner3(2) = inner3(2) - 3.5;

    % Apply new position
    ax3.InnerPosition = inner3;
else
    %% Ensure horizontal and vertical alignment of right plot relative to upper main plot
    ax1 = MainFigure;            % upper-left plot
    ax3 = SpikeRateChannelFig;   % right plot
    
    % Make sure layout updates
    drawnow;
    
    inner1 = ax1.InnerPosition;
    inner3 = ax3.InnerPosition;
    
    % Horizontal alignment → start where main plot ends
    inner3(1) = inner1(1) + inner1(3);   % left edge = right edge of main plot
    
    if ~strcmp(AnalysisMethod,"Spike Waveforms")
        % Vertical alignment → same vertical span as main plot
        inner3(2) = inner1(2)+inner2(4)/1.15;               % same bottom edge
        inner3(3) = 300;               % WIDTH
        inner3(4) = 438;               % HEIGHT
    else
        % Vertical alignment → same vertical span as main plot
        inner3(2) = inner1(2)+inner2(4)/1.2;               % same bottom edge
        inner3(3) = 300;               % WIDTH
        inner3(4) = 438;               % HEIGHT
    end

    inner3(2) = inner3(2) + 4;
    
    % Apply new position
    ax3.InnerPosition = inner3;

end