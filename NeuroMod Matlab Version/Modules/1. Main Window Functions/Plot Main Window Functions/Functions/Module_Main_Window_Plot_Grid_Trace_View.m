function YlimMaxVlaues = Module_Main_Window_Plot_Grid_Trace_View(app,Data,PlotData,Time,BaselineNorm,PlotAppearance,ActiveDataChannel,PreservePlotChannelLocations,SpikeData,EventERP,MainPlot,YlimMaxVlaues)

%% Setup

AllRows = length(unique(Data.Info.ProbeInfo.xcoords));

[PlotData,SpikeDataCell,Time] = Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Data.Info,PlotData,Time,ActiveDataChannel,PreservePlotChannelLocations,SpikeData,'All');

ChannelBeforeActive = 0;

[AllChannel,ActiveDataChannel,~] = Module_MainWindow_ActiveChannel_ChannerlNumber_Grid_Traces(Data.Info,SpikeData,"NumChan",ActiveDataChannel,PreservePlotChannelLocations);

%% Loop over channels

%Which rows affected?
[MatrixIndexedActiveDataChannel, ~] = deal( ceil(ActiveDataChannel/size(PlotData,2)), mod(ActiveDataChannel-1,size(PlotData,2))+1 );
MatrixIndexedActiveDataChannel = unique(MatrixIndexedActiveDataChannel);

Laufvariable = 1;

for NActive = 1:length(MatrixIndexedActiveDataChannel)

    % Create one axes for this channel
    
    nChannel = MatrixIndexedActiveDataChannel(NActive);
    ax = app.ChannelAxes{nChannel};
    hold(ax,'on')
    
    DataForCurrentSubPlot = zeros(1,length(Time)*AllRows);
    TimeForCurrentSubPlot = zeros(1,length(Time)*AllRows);

    NumberRowDataChannel = 0;
    
    TraceHandles = findobj(ax, 'Type', 'line', 'Tag', 'Traces');
    BorderHandles = findobj(ax, 'Type', 'line', 'Tag', 'Border');
    EventHandles = findobj(ax, 'Type', 'line', 'Tag', 'Events');
    ImageSCHandles = findobj(ax, 'Tag', 'ImagSCPlot');

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

    if ~strcmp(EventERP,"EventWindowpcolor")
        delete(ImageSCHandles)
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
            if strcmp(EventERP,"EventWindowpcolor")
                v2d = DataForCurrentSubPlot(:)';   
                v2d = [v2d; v2d];                 
                
                imagesc(ax, v2d,'Tag','ImagSCPlot');           
                shading(ax, 'flat'); 
                ylim(ax,[1,2])
            else
                line(ax,1:length(DataForCurrentSubPlot), DataForCurrentSubPlot, 'Color', 'b','LineWidth',1.5, 'Tag', 'Traces')
            end
        else
            %line(ax,1,1, 'Tag', 'Traces')
        end
    else
        if sum(isnan(DataForCurrentSubPlot))<length(DataForCurrentSubPlot)
            if strcmp(EventERP,"EventWindowpcolor")
                v2d = DataForCurrentSubPlot(:)';   
                v2d = [v2d; v2d];                  
                
                set(ax,'CData',v2d,'Tag','ImagSCPlot')
                %imagesc(ax, v2d,'Tag','ImagSCPlot');           
                %shading(ax, 'flat');   
                ylim(ax,[1,2])
            else
                set(TraceHandles(1), 'XData', 1:length(DataForCurrentSubPlot), 'YData', DataForCurrentSubPlot, 'Tag', 'Traces');
            end
        else
            delete(TraceHandles(1));
        end
    end
    
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
    
    %% ylim   
    if app.Slider.Value == 0
        app.Slider.Value = 0.000001;
    end

    if ~strcmp(EventERP,"EventWindowpcolor")
        if BaselineNorm == 1
            ylim(ax,[-app.Slider.Value, app.Slider.Value]);
        else
            ylim(ax,[min(DataForCurrentSubPlot)-app.Slider.Value, max(DataForCurrentSubPlot)+app.Slider.Value]);
        end
    else
        if BaselineNorm == 1
            clim(ax,[-app.Slider.Value, app.Slider.Value]);
        else
            clim(ax,[min(DataForCurrentSubPlot)-app.Slider.Value, max(DataForCurrentSubPlot)+app.Slider.Value]);
        end
    end

    %% Vertical lines separating rows
    Plotobject = [];
    if isempty(BorderHandles)
        for j = 1:NumberRowDataChannel
            idx = length(Time)*j;
            line(ax,[idx, idx], ax.YLim, 'LineWidth', 1.2, 'Color', 'k', 'Tag', 'Border')
        end
    else
        if strcmp(EventERP,"EventWindowAll") || strcmp(EventERP,"EventWindowLines") || MainPlot
            if UpdateLinesAndText
                for j = 1:NumberRowDataChannel
                    idx = length(Time)*j;
                    if sum(BorderHandles(j).XData == idx)<2
                        set(BorderHandles(j), 'XData', [idx, idx], 'LineWidth', 1.2, 'Color', 'k', 'Tag', 'Border');
                    end
                    if sum(BorderHandles(j).YData == ax.YLim)<2
                        set(BorderHandles(j), 'YData', ax.YLim, 'LineWidth', 1.2, 'Color', 'k', 'Tag', 'Border');
                    end

                    if strcmp(EventERP,"EventWindowpcolor")
                        if ~isempty(BorderHandles) && length(BorderHandles)<=NumberRowDataChannel
                            uistack(BorderHandles(j), 'top')
                        end
                    end

                end
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
    
    % remove old labels if they exist
    delete(findobj(ax,'Type','text','Tag','LeftAxisLabel'))

    % horizontal offset (to the left of axis)
    xOffset = -0.05 * range(ax.XLim);  

    % vertical position: middle of the axis
    yText = mean(ax.YLim, 'omitnan');
    
    if ~strcmp(EventERP,"EventWindowpcolor")
        text(ax, 1, yText, ...
            strcat("Signal from ",num2str(ax.YLim(1))," to ",num2str(ax.YLim(2))," mV"), ...             
            'HorizontalAlignment','right', ...
            'VerticalAlignment','middle', ...
            'FontSize', 6, ...
            'Color', 'k', ...
            'Clipping','off', ...
            'Tag','LeftAxisLabel');
    else
        text(ax, 1, yText, ...
            strcat("Signal from ",num2str(ax.CLim(1))," to ",num2str(ax.CLim(2))," mV"), ...             
            'HorizontalAlignment','right', ...
            'VerticalAlignment','middle', ...
            'FontSize', 6, ...
            'Color', 'k', ...
            'Clipping','off', ...
            'Tag','LeftAxisLabel');
    end
    
    %% If event realted ERP: Plot event trigger time
    if strcmp(EventERP,"EventWindowAll") || strcmp(EventERP,"EventWindowLines") || strcmp(EventERP,"EventWindowpcolor") 
        %if firsttimeindicator || isempty(EventHandles)
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
       %end
    end
end

