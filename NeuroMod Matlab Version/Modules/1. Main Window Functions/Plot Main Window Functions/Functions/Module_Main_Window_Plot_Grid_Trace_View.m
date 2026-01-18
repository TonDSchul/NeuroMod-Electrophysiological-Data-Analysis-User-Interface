function Module_Main_Window_Plot_Grid_Trace_View(app,Data,PlotData,Time,StartIndex,PlotAppearance,ActiveDataChannel)

%% Setup
AllChannel = length(unique(Data.Info.ProbeInfo.ycoords));
AllRows    = length(unique(Data.Info.ProbeInfo.xcoords));

[PlotData, Time] = Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Data,PlotData,Time,ActiveDataChannel);

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

    if length(TraceHandles)>1
        delete(TraceHandles(2:end));
        TraceHandles = findobj(ax, 'Type', 'line', 'Tag', 'Traces');
    end
    if length(BorderHandles)>AllRows
        delete(BorderHandles(AllRows+1:end));
        BorderHandles = findobj(ax, 'Type', 'line', 'Tag', 'Border');
    end
    
    StartChunk = 1;
    StopChunk = length(Time);

    for nRows = 1:AllRows
        if sum(Laufvariable == ActiveDataChannel)>0
            if ~isempty(PlotData{nChannel,nRows})
                DataForCurrentSubPlot(StartChunk:StopChunk) = PlotData{nChannel,nRows};
                TimeForCurrentSubPlot(StartChunk:StopChunk) = Time;
                NumberRowDataChannel = NumberRowDataChannel + 1;
            else
                DataForCurrentSubPlot(StartChunk:StopChunk) = nan(size(Time));
                TimeForCurrentSubPlot(StartChunk:StopChunk) = Time;
                NumberRowDataChannel = NumberRowDataChannel + 1;
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
    if ~isnan(Center) && app.Slider.Value ~= 0
        ylim(ax,[Center-app.Slider.Value, Center+app.Slider.Value]);
    end

    % Vertical lines separating rows
    Datamin = min(DataForCurrentSubPlot);
    Datamax = max(DataForCurrentSubPlot);
    if isempty(BorderHandles)
        for j = 1:NumberRowDataChannel
            idx = length(Time)*j;
            line(ax,[idx, idx], ax.YLim, 'LineWidth', 1.5, 'Color', 'k', 'Tag', 'Border')
        end
    else
        for j = 1:NumberRowDataChannel
            idx = length(Time)*j;
            set(BorderHandles(j), 'XData', [idx, idx], 'YData', ax.YLim, 'LineWidth', 1.5, 'Color', 'k', 'Tag', 'Border');
        end
    end

    if firsttimeindicator
        % Axes styling
        ax.Color = PlotAppearance.MainWindow.Data.Color.MainBackground;
        ax.XColor = 'k';  % or 'none' if you want no ticks
        ax.YColor = 'k';  % tick label color
        ax.Box = 'on';
        ax.LineWidth = 1;
        ax.XTick = [];
    end
    
    xlim(ax,[1, length(DataForCurrentSubPlot)]);
    drawnow;

    DataForCurrentSubPlot = [];
    TimeForCurrentSubPlot = [];
    NumberRowDataChannel = 0;
end

