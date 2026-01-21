function [Spike_GridDataT1,Spike_GridDataT2] = Module_MainWindow_Detect_and_Add_Spikes(GridData,Info)

% griddata: probecolumns x proberows cell array, each cell containing a
% signal in the main window time range

Spike_GridDataT1 = zeros(size(GridData));
Spike_GridDataT2 = zeros(size(GridData));

% 1. High Threshold --> all 0 except of biiiig spikes
LaufVariable = 1;
LaufVariableChannel = 1;
for ncolumns = 1:size(GridData,1)
    for nrows = 1:size(GridData,2)
        if sum(LaufVariable==Info.ProbeInfo.ActiveChannel)
            if sum(isnan(GridData{ncolumns,nrows}))==0

                Threshold = Info.HighPassStatistics.Mean(LaufVariableChannel) - (3 * Info.HighPassStatistics.Std(LaufVariableChannel));
                
                ChunkSize1 = ceil(numel(GridData{ncolumns,nrows})/2);
                CurrentChunkT1 = GridData{ncolumns,nrows}(1:ChunkSize1);
                IndiciesBelowThresholdT1 = CurrentChunkT1<Threshold;
            
                if sum(IndiciesBelowThresholdT1)>0 % spikes found, no matter how many
                    % step 1 -- threshold ones
                    %ChannelWithSpikes = [ChannelWithSpikes,ncolumns];
                    SpikeWaveformMinimum = min(CurrentChunkT1(IndiciesBelowThresholdT1)); % take min waveform --> take max amplitude
                    
                    Spike_GridDataT1(ncolumns,nrows) = SpikeWaveformMinimum;
                    % step 2 look at indicie
                end
                
                CurrentChunkT2 = GridData{ncolumns,nrows}(ChunkSize1+1:end);
                IndiciesBelowThresholdT2 = CurrentChunkT2<Threshold;
            
                if sum(IndiciesBelowThresholdT2)>0 % spikes found, no matter how many
                    % step 1 -- threshold ones
                    %ChannelWithSpikes = [ChannelWithSpikes,ncolumns];
                    SpikeWaveformMinimum = min(CurrentChunkT2(IndiciesBelowThresholdT2)); % take min waveform --> take max amplitude
                    
                    Spike_GridDataT2(ncolumns,nrows) = SpikeWaveformMinimum;
                    % step 2 look at indicie
                end
            end
            LaufVariableChannel = LaufVariableChannel + 1;
        end
        LaufVariable = LaufVariable + 1; 
    end
end

% 2 take next datapoint 
%pcolor(Figure,Spike_GridData);
