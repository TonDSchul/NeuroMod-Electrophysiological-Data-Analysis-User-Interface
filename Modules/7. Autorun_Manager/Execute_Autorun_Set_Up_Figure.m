function [Figure] = Execute_Autorun_Set_Up_Figure(Figure,AddXticks,YReverse,XData,NumXTicksToShow,XLabel,Ylabel,Title,Fontsize)

if AddXticks
    % Add xtick labels back
    % Choose a subset of x values for xticks
    numTicks = NumXTicksToShow; % Desired number of ticks
    tickIndices = round(linspace(1, length(XData), numTicks));
    xtickValues = XData(tickIndices); % Select the x values at these indices
    % Set xticks and xticklabels for Figure
    xticks(Figure, xtickValues); % Set the chosen x values as ticks
    xticklabels(Figure, arrayfun(@num2str, xtickValues, 'UniformOutput', false)); % Generate labels for the x-ticks
end

if ~isempty(XLabel)
    xlabel(Figure,XLabel);
end
if ~isempty(Ylabel)
    ylabel(Figure,Ylabel);
end
if ~isempty(Title)
    title(Figure,Title);
end

if strcmp(YReverse,"Left Axis Only")
    set(Figure, 'YDir', 'reverse');
elseif strcmp(YReverse,"Both Axis")
    yyaxis(Figure, 'left');
    set(Figure, 'YDir','reverse');
    yyaxis(Figure, 'right');
    set(Figure, 'YDir','reverse');
end

Figure.FontSize = Fontsize;