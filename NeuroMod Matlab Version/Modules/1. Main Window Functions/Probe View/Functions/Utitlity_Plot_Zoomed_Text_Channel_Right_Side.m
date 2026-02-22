function Utitlity_Plot_Zoomed_Text_Channel_Right_Side(Figure,ChannelText,NrChannel,ChannelRows,FirstZoomChannel,numSquares,squareHeight,lowylimits,CorrrectedVerOffset,CreateProbeWindow,ChannelActivation,PlotChannelSpacing,VerOffset,ChannelSpacing,SwitchTopBottom,SquareXPos,SquareYPos,OffSetRows)

%________________________________________________________________________________________
%% Function to plot channel names on the zoomed channel on the right 

% Inputs: 
% 1. Figure: figure object of probe view window
% 2. ChannelText: array of text objects that show the channel name
% 3. NrChannel: double, from Data.Info structure or create probe view window
% 4. ChannelRows: double, 1 or 2 from Data.Info structure or create probe view window
% 5. FirstZoomChannel: First Channel shown in zoomed channel view on the
% right (lowest channel) - comes from ClickCallback functions
% 6. numSquares: double, number of channel sqaures plotted on the right
% 7. squareHeight: double, height of squares plotted on the right
% 8. lowylimits: lowest plot limit of channel plot on the right
% 9. CorrrectedVerOffset: double, vertical offset of channel rows plotted
% one the right in the actual plot (comes from Utitlity_Plot_Zoomed_Channel_Right_Side)
% 10. CreateProbeWindow: double, 1 or 0, if plot is for create probe window
% or probe view window
% 11. ChannelActivation: double, 1 or 0, if user activated/deactivated a
% channel (comes from ClickCallbacks), but also 1 if initialy created!!
% 12. PlotChannelSpacing: 1 or 0 if channel spacing between channel squares
% should be plotted on the right side
% 13. VerOffset: Vertical offset in um between channel rows (0 if 1 channel
% row) --> affects right row only. Positive and negative possible
% 14. ChannelSpacing: double, from Data.Info structure in um
% 15. SwitchTopBottom: 1 or 0 if upper and lower channel names are switched
% 16. SquareXPos: vector with all x position of all rows plotted (start and end of each row)
% 17. SquareYPos: vector with all x position of all columns plotted (start and end of each column)
% 18. OffSetRows: 1 or 0 whether every second column is offset to the right

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

Squareplots = 0;

if ~ChannelActivation || CreateProbeWindow
    if ChannelRows <=2
        % loop over probe channel rows
        for nrows = 1:ChannelRows   
            for i = 0:((numSquares) - 1)    
                
                if CorrrectedVerOffset > 0
                    if mod(i, 2) == 0            
                        if nrows == 1
                            yPos = lowylimits+ ((i * squareHeight) - CorrrectedVerOffset) + (CorrrectedVerOffset/2) ; % y-position of the square
                        else
                            yPos = lowylimits+ ((i * (squareHeight))) ; % y-position of the square
                        end
                    else
                        if nrows == 1
                            yPos = lowylimits+(i * (squareHeight) - CorrrectedVerOffset) + (CorrrectedVerOffset/2) ; % y-position of the square
                        else
                            yPos = lowylimits+((i * (squareHeight))) ; % y-position of the square
                        end
                    end
                else
                    if mod(i, 2) == 0            
                        if nrows == 1
                            yPos = lowylimits+ ((i * (squareHeight))) ; % y-position of the square
                        else
                            yPos = lowylimits+ ((i * squareHeight) + CorrrectedVerOffset) - (CorrrectedVerOffset/2) ; % y-position of the square
                        end
                    else
                        if nrows == 1
                            yPos = lowylimits+((i * (squareHeight))) ; % y-position of the square
                        else
                            yPos = lowylimits+(i * (squareHeight) + CorrrectedVerOffset) - (CorrrectedVerOffset/2) ; % y-position of the square
                        end
                    end
                end
        
                %% Plot channel name
                Squareplots = Squareplots+1;
        
                if mod(nrows, 2) == 0 % right
                    
                    x = 6;       % X-coordinate
                    
                    y = yPos+(squareHeight/2);       % Y-coordinate
        
                    if SwitchTopBottom % If top and bottom channel swicthed
                        if ChannelRows == 1
                            currentchannel = NrChannel+2-(FirstZoomChannel+1+i);
                            currentchannel = currentchannel+NrChannel;
                        else
                            if i == 0
                                currentchannel = (FirstZoomChannel+i)*2;
                            else
                                currentchannel = currentchannel+2;
                            end
                        end
                    else
                        if ChannelRows == 1
                            currentchannel = NrChannel+2-(FirstZoomChannel+1+i);
                            currentchannel = currentchannel+NrChannel;
                        else
                            if i == 0
                                currentchannel = (NrChannel+2-(FirstZoomChannel+1+i))*2;
                            else
                                currentchannel = currentchannel-2;
                            end
                        end
                    end
        
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
                    
    
                    if SwitchTopBottom % If top and bottom channel swicthed
                        if ChannelRows == 1
                            currentchannel = FirstZoomChannel+i;
                        else
                            if i == 0
                                currentchannel = (FirstZoomChannel+i)*2-1;
                            else
                                currentchannel = currentchannel+2;
                            end
                        end
                    else % If top and bottom channel NOT swicthed
                        if ChannelRows == 1
                            currentchannel = NrChannel+1-(FirstZoomChannel+i);
                        else
                            if i == 0
                                currentchannel = ((NrChannel-(FirstZoomChannel+i))*2)+1;
                            else
                                currentchannel = currentchannel-2;
                            end
                        end
                    end
    
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

    else %% 3 or more channel rows
        AllChannelNames = zeros(NrChannel,ChannelRows);
        LaufVariable = NrChannel*ChannelRows;
        for i = 1:NrChannel
            for j = 1:ChannelRows
                AllChannelNames(i,j) = LaufVariable;
                LaufVariable = LaufVariable-1;
            end
        end
        
        if ~SwitchTopBottom % If top and bottom channel swicthed
            AllChannelNames=flip(AllChannelNames,2);
        else
            AllChannelNames=flip(AllChannelNames,1);
            AllChannelNames=flip(AllChannelNames,2);
        end
        
        AllXPos = SquareXPos(1:2:end);
        
        for nchannel = 1:ChannelRows

            Squareplots = nchannel;
            
            x = AllXPos(nchannel)+0.3;
            
            AllYPos = SquareYPos;

            
            AllYPos = AllYPos+(squareHeight/2);       % Y-coordinate
            
            for nrows = 1:NrChannel
                
                if OffSetRows % every second row shifted in position to the right
                    if mod(nrows,2)==0
                        x = x - 0.72;
                    else
                        x = x + 0.72;
                    end
                end

                y = AllYPos(nrows);

                textString = strcat("CH ",num2str(AllChannelNames(nrows,nchannel)));  % Text to display
 
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
                Squareplots = Squareplots+ChannelRows;
            end
        end

    end
end