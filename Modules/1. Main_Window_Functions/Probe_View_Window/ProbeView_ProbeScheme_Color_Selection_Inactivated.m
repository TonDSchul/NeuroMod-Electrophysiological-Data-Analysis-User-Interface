function [faceColor] = ProbeView_ProbeScheme_Color_Selection_Inactivated(ChannelClicked,FirstZoomChannel,ChannelRows,OffSetRows,NrChannel,AllChannelLeft,AllChannelRight)

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

% Determine the color based on the iteration index - iterate
% through black and white or set to yellow when active channel
if ChannelRows == 1
    if OffSetRows
        faceColor = ChannelColors(ChannelClicked);
    else
        if mod(FirstZoomChannel, 2) == 1
            if mod(ChannelClicked, 2) == 0
                faceColor = 'k'; 
            else
                faceColor = 'w'; 
            end
        else
            if mod(ChannelClicked, 2) == 0
                faceColor = 'k'; 
            else
                faceColor = 'w'; 
            end
        end
    end
else
    if sum(ChannelClicked==AllChannelLeft)== 1
        if mod(find(ChannelClicked==AllChannelLeft), 2) == 0
            faceColor = 'w'; %
        else
            faceColor = 'k'; 
        end
    else
        if mod(find(ChannelClicked==AllChannelRight), 2) == 0
            faceColor = 'k'; %
        else
            faceColor = 'w'; 
        end 
    end
end