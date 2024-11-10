function Utitlity_Plot_Zoomed_Text_Channel_Right_Side(Figure,ChannelText,NrChannel,ChannelRows,FirstZoomChannel,numSquares,squareHeight,lowylimits,CorrrectedVerOffset,CreateProbeWindow,ChannelActivation)

Squareplots = 0;

if ~ChannelActivation || CreateProbeWindow
    % loop over probe channel rows
    for nrows = 1:ChannelRows   
        for i = 0:((numSquares) - 1)    
    
            if mod(i, 2) == 0            
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
            end
    
            %% Plot channel name
            Squareplots = Squareplots+1;
    
            if mod(nrows, 2) == 0 % right
                
                x = 6;       % X-coordinate
                y = yPos+(squareHeight/2);       % Y-coordinate
    
                currentchannel = NrChannel+2-(FirstZoomChannel+1+i);
    
                currentchannel = currentchannel+NrChannel;
    
                textString = strcat("CH ",num2str(currentchannel));  % Text to display
               
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
                
                currentchannel = NrChannel+1-(FirstZoomChannel+i);
    
                textString = strcat("CH ",num2str(currentchannel));  % Text to display
    
    
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