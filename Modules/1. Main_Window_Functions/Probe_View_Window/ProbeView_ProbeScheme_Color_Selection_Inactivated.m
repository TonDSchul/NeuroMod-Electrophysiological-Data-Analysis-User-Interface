function [faceColor] = ProbeView_ProbeScheme_Color_Selection_Inactivated(ChannelClicked,FirstZoomChannel,ChannelRows,OffSetRows,NrChannel,AllChannelLeft,AllChannelRight)

%________________________________________________________________________________________
%% Function to determine the color of a channel in the probe view window when it is clicked at

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

% Outputs:
% 1. Waveforms: nchannel x nwaveforms x ntime matrix saving each extract
% waveform
% 2. BiggestSpikeIndicies: 1 x nrspikes (length of SpikeTimes). 1 if spike waveform was extracted, 0 if spike waveform was NOT
% extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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