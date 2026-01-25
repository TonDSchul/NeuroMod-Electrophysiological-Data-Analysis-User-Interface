function Module_Main_Window_Plot_Grid_Trace_View(app,Data,PlotData,Time,StartIndex,PlotAppearance,ActiveDataChannel,PreservePlotChannelLocations,SpikeData)

%% Setup

AllRows = length(unique(Data.Info.ProbeInfo.xcoords));

[PlotData, Time] = Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Data,PlotData,Time,ActiveDataChannel,PreservePlotChannelLocations);

%% Loop over channels

Laufvariable = 1;

if PreservePlotChannelLocations
    AllChannel = length(unique(app.Data.Info.ProbeInfo.ycoords(app.Data.Info.ProbeInfo.ActiveChannel(1):app.Data.Info.ProbeInfo.ActiveChannel(end))));
else
    AllChannel = length(unique(app.Data.Info.ProbeInfo.ycoords(app.Data.Info.ProbeInfo.ActiveChannel)));
end

% origActiveDataChannel = ActiveDataChannel;
ChannelBeforeActive = 0;
if PreservePlotChannelLocations
    if Data.Info.ProbeInfo.ActiveChannel(1)-1 ~=0
        ChannelBeforeActive = Data.Info.ProbeInfo.ActiveChannel(1)-1;
        ActiveDataChannel = ActiveDataChannel - (Data.Info.ProbeInfo.ActiveChannel(1)-1);
    end
else
    [ActiveDataChannel] = Organize_Convert_ActiveChannel_to_DataChannel(app.Data.Info.ProbeInfo.ActiveChannel,ActiveDataChannel,'MainPlot');
end

% find out gaps on the left or right of the probe to leave out
if ~PreservePlotChannelLocations
    if str2double(Data.Info.ProbeInfo.NrRows) == 2
        % find gapos in active channel
        d = diff(Data.Info.ProbeInfo.ActiveChannel);
        breakIdx = find(d > 1);
        run_start = [1, breakIdx + 1];
        run_end   = [breakIdx, numel(Data.Info.ProbeInfo.ActiveChannel)];
        gap_start_val = (Data.Info.ProbeInfo.ActiveChannel(run_end(1:end-1)) + 1) ;
        gap_end_val   = (Data.Info.ProbeInfo.ActiveChannel(run_start(2:end)) - 1) ;
        
        IndicieToNotPlot = [];
        for iii = 1:length(gap_end_val)
            if mod(gap_end_val(iii),2)==1 % uneven
                activeindicie = Data.Info.ProbeInfo.ActiveChannel == gap_end_val(iii)+1;
                IndicieToNotPlot = [IndicieToNotPlot,find(activeindicie==1)];
                ActiveDataChannel(ActiveDataChannel>=IndicieToNotPlot(end)) = ActiveDataChannel(ActiveDataChannel>=IndicieToNotPlot(end))+1;
                %SpikeData.Position(SpikeData.Position>=IndicieToNotPlot) = SpikeData.Position(SpikeData.Position>=IndicieToNotPlot) + 1;
            else % nothing - no gap in trace view required
        
            end
        end
    end
end

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
        
        %% Handle Spikes
        if ~isempty(SpikeData)
            if ~isempty(SpikeData.Indicie)
                if PreservePlotChannelLocations==0
                    if sum(Laufvariable==SpikeData.Position)
                        SpikeIndicies = Laufvariable==SpikeData.Position;
                        SpikesForCurrentSubPlot = [SpikesForCurrentSubPlot,SpikeData.Indicie(SpikeIndicies)' + ((nRows-1)*length(Time)+1)];
                    end
                else
                    if sum(Laufvariable==ActiveDataChannel(SpikeData.Position))
                        SpikeIndicies = Laufvariable==ActiveDataChannel(SpikeData.Position);
                        SpikesForCurrentSubPlot = [SpikesForCurrentSubPlot,SpikeData.Indicie(SpikeIndicies)' + ((nRows-1)*length(Time)+1)];
                    end
                end
            end
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

    %% Plot Spikes
    SpikeHandles = findobj(ax, 'Tag', 'TracesSpikes');
    if ~isempty(SpikesForCurrentSubPlot)
        if length(SpikeHandles)>length(SpikesForCurrentSubPlot)
            delete(SpikeHandles(length(SpikesForCurrentSubPlot)+1:end));
            SpikeHandles = findobj(ax, 'Tag', 'TracesSpikes');
        end

        if isempty(SpikeHandles)
            line(ax,SpikesForCurrentSubPlot,mean(DataForCurrentSubPlot),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',2,'Tag','TracesSpikes')
        else
            for i = 1:length(SpikesForCurrentSubPlot)
                if i <= SpikeHandles
                    set(SpikeHandles(i),'XData',SpikesForCurrentSubPlot(i),'YData',mean(DataForCurrentSubPlot),'LineStyle','none','Marker','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',3,'Tag','TracesSpikes')
                else
                    line(ax,SpikesForCurrentSubPlot(i),mean(DataForCurrentSubPlot),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',3,'Tag','TracesSpikes')
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
    drawnow;

    % Plot text above first axis
    if nChannel == 1 && UpdateLinesAndText
        % remove old labels if they exist
        delete(findobj(ax,'Type','text','Tag','RowLabel'))
    
        nBlocks = NumberRowDataChannel;
        blockWidth = length(Time);
    
        yText = ax.YLim(2) + 0.05 * range(ax.YLim);  % slightly above axis
        
        ScaledFontSize = -0.27778 * nBlocks + 15.556;

        for j = 1:nBlocks
            xCenter = (j-1)*blockWidth + blockWidth/2;
            
            if PreservePlotChannelLocations
                Allchannelcurrently = j:length(unique(Data.Info.ProbeInfo.xcoords)):length(Data.Info.ProbeInfo.ActiveChannel);
            else
                Allchannelcurrently = j:length(unique(Data.Info.ProbeInfo.xcoords)):Data.Info.ProbeInfo.ActiveChannel(end);
            end
            
            text(ax, xCenter, yText, ...
                strcat("Ch ", num2str(j+ChannelBeforeActive)," to ",num2str(Allchannelcurrently(end))), ...
                'HorizontalAlignment','center', ...
                'VerticalAlignment','bottom', ...
                'FontSize', ScaledFontSize, ...
                'Color', 'k', ...
                'Clipping','off', ...     % IMPORTANT
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
            strcat("Signal from ",num2str(Center-app.Slider.Value)," to ",num2str(Center+app.Slider.Value)," mV"), ...             % change as needed
            'HorizontalAlignment','right', ...
            'VerticalAlignment','middle', ...
            'FontSize', 6, ...
            'Color', 'k', ...
            'Clipping','off', ...
            'Tag','LeftAxisLabel');
    end
    %plot text to the left of each column with data


end

