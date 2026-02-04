function [PlotData,SpikeDataCell,TimeToPlot] = Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Info,DataForMatrix,TimeToPlot,ActiveDataChannel,PreservePlotChannelLocations,SpikeData,WhatToDo)


[NumChannel,ActiveDataChannel,SpikeData] = Module_MainWindow_ActiveChannel_ChannerlNumber_Grid_Traces(Info,SpikeData,"All",ActiveDataChannel,PreservePlotChannelLocations);

%% Plot
DataLaufVariable = 1;
LaufVariable = 1;

NumRows = length(unique(Info.ProbeInfo.xcoords));

PlotData = cell(NumChannel, NumRows);
SpikeDataCell = cell(NumChannel, NumRows);

for nchannel = 1:NumChannel
    for nrows = 1:NumRows
        % Save Channel Data
        if strcmp(WhatToDo,'All') || strcmp(WhatToDo,'JustData')
           
            if sum(LaufVariable==ActiveDataChannel)>0
                PlotData{nchannel,nrows} = DataForMatrix(DataLaufVariable,:);
                DataLaufVariable = DataLaufVariable + 1;
            end

        end
        % Save Spike Data
        %% Handle Spikes
        if strcmp(WhatToDo,'All') || strcmp(WhatToDo,'JustSpikes')
            if ~isempty(SpikeData)
                if ~isempty(SpikeData.Indicie)
                    if PreservePlotChannelLocations==0
                        if sum(LaufVariable==SpikeData.Position)
                            SpikeIndicies = LaufVariable==SpikeData.Position;
                            SpikeDataCell{nchannel,nrows} = SpikeData.Indicie(SpikeIndicies)';
                        end
                    else
                        if sum(LaufVariable==SpikeData.Position)
                            
                            SpikeIndicies = LaufVariable==SpikeData.Position;
                            SpikeDataCell{nchannel,nrows} = SpikeData.Indicie(SpikeIndicies)';
                        end
                    end
                end
            end
        end
        LaufVariable = LaufVariable + 1;
    end
end

