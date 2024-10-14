function [CurrentPlotData] = Event_Analyse_Static_Power_Spectrum(Data,Figure,DataType,DataSource,SelectedChannel,ChannelText,FrequencyRangeHzEditField,CurrentPlotData,PlotAppearance,SelectedEvents)
%________________________________________________________________________________________

%% Function to compute static power spectrum of event related data using pwelch method
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
% 10. SelectedEvents: 1 x 2 double holding events user seleted, i.e. [1,10]
% for events 1 to 10 

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% First calculate ERP over events when multiple events selected
if SelectedEvents(1) ~= SelectedEvents(2) %--> mean over events if multiple selected
    if strcmp(DataSource,"Raw Event Related Data")
        DataToAnalyse = squeeze(mean(Data.EventRelatedData(:,SelectedEvents(1):SelectedEvents(2),:),2));
        
        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    else
        DataToAnalyse = squeeze(mean(Data.PreprocessedEventRelatedData(:,SelectedEvents(1):SelectedEvents(2),:),2));

        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    end
else % If same event --> no mean
    if strcmp(DataSource,"Raw Event Related Data")
        DataToAnalyse = squeeze(Data.EventRelatedData(:,SelectedEvents(1),:));
        
        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    else
        DataToAnalyse = squeeze(Data.PreprocessedEventRelatedData(:,SelectedEvents(1),:));

        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    end
end

%% Compute Spectrum using pwelch

if strcmp(DataSource,"Raw Event Related Data")
    NonNaN = ~isnan(DataToAnalyse);
     if isfield(Data.Info, 'DownsampleFactor')
        [Welchpowspect,Freq] = pwelch(double(DataToAnalyse(NonNaN)),[],[],[],Data.Info.DownsampledSampleRate);
    else
        [Welchpowspect,Freq] = pwelch(double(DataToAnalyse(NonNaN)),[],[],[],Data.Info.NativeSamplingRate);
     end
end

if strcmp(DataType,"Channel Individually")
    titlestring = strcat("Power Spectral Density Channel ",ChannelText);
else
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
    semilogy(Figure,Freq(DispIndicies),10*log10(Welchpowspect(DispIndicies)),'LineWidth',PlotAppearance.SpectrumWindow.Data.SpectrumLinwWidth,'Tag','Pwelch','Color',PlotAppearance.SpectrumWindow.Data.SpectrumColor);
end

xlabel(Figure, PlotAppearance.SpectrumWindow.Data.TimeXLabel);
ylabel(Figure, PlotAppearance.SpectrumWindow.Data.TimeYLabel);
ylim(Figure,[min(10*log10(Welchpowspect(DispIndicies)),[],'all') max(10*log10(Welchpowspect(DispIndicies)),[],'all')])

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

