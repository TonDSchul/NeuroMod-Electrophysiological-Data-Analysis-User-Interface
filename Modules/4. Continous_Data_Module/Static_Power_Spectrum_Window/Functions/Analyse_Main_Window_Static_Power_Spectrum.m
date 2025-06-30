function [CurrentPlotData] = Analyse_Main_Window_Static_Power_Spectrum(Data,Figure,DataType,DataSource,SelectedChannel,ChannelText,FrequencyRangeHzEditField,CurrentPlotData,PlotAppearance,WindowSize,UseCostumeWindowSize)
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
% 5: SelectedChannel: 1x2 double with channel over which pwelch is computed
% (when no mean over channel selected). [Start Channel, Stop Channel] = all
% channel from Start Channel to Stop Channel
% 6: ChannelText: String which channel is analyzed -- only if power
% spectrum over individual channel
% 7. FrequencyRangeHzEditField: char, holding frequency range user
% specified in Hz. Format: '1,100' for 1 to 100 Hz
% 8. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 9. PlotAppearance: structure holding current default of plot appearances
% like linewidth
% 10. WindowSize: char from editfield, window size for Pwelch
% Outputs:
% 11. UseCostumeWindowSize: logical 1 or 0, whether costume window size
% should be applied

% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if ~isempty(WindowSize)
    if UseCostumeWindowSize == 1
        WindowSize = str2double(WindowSize);
    else
        WindowSize = [];
    end
else
    WindowSize = [];
end

%% Compute Spectrum using pwelch
if strcmp(DataType,"Channel Individually")
    if strcmp(DataSource,"Raw Data")
        NonNaN = ~isnan(Data.Raw);
        [Welchpowspect,Freq] = pwelch(double(Data.Raw(SelectedChannel,NonNaN(SelectedChannel,:))),WindowSize,[],[],Data.Info.NativeSamplingRate);
    elseif strcmp(DataSource,"Preprocessed Data")
        NonNaN = ~isnan(Data.Preprocessed);
        if isfield(Data.Info, 'DownsampleFactor')
            [Welchpowspect,Freq] = pwelch(double(Data.Preprocessed(SelectedChannel,NonNaN(SelectedChannel,:))),WindowSize,[],[],Data.Info.DownsampledSampleRate);
        else
            [Welchpowspect,Freq] = pwelch(double(Data.Preprocessed(SelectedChannel,NonNaN(SelectedChannel,:))),WindowSize,[],[],Data.Info.NativeSamplingRate);
        end
    end
    titlestring = strcat("Power Spectral Density Channel ",ChannelText);
elseif strcmp(DataType,"Mean over all Channel")  
    if strcmp(DataSource,"Raw Data")
        MeanOverChannel = mean(Data.Raw,1,'omitnan');
        NonNaN = ~isnan(MeanOverChannel);
        [Welchpowspect,Freq] = pwelch(double(MeanOverChannel(NonNaN)),WindowSize,[],[],Data.Info.NativeSamplingRate);
    elseif strcmp(DataSource,"Preprocessed Data")
        MeanOverChannel = mean(Data.Preprocessed,1,'omitnan');
        NonNaN = ~isnan(MeanOverChannel);
        if isfield(Data.Info, 'DownsampleFactor')
            [Welchpowspect,Freq] = pwelch(double(MeanOverChannel(NonNaN)),WindowSize,[],[],Data.Info.DownsampledSampleRate);
        else
            [Welchpowspect,Freq] = pwelch(double(MeanOverChannel(NonNaN)),WindowSize,[],[],Data.Info.NativeSamplingRate);
        end
    end
    titlestring = strcat("Power Spectral Density Mean over Channel");
end

PWelch_handles = findobj(Figure,'Type', 'line', 'Tag', 'Pwelch');

if length(PWelch_handles) > 1
    delete(PWelch_handles(2:end));
    PWelch_handles = findobj(Figure,'Type', 'line', 'Tag', 'Pwelch');
end

commaindicie = find(FrequencyRangeHzEditField == ',');
dispRange(1) = str2double(FrequencyRangeHzEditField(1:commaindicie(1)-1)); % Hz
dispRange(2) = str2double(FrequencyRangeHzEditField(commaindicie(1)+1:end)); % Hz
DispIndicies = Freq>dispRange(1) & Freq<dispRange(2);

%Welch Method
if ~isempty(PWelch_handles)
    set(PWelch_handles(1), 'XData', Freq(DispIndicies), 'YData', 10*log10(Welchpowspect(DispIndicies)),'LineWidth',PlotAppearance.SpectrumWindow.Data.SpectrumLinwWidth,'Tag','Pwelch','Color',PlotAppearance.SpectrumWindow.Data.SpectrumColor);
else
    %semilogy(Figure,Freq(DispIndicies),10*log10(Welchpowspect(DispIndicies)),'LineWidth',PlotAppearance.SpectrumWindow.Data.SpectrumLinwWidth,'Tag','Pwelch','Color',PlotAppearance.SpectrumWindow.Data.SpectrumColor);
    line(Figure,Freq(DispIndicies),10*log10(Welchpowspect(DispIndicies)),'LineWidth',PlotAppearance.SpectrumWindow.Data.SpectrumLinwWidth,'Tag','Pwelch','Color',PlotAppearance.SpectrumWindow.Data.SpectrumColor);
end

xlabel(Figure, PlotAppearance.SpectrumWindow.Data.TimeXLabel);
ylabel(Figure, PlotAppearance.SpectrumWindow.Data.TimeYLabel);
if min(10*log10(Welchpowspect(DispIndicies)),[],'all') ~= max(10*log10(Welchpowspect(DispIndicies)),[],'all')
    ylim(Figure,[min(10*log10(Welchpowspect(DispIndicies)),[],'all') max(10*log10(Welchpowspect(DispIndicies)),[],'all')])
end
view(Figure,0,90);
xlim(Figure,[dispRange(1) dispRange(2)]);
title(Figure,titlestring);
Figure.FontSize = 10;
grid(Figure, 'on');
drawnow;
hold(Figure, 'off' );

%% save plotted data in case user wants to save 
CurrentPlotData.XData = Freq(DispIndicies)';
CurrentPlotData.YData = 10*log10(Welchpowspect(DispIndicies))';
CurrentPlotData.CData = [];
CurrentPlotData.Type = "Static P-Welch Spectrum";
CurrentPlotData.XTicks = Figure.XTickLabel;

