function Module_MainWindow_Plot_Data(Data,UIAxis,Time,Channel_Selection,PlotLineSpacing,Type,colorMap,Preprocessed,EventPlot,EventData,SampleRate,SpikePlot,SpikeData,StartIndex,StopIndex,SpikeDatatype,ChannelSpacing,PlotAppearance,SpikePlotType)

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
% "Kilosort" when plotting spikes analysed with kilosort
% 17. ChannelSpacing: as double in um

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Scale all channel lines so that they are as far apart as specified in main window
% (Channelspacing)

for i = 1:size(Data,1)     
    Data(i, :) = Data(i, :) - (i - 1) * PlotLineSpacing;
end

%% Predefine x and y lims and title before plotting to increase performance!
YMaxLimitsMultipeERP = max(Data,[],"all");
YMinLimitsMultipeERP = min(Data,[],"all");
xlim(UIAxis, [Time(1),Time(end)]);
ylim(UIAxis, [YMinLimitsMultipeERP,YMaxLimitsMultipeERP]);

set(UIAxis,'yticklabel',{[]});
ylabel(UIAxis,PlotAppearance.MainWindow.Data.MainYLabel)
xlabel(UIAxis,PlotAppearance.MainWindow.Data.MainXLabel)

if Preprocessed == 0
    title(UIAxis, PlotAppearance.MainWindow.Data.Title.Raw);
elseif Preprocessed == 1 
    title(UIAxis, PlotAppearance.MainWindow.Data.Title.Preprocessed);
end

%% Select the current Colormap (tempcolorMapset set in Main window of GUI when colormap setting changed)

EventIndicies = 0;

if strcmp(EventPlot,"Events")
    %% Downsampling: Events handled seperately. This is bc. event times are save in respect to raw data time.
    %% Time points saved in there are therefore not necessary the same as in the downsampled time vector.
    % Therefore, closest value of the event time to the downsampled
    % vtime vecotor has to be found. (When eventtime in range of downsampled time)

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
    % created line objects instead of creating new ones every time. This
    % increases performance 
    
    %% First Check and delete unneccesary plot handles

    if sum(EventIndicies) == 0
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        delete(Eventline_handles(1:end));  
    else
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        if length(Eventline_handles) > sum(EventIndicies)
            delete(Eventline_handles(sum(EventIndicies)+1:end)); 
        end
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
    end

    lineHandles = findobj(UIAxis, 'Tag', 'Data');

    %% Plot Channel Data
    % lines = NaN(size,)
    if isempty(lineHandles) 
        % Plot rfor the first time
        lines = line(UIAxis,Time,Data,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data');
        % ColorMap
        for i = 1:size(Data,1)
            lines(i).Color = colorMap(i, :);
        end
    else
        if length(lineHandles) >= size(Data,1)
            for i = 1:size(Data,1)
                set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
            end
            delete(lineHandles(i+1:end));
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
     
    %% Events: Check if Events should be plotted.
    if strcmp(EventPlot,"Events") && sum(EventIndicies) > 0

        xData = [Time(EventIndicies == 1); Time(EventIndicies == 1)];
        yData = double(repmat([YMinLimitsMultipeERP,YMaxLimitsMultipeERP]', 1, length(Time(EventIndicies == 1))));

        % If 64 lines: line 65 has to be plooted with line. Set
        % will result in an error bc this handle indicie isnt
        % existing yet
        if isempty(Eventline_handles) 
            line(UIAxis,xData, yData, 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events'); % Adjust color as needed
        else
            if length(Eventline_handles)>=size(xData,2)
                for i = 1:size(xData,2)
                    set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
                end
                delete(Eventline_handles(size(xData,2)+1:end));
            elseif length(Eventline_handles) < size(xData,2)
                for i = 1:length(Eventline_handles)
                    set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
                end
                line(UIAxis,xData(:,length(Eventline_handles)+1:end), yData(:,length(Eventline_handles)+1:end), 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events'); % Adjust color as needed
            end            
        end
    end 

    %% Plot Toolbox internally computed Spike Data
    if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Internal")

        if strcmp(SpikePlotType,"Points")
            if ~isempty(SpikeData.Indicie)
                [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);
    
                SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
    
                % Modify Positions to be able to take as indicie
                SpikeData.Position = SpikeData.Position./ChannelSpacing;
                SpikeData.Position = SpikeData.Position+1;
                
                %% Scale and Plot Kilosort Spike Positions
                for nspikes = 1:numel(SpikeData.Indicie) 
                    SpikeData.Position(nspikes) = Data(SpikeData.Position(nspikes),SpikeData.Indicie(nspikes));
                end
    
                if isempty(SpikeHandles)
                    plot(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, 'ko', ...
                    'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                    'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                    'Tag', 'Spikes');
                else
                    if length(SpikeHandles) >= numel(SpikeData.Indicie)
                        set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                        delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                    elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                        set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                        plot(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), 'ko', ...
                        'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                        'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                        'Tag', 'Spikes');
                    end
                end      
            end
        elseif strcmp(SpikePlotType,"Waveforms")
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);
            SpikeData.Position = SpikeData.Position./ChannelSpacing;
    
            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
            numspikesplotted = 0;
     
            Samplestoshowaroundspike = SampleRate*0.001; % num samples equivalent to 2ms
    
            %% Plot time window around spike in red
            SpikeIndiciesInRange = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtStart = SpikeData.Indicie-Samplestoshowaroundspike < 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtEnd = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike > size(Data,2);
    
            SpikeIndicies = SpikeData.Indicie(SpikeIndiciesInRange==1);
            SpikePositions = SpikeData.Position(SpikeIndiciesInRange==1);
            SpikePositions = SpikePositions+1; % first channel is 0 for convenience for spike analysis, but used as index here
    
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
                SpikePositions = SpikePositions+1; % first channel is 0 for convenience for spike analysis, but used as index here
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
            
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            %% If for example channel 10-20 are selected, Starting depth is no longer 0. Therefore, Kilosort Spike positions have to be adjusted so that the the line plotted corresponds to 0 um depth
            range_Positions = (Channel_Selection(2)*ChannelSpacing)-(Channel_Selection(1)*ChannelSpacing);
           
            %% Scale and Plot Kilosort Spike Positions
            for j = 1:numel(SpikeData.Indicie) 
                %To Plot Kilosort Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                % Calculate the range of both vectors
                range_ScalingEachChannel = min(double(Data(:,SpikeData.Indicie(j)))) - max(double(Data(:,SpikeData.Indicie(j))));
                % Compute the scaling factor
                SpikeData.Position(j) = SpikeData.Position(j) ./ (range_Positions/range_ScalingEachChannel);
            end
         
            if isempty(SpikeHandles)
                plot(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, 'ko', ...
                'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                'Tag', 'Spikes');
            else
                if length(SpikeHandles) >= numel(SpikeData.Indicie)
                    set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                    delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                    set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                    plot(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), 'ko', ...
                    'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                    'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                    'Tag', 'Spikes');
                end
            end      
        end
    end 
end

if strcmp(Type,"Movie")

    pause(0.04);

    %% First Check and delete unneccesary plot handles

    if sum(EventIndicies) == 0
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        delete(Eventline_handles(1:end));  
    else
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        if length(Eventline_handles) > sum(EventIndicies)
            delete(Eventline_handles(sum(EventIndicies)+1:end)); 
        end
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
    end

    lineHandles = findobj(UIAxis, 'Tag', 'Data');

    %% Plot Channel Data
    % lines = NaN(size,)
    if isempty(lineHandles) 
        % Plot rfor the first time
        lines = line(UIAxis,Time,Data,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data');
        % ColorMap
        for i = 1:size(Data,1)
            lines(i).Color = colorMap(i, :);
        end
    else
        if length(lineHandles) >= size(Data,1)
            for i = 1:size(Data,1)
                set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
            end
            delete(lineHandles(i+1:end));
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
     
    %% Events: Check if Events should be plotted.
    if strcmp(EventPlot,"Events") && sum(EventIndicies) > 0

        xData = [Time(EventIndicies == 1); Time(EventIndicies == 1)];
        yData = repmat([YMinLimitsMultipeERP,YMaxLimitsMultipeERP]', 1, length(Time(EventIndicies == 1)));

        % If 64 lines: line 65 has to be plooted with line. Set
        % will result in an error bc this handle indicie isnt
        % existing yet
        if isempty(Eventline_handles) 
            line(UIAxis,xData, yData, 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events'); % Adjust color as needed
        else
            if length(Eventline_handles)>=size(xData,2)
                for i = 1:size(xData,2)
                    set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
                end
                delete(Eventline_handles(size(xData,2)+1:end));
            elseif length(Eventline_handles) < size(xData,2)
                for i = 1:length(Eventline_handles)
                    set(Eventline_handles(i), 'XData', xData(:,i), 'YData', yData(:,i), 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events');
                end
                line(UIAxis,xData(:,length(Eventline_handles)+1:end), yData(:,length(Eventline_handles)+1:end), 'Color', PlotAppearance.MainWindow.Data.Color.MainEvents,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainEvents, 'Tag', 'Events'); % Adjust color as needed
            end            
        end
    end 

    %% Plot Toolbox internally computed Spike Data
    if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Internal")
        
        if strcmp(SpikePlotType,"Points")
            if ~isempty(SpikeData.Indicie)
                [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);
    
                SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
    
                % Modify Positions to be able to take as indicie
                SpikeData.Position = SpikeData.Position./ChannelSpacing;
                SpikeData.Position = SpikeData.Position+1;
                
                %% Scale and Plot Kilosort Spike Positions
                for nspikes = 1:numel(SpikeData.Indicie) 
                    SpikeData.Position(nspikes) = Data(SpikeData.Position(nspikes),SpikeData.Indicie(nspikes));
                end
    
                if isempty(SpikeHandles)
                    plot(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, 'ko', ...
                    'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                    'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                    'Tag', 'Spikes');
                else
                    if length(SpikeHandles) >= numel(SpikeData.Indicie)
                        set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                        delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                    elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                        set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                        plot(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), 'ko', ...
                        'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                        'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                        'Tag', 'Spikes');
                    end
                end      
            end
        elseif strcmp(SpikePlotType,"Waveforms")
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);
            SpikeData.Position = SpikeData.Position./ChannelSpacing;
    
            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
            numspikesplotted = 0;
     
            Samplestoshowaroundspike = SampleRate*0.001; % num samples equivalent to 2ms
    
            %% Plot time window around spike in red
            SpikeIndiciesInRange = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtStart = SpikeData.Indicie-Samplestoshowaroundspike < 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
            SpikeindiciesinRangeButAtEnd = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike > size(Data,2);
    
            SpikeIndicies = SpikeData.Indicie(SpikeIndiciesInRange==1);
            SpikePositions = SpikeData.Position(SpikeIndiciesInRange==1);
            SpikePositions = SpikePositions+1; % first channel is 0 for convenience for spike analysis, but used as index here
    
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
                SpikePositions = SpikePositions+1; % first channel is 0 for convenience for spike analysis, but used as index here
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
            
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeData.Indicie,SpikeData.Position,ChannelSpacing,Channel_Selection,SpikeDatatype);

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            %% If for example channel 10-20 are selected, Starting depth is no longer 0. Therefore, Kilosort Spike positions have to be adjusted so that the the line plotted corresponds to 0 um depth
            range_Positions = (Channel_Selection(2)*ChannelSpacing)-(Channel_Selection(1)*ChannelSpacing);
           
            %% Scale and Plot Kilosort Spike Positions
            for j = 1:numel(SpikeData.Indicie) 
                %To Plot Kilosort Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                % Calculate the range of both vectors
                range_ScalingEachChannel = min(double(Data(:,SpikeData.Indicie(j)))) - max(double(Data(:,SpikeData.Indicie(j))));
                % Compute the scaling factor
                SpikeData.Position(j) = SpikeData.Position(j) ./ (range_Positions/range_ScalingEachChannel);
            end
         
            if isempty(SpikeHandles)
                plot(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, 'ko', ...
                'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                'Tag', 'Spikes');
            else
                if length(SpikeHandles) >= numel(SpikeData.Indicie)
                    set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                    delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                    set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                    plot(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), 'ko', ...
                    'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                    'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                    'Tag', 'Spikes');
                end
            end      
        end
    end  
end
