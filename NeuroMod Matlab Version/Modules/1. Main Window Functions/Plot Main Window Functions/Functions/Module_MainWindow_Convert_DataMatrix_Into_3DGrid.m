function [PlotData,SpikeDataCell,TimeToPlot] = Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Info,DataForMatrix,TimeToPlot,ActiveDataChannel,PreservePlotChannelLocations,SpikeData,WhatToDo)

%________________________________________________________________________________________

%% Function to prepare cell array with data to plot  grid view plot in main window
%% also handles detection of spikes within grid

% gets called in Module_Main_Window_Plot_Grid_Trace_View and
% Module_MainWindow_Plot_Data to prepare data for these plots or extract
% spikes for surf and mesh plots

% Inputs: 
% 1. Info: main data metadata structure from Data.Info
% 2. DataForMatrix: channel by time points data matrix with data being
% plotted in main window comes from
% Module_MainWindow_Convert_DataMatrix_Into_Grid!
% 3. TimeToPlot: vector double with time stamps for each data point
% 4. ActiveDataChannel: vector with currently active channel
% 5. PreserveChannelLocations: double, 1 or 0 whether to preserve the true distance
% between probe channels
% 6. SpikeData: cell array with dimension of probe design, holding spikes for
% each channel in spatially preserved channel order.
% 7. WhatToDo: char, what to do, either "JustData" to just get data matrix
% or "JustSpikes" to just get spikes or 'All' to get all. 

% Outputs:
% 1.PlotData: cell array (probe columns x rows)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


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

