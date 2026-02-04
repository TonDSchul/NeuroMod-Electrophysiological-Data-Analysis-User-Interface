function [NumChannel,ActiveDataChannel,SpikeData] = Module_MainWindow_ActiveChannel_ChannerlNumber_Grid_Traces(Info,SpikeData,WhatToDo,ActiveDataChannel,PreserveChannelLocations)

NumChannel = [];
OrigActive = ActiveDataChannel;

% With gaps
if PreserveChannelLocations
    if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"NumChan")
        %ChannNr
        NumChannel = length(unique(Info.ProbeInfo.ycoords(Info.ProbeInfo.ActiveChannel(1):Info.ProbeInfo.ActiveChannel(end))));
        %Active Channel
        if Info.ProbeInfo.OffSetRows == 0
            if Info.ProbeInfo.ActiveChannel(1)-1 ~= 0
                ActiveDataChannel = ActiveDataChannel - (Info.ProbeInfo.ActiveChannel(1)-1);
            end
        end
    end

    if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"Spikes")
        %% Prepare Spike Positions
        if ~isempty(SpikeData)
            SpikeData.Position = Info.ProbeInfo.ActiveChannel(SpikeData.Position);
            
            ChannelToSTartWith = 0;
            if Info.ProbeInfo.ActiveChannel(1)~=1
                ChannelToSTartWith = Info.ProbeInfo.ActiveChannel(1)-1;
            end

            if Info.ProbeInfo.OffSetRows == 0
                SpikeData.Position = SpikeData.Position - ChannelToSTartWith;
            end
        end
    end
    %end % No OffSetRows
    
    if Info.ProbeInfo.OffSetRows == 1
        % create artificial active channel (while preserrving relations) to
        % accomodate gaps in probe design 
        %ActiveIndicies = ismember(ActiveDataChannel,Info.ProbeInfo.ActiveChannel);
        pattern = [2 3 2 1]; 
        NewActiveChannel(1) = 1;
        i = 1;
        for nn = 1:length(Info.ProbeInfo.ActiveChannel(1):Info.ProbeInfo.ActiveChannel(end))-1
            NewActiveChannel(end+1) = NewActiveChannel(end) + pattern(i);
            i = mod(i, numel(pattern)) + 1;
        end
        AllActiveChannelss = Info.ProbeInfo.ActiveChannel(1):Info.ProbeInfo.ActiveChannel(end);
        ActiveIndicies = ismember(AllActiveChannelss,OrigActive);      	
        
        ActiveDataChannel = NewActiveChannel;
        ActiveDataChannel(ActiveIndicies==0) = [];
        
        if ~isempty(SpikeData)
            if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"Spikes")
                if strcmp(Info.SpikeType,"Internal")
                    for iii = 1:length(SpikeData.Position)
                        CurrentIdnice = ActiveDataChannel( Info.ProbeInfo.ActiveChannel(ismember(Info.ProbeInfo.ActiveChannel,OrigActive)) == SpikeData.Position(iii));
                        if ~isempty(CurrentIdnice)
                            SpikeData.Position(iii) = CurrentIdnice;
                        end
                    end
                end
            end
        end
    end
else % PreserveChannelLocations - no gaps
    %% No OffSetRows
   
    if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"NumChan")
        %ChannNr
        NumChannel = length(unique(Info.ProbeInfo.ycoords(Info.ProbeInfo.ActiveChannel)));
        %Active Channel
        [ActiveDataChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Info.ProbeInfo.ActiveChannel,ActiveDataChannel,'MainPlot');
    end

    if str2double(Info.ProbeInfo.NrRows)==2 && Info.ProbeInfo.OffSetRows == 1
        NumChannel = round(NumChannel/2);
    end
    
end