
function f = plotLFPpower(F, allPowerEst, dispRange, marginalChans, freqBands, BandPowerFigure, FrequencyBandsFigure,WhattoPlot, ChannelSpacing)
% function plotLFPpower(F, allPowerEst, dispRange, marginalChans, freqBands)
%
% Plots LFP power across the probe, depth by frequency, as colormap
% Adds marginals with the power at selected channels, and with the power
% averaged across certain freq bands. 
%
% See companion function lfpBandPower that produces the first two inputs for this.

%%
dispF = F>dispRange(1) & F<=dispRange(2);
nC = size(allPowerEst,1); 

if strcmp(WhattoPlot,"Just Bandpower") || strcmp(WhattoPlot,"All")
    imagesc(BandPowerFigure,F(dispF), (0:nC-1)*ChannelSpacing, 10*log10(allPowerEst(:,dispF)));
    xlim(BandPowerFigure,dispRange);
    title(BandPowerFigure,'Power over Depth')
    xlabel(BandPowerFigure,'Frequency [Hz]');
    %set(BandPowerFigure, 'YDir', 'reverse');
    ylabel(BandPowerFigure,'Depth on Probe [µm]');
    cbar_handle=colorbar('peer',BandPowerFigure,'location','EastOutside');
    cbar_handle.Label.String = "Power [dB]";
    cbar_handle.Label.Rotation = 270;
    ylim(BandPowerFigure,[0,nC*ChannelSpacing]);
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
        plot(FrequencyBandsFigure,thisPow, (0:nC-1)*10,'LineWidth',2);
    end
    set(FrequencyBandsFigure, 'YTick', []);
    set(FrequencyBandsFigure, 'YDir', 'reverse');
    ylim(FrequencyBandsFigure,[0 nC(end)*10])
    if strcmp(WhattoPlot,"Just Frequency Bands")
        xlabel(FrequencyBandsFigure,'Depth [µm]')
    else
        xlabel(FrequencyBandsFigure,'')
    end
    xlabel(FrequencyBandsFigure,'Power (dB)');
    h = legend(FrequencyBandsFigure,cellfun(@(x)sprintf('%.1f - %.1f Hz', x(1), x(2)), freqBands, 'uni', false));
    set(h, 'Position', [ 0.8071    0.7356    0.0980    0.1009]);
end