function [yPoint,yLimits,ActiveChannel,yLimitsSquares,squareHeight] = Utility_Plot_Probe_Scheme(Figure,GrayProbeFilling,ProbeLines,ChannelViewLeft,NrChannel,ChannelSpacing,ActiveChannel,VerOffset,ChannelRows,LeftProbeChanged,AllActiveChannel,CreateProbeWindow,ChannelActivation,ChannelClicked)

%% Prepare
if ~isempty(ActiveChannel)
    if ismatrix(ActiveChannel) && ~iscell(ActiveChannel)
    
    else
        ActiveChannel = str2double(strsplit(ActiveChannel{1},','));
    end
else
    ActiveChannel = 1:NrChannel;
end

if isnan(VerOffset)
    VerOffset = 0;
end

%% Set limits of plot
yLimits = [0 ((NrChannel-1)*ChannelSpacing)+(ChannelSpacing)*2];  % Get current y-axis limits to extend the lines
yPoint = yLimits(1) - (yLimits(2) - yLimits(1)) / 10;  % y position below the minimum of the plotted lines

%% Plot grey probe model on the left
% Define x-coordinates for the vertical lines
x1 = 0;   % x-position of the first line
x2 = 1;   % x-position of the second line

if LeftProbeChanged && CreateProbeWindow
    % Fill the area between the two lines with grey color
    if isempty(GrayProbeFilling)
        fill(Figure, [x1, x2, x2, x1], [yLimits(1), yLimits(1), yLimits(2), yLimits(2)], ...
             [0.5, 0.5, 0.5], 'EdgeColor', 'none','Tag','GrayProbeFilling');  % Grey color fill
    else
        set(GrayProbeFilling(1),'XData', [x1, x2, x2, x1],'YData', [yLimits(1), yLimits(1), yLimits(2), yLimits(2)], ...
             'FaceColor',[0.5, 0.5, 0.5], 'EdgeColor', 'none','Tag','GrayProbeFilling');  % Grey color fill
    end
    
    if isempty(ProbeLines)
        % Plot the two vertical lines
        line(Figure, [x1, x1], yLimits, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % First line
        line(Figure, [x2, x2], yLimits, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % Second line
    else
        set(ProbeLines(1), 'XData',[x1, x1],'YData', yLimits, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % First line
        set(ProbeLines(2), 'XData',[x2, x2],'YData', yLimits, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % Second line
    end
    
    % Calculate the position for the point
    xPoint = (x1 + x2) / 2;  % Midpoint x position between the two lines
    
    if isempty(ProbeLines)
        % Draw lines from the minimum of the vertical lines to the point
        line(Figure, [x1, xPoint], [yLimits(1), yPoint], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % Left line
        line(Figure, [x2, xPoint], [yLimits(1), yPoint], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % Right line
    else
        set(ProbeLines(3), 'XData',[x1, xPoint],'YData', [yLimits(1), yPoint], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % First line
        set(ProbeLines(4), 'XData',[x2, xPoint],'YData', [yLimits(1), yPoint], 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5,'Tag','ProbeLines');  % Second line
    end
    
    if isempty(GrayProbeFilling)
        % Fill the triangle formed by the point and the two lines
        fill(Figure, [x1, xPoint, x2], [yLimits(1), yPoint, yLimits(1)], ...
             [0.5, 0.5, 0.5], 'EdgeColor', 'none','Tag','GrayProbeFilling');  % Light grey fill for the triangle
    else
        set(GrayProbeFilling(2),'XData', [x1, xPoint, x2],'YData', [yLimits(1), yPoint, yLimits(1)], ...
             'FaceColor',[0.5, 0.5, 0.5], 'EdgeColor', 'none','Tag','GrayProbeFilling');  % Grey color fill
    end
end


%% Plot squares in that probe
% define x position of sqaures
numSquares = NrChannel; % Number of squares - 

x1 = 0;   % x-position of the first vertical line
x2 = 1;   % x-position of the second vertical line

yMax = (NrChannel-1)*ChannelSpacing; % Maximum y-value based on number of squares

% height of each square
squareHeight = yMax/numSquares;

if ChannelActivation && CreateProbeWindow

    if VerOffset ~= 0
        CorrectionFactor = ChannelSpacing/VerOffset;
        CorrrectedVerOffset = squareHeight/CorrectionFactor;
    else
        CorrrectedVerOffset = 0;
    end
    
    xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
    
    squareWidth = xdistances(2)-xdistances(1);
    % loop over probe channel rows
    
    Squareplots = 0;
    
    % To plot yellow active channel: channelplot is reversed.
    % Therefore channel 1 has to be transformed into last channel
    % and so on
    ActiveChannelLeft = ActiveChannel<=NrChannel;
    
    ReversedActiveChannelLeft = (numSquares+1)-ActiveChannel(ActiveChannelLeft);
    ReversedActiveChannelRight = ((numSquares*2+1)-ActiveChannel(~ActiveChannelLeft))+NrChannel;
    
    % Now decide which squares to highliht with red edge color to indicate it
    % can be set to active
    
    if ChannelRows == 1 
        AllReversedActiveChannelLeft = (numSquares+1)-AllActiveChannel;
    elseif ChannelRows == 2
        AllReversedActiveChannelLeft = (numSquares+1)-AllActiveChannel(AllActiveChannel<=NrChannel);
        AllReversedActiveChannelRight = ((numSquares*2+1)-AllActiveChannel)+NrChannel;
        if sum(AllReversedActiveChannelLeft<=0)>0
            AllReversedActiveChannelLeft = [];
        end
    end
    
    ShowedLegendAllActive = 0;
    ShowedLegendCurrentlyActive = 0;
    
    for nrows = 1:ChannelRows
    
        xPos = xdistances(nrows+nrows);
        %xPos = x1 + (x2 - x1 - squareWidth) / 2; % Center the square between the lines
        % Loop to plot squares
         
        for i = 0:(numSquares - 1)      
            % Determine the color based on the iteration index - iterate
            % through black and white or set to yellow when active channel
            if mod(i, 2) == 0
                % Even index: plot with color
                if mod(nrows, 2) == 0
                    faceColor = 'k'; %
                else
                    faceColor = 'w'; 
                end
                if nrows == 1
                    if sum(ReversedActiveChannelLeft==i+1)
                        faceColor = 'y'; 
                    end
    
                    if sum(i+1 == AllReversedActiveChannelLeft)>0
                        Edgecolor = 'r';
                    else
                        Edgecolor = 'none';
                    end
    
                else
                    if sum(ReversedActiveChannelRight==i+NrChannel+1)
                        faceColor = 'y'; 
                    end
    
                    if sum(i+NrChannel+1 == AllReversedActiveChannelRight)>0
                        Edgecolor = 'r';
                    else
                        Edgecolor = 'none';
                    end
    
                end
                % Active Channel
                if nrows == 1
                    yPos = (i * (ChannelSpacing)) ; % y-position of the square
                else
                    yPos = (i * (ChannelSpacing)) + CorrrectedVerOffset ; % y-position of the square
                end
            else
                if nrows == 1
                    yPos = (i * (ChannelSpacing)) ; % y-position of the square
                else
                    yPos = (i * (ChannelSpacing)) + CorrrectedVerOffset ; % y-position of the square
                end
    
                % Odd index: plot invisible (no fill color)
                if mod(nrows, 2) == 0
                    faceColor = 'w'; % No fill color
                else
                    faceColor = 'k'; % No fill color
                end
                %Active Channel
                if nrows == 1
                    if sum(ReversedActiveChannelLeft==i+1)
                        faceColor = 'y'; 
                    end
    
                    if sum(i+1 == AllReversedActiveChannelLeft)>0
                        Edgecolor = 'r';
                    else
                        Edgecolor = 'none';
                    end
    
                else
                    if sum(ReversedActiveChannelRight==i+NrChannel+1)
                        faceColor = 'y'; 
                    end
    
                    if sum(i+NrChannel+1 == AllReversedActiveChannelRight)>0
                        Edgecolor = 'r';
                    else
                        Edgecolor = 'none';
                    end
                end
            end
        
            if i == 0
                yLimitsSquares(1) = yPos;
            elseif i == (numSquares - 1)  
                yLimitsSquares(2) = yPos;
            end
    
            Squareplots = Squareplots+1;
    
            if LeftProbeChanged
                if isempty(ChannelViewLeft)
                    % Plot the square using patch instead of rectangle
                    rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                        'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                else
                    if ~CreateProbeWindow
                        if length(ChannelViewLeft) >= Squareplots
                            % Update the existing patch position
                            if ChannelRows == 1
                                set(ChannelViewLeft((numSquares+1)-Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                  'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');

                            else
                                set(ChannelViewLeft((length(ChannelViewLeft)+1)-Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                  'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                            end
                        else
                            % Plot the square using patch
                            rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                        end
                    else
                        if length(ChannelViewLeft) >= Squareplots
                            % Update the existing patch position
                            if ChannelRows == 1
                                
                                set(ChannelViewLeft(Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                  'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                            else
                                set(ChannelViewLeft(Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                  'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                            end
                        else
                            % Plot the square using patch
                            rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                        end
                    end
                end   
            end
        end
    end
    
elseif ChannelActivation && ~CreateProbeWindow %just change of channel: just update the one channel that changed
    if ~isempty(ChannelClicked)
        if sum(ChannelClicked == ActiveChannel)>0 % if clicked active
            xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
            
            squareWidth = xdistances(2)-xdistances(1);

            if ChannelRows == 1
                xPos = xdistances(1+1);
            else
                if ChannelClicked<=NrChannel
                    xPos = xdistances(1+1);
                else
                    xPos = xdistances(2+2);
                end
            end
    
            if VerOffset ~= 0
                CorrectionFactor = ChannelSpacing/VerOffset;
                CorrrectedVerOffset = squareHeight/CorrectionFactor;
            else
                CorrrectedVerOffset = 0;
            end

            if ChannelRows == 1
                yPos = ((ChannelClicked-1) * (ChannelSpacing)) ; % y-position of the square
            else
                yPos = ((ChannelClicked-1) * (ChannelSpacing)) + CorrrectedVerOffset ; % y-position of the square
            end
    
            if ChannelRows == 1
                yPos = ((NrChannel-1) * (ChannelSpacing))-yPos;
            else
                if ChannelClicked>NrChannel
                    yPos = ((NrChannel*2-1) * (ChannelSpacing))-yPos;
                else
                    yPos = ((NrChannel-1) * (ChannelSpacing))-yPos;
                end
            end
       
            % Update the existing patch position
            if ChannelRows == 1
                p1 = set(ChannelViewLeft((NrChannel+1)-ChannelClicked), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', 'y', 'Tag', 'ChannelViewLeft');
            else
                if ChannelClicked>NrChannel
                    p1 = set(ChannelViewLeft((NrChannel*2+1) - (ChannelClicked-(NrChannel))), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', 'y', 'Tag', 'ChannelViewLeft');
                else
                    p1 = set(ChannelViewLeft((NrChannel+1)-ChannelClicked), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', 'y', 'Tag', 'ChannelViewLeft');
                end
            end

        else %if clicked inactive
            xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
            
            squareWidth = xdistances(2)-xdistances(1);
            
            if ChannelRows == 1
                xPos = xdistances(1+1);
            else
                if ChannelClicked<=NrChannel
                    xPos = xdistances(1+1);
                else
                    xPos = xdistances(2+2);
                end
            end
    
            if VerOffset ~= 0
                CorrectionFactor = ChannelSpacing/VerOffset;
                CorrrectedVerOffset = squareHeight/CorrectionFactor;
            else
                CorrrectedVerOffset = 0;
            end
    
            if ChannelRows == 1
                yPos = ((ChannelClicked-1) * (ChannelSpacing)) ; % y-position of the square
            else
                yPos = ((ChannelClicked-1) * (ChannelSpacing)) + CorrrectedVerOffset ; % y-position of the square
            end
    
            if ChannelRows == 1
                yPos = ((NrChannel-1) * (ChannelSpacing))-yPos;
            else
                if ChannelClicked>NrChannel
                    yPos = ((NrChannel*2-1) * (ChannelSpacing))-yPos;
                else
                    yPos = ((NrChannel-1) * (ChannelSpacing))-yPos;
                end
            end

            % Update the existing patch position
            if mod(ChannelClicked, 2) == 0
                faceColor = 'w'; % No fill color
            else
                faceColor = 'k'; % No fill color
            end
            
            if ChannelRows == 1
                p1 = set(ChannelViewLeft((NrChannel+1)-ChannelClicked), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
            else
                if ChannelClicked>NrChannel
                    p1 = set(ChannelViewLeft((NrChannel*2+1) - (ChannelClicked-(NrChannel))), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                else
                    p1 = set(ChannelViewLeft((NrChannel+1)-ChannelClicked), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                end
            end
        end

    end

    if VerOffset ~= 0
        CorrectionFactor = ChannelSpacing/VerOffset;
        CorrrectedVerOffset = squareHeight/CorrectionFactor;
    else
        CorrrectedVerOffset = 0;
    end

    for nrows = 1:ChannelRows 
        for i = 0:(numSquares - 1)
          
            % Active Channel
            if nrows == 1
                yPos = (i * (ChannelSpacing)) ; % y-position of the square
            else
                yPos = (i * (ChannelSpacing)) + CorrrectedVerOffset ; % y-position of the square
            end

            if i == 0
                yLimitsSquares(1) = yPos;
            elseif i == (numSquares - 1)  
                yLimitsSquares(2) = yPos;
            end

        end
    end
else
    if VerOffset ~= 0
        CorrectionFactor = ChannelSpacing/VerOffset;
        CorrrectedVerOffset = squareHeight/CorrectionFactor;
    else
        CorrrectedVerOffset = 0;
    end

    for nrows = 1:ChannelRows 
        for i = 0:(numSquares - 1)
          
            % Active Channel
            if nrows == 1
                yPos = (i * (ChannelSpacing)) ; % y-position of the square
            else
                yPos = (i * (ChannelSpacing)) + CorrrectedVerOffset ; % y-position of the square
            end

            if i == 0
                yLimitsSquares(1) = yPos;
            elseif i == (numSquares - 1)  
                yLimitsSquares(2) = yPos;
            end

        end
    end
end