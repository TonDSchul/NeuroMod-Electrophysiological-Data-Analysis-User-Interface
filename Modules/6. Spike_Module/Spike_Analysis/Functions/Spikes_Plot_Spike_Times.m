function Spikes_Plot_Spike_Times(Type,rgb_matrix,Time,SpikeTimes,SpikePositions,SpikeCluster,SpikeAmps,ChannelPositions,Figure,numCluster,Clustertoshow,PlotEvents,EventIndicies,ChannelSelection,ChannelSpacing)

%________________________________________________________________________________________
%% Function to plot spike times with amplitude color coding
% This function uses a functions from the spike repository from Nick
% Steinmetz on Github: https://github.com/cortex-lab/spikes
%Function used: plotDriftmap -- function was modified to fit the purpose of this Toolbox

% This function is called on startup of the event spike windows and continous spike windows to plot the
% spike map or when the user selects spike map as visualization

% Inputs:
% 1. Type: Type of spike window calling this function: Either "Continous" OR "Eventrelated"
% 2. rgb_matrix: nunits x 3 double with rgb values to give unit plots
% colors
% 3. Time: 1 x ntime double with time in seconds
% 4. SpikeTimes: nspikes x 1 double with just spike time (in seconds) within the
% channelrange (negativ for spikes before event)
% 5. SpikePositions: nspikes x 1 double with spikeposition in um within the
% channelrange (for internal spikes: nchannel*Channelspacing)
% 6. SpikeCluster: nspikes x 1 double with unit/cluster indicie for spike
% as integer - for internal: just 1 since no clustering is done
% 7. SpikeAmps: nspikes x 1 double with just spike amplitudes within the
% channelrange
% 8. ChannelPositions: nchannelx2 double. :,1 is x coordinate (all 0 for
% linear probe), :,2 is y coordinate (cahnneldepth in um)
% 9. Figure: Figure axes handle to plot in
% 10. numCluster: double, number of cluster/units
% 11. Clustertoshow: char, 'All' OR 'Non' or number as char like '1' for
% unit 1
% 12. PlotEvents: 1 to plot eventlines, 0 if not
% 13. EventIndicies: 1xnevents double with indicies of events to plot (in samples)
% 14. ChannelSelection: 1x2 double with channelselction, i.e. [1,10] for
% channel 1 to 10
% 15. ChannelSpacing: double in um, from Data.Info.ChannelSpacing

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if ~strcmp(Type,"Eventrelated")
    negativeIndicies = find(SpikeTimes <= 0);
    
    if ~isempty(negativeIndicies)
        SpikeTimes(negativeIndicies) = 1;
    end
end

NumChannel = length(ChannelSelection(1):ChannelSelection(2));

%% Plot Spikes
xlim(Figure,[Time(1),Time(end)]);
ylim(Figure,[0,((NumChannel)*ChannelSpacing)]);
ylabel(Figure,'Depth (um)')

title(Figure,strcat("Spike Positions Across Time and Depth Channel ", num2str(ChannelSelection)));

Figure.FontSize = 10;

Spikeline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Spikes');

% Delete handles of event plots if too many accumulated or if no events
% selceted

% Then delete handles for spike plot
if numel(Spikeline_handles)>numCluster
    delete(Spikeline_handles(numCluster+1:end));
end

Spikeline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Spikes');

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
        
        IndiciesCurrentCluster = SpikeCluster == i; %% 

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
            line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(str2double(Clustertoshow),:),'MarkerEdgeColor',rgb_matrix(str2double(Clustertoshow),:),'MarkerSize',3, 'Parent', Figure, 'Tag', 'ClusterSpikes');
        elseif strcmp(Type,"Eventrelated")
            line(Figure,SpikeTimes(IndiciesCurrentCluster),SpikePositions(IndiciesCurrentCluster),'LineStyle', 'none', 'Marker', 'o','MarkerFaceColor', rgb_matrix(str2double(Clustertoshow),:),'MarkerEdgeColor',rgb_matrix(str2double(Clustertoshow),:),'MarkerSize',3, 'Parent', Figure, 'Tag', 'ClusterSpikes');
        end
    end
end

if strcmp(Type,"Eventrelated")
    %% Plot Event line
    Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
    if length(Event_handles)>1
        delete(Event_handles(2:end));
        Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
    end

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
        legend(Figure, 'on');
        %% Plot Event line
        Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
        delete(Event_handles(:));

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

    else
        Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
        delete(Event_handles(:));
        
        legend(Figure, 'off');
        
    end
end