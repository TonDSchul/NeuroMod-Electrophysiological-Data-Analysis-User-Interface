function helperPlotCoherence(Figure,t,F,coi)
%   This helper function is provided solely in support of Wavelet
%   Toolbox examples.
%   This function may be changed or removed in a future release.

Yticks = 2.^(round(log2(min(F))):round(log2(max(F))));
%imagesc(t,log2(F),wcoh);
% Set axes properties (on the UIAxes, not on PltObject)
Figure.YLim = log2([min(F), max(F)]);
Figure.YDir = 'normal';
Figure.YTick = log2(Yticks(:));
Figure.YTickLabel = arrayfun(@(y) sprintf('%.2f', y), Yticks, 'UniformOutput', false);
Figure.Layer = 'top';
hold(Figure, 'on');   % turn hold on

% HelperHandle = findobj(Figure, 'Tag', 'HelperLine');
% if length(HelperHandle)>1
%     delete(HelperHandle(2:end));
% end
% 
% if isempty(HelperHandle)
%     plot(Figure,t,log2(coi),"k--",'LineWidth',2,'Tag','HelperLine');
% else
%     set(HelperHandle(1),'XData',t,'YData',log2(coi),'LineWidth',2,'Tag','HelperLine')
% end
