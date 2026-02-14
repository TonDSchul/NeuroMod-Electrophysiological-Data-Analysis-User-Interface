function [CurrentClim,CurrentPlotData] = Analyse_Main_Window_Wavelet_Coherence(Data,ChannelData1,ChannelData2,TF,CurrentClim,Figure,SampleRate,PlotAppearance,Time,CurrentPlotData,TwoORThreeD,PlotEvent,EventsToShow,CurrentEventChannel,StartSample)

%________________________________________________________________________________________
%% Function to conducr wavelet coherence analysis

% Input Arguments:


% Output:

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


TimeToPlot = Time;

[CoherenceC,~,Freqs,coi] = wcoherence(ChannelData1, ChannelData2, SampleRate,...
    'VoicesPerOctave', TF.FreqRange(2),'FrequencyLimits', [TF.FreqRange(1) TF.FreqRange(3)],...
    'NumScales',TF.NumScales);

cla(Figure)
% Actual Plot
figTemp = figure('Visible','off');  % invisible figure

wcoherence(ChannelData1, ChannelData2, SampleRate,...
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

title(Figure,strcat("Time Varying Coherence Between Channel ",num2str(TF.ChannelTriggerToCompare(1))," and ",num2str(TF.ChannelTriggerToCompare(2))));

xlabel(Figure,PlotAppearance.LiveSpectrogramWindow.XLabel), ylabel(Figure,strcat(PlotAppearance.LiveSpectrogramWindow.YLabel,' (log scale)'))

%% for later for legend but already here as unique thing in Analyse_Main_Window_Plot_Events to know its coming from here
%hLine = findobj(Figure, 'Type', 'Line', 'DisplayName', 'data1');
hDummy = quiver(Figure,NaN, NaN, NaN, NaN, 'k');  % invisible, just for legend
dummycoh = plot(Figure,0,0,'Color','w');

%% --------------- Handle Events ---------------

if strcmp(PlotEvent,'Events')
    if Time(end)-Time(1)>1 % in seconds
        Analyse_Main_Window_Plot_Events(Figure,Data,Time,EventsToShow,TF.FreqRange(1),TF.FreqRange(3),SampleRate,CurrentEventChannel)
    else % in ms
        Analyse_Main_Window_Plot_Events(Figure,Data,Time,EventsToShow,TF.FreqRange(1),TF.FreqRange(3),SampleRate,CurrentEventChannel)
    end

else
    Eventline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Events');
    delete(Eventline_handles); 
end

% Save data for export
CurrentPlotData.LiveSpectroXData = TimeToPlot;
CurrentPlotData.LiveSpectroYData = Freqs;
CurrentPlotData.LiveSpectroCData = CoherenceC;
CurrentPlotData.LiveSpectroType = strcat("Time Varying Coherence for Channel ",num2str(TF.SingleChannelSelected));
CurrentPlotData.LiveSpectroXTicks = Figure.XTickLabel;

% Add legend only once
if isempty(findobj(Figure, 'Type', 'legend'))
    legendHandles = [dummycoh, hDummy];
    legendLabels  = {'COI Boundary', 'Phase Direction'};
    
    % Create legend if it doesn't exis
    legendHandle = legend(Figure, legendHandles, legendLabels);
    set(legendHandle, 'HandleVisibility', 'off');

end



