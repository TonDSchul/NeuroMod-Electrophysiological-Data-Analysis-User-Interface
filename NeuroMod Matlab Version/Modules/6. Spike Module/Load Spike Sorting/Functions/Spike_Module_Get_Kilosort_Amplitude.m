function Data = Spike_Module_Get_Kilosort_Amplitude(Data)

%________________________________________________________________________________________
%% Function to get the amplitude of ech spike detected by kilosort at the spike channel and time point detected by the sorter
% this is because kilosort works with ints that have to be converted back
% to mV which is not given (only if saved data for kilosort with this gui)

% Input Arguments:
% 1. Data: Main window data struc

% Output Arguments:
% 1. Data: Main window data struc with modified Data.Spikes.SpikeAmps 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%ensure no 0 indexing
if min(Data.Spikes.SpikeChannel)==0
    Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel + 1;
end

TempSpikeAmps = zeros(size(Data.Spikes.SpikeTimes));

if isfield(Data,'Preprocessed')
    for i = 1:size(Data.Raw,1)
        CurrentIndices = Data.Spikes.SpikeChannel == Data.Info.ProbeInfo.ActiveChannel(i);
        TempSpikeAmps(CurrentIndices) = Data.Preprocessed(i,Data.Spikes.SpikeTimes(CurrentIndices));
    end
else
    for i = 1:size(Data.Raw,1)
        CurrentIndices = Data.Spikes.SpikeChannel == Data.Info.ProbeInfo.ActiveChannel(i);
        TempSpikeAmps(CurrentIndices) = Data.Raw(i,Data.Spikes.SpikeTimes(CurrentIndices));
    end
end

Data.Spikes.SpikeAmps = TempSpikeAmps;