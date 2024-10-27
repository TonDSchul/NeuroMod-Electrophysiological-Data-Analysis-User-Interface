function Utility_Plot_Interactive_Probe_View(Figure,ChannelSpacing,NrChannel,ChannelRows,HorOffset,VerOffset,ChannelOrder,ActiveChannel,FirstZoomChannel,LeftProbeChanged)


if ~isnan(NrChannel) && ~isnan(ChannelSpacing)

    if isnan(VerOffset)
        VerOffset = 0;
    end

    % Add ButtonDownFcn to each line object in UIAxis
    ProbeLines = findobj(Figure,'Tag','ProbeLines');

    % Add ButtonDownFcn to each line object in UIAxis
    BracketLine = findobj(Figure, 'Tag', 'BracketLine');
    
    if LeftProbeChanged
        % Add ButtonDownFcn to each line object in UIAxis
        ChannelViewRight = findobj(Figure,'Tag','ChannelViewRight');
    
        % Add ButtonDownFcn to each line object in UIAxis
        ChannelViewLeft = findobj(Figure,'Tag','ChannelViewLeft');
    
        % Add ButtonDownFcn to each line object in UIAxis
        GrayProbeFilling = findobj(Figure,'Tag','GrayProbeFilling');
    end

    % Add ButtonDownFcn to each line object in UIAxis
    ChannelText = findobj(Figure,'Tag','ChannelText');

    if LeftProbeChanged
        if length(GrayProbeFilling)>2
            delete(GrayProbeFilling(2:end));
            GrayProbeFilling = findobj(Figure,'Tag','GrayProbeFilling');
        end
    
        if length(ProbeLines)>4
            delete(ProbeLines(5:end));
            ProbeLines = findobj(Figure,'Tag','ProbeLines');
        end
    end

    if LeftProbeChanged
        if length(ChannelViewLeft)>NrChannel*ChannelRows
            delete(ChannelViewLeft(NrChannel*ChannelRows+1:end));
            ChannelViewLeft = findobj(Figure,'Tag','ChannelViewLeft');
        end
    end

    if length(BracketLine)>6
        delete(ProbeLines(7:end));
        BracketLine = findobj(Figure,'Tag','BracketLine');
    end

    if LeftProbeChanged
        if NrChannel >= 32
            if length(ChannelViewRight)>32*ChannelRows
                delete(ChannelViewRight(32*ChannelRows+1:end));
                ChannelViewRight = findobj(Figure,'Tag','ChannelViewRight');
            end
        else
            if length(ChannelViewRight)>NrChannel*ChannelRows
                delete(ChannelViewRight(NrChannel*ChannelRows+1:end));
                ChannelViewRight = findobj(Figure,'Tag','ChannelViewRight');
            end
        end
    end

    if NrChannel >= 32
        if length(ChannelText)>32*ChannelRows
            delete(ChannelText(32*ChannelRows+1:end));
            ChannelText = findobj(Figure,'Tag','ChannelText');
        end
    else
        if length(ChannelText)>NrChannel*ChannelRows
            delete(ChannelText(NrChannel*ChannelRows+1:end));
            ChannelText = findobj(Figure,'Tag','ChannelText');
        end
    end

    yLimits = [0 ((NrChannel-1)*ChannelSpacing)+(ChannelSpacing)*2];  % Get current y-axis limits to extend the lines
    yPoint = yLimits(1) - (yLimits(2) - yLimits(1)) / 10;  % y position below the minimum of the plotted lines

    if LeftProbeChanged
        %% Plot grey probe model on the left
        % Define x-coordinates for the vertical lines
        x1 = 0;   % x-position of the first line
        x2 = 1;   % x-position of the second line
        
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
    
        %% Set Plot properties
        % Flip ytick labels --> bc reversing y axis also turns around probe
        xlim(Figure,[-0.5 8.2])
        ylim(Figure,[yPoint ((NrChannel-1)*ChannelSpacing)+(ChannelSpacing)*2])
    
        ylabel(Figure, 'Depth [µm]');
    
        % yTicks = get(Figure, 'YTickLabel'); % Current y-tick values
        % 
        % if str2double(yTicks{1})<str2double(yTicks{end})
        %     newticks = flip(yTicks);
        %     set(Figure, 'YTickLabel',newticks); % Current y-tick values
        % end
    
        %% Plot squares in that probe
        % define x position of sqaures
        numSquares = NrChannel; % Number of squares - 
    
        x1 = 0;   % x-position of the first vertical line
        x2 = 1;   % x-position of the second vertical line
    
        yMax = (NrChannel-1)*ChannelSpacing; % Maximum y-value based on number of squares
        
        % height of each square
        squareHeight = yMax/numSquares;
        
        xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
    
        squareWidth = xdistances(2)-xdistances(1);
        % loop over probe channel rows
    
        Squareplots = 0;
        
        for nrows = 1:ChannelRows
    
            xPos = xdistances(nrows+nrows);
            %xPos = x1 + (x2 - x1 - squareWidth) / 2; % Center the square between the lines
            % Loop to plot squares
            
            for i = 0:((numSquares) - 1)              
                % Determine the color based on the iteration index
                if mod(i, 2) == 0
                    % Even index: plot with color
                    if mod(nrows, 2) == 0
                        faceColor = 'k'; %
                    else
                        faceColor = 'w'; 
                    end
                    
                    if nrows == 1
                        yPos = (i * (ChannelSpacing)) - (squareHeight/2) ; % y-position of the square
                    else
                        yPos = (i * (ChannelSpacing)) - (squareHeight/2) - VerOffset ; % y-position of the square
                    end
                else
                    if nrows == 1
                        yPos = (i * (ChannelSpacing)) - (squareHeight/2) ; % y-position of the square
                    else
                        yPos = (i * (ChannelSpacing)) - (squareHeight/2) - VerOffset ; % y-position of the square
                    end
    
                    % Odd index: plot invisible (no fill color)
                    if mod(nrows, 2) == 0
                        faceColor = 'w'; % No fill color
                    else
                        faceColor = 'k'; % No fill color
                    end
                end
            
                Squareplots = Squareplots+1;
    
                if isempty(ChannelViewLeft)
                    % Plot the square
                    rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', faceColor, 'FaceColor', faceColor,'Tag','ChannelViewLeft'); % Black edges with specified face color
                else
                    if length(ChannelViewLeft)>=Squareplots
                        set(ChannelViewLeft(Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                  'EdgeColor', faceColor, 'FaceColor', faceColor,'Tag','ChannelViewLeft'); % Black edges with specified face color
                    else
                        % Plot the square
                        rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', faceColor, 'FaceColor', faceColor,'Tag','ChannelViewLeft'); % Black edges with specified face color
                    end
                end
    
            end
        end
    end


    if ~LeftProbeChanged
        numSquares = NrChannel; % Number of squares - 
    
        yMax = (NrChannel-1)*ChannelSpacing; % Maximum y-value based on number of squares
        
        % height of each square
        squareHeight = yMax/numSquares;
    end
    %% Plot bracket
    % Plot horizontal lines to the left
    %%%%%% Changed in callback
    y1 =(FirstZoomChannel+1)*ChannelSpacing;

    if y1<0
        y1 = 0;
    end
    %y1 = 0; % y-coordinate for the first line
    %%%%%% Changed in callback

    if NrChannel*ChannelRows<32 % imit to show: 64 channel
        y2 = y1 + (((NrChannel*ChannelRows)-1)) * ChannelSpacing; % y-coordinate for the second line (64 * ChannelSpacing apart)
    else
        y2 = y1 + ((32)-1) * ChannelSpacing; % y-coordinate for the second line (64 * ChannelSpacing apart)
    end

    if y2 > ((NrChannel-1)*ChannelSpacing)
        y2 = ((NrChannel-1)*ChannelSpacing);

        if NrChannel*ChannelRows<32 % imit to show: 64 channel
            y1 = y2 - (((NrChannel*ChannelRows)-1) * ChannelSpacing);
        else
            y1 = y2 - (((32)-1) * ChannelSpacing);
        end
        
    end

    if y1 < 0
        y1 = 0;
    end

    if isempty(BracketLine)
        % Plot the lower line
        line(Figure, [0, 2], [y1-(squareHeight/2), y1-(squareHeight/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
        % Plot upper line
        line(Figure, [0, 2], [y2, y2], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % Second horizontal line
        % Plot bracket etnsions
        % Plower line
        line(Figure, [2, 2.5], [y1-(squareHeight/2), yPoint+abs(yPoint/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
        
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
        set(BracketLine(1),'XData' ,[0, 2],'YData' , [y1-(squareHeight/2), y1-(squareHeight/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
        % Plot upper line
        set(BracketLine(2),'XData' , [0, 2],'YData' , [y2, y2], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % Second horizontal line
        % Plot bracket etnsions
        % lower line
        set(BracketLine(3),'XData' , [2, 2.5],'YData' , [y1-(squareHeight/2), yPoint+abs(yPoint/2)], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
        
        % Plot bracket etnsions
        % upper line
        if NrChannel<=64 % imit to show: 64 channel
            set(BracketLine(4), 'XData' ,[2, 2.5],'YData' , [y2, ((NrChannel-1)*ChannelSpacing)+NrChannel], 'Color', 'k', 'LineWidth', 1.5,'Tag','BracketLine'); % First horizontal line
            ylim(Figure, [yPoint ((NrChannel-1)*ChannelSpacing)+NrChannel])
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

    
    %% Plot 64 channel on the right
    lowylimits = (yPoint+NrChannel) + NrChannel;

    if NrChannel<=64 % imit to show: 64 channel
        highylimits = ((NrChannel-1)*ChannelSpacing)+NrChannel;
    else
        highylimits = ((NrChannel-1)*ChannelSpacing)-NrChannel;
    end

    if ChannelRows == 1
        if NrChannel<32 % imit to show: 64 channel
            numSquares = NrChannel; % Number of squares
            ChannelSpacing = (highylimits-lowylimits)/NrChannel; 
        else
            numSquares = 32;
            ChannelSpacing = (highylimits-lowylimits)/32; 
        end
    else
        if NrChannel*2<64 % imit to show: 64 channel
            numSquares = NrChannel; % Number of squares
            ChannelSpacing = (highylimits-lowylimits)/32; 
        else
            numSquares = 32;
            ChannelSpacing = (highylimits-lowylimits)/32; 
        end
    end
    
    x1 = 4;   % x-position of the first vertical line
    x2 = 6;   % x-position of the second vertical line
    yMax = highylimits; % Maximum y-value based on number of squares
    
    % height of each square
    squareHeight = yMax/numSquares;

    if ChannelRows == 1
        xdistances = (x1:(x2 - x1) / ((ChannelRows*2)+1):x2)+1;
    else
        xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
    end

    squareWidth = xdistances(2)-xdistances(1);

    if ChannelRows == 1
        if FirstZoomChannel > NrChannel
            if NrChannel>=32
                FirstZoomChannel = FirstZoomChannel-32+1;
            else
                FirstZoomChannel = 1;
            end
        end
    else
        if (FirstZoomChannel*2+2)+64 >= NrChannel*2+1
            %dont update plot
            
            if NrChannel*2>=64
                FirstZoomChannel = round(((NrChannel*2-64)+1)/2)-2;
            else
                FirstZoomChannel = 1;
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
                
                if nrows == 1
                    yPos = ((i * (squareHeight)) - (squareHeight/2)) ; % y-position of the square
                else
                    yPos = ((i * (squareHeight)) - (squareHeight/2)) - VerOffset ; % y-position of the square
                end
            else
                if nrows == 1
                    yPos = ((i * (squareHeight)) - (squareHeight/2)) ; % y-position of the square
                else
                    yPos = ((i * (squareHeight)) - (squareHeight/2)) - VerOffset ; % y-position of the square
                end


                % Odd index: plot invisible (no fill color)
                if mod(nrows, 2) == 0
                    faceColor = [0.8 0.8 0.8];  
                else
                    faceColor = 'k'; 
                end
            end
        
            Squareplots = Squareplots+1;

            if LeftProbeChanged
                if isempty(ChannelViewRight)
                    % Plot the square
                    rectangle(Figure, 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', faceColor, 'FaceColor', faceColor,'Tag','ChannelViewRight'); % Black edges with specified face color
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
            %% Plot channel name
            if mod(nrows, 2) == 0 % right
                
                x = 6;       % X-coordinate
                y = yPos+(squareHeight/2);       % Y-coordinate

                if ChannelRows == 1
                    textString = strcat("CH ",num2str(FirstZoomChannel+2+i+length(0:((numSquares) - 1) )));  % Text to display
                else
                    textString = strcat("CH ",num2str((FirstZoomChannel*2)+3+i+length(0:((numSquares) - 1) )));  % Text to display
                end
                if isempty(ChannelText)
                    % Add the text to app.UIAxes at the specified coordinates
                    text(Figure, x, y, textString, 'FontSize', 10, 'Color', 'k','Tag','ChannelText');
                else
                    if length(ChannelText)>=Squareplots
                        % Add the text to app.UIAxes at the specified coordinates
                        set(ChannelText(Squareplots),'Position', [x y],'String' , textString, 'FontSize', 10, 'Color', 'k','Tag','ChannelText');
                    else
                        % Add the text to app.UIAxes at the specified coordinates
                        text(Figure, x, y, textString, 'FontSize', 10, 'Color', 'k','Tag','ChannelText');
                    end
                end

            else % left
                
                if ChannelRows == 1
                    x = 3.2+1;       % X-coordinate
                else
                    x = 3.2;       % X-coordinate
                end

                y = yPos+(squareHeight/2);       % Y-coordinate
                if ChannelRows == 1
                    textString = strcat("CH ",num2str(FirstZoomChannel+2+i));  % Text to display
                else
                    textString = strcat("CH ",num2str((FirstZoomChannel*2)+3+i));  % Text to display
                end

                if isempty(ChannelText)
                    % Add the text to app.UIAxes at the specified coordinates
                    text(Figure, x, y, textString, 'FontSize', 10, 'Color', 'k','Tag','ChannelText');
                else
                    if length(ChannelText)>=Squareplots
                        % Add the text to app.UIAxes at the specified coordinates
                        set(ChannelText(Squareplots),'Position', [x y],'String' ,textString, 'FontSize', 10, 'Color', 'k','Tag','ChannelText');
                    else
                        % Add the text to app.UIAxes at the specified coordinates
                        text(Figure, x, y, textString, 'FontSize', 10, 'Color', 'k','Tag','ChannelText');
                    end
                end
            end
        end
    end
end