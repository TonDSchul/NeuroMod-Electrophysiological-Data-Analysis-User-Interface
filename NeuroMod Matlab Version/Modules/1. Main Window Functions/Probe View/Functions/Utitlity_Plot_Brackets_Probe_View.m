function [yLimitBracktes] = Utitlity_Plot_Brackets_Probe_View(Figure,BracketLine,NrChannel,ChannelSpacing,yPoint,yLimits,yLimitsSquares,squareHeightLeftProbe,FirstZoomChannel,NrRows,CreateProbeWindow,ChannelActivation,ECogArray)

%________________________________________________________________________________________
%% Function to plot the black bracket on the right for the zoomed channel selection

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. BracketLine: array with line objects of brackets
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelSpacing: double, from Data.Info structure in um
% 5. yPoint: y value of grey probe tip (warning: most likely negative!)
% 6. yLimits: double 1x2 vector with min and max value of plotted probe on
% the left - for y scale and detection where user clicked on
% 7. yLimitsSquares: double 1x2 vector with min and max value of plotted channel rectangles on
% the left, used as limit to plot black lines of channel zoomed on the
% right
% 8. squareHeightLeftProbe: double, Height of each square plotted in the left side
% (in um)
% 9. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 10. NrRows: double, 1 or 2 from Data.Info structure or create probe view window
% 11. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 12. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 13. ECogArray: logical 1 or 0 if probe is a ECoG array

% Outputs:
% 1. yLimitBracktes: double, vector with min and max value of the plotted
% bracket

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Plot horizontal lines to the left
%%%%%% Changed in callback

% Upper limit
if ~ECogArray
    if CreateProbeWindow || ~ChannelActivation
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
    end
end

if NrChannel<=64 % imit to show: 64 channel
    yLimitBracktes(1) = yPoint+abs(yPoint/2);
    yLimitBracktes(2) = ((NrChannel-1)*ChannelSpacing)+NrChannel;
else
    yLimitBracktes(1) = yPoint+abs(yPoint/2);
    yLimitBracktes(2) = ((NrChannel-1)*ChannelSpacing)-NrChannel;
end


