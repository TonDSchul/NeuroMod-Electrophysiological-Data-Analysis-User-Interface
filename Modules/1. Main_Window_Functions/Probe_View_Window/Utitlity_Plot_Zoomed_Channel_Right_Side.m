function [numSquares,squareHeight,lowylimits,CorrrectedVerOffset] = Utitlity_Plot_Zoomed_Channel_Right_Side(Figure,ChannelViewRight,NrChannel,ChannelSpacing,ShowChannelSpacing,ChannelRows,VerOffset,FirstZoomChannel,ActiveChannel,NrRows,yLimitBracktes,AllActiveChannel,OffSetRows,SwitchTopBottom)


ChannelLeft = [];
ChannelRight = [];
ReversedActiveChannelLeft = [];

%% Plot 64 channel on the right

if NrChannel<=32
    numSquares = NrChannel; % Number of squares - 
else
    numSquares = 32; % Number of squares - 
end

highylimits = yLimitBracktes(2);
lowylimits = yLimitBracktes(1);

squareHeight = (highylimits-lowylimits)/numSquares;

if ShowChannelSpacing
    PlottedSquareHeight = floor(squareHeight/2);
else
    PlottedSquareHeight = squareHeight;
end

x1 = 4;   % x-position of the first vertical line
x2 = 6;   % x-position of the second vertical line

if VerOffset ~= 0
    CorrectionFactor = ChannelSpacing/(VerOffset*2);
    
    CorrrectedVerOffset = squareHeight/CorrectionFactor;
else
    CorrrectedVerOffset = 0;
end

if OffSetRows
    if ChannelRows == 1 
        xdistances = (x1:(x2 - x1) / ((ChannelRows*2)+2):x2)+1;
    else
        xdistances = x1:(x2 - x1) / ((ChannelRows*2)+2):x2;
    end
else
    if ChannelRows == 1
        xdistances = (x1:(x2 - x1) / ((ChannelRows*2)+1):x2)+1;
    else
        xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
    end
end

squareWidth = xdistances(2)-xdistances(1);

%% 1 Row
if ChannelRows == 1

    if NrChannel<32
        PlottedChannelsLeft = FirstZoomChannel :FirstZoomChannel+ NrChannel-1;
    else
        PlottedChannelsLeft = FirstZoomChannel :FirstZoomChannel+ 32-1;
    end

    ReversedActiveChannelLeft = NrChannel+1-PlottedChannelsLeft;

    for i = 1:length(ActiveChannel)
        if sum(ActiveChannel(i) == ReversedActiveChannelLeft)>0
            ChannelLeft = [ChannelLeft,ReversedActiveChannelLeft(ActiveChannel(i) == ReversedActiveChannelLeft)];
        end
    end
%% 2 rows
else
    % differentiate left and right row
    AllChannelLeft = 2*NrChannel-1:-2:1;
    CurrentChannelLeft = AllChannelLeft(FirstZoomChannel);

    if NrChannel>=32
        ChannelLeft = CurrentChannelLeft:-2:CurrentChannelLeft-63;
        ChannelRight = CurrentChannelLeft+1:-2:CurrentChannelLeft-62;
    else
        ChannelLeft = CurrentChannelLeft:-2:CurrentChannelLeft-(NrChannel*2-1);
        ChannelRight = CurrentChannelLeft+1:-2:CurrentChannelLeft-(NrChannel*2-2);
    end

    if SwitchTopBottom == 1
        ChannelLeft = ChannelLeft+1;
        ChannelRight = ChannelRight-1;
    end

end

Squareplots = 0;
CurrentChannel = 0;

% loop over probe channel rows
for nrows = 1:ChannelRows

    xPos = xdistances(nrows+nrows);

    for i = 0:((numSquares) - 1)  

        %% Offset every seconds row
        if ChannelRows == 1
            if OffSetRows
                if mod(FirstZoomChannel,2)==0
                    if mod(i, 2) == 0
                        xPos = (xdistances(nrows+nrows)/2);    
                    else
                        xPos = (xdistances(nrows+nrows+2)/2)+0.2;
                    end
                else
                    if mod(i, 2) == 1
                        xPos = (xdistances(nrows+nrows)/2);    
                    else
                        xPos = (xdistances(nrows+nrows+2)/2)+0.2;
                    end
                end
                xPos = xPos+2.7;
            end
        else
            if OffSetRows 
                if nrows==1
                    if mod(FirstZoomChannel,2)==0
                        if mod(i, 2) == 0
                            xPos = (xdistances(nrows+nrows)/2)+0.08;    
                        else
                            xPos = (xdistances(nrows+nrows+3)/2)+0.03;
                        end
                    else
                        if mod(i, 2) == 1
                            xPos = (xdistances(nrows+nrows)/2)+0.08;    
                        else
                            xPos = (xdistances(nrows+nrows+3)/2)+0.03;
                        end
                    end
                else
                    if mod(FirstZoomChannel,2)==0
                        if mod(i, 2) == 0
                            xPos = (xdistances(nrows+nrows)/2)+0.61;    
                        else
                            xPos = (xdistances(nrows+nrows+3)/2)+0.53;
                        end
                    else
                        if mod(i, 2) == 1
                            xPos = (xdistances(nrows+nrows)/2)+0.61;    
                        else
                            xPos = (xdistances(nrows+nrows+3)/2)+0.53;
                        end
                    end
                end
                xPos = xPos+1.9;
            end
        end

        if nrows == 1
            yPos = lowylimits+ ((i * (squareHeight))) ; % y-position of the square
        else
            yPos = lowylimits+ ((i * squareHeight) + CorrrectedVerOffset) - (CorrrectedVerOffset/2); % y-position of the square
        end
        
        %% Determine Color
        
        CurrentChannel = 0;
        
        [faceColor,EdgeColor] = ProbeView_ZoomedChannel_Color_Selection(i,FirstZoomChannel,ChannelRows,OffSetRows,ReversedActiveChannelLeft,AllActiveChannel,ChannelRight,ChannelLeft,nrows,NrChannel,CurrentChannel,ActiveChannel);

        Squareplots = Squareplots+1;

        if isempty(ChannelViewRight)
            % Plot the square
            rectangle(Figure, 'Position', [xPos, yPos, squareWidth, PlottedSquareHeight], ...
                  'EdgeColor', EdgeColor, 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
        else
            if length(ChannelViewRight)>=Squareplots
                % Plot the square
                set(ChannelViewRight(Squareplots), 'Position', [xPos, yPos, squareWidth, PlottedSquareHeight], ...
                          'EdgeColor', EdgeColor, 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
            else
                % Plot the square
                rectangle(Figure, 'Position', [xPos, yPos, squareWidth, PlottedSquareHeight], ...
                          'EdgeColor', EdgeColor, 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
            end
        end
    end
end