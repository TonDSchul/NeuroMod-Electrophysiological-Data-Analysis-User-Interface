function Module_Main_Window_Plot_Grid_Trace_View(app,Data,PlotData,Time,StartIndex,PlotAppearance,ActiveDataChannel,PreservePlotChannelLocations,SpikeData,EventERP)

%% Setup

AllRows = length(unique(Data.Info.ProbeInfo.xcoords));

[PlotData,SpikeDataCell,Time] = Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Data.Info,PlotData,Time,ActiveDataChannel,PreservePlotChannelLocations,SpikeData,'All');

ChannelBeforeActive = 0;

[AllChannel,ActiveDataChannel,~] = Module_MainWindow_ActiveChannel_ChannerlNumber_Grid_Traces(Data.Info,SpikeData,"NumChan",ActiveDataChannel,PreservePlotChannelLocations);

%% Loop over channels

Laufvariable = 1;

for nChannel = 1:AllChannel

    % Create one axes for this channel

    ax = app.ChannelAxes{nChannel};
    hold(ax,'on')
    
    DataForCurrentSubPlot = zeros(1,length(Time)*AllRows);
    TimeForCurrentSubPlot = zeros(1,length(Time)*AllRows);

    NumberRowDataChannel = 0;
    
    TraceHandles = findobj(ax, 'Type', 'line', 'Tag', 'Traces');
    BorderHandles = findobj(ax, 'Type', 'line', 'Tag', 'Border');
    EventHandles = findobj(ax, 'Type', 'line', 'Tag', 'Events');

    if length(TraceHandles)>1
        delete(TraceHandles(2:end));
        TraceHandles = findobj(ax, 'Type', 'line', 'Tag', 'Traces');
    end
    if length(BorderHandles)>AllRows
        delete(BorderHandles(AllRows+1:end));
        BorderHandles = findobj(ax, 'Type', 'line', 'Tag', 'Border');
    end
    if length(EventHandles)>AllRows
        delete(EventHandles(AllRows+1:end));
        EventHandles = findobj(ax, 'Type', 'line', 'Tag', 'Events');
    end
    
    StartChunk = 1;
    StopChunk = length(Time);
    
    if isprop(ax,'XLim')
        PreviousXlim = ax.XLim;
    else
        PreviousXlim = [];
    end

    UpdateLinesAndText = 0; 
    if ~isempty(PreviousXlim)
        if PreviousXlim(2) ~= length(Time)
            UpdateLinesAndText = 1;
        end
    end
    
    SpikesForCurrentSubPlot = [];
    for nRows = 1:AllRows
        if sum(Laufvariable == ActiveDataChannel)>0
            % Channel Data
            if ~isempty(PlotData{nChannel,nRows})
                DataForCurrentSubPlot(StartChunk:StopChunk) = PlotData{nChannel,nRows};
                TimeForCurrentSubPlot(StartChunk:StopChunk) = Time;
                NumberRowDataChannel = NumberRowDataChannel + 1;
            else
                DataForCurrentSubPlot(StartChunk:StopChunk) = nan(size(Time));
                TimeForCurrentSubPlot(StartChunk:StopChunk) = Time;
                NumberRowDataChannel = NumberRowDataChannel + 1;
            end
            % Spike Data
            if ~isempty(SpikeDataCell{nChannel,nRows})
                SpikesForCurrentSubPlot = [SpikesForCurrentSubPlot,SpikeDataCell{nChannel,nRows}+((nRows-1)*length(Time))];
            end
        else
            DataForCurrentSubPlot(StartChunk:StopChunk) = nan(size(Time));
            TimeForCurrentSubPlot(StartChunk:StopChunk) = Time;
            NumberRowDataChannel = NumberRowDataChannel + 1;
        end

        Laufvariable = Laufvariable+1;
        StartChunk = StopChunk + 1;
        StopChunk = StopChunk + length(Time);
    end

    %% plotting part
    % Create subplot
    % ax = subplot(AllChannel, 1, nChannel);
    hold(ax,'on')
    firsttimeindicator = 0;
    if isempty(TraceHandles)
        firsttimeindicator = 1;
        if sum(isnan(DataForCurrentSubPlot))<length(DataForCurrentSubPlot)
            line(ax,1:length(DataForCurrentSubPlot), DataForCurrentSubPlot, 'Color', 'b','LineWidth',1.5, 'Tag', 'Traces')
        else
            %line(ax,1,1, 'Tag', 'Traces')
        end
    else
        if sum(isnan(DataForCurrentSubPlot))<length(DataForCurrentSubPlot)
            set(TraceHandles(1), 'XData', 1:length(DataForCurrentSubPlot), 'YData', DataForCurrentSubPlot, 'Tag', 'Traces');
        else
            delete(TraceHandles(1));
        end
    end
    
    % ylim
    Center = median(DataForCurrentSubPlot,'omitnan');
    ylim(ax,[min(DataForCurrentSubPlot)-app.Slider.Value, max(DataForCurrentSubPlot)+app.Slider.Value]);
    % if EventERP == 0
    %     Center = median(DataForCurrentSubPlot,'omitnan');
    %     if ~isnan(Center) && app.Slider.Value ~= 0
    %         ylim(ax,[Center-app.Slider.Value, Center+app.Slider.Value]);
    %     end
    % else
    %     Center = median(DataForCurrentSubPlot,'omitnan');
    %     ylim(ax,[min(DataForCurrentSubPlot)-app.Slider.Value, max(DataForCurrentSubPlot)+app.Slider.Value]);
    % end

    %% Plot Spikes
    SpikeHandles = findobj(ax, 'Tag', 'TracesSpikes');
    delete(SpikeHandles)
    SpikeHandles = findobj(ax, 'Tag', 'TracesSpikes');
    if ~isempty(SpikesForCurrentSubPlot)
        if length(SpikeHandles)>length(SpikesForCurrentSubPlot)
            delete(SpikeHandles(length(SpikesForCurrentSubPlot)+1:end));
            SpikeHandles = findobj(ax, 'Tag', 'TracesSpikes');
        end

        if isempty(SpikeHandles)
            line(ax,SpikesForCurrentSubPlot,mean(DataForCurrentSubPlot,'omitnan'),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',2,'Tag','TracesSpikes')
        else
            for i = 1:length(SpikesForCurrentSubPlot)
                if i <= length(SpikeHandles)
                    set(SpikeHandles(i),'XData',SpikesForCurrentSubPlot(i),'YData',mean(DataForCurrentSubPlot,'omitnan'),'LineStyle','none','Marker','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',3,'Tag','TracesSpikes')
                else
                    line(ax,SpikesForCurrentSubPlot(i),mean(DataForCurrentSubPlot,'omitnan'),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',3,'Tag','TracesSpikes')
                end
            end
        end
    else
        delete(SpikeHandles);
    end

    %% Vertical lines separating rows
    if isempty(BorderHandles)
        for j = 1:NumberRowDataChannel
            idx = length(Time)*j;
            line(ax,[idx, idx], ax.YLim, 'LineWidth', 1.2, 'Color', 'k', 'Tag', 'Border')
        end
    else
        if UpdateLinesAndText
            for j = 1:NumberRowDataChannel
                idx = length(Time)*j;
                set(BorderHandles(j), 'XData', [idx, idx], 'YData', ax.YLim, 'LineWidth', 1.2, 'Color', 'k', 'Tag', 'Border');
            end
        end
    end

    if firsttimeindicator
        % Axes styling
        ax.Color = PlotAppearance.MainWindow.Data.Color.MainBackground;
        ax.XColor = 'k';  % or 'none' if you want no ticks
        ax.YColor = 'k';  % tick label color
        ax.Box = 'on';
        ax.LineWidth = 0.5;
        ax.XTick = [];
    end

    xlim(ax,[1, length(DataForCurrentSubPlot)]);

    % Plot text above first axis
    if nChannel == 1 %&& UpdateLinesAndText
        % remove old labels if they exist
        delete(findobj(ax,'Type','text','Tag','RowLabel'))
    
        nBlocks = NumberRowDataChannel;
        blockWidth = length(Time);
    
        yText = ax.YLim(2) + 0.05 * range(ax.YLim);  % slightly above axis
        
        ScaledFontSize = -0.27778 * nBlocks + 15.556;
    
        for j = 1:nBlocks
            xCenter = (j-1)*blockWidth + blockWidth/2;
            
            if PreservePlotChannelLocations
                Allchannelcurrently = j:length(unique(Data.Info.ProbeInfo.xcoords)):Data.Info.ProbeInfo.ActiveChannel(end);
            else
                Allchannelcurrently = j:length(unique(Data.Info.ProbeInfo.xcoords)):length(Data.Info.ProbeInfo.ActiveChannel);
            end
            
            text(ax, xCenter, yText, ...
                strcat("Ch ", num2str(j+ChannelBeforeActive)," to ",num2str(Allchannelcurrently(end))), ...
                'HorizontalAlignment','center', ...
                'VerticalAlignment','bottom', ...
                'FontSize', ScaledFontSize, ...
                'Color', 'k', ...
                'Clipping','off', ...     
                'Tag','RowLabel');
        end
    end

    % remove old labels if they exist
    delete(findobj(ax,'Type','text','Tag','LeftAxisLabel'))
    
    % horizontal offset (to the left of axis)
    xOffset = -0.05 * range(ax.XLim);  
    
    % vertical position: middle of the axis
    yText = mean(ax.YLim, 'omitnan');
    
    if ~isnan(Center-app.Slider.Value) && ~isnan(Center+app.Slider.Value)
        text(ax, 1, yText, ...
            strcat("Signal from ",num2str(Center-app.Slider.Value)," to ",num2str(Center+app.Slider.Value)," mV"), ...             
            'HorizontalAlignment','right', ...
            'VerticalAlignment','middle', ...
            'FontSize', 6, ...
            'Color', 'k', ...
            'Clipping','off', ...
            'Tag','LeftAxisLabel');
    end
    
    %% If event realted ERP: Plot event trigger time
    if EventERP == 1
        NumSamplesEventTimeBefore = find(Data.Info.EventRelatedTime==0)-1;
        %% Vertical lines for events
        if isempty(EventHandles)
            for j = 1:NumberRowDataChannel
                Index = NumSamplesEventTimeBefore + ((j-1)*length(Data.Info.EventRelatedTime));
                line(ax,[Index, Index], ax.YLim, 'LineWidth', 1, 'Color', 'r', 'Tag', 'Events')
            end
        else
            if UpdateLinesAndText
                for j = 1:NumberRowDataChannel
                    Index = NumSamplesEventTimeBefore + ((j-1)*length(Data.Info.EventRelatedTime));
                    set(EventHandles(j), 'XData', [Index, Index], 'YData', ax.YLim, 'LineWidth', 1, 'Color', 'r', 'Tag', 'Events');
                end
            end
        end
    end


end

