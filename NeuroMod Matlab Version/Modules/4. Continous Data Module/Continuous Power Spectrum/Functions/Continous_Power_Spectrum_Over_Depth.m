function [PowerSpecResults,BandPower,CurrentPlotData] = Continous_Power_Spectrum_Over_Depth(Data,DataSource,PowerSpecResults,BandPower,FrequencyRangeHzEditField,Figure,Figure_2,TextArea,WhattoPlot,TwoORThreeD,CurrentPlotData,ActiveChannel,PlotAppearance)
%________________________________________________________________________________________

%% Function to compute static power spectrum over probe depth
% This function contains and uses functions from the Spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes. 
% They are saved in: GUIPath/Modules/6.Spike_Module/Spike_Analysis/Modified_Spike_Repository and are modified to
% fit the purpose of this GUI
% Functions used from the Spike repository: 
% lfpBandPower
% plotLFPpower -- all modified for the purpose of this GUI

% NOTE: PowerSpecResults holds the results of the computations. If its not
% empty, its not computed again since it takes a long time. In this case
% the output BandPower is replaced by PowerSpecResults.

% NOTE: PowerSpecResults has a field for raw data and preprocessed data,
% since the spectrum can be computed for both 

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
% 12. ActiveChannel: double vector containing channel active in the probe
% view window
% 13. PlotAppearance: structure holding current default of plot appearances
% like linewidths

% Outputs:
% 1. PowerSpecResults: results of current computation or previously executed
%computation save in current GUI instance
% 2. BandPower: Current analysis results. Replaced by PowerSpecResults if
% already computed
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Compute Spectrum over Depth 
% No data present, compute 
if strcmp(DataSource,"Raw Data") && ~isfield(PowerSpecResults,'Raw')
    nChansInFile = size(Data.Raw,1);  
    
    [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
    lfpBandPower([], Data.Info.NativeSamplingRate, nChansInFile, [], Data.Raw,TextArea);
    BandPower.allPowerEst = BandPower.allPowerEst';
    BandPower.marginalChans = 1;
    BandPower.freqBands = {[1.5 4], [4 10], [10 30], [30 80], [80 200]};
elseif strcmp(DataSource,"Preprocessed Data") && ~isfield(PowerSpecResults,'Preprocessed')
    nChansInFile = size(Data.Preprocessed,1);  
    if ~isfield(Data.Info,'DownsampleFactor')
        [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
        lfpBandPower([], Data.Info.NativeSamplingRate, nChansInFile, [], Data.Preprocessed,TextArea);
    else
        [BandPower.lfpByChannel, BandPower.allPowerEst, BandPower.F, BandPower.allPowerVar] = ...
        lfpBandPower([], Data.Info.DownsampledSampleRate, nChansInFile, [], Data.Preprocessed,TextArea);
    end
    BandPower.allPowerEst = BandPower.allPowerEst';
    BandPower.marginalChans = 1;
    BandPower.freqBands = {[1.5 4], [4 10], [10 30], [30 80], [80 200]};
% Data already there, just load
elseif strcmp(DataSource,"Raw Data") && isfield(PowerSpecResults,'Raw')
    BandPower.lfpByChannel = PowerSpecResults.Raw.lfpByChannel;
    BandPower.allPowerEst = PowerSpecResults.Raw.allPowerEst;
    BandPower.F = PowerSpecResults.Raw.F;
    BandPower.allPowerVar = PowerSpecResults.Raw.allPowerVar;
    BandPower.marginalChans = PowerSpecResults.Raw.marginalChans;
    BandPower.freqBands = PowerSpecResults.Raw.freqBands;
elseif strcmp(DataSource,"Preprocessed Data") && isfield(PowerSpecResults,'Preprocessed')
    BandPower.lfpByChannel = PowerSpecResults.Preprocessed.lfpByChannel;
    BandPower.allPowerEst = PowerSpecResults.Preprocessed.allPowerEst;
    BandPower.F = PowerSpecResults.Preprocessed.F;
    BandPower.allPowerVar = PowerSpecResults.Preprocessed.allPowerVar;
    BandPower.marginalChans = PowerSpecResults.Preprocessed.marginalChans;
    BandPower.freqBands = PowerSpecResults.Preprocessed.freqBands;
end

%% Save Check point for Main GUI

if strcmp(DataSource,"Raw Data") && ~isfield(PowerSpecResults,'Raw')
    PowerSpecResults.Raw = BandPower;
elseif strcmp(DataSource,"Preprocessed Data") && ~isfield(PowerSpecResults,'Preprocessed')
    PowerSpecResults.Preprocessed = BandPower;
end

%% plot LFP power over specific bands and over depth
commaindicie = find(FrequencyRangeHzEditField == ',');
dispRange(1) = str2double(FrequencyRangeHzEditField(1:commaindicie(1)-1)); % Hz
dispRange(2) = str2double(FrequencyRangeHzEditField(commaindicie(1)+1:end)); % Hz

Figure_2.NextPlot = "add";
Figure_2.FontSize = 10;
Figure.FontSize = 10;

[ActiveChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainWindow');

BPEstimate = BandPower.allPowerEst(ActiveChannel,:);

plotLFPpower(BandPower.F, BPEstimate, dispRange, BandPower.marginalChans, BandPower.freqBands, Figure, Figure_2, WhattoPlot,Data.Info.ChannelSpacing,TwoORThreeD,PlotAppearance);

%% save plotted data in case user wants to save 
dispF = BandPower.F>dispRange(1) & BandPower.F<=dispRange(2);
nC = size(BandPower.allPowerEst,1); 

CurrentPlotData.XData = BandPower.F(dispF)';
CurrentPlotData.YData = (0:nC-1)*Data.Info.ChannelSpacing;
CurrentPlotData.CData = 10*log10(BandPower.allPowerEst(:,dispF))';
CurrentPlotData.Type = "Power Spectrum over Depth";
CurrentPlotData.XTicks = Figure.XTickLabel';

