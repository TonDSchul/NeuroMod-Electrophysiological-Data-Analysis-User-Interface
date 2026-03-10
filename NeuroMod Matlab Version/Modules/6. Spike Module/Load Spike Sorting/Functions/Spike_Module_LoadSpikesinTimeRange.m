function Data = Spike_Module_LoadSpikesinTimeRange(Data,LoadSpikesinTimeRange)

%________________________________________________________________________________________

%% Function to only keep spike information of spikes withinn specified time range
% called in function to load spikeinterface and kilosort sorting results :
% Spike_Module_Load_Kilosort_Data and Spike_Module_Load_SpikeInterface_Sorter

% Input:
% 1. Data = structure containing all data. Data.Spikes is modified
% 2. LoadSpikesinTimeRange: char, comma separated number with time range to
% extract spikes from if sorting results are for concatonated recordings

% Output:
% 1. Data structure of toolbox with modified field: Data.Spikes, 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


if isempty(LoadSpikesinTimeRange)
    return;
end

LoadSpikesinTimeRange = str2double(strsplit(LoadSpikesinTimeRange,','));

TimeRange(1) = round(LoadSpikesinTimeRange(1)*Data.Info.NativeSamplingRate);
TimeRange(2) = round(LoadSpikesinTimeRange(2)*Data.Info.NativeSamplingRate);

DeleteIndicies = Data.Spikes.SpikeTimes<TimeRange(1) | Data.Spikes.SpikeTimes>TimeRange(2);

if ~isempty(DeleteIndicies) 
    Data.Spikes.SpikeTimes(DeleteIndicies==1) = [];
    Data.Spikes.SpikePositions(DeleteIndicies==1,:) = [];
    Data.Spikes.SpikeAmps(DeleteIndicies==1) = [];
    Data.Spikes.SpikeChannel(DeleteIndicies==1) = [];
    Data.Spikes.SpikeCluster(DeleteIndicies==1) = [];
    Data.Spikes.SpikeTemplates(DeleteIndicies==1) = [];
end

% notmalize time to 0
if TimeRange(1) ~= 0
    Data.Spikes.SpikeTimes = Data.Spikes.SpikeTimes - (TimeRange(1)-1);
end

disp(strcat("Only extracted spikes in time range ",num2str(LoadSpikesinTimeRange)))