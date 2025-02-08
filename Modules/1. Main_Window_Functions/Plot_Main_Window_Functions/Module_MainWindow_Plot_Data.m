function Module_MainWindow_Plot_Data(Data,Info,UIAxis,Time,Channel_Selection,PlotLineSpacing,Type,colorMap,Preprocessed,EventPlot,EventData,SampleRate,SpikePlot,SpikeData,StartIndex,StopIndex,SpikeDatatype,ChannelSpacing,PlotAppearance,SpikePlotType,ActiveChannel,frameTime)

%________________________________________________________________________________________
%% Function to Plot Data in the Main Window (raw data, preprocessed data, spike data and event data)

% Gets called in the 'Organize_Prepare_Plot_and_Extract_GUI_Info' function

% Input Arguments:
% 1. Data: Channel x Time holding the raw/preprocessed data (single/double)
% 2. UIAxis: App UIAxes object designating the plot you want to plot in
% 3. Time: Vector with time points to be plotted (single/double)
% 4. Channel_Selection [Ch1,Ch2]: Vector with two values, for the start andstop channel selected in main window
% 5. PlotLineSpacing: Factor (double) to introduce spacing between channel plots
% based on GUI slider input
% 6. Type: "Static" to not plot movie but just single plot. "Movie to plot movie"
% 7. colorMap: Colormap object to be used (as many elements as channel in dataset in a nelements x 3 matrix with rgb values)
% 8.Preprocessed: if 1: Data to be plotted is downsamßpled
% 9. EventPlot: "Events" to show event plots if within time range, any other
% string like "Non" leads to no events being plotted
% 10. EventData: vector of time points (in s as double) of the event selected
% on the bottom right of the main window. Only needed if EventPlot = "Events"
% 11. SampleRate as double in Hz
% 12. SpikePlot: string, "Spikes" when plotting spikes, some other string
% like "non" when not
% 13. SpikeData: structure with spike indicies and positions (all spikes)
% 14. StartIndex: First idicie plotted in main plot in samples as double
% 15. StopIndex: Last idicie plotted in main plot in samples as double
% 16. SpikeDatatype: Either "Internal" when plotting internal spike data or
% "Kilosort" when plotting spikes analysed with kilosort Or "SpikeInterface"
% 17. ChannelSpacing: as double in um
% 18. PlotAppearance: structure holding indo about the appearance of plots
% the user selected
% 19. SpikePlotType: string, either "Points" or "Waveforms" to specifiy how
% spikes should be plotted when the user selected them 
% 20. frameTime: double, Time in seconds of each frame based on selected
% frame rate

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Scale all channel lines so that they are as far apart as specified in main window
% (Channelspacing)

if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
    for i = 1:size(Data,1)     
        Data(i, :) = Data(i, :) - (i - 1) * PlotLineSpacing;
    end
    YMaxLimitsMultipeERP = max(Data,[],"all");
    YMinLimitsMultipeERP = min(Data,[],"all");
    ylim(UIAxis, [YMinLimitsMultipeERP,YMaxLimitsMultipeERP]);
else
    Depth = 0:ChannelSpacing:(size(Data,1)-1)*ChannelSpacing;
    YMinLimitsMultipeERP = Depth(1);
    YMaxLimitsMultipeERP = Depth(end);
    ylim(UIAxis, [Depth(1),Depth(end)]);
end

%% Predefine x and y lims and title before plotting to increase performance!

xlim(UIAxis, [Time(1),Time(end)]);

if size(Data,1)>1
    if ~isempty(UIAxis.YTickLabel)
        if ~isempty(UIAxis.YTickLabel{1})
            set(UIAxis,'yticklabel',{[]});
            ylabel(UIAxis,PlotAppearance.MainWindow.Data.MainYLabel)
        end
    end
end

if ~strcmp(UIAxis.XLabel.String,PlotAppearance.MainWindow.Data.MainXLabel)
    xlabel(UIAxis,PlotAppearance.MainWindow.Data.MainXLabel)
end

if Preprocessed == 0
    if ~strcmp(UIAxis.Title.String,PlotAppearance.MainWindow.Data.Title.Raw)
        title(UIAxis, PlotAppearance.MainWindow.Data.Title.Raw);
    end
elseif Preprocessed == 1 
    if ~strcmp(UIAxis.Title.String,PlotAppearance.MainWindow.Data.Title.Preprocessed)
        title(UIAxis, PlotAppearance.MainWindow.Data.Title.Preprocessed);
    end
end

%% Select the current Colormap (tempcolorMapset set in Main window of GUI when colormap setting changed)

EventIndicies = 0;

if strcmp(EventPlot,"Events")
    %% Downsampling: Events handled seperately. This is bc. event times are save in respect to raw data time.
    %% Time points saved in there are therefore not necessary the same as in the downsampled time vector.
    % Therefore, closest value of the event time to the downsampled
    % time vector has to be found. (When eventtime in range of downsampled time)

    TempEventIndicies = EventData >= StartIndex & EventData <= StopIndex;
    EventSamples = EventData(TempEventIndicies)-(StartIndex-1);

    EventIndicies = zeros(size(Time));
    EventIndicies(EventSamples) = 1;

end

%% Start Plot
% If Not movie mode:

if strcmp(Type,"Static")
    % All objects being plotted are lines. The following code captures all the lines
    % plotted to keep track of how much is plotted and to update already
    % created line objects instead of creating new ones every time.
    
    %% First Check and delete unneccesary plot handles
  
    if sum(EventIndicies) == 0
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        delete(Eventline_handles(1:end));  
    else
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        if length(Eventline_handles) > sum(EventIndicies)
            delete(Eventline_handles(sum(EventIndicies)+1:end)); 
            Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        end
    end

    lineHandles = findobj(UIAxis, 'Tag', 'Data');
    
    ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');

    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        delete(lineHandles);
        if length(ImageScChannel_handles)>1
            delete(ImageScChannel_handles(2:end));
            ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
        end
    else
        delete(ImageScChannel_handles);
    end
  
    %% Plot Channel Data
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
        if isempty(lineHandles) 
            % Plot for the first time
            lines = line(UIAxis,Time,Data,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
            % ColorMap
            for i = 1:size(Data,1)
                lines(i).Color = colorMap(i, :);
            end
        else
            if length(lineHandles) >= size(Data,1)
                for i = 1:size(Data,1)
                    set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                end
                delete(lineHandles(size(Data,1)+1:end));
                % ColorMap
                for i = 1:size(Data,1)
                    lines(i).Color = colorMap(i, :);
                end
            elseif length(lineHandles) < size(Data,1)

                for i = 1:length(lineHandles)
                    set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                    lines(i)=lineHandles(i);
                end
                % Plot rest of the lines
                lines(i+1:size(Data,1)) = line(UIAxis,Time,Data(i+1:end,:),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data');
                % ColorMap
                for i = 1:size(Data,1)
                    lines(i).Color = colorMap(i, :);
                end
            end
        end
    end

    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        
        if isempty(ImageScChannel_handles)
            imagesc(UIAxis,Time,Depth,Data,'Tag','ImageScChannel')
        else
            set(ImageScChannel_handles(1), 'XData', Time, 'YData', Depth,'CData', Data,'Tag','ImageScChannel');
        end
    end

    %% Events: Check if Events should be plotted.
    if strcmp(EventPlot,"Events") && sum(EventIndicies) > 0
        
        % Pre-calculate values used multiple times
        eventTimes = Time(EventIndicies == 1);
        numEvents = length(eventTimes);
        
        % Prepare xData and yData without redundant calculations
        xData = [eventTimes; eventTimes];
        yData = [YMinLimitsMultipeERP; YMaxLimitsMultipeERP];
        yData = yData(:, ones(1, numEvents));  % Replicate columns without using repmat
        
        % Check if we need to create new lines or update existing ones
        if isempty(Eventline_handles)
            % Create new lines if there are no existing handles
            line(UIAxis, xData, yData, 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
        else
            % Number of existing lines
            numHandles = length(Eventline_handles);
            
            % Update existing handles if possible
            minCount = min(numHandles, numEvents);
            for i = 1:minCount
                set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), ...
                    'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                    'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
            end
            
            % Add new lines if there are more events than handles
            if numEvents > numHandles
                line(UIAxis, xData(:, numHandles+1:end), yData(:, numHandles+1:end), ...
                    'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                    'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
            % Remove excess handles if there are more handles than events
            elseif numEvents < numHandles
                delete(Eventline_handles(numEvents+1:end));
            end
        end
        
    end 

    %% Plot Toolbox internally computed Spike Data
    if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Internal")

        if strcmp(SpikePlotType,"Points")
            if ~isempty(SpikeData.Indicie)

                [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);
                
                % INdex of SpikeData.Position in Info.ProbeInfo.ActiveChannel

                SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
    
                if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
                    %% Scale and Plot Spike Positions
                    for nspikes = 1:numel(SpikeData.Indicie) 
                        SpikeData.Position(nspikes) = Data(SpikeData.Position(nspikes),SpikeData.Indicie(nspikes));
                    end
                end
    
                if isempty(SpikeHandles)
                    line(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, ...
                     'LineStyle', 'none', ...  % No line between markers
                     'Marker', 'o', ...        % Marker type
                     'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                     'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                     'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                     'Tag', 'Spikes');
                else
                    if length(SpikeHandles) >= numel(SpikeData.Indicie)
                        set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                        delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                    elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                        set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                        line(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), ...
                         'LineStyle', 'none', ...  % No line between markers
                         'Marker', 'o', ...        % Marker type
                         'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                         'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                         'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                         'Tag', 'Spikes');
                    end
                end      
            end
        elseif strcmp(SpikePlotType,"Waveforms") && strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
            
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);
    
            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
            numspikesplotted = 0;
     
            Samplestoshowaroundspike = SampleRate*0.001; % num samples equivalent to 2ms
    
            %% Plot time window around spike in red
            SpikeIndiciesInRange = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtStart = SpikeData.Indicie-Samplestoshowaroundspike < 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtEnd = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike > size(Data,2);
    
            SpikeIndicies = SpikeData.Indicie(SpikeIndiciesInRange==1);
            SpikePositions = SpikeData.Position(SpikeIndiciesInRange==1);

            for i = 1:numel(SpikePositions) % Channel
                numspikesplotted = numspikesplotted+1;
                if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                    set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike), 'YData', Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                else 
                    line(UIAxis, Time(SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike), Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                end
            end  
            SpikeIndicies = [];
            SpikePositions = [];
            % If spike line would be smaller than window
            if ~isempty(SpikeindiciesinRangeButAtStart)
                SpikeIndicies = SpikeData.Indicie(SpikeindiciesinRangeButAtStart==1);
                SpikePositions = SpikeData.Position(SpikeindiciesinRangeButAtStart==1);
                SpikePositions = SpikePositions+1; % first channel is 0 for convenience for spike analysis, but used as index here
                for i = 1:numel(SpikePositions) % Channel
                    numspikesplotted = numspikesplotted+1;
                    if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                        set(SpikeHandles(numspikesplotted), 'XData', Time(1:SpikeIndicies(i)+Samplestoshowaroundspike), 'YData', Data(SpikePositions(i),1:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    else 
                        line(UIAxis, Time(1:SpikeIndicies(i)+Samplestoshowaroundspike), Data(SpikePositions(i),1:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    end
                end  
            end
            SpikeIndicies = [];
            SpikePositions = [];
            % If spike line would be bigger than window
            if ~isempty(SpikeindiciesinRangeButAtEnd)
                SpikeIndicies = SpikeData.Indicie(SpikeindiciesinRangeButAtEnd==1);
                SpikePositions = SpikeData.Position(SpikeindiciesinRangeButAtEnd==1);
                for i = 1:numel(SpikePositions) % Channel
                    numspikesplotted = numspikesplotted+1;
                    if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                        set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)), 'YData', Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    else 
                        line(UIAxis, Time(SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)), Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    end
                end  
            end
            SpikeIndicies = [];
            SpikePositions = [];
    
            if length(SpikeHandles)>numspikesplotted
                delete(SpikeHandles(numspikesplotted+1:end));
            end
        end
    %% Plot loaded Kilosort Spikes
    elseif strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Kilosort") || strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"SpikeInterface")
        if ~isempty(SpikeData.Indicie)
            
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
                %% If for example channel 10-20 are selected, Starting depth is no longer 0. Therefore, Kilosort Spike positions have to be adjusted so that the the line plotted corresponds to 0 um depth
                %range_Positions = (Channel_Selection(2)*ChannelSpacing)-(Channel_Selection(1)*ChannelSpacing);
               
                range_Positions = (length(Channel_Selection)-1)*ChannelSpacing;
                
                %% Scale and Plot Kilosort Spike Positions
                for j = 1:numel(SpikeData.Indicie) 
                    %To Plot Kilosort Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                    % Calculate the range of both vectors
                    range_ScalingEachChannel = min(double(Data(:,SpikeData.Indicie(j)))) - max(double(Data(:,SpikeData.Indicie(j))));
                    % Compute the scaling factor
                    SpikeData.Position(j) = SpikeData.Position(j) ./ (range_Positions/range_ScalingEachChannel);
                end

            else%imagsc plot
                SpikeData.Position = (round(SpikeData.Position/ChannelSpacing))*ChannelSpacing;
            end
         
            if isempty(SpikeHandles)
                line(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, ...
                 'LineStyle', 'none', ...  % No connecting lines between markers
                 'Marker', 'o', ...        % Marker type
                 'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                 'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                 'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                 'Tag', 'Spikes');
            else
                if length(SpikeHandles) >= numel(SpikeData.Indicie)
                    set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                    delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                    set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                    % plot(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), 'ko', ...
                    % 'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                    % 'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                    % 'Tag', 'Spikes');

                    line(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), ...
                     'LineStyle', 'none', ...  % No connecting lines between markers
                     'Marker', 'o', ...        % Marker type
                     'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                     'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                     'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                     'Tag', 'Spikes');
                end
            end      
        end
    end 
end


if strcmp(Type,"Movie")

    tic

    %% First Check and delete unneccesary plot handles

    %% First Check and delete unneccesary plot handles
  
    if sum(EventIndicies) == 0
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        delete(Eventline_handles(1:end));  
    else
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        if length(Eventline_handles) > sum(EventIndicies)
            delete(Eventline_handles(sum(EventIndicies)+1:end)); 
            Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        end
    end

    lineHandles = findobj(UIAxis, 'Tag', 'Data');
    
    ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');

    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        delete(lineHandles);
        if length(ImageScChannel_handles)>1
            delete(ImageScChannel_handles(2:end));
            ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
        end
    else
        delete(ImageScChannel_handles);
    end
  
    %% Plot Channel Data
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
        if isempty(lineHandles) 
            % Plot for the first time
            lines = line(UIAxis,Time,Data,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
            % ColorMap
            for i = 1:size(Data,1)
                lines(i).Color = colorMap(i, :);
            end
        else
            if length(lineHandles) >= size(Data,1)
                for i = 1:size(Data,1)
                    set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                end
                delete(lineHandles(size(Data,1)+1:end));
                % ColorMap
                for i = 1:size(Data,1)
                    lines(i).Color = colorMap(i, :);
                end
            elseif length(lineHandles) < size(Data,1)

                for i = 1:length(lineHandles)
                    set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                    lines(i)=lineHandles(i);
                end
                % Plot rest of the lines
                lines(i+1:size(Data,1)) = line(UIAxis,Time,Data(i+1:end,:),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data');
                % ColorMap
                for i = 1:size(Data,1)
                    lines(i).Color = colorMap(i, :);
                end
            end
        end
    end

    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        
        if isempty(ImageScChannel_handles)
            imagesc(UIAxis,Time,Depth,Data,'Tag','ImageScChannel')
        else
            set(ImageScChannel_handles(1), 'XData', Time, 'YData', Depth,'CData', Data,'Tag','ImageScChannel');
        end
    end

    %% Events: Check if Events should be plotted.
    if strcmp(EventPlot,"Events") && sum(EventIndicies) > 0
        
        % Pre-calculate values used multiple times
        eventTimes = Time(EventIndicies == 1);
        numEvents = length(eventTimes);
        
        % Prepare xData and yData without redundant calculations
        xData = [eventTimes; eventTimes];
        yData = [YMinLimitsMultipeERP; YMaxLimitsMultipeERP];
        yData = yData(:, ones(1, numEvents));  % Replicate columns without using repmat
        
        % Check if we need to create new lines or update existing ones
        if isempty(Eventline_handles)
            % Create new lines if there are no existing handles
            line(UIAxis, xData, yData, 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
        else
            % Number of existing lines
            numHandles = length(Eventline_handles);
            
            % Update existing handles if possible
            minCount = min(numHandles, numEvents);
            for i = 1:minCount
                set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), ...
                    'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                    'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
            end
            
            % Add new lines if there are more events than handles
            if numEvents > numHandles
                line(UIAxis, xData(:, numHandles+1:end), yData(:, numHandles+1:end), ...
                    'Color', PlotAppearance.MainWindow.Data.Color.MainEvents, ...
                    'LineWidth', PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
            % Remove excess handles if there are more handles than events
            elseif numEvents < numHandles
                delete(Eventline_handles(numEvents+1:end));
            end
        end
        
    end 

    %% Plot Toolbox internally computed Spike Data
    if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Internal")
        
        if strcmp(SpikePlotType,"Points")
            if ~isempty(SpikeData.Indicie)
                [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);
    
                SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
    
                if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")

                    %% Scale and Plot Kilosort Spike Positions
                    for nspikes = 1:numel(SpikeData.Indicie) 
                        SpikeData.Position(nspikes) = Data(SpikeData.Position(nspikes),SpikeData.Indicie(nspikes));
                    end
                end

                if isempty(SpikeHandles)
                    line(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, ...
                     'LineStyle', 'none', ...  % No line between markers
                     'Marker', 'o', ...        % Marker type
                     'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                     'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                     'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                     'Tag', 'Spikes');
                else
                    if length(SpikeHandles) >= numel(SpikeData.Indicie)
                        set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                        delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                    elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                        set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                        line(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), ...
                         'LineStyle', 'none', ...  % No line between markers
                         'Marker', 'o', ...        % Marker type
                         'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                         'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                         'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                         'Tag', 'Spikes');
                    end
                end       
            end
        elseif strcmp(SpikePlotType,"Waveforms") && strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);
    
            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
            numspikesplotted = 0;
     
            Samplestoshowaroundspike = SampleRate*0.001; % num samples equivalent to 2ms
    
            %% Plot time window around spike in red
            SpikeIndiciesInRange = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtStart = SpikeData.Indicie-Samplestoshowaroundspike < 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtEnd = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike > size(Data,2);
    
            SpikeIndicies = SpikeData.Indicie(SpikeIndiciesInRange==1);
            SpikePositions = SpikeData.Position(SpikeIndiciesInRange==1);

            for i = 1:numel(SpikePositions) % Channel
                numspikesplotted = numspikesplotted+1;
                if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                    set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike), 'YData', Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                else 
                    line(UIAxis, Time(SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike), Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                end
            end  
            SpikeIndicies = [];
            SpikePositions = [];
            % If spike line would be smaller than window
            if ~isempty(SpikeindiciesinRangeButAtStart)
                SpikeIndicies = SpikeData.Indicie(SpikeindiciesinRangeButAtStart==1);
                SpikePositions = SpikeData.Position(SpikeindiciesinRangeButAtStart==1);
                SpikePositions = SpikePositions+1; % first channel is 0 for convenience for spike analysis, but used as index here
                for i = 1:numel(SpikePositions) % Channel
                    numspikesplotted = numspikesplotted+1;
                    if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                        set(SpikeHandles(numspikesplotted), 'XData', Time(1:SpikeIndicies(i)+Samplestoshowaroundspike), 'YData', Data(SpikePositions(i),1:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    else 
                        line(UIAxis, Time(1:SpikeIndicies(i)+Samplestoshowaroundspike), Data(SpikePositions(i),1:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    end
                end  
            end
            SpikeIndicies = [];
            SpikePositions = [];
            % If spike line would be bigger than window
            if ~isempty(SpikeindiciesinRangeButAtEnd)
                SpikeIndicies = SpikeData.Indicie(SpikeindiciesinRangeButAtEnd==1);
                SpikePositions = SpikeData.Position(SpikeindiciesinRangeButAtEnd==1);
                for i = 1:numel(SpikePositions) % Channel
                    numspikesplotted = numspikesplotted+1;
                    if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                        set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)), 'YData', Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    else 
                        line(UIAxis, Time(SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)), Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                    end
                end  
            end
            SpikeIndicies = [];
            SpikePositions = [];
    
            if length(SpikeHandles)>numspikesplotted
                delete(SpikeHandles(numspikesplotted+1:end));
            end
        end

    %% Plot loaded Kilosort Spikes
    elseif strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Kilosort")
        if ~isempty(SpikeData.Indicie)
            
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
                %% If for example channel 10-20 are selected, Starting depth is no longer 0. Therefore, Kilosort Spike positions have to be adjusted so that the the line plotted corresponds to 0 um depth
                %range_Positions = (Channel_Selection(2)*ChannelSpacing)-(Channel_Selection(1)*ChannelSpacing);
                range_Positions = (length(Channel_Selection)-1)*ChannelSpacing;
               
                %% Scale and Plot Kilosort Spike Positions
                for j = 1:numel(SpikeData.Indicie) 
                    %To Plot Kilosort Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                    % Calculate the range of both vectors
                    range_ScalingEachChannel = min(double(Data(:,SpikeData.Indicie(j)))) - max(double(Data(:,SpikeData.Indicie(j))));
                    % Compute the scaling factor
                    SpikeData.Position(j) = SpikeData.Position(j) ./ (range_Positions/range_ScalingEachChannel);
                end
            else%imagsc plot
                SpikeData.Position = (round(SpikeData.Position/ChannelSpacing))*ChannelSpacing;
            end
         
            if isempty(SpikeHandles)
                line(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, ...
                 'LineStyle', 'none', ...  % No connecting lines between markers
                 'Marker', 'o', ...        % Marker type
                 'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                 'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                 'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                 'Tag', 'Spikes');
            else
                if length(SpikeHandles) >= numel(SpikeData.Indicie)
                    set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                    delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                    set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                    % plot(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), 'ko', ...
                    % 'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                    % 'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                    % 'Tag', 'Spikes');

                    line(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), ...
                     'LineStyle', 'none', ...  % No connecting lines between markers
                     'Marker', 'o', ...        % Marker type
                     'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                     'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                     'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                     'Tag', 'Spikes');
                end
            end      
        end
    end  

    drawnow;

    % limit time for new plot so that its not updating too fast and
    % according to framerate
    plottime = toc;
    
    if plottime<frameTime
        timeremaining = frameTime-plottime;
        pause(timeremaining);
    end

end
