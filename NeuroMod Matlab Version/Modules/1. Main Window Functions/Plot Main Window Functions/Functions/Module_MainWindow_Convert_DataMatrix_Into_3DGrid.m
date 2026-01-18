function [PlotData,TimeToPlot]= Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Data,DataForMatrix,TimeToPlot,ActiveDataChannel)

%% If show data trails take the sum over specific number of time points
NumRows = length(unique(Data.Info.ProbeInfo.xcoords));
NumChannel = length(unique(Data.Info.ProbeInfo.ycoords));

PlotData = cell(NumChannel, NumRows);

DataLaufVariable = 1;
LaufVariable = 1;
for nchannel = 1:NumChannel
    for nrows = 1:NumRows
        if sum(LaufVariable==ActiveDataChannel)>0
            PlotData{nchannel,nrows} = DataForMatrix(DataLaufVariable,:);
            DataLaufVariable = DataLaufVariable+1;
        end
        LaufVariable = LaufVariable + 1;
    end
    
end

