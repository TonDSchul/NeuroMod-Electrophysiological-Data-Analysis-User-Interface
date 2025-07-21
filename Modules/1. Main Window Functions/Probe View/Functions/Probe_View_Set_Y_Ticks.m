function Probe_View_Set_Y_Ticks(Figure,yMax,yMin, CreateProbeWindow, ChannelClicked)

%________________________________________________________________________________________
%% Function to reverse just the y ticks and y tick labels for the probe view window and probe creation window

% This function is executed every time the probe view window is newly
% opened/plotted. Only executed, if y limits change

% Inputs: 
% 1. Figure: app.UIAxes object of the probe view window
% 2. yMax: double, max value for yticks
% 3. yMin: double, min value for yticks
% 4. CreateProbeWindow: double, either 1 or 0, 1 if probe window is newly
% created, 0 if its for the probe view window when data was already
% exctracted
% 5: ChannelClicked: double if user activate a channel with channel nr. (to check whether min/max values change and this has to be excuted)

% Outputs:
% 1. Waveforms: nchannel x nwaveforms x ntime matrix saving each extract
% waveform
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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
    %disp('Updated YTicks and YTickLabels.');
else
    %disp('YTickLabel "0" is already at the ymax position. No update required.');
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