
function plotLFPpower(F, allPowerEst, dispRange, marginalChans, freqBands, BandPowerFigure, FrequencyBandsFigure,WhattoPlot, ChannelSpacing, TwoORThreeD)
% function plotLFPpower(F, allPowerEst, dispRange, marginalChans, freqBands)
%
% Plots LFP power across the probe, depth by frequency, as colormap
% Adds marginals with the power at selected channels, and with the power
% averaged across certain freq bands. 
%
% See companion function lfpBandPower that produces the first two inputs for this.

%%
dispF = F>=dispRange(1) & F<=dispRange(2);
nC = size(allPowerEst,1); 

if strcmp(WhattoPlot,"Just Bandpower") || strcmp(WhattoPlot,"All")
    if strcmp(TwoORThreeD,"TwoD")
        PowerDepth_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth');
        if length(PowerDepth_handles)>1
            delete(PowerDepth_handles(2:end))
            PowerDepth_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth');
        end
        % 2D Plot
        min_z = 0;
        if isempty(PowerDepth_handles)
            surface(BandPowerFigure,F(dispF), (0:nC-1)*ChannelSpacing, min_z * ones(size(10*log10(allPowerEst(:,dispF)))), ...
            'CData', 10*log10(allPowerEst(:,dispF)), 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth');
        else
            set(PowerDepth_handles(1),'XData', F(dispF), 'YData', (0:nC-1)*ChannelSpacing, 'ZData', min_z * ones(size(10*log10(allPowerEst(:,dispF)))), ...
            'CData', 10*log10(allPowerEst(:,dispF)), 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth');
        end

    elseif strcmp(TwoORThreeD,"ThreeD")

        PowerDepth2D_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth2D');
        PowerDepth3D_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth3D');

        if length(PowerDepth2D_handles)>1
            delete(PowerDepth2D_handles(2:end));
            PowerDepth2D_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth2D');
        elseif length(PowerDepth3D_handles)>1
            delete(PowerDepth3D_handles(2:end));
            PowerDepth3D_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth3D');
        end

        if length(PowerDepth3D_handles)+length(PowerDepth2D_handles)==1
            delete(PowerDepth3D_handles(:));
            delete(PowerDepth2D_handles(:));
            PowerDepth2D_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth2D');
            PowerDepth3D_handles = findobj(BandPowerFigure, 'Tag', 'PowerDepth3D');
        end

        if isempty(PowerDepth2D_handles) || isempty(PowerDepth3D_handles)
            % 3D Plot
            surf(BandPowerFigure,F(dispF),(0:nC-1)*ChannelSpacing,10*log10(allPowerEst(:,dispF)),'EdgeColor', 'none','Tag','PowerDepth3D')
            % 2D Plot
            min_z = min(10*log10(allPowerEst(:,dispF)),[],'all');
            surface(BandPowerFigure,F(dispF), (0:nC-1)*ChannelSpacing, min_z * ones(size(10*log10(allPowerEst(:,dispF)))), ...
            'CData', 10*log10(allPowerEst(:,dispF)), 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth2D');
        else
            % 3D Plot
            set(PowerDepth3D_handles(1),'XData', F(dispF),'YData', (0:nC-1)*ChannelSpacing,'CData',10*log10(allPowerEst(:,dispF)),'ZData',10*log10(allPowerEst(:,dispF)),'EdgeColor', 'none','Tag','PowerDepth3D')
            % 2D Plot
            min_z = min(10*log10(allPowerEst(:,dispF)),[],'all');
            set(PowerDepth2D_handles(1),'XData',F(dispF),'YData', (0:nC-1)*ChannelSpacing, 'ZData', min_z * ones(size(10*log10(allPowerEst(:,dispF)))), ...
            'CData', 10*log10(allPowerEst(:,dispF)), 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth2D');
        end

        view(BandPowerFigure,45,45);
        box(BandPowerFigure, 'off');
        grid(BandPowerFigure, 'off');

    end

    xlim(BandPowerFigure,dispRange);
    title(BandPowerFigure,'Power over Depth')
    xlabel(BandPowerFigure,'Frequency [Hz]');
    set(BandPowerFigure, 'YDir', 'reverse');
    ylabel(BandPowerFigure,'Depth on Probe [µm]');
    cbar_handle=colorbar('peer',BandPowerFigure,'location','EastOutside');
    cbar_handle.Label.String = "Power [dB]";
    cbar_handle.Label.Rotation = 270;
    ylim(BandPowerFigure,[0,(nC-1)*ChannelSpacing]);
end

%     ax = subplot(4,4,1:3); hold on;
%     set(ax, 'ColorOrder', copper(length(marginalChans)));
%     plot(F(dispF), 10*log10(allPowerEst(marginalChans,dispF)));
%     ylabel('power (dB)');
%     set(ax, 'XTick', []);
%     hleg = legend(array2stringCell(marginalChans*10));
%     set(hleg, 'Position', [0.7125    0.7607    0.1036    0.2083]);

if strcmp(WhattoPlot,"Just Frequency Bands") || strcmp(WhattoPlot,"All")
    c = copper(length(freqBands));
    c = c(:, [3 2 1]);
    set(FrequencyBandsFigure, 'ColorOrder', c);
    for q = 1:length(freqBands)
        inclF = F>freqBands{q}(1) & F<=freqBands{q}(2);
        thisPow = mean(10*log10(allPowerEst(:,inclF)),2);
        plot(FrequencyBandsFigure,thisPow, (0:nC-1)*ChannelSpacing,'LineWidth',2);
    end
    set(FrequencyBandsFigure, 'YTick', []);
    set(FrequencyBandsFigure, 'YDir', 'reverse');
    ylim(FrequencyBandsFigure,[0 (nC-1)*ChannelSpacing])
    xlim(BandPowerFigure,dispRange);
    if strcmp(WhattoPlot,"Just Frequency Bands")
        xlabel(FrequencyBandsFigure,'Depth [µm]')
    else
        xlabel(FrequencyBandsFigure,'')
    end
    xlabel(FrequencyBandsFigure,'Power (dB)');
    h = legend(FrequencyBandsFigure,cellfun(@(x)sprintf('%.1f - %.1f Hz', x(1), x(2)), freqBands, 'uni', false));
    set(h, 'Position', [ 0.8771    0.7856    0.0980    0.1009]);
end