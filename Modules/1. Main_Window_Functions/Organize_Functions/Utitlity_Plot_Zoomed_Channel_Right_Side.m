function [numSquares,squareHeight,lowylimits,CorrrectedVerOffset] = Utitlity_Plot_Zoomed_Channel_Right_Side(Figure,ChannelViewRight,NrChannel,ChannelSpacing,yPoint,ChannelRows,VerOffset,FirstZoomChannel,ActiveChannel,NrRows,yLimitBracktes)

%% Plot 64 channel on the right

if NrRows == 1
    if NrChannel<=32
        numSquares = NrChannel; % Number of squares - 
    else
        numSquares = 32; % Number of squares - 
    end
else
    if NrChannel<=32
        numSquares = NrChannel/2; % Number of squares - 
    else
        numSquares = 32; % Number of squares - 
    end
end

highylimits = yLimitBracktes(2);
lowylimits = yLimitBracktes(1);

squareHeight = (highylimits-lowylimits)/numSquares;

x1 = 4;   % x-position of the first vertical line
x2 = 6;   % x-position of the second vertical line

if VerOffset ~= 0
    CorrectionFactor = ChannelSpacing/VerOffset;
    
    CorrrectedVerOffset = squareHeight/CorrectionFactor;
else
    CorrrectedVerOffset = 0;
end

if ChannelRows == 1
    xdistances = (x1:(x2 - x1) / ((ChannelRows*2)+1):x2)+1;
else
    xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
end

squareWidth = xdistances(2)-xdistances(1);

if ChannelRows == 1
    ActiveChannelinRangeLeft = [];
    ActiveChannelinRangeRight = [];

    if NrChannel<32
        PlottedChannelsLeft = FirstZoomChannel :FirstZoomChannel+ NrChannel-1;
    else
        PlottedChannelsLeft = FirstZoomChannel :FirstZoomChannel+ 32-1;
    end

    ReversedActiveChannelLeft = NrChannel+1-PlottedChannelsLeft;
    %ReversedActiveChannelLeft = PlottedChannelsLeft;

    for i = 1:length(ActiveChannel)
        if sum(ActiveChannel(i) == ReversedActiveChannelLeft)>0
            ActiveChannelinRangeLeft = [ActiveChannelinRangeLeft,ReversedActiveChannelLeft(ActiveChannel(i) == ReversedActiveChannelLeft)];
        end
    end
    
else
    
    ActiveChannelinRangeLeft = [];
    ActiveChannelinRangeRight = [];

    if NrChannel<=32 %if less channel than normally shown on the right (32*2)
        PlottedChannelsLeft = 1:NrChannel;
    else% if more channel than shown on the right
        if FirstZoomChannel + 32-1 < NrChannel*2
            % 32 channel shwon on the left
            PlottedChannelsLeft = FirstZoomChannel :FirstZoomChannel+ 32-1;
        else % if channelnr would exceed max channel
            %show nr channel -32 to nr channel
            PlottedChannelsLeft = NrChannel*2 - 63;
        end
    end

    ReversedActiveChannelLeft = NrChannel+1-PlottedChannelsLeft;

    FirstZoomChannelRight = FirstZoomChannel + (NrChannel-PlottedChannelsLeft(1));

    if NrChannel<=32 %if less channel than normally shown on the right (32*2)
        PlottedChannelsRight = 1:NrChannel;
    else% if more channel than shown on the right
        if FirstZoomChannel + 32-1 < NrChannel*2
            % 32 channel shwon on the left
            PlottedChannelsRight = FirstZoomChannel :FirstZoomChannel+ 32-1;
        else % if channelnr would exceed max channel
            %show nr channel -32 to nr channel
            PlottedChannelsRight = NrChannel*2 - 63;
        end
    end

    ReversedActiveChannelRight = (NrChannel*2+1)-PlottedChannelsRight;

    for i = 1:length(ActiveChannel)
        if sum(ActiveChannel(i) == ReversedActiveChannelLeft)>0
            ActiveChannelinRangeLeft = [ActiveChannelinRangeLeft,ReversedActiveChannelLeft(ActiveChannel(i) == ReversedActiveChannelLeft)];
        end
    end

    for i = 1:length(ActiveChannel)
        if sum(ActiveChannel(i) == ReversedActiveChannelRight)>0
            ActiveChannelinRangeRight = [ActiveChannelinRangeRight,ReversedActiveChannelRight(ActiveChannel(i) == ReversedActiveChannelRight)];
        end
    end
end

Squareplots = 0;

% loop over probe channel rows
for nrows = 1:ChannelRows

    xPos = xdistances(nrows+nrows);
    %xPos = x1 + (x2 - x1 - squareWidth) / 2; % Center the square between the lines
    % Loop to plot squares
    
    for i = 0:((numSquares) - 1)   

        % Determine the color based on the iteration index
        if mod(i, 2) == 0
            % Even index: plot with color
            if mod(nrows, 2) == 0
                faceColor = 'k'; 
            else
                faceColor = [0.8 0.8 0.8]; 
            end
            % Active Channel
            if nrows == 1
                CurrentChannel = ReversedActiveChannelLeft(i+1);
                if ~isempty(ActiveChannelinRangeLeft) 
                    if sum(CurrentChannel==ActiveChannelinRangeLeft)>0
                        faceColor = 'y'; 
                    end
                end
            else
                CurrentChannel = ReversedActiveChannelRight(i+1);
                if ~isempty(ActiveChannelinRangeRight) 
                    if sum(CurrentChannel==ActiveChannelinRangeRight)>0
                        faceColor = 'y'; 
                    end
                end
            end
            
            if nrows == 1
                yPos = lowylimits+ ((i * (squareHeight))) ; % y-position of the square
            else
                yPos = lowylimits+ ((i * squareHeight) + CorrrectedVerOffset) ; % y-position of the square
            end
        else
            if nrows == 1
                yPos = lowylimits+((i * (squareHeight))) ; % y-position of the square
            else
                yPos = lowylimits+(i * (squareHeight) + CorrrectedVerOffset) ; % y-position of the square
            end


            % Odd index: plot invisible (no fill color)
            if mod(nrows, 2) == 0
                faceColor = [0.8 0.8 0.8];  
            else
                faceColor = 'k'; 
            end

            % Active Channel
            if nrows == 1
                CurrentChannel = ReversedActiveChannelLeft(i+1);
                if ~isempty(ActiveChannelinRangeLeft) 
                    if sum(CurrentChannel==ActiveChannelinRangeLeft)>0
                        faceColor = 'y'; 
                    end
                end
            else
                CurrentChannel = ReversedActiveChannelRight(i+1);
                if ~isempty(ActiveChannelinRangeRight) 
                    if sum(CurrentChannel==ActiveChannelinRangeRight)>0
                        faceColor = 'y'; 
                    end
                end
            end
        end
    
        Squareplots = Squareplots+1;

        if isempty(ChannelViewRight)
            % Plot the square
            if strcmp(faceColor,'y')
                rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                      'EdgeColor', 'k', 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
            else
                rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                      'EdgeColor', faceColor, 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
            end
        else
            if strcmp(faceColor,'y')
                if length(ChannelViewRight)>=Squareplots
                    % Plot the square
                    set(ChannelViewRight(Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', 'k', 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
                else
                    % Plot the square
                    rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', 'k', 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
                end
            else
                if length(ChannelViewRight)>=Squareplots
                    % Plot the square
                    set(ChannelViewRight(Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', faceColor, 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
                else
                    % Plot the square
                    rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', faceColor, 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
                end
            end
        end
    end
end