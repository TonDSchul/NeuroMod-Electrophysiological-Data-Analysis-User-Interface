function mnLFP = spikeTrigLFP(tLFP, lfpdat, theseST, SpikePositions, ChanneltoPlot, winAroundSpike, Figure,SR,Textarea,ChannelSpacing,AppWidnow)
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

Time = Time*1000;

sampTimes = bsxfun(@plus, theseST, winAroundSpike);
    
mnLFP = zeros(size(lfpdat,1), numel(winAroundSpike));

% compute the spike-trig LFP channel-by-channel
    % for ch = 1:size(lfpdat,1)
    %     if mod(ch,10)==0
    %         fprintf(1, 'ch %d/%d...\n', ch, size(lfpdat,1));
    %     end
    %     mnLFP(ch,:) = mean(interp1(tLFP, lfpdat(ch,:)', sampTimes),1);
    % end

% compute the spike-trig LFP chunk-by-chunk (this one seems faster)
h = waitbar(0, 'Extracting Spike Triggered LFP...', 'Name','Extracting Spike Triggered LFP...');

nChunk = 4;
chunkBounds = linspace(0,max(tLFP),nChunk+1);
for n = 1:nChunk
    fprintf(1, 'chunk %d/%d...\n', n, nChunk);
    Textarea.Value = strcat("Analyzing Datachunk "," ",num2str(n)," of "," ", num2str(nChunk));
    pause(0.01);
    inclSamps = tLFP>chunkBounds(n) & tLFP<=chunkBounds(n+1);
    inclSpikes = theseST>chunkBounds(n) & theseST<=chunkBounds(n+1);
    mnLFP = mnLFP+squeeze(nanmean(interp1(tLFP(inclSamps), ...
        lfpdat(:,inclSamps)', sampTimes(inclSpikes,:)),1))';
    % Update the progress bar
   fraction = n/nChunk;
   msg = sprintf('Extracting Spike Triggered LFP... (%d%% done)', round(100*fraction));
   waitbar(fraction, h, msg);
end

close(h);

mnLFP = mnLFP/nChunk;

title(Figure,'Spike Triggered LFP')
xlabel(Figure,'Time [ms]')
ylabel(Figure,'Depth [µm]')
xlim(Figure,[min(Time) max(Time)]);
ylim(Figure,[0 size(mnLFP,1)*ChannelSpacing]);

set(Figure, 'YDir', 'reverse');

imagesc(Figure,Time,0:size(mnLFP,1)*ChannelSpacing,mnLFP);
cbar_handle=colorbar('peer',Figure,'location','WestOutside');
cbar_handle.Label.String = "LFP [mV]";
%% Plot Event line

Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
if isempty(Event_handles)
    eventLine = line(Figure,[Time(Time==0),Time(Time==0)],[1,size(mnLFP,1)*ChannelSpacing],'Color','r','LineWidth',2, 'Parent', Figure, 'Tag', 'Event');
else
    set(Event_handles(1), 'XData', [Time(Time==0),Time(Time==0)], 'YData', [1,size(mnLFP,1)*ChannelSpacing], 'Parent', Figure, 'Tag', 'Event');
    eventLine = Event_handles(1);
end

% Bring the event line to the front
uistack(eventLine, 'top');

% Add legend only once
if isempty(findobj(Figure, 'Type', 'legend'))
    % Create legend with imagesc and event line
    legendHandle = legend(eventLine, {'Spikes'});
    set(legendHandle, 'HandleVisibility', 'off');
end

%Add xticks
Execute_Autorun_Set_Up_Figure(Figure,1,"Non",Time,20,[],[],[],10);