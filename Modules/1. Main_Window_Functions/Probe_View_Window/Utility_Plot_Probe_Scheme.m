function [yPoint,yLimits,ActiveChannel,yLimitsSquares,squareHeight] = Utility_Plot_Probe_Scheme(Figure,GrayProbeFilling,ProbeLines,ChannelViewLeft,NrChannel,ChannelSpacing,ActiveChannel,VerOffset,ChannelRows,LeftProbeChanged,AllActiveChannel,CreateProbeWindow,ChannelActivation,ChannelClicked,OffSetRows,RowClicked,FirstZoomChannel)

%________________________________________________________________________________________
%% Function to plot the complete probe scheme on the right of the probe view windows

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. GrayProbeFilling: vector with handles to gray patch plots -- empty
% when not necessray to plot or update
% 3. ProbeLines: array with line objects of the probe on the left -- empty
% when not necessray to plot or update
% 4. ChannelViewLeft: array with rectangle objects of the probe on the left (for all channel plotted) -- empty
% when not necessray to plot or update
% 5. NrChannel: double, from Data.Info structure or create probe view window
% 6. ChannelSpacing: double, from Data.Info structure in um
% 7. ActiveChannel: double, vector with currently active channel the userselected
% 8. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 9. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 10. LeftProbeChanged: double, 1 or 0 - if the left probe plot has to be
% updated -- saves time if not
% 11. AllActiveChannel: double, vector with active channel  from Data.Info
% structure
% 12. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 13. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 14. ChannelClicked: double, channel the user clicked on if he did so,
% empty if not
% 15. OffSetRows: logical, 1 or 0, if left and right row have an offset (only if two channelrows)
% 16. RowClicked: 0 if clicked on a row on the left
% 17. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions

% Outputs:
% 1. yPoint: y value of grey probe tip (warning: most likely negative!)
% 2. yLimits: double 1x2 vector with min and max value of plotted probe on
% the left - for y scale and detection where user clicked on
% 3. ActiveChannel: currently selected active channel
% 4. yLimitsSquares: double 1x2 vector with min and max value of plotted channel rectangles on
% the left, used as limit to plot black lines of channel zoomed on the
% right
% 5. squareHeight: double, Height of each square plotted in the left side
% (in um)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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
    
    if OffSetRows
        if ChannelRows == 1 
            xdistances = x1:(x2 - x1) / ((ChannelRows*2)+2):x2;
        else
            xdistances = x1:(x2 - x1) / ((ChannelRows*2)+3):x2;
        end
    else
        xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
    end
    
    squareWidth = xdistances(2)-xdistances(1);
    
    Squareplots = 0;
        
    if ChannelRows == 1 
        ActiveChannelLeft = ActiveChannel<=NrChannel;
        ReversedActiveChannelLeft = (numSquares+1)-ActiveChannel(ActiveChannelLeft);
        AllReversedActiveChannelLeft = (numSquares+1)-AllActiveChannel;
    elseif ChannelRows == 2     
        AllChannelLeft = NrChannel*2-1:-2:1;
        AllChannelRight = NrChannel*2:-2:1;
    end

    CurrentChannel = 0;
    % To know whether to plot white or black. Different when offset
    if ChannelRows == 1
        max_num = NrChannel; % Replace with your desired maximum number
        IndiciesBoxesPlottedLeftOffset = [];
        for i = 1:4:max_num
            IndiciesBoxesPlottedLeftOffset = [IndiciesBoxesPlottedLeftOffset, i, i+1]; % Append pairs of numbers
        end
    end

    for nrows = 1:ChannelRows
        
        % Current xposition for rectangle
        xPos = xdistances(nrows+nrows);
        
        for i = 0:(numSquares - 1)
            %% Offset every seconds row
            if ChannelRows == 1 
                if OffSetRows
                    if mod(i, 2) == 1
                        xPos = (xdistances(nrows+nrows)/2)+0.05;    
                    else
                        xPos = (xdistances(nrows+nrows+3)/2)+0.05;
                    end
                end
            else
                if OffSetRows
                    if nrows==1
                        if mod(i, 2) == 1
                            xPos = (xdistances(nrows+nrows)/2)+0.08;    
                        else
                            xPos = (xdistances(nrows+nrows+4)/2)+0.03;
                        end
                    else
                        if mod(i, 2) == 1
                            xPos = (xdistances(nrows+nrows)/2)+0.41;    
                        else
                            xPos = (xdistances(nrows+nrows+4)/2)+0.32;
                        end
                    end
                    xPos = xPos-0.07;
                end
            end
            
            % Current Depth
            if nrows == 1
                yPos = (i * (ChannelSpacing)) ; % y-position of the square
            else
                yPos = (i * (ChannelSpacing)) + VerOffset ; % y-position of the square
            end
            %% Just one row
            if ChannelRows == 1  %%%%%%%%%%%%%%%%%%%%%%%%
                
                % Different color top to bottom
                if OffSetRows
                    if sum(i+1==IndiciesBoxesPlottedLeftOffset)>0
                        if mod(i, 2) == 0
                            faceColor = 'k'; %
                        else
                            faceColor = 'w'; 
                        end
                    else
                        if mod(i, 2) == 0
                            faceColor = 'w'; %
                        else
                            faceColor = 'k'; 
                        end
                    end
                else
                    if mod(i, 2) == 0
                        faceColor = 'k'; %
                    else
                        faceColor = 'w'; 
                    end
                end

                if sum(ReversedActiveChannelLeft==i+1)
                    faceColor = 'y'; 
                end

                if sum(i+1 == AllReversedActiveChannelLeft)>0
                    Edgecolor = 'r';
                else
                    Edgecolor = 'none';
                end
            end
            %% Two Rows
            if ChannelRows == 2

                CurrentChannel = CurrentChannel+1;

                % Determine the color based on the iteration index - iterate
                % through black and white or set to yellow when active channel
                if nrows == 1
                    if mod(i+1, 2) == 0
                        faceColor = 'k'; %
                    else
                        faceColor = 'w'; 
                    end
                else
                    if mod(i+1, 2) == 0
                        faceColor = 'w'; %
                    else
                        faceColor = 'k'; 
                    end 
                end

                if CurrentChannel>NrChannel %% Right Row: even channel

                    RealChannel = AllChannelRight(i+1);

                    if sum(RealChannel==ActiveChannel)>0
                        faceColor = 'y'; 
                    end
    
                    if sum(RealChannel==AllActiveChannel)>0
                        Edgecolor = 'r';
                    else
                        Edgecolor = 'none';
                    end                
                else %% Left Row: odd channel 

                    RealChannel = AllChannelLeft(i+1);

                    if sum(RealChannel==ActiveChannel)>0
                        faceColor = 'y'; 
                    end
    
                    if sum(RealChannel==AllActiveChannel)>0
                        Edgecolor = 'r';
                    else
                        Edgecolor = 'none';
                    end      
                end
            end % 2 rows

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
                            set(ChannelViewLeft(Squareplots), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                              'EdgeColor', Edgecolor, 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
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

    AllChannelLeft = 1:2:NrChannel*2;
    AllChannelRight = 2:2:NrChannel*2;

    if ~isempty(ChannelClicked)
        
        if sum(ChannelClicked == ActiveChannel)>0 % if clicked active

            if OffSetRows
                if ChannelRows == 1 
                    xdistances = x1:(x2 - x1) / ((ChannelRows*2)+2):x2;
                else
                    xdistances = x1:(x2 - x1) / ((ChannelRows*2)+3):x2;
                end
            else
                xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
            end
            
            squareWidth = xdistances(2)-xdistances(1);
            
            if ChannelRows == 1
                if OffSetRows
                    if mod(ChannelClicked, 2) == 1
                        xPos = (xdistances(ChannelRows+ChannelRows)/2)+0.05;    
                    else
                        xPos = (xdistances(ChannelRows+ChannelRows+3)/2)+0.05;
                    end
                else
                    xPos = xdistances(1+1);
                end
            else
                if OffSetRows %%%%%%%%%%%%%% Left Right
                    if mod(FirstZoomChannel, 2) == 0
                        if RowClicked == 1   %1 = L1 2 = L2 3 = R1 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)-0.08;    
                        elseif RowClicked == 2 
                            xPos = (xdistances(ChannelRows+ChannelRows+2)/2)+0.03;
                        elseif RowClicked == 3 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)+0.41;
                        elseif RowClicked == 4
                            xPos = (xdistances(ChannelRows+ChannelRows+4)/2)+0.33;
                        end
                    else
                        if RowClicked == 1   %1 = L1 2 = L2 3 = R1 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)-0.08;    
                        elseif RowClicked == 2 
                            xPos = (xdistances(ChannelRows+ChannelRows+2)/2)+0.03;
                        elseif RowClicked == 3 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)+0.41;
                        elseif RowClicked == 4
                            xPos = (xdistances(ChannelRows+ChannelRows+2)/2)+0.46;
                        end
                    end
                    xPos = xPos-0.07;
                else % Channel Clicked 
                    if mod(ChannelClicked, 2) == 1
                        xPos = xdistances(1+1);
                    else
                        xPos = xdistances(2+2);
                    end
                end
            end
    
            if ChannelRows == 1
                yPos = ((ChannelClicked-1) * (ChannelSpacing)) ; % y-position of the square
            else
                if sum(AllChannelLeft==ChannelClicked)
                    ChannelIndex = find(AllChannelLeft==ChannelClicked);
                elseif sum(AllChannelRight==ChannelClicked)
                    ChannelIndex = find(AllChannelRight==ChannelClicked);
                end
                yPos = ((ChannelIndex-1) * (ChannelSpacing))+ VerOffset ; % y-position of the square
            end

            yPos = ((NrChannel-1) * (ChannelSpacing))-yPos;

            if ChannelRows == 1
                set(ChannelViewLeft((NrChannel+1)-ChannelClicked), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', 'y', 'Tag', 'ChannelViewLeft');
            else
                if mod(ChannelClicked, 2) == 1 %odd - plot on the left
                    AllLeft = 1:2:NrChannel*2;
                    TempChannelClicked = find(ChannelClicked==AllLeft);
                    if ChannelClicked == AllLeft(end)
                        yPos=yPos+ (VerOffset);
                        squareHeight = squareHeight-VerOffset;
                    end

                    set(ChannelViewLeft((NrChannel-TempChannelClicked)+1), 'Position', [xPos, yPos, squareWidth, squareHeight+ (VerOffset)], ...
                                              'EdgeColor', 'r', 'FaceColor', 'y', 'Tag', 'ChannelViewLeft');
 
                else % plot on the right
                    AllRight = 2:2:NrChannel*2;
                    TempChannelClicked = find(ChannelClicked==AllRight);
                    if ChannelClicked == AllRight(end)
                        yPos=yPos+ (VerOffset);
                        squareHeight = squareHeight-VerOffset;
                    end
                    yPos = yPos+VerOffset;
                    set(ChannelViewLeft((NrChannel*2+1) - (TempChannelClicked)), 'Position', [xPos, yPos, squareWidth, squareHeight+ (VerOffset)], ...
                                              'EdgeColor', 'r', 'FaceColor', 'y', 'Tag', 'ChannelViewLeft');
                end
            end

        else %if clicked inactive

            if OffSetRows
                if ChannelRows == 1 
                    xdistances = x1:(x2 - x1) / ((ChannelRows*2)+2):x2;
                else
                    xdistances = x1:(x2 - x1) / ((ChannelRows*2)+3):x2;
                end
            else
                xdistances = x1:(x2 - x1) / ((ChannelRows*2)+1):x2;
            end
            
            squareWidth = xdistances(2)-xdistances(1);
            
            if ChannelRows == 1
                if OffSetRows
                    if mod(ChannelClicked, 2) == 1
                        xPos = (xdistances(ChannelRows+ChannelRows)/2)+0.05;    
                    else
                        xPos = (xdistances(ChannelRows+ChannelRows+3)/2)+0.05;
                    end
                else
                    xPos = xdistances(1+1);
                end
            else
                if OffSetRows %%%%%%%%%%%%%% Left Right
                    if mod(FirstZoomChannel, 2) == 0
                        if RowClicked == 1   %1 = L1 2 = L2 3 = R1 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)-0.08;    
                        elseif RowClicked == 2 
                            xPos = (xdistances(ChannelRows+ChannelRows+2)/2)+0.03;
                        elseif RowClicked == 3 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)+0.41;
                        elseif RowClicked == 4
                            xPos = (xdistances(ChannelRows+ChannelRows+4)/2)+0.33;
                        end
                    else
                        if RowClicked == 1   %1 = L1 2 = L2 3 = R1 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)-0.08;    
                        elseif RowClicked == 2 
                            xPos = (xdistances(ChannelRows+ChannelRows+2)/2)+0.03;
                        elseif RowClicked == 3 
                            xPos = (xdistances(ChannelRows+ChannelRows)/2)+0.41;
                        elseif RowClicked == 4
                            xPos = (xdistances(ChannelRows+ChannelRows+2)/2)+0.46;
                        end
                    end
                    xPos = xPos-0.07;
                else % Channel Clicked 
                    if mod(ChannelClicked, 2) == 1
                        xPos = xdistances(1+1);
                    else
                        xPos = xdistances(2+2);
                    end
                end
            end
        
            if ChannelRows == 1
                yPos = ((ChannelClicked-1) * (ChannelSpacing)) ; % y-position of the square
            else
                if sum(AllChannelLeft==ChannelClicked)
                    ChannelIndex = find(AllChannelLeft==ChannelClicked);
                elseif sum(AllChannelRight==ChannelClicked)
                    ChannelIndex = find(AllChannelRight==ChannelClicked);
                end

                yPos = ((ChannelIndex-1) * (ChannelSpacing)); %+ VerOffset ; % y-position of the square
            end

            yPos = ((NrChannel-1) * (ChannelSpacing))-yPos;

            [faceColor] = ProbeView_ProbeScheme_Color_Selection_Inactivated(ChannelClicked,FirstZoomChannel,ChannelRows,OffSetRows,NrChannel,AllChannelLeft,AllChannelRight);
            
            if ChannelRows == 1
                set(ChannelViewLeft((NrChannel+1)-ChannelClicked), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
            else
                if mod(ChannelClicked, 2) == 1 %odd - plot on the left
                    AllLeft = 1:2:NrChannel*2;
                    TempChannelClicked = find(ChannelClicked==AllLeft);
                    set(ChannelViewLeft((NrChannel-TempChannelClicked)+1), 'Position', [xPos, yPos, squareWidth, squareHeight], ...
                                              'EdgeColor', 'r', 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');

                else % plot on the right
                    AllRight = 2:2:NrChannel*2;
                    TempChannelClicked = find(ChannelClicked==AllRight);
                    if ChannelClicked == AllRight(end)
                        yPos=yPos+ (VerOffset);
                        squareHeight = squareHeight-VerOffset;
                    end
                    set(ChannelViewLeft((NrChannel*2+1) - (TempChannelClicked)), 'Position', [xPos, yPos, squareWidth, squareHeight + (VerOffset)], ...
                                              'EdgeColor', 'r', 'FaceColor', faceColor, 'Tag', 'ChannelViewLeft');
                end
            end
        end
    end

    for nrows = 1:ChannelRows 
        for i = 0:(numSquares - 1)
          
            % Active Channel
            if nrows == 1
                yPos = (i * (ChannelSpacing)) ; % y-position of the square
            else
                yPos = (i * (ChannelSpacing)) + VerOffset ; % y-position of the square
            end

            if i == 0
                yLimitsSquares(1) = yPos;
            elseif i == (numSquares - 1)  
                yLimitsSquares(2) = yPos;
            end

        end
    end
else
    for nrows = 1:ChannelRows 
        for i = 0:(numSquares - 1)
          
            % Active Channel
            if nrows == 1
                yPos = (i * (ChannelSpacing)) ; % y-position of the square
            else
                yPos = (i * (ChannelSpacing)) + VerOffset ; % y-position of the square
            end

            if i == 0
                yLimitsSquares(1) = yPos;
            elseif i == (numSquares - 1)  
                yLimitsSquares(2) = yPos;
            end

        end
    end
end