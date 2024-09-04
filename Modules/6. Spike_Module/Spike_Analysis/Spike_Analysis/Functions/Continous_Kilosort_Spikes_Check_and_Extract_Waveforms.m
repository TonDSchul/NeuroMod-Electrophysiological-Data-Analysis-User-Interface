function [Data,TextArea] = Continous_Kilosort_Spikes_Check_and_Extract_Waveforms(Data,TextArea,SpikeTimes,SpikeClusters,PlotInfo)

%________________________________________________________________________________________
%% Function to extract waveforms of kilosort spikes from raw or preprocessed data
% This function is executed every time some continous kilosort spikes
% analysis containing waveforms is executed
% This function uses a functions from the spike repository from Nick
% Steinmetz on Github: https://github.com/cortex-lab/spikes
% Function used: getWaveForms

% Inputs:
% 1. Data: main window data structure with Data.Spikes , Data.Time and
% Data.Info
% 2. TextArea: app window text object to show number of cluster and spikes
% found
% 3. SpikeTimes: nspikes x 1 double in seconds
% 4. SpikeClusters: N x 1 double or single with cliuster identity (integer specifying the unit/cluster of that spike) of each spike
% (analyzed in internal spike detection) 
% 5. PlotInfo: 

%Output:
% 1. Data: main window data structure with added field
% Data.Spikes.Waveforms as Unit x waveforms x channel 
% 2. app window text object to show number of cluster and spikes
% found

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if ~isfield(Data.Spikes,'Waveforms')
    if isfield(Data,'Preprocessed') && ~isfield(Data.Info,'DownsampleFactor') && isfield(Data.Info,'FilterMethod')
        if strcmp(Data.Info.FilterMethod,"High-Pass")
            Data.Spikes.Waveforms = getWaveForms([40 41],TextArea,Data.Preprocessed(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
        else
            msgbox("Warning! No High Pass filtered Data found. Waveforms will be extracted from Raw Data which can screw with scaling and shape");
            Data.Spikes.Waveforms = getWaveForms([40 41],TextArea,Data.Raw(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
        end
    else
        msgbox("Warning! No High Pass filtered Data found. Waveforms will be extracted from Raw Data which can screw with scaling and shape");
        Data.Spikes.Waveforms = getWaveForms([40 41],TextArea,Data.Raw(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
    end

else % When Data is already there check if parameters (channel nr and waveform number) changed
    if isempty(Data.Spikes.Waveforms)
        if isfield(Data,'Preprocessed') && ~isfield(Data.Info,'DownsampleFactor') && isfield(Data.Info,'FilterMethod')
            if strcmp(Data.Info.FilterMethod,"High-Pass")
                Data.Spikes.Waveforms = getWaveForms([40 41],TextArea,Data.Preprocessed(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
            else
                msgbox("Warning! No High Pass filtered Data found. Waveforms will be extracted from Raw Data which can screw with scaling and shape");
                Data.Spikes.Waveforms = getWaveForms([40 41],TextArea,Data.Raw(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
            end
        else
            msgbox("Warning! No High Pass filtered Data found. Waveforms will be extracted from Raw Data which can screw with scaling and shape");
            Data.Spikes.Waveforms = getWaveForms([40 41],TextArea,Data.Raw(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
        end
        return;
    end

    ExtractAgain = 0;
    Channelextracted = size(Data.Spikes.Waveforms.waveForms,3);
    Waveformsextracted = size(Data.Spikes.Waveforms.waveForms,2);

    if Channelextracted ~= numel(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2))
        ExtractAgain = 1;
    elseif Waveformsextracted ~= numel(PlotInfo.Waveforms(1):PlotInfo.Waveforms(2))
        ExtractAgain = 1;
    end

    if ExtractAgain == 1
        if isfield(Data,'Preprocessed') && ~isfield(Data.Info,'DownsampleFactor') && isfield(Data.Info,'FilterMethod')
            if strcmp(Data.Info.FilterMethod,"High-Pass")
                Data.Spikes.Waveforms = getWaveForms([40,41],TextArea,Data.Preprocessed(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
            else
                msgbox("Warning! No High Pass filtered Data found. Waveforms will be extracted from Raw Data which can screw with scaling and shape");
                Data.Spikes.Waveforms = getWaveForms([40,41],TextArea,Data.Raw(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
            end
        else
            msgbox("Warning! No High Pass filtered Data found. Waveforms will be extracted from Raw Data which can screw with scaling and shape");
            Data.Spikes.Waveforms = getWaveForms([40,41],TextArea,Data.Raw(PlotInfo.ChannelSelection(1):PlotInfo.ChannelSelection(2),:),SpikeTimes,SpikeClusters,PlotInfo);
        end
    end

end