function [numSquares,squareHeight,lowylimits,CorrrectedVerOffset,xdistances,AllYPositions] = Utitlity_Plot_Zoomed_Channel_Right_Side(Figure,ChannelViewRight,NrChannel,ChannelSpacing,ShowChannelSpacing,ChannelRows,VerOffset,FirstZoomChannel,ActiveChannel,NrRows,yLimitBracktes,AllActiveChannel,OffSetRows,SwitchTopBottom)

%________________________________________________________________________________________
%% Function to plot the zoomed channel selection on the right.

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. ChannelViewRight: array with rectangle objects of the probe on the right (for all channel plotted) -- empty
% when not necessray to plot or update
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelSpacing: double, from Data.Info structure in um
% 5. ShowChannelSpacing double, 1 or 0 if channel spacing between
% rectangles should be plotted (using the checkbox in the probe view window)
% 6. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 7. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 8. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 9. ActiveChannel: double, vector with currently active channel the userselected
% 10. NrRows: not used
% 11. yLimitBracktes: ymax and ymin of the black brackets in the right
% 12. AllActiveChannel: double, vector with active channel  from Data.Info
% structure
% 13. OffSetRows: logical, 1 or 0, if left and right row have an offset (only if two channelrows)
% 14. SwitchTopBottom: logical, 1 or 0, if upper and lower channel names
% are switched

% Outputs:
% 1. numSquares: double, number of channel squares plotted
% squareHeight : double, height of channel squares plotted
% lowylimits: double, height of channel squares plotted
% CorrrectedVerOffset: Vertical Offset in plot between left and right
% channelrow for the actual plot

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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

if ChannelRows > 2
    highylimits = highylimits+0.3*ChannelSpacing;
    lowylimits = lowylimits+0.3*ChannelSpacing;
end

squareHeight = (highylimits-lowylimits)/numSquares;

PlottedSquareHeight = squareHeight;

% Different spacing if wider
if ChannelRows>2
    PlottedSquareHeight = floor(squareHeight/3);
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
% Different spacing if wider
if ChannelRows>2
    squareWidth = squareWidth*ChannelRows;
end

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
    if ChannelRows == 2
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
    else
        AllChannelLeft = 1:1:NrRows*NrChannel;
        ChannelRight = 1:1:NrRows*NrChannel;
        ChannelLeft = 1:1:NrRows*NrChannel;

        CurrentChannelLeft = AllChannelLeft(FirstZoomChannel);
    end
end

Squareplots = 0;
CurrentChannel = 0;

%% If array: More distance between channel
if ChannelRows>2
    xdistances(:) = xdistances(:) - 2;
    PreviousDist = xdistances(4)-xdistances(3);
    xdistances(3) = xdistances(3) + 1;
    xdistances(4) = xdistances(3) + PreviousDist;
    DistFirstTwo = xdistances(3)-xdistances(2);
    
    if length(xdistances)>4
        for i = 5:2:length(xdistances)
            xdistances(i:i+1) = xdistances(i-1)+DistFirstTwo;
            xdistances(i+1) = xdistances(i+1) + PreviousDist;
        end
    end
end

AllYPositions = [];
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
        elseif ChannelRows == 2
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
        else % mmore than 2 rows
            if OffSetRows
                if mod(i,2)==0
                    xPos = xPos + 0.72;
                else
                    xPos = xPos - 0.72;
                end
            end
        end
        
        if VerOffset > 0
            if nrows == 1
                yPos = lowylimits+ ((i * squareHeight) - CorrrectedVerOffset) + (CorrrectedVerOffset/2); % y-position of the square
            else
                yPos = lowylimits+ ((i * (squareHeight))); % y-position of the square
            end
        else
            if nrows == 1
                yPos = lowylimits+ ((i * (squareHeight))) ; % y-position of the square
            else
                yPos = lowylimits+ ((i * squareHeight) + CorrrectedVerOffset) - (CorrrectedVerOffset/2); % y-position of the square
            end
        end
        
        AllYPositions = [AllYPositions,yPos];

        %% Determine Color
        
        CurrentChannel = 0;
        if NrRows <= 2
            [faceColor,EdgeColor] = ProbeView_ZoomedChannel_Color_Selection(i,FirstZoomChannel,ChannelRows,OffSetRows,ReversedActiveChannelLeft,AllActiveChannel,ChannelRight,ChannelLeft,nrows,NrChannel,CurrentChannel,ActiveChannel);
        else % If array
            
            if SwitchTopBottom == 1
                TempActiveChannel = NaN(size(ActiveChannel));
                for nac = 1:length(ActiveChannel)
                    TempActiveChannel(nac) = (NrChannel*NrRows) - ActiveChannel(nac) + 1;
                end
                TempAllActiveChannel = NaN(size(AllActiveChannel));
                for nac = 1:length(AllActiveChannel)
                    TempAllActiveChannel(nac) = (NrChannel*NrRows) - AllActiveChannel(nac) + 1;
                end

                CurrentArrayChannel = nrows + (i*NrRows);
            else
                TempActiveChannel = ActiveChannel;
                TempAllActiveChannel = AllActiveChannel;
                CurrentArrayChannel = ((NrChannel*NrRows) - (i+1) * NrRows) + 1 + (nrows-1);
            end

            if sum(TempActiveChannel==CurrentArrayChannel)>0
                faceColor = 'y';
            else
                if mod(i,2)==1
                    if mod(nrows,2)==1
                        faceColor = 'k';
                    else
                        faceColor = [0.5 0.5 0.5];
                    end
                else
                    if mod(nrows,2)==0
                        faceColor = 'k';
                    else
                        faceColor = [0.5 0.5 0.5];
                    end
                end    
            end

            if sum(TempAllActiveChannel==CurrentArrayChannel)>0
                EdgeColor = 'r';
            else
                EdgeColor = 'k';
            end

        end

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

if ~isempty(AllYPositions)
    AllYPositions = unique(AllYPositions);
end