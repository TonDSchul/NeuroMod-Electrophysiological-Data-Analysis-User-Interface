function Probe_View_Set_Y_Ticks(Figure,yMax,yMin, CreateProbeWindow, ChannelClicked)

% Calculate 5 equally spaced values between yMin and yMax
numTicks = 5;
yTicks = linspace(yMin, yMax, numTicks);

% Reverse the labels to display them in the desired order
yTickLabels = flip(arrayfun(@num2str, yTicks, 'UniformOutput', false));

% Check if the label '0' is already at yMax position
if ~isequal(yTickLabels{end}, '0') || CreateProbeWindow && isempty(ChannelClicked) 
    % Set y ticks and y tick labels only if '0' is not at the top
    Figure.YTick = yTicks;         % Tick positions in ascending order
    Figure.YTickLabel = yTickLabels; % Reversed labels
    disp('Updated YTicks and YTickLabels.');
else
    disp('YTickLabel "0" is already at the ymax position. No update required.');
end

% % Calculate 5 equally spaced values between yMin and yMax
% numTicks = 5;
% yTicks = linspace(yMin, yMax, numTicks);
% 
% % Reverse the labels to display them in the desired order
% yTickLabels = flip(arrayfun(@num2str, yTicks, 'UniformOutput', false));
% 
% % Set y ticks and y tick labels
% Figure.YTick = yTicks;         % Tick positions in ascending order
% Figure.YTickLabel = yTickLabels; % Reversed labels