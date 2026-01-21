function [Thresh_GridData,PreviousThreshGridsNoNeighbour,PreviousThreshGridsWithNeighbour] = Module_MainWindow_Axon_Viewer(GridData,Info,PreviousThreshGridsNoNeighbour,PreviousThreshGridsWithNeighbour,PlotMode,PlotAppearance)

Thresh_GridData = zeros(size(GridData));
%
%% 1. High Threshold --> all 0 except of spikes
LaufVariable = 1;
LaufVariableChannel = 1;
for ncolumns = 1:size(GridData,1)
    for nrows = 1:size(GridData,2)
        if sum(LaufVariable==Info.ProbeInfo.ActiveChannel)
            if sum(isnan(GridData(ncolumns,nrows)))==0

                Threshold = Info.HighPassStatistics.Mean - (PlotAppearance.MainWindow.Data.AxonViewerSpikeThreshold * Info.HighPassStatistics.Std);
                
                IndiciesBelowThresholdT1 = GridData(ncolumns,nrows)<Threshold;
            
                if sum(IndiciesBelowThresholdT1)>0 % spikes found, no matter how many
                    SpikeWaveformMinimum = abs(GridData(ncolumns,nrows)); % take min waveform --> take max amplitude
                    
                    Thresh_GridData(ncolumns,nrows) = SpikeWaveformMinimum;
                end
            end
            LaufVariableChannel = LaufVariableChannel + 1;
        end
        LaufVariable = LaufVariable + 1; 
    end
end

%% fill previous grids cells no neighbourhood
if strcmp(PlotMode,"Movie")
    if isempty(PreviousThreshGridsNoNeighbour)
        PreviousThreshGridsNoNeighbour{1} = Thresh_GridData;
    else
        if length(PreviousThreshGridsNoNeighbour) <= PlotAppearance.MainWindow.Data.AxonViewerPastSampleToSum
            PreviousThreshGridsNoNeighbour{end+1} = Thresh_GridData;
        else
            % If already all samples collected: delete the first one
            % (longest ago) and add the most recent one as last
            PreviousThreshGridsNoNeighbour(1)=[];
            PreviousThreshGridsNoNeighbour{end+1} = Thresh_GridData;
        end
    end
end

%% check for neighbourhood
if ~isempty(PreviousThreshGridsNoNeighbour)
    conn = strel('square',3);   % 8-connected neighborhood
 
    PrevMask = false(size(Thresh_GridData));
    
    for k = 1:numel(PreviousThreshGridsNoNeighbour)
        PrevMask = PrevMask | (PreviousThreshGridsNoNeighbour{k} ~= 0);
    end

    PrevMaskDilated = imdilate(PrevMask, conn);

    Unsupported = (Thresh_GridData ~= 0) & ~PrevMaskDilated;
    Thresh_GridData(Unsupported) = 0;
end

%% fill previous grids cells with neighbourhood
if strcmp(PlotMode,"Movie")
    if isempty(PreviousThreshGridsWithNeighbour)
        PreviousThreshGridsWithNeighbour{1} = Thresh_GridData;
    else
        if length(PreviousThreshGridsWithNeighbour) <= PlotAppearance.MainWindow.Data.AxonViewerPastSampleToSum
            PreviousThreshGridsWithNeighbour{end+1} = Thresh_GridData;
        else
            % If already all samples collected: delete the first one
            % (longest ago) and add the most recent one as last
            PreviousThreshGridsWithNeighbour(1)=[];
            PreviousThreshGridsWithNeighbour{end+1} = Thresh_GridData;
        end
    end
end

%% Sum over past results
if strcmp(PlotMode,"Movie")
     % sum over previous grids to visualize a 'tail'
    if ~isempty(PreviousThreshGridsWithNeighbour)
        for i = 1:length(PreviousThreshGridsWithNeighbour)
            if PlotAppearance.MainWindow.Data.AxonViewerAdditionalThreshold ~= 0
                if length(PreviousThreshGridsWithNeighbour) >= PlotAppearance.MainWindow.Data.AxonViewerPastSampleToSum
                    PreviousThreshGridsWithNeighbour{i}(PreviousThreshGridsWithNeighbour{i}<PlotAppearance.MainWindow.Data.AxonViewerAdditionalThreshold)=0;
                end
            end

            Thresh_GridData = Thresh_GridData + PreviousThreshGridsWithNeighbour{i};

            Thresh_GridData(Thresh_GridData>0.1)=0.1;
        end
    end
end

