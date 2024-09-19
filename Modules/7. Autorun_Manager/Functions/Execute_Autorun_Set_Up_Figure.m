function [Figure] = Execute_Autorun_Set_Up_Figure(Figure,AddXticks,YReverse,XData,NumXTicksToShow,XLabel,Ylabel,Title,Fontsize)

%________________________________________________________________________________________
%% This function costumizes a function based on the inputs

% Inputs:
% 1. Figure: figure axes handle to modify
% AddXticks: 1 to add costum x tick labels, 0 otherwise
% YReverse: 1 to reverse y axis, 0 otherwise
% XData: string array, All Xtick values if AddXticks=1
% NumXTicksToShow: double number of xticks to show in plot if AddXticks=1
% XLabel: char, costum x label
% Ylabel: char, costum y label
% Title: char, costum title
% Fontsize: double, costum fontsize
%
% Output:
% 1. Figure: modifed figure axes handle 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if AddXticks
    % Add xtick labels back
    % Choose a subset of x values for xticks
    numTicks = NumXTicksToShow; % Desired number of ticks
    tickIndices = round(linspace(1, length(XData), numTicks));
    xtickValues = XData(tickIndices); % Select the x values at these indices
    
    if length(unique(xtickValues))==length(tickIndices)
        % Set xticks and xticklabels for Figure
        xticks(Figure, xtickValues); % Set the chosen x values as ticks
        xticklabels(Figure, arrayfun(@num2str, xtickValues, 'UniformOutput', false)); % Generate labels for the x-ticks
    end
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