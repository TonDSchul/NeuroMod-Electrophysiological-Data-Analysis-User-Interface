function [faceColor,EdgeColor] = ProbeView_ZoomedChannel_Color_Selection(LoopIteration,FirstZoomChannel,ChannelRows,OffSetRows,ReversedActiveChannelLeft,AllActiveChannel,ChannelRight,ChannelLeft,nrows,NrChannel,CurrentChannel,ActiveChannel)

%________________________________________________________________________________________
%% Function to set color of squares in probe view window depending on whether they are active channel and whether they are currently active

% Called in Utitlity_Plot_Zoomed_Channel_Right_Side - only if nr rows
% smaller than 3, since no zoomed selection is plotted otherwise

% Inputs: 
% 1. LoopIteration: double, number of sqaure currently looped through 
% 2. FirstZoomChannel: double, first channel number currently viewed in zoomed in
% channel selection (note: 'real' channel = channel nr - FirstZoomChannel since its flipped after plotting)
% 3. ChannelRows: Nr of channel rows
% 4. OffSetRows: double. nr of rows in probe design
% 5. ReversedActiveChannelLeft: vector with channel number on the left
% side(first row) when channel numbers reversed
% 6. AllActiveChannel: vector with all active channel (not matrix channel)
% 7. ChannelRight: vector 1:NrColumns for right channel row
% 8. ChannelLeft: vector 1:NrColumns for left channel row
% 9. nrows: current row iteration in Utitlity_Plot_Zoomed_Channel_Right_Side
% 10. NrChannel: double, number of all channel (active and inactive)
% 11. CurrentChannel: double, no influence currently, always 0
% 12. ActiveChannel: double vector, currently active channel

% Outputs:
% 1. faceColor: 1x3 RGB value with face color of currently plotted square
% (yellow if currently active, white or black if not)
% 2. EdgeColor: 1x3 RGB value with edge olor of currently plotted square (red if active channel)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

CurrentFirstChannel = NrChannel+1-FirstZoomChannel;

% Determine all channel colors 
if ChannelRows == 1
    ChannelColors = [];
    for nchannel = 1:NrChannel
        if nchannel == 1
            ChannelColors = [ChannelColors,"k"];
        elseif nchannel == 2 || nchannel == 3
            ChannelColors = [ChannelColors,"w"];
            current = -1;
            NewColor = "k";
        else 
            
            current = current+1;
            if current<=1
                ChannelColors = [ChannelColors,NewColor];
            else
                current = 0;
                if strcmp(NewColor,"k")
                    NewColor = "w";
                else
                    NewColor = "k";
                end
                ChannelColors = [ChannelColors,NewColor];
            end
            
        end
    end
end

%% 1 Row
if ChannelRows == 1
    %% Black White
    % 1 Row Offset
    if OffSetRows
        
        faceColor = ChannelColors(((NrChannel+1)-CurrentFirstChannel)+LoopIteration);
        
    % 1 Row No Offset
    else
        if mod(FirstZoomChannel, 2) == 1
            if mod(LoopIteration, 2) == 0
                faceColor = 'k'; 
            else
                faceColor = [0.5 0.5 0.5]; 
            end
        else
            if mod(LoopIteration, 2) == 0
                faceColor = [0.5 0.5 0.5]; 
            else
                faceColor = 'k'; 
            end
        end
    end
    
    %% Active Color
    CurrentChannel = ReversedActiveChannelLeft(LoopIteration+1);

    if sum(CurrentChannel==AllActiveChannel)>0
        EdgeColor = 'r'; 
    else
        EdgeColor = 'k'; 
    end

    if ~isempty(ChannelLeft) && nrows == 1
        if sum(CurrentChannel==ChannelLeft)>0
            faceColor = 'y'; 
        end
    else
        if sum(CurrentChannel==AllActiveChannel)>0
            EdgeColor = 'r'; 
        else
            EdgeColor = 'k'; 
        end
    end
end

%% 2 Rows
if ChannelRows >= 2

    CurrentChannel = CurrentChannel+1;
    %% Currently in loop: Left Row
    if mod(nrows, 2) == 1
        if mod(FirstZoomChannel, 2) == 1
            if mod(LoopIteration, 2) == 0
                faceColor = [0.5 0.5 0.5]; 
            else
                faceColor = 'k';
            end
        else
            if mod(LoopIteration, 2) == 0
                faceColor = 'k'; 
            else
                faceColor = [0.5 0.5 0.5]; 
            end
        end
    %% Currently in loop: Right Row
    else 
        if mod(FirstZoomChannel, 2) == 1
            if mod(LoopIteration, 2) == 0
                faceColor = 'k'; 
            else
                faceColor = [0.5 0.5 0.5];
            end
        else
            if mod(LoopIteration, 2) == 0
                faceColor = [0.5 0.5 0.5];
            else
                faceColor = 'k'; 
            end
        end
    end
    
    if NrChannel>=32
        Border = 32;
    else
        Border = NrChannel;
    end

    %% Determine the color based on the iteration index
    if  mod(nrows, 2) == 0 %% Right Row: even channel
        RealChannel = ChannelRight(LoopIteration+1);

        if sum(RealChannel==ActiveChannel)==1
            faceColor = 'y'; 
        end
        if sum(RealChannel==AllActiveChannel)>0
            EdgeColor = 'r'; 
        else
            EdgeColor = 'k'; 
        end
    else
        RealChannel = ChannelLeft(LoopIteration+1);
        if sum(RealChannel==ActiveChannel)==1
            faceColor = 'y'; 
        end
        if sum(RealChannel==AllActiveChannel)>0
            EdgeColor = 'r'; 
        else
            EdgeColor = 'k'; 
        end
    end
end