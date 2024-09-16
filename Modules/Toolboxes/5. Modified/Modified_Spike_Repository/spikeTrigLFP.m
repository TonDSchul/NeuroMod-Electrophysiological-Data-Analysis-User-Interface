function [mnLFP,CurrentPlotData] = spikeTrigLFP(Data, tLFP, lfpdat, theseST, SpikePositions, ChanneltoPlot, winAroundSpike, Figure,SR,Textarea,ChannelSpacing,AppWidnow,Plot,TwoORThreeD,ClustertoShow,CurrentPlotData)
% function mnLFP = spikeTrigLFP(tLFP, lfpdat, theseST, winAroundSpike)
%
% returns nChannels x nTimePoints mean spike-triggered LFP. 
%
% Inputs:
% - tLFP - 1 x nLFP - vector of time points at which the lfp was sampled
% (s)
% - lfpdat - nChannels x nLFP - the lfp data (any units)
% - theseST - nSpikes x 1 - spike times (s)
% - winAroundSpike - 1 x nTimePoints - time points around each spike to
% include
% the time points to sample LFP at

Time = winAroundSpike;

sampTimes = bsxfun(@plus, theseST, winAroundSpike);
    
mnLFP = zeros(size(lfpdat,1), numel(winAroundSpike));
lfpdat = double(lfpdat);
% compute the spike-trig LFP chunk-by-chunk (this one seems faster)
h = waitbar(0, 'Extracting Spike Triggered LFP...', 'Name','Extracting Spike Triggered LFP...');

% compute the spike-trig LFP channel-by-channel
for ch = 1:size(lfpdat,1)
    if mod(ch,10)==0
        fprintf(1, 'ch %d/%d...\n', ch, size(lfpdat,1));
    end
    mnLFP(ch,:) = mean(interp1(tLFP, lfpdat(ch,:)', sampTimes),1,'omitnan');
    % Update the progress bar
    fraction = ch/size(lfpdat,1);
    msg = sprintf('Extracting Spike Triggered LFP... (%d%% done)', round(100*fraction));
    waitbar(fraction, h, msg);
end

% nChunk = 4;
% chunkBounds = linspace(0,max(tLFP),nChunk+1);
% for n = 1:nChunk
%     fprintf(1, 'chunk %d/%d...\n', n, nChunk);
%     Textarea.Value = strcat("Analyzing Datachunk "," ",num2str(n)," of "," ", num2str(nChunk));
%     pause(0.01);
%     inclSamps = tLFP>chunkBounds(n) & tLFP<=chunkBounds(n+1);
%     inclSpikes = theseST>chunkBounds(n) & theseST<=chunkBounds(n+1);
%     mnLFP = mnLFP+squeeze(mean(interp1(tLFP(inclSamps), ...
%         lfpdat(:,inclSamps)', sampTimes(inclSpikes,:)),1,'omitnan'))';
%     % Update the progress bar
%     fraction = n/nChunk;
%     msg = sprintf('Extracting Spike Triggered LFP... (%d%% done)', round(100*fraction));
%     waitbar(fraction, h, msg);
% end

% mnLFP = mnLFP/nChunk;

close(h); % waitbar

if Plot
 
    Time = Time*1000; % convert to ms

    ydata = 0:ChannelSpacing:(size(mnLFP,1)-1)*ChannelSpacing;
    
    if strcmp(TwoORThreeD,"ThreeD")
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
        
        if length(PowerDepth2D_handles)>1
            delete(PowerDepth2D_handles(2:end));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        elseif length(PowerDepth3D_handles)>1
            delete(PowerDepth3D_handles(2:end));
            PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
        end
        
        if length(PowerDepth3D_handles)+length(PowerDepth2D_handles)==1
            delete(PowerDepth3D_handles(:));
            delete(PowerDepth2D_handles(:));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
            PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
        end
    
        if isempty(PowerDepth2D_handles) || isempty(PowerDepth3D_handles)
            %3D
            surf(Figure,Time,ydata,mnLFP,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            %2D
            % 2D Plot
            min_z = min(mnLFP,[],'all');
            surface(Figure,Time,ydata, min_z * ones(size(mnLFP)), ...
            'CData', mnLFP, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            %3D
            set(PowerDepth3D_handles(1),'XData',Time,'YData',ydata,'ZData',mnLFP,'CData',mnLFP,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            %2D
            % 2D Plot
            min_z = min(mnLFP,[],'all');
            set(PowerDepth2D_handles(1),'XData',Time,'YData',ydata,'ZData', min_z * ones(size(mnLFP)), ...
            'CData', mnLFP, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        end

        view(Figure,45,45);
        box(Figure, 'off');
        grid(Figure, 'off');

        Event_handles = findobj(Figure,'Tag', 'Event');
        if numel(Event_handles)>1
            delete(Event_handles(2:end));
        end

        % Define the Y and Z ranges
        Y = [ydata(1), ydata(end)];
        Z = [min(mnLFP,[],'all'), max(mnLFP,[],'all')];  
        
        % Create a plane through Y and Z
        [YGrid, ZGrid] = meshgrid(Y, Z);
        
        XGrid = zeros(size(YGrid));
        if isempty(Event_handles)
            eventLine=surf(Figure,XGrid, YGrid, ZGrid, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'EdgeColor', 'none','Tag', 'Event');
        else
            set(Event_handles(1),'XData',XGrid,'YData', YGrid,'ZData', ZGrid, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'EdgeColor', 'none','Tag', 'Event');
            eventLine = Event_handles(1);
        end

    elseif strcmp(TwoORThreeD,"TwoD")
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        if length(PowerDepth2D_handles)>1
            delete(PowerDepth2D_handles(2:end));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        end
    
        min_z = 0;
        if isempty(PowerDepth2D_handles)
            surface(Figure,Time,ydata, min_z * ones(size(mnLFP)), ...
            'CData', mnLFP, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            set(PowerDepth2D_handles(1),'XData',Time,'YData',ydata,'ZData', min_z * ones(size(mnLFP)), ...
            'CData', mnLFP, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        end 

        Event_handles = findobj(Figure,'Tag', 'Event');
        if numel(Event_handles)>1
            delete(Event_handles(2:end));
        end
        
        if isempty(Event_handles)
            eventLine = line(Figure,[Time(Time==0),Time(Time==0)],[ydata(1),ydata(end)],'Color','r','LineWidth',2, 'Parent', Figure,'Tag', 'Event');
        else
            set(Event_handles(1),'XData',[Time(Time==0),Time(Time==0)],'YData',[ydata(1),ydata(end)],'Color','r','LineWidth',2, 'Parent', Figure,'Tag', 'Event');
            eventLine = Event_handles(1);
        end
        uistack(eventLine, 'top');
    end
        
    % Add legend only once
    if isempty(findobj(Figure, 'Type', 'legend'))
        % Create legend with imagesc and event line
        legendHandle = legend(eventLine, {'Spikes Time'});
        set(legendHandle, 'HandleVisibility', 'off');
    end
    if strcmp(ClustertoShow,"All") || strcmp(ClustertoShow,"Non")
        title(Figure,'All Units Spike Triggered LFP')
    else
        title(Figure,strcat("Unit ",ClustertoShow," Spike Triggered LFP"));
    end
    
    xlabel(Figure,'Time [ms]')
    ylabel(Figure,'Depth [µm]')
    xlim(Figure,[min(Time) max(Time)]);
    if ydata(1)~=ydata(end)
        ylim(Figure,[ydata(1),ydata(end)])
    end
    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    cbar_handle.Label.String = "LFP [mV]";
    set(Figure, 'YDir', 'reverse');
    
    %Add xticks
    Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);
end

CurrentPlotData.MainXData = Time;
CurrentPlotData.MainYData = ydata;
CurrentPlotData.MainCData = mnLFP;

if strcmp(AppWidnow,"Continous")
    if strcmp(Data.Info.SpikeType,"Kilosort")
        CurrentPlotData.MainType = strcat("Continous Kilosort Spikes: Spike Triggered Average");
    else
        CurrentPlotData.MainType = strcat("Continous Internal Spikes: Spike Triggered Average");
    end
else
    if strcmp(Data.Info.SpikeType,"Kilosort")
        CurrentPlotData.MainType = strcat("Events Kilosort Spikes: Spike Triggered Average");
    else
        CurrentPlotData.MainType = strcat("Events Internal Spikes: Spike Triggered Average");
    end
end

CurrentPlotData.MainXTicks = Figure.XTickLabel;