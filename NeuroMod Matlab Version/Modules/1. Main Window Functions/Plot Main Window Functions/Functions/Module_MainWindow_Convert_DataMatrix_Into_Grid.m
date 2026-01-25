function [PlotData,GridSpikeData]= Module_MainWindow_Convert_DataMatrix_Into_Grid(Info,DataForMatrix,PlotAppearance,SpikeData,DataType,Channel_Selection,Type)

PlotData = [];
GridSpikeData = [];

%% Create Data Matrix
if strcmp(DataType,"DataMatrix")
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
elseif strcmp(DataType,"SpikeMatrix")
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