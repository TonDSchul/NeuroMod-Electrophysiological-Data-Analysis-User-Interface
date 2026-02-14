function [CurrentClim,CurrentPlotData] = Event_Module_Wavelet_Coherence(Data,EventRelatedData1,EventRelatedData2,Window,BaselineNormalize,BaselineWindow,TF,CurrentClim,Figure,SampleRate,PlotAppearance,Time,CurrentPlotData,TwoORThreeD)

%________________________________________________________________________________________
%% Function to conducr wavelet coherence analysis

% Input Arguments:


% Output:

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


TimeToPlot = Data.Info.EventRelatedTime;

[CoherenceC,~,Freqs,coi] = wcoherence(EventRelatedData1, EventRelatedData2, SampleRate,...
    'VoicesPerOctave', TF.FreqRange(2),'FrequencyLimits', [TF.FreqRange(1) TF.FreqRange(3)],...
    'NumScales',TF.NumScales);

cla(Figure)
% Actual Plot
figTemp = figure('Visible','off');  % invisible figure

wcoherence(EventRelatedData1, EventRelatedData2, SampleRate,...
    'VoicesPerOctave', TF.FreqRange(2),'FrequencyLimits', [TF.FreqRange(1) TF.FreqRange(3)],...
    'NumScales',TF.NumScales);

axTemp = gca;  % get axes from temporary figure

% Copy all children from temp axes to UIAxes
copyobj(allchild(axTemp), Figure);

% Copy axis properties (optional)
Figure.XLim = axTemp.XLim;
Figure.YLim = axTemp.YLim;
Figure.YDir = axTemp.YDir;
Figure.Layer = axTemp.Layer;
Figure.CLim = axTemp.CLim;

% Close temporary figure
close(figTemp);

helperPlotCoherence(Figure,[],Freqs,coi)
%% Plot

%% Plot Event line
EventHandle = findobj(Figure, 'Tag', 'EventLine');
if length(EventHandle)>1
    delete(EventHandle(2:end));
end

if strcmp(TwoORThreeD,"ThreeD")
    % Define the Y and Z ranges
    Y = [log2(Freqs(1)), log2(Freqs(end))];
    Z = [min(CoherenceC(~isinf(CoherenceC)),[],'all'), max(CoherenceC(~isinf(CoherenceC)),[],'all')];  
    
    % Create a plane through Y and Z
    [YGrid, ZGrid] = meshgrid(Y, Z);
    
    XGrid = zeros(size(YGrid));
    
    if isempty(EventHandle)
        eventLine=surf(Figure,XGrid, YGrid, ZGrid, 'FaceColor', PlotAppearance.TFWindow.TriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
    else
        set(EventHandle(1),'XData',XGrid,'YData', YGrid,'ZData', ZGrid, 'FaceColor', PlotAppearance.TFWindow.TriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
        eventLine = EventHandle(1);
    end

else
    if abs(Data.Info.EventRelatedTime(1)) + Data.Info.EventRelatedTime(end)>1
        Evtime = abs(Data.Info.EventRelatedTime(1)); % s
    else
        Evtime = abs(Data.Info.EventRelatedTime(1))*1000; % ms
    end

    if isempty(EventHandle)
        eventLine = line(Figure,[Evtime,Evtime],[min(log2(Freqs)) max(log2(Freqs))],'Color',PlotAppearance.TFWindow.TriggerColor ,'LineWidth',PlotAppearance.TFWindow.TriggerLineWidth,'Tag', 'EventLine');
    else
        set(EventHandle(1),'XData',[Evtime,Evtime],'YData',[min(log2(Freqs)) max(log2(Freqs))],'Tag','Events');
        eventLine = EventHandle(1);
    end
end

axis(Figure, 'xy');% correct orientation

CurrentClim(1) = min(CoherenceC(~isinf(CoherenceC)),[],'all');
CurrentClim(2) = max(CoherenceC(~isinf(CoherenceC)),[],'all');
cbar_handle=colorbar('peer',Figure,'location','EastOutside');
cbar_handle.Label.String = "Magnitude-Squared Coherence";
cbar_handle.Label.Rotation = 270;
cbar_handle.Color = 'k';  
cbar_handle.Label.Color = 'k';        % Sets the color of the label text
Figure.XLabel.Color = [0 0 0];
Figure.YLabel.Color = [0 0 0];       
Figure.YColor = 'k';  
%UIAxes.XTickLabelMode = 'auto';
Figure.XColor = 'k';  
Figure.Title.Color = 'k';  
Figure.Box ="off";

if TF.ChannelTriggerToCompareType(1)==1
    title(Figure,strcat("Time Varying Coherence for Channel ",num2str(TF.SingleChannelSelected)," Between Trials ",num2str(TF.ChannelTriggerToCompare(1))," and ",num2str(TF.ChannelTriggerToCompare(2))));
else
    title(Figure,strcat("Time Varying Coherence for Trials ",num2str(TF.EventNrRange)," Between Channel ",num2str(TF.ChannelTriggerToCompare(1))," and ",num2str(TF.ChannelTriggerToCompare(2))));
end

xlabel(Figure,PlotAppearance.TFWindow.XLabel), ylabel(Figure,strcat(PlotAppearance.TFWindow.YLabel,' (log scale)'))

% Save data for export
CurrentPlotData.TFPowerXData = TimeToPlot;
CurrentPlotData.TFPowerYData = Freqs;
CurrentPlotData.TFPowerCData = CoherenceC;
CurrentPlotData.TFPowerType = strcat("Time Varying Coherence for Channel ",num2str(TF.SingleChannelSelected));
CurrentPlotData.TFPowerXTicks = Figure.XTickLabel;

hLine = findobj(Figure, 'Type', 'Line', 'DisplayName', 'data1');
hDummy = quiver(Figure,NaN, NaN, NaN, NaN, 'k');  % invisible, just for legend

% Add legend only once
if isempty(findobj(Figure, 'Type', 'legend'))
    legendHandles = [eventLine, hLine, hDummy];
    legendLabels  = {'Trigger', 'COI Boundary', 'Phase Direction'};
    
    % Create legend if it doesn't exis
    legendHandle = legend(Figure, legendHandles, legendLabels);
    set(legendHandle, 'HandleVisibility', 'off');

end