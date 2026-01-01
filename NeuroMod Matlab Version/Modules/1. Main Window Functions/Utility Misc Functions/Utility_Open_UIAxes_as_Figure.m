function Utility_Open_UIAxes_as_Figure(Data,Figure,Window)

CopyColorBar = 0;
CopyLegend = 0;
CopySecondAxis = 0;

if strcmp(Window,"ERPSingleChannel")
    CopyColorBar = 1;
    CopyLegend = 1;
    CopySecondAxis = 1;
elseif strcmp(Window,"ERPMultipleChannel")
    CopyColorBar = 0;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif strcmp(Window,"EventCSD")
    CopyColorBar = 1;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif strcmp(Window,"EventStaticSpectrum2")
    CopyColorBar = 0;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif strcmp(Window,"EventTF")
    CopyColorBar = 1;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif strcmp(Window,"LiveCSD")
    CopyColorBar = 1;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif strcmp(Window,"LivePowerEstimate")
    CopyColorBar = 0;
    CopyLegend = 0;
    CopySecondAxis = 0;
    elseif strcmp(Window,"LiveSpectogram")
    CopyColorBar = 1;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif strcmp(Window,"LiveSpikeRate")
    CopyColorBar = 0;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif strcmp(Window,"ConStaticSpectrum Band Power Individual Channel")
    CopyColorBar = 0;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif strcmp(Window,"ConStaticSpectrum Band Power over Depth")
    CopyColorBar = 1;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif strcmp(Window,"ConStaticSpectrum2")
    CopyColorBar = 0;
    CopyLegend = 1;
    CopySecondAxis = 0;
    %% Con Spikes
elseif contains(Window,"ConSpikes") && contains(Window,"Spike Map")
    CopyColorBar = 1;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif contains(Window,"ConSpikes") && contains(Window,"Spike Amplitude Density Along Depth")
    CopyColorBar = 1;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif contains(Window,"ConSpikes") && contains(Window,"Cumulative Spike Amplitude Density Along Depth")
    CopyColorBar = 1;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif contains(Window,"ConSpikes") && contains(Window,"Spike Triggered LFP")
    CopyColorBar = 1;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif contains(Window,"ConSpikes") && contains(Window,"Average Waveforms Across Channel")
    CopyColorBar = 1;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif contains(Window,"ConSpikes") && contains(Window,"Spike Waveforms")
    CopyColorBar = 0;
    CopyLegend = 0;
    CopySecondAxis = 0;

elseif contains(Window,"ConSpikes") && contains(Window,"SpikeRateTime")
    CopyColorBar = 0;
    CopyLegend = 0;
    CopySecondAxis = 1;
elseif contains(Window,"ConSpikes") && contains(Window,"SpikeRateChannel")
    CopyColorBar = 0;
    CopyLegend = 0;
    CopySecondAxis = 0;
%% event spikes
elseif contains(Window,"EventSpikes") && contains(Window,"Spike Map")
    CopyColorBar = 1;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif contains(Window,"EventSpikes") && contains(Window,"Heatmap")
    CopyColorBar = 1;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif contains(Window,"EventSpikes") && contains(Window,"Triggered Average")
    CopyColorBar = 1;
    CopyLegend = 1;
    CopySecondAxis = 0;
elseif strcmp(Window,"MainWindow")
    CopyColorBar = 0;
    CopyLegend = 0;
    CopySecondAxis = 0;
elseif contains(Window,"EventStaticSpectrum")
    if contains(Window,"Depth")
        CopyColorBar = 1;
        CopyLegend = 0;
        CopySecondAxis = 0;
    else
        CopyColorBar = 0;
        CopyLegend = 0;
        CopySecondAxis = 0;
    end
end

% Create new figure + axes
f = figure;
destAx = axes('Parent', f);

if CopySecondAxis || strcmp(Window,"EventStaticSpectrum2") || strcmp(Window,"ConStaticSpectrum2") || contains(Window,"SpikeRateTime")
    yyaxis(Figure,'left');
end
%% Copy Left Plot Axis

leftChildren = allchild(Figure);
copyobj(leftChildren, destAx);
destAx.YColor = Figure.YColor;
destAx.YLim   = Figure.YLim;
destAx.YLabel.String = Figure.YLabel.String;

% --- Shared properties ---
destAx.XLim = Figure.XLim;
destAx.XLabel.String = Figure.XLabel.String;
destAx.Title.String  = Figure.Title.String;
destAx.XTick = Figure.XTick;
destAx.YTick = Figure.YTick;

if strcmp(Figure.YDir,'reverse')
    destAx.YDir = 'reverse';
end

%% COLORBAR
if CopyColorBar
    cbar = findall(Figure.Parent, 'Type', 'Colorbar');
    if ~isempty(cbar)
        colormap(destAx, colormap(Figure));
        cbNew = colorbar(destAx);
        cbNew.Label.String = cbar.Label.String;
        cbNew.Ticks = cbar.Ticks;
        cbNew.Limits = cbar.Limits;
    end
end

%% LEGEND
if CopyLegend
    lgd = findobj(Figure.Parent, 'Type', 'Legend');
    % Get legend strings
    if ~isempty(lgd)
        lgdStrings = lgd.String;
        % Recreate legend on destination axes
        newLgd = legend(destAx, lgdStrings);
        newLgd.Location = lgd.Location;
        newLgd.Position = lgd.Position;
    else
        lgd = Figure.Legend;
        if ~isempty(lgd)
            lgdStrings = lgd.String;
            % Recreate legend on destination axes
            newLgd = legend(destAx, lgdStrings);
            newLgd.Location = lgd.Location;
            newLgd.Position = lgd.Position;
        end
    end
end

%% Copy Right Plot Axis
if CopySecondAxis
    yyaxis(Figure,'right');
    rightChildren = allchild(Figure);
    if ~isempty(rightChildren)
        yyaxis(destAx,'right');
        copyobj(rightChildren, destAx);
        destAx.YColor = Figure.YColor;
        destAx.YLim   = Figure.YLim;
        destAx.YLabel.String = Figure.YLabel.String;
        destAx.YDir   = Figure.YDir;   % preserve direction
    end
end