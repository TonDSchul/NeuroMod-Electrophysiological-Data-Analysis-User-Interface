function [CurrentPlotData] = Event_Analyse_Static_Power_Spectrum(Data,Figure,DataType,DataSource,SelectedChannel,ChannelText,FrequencyRangeHzEditField,CurrentPlotData,PlotAppearance,SelectedEvents,DataToExtractFrom,BaselineNormalize,NormalizationWindow)
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
% 11. DataToExtractFrom: char, either 'Raw Data' or 'Preprocessed Data' to
% designate from which dataset component event related data was extracted
% from
% 12. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 13. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if BaselineNormalize
    if strcmp(DataSource,"Raw Event Related Data")
        EventRelatedData = Event_Module_Baseline_Normalize(Data,Data.EventRelatedData,NormalizationWindow,Data.Info.EventRelatedTime,"StaticSpec");
    else
        EventRelatedData = Event_Module_Baseline_Normalize(Data,Data.PreprocessedEventRelatedData,NormalizationWindow,Data.Info.EventRelatedTime,"StaticSpec");
    end
else
    if strcmp(DataSource,"Raw Event Related Data")
        EventRelatedData = Data.EventRelatedData;
    else
        EventRelatedData = Data.PreprocessedEventRelatedData;
    end
end

%% First calculate ERP over events when multiple events selected
if length(SelectedEvents)>1 %--> mean over events if multiple selected
    if strcmp(DataSource,"Raw Event Related Data")
        DataToAnalyse = squeeze(mean(EventRelatedData(:,SelectedEvents,:),2));
        
        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    else
        DataToAnalyse = squeeze(mean(EventRelatedData(:,SelectedEvents,:),2));

        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    end
else % If same event --> no mean
    if strcmp(DataSource,"Raw Event Related Data")
        DataToAnalyse = squeeze(EventRelatedData(:,SelectedEvents,:));
        
        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    else
        DataToAnalyse = squeeze(EventRelatedData(:,SelectedEvents,:));

        if strcmp(DataType,"Channel Individually")
            DataToAnalyse = DataToAnalyse(SelectedChannel,:);
        else
            DataToAnalyse = mean(DataToAnalyse,1);
        end
    end
end

%% Compute Spectrum using pwelch

%if strcmp(DataSource,"Raw Event Related Data")
NonNaN = ~isnan(DataToAnalyse);
if isfield(Data.Info, 'DownsampleFactor') && strcmp(DataToExtractFrom,'Preprocessed Data')
    [Welchpowspect,Freq] = pwelch(double(DataToAnalyse(NonNaN)),[],[],[],Data.Info.DownsampledSampleRate);
else
    [Welchpowspect,Freq] = pwelch(double(DataToAnalyse(NonNaN)),[],[],[],Data.Info.NativeSamplingRate);
end
%end

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
    line(Figure,Freq(DispIndicies),10*log10(Welchpowspect(DispIndicies)),'LineWidth',PlotAppearance.SpectrumWindow.Data.SpectrumLinwWidth,'Tag','Pwelch','Color',PlotAppearance.SpectrumWindow.Data.SpectrumColor);
end

xlabel(Figure, PlotAppearance.SpectrumWindow.Data.TimeXLabel);
ylabel(Figure, PlotAppearance.SpectrumWindow.Data.TimeYLabel);
ylim(Figure,[min(10*log10(Welchpowspect(DispIndicies)),[],'all') max(10*log10(Welchpowspect(DispIndicies)),[],'all')])

Figure.FontSize = PlotAppearance.SpectrumWindow.Data.TimeFontSize;
Figure.Color = PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;

Figure.XLabel.Color = [0 0 0];
Figure.YLabel.Color = [0 0 0];       
Figure.YColor = 'k';  
%UIAxes.XTickLabelMode = 'auto';
Figure.XColor = 'k';  
Figure.Title.Color = 'k';  
Figure.Box ="off";
view(Figure,0,90);

xlim(Figure,[dispRange(1) dispRange(2)]);
title(Figure,titlestring);
Figure.FontSize = 10;
grid(Figure, 'on');
drawnow;
hold(Figure, 'off' );

%% save plotted data in case user wants to save 
CurrentPlotData.EventSpectrumXData = Freq(DispIndicies)';
CurrentPlotData.EventSpectrumYData = 10*log10(Welchpowspect(DispIndicies))';
CurrentPlotData.EventSpectrumType = strcat("Event Related Static P-Welch Spectrum Single Channel ",num2str(SelectedChannel));
CurrentPlotData.EventSpectrumXTicks = Figure.XTickLabel;

