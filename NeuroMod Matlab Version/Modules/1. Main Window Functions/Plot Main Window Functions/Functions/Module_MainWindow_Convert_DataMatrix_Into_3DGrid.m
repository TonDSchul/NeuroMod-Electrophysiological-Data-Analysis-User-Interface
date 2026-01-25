function [PlotData,TimeToPlot]= Module_MainWindow_Convert_DataMatrix_Into_3DGrid(Data,DataForMatrix,TimeToPlot,ActiveDataChannel,PreservePlotChannelLocations)

if PreservePlotChannelLocations
    NumChannel = length(unique(Data.Info.ProbeInfo.ycoords(Data.Info.ProbeInfo.ActiveChannel(1):Data.Info.ProbeInfo.ActiveChannel(end))));
else
    NumChannel = length(unique(Data.Info.ProbeInfo.ycoords(Data.Info.ProbeInfo.ActiveChannel)));
end

NumRows = length(unique(Data.Info.ProbeInfo.xcoords));

PlotData = cell(NumChannel, NumRows);

if PreservePlotChannelLocations
    if Data.Info.ProbeInfo.ActiveChannel(1)-1 ~=0
        ActiveDataChannel = ActiveDataChannel - Data.Info.ProbeInfo.ActiveChannel(1)-1;
    end
else
    [ActiveDataChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveDataChannel,'MainPlot');
end

if ~PreservePlotChannelLocations
    if str2double(Data.Info.ProbeInfo.NrRows) == 2
        % find gapos in active channel
        d = diff(Data.Info.ProbeInfo.ActiveChannel);
        breakIdx = find(d > 1);
        run_start = [1, breakIdx + 1];
        run_end   = [breakIdx, numel(Data.Info.ProbeInfo.ActiveChannel)];
        %gap_start_val = (Data.Info.ProbeInfo.ActiveChannel(run_end(1:end-1)) + 1) ;
        gap_end_val   = (Data.Info.ProbeInfo.ActiveChannel(run_start(2:end)) - 1) ;
    
        for iii = 1:length(gap_end_val)
            if mod(gap_end_val(iii),2)==1 % uneven
                activeindicie = Data.Info.ProbeInfo.ActiveChannel == gap_end_val(iii)+1;
                IndicieToNotPlot = find(activeindicie==1);
                ActiveDataChannel(ActiveDataChannel>=gap_end_val(iii)+1) = ActiveDataChannel(ActiveDataChannel>=gap_end_val(iii)+1)+1;
            else
    
            end
        end
    end
end

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

