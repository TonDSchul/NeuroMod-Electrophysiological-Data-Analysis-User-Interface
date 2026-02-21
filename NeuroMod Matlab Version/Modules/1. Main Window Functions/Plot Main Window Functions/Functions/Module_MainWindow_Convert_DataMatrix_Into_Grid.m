function [PlotData,GridSpikeData] = Module_MainWindow_Convert_DataMatrix_Into_Grid(Info,DataForMatrix,PlotAppearance,SpikeData,WhatToDo,Channel_Selection,Type)

%________________________________________________________________________________________

%% Function used to take matrix data of a single time point like in surf or axon viewer plots and save that single value for each channel in a matrix preserving channel locations
% Same as Module_MainWindow_Convert_DataMatrix_Into_3DGrid just for a
% single data point!

% gets called in 
% Module_MainWindow_Plot_Data to prepare data for these plots

% Inputs: 
% 1. Info: main data metadata structure from Data.Info
% 2. DataForMatrix: channel by time points data matrix with data being
% 3. PlotAppearance: structure holding indo about the appearance of plots
% the user selected
% 4. SpikeData: cell array with dimension of probe design, holding spikes for
% each channel in spatially preserverd channel order.
% 5. WhatToDo: char, what to do, either "DataMatrix" to just get data
% matrix or "SpikeMatrix" to just get spike matrix
% Channel_Selection: vector with data amtrix indicies that are selected to
% be plotted by user

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

PlotData = [];
GridSpikeData = [];

%% Create Data Matrix
if strcmp(WhatToDo,"DataMatrix")
    PlotData = nan(numel(unique(Info.ProbeInfo.ycoords)), numel(unique(Info.ProbeInfo.xcoords)));

    LaufVariable = 1;
    for ii = 1:numel(unique(Info.ProbeInfo.ycoords))
        for jj = 1:numel(unique(Info.ProbeInfo.xcoords))
            [TempLaufVariable] = Organize_Convert_ActiveChannel_to_DataChannel(Info.ProbeInfo.ActiveChannel,LaufVariable,'MainPlot');
            if ~isempty(TempLaufVariable)
                if sum(TempLaufVariable == Channel_Selection)>0
                    PlotData(ii,jj) = (DataForMatrix(TempLaufVariable == Channel_Selection,1));
                end
            end
            LaufVariable = LaufVariable + 1;
        end
    end
elseif strcmp(WhatToDo,"SpikeMatrix")
    %% Create Spike Matrix
    GridSpikeData = SpikeData;
    LaufVariable = 1;
    if ~isempty(SpikeData.Indicie)
        GridSpikeData.Position = zeros(numel(unique(Info.ProbeInfo.ycoords)), numel(unique(Info.ProbeInfo.xcoords)));
        GridSpikeData.Indicie = [];
        for ii = 1:numel(unique(Info.ProbeInfo.ycoords))
            for jj = 1:numel(unique(Info.ProbeInfo.xcoords))
                if sum(LaufVariable == Info.ProbeInfo.ActiveChannel)>0
                    [TempLaufVariable] = Organize_Convert_ActiveChannel_to_DataChannel(Info.ProbeInfo.ActiveChannel,LaufVariable,'MainPlot');
                    if sum(LaufVariable == SpikeData.Position)>0
                        %[TempLaufVariable] = Organize_Convert_ActiveChannel_to_DataChannel(Info.ProbeInfo.ActiveChannel,LaufVariable,'MainPlot');
                        GridSpikeData.Position(ii,jj) = 1;
                        GridSpikeData.Indicie = [GridSpikeData.Indicie,1];
                    end
                end
                LaufVariable = LaufVariable + 1;
            end
        end
    end
end