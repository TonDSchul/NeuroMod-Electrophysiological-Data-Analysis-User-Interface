function Analyse_Main_Window_Static_Power_Spectrum(Data,Figure,DataType,DataSource,SelectedChannel,ChannelText)
%________________________________________________________________________________________

%% Function to compute static power spectrum of a signal using pwelch method
% This function organizes data based on GUI inputs, puts them into the
% matlab pwelch function and plots the results. This is plotted at standard
% whenever the power spectrum analysis window is opened

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: Figure: axes handle of a figure to plot results in
% 3: DataType: Char that specifies how data is processed before pwelch.
% Options: "Channel Individually" OR "Mean over all Channel"
% 4: DataSource: string which data to use to compute? Either "Raw Data" or "Preprocessed Data"
% 5: SelectedChannel: 1X2 double with channel over which pwelch is computed
% (when no mean over channel selected). [Start Channel, Stop Channel] = all
% channel from Start Channel to Stop Channel
% 6: ChannelText: String which channel is analyzed -- only if power
% spectrum over individual channel

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Compute Spectrum using pwelch
if strcmp(DataType,"Channel Individually")
    if strcmp(DataSource,"Raw Data")
        [Welchpowspect,Freq] = pwelch(double(Data.Raw(SelectedChannel,:)),[],[],[],Data.Info.NativeSamplingRate);
    elseif strcmp(DataSource,"Preprocessed Data")
        if isfield(Data.Info, 'DownsampleFactor')
            [Welchpowspect,Freq] = pwelch(double(Data.Preprocessed(SelectedChannel,:)),[],[],[],Data.Info.NativeSamplingRate/Data.Info.DownsampleFactor);
        else
            [Welchpowspect,Freq] = pwelch(double(Data.Preprocessed(SelectedChannel,:)),[],[],[],Data.Info.NativeSamplingRate);
        end
    end
    titlestring = strcat("Power Spectral Density Channel ",ChannelText);
elseif strcmp(DataType,"Mean over all Channel")  
    if strcmp(DataSource,"Raw Data")
        MeanOverChannel = mean(Data.Raw,1);
        [Welchpowspect,Freq] = pwelch(double(MeanOverChannel),[],[],[],Data.Info.NativeSamplingRate);
    elseif strcmp(DataSource,"Preprocessed Data")
        MeanOverChannel = mean(Data.Preprocessed,1);
        if isfield(Data.Info, 'DownsampleFactor')
            [Welchpowspect,Freq] = pwelch(double(MeanOverChannel),[],[],[],Data.Info.NativeSamplingRate/Data.Info.DownsampleFactor);
        else
            [Welchpowspect,Freq] = pwelch(double(MeanOverChannel),[],[],[],Data.Info.NativeSamplingRate);
        end
    end
    titlestring = strcat("Power Spectral Density Mean over Channel");
end

PWelch_handles = findobj(Figure,'Type', 'line', 'Tag', 'Pwelch');

if length(PWelch_handles) > 1
    delete(PWelch_handles(2:end));
    PWelch_handles = findobj(Figure,'Type', 'line', 'Tag', 'Pwelch');
end

%Welch Method
if ~isempty(PWelch_handles)
    set(PWelch_handles(1), 'XData', Freq, 'YData', 10*log10(Welchpowspect),'LineWidth',2,'Tag','Pwelch');
else
    line(Figure,Freq,10*log10(Welchpowspect),'LineWidth',2,'Tag','Pwelch');
end

xlabel(Figure, 'Frequency (Hz)');
ylabel(Figure, 'Power/Frequency (dB/Hz)');
ylim(Figure,[min(10*log10(Welchpowspect),[],'all') max(10*log10(Welchpowspect),[],'all')])
xlim(Figure,[min(Freq) max(Freq)]);
title(Figure,titlestring);
drawnow;
hold(Figure, 'off' );