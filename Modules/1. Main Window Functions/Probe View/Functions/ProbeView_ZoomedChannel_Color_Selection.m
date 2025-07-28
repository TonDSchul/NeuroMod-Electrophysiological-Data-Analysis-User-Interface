function [faceColor,EdgeColor]= ProbeView_ZoomedChannel_Color_Selection(LoopIteration,FirstZoomChannel,ChannelRows,OffSetRows,ReversedActiveChannelLeft,AllActiveChannel,ChannelRight,ChannelLeft,nrows,NrChannel,CurrentChannel,ActiveChannel)

%________________________________________________________________________________________
%% Function to determine the color of a channel in the probe view window when it is clicked at
%% -- for zoomed channel selction on the right of the probe view window

% This function is executed every time the probe view window is newly
% opened/plotted. Only executed, if y limits change

% Inputs: 
% 1. ChannelClicked: double, channel the user clicked at in the probe view
% window (empty when non was clicked)
% 2. FirstZoomChannel: First channel of the zoomed selection in the right
% (from the bottom)
% 3. ChannelRows: double, specifies whether probe has one or two rows
% 4. OffSetRows: double, 1 or 0, specifies, whether every second channel row is shifted to the right 
% 5. NrChannel: doubl, number of channel from Data.Info
% 6. AllChannelLeft: vector, with all channel indicies on the left row
% 7. AllChannelRight: vector, with all channel indicies on the right row (if present)
% 8. ChannelRight,ChannelLeft,nrows,NrChannel,CurrentChannel,ActiveChannel


% Outputs:
% 1. Waveforms: nchannel x nwaveforms x ntime matrix saving each extract
% waveform
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted

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
if ChannelRows == 2

    CurrentChannel = CurrentChannel+1;
    %% Currently in loop: Left Row
    if nrows == 1
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
    if  nrows == 2 %% Right Row: even channel
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