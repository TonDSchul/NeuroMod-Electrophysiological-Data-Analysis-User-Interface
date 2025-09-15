function [AutorunConfig] = Execute_Autorun_Convert_ConfigChannel_to_ActiveChannel(AutorunConfig,ActiveChannel)

%________________________________________________________________________________________
%% Function to convert the channel selection in the autorun config into active channel for further analysis

% This function is called in the Execute_Autorun_Config_Template function
% in the Manage Dataset Module Functions

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. ActiveChannel: 1 x n double with all active channel defined in the
% probe information (Data.Info.ProbeInfo.ActiveChannel)

% Outputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected -- channel info for individual
% analysis parts where added and converted.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

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
if ~isempty(AutorunConfig.PreproEventDataModule.ChannelToInterpolate) && AutorunConfig.PreproEventDataModule.ChannelInterpolation == true
    commaindidcie = find(AutorunConfig.PreproEventDataModule.ChannelToInterpolate);
    Ch(1) = str2double(AutorunConfig.PreproEventDataModule.ChannelToInterpolate(1:commaindidcie(1)));
    Ch(2) = str2double(AutorunConfig.PreproEventDataModule.ChannelToInterpolate(commaindidcie(1)+1:end));

    AutorunConfig.PreproEventDataModule.ChannelToInterpolate = [];
    AutorunConfig.PreproEventDataModule.ChannelToInterpolate(1) = Ch(1);
    AutorunConfig.PreproEventDataModule.ChannelToInterpolate(2) = Ch(2);
else
    AutorunConfig.PreproEventDataModule.ChannelToInterpolate(1) = 1;
    AutorunConfig.PreproEventDataModule.ChannelToInterpolate(2) = length(ActiveChannel);
end
% % Preprocess Event related Data Artefact rejection channel
% if ~isempty(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject)
%     commaindidcie = find(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject);
%     Ch(1) = str2double(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(1:commaindidcie(1)));
%     Ch(2) = str2double(AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(commaindidcie(1)+1:end));
% 
%     AutorunConfig.PreproEventDataModule.ArtefactChannelToReject = [];
%     AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(1) = Ch(1);
%     AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(2) = Ch(2);
% else
%     AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(1) = 1;
%     AutorunConfig.PreproEventDataModule.ArtefactChannelToReject(2) = length(ActiveChannel);
% end
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