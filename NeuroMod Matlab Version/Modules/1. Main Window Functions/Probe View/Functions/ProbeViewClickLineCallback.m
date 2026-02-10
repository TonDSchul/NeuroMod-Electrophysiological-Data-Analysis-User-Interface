function [app] = ProbeViewClickLineCallback(app, event, Window)

%________________________________________________________________________________________
%% Function to handle click on the probe view window -- only clicks not on a line or rectangle

% this functions handles all the magic happening when the user clicks a
% channel --> recognize clicekd channel, delete it from active channel and call
% analysis/plot functions from openend windows to update plotted data.

% Inputs: 
% 1. app: Probe View app window
% 2. event: click event holding x and y position
% 3. Window: not used here

% Outputs:
% 1. app: Probe View app window

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if isprop(app,'NrChannelEditField')
    ProbeViewWindow = 1;
else
    ProbeViewWindow = 0;
end

if isprop(app,'ChangeforWindowDropDown')
    Window = app.ChangeforWindowDropDown.Value;
end

% Get the click coordinates
clickPoint = event.IntersectionPoint; % X, Y, and Z of click
xClick = clickPoint(1);
yClick = clickPoint(2);

%% Check whether user clicked on a channel square on the right
ClickedOnChannelXDirection = 0;
ClickedOnChannelYDirection = 0;
ClickedOnChannelXDirectionRight = 0;
ClickedOnChannelXDirectionLeft = 0;

ClickedLeftSide = 0;
ClickedRightSide = 0;

ClickedLeftSideR1 = 0;
ClickedLeftSideR2 = 0;
ClickedRightSideR1 = 0;
ClickedRightSideR2 = 0;

ChannelClicked = [];

if ProbeViewWindow == 0    

    
    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)<=32
        numSquares = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel); % Number of squares - 
    else
        numSquares = 32; % Number of squares - 
    end

    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1 %% X for 1 row
        %% Check if x pos. of squares was clicked
        x1 = 4;   % lower x-limit of squares
        x2 = 6;   % upper x-limit of squares
    
        if ~app.Mainapp.Data.Info.ProbeInfo.OffSetRows
            Tempxdistances = (x1:(x2 - x1) / ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2)+1):x2)+1;
            squareWidth = Tempxdistances(2)-Tempxdistances(1);
            
            xdistances(1) = Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows));
            xdistances(2) = xdistances(1) + squareWidth;

            % if click in xrange of squares
            if xClick >= xdistances(1) && xClick <= xdistances(2)
                ClickedOnChannelXDirection = 1;
            end
        else
            Tempxdistances = (x1:(x2 - x1) / ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2)+2):x2)+1;
            squareWidth = Tempxdistances(2)-Tempxdistances(1);
          
            xdistances1(1) = (Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows))/2);    
            xdistances1(1) = xdistances1(1)+2.7;
            xdistances1(2) = xdistances1(1)+squareWidth;

            xdistances2(1) = (Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+2)/2)+0.2;
            xdistances2(1) = xdistances2(1)+2.7;
            xdistances2(2) = xdistances2(1)+squareWidth;
            
            % if click in xrange of squares
            if xClick >= xdistances1(1) && xClick <= xdistances1(2)
                ClickedLeftSide = 1; 
            else
                ClickedLeftSide = 0;
            end

            % if click in xrange of squares
            if xClick >= xdistances2(1) && xClick <= xdistances2(2)
                ClickedRightSide = 1;
            else
                ClickedRightSide = 0;
            end
        end
    end
    
    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) >= 2 %% X for 2 rows
            %% Check if x pos. of squares was clicked
            x1 = 4;   % lower x-limit of squares
            x2 = 6;   % upper x-limit of squares
        
        if ~app.Mainapp.Data.Info.ProbeInfo.OffSetRows

            Tempxdistances= x1:(x2 - x1) / ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2)+1):x2;
                        squareWidth = Tempxdistances(2)-Tempxdistances(1);

            squareWidth = squareWidth*str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows);

            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)>2
                Tempxdistances(:) = Tempxdistances(:) - 2;
                PreviousDist = Tempxdistances(4)-Tempxdistances(3);
                Tempxdistances(3) = Tempxdistances(3) + 1;
                Tempxdistances(4) = Tempxdistances(3) + PreviousDist;
                DistFirstTwo = Tempxdistances(3)-Tempxdistances(2);
                
                if length(Tempxdistances)>4
                    for i = 5:2:length(Tempxdistances)
                        Tempxdistances(i:i+1) = Tempxdistances(i-1)+DistFirstTwo;
                        Tempxdistances(i+1) = Tempxdistances(i+1) + PreviousDist;
                    end
                end
            end
            
            xdistanceRight(1) = Tempxdistances(2);
            xdistanceRight(2) = xdistanceRight(1) + squareWidth;
    
            xdistanceLeft(1) = Tempxdistances(4);
            xdistanceLeft(2) = xdistanceLeft(1) + squareWidth;
    
            % if click in xrange of squares
            if xClick >= xdistanceRight(1) && xClick <= xdistanceRight(2)
                ClickedOnChannelXDirectionLeft = 1;
            end
            % if click in xrange of squares
            if xClick >= xdistanceLeft(1) && xClick <= xdistanceLeft(2)
                ClickedOnChannelXDirectionRight = 1;
            end
            % overwrite previos caluclation
            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)>2
                XClickedOnRow = [];
                Laufvariable = 1;
                for t = 1:2:length(Tempxdistances)
                    xdistance(1) = Tempxdistances(t+1);
                    xdistance(2) = xdistance(1) + squareWidth;
            
                    % if click in xrange of squares
                    if xClick >= xdistance(1) && xClick <= xdistance(2)
                        ClickedOnChannelXDirectionLeft = 1;
                        XClickedOnRow = Laufvariable;
                    end
                    Laufvariable = Laufvariable + 1;
                end
            end
        else
            Tempxdistances = (x1:(x2 - x1) / ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2)+2):x2);
            
            % If negative offset second row, xdistances have to be shifted
            if str2double(app.Mainapp.Data.Info.ProbeInfo.OffSetRowsDistance)<0
                Tempxdistances = Tempxdistances - (Tempxdistances(2)-Tempxdistances(1));
            end

            squareWidth = Tempxdistances(2)-Tempxdistances(1);

            %%%%% Left Offset Row
            Lxdistances1(1) = (Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows))/2)-0.08;    
            Lxdistances1(1) = Lxdistances1(1)+1.78;
            Lxdistances1(2) = Lxdistances1(1)+squareWidth;

            Lxdistances2(1) = (Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+2)/2)+0.03; 
            Lxdistances2(1) = Lxdistances2(1)+1.78;
            Lxdistances2(2) = Lxdistances2(1)+squareWidth;
            %%%%% Right Offset Row
            Rxdistances1(1) = (Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows))/2)+0.61;    
            Rxdistances1(1) = Rxdistances1(1)+1.9;
            Rxdistances1(2) = Rxdistances1(1)+squareWidth;

            Rxdistances2(1) = (Tempxdistances(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+3)/2)+0.53; 
            Rxdistances2(1) = Rxdistances2(1)+1.9;
            Rxdistances2(2) = Rxdistances2(1)+squareWidth;
            
            %%%%% Left Offset Row
            % if click in xrange of squares
            if xClick >= Lxdistances1(1) && xClick <= Lxdistances1(2)
                ClickedLeftSideR1 = 1; 
            else
                ClickedLeftSideR1 = 0;
            end

            % if click in xrange of squares
            if xClick >= Lxdistances2(1) && xClick <= Lxdistances2(2)
                ClickedLeftSideR2 = 1;
            else
                ClickedLeftSideR2 = 0;
            end
            %%%%% Right Offset Row
            % if click in xrange of squares
            if xClick >= Rxdistances1(1) && xClick <= Rxdistances1(2)
                ClickedRightSideR1 = 1; 
            else
                ClickedRightSideR1 = 0;
            end

            % if click in xrange of squares
            if xClick >= Rxdistances2(1) && xClick <= Rxdistances2(2)
                ClickedRightSideR2 = 1;
            else
                ClickedRightSideR2 = 0;
            end

            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)>2
                squareWidth = Tempxdistances(2)-Tempxdistances(1);
                squareWidth = squareWidth*str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows);
            
                if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)>2
                    Tempxdistances(:) = Tempxdistances(:) - 2;
                    PreviousDist = Tempxdistances(4)-Tempxdistances(3);
                    Tempxdistances(3) = Tempxdistances(3) + 1;
                    Tempxdistances(4) = Tempxdistances(3) + PreviousDist;
                    DistFirstTwo = Tempxdistances(3)-Tempxdistances(2);
                    
                    if length(Tempxdistances)>4
                        for i = 5:2:length(Tempxdistances)
                            Tempxdistances(i:i+1) = Tempxdistances(i-1)+DistFirstTwo;
                            Tempxdistances(i+1) = Tempxdistances(i+1) + PreviousDist;
                        end
                    end
                end
            
                XClickedOnRow1 = [];
                Laufvariable = 1;
                xdistance = [];
                for t = 1:2:length(Tempxdistances)
                    xdistance(1) = Tempxdistances(t+1);
                    xdistance(2) = xdistance(1) + squareWidth;
            
                    % if click in xrange of squares
                    if xClick >= xdistance(1) && xClick <= xdistance(2)
                        ClickedOnChannelXDirectionLeft = 1;
                        XClickedOnRow1 = Laufvariable;
                    end
                    Laufvariable = Laufvariable + 1;
                end
                %every seond row diff position
                XClickedOnRow2 = [];
                Laufvariable = 1;
                xdistance = [];
            
                Tempxdistances = Tempxdistances + 0.72;

                for t = 1:2:length(Tempxdistances)
                    xdistance(1) = Tempxdistances(t+1);
                    xdistance(2) = xdistance(1) + squareWidth;
            
                    % if click in xrange of squares
                    if xClick >= xdistance(1) && xClick <= xdistance(2)
                        ClickedOnChannelXDirectionLeft = 1;
                        XClickedOnRow2 = Laufvariable;
                    end
                    Laufvariable = Laufvariable + 1;
                end
                
            end

        end
    end
    
    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1 || str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) >= 2
        %% Check if y pos. of squares was clicked
        yLimits = [0 ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-1)*app.Mainapp.Data.Info.ChannelSpacing)+(app.Mainapp.Data.Info.ChannelSpacing)*2];  % Get current y-axis limits to extend the lines
        yPoint = yLimits(1) - (yLimits(2) - yLimits(1)) / 10;  % y position below the minimum of the plotted lines

        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)<=64 % imit to show: 64 channel
            yLimitBracktes(1) = yPoint+abs(yPoint/2);
            yLimitBracktes(2) = ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-1)*app.Mainapp.Data.Info.ChannelSpacing)+str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel);
        else
            yLimitBracktes(1) = yPoint+abs(yPoint/2);
            yLimitBracktes(2) = ((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-1)*app.Mainapp.Data.Info.ChannelSpacing)-str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel);
        end

        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1
            highylimits = yLimitBracktes(2);
            lowylimits = yLimitBracktes(1);
        else
            highylimits = yLimitBracktes(2);
            lowylimits = yLimitBracktes(1);

            squareHeight = (highylimits-lowylimits)/numSquares;
            
            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)>2
                squareHeight = floor(squareHeight/3);
            end

            if str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset) ~= 0
                CorrectionFactor = app.Mainapp.Data.Info.ChannelSpacing/str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset);
                
                CorrrectedVerOffset = squareHeight/CorrectionFactor;
            else
                CorrrectedVerOffset = 0;
            end

            highylimits = yLimitBracktes(2)+CorrrectedVerOffset;
            lowylimits = yLimitBracktes(1)+CorrrectedVerOffset;
        end
        
        squareHeight = (highylimits-lowylimits)/numSquares;
                
        if yClick >= lowylimits && yClick <= highylimits
            ClickedOnChannelYDirection = 1;
        end

        % get specific column if more than 2 channel

        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)>2
            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) > 2
                highylimits = highylimits+0.3*app.Mainapp.Data.Info.ChannelSpacing;
                lowylimits = lowylimits+0.3*app.Mainapp.Data.Info.ChannelSpacing;
            end
            
            yPos = NaN(1,numSquares);
            for i = 0:((numSquares) - 1)  
                yPos(i+1) = lowylimits+ ((i * squareHeight) + CorrrectedVerOffset) - (CorrrectedVerOffset/2); % y-position of the square
            end
            
            yPos = flip(yPos);
            YClickedOnRow = [];
            Laufvariable = 1;
            for t = 1:length(yPos)
                % if click in xrange of squares
                if yClick >= yPos(t) && yClick <= yPos(t)+squareHeight
                    YClickedOnRow = Laufvariable;
                end
                Laufvariable = Laufvariable + 1;
            end
        end
    end
    
    %% if more than 2 rows and offset! determine if indented x position or normal x position required
    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) > 2 && app.Mainapp.Data.Info.ProbeInfo.OffSetRows
        if mod(YClickedOnRow,2)
            XClickedOnRow = XClickedOnRow1;
        else
            XClickedOnRow = XClickedOnRow2;
        end
    end

    %% If user clicked on channel on the right detect channel

    %
    TwoRowOffsetDesignHit = 0;
    HitRight = 0;
    HitLeft = 0;
    if sum([ClickedLeftSideR1,ClickedOnChannelYDirection]) == 2
        TwoRowOffsetDesignHit = 1;
        HitLeft = 1;
    elseif sum([ClickedLeftSideR2,ClickedOnChannelYDirection]) == 2
        TwoRowOffsetDesignHit = 1;
        HitLeft = 1;
    elseif sum([ClickedRightSideR1,ClickedOnChannelYDirection]) == 2
        TwoRowOffsetDesignHit = 1;
        HitRight = 1;
    elseif sum([ClickedRightSideR2,ClickedOnChannelYDirection]) == 2
        TwoRowOffsetDesignHit = 1;
        HitRight = 1;
    end

    if sum([ClickedOnChannelXDirection,ClickedOnChannelYDirection]) == 2 || sum([ClickedOnChannelXDirectionRight,ClickedOnChannelYDirection]) == 2 || ClickedOnChannelXDirectionLeft == 1 && ClickedOnChannelYDirection == 1 || ClickedOnChannelYDirection == 1 && ClickedLeftSide == 1 || ClickedOnChannelYDirection == 1 && ClickedRightSide == 1 || TwoRowOffsetDesignHit == 1
        
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 1
            if app.FirstZoomChannel > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)
                if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)>=32
                    app.FirstZoomChannel = app.FirstZoomChannel-32+1;
                else
                    app.FirstZoomChannel = 1;
                end
            end
            if app.FirstZoomChannel+31 > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)
                app.FirstZoomChannel = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-32+1;
            end
        else
            if (app.FirstZoomChannel*2)+64 >= str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2+1
                %dont update plot
                
                if app.Mainapp.Data.Info.ProbeInfo.NrChannel*2>=64
                    app.FirstZoomChannel = round(((str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2-64)+1)/2);
                else
                    app.FirstZoomChannel = 1;
                end
            end
        end
 
        if app.FirstZoomChannel <= 0
            app.FirstZoomChannel = 1;
        end

        %% detect based on plotted channelnames
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) >=2 && ClickedOnChannelXDirectionRight == 1 || str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) >=2 && HitRight == 1
            
            yPos = NaN((numSquares) - 1,2);
            currentchannel = [];

            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel) >= 32
                for i = 0:((numSquares) - 1) 
                   yPos(i+1,1) = (lowylimits+ (i * squareHeight)); % lower y pos
                   yPos(i+1,2) = (lowylimits+ (i * squareHeight)) +squareHeight; % upper y pos
                   if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2
                        currentchannel(i+1) = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1-(app.FirstZoomChannel+1+i);
                   else
                        currentchannel(i+1) = str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+1-(app.FirstZoomChannel+1+i);
                   end
                end
              
                currentchannel = currentchannel+str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1;
            else
                for i = 0:((numSquares) - 1) 
                   yPos(i+1,1) = (lowylimits+ (i * squareHeight)); % lower y pos
                   yPos(i+1,2) = (lowylimits+ (i * squareHeight)) +squareHeight; % upper y pos
                    if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2
                        currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2+1)-(i+1);
                    else
                        currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)*2+1)-(i+1);
                    end
                end
            end

        elseif str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) >=2 && ClickedOnChannelXDirectionLeft == 1 || str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) >=2 && HitLeft == 1
            %if more than 2 channel rows only here!!!
            yPos = NaN((numSquares) - 1,2);
            currentchannel = [];

            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel) >= 32
                if CorrrectedVerOffset ~=0
                     for i = 0:((numSquares) - 1) 
                        yPos(i+1,1) = lowylimits+ ((i * (squareHeight)))-CorrrectedVerOffset; % lower y pos
                        yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight-CorrrectedVerOffset; % upper y pos
                        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel))+2-(app.FirstZoomChannel+1+i);
                        else
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows))+2-(app.FirstZoomChannel+1+i);
                        end
                        
                     end
                else
                    for i = 0:((numSquares) - 1) 
                        yPos(i+1,1) = lowylimits+ ((i * (squareHeight))); % lower y pos
                        yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight; % upper y pos
                        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel))+2-(app.FirstZoomChannel+1+i);
                        else
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows))+2-(app.FirstZoomChannel+1+i);
                        end
                     end
                end
            else
                if CorrrectedVerOffset ~=0
                     for i = 0:((numSquares) - 1) 
                        yPos(i+1,1) = lowylimits+ ((i * (squareHeight)))-CorrrectedVerOffset; % lower y pos
                        yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight-CorrrectedVerOffset; % upper y pos
                        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1)-(i+1);
                        else
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+1)-(i+1);
                        end
                     end
                else
                    for i = 0:((numSquares) - 1) 
                        yPos(i+1,1) = lowylimits+ ((i * (squareHeight))); % lower y pos
                        yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight; % upper y pos
                        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==2
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1)-(i+1);
                        else
                            currentchannel(i+1) = (str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)+1)-(i+1);
                        end
                     end
                end
            end
            
        end

        %% detect based on plotted channelnames
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==1 
            yPos = NaN((numSquares) - 1,2);
            currentchannel = [];

             for i = 0:((numSquares) - 1) 
                yPos(i+1,1) = lowylimits+ ((i * (squareHeight))); % lower y pos
                yPos(i+1,2) = lowylimits+ ((i * (squareHeight)))+squareHeight; % upper y pos

                currentchannel(i+1) = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1-(app.FirstZoomChannel+i);
             end
        end
        
        % Find the index where y_value lies within the range
        Index = find(yClick >= yPos(:,1) & yClick <= yPos(:,2), 1);
        
        if isempty(Index)
            Index = 1;
        end
        
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) >2 %%% ARRAY
            ChannelMatrix = NaN(str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)); 
            %ChannelMatrix = NaN(str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)); 
            Laufvariable = 1;
            for m = 1:str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)
                for n = 1:str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows)
                    ChannelMatrix(m,n) = Laufvariable;
                    Laufvariable = Laufvariable + 1;
                end
            end
            % if top bottom channel switched
            if app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
                ChannelMatrix = flip(ChannelMatrix,1);
            end
            ChannelClicked = ChannelMatrix(YClickedOnRow,XClickedOnRow);
            
            if app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
                AllChannel = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows);
                ChannelClicked = (AllChannel-ChannelClicked)+1;
            end

        end

        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) ==1 
            ChannelClicked = currentchannel(Index);
        elseif str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 2 % keep = !
            if ClickedOnChannelXDirectionLeft || HitLeft == 1 
                if currentchannel(Index) == 1
                    ChannelClicked = 1;
                else
                    ChannelClicked = currentchannel(Index)*2-1;
                end
            else
                if currentchannel(Index) == str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1
                    ChannelClicked = currentchannel(Index)-str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)+1;
                else
                    ChannelClicked = (currentchannel(Index)-str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel))*2;
                end
            end
        end
        
        if str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows) == 2 && app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
            if mod(ChannelClicked, 2) == 1
                ChannelClicked = ChannelClicked+1;
            else
                ChannelClicked = ChannelClicked-1;
            end
        end
        
        if isempty(ChannelClicked)
            return
        end

        if sum(ChannelClicked == app.Mainapp.Data.Info.ProbeInfo.ActiveChannel)>0
            %% If clicked Channel is active, inactivate it
        
            if sum(ChannelClicked==app.Mainapp.ActiveChannel)>0
                if length(app.Mainapp.ActiveChannel)>=2
                    app.Mainapp.ActiveChannel(ChannelClicked==app.Mainapp.ActiveChannel) = [];
                else
                    msgbox("Warning: At least one channel required to be active.")
                end
            else
                app.Mainapp.ActiveChannel = sort([app.Mainapp.ActiveChannel,ChannelClicked]);
            end
                       
            if isscalar(app.Mainapp.ActiveChannel)
                app.Mainapp.UIAxes.YTickMode = 'auto';
                app.Mainapp.UIAxes.YTickLabelMode = 'auto';
                ylabel(app.Mainapp.UIAxes,"Signal [mV]");
            else
                app.Mainapp.UIAxes.YTick = [];         % Remove Y ticks
                app.Mainapp.UIAxes.YTickLabel = {};    % Remove Y tick labels
                ylabel(app.Mainapp.UIAxes,"");
            end

            if isfield(app.Mainapp.Data.Info.ProbeInfo,'CompleteAreaNames')
                BrainAreaInfo = app.Mainapp.Data.Info.ProbeInfo.CompleteAreaNames;
            else
                BrainAreaInfo = [];
            end

            AllActiveChannel = app.Mainapp.Data.Info.ProbeInfo.ActiveChannel;
            ActiveChannel = app.Mainapp.ActiveChannel;
           
            TwoRowOffsetDesignHit = 0;
            if sum([ClickedLeftSideR1,ClickedOnChannelYDirection]) == 2
                TwoRowOffsetDesignHit = 1;
            elseif sum([ClickedLeftSideR2,ClickedOnChannelYDirection]) == 2
                TwoRowOffsetDesignHit = 2;
            elseif sum([ClickedRightSideR1,ClickedOnChannelYDirection]) == 2
                TwoRowOffsetDesignHit = 3;
            elseif sum([ClickedRightSideR2,ClickedOnChannelYDirection]) == 2
                TwoRowOffsetDesignHit = 4;
            end

            %% Update plots with new channelselection

        
            if strcmp(Window,'Main Window') || strcmp(Window,'All Windows Opened') || strcmp(Window,'Main Plot Current Source Density') || strcmp(Window,'Main Plot Power Estimate') || strcmp(Window,'Main Plot Spike Rate') || strcmp(Window,'Main Plot Phase Synchronization')
              
                app.Mainapp.ChannelChange = "ProbeView";
    
                Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp,0,"Subsequent","Static",app.Mainapp.PlotEvents,app.Mainapp.Plotspikes);
                
                if isscalar(app.Mainapp.ActiveChannel)
                    app.Mainapp.UIAxes.YTickMode = 'auto';
                    app.Mainapp.UIAxes.YTickLabelMode = 'auto';
                    ylabel(app.Mainapp.UIAxes,"Signal [mV]");
                else
                    %app.Mainapp.UIAxes.YTick = [];         % Remove Y ticks
                    %app.Mainapp.UIAxes.YTickLabel = {};    % Remove Y tick labels
                    %ylabel(app.Mainapp.UIAxes,"");
                end
            end
           
            if strcmp(Window,'Static Spectrum Window') || strcmp(Window,'All Windows Opened')
                if ~isempty(app.Mainapp.ContStaticSpectrumWindow)
                    if isvalid(app.Mainapp.ContStaticSpectrumWindow)
                        Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.ProbeInfo.OffSetRowsDistance,ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,AllActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,1,ChannelClicked,app.Mainapp.Data.Info.ProbeInfo.OffSetRows,TwoRowOffsetDesignHit,app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel,app.Mainapp.Data.Info.ProbeInfo.SwitchLeftRightChannel,app.Mainapp.Data.Info.ProbeInfo.ECoGArray);
                        if strcmp(app.Mainapp.ContStaticSpectrumWindow.AnalysisDropDown.Value,'Band Power over Depth')
                            [app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,~] = Continous_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.ContStaticSpectrumWindow.DataSourceDropDown.Value,app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,app.Mainapp.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Value,app.Mainapp.ContStaticSpectrumWindow.UIAxes,app.Mainapp.ContStaticSpectrumWindow.UIAxes_2,app.Mainapp.ContStaticSpectrumWindow.TextArea,'All',app.Mainapp.ContStaticSpectrumWindow.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.ActiveChannel,app.Mainapp.PlotAppearance,app.Mainapp.PreservePlotChannelLocations);
                        else
                            [app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,~] = Continous_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.ContStaticSpectrumWindow.DataSourceDropDown.Value,app.Mainapp.PowerSpecResults,app.Mainapp.ContStaticSpectrumWindow.BandPower,app.Mainapp.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Value,app.Mainapp.ContStaticSpectrumWindow.UIAxes,app.Mainapp.ContStaticSpectrumWindow.UIAxes_2,app.Mainapp.ContStaticSpectrumWindow.TextArea,'Just Frequency Bands',app.Mainapp.ContStaticSpectrumWindow.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.ActiveChannel,app.Mainapp.PlotAppearance,app.Mainapp.PreservePlotChannelLocations);
                        end
                        if strcmp(app.Mainapp.ContStaticSpectrumWindow.AnalysisDropDown.Value,'Band Power over Depth')
                            cb = colorbar(app.Mainapp.ContStaticSpectrumWindow.UIAxes);
                            cb.Color = 'k';              % Sets tick mark and label color to black
                            cb.Label.String = "Power [dB]";
                            cb.Label.Rotation = 270;
                            %cb.FontSize =  app.Mainapp.PlotAppearance.SpectrumWindow.Data.TimeFontSize;
                            cb.Label.Color = 'k';        % Sets the color of the label text
                        else
                            cb = colorbar(app.Mainapp.ContStaticSpectrumWindow.UIAxes);   % Create a colorbar (if it exists)
                            if ~isempty(cb)
                                delete(cb);                  % Delete the colorbar
                            end
                        end

                    end
                end
            end
            
            if strcmp(Window,'All Windows Opened') || strcmp(Window,'Cont. Spike Analysis')
                if ~isempty(app.Mainapp.ConInternalSpikesWindow) || ~isempty(app.Mainapp.ConKilosortSpikesWindow)
                    [app] = Utility_ProbeChange_Plot_ContSpikes(app);
                end
            end

            if strcmp(Window,'All Windows Opened') || strcmp(Window,'Event Spike Analysis')
                if ~isempty(app.Mainapp.EventInternalSpikesWindow) || ~isempty(app.Mainapp.EventKilosortSpikesWindow)
                    [app] = Utility_ProbeChange_Plot_EventSpikes(app);
                end
            end
           
            if strcmp(Window,'Event CSD Window') && ~isempty(app.Mainapp.EventLFPCSD) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventLFPCSD)
                [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'CSD');
            end
            if strcmp(Window,'Event ERP Window') && ~isempty(app.Mainapp.EventLFPERP) || strcmp(Window,'All Windows Opened')  && ~isempty(app.Mainapp.EventLFPERP)
                [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'ERP');
            end
            if strcmp(Window,'Event Static Spectrum Window') && ~isempty(app.Mainapp.EventLFPSSP) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventLFPSSP)
                [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'EventSpectrum');
            end
            if strcmp(Window,'Event Time Frequency Power Window') && ~isempty(app.Mainapp.EventLFPTF) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventLFPTF)
                [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'TF');
            end
            if strcmp(Window,'Event Phase Synchronization') && ~isempty(app.Mainapp.EventPhaseSynchro) || strcmp(Window,'All Windows Opened') && ~isempty(app.Mainapp.EventPhaseSynchro)
                [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,'PhaseSync');
            end

            if strcmp(Window,'Prepro Artefact Rejection') || strcmp(Window,'All Windows Opened')
                if ~isempty(app.Mainapp.PreproArtefactRejection)
                    [~,app.Mainapp.PreproArtefactRejection.StimArtefactInfo] = Preprocess_Extract_and_Plot_Stimulation_Artefact(app.Mainapp.Data, app.Mainapp.PreproArtefactRejection.TimeAroundEventsEditField_2.Value ,app.Mainapp.PreproArtefactRejection.TimeAroundEventsEditField.Value, app.Mainapp.PreproArtefactRejection.EventChannelforStimulationDropDown.Value, app.Mainapp.PreproArtefactRejection.EventstoPlotDropDown.Value, app.Mainapp.PreproArtefactRejection.Slider.Value, app.Mainapp.PreproArtefactRejection.UIAxes, app.Mainapp.ActiveChannel);            
                end
            end

            Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.ProbeInfo.OffSetRowsDistance,ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,AllActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,1,ChannelClicked,app.Mainapp.Data.Info.ProbeInfo.OffSetRows,TwoRowOffsetDesignHit,app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel,app.Mainapp.Data.Info.ProbeInfo.SwitchLeftRightChannel,app.Mainapp.Data.Info.ProbeInfo.ECoGArray);

            app.ChannelSelectionEditField.Value = '';

        end
    end
end


%% Set Probe Information Window for data extraction stuff

TwoRowOffsetDesignHit = 0;
if sum([ClickedLeftSideR1,ClickedOnChannelYDirection]) == 2
    TwoRowOffsetDesignHit = 1;
elseif sum([ClickedLeftSideR2,ClickedOnChannelYDirection]) == 2
    TwoRowOffsetDesignHit = 1;
elseif sum([ClickedRightSideR1,ClickedOnChannelYDirection]) == 2
    TwoRowOffsetDesignHit = 1;
elseif sum([ClickedRightSideR2,ClickedOnChannelYDirection]) == 2
    TwoRowOffsetDesignHit = 1;
end

if ProbeViewWindow 

    Channel = ceil(yClick/str2double(app.ChannelSpacingumEditField.Value));
    rows = str2double(app.ChannelRowsDropDown.Value);
    
    if Channel <= 0
        Channel = 1;
    end
    
    if rows == 1
        if str2double(app.NrChannelEditField.Value)>=32 % for 32 channel: ends up with channel 1
            if Channel+32-1 > str2double(app.NrChannelEditField.Value)
                Channel = str2double(app.NrChannelEditField.Value)-32+1;
            end
        else % less than 32 channels: dont update, start channel is always 1
            Channel = 1;
        end
    else
        if str2double(app.NrChannelEditField.Value)*2>=64
            if Channel+64-1 > str2double(app.NrChannelEditField.Value)*2
                Channel = str2double(app.NrChannelEditField.Value)*2-64+1;
            end
        else
            if Channel + (str2double(app.NrChannelEditField.Value)*2) > str2double(app.NrChannelEditField.Value)*2
                Channel = 1;
            end
        end
    end

    app.FirstZoomChannel = Channel;
    
    if isempty(app.ActiveChannelField.Value{1})
        ActiveChannel = 1:str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value);
    else
        ActiveChannel = str2double(strsplit(app.ActiveChannelField.Value{1},','));
    end

    if app.ReverseTopandBottomChannelNumberCheckBox.Value == 1
        ActiveChannel = (str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value)+1)-ActiveChannel;
    end

    if isfield(app.ProbeTrajectoryInfo,'AreaNamesLong')
        BrainAreaInfo = app.ProbeTrajectoryInfo;
    else
        BrainAreaInfo = [];
    end

    Utility_Plot_Interactive_Probe_View(app.UIAxes,str2double(app.ChannelSpacingumEditField.Value),str2double(app.NrChannelEditField.Value),str2double(app.ChannelRowsDropDown.Value),str2double(app.HorizontalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField.Value),str2double(app.VerticalOffsetumEditField_2.Value),ActiveChannel,app.FirstZoomChannel,0,BrainAreaInfo,ActiveChannel,app.ShowChannelSpacingCheckBox.Value,1,0,[],app.CheckBox.Value,[],app.ReverseTopandBottomChannelNumberCheckBox.Value,app.SwitchLeftandRightChannelNumberCheckBox.Value,app.ECoGArrayCheckBox.Value)

%% Main Window probe view_____if clicked on a line but not on a channel on the right side --> not to change channel selection
elseif ~ProbeViewWindow && sum([ClickedOnChannelXDirection,ClickedOnChannelYDirection]) < 2 && ClickedOnChannelYDirection == 0 || ClickedOnChannelXDirection == 0 && sum([ClickedOnChannelYDirection,ClickedRightSide])<2 && sum([ClickedOnChannelYDirection,ClickedLeftSide])<2 && TwoRowOffsetDesignHit == 0 % no change when user clicked on a channel square in the right
    
    x1 = 4;   % lower x-limit of squares
    x2 = 6;   % upper x-limit of squares
   
    if xClick <= x2 && xClick >= x1
        return;
    end

    if ClickedOnChannelXDirectionLeft == 0 && ClickedOnChannelXDirectionRight == 0
            Channel = ceil(yClick/app.Mainapp.Data.Info.ChannelSpacing);
            rows = str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows);
        
        if Channel <= 0
            Channel = 1;
        end
        
        if rows == 1
            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)>=32 % for 32 channel: ends up with channel 1
                if Channel+32-1 > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)
                    Channel = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)-32+1;
                end
            else % less than 32 channels: dont update, start channel is always 1
                Channel = 1;
            end
        else
            if str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2>=64
                if Channel+64-1 > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2
                    Channel = str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2-64+1;
                end
            else
                if Channel + (str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2) > str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel)*2
                    Channel = 1;
                end
            end
        end

        app.FirstZoomChannel = Channel;

        if isfield(app.Mainapp.Data.Info.ProbeInfo,'CompleteAreaNames')
            BrainAreaInfo = app.Mainapp.Data.Info.ProbeInfo.CompleteAreaNames;
        else
            BrainAreaInfo = [];
        end

        AllActiveChannel = app.Mainapp.Data.Info.ProbeInfo.ActiveChannel;
        ActiveChannel = app.Mainapp.ActiveChannel;
       
        Utility_Plot_Interactive_Probe_View(app.UIAxes,app.Mainapp.Data.Info.ChannelSpacing,str2double(app.Mainapp.Data.Info.ProbeInfo.NrChannel),str2double(app.Mainapp.Data.Info.ProbeInfo.NrRows),str2double(app.Mainapp.Data.Info.ProbeInfo.HorOffset),str2double(app.Mainapp.Data.Info.ProbeInfo.VertOffset),app.Mainapp.Data.Info.ProbeInfo.OffSetRowsDistance,ActiveChannel,app.FirstZoomChannel,1,BrainAreaInfo,AllActiveChannel,app.ShowChannelSpacingCheckBox.Value,0,0,[],app.Mainapp.Data.Info.ProbeInfo.OffSetRows,[],app.Mainapp.Data.Info.ProbeInfo.SwitchTopBottomChannel,app.Mainapp.Data.Info.ProbeInfo.SwitchLeftRightChannel,app.Mainapp.Data.Info.ProbeInfo.ECoGArray)
    end
end
