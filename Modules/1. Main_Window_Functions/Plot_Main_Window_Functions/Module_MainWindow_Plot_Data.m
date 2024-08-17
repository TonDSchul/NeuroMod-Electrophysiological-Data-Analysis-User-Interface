function Module_MainWindow_Plot_Data(Data,UIAxis,Time,Channel_Selection,PlotLineSpacing,Type,colorMap,Preprocessed,EventPlot,EventData,SampleRate,SpikePlot,SpikeData,StartIndex,StopIndex,SpikeDatatype,ChannelSpacing)

%________________________________________________________________________________________
%% Function to Plot Data in the Main Window (raw data, preprocessed data, spike data and event data)
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
% "Kilosort" when plotting spikes analysed with kilosort
% 17. ChannelSpacing: as double in um

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Scale all channel lines so that they are as far apart as specified in main window
% (Channelspacing)

%Data = flip(Data,1);

for i = 1:size(Data,1)     
    Data(i, :) = Data(i, :) - (i - 1) * PlotLineSpacing;
end

%% Predefine x and y lims and title before plotting to increase performance!
YMaxLimitsMultipeERP = max(Data,[],"all");
YMinLimitsMultipeERP = min(Data,[],"all");
xlim(UIAxis, [Time(1),Time(end)]);
ylim(UIAxis, [YMinLimitsMultipeERP,YMaxLimitsMultipeERP]);

%set(UIAxis,'xticklabel',{[]});
set(UIAxis,'yticklabel',{[]});
UIAxis.YLabel = [];
%UIAxis.XLabel = [];

if Preprocessed == 0
    title(UIAxis, 'Raw Data');
elseif Preprocessed == 1 
    title(UIAxis, 'Preproccessed Data');
end

%% Select the current Colormap (tempcolorMapset set in Main window of GUI when colormap setting changed)

EventIndicies = 0;

if strcmp(EventPlot,"Events")
    %% Downsampling: Events handled seperately. This is bc. event times are save in respect to raw data time.
    %% Time points saved in there are therefore not necessary the same as in the downsampled time vector.
    % Therefore, closest value of the event time to the downsampled
    % vtime vecotor has to be found. (When eventtime in range of downsampled time)

    EventIndicies = zeros(size(Time));
    % Iterate over each single time point to check whther one
    % of the event times is in time range and get the closest
    % time point of the time vector for plotting
    for j = 1:numel(EventData)
        % Check if the time point falls within the range
        if EventData(j) >= StartIndex && EventData(j) <= StopIndex
            % Find the index of the element in continuous_time closest to the single time point
            %[~, index] = min(abs(Time - EventData(j)));
            EventIndicies((EventData(j)-StartIndex)-1) = 1;
        end
    end

else
    

end

%% Start Plot
% If Not movie mode:
if strcmp(Type,"Static")
    % All objects being plotted are lines. The following code captures all the lines
    % plotted to keep track of how much is plotted and to update already
    % created line objects instead of creating new ones every time. This
    % increases performance 
    
    %% Plotting Channel Data 

    if sum(EventIndicies) == 0
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        for i = 1:length(Eventline_handles)
            delete(Eventline_handles(i));
        end
    else
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        if length(Eventline_handles) > sum(EventIndicies)
            for i = sum(EventIndicies)+1:length(Eventline_handles)
                delete(Eventline_handles(i));
            end
        end
    end

    lineHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Data');

    if ~isempty(lineHandles) 
        for i = 1:size(Data,1)
            set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',1.5);
        end
    else
        % Plot for first time
        lines = line(UIAxis,Time,Data,'LineWidth',1.5, 'Tag', 'Data');
        % ColorMap
        for i = 1:size(Data,1)
            lines(i).Color = colorMap(i, :);
        end
    end
     
    %% Events: Check if Events should be plotted.
    if strcmp(EventPlot,"Events")
        lineHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Events');
        % If one ore more events within plotted time range
        if sum(EventIndicies)>=1 % One event within range
            indi = find(EventIndicies==1);
            % Just to plot lines: Specify y range of vertical event
            % plots
            for o = 1:length(indi)
                y_start = repmat(YMinLimitsMultipeERP, size(Time(indi(o))));
                y_end = repmat(YMaxLimitsMultipeERP, size(Time(indi(o))));
                % If 64 lines: line 65 has to be plooted with line. Set
                % will result in an error bc this handle indicie isnt
                % existing yet
                if isempty(lineHandles) || length(lineHandles) < sum(EventIndicies)
                    line(UIAxis,[Time(indi(o)), Time(indi(o))], [y_start, y_end], 'Color', 'k','LineWidth',2.5, 'Tag', 'Events'); % Adjust color as needed
                else % If already 65 line handles: set the last line
                    set(lineHandles(o), 'XData', [Time(indi(o)), Time(indi(o))], 'YData', [y_start, y_end], 'Color', 'k','LineWidth',2.5, 'Tag', 'Events');
                end
            end
        end
    end 

    %% Plot Toolbox internally computed Spike Data
    if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Internal")
        
        [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);
        SpikeData.Position = SpikeData.Position./ChannelSpacing;

        SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
        numspikesplotted = 0;
 
        Samplestoshowaroundspike = SampleRate*0.001; % num samples equivalent to 2ms

        %% Plot time window around spike in red
        for i = 1:length(SpikeData.Position) % Channel
            if SpikeData.Indicie(i)-Samplestoshowaroundspike > 0 && SpikeData.Indicie(i)+Samplestoshowaroundspike <= size(Data,2)
                numspikesplotted = numspikesplotted+1;
                if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                    set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike), 'YData', Data(SpikeData.Position(i),SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike),'LineWidth',2.5,'Color','r', 'Tag', 'Spikes');
                else
                    line(UIAxis,Time(SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike),Data(SpikeData.Position(i),SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike),'LineWidth',2.5,'Color','r', 'Tag', 'Spikes');
                end
            end
        end  

        if length(SpikeHandles)>numspikesplotted
            delete(SpikeHandles(numspikesplotted+1:end));
        end

    %% Plot loaded Kilosort Spikes
    elseif strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Kilosort")
        
        if ~isempty(SpikeData.Indicie)
            
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            if length(SpikeHandles) > length(SpikeData.Indicie) && ~isempty(SpikeHandles)
                delete(SpikeHandles(length(SpikeData.Indicie)+1:end));
            end
            
            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
            
            %% If for example channel 10-20 are selected, Starting depth is no longer 0. Therefore, Kilosort Spike positions have to be adjusted so that the the line plotted corresponds to 0 um depth
            range_Positions = (Channel_Selection(2)*ChannelSpacing)-(Channel_Selection(1)*ChannelSpacing);
            
            %% Scale and Plot Kilosort Spike Positions
            for j = 1:numel(SpikeData.Indicie) 
                %To Plot Kilosort Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                ScalingEachChannel = double(Data(:,SpikeData.Indicie(j)));
                % Calculate the range of both vectors
                range_ScalingEachChannel = min(ScalingEachChannel) - max(ScalingEachChannel);
                % Compute the scaling factor
                SpikeData.Position(j) = SpikeData.Position(j) ./ (range_Positions/range_ScalingEachChannel);
               
                if ~isempty(SpikeHandles) && j <= length(SpikeHandles)
                    set(SpikeHandles(j), 'XData', Time(SpikeData.Indicie(j)), 'YData', SpikeData.Position(j), 'Tag', 'Spikes');
                else
                    UIAxis.NextPlot = "add";
                    plot(UIAxis,Time(SpikeData.Indicie(j)),SpikeData.Position(j),'ko','markerfacecolor','r','MarkerSize',4, 'Tag', 'Spikes');
                    UIAxis.NextPlot = "replace";
                end
            end       
           
        end

    end 

end

if strcmp(Type,"Movie")

    pause(0.04);

    %% Plotting Channel Data 
    if sum(EventIndicies) == 0
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        for i = 1:length(Eventline_handles)
            delete(Eventline_handles(i));
        end
    else
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        if length(Eventline_handles) > sum(EventIndicies)
            for i = sum(EventIndicies)+1:length(Eventline_handles)
                delete(Eventline_handles(i));
            end
        end
    end

    lineHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Data');

    if length(lineHandles) > 1 
        for i = 1:size(Data,1)
            set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data');
        end
    else
        % Plot for first time
        lines = line(UIAxis,Time,Data,'LineWidth',1.5, 'Tag', 'Data');
        % ColorMap
        for i = 1:size(Data,1)
            lines(i).Color = colorMap(i, :);
        end
    end
     
    %% Events: Check if Events should be plotted.
    if strcmp(EventPlot,"Events")
        lineHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Events');
        % If one ore more events within plotted time range
        if sum(EventIndicies)>=1 % One event within range
            indi = find(EventIndicies==1);
            % Just to plot lines: Specify y range of vertical event
            % plots
            for o = 1:length(indi)
                y_start = repmat(YMinLimitsMultipeERP, size(Time(indi(o))));
                y_end = repmat(YMaxLimitsMultipeERP, size(Time(indi(o))));
                % If 64 lines: line 65 has to be plooted with line. Set
                % will result in an error bc this handle indicie isnt
                % existing yet
                if isempty(lineHandles) || length(lineHandles) < sum(EventIndicies)
                    line(UIAxis,[Time(indi(o)), Time(indi(o))], [y_start, y_end], 'Color', 'k','LineWidth',2.5, 'Tag', 'Events'); % Adjust color as needed
                else % If already 65 line handles: set the last line
                    set(lineHandles(o), 'XData', [Time(indi(o)), Time(indi(o))], 'YData', [y_start, y_end], 'Color', 'k','LineWidth',2.5, 'Tag', 'Events');
                end
            end
        end
    end 

    %% Plot Toolbox internally computed Spike Data
    %% Plot Toolbox internally computed Spike Data
    if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Internal")
        
        %% Only plot selected channel
        ChannelRange = Channel_Selection(1):Channel_Selection(2);
        SelectedChannelIndicies = zeros(length(SpikeData.Position),1);
        for i = 1:length(SpikeData.Position)
            if sum(SpikeData.Position(i) == ChannelRange) >= 1
                SelectedChannelIndicies(i) = 1;
            end
        end
        
        SpikeData.Indicie = SpikeData.Indicie(SelectedChannelIndicies == 1);
        SpikeData.Position = SpikeData.Position(SelectedChannelIndicies == 1);

        %If Channel 10 to 20: 10 has to have indicie 1 to be plotted
        %correctly
        if Channel_Selection(1) > 1
            SpikeData.Position = SpikeData.Position - (Channel_Selection(1)-1);
        end

        SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
        numspikesplotted = 0;
        
        Samplestoshowaroundspike = SampleRate*0.001; % num samples equivalent to 2ms
        
        %% Plot time window around spike in red
        for i = 1:length(SpikeData.Position) % Channel
            if SpikeData.Indicie(i)-Samplestoshowaroundspike > 0 && SpikeData.Indicie(i)+Samplestoshowaroundspike <= size(Data,2)
                numspikesplotted = numspikesplotted+1;
                if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                    set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike), 'YData', Data(SpikeData.Position(i),SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike),'LineWidth',2.5,'Color','r', 'Tag', 'Spikes');
                else
                    line(UIAxis,Time(SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike),Data(SpikeData.Position(i),SpikeData.Indicie(i)-Samplestoshowaroundspike:SpikeData.Indicie(i)+Samplestoshowaroundspike),'LineWidth',2.5,'Color','r', 'Tag', 'Spikes');
                end
            end
        end  

        if length(SpikeHandles)>numspikesplotted
            delete(SpikeHandles(numspikesplotted+1:end));
        end

    %% Plot loaded Kilosort Spikes
    elseif strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Kilosort")
        
        if ~isempty(SpikeData)
            
            %% This is just to assign each spike position to a channel to display spikes in the main window. 

            Depth(1) = SpikeData.ChannelPosition(Channel_Selection(1),2);
            Depth(2) = SpikeData.ChannelPosition(Channel_Selection(2),2);

            Indicietodelete = [];
            for i = 1:numel(SpikeData.Indicie)
                if SpikeData.Position(i) < Depth(1) || SpikeData.Position(i) > Depth(2)
                    Indicietodelete =  [Indicietodelete,i];
                end
            end
            
            if ~isempty(Indicietodelete)
                SpikeData.Indicie(Indicietodelete) = [];
                SpikeData.Position(Indicietodelete) = [];
            end

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            if length(SpikeHandles) > length(SpikeData.Indicie) && ~isempty(SpikeHandles)
                delete(SpikeHandles(length(SpikeData.Indicie)+1:end));
            end

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            range_Positions = Depth(2) - Depth(1);
            extrarange = SpikeData.ChannelPosition(end) - Depth(2);
            
            SpikeData.Position = SpikeData.Position - ((SpikeData.ChannelPosition(end) - range_Positions)-extrarange);

            for j = 1:numel(SpikeData.Indicie) 

                %To Plot Kilosort Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                ScalingEachChannel = double(Data(:,SpikeData.Indicie(j)));
                % Calculate the range of both vectors
                range_ScalingEachChannel = min(ScalingEachChannel) - max(ScalingEachChannel);
                % Compute the scaling factor
                SpikeData.Position(j) = SpikeData.Position(j) .* (range_ScalingEachChannel/range_Positions);
                % SpikeData.Position = SpikeData.Position .* Scaling_factor_KilosortSpikePositions;

                if ~isempty(SpikeHandles) && j <= length(SpikeHandles)
                    set(SpikeHandles(j), 'XData', Time(SpikeData.Indicie(j)), 'YData', SpikeData.Position(j), 'Tag', 'Spikes');
                else
                    UIAxis.NextPlot = "add";
                    plot(UIAxis,Time(SpikeData.Indicie(j)),SpikeData.Position(j),'ko','markerfacecolor','r','MarkerSize',4, 'Tag', 'Spikes');
                    UIAxis.NextPlot = "replace";
                end

            end       
           
        end

    end 

end
