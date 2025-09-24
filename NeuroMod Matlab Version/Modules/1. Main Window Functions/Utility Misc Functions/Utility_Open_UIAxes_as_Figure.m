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
elseif strcmp(Window,"LiveSpikeRate")
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

if CopySecondAxis || strcmp(Window,"EventStaticSpectrum2")
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