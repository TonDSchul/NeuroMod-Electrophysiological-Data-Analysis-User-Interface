function [yLimitBracktes] = Utitlity_Plot_Brackets_Probe_View(Figure,BracketLine,NrChannel,ChannelSpacing,yPoint,yLimits,yLimitsSquares,squareHeightLeftProbe,FirstZoomChannel,NrRows)

%% Plot bracket
% Plot horizontal lines to the left
%%%%%% Changed in callback

% Upper limit

y1 = (FirstZoomChannel-1)*ChannelSpacing;

if NrChannel<32
    y2 = y1+NrChannel*ChannelSpacing;
else
    y2 = y1+32*ChannelSpacing;
end

if isempty(BracketLine)
    % Plot the lower line
    line(Figure, [0, 2], [y1, y1], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
    % Plot upper line
    line(Figure, [0, 2], [y2, y2], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % Second horizontal line
    % Plot bracket etnsions
    % Plower line
    line(Figure, [2, 2.5], [y1, yPoint+abs(yPoint/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
    
    % Plot bracket etnsions
    % upper line
    if NrChannel<=64 % imit to show: 64 channel
        line(Figure, [2, 2.5], [y2, ((NrChannel-1)*ChannelSpacing)+NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
        ylim(Figure, [yPoint ((NrChannel-1)*ChannelSpacing)+NrChannel])
    else
        line(Figure, [2, 2.5], [y2, ((NrChannel-1)*ChannelSpacing)-NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
    end

    % plot horizontal extensions
    %upper line
    if NrChannel<=64 % imit to show: 64 channel
        line(Figure,[2.5 8], [((NrChannel-1)*ChannelSpacing)+NrChannel ((NrChannel-1)*ChannelSpacing)+NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine')
    else
        line(Figure,[2.5 8], [((NrChannel-1)*ChannelSpacing)-NrChannel ((NrChannel-1)*ChannelSpacing)-NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine')
    end

    %lower line
    line(Figure,[2.5 8], [yPoint+abs(yPoint/2) yPoint+abs(yPoint/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine')
else
    % Plot the lower line
    set(BracketLine(1),'XData' ,[0, 2],'YData' , [y1, y1], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
    % Plot upper line
    set(BracketLine(2),'XData' , [0, 2],'YData' , [y2, y2], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % Second horizontal line
    % Plot bracket etnsions
    % lower line
    set(BracketLine(3),'XData' , [2, 2.5],'YData' , [y1, yPoint+abs(yPoint/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
    
    % Plot bracket etnsions
    % upper line
    if NrChannel<=64 % imit to show: 64 channel
        set(BracketLine(4), 'XData' ,[2, 2.5],'YData' , [y2, ((NrChannel-1)*ChannelSpacing)+NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
    else
        set(BracketLine(4), 'XData' ,[2, 2.5],'YData' , [y2, ((NrChannel-1)*ChannelSpacing)-NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
    end

    % plot horizontal extensions
    if NrChannel<=64 % imit to show: 64 channel
        set(BracketLine(5),'XData' ,[2.5 8],'YData' , [((NrChannel-1)*ChannelSpacing)+NrChannel ((NrChannel-1)*ChannelSpacing)+NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine')
    else
        set(BracketLine(5),'XData' ,[2.5 8],'YData' , [((NrChannel-1)*ChannelSpacing)-NrChannel ((NrChannel-1)*ChannelSpacing)-NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine')
    end

    set(BracketLine(6),'XData' ,[2.5 8],'YData' , [yPoint+abs(yPoint/2), yPoint+abs(yPoint/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine')
end

if NrChannel<=64 % imit to show: 64 channel
    yLimitBracktes(1) = yPoint+abs(yPoint/2);
    yLimitBracktes(2) = ((NrChannel-1)*ChannelSpacing)+NrChannel;
else
    yLimitBracktes(1) = yPoint+abs(yPoint/2);
    yLimitBracktes(2) = ((NrChannel-1)*ChannelSpacing)-NrChannel;
end