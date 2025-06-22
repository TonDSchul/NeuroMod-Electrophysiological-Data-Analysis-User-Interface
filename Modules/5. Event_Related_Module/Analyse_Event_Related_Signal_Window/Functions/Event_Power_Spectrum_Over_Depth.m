function [PowerSpecResults,BandPower,CurrentPlotData] = Event_Power_Spectrum_Over_Depth(Data,DataSource,BandPower,FrequencyRangeHzEditField,Figure,Figure_2,TextArea,WhattoPlot,TwoORThreeD,CurrentPlotData,SelectedEvents,ActiveChannel)
%________________________________________________________________________________________

%% Function to compute static power spectrum over probe depth for event related data
% This function contains and uses functions from the Spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes. 
% They are saved in: GUIPath/Modules/6.Spike_Module/Spike_Analysis/Modified_Spike_Repository and are modified to
% fit the purpose of this GUI
% Functions used from the Spike repository: 
% lfpBandPower
% plotLFPpower -- all modified for the purpose of this GUI

% NOTE: PowerSpecResults holds the results of the computations. Its not
% used here, bc computation for events is fast  enough to do it on the fly

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: DataSource: string which data to use to compute? Either "Raw Data" or "Preprocessed Data"
% 3: PowerSpecResults: structure, if already computed in current GUI instance: this is non empty and contains the results from the previous calculation.
% So the lengthy computation does not have to happen again and results can be plotted immediately
% 4: Bandpower: saves the current results from the computation for the
% plotting function (is not saved globaly)
% 5. FrequencyRangeHzEditField: char, holding frequency range user
% specified in Hz, Format: '1,100' for 1 to 100Hz
% 6. Figure: figure object to plot power over all frequencies
% 7. Figure_2: figure object to plot bandpower over low frequency ranges on the
% right
% 8. TextArea: app text are to display info in (progress of computing power
% over depth), can be empty if used outside of GUI
% 9. WhattoPlot: string, specifies which of the both plots should be
% plotted; "All" for power over all frequencies and bandpower of low frequency
% parts OR "Just Bandpower" for just bandpower of low frequency
% parts
% 10. TwoORThreeD: string, "TwoD" to show 2D plots OR "ThreeD" to show 3
% dimensional plots
% 11. CurrentPlotData: structure saving results to export.
% 12. SelectedEvents: 1 x 2 double holding events user seleted, i.e. [1,10]
% for events 1 to 10 

% Outputs:
% 1. PowerSpecResults: always empty here
% 2. BandPower: Current analysis results. Replaced by PowerSpecResults if
% already computed
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% First calculate ERP over events when multiple events selected
if length(SelectedEvents) > 1 %--> mean over events if multiple selected
    if strcmp(DataSource,"Raw Event Related Data")
        DataToAnalyse = squeeze(mean(Data.EventRelatedData(:,SelectedEvents,:),2)); 
    else
        DataToAnalyse = squeeze(mean(Data.PreprocessedEventRelatedData(:,SelectedEvents,:),2));
    end
else % If same event --> no mean
    if strcmp(DataSource,"Raw Event Related Data")
        DataToAnalyse = squeeze(Data.EventRelatedData(:,SelectedEvents(1),:));
    else
        DataToAnalyse = squeeze(Data.PreprocessedEventRelatedData(:,SelectedEvents(1),:));
    end
end

%% Compute Spectrum over Depth 
if strcmp(Data.Info.EventRelatedDataType,"Raw")
    nChansInFile = size(DataToAnalyse,1);  
    [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
    lfpBandPower([], Data.Info.NativeSamplingRate, nChansInFile, [], DataToAnalyse,TextArea);
    BandPower.allPowerEst = BandPower.allPowerEst';
    BandPower.marginalChans = 1;
    BandPower.freqBands = {[1.5 4], [4 10], [10 30], [30 80], [80 200]};
elseif strcmp(Data.Info.EventRelatedDataType,"Preprocessed")
    nChansInFile = size(DataToAnalyse,1);  
    if ~isfield(Data.Info,'DownsampleFactor')
        [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
        lfpBandPower([], Data.Info.NativeSamplingRate, nChansInFile, [], DataToAnalyse,TextArea);
    else
        [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
        lfpBandPower([], Data.Info.DownsampledSampleRate, nChansInFile, [], DataToAnalyse,TextArea);
    end
    BandPower.allPowerEst = BandPower.allPowerEst';
    BandPower.marginalChans = 1;
    BandPower.freqBands = {[1.5 4], [4 10], [10 30], [30 80], [80 200]};
end

%% Save Check point for Main GUI --- not for events, fast enough to do it on the fly
PowerSpecResults = [];

%% plot LFP power over specific bands and over depth
commaindicie = find(FrequencyRangeHzEditField == ',');
dispRange(1) = str2double(FrequencyRangeHzEditField(1:commaindicie(1)-1)); % Hz
dispRange(2) = str2double(FrequencyRangeHzEditField(commaindicie(1)+1:end)); % Hz

[ActiveChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainWindow');

BPEstimate = BandPower.allPowerEst(ActiveChannel,:);

Figure_2.NextPlot = "add";
Figure_2.FontSize = 10;
Figure.FontSize = 10;
plotLFPpower(BandPower.F, BPEstimate, dispRange, BandPower.marginalChans, BandPower.freqBands, Figure, Figure_2, WhattoPlot,Data.Info.ChannelSpacing,TwoORThreeD);

%% save plotted data in case user wants to save 
dispF = BandPower.F>dispRange(1) & BandPower.F<=dispRange(2);
nC = size(BandPower.allPowerEst,1); 

CurrentPlotData.XData = BandPower.F(dispF)';
CurrentPlotData.YData = (0:nC-1)*Data.Info.ChannelSpacing;
CurrentPlotData.CData = 10*log10(BandPower.allPowerEst(:,dispF))';
CurrentPlotData.Type = "Power Spectrum over Depth";
CurrentPlotData.XTicks = Figure.XTickLabel';