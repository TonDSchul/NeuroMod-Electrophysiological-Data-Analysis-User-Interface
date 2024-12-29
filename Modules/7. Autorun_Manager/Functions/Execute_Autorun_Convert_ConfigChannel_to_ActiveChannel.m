function [AutorunConfig] = Execute_Autorun_Convert_ConfigChannel_to_ActiveChannel(AutorunConfig,ActiveChannel)

%% Function to convert channel from 1 to whatever how many channel you have to the actual active channel selected when extracting data

if ~isempty(AutorunConfig.ChannelRange)
    Ch = str2double(strsplit(AutorunConfig.ChannelRange,','));
end

% Cont. Power Spectrum
if ~isempty(AutorunConfig.ChannelRange)
    AutorunConfig.StaticPowerSpectrum.DepthChannel = ActiveChannel(Ch);
else
    AutorunConfig.StaticPowerSpectrum.DepthChannel = ActiveChannel;
end 

% Event. Power Spectrum
if ~isempty(AutorunConfig.ChannelRange)
    Ch = str2double(strsplit(AutorunConfig.ChannelRange,','));
    AutorunConfig.AnalyseEventDataModule.SpectrumDepthChannel = ActiveChannel(Ch);
else
    AutorunConfig.AnalyseEventDataModule.SpectrumDepthChannel = ActiveChannel;
end 

% Cont. Spikes
if ~isempty(AutorunConfig.ChannelRange)
    Ch = str2double(strsplit(AutorunConfig.ChannelRange,','));

    AutorunConfig.ContSpikeAnalysis.ChannelSelection = ActiveChannel(Ch);   
else
    AutorunConfig.ContSpikeAnalysis.ChannelSelection = ActiveChannel;
end
% Preprocess Event related Data Channel Rejection
if ~isempty(AutorunConfig.PreproEventDataModule.ChannelToReject)
    commaindidcie = find(AutorunConfig.PreproEventDataModule.ChannelToReject);
    Ch(1) = str2double(AutorunConfig.PreproEventDataModule.ChannelToReject(1:commaindidcie(1)));
    Ch(2) = str2double(AutorunConfig.PreproEventDataModule.ChannelToReject(commaindidcie(1)+1:end));

    AutorunConfig.PreproEventDataModule.ChannelToReject = [];
    AutorunConfig.PreproEventDataModule.ChannelToReject(1) = Ch(1);
    AutorunConfig.PreproEventDataModule.ChannelToReject(2) = Ch(2);
else
    AutorunConfig.PreproEventDataModule.ChannelToReject(1) = 1;
    AutorunConfig.PreproEventDataModule.ChannelToReject(2) = length(ActiveChannel);
end
% Preprocess Event related Data Artefact rejection channel
if ~isempty(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject)
    commaindidcie = find(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject);
    Ch(1) = str2double(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(1:commaindidcie(1)));
    Ch(2) = str2double(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(commaindidcie(1)+1:end));

    AutorunConfig.PreproEventDataModule.ArtefactChannelToReject = [];
    AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(1) = Ch(1);
    AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(2) = Ch(2);
else
    AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(1) = 1;
    AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(2) = length(ActiveChannel);
end
% Event LFP Analyse
if ~isempty(AutorunConfig.ChannelRange)
    Ch = str2double(strsplit(AutorunConfig.ChannelRange,','));
    
    AutorunConfig.AnalyseEventDataModule.ChannelSelection = [];
    AutorunConfig.AnalyseEventDataModule.ChannelSelection = Ch;
else
    AutorunConfig.AnalyseEventDataModule.ChannelSelection = 1:length(ActiveChannel);
end

AutorunConfig.AnalyseEventDataModule.SingleERPChannel = num2str(ActiveChannel(str2double(AutorunConfig.AnalyseEventDataModule.SingleERPChannel)));

% Event Spike Analyse
if ~isempty(AutorunConfig.ChannelRange)
    Ch = str2double(strsplit(AutorunConfig.ChannelRange,','));

    AutorunConfig.AnalyseEventSpikesModule.ChanneltoPlot = ActiveChannel(Ch); 
else
    AutorunConfig.AnalyseEventSpikesModule.ChanneltoPlot = ActiveChannel;
end