function Analyse_Main_Window_Plot_Events(Figure,Data,Time,EventData,MinValue,MaxValue,CurrentSampleRate,SelectedEventIndice)

if isempty(EventData)
    return;
end
%% --------------- Handle Events ---------------


% 1. Raw Take event indicies und time plus samplerate --> downsample
% 2. Calculate indicies based on time und sample rate --> check 1 vs 2
% 2.:
DownsampleFactor = Data.Info.NativeSamplingRate/CurrentSampleRate;
if DownsampleFactor ~= 0
    EventData = floor(Data.Events{SelectedEventIndice}/DownsampleFactor);
else
    EventData = Data.Events{SelectedEventIndice};
end
SampleTimes = round(Time(1)*CurrentSampleRate):1:round(Time(end)*CurrentSampleRate);
StartIndex = SampleTimes(1);
StopIndex = SampleTimes(end);
%% Downsampling: Events handled seperately. This is bc. event times are save in respect to raw data Time.
%% Time points saved in there are therefore not necessary the same as in the downsampled Time vector.
% Therefore, closest value of the event Time to the downsampled
% Time vector has to be found. (When eventtime in range of downsampled Time)
if ~isempty(EventData)
    TempEventIndicies = EventData >= StartIndex & EventData <= StopIndex;
    EventSamples = EventData(TempEventIndicies)-(StartIndex-1);
   
    EventIndicies = zeros(size(Time));
    EventIndicies(EventSamples) = 1;
else
    EventIndicies = 0;
end

if sum(EventIndicies) == 0
    Eventline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Events');
    delete(Eventline_handles(1:end));  
end

if sum(EventIndicies) > 0
    Eventline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Events');

    %% Plot events
    if length(Eventline_handles) > sum(EventIndicies)
        delete(Eventline_handles(sum(EventIndicies)+1:end)); 
        Eventline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Events');
    end

    if isempty(Eventline_handles)
        % Pre-calculate values used multiple times
        eventTimes = Time(EventIndicies == 1);
        numEvents = length(eventTimes);
        
        % Prepare xData and yData without redundant calculations
        xData = [eventTimes; eventTimes];
        yData = [MinValue; MaxValue];
        yData = yData(:, ones(1, numEvents));  % Replicate columns without using repmat

        % Create new lines if there are no existing handles
        line(Figure, xData, yData, 'Color', 'r', ...
            'LineWidth', 2, 'Tag', 'Events');
    else
        % Pre-calculate values used multiple times
        eventTimes = Time(EventIndicies == 1);
        numEvents = length(eventTimes);
        % Number of existing lines
        numHandles = length(Eventline_handles);
        
        % Prepare xData and yData without redundant calculations
        xData = [eventTimes; eventTimes];
        yData = [MinValue; MaxValue];
        yData = yData(:, ones(1, numEvents));  % Replicate columns without using repmat

        % Update existing handles if possible
        minCount = min(numHandles, numEvents);
        for i = 1:minCount
            set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), ...
                'Color', 'r', ...
                'LineWidth', 2, 'Tag', 'Events');
        end
        
        % Add new lines if there are more events than handles
        if numEvents > numHandles
            line(Figure, xData(:, numHandles+1:end), yData(:, numHandles+1:end), ...
                'Color', 'r', ...
                'LineWidth', 2, 'Tag', 'Events');
        % Remove excess handles if there are more handles than events
        elseif numEvents < numHandles
            delete(Eventline_handles(numEvents+1:end));
        end
    end
end