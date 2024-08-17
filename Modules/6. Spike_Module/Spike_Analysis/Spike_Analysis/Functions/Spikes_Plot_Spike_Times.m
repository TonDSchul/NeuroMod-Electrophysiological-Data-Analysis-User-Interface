function Spikes_Plot_Spike_Times(Type,rgb_matrix,Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmps,ChannelPositions,Figure,numCluster,Clustertoshow,PlotEvents,EventIndicies,ChannelSelection,ChannelSpacing)

if ~strcmp(Type,"Eventrelated")
    negativeIndicies = find(SpikeTimes <= 0);
    
    if ~isempty(negativeIndicies)
        SpikeTimes(negativeIndicies) = 1;
    end
end

NumChannel = length(ChannelSelection(1):ChannelSelection(2));

%% Plot Spikes
xlim(Figure,[Time(1),Time(end)]);
ylim(Figure,[ChannelSpacing/2,(NumChannel*ChannelSpacing)+(ChannelSpacing/2)]);
ylabel(Figure,'Depth (um)')

title(Figure,strcat("Spike Positions Across Time and Depth Channel ", num2str(ChannelSelection)));

Figure.FontSize = 10;

Spikeline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Spikes');
Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');

% Delete handles of event plots if too many accumulated or if no events
% selceted

% Then delete handles for spike plot
if numel(Spikeline_handles)>numCluster
    delete(Spikeline_handles(numCluster+1:end));
end

if numel(Event_handles)>1
    delete(Event_handles(2:end));
end

Spikeline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Spikes');
Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');

%% Plot Spikes
if strcmp(Clustertoshow,"All")

    SpikeAmps_handles = findobj(Figure,'Type', 'line', 'Tag', 'SpikeAmps');

    if ~isempty(SpikeAmps_handles)
        for i = 1:length(SpikeAmps_handles)
            if strcmp(get(SpikeAmps_handles(i), 'Tag'), 'SpikeAmps')
                delete(SpikeAmps_handles(i));
            end
        end
    end
    SpikeCluster_handles = findobj(Figure,'Type', 'line', 'Tag', 'ClusterSpikes');
    if ~isempty(SpikeCluster_handles)
        for i = 1:length(SpikeCluster_handles)
            if strcmp(get(SpikeCluster_handles(i), 'Tag'), 'ClusterSpikes')
                delete(SpikeCluster_handles(i));
            end
        end
    end

    for i = 1:numCluster

        IndiciesCurrentCluster = SpikeCluster == i-1; %% -1 bc. spike SpikeCluster output from kilosrt starts with 0. With 51 SpikeCluster found, SpikeCluster number is 0:50

        if isempty(Spikeline_handles)
            if strcmp(Type,"Continous") 
                line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(i,:),'MarkerEdgeColor',rgb_matrix(i,:),'MarkerSize',1.5, 'Parent', Figure, 'Tag', 'Spikes');
            elseif strcmp(Type,"Eventrelated") 
                line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(i,:),'MarkerEdgeColor',rgb_matrix(i,:),'MarkerSize',1.5, 'Parent', Figure, 'Tag', 'Spikes');
            end
        elseif ~isempty(Spikeline_handles) 
            if i <= length(Spikeline_handles)
                if strcmp(Type,"Continous") 
                    set(Spikeline_handles(i), 'XData', SpikeTimes(IndiciesCurrentCluster), 'YData', SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(i,:),'MarkerEdgeColor',rgb_matrix(i,:),'MarkerSize',1.5, 'Parent', Figure, 'Tag', 'Spikes');
                elseif strcmp(Type,"Eventrelated") 
                    set(Spikeline_handles(i), 'XData', SpikeTimes(IndiciesCurrentCluster), 'YData', SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(i,:),'MarkerEdgeColor',rgb_matrix(i,:),'MarkerSize',1.5, 'Parent', Figure, 'Tag', 'Spikes');
                end
            else
                if strcmp(Type,"Continous") 
                    line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(i,:),'MarkerEdgeColor',rgb_matrix(i,:),'MarkerSize',1.5, 'Parent', Figure, 'Tag', 'Spikes');
                elseif strcmp(Type,"Eventrelated") 
                    line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(i,:),'MarkerEdgeColor',rgb_matrix(i,:),'MarkerSize',1.5, 'Parent', Figure, 'Tag', 'Spikes');
                end
            end
        end

    end

elseif strcmp(Clustertoshow,"Non")
    opt = [];
    Segmentlength = 200;
    if strcmp(Type,"Continous") 
        [Figure] = plotDriftmap(SpikeTimes, SpikeAmps, SpikePositions(:), Figure, opt, Segmentlength);  
    elseif strcmp(Type,"Eventrelated")
        [Figure] = plotDriftmap(SpikeTimes, SpikeAmps, SpikePositions(:), Figure, opt, Segmentlength);   
    end

    SpikeCluster_handles = findobj(Figure,'Type', 'line', 'Tag', 'ClusterSpikes');
    if ~isempty(SpikeCluster_handles)
        for i = 1:length(SpikeCluster_handles)
            if strcmp(get(SpikeCluster_handles(i), 'Tag'), 'ClusterSpikes')
                delete(SpikeCluster_handles(i));
            end
        end
    end
    Spike_handles = findobj(Figure,'Type', 'line', 'Tag', 'Spikes');
    if ~isempty(Spike_handles)
        for i = 1:length(Spike_handles)
            if strcmp(get(Spike_handles(i), 'Tag'), 'Spikes')
                delete(Spike_handles(i));
            end
        end
    end

else %% If specific spike SpikeCluster selected
    
    SpikeAmps_handles = findobj(Figure,'Type', 'line', 'Tag', 'SpikeAmps');
    SpikeCluster_handles = findobj(Figure,'Type', 'line', 'Tag', 'ClusterSpikes');

    if isempty(SpikeAmps_handles)
        opt = [];
        Segmentlength = 200;
        if strcmp(Type,"Continous")
            [Figure] = plotDriftmap(SpikeTimes, SpikeAmps, SpikePositions(:), Figure, opt, Segmentlength);   
        elseif strcmp(Type,"Eventrelated")
            [Figure] = plotDriftmap(SpikeTimes, SpikeAmps, SpikePositions(:), Figure, opt, Segmentlength);   
        end
    end

    Spike_handles = findobj(Figure,'Type', 'line', 'Tag', 'Spikes');
    if ~isempty(Spike_handles)
        for i = 1:length(Spike_handles)
            if strcmp(get(Spike_handles(i), 'Tag'), 'Spikes')
                delete(Spike_handles(i));
            end
        end
    end

    if ~isempty(SpikeCluster_handles)
        for i = 1:length(SpikeCluster_handles)
            if strcmp(get(SpikeCluster_handles(i), 'Tag'), 'ClusterSpikes')
                delete(SpikeCluster_handles(i));
            end
        end
    end

    IndiciesCurrentCluster = SpikeCluster == str2double(Clustertoshow);

    if sum(IndiciesCurrentCluster) > 0
        if strcmp(Type,"Continous")
            line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(str2double(Clustertoshow)+1,:),'MarkerEdgeColor',rgb_matrix(str2double(Clustertoshow)+1,:),'MarkerSize',3, 'Parent', Figure, 'Tag', 'ClusterSpikes');
        elseif strcmp(Type,"Eventrelated")
            line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(str2double(Clustertoshow)+1,:),'MarkerEdgeColor',rgb_matrix(str2double(Clustertoshow)+1,:),'MarkerSize',3, 'Parent', Figure, 'Tag', 'ClusterSpikes');
        end
    end

end

if strcmp(Type,"Eventrelated")
    %% Plot Event line
    Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
    if isempty(Event_handles)
        eventLine = line(Figure,[Time(Time==0),Time(Time==0)],[0,ChannelPositions(end,2)],'Color','r','LineWidth',2, 'Parent', Figure, 'Tag', 'Event');
    else
        set(Event_handles(1), 'XData', [Time(Time==0),Time(Time==0)], 'YData', [0,ChannelPositions(end,2)], 'Parent', Figure, 'Tag', 'Event');
        eventLine = Event_handles(1);
    end
    
    % Bring the event line to the front
    uistack(eventLine, 'top');
    
    % Add legend only once
    if isempty(findobj(Figure, 'Type', 'legend'))
        % Create legend with imagesc and event line
        legendHandle = legend(eventLine, {'Trigger'});
        set(legendHandle, 'HandleVisibility', 'off');
    end
elseif strcmp(Type,"Continous")
    if PlotEvents
        %% Plot Event line
        
        for i = 1:length(EventIndicies)
            line(Figure,[EventIndicies(i),EventIndicies(i)],[0,ChannelPositions(end,2)],'Color','k','LineWidth',1.5, 'Tag', 'Event');
            Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
            eventLine = Event_handles(1);
        end
         
        if ~isempty(eventLine)
            % Bring the event line to the front
            uistack(eventLine, 'top');
    
            % Add legend only once
            if isempty(findobj(Figure, 'Type', 'legend'))
                % Create legend with imagesc and event line
                legendHandle = legend(eventLine, {'Trigger'});
                set(legendHandle, 'HandleVisibility', 'off');
            end
        end
    end
end