function [PowerSpecResults,BandPower] = Continous_Power_Spectrum_Over_Depth(Data,DataSource,PowerSpecResults,BandPower,FrequencyRangeHzEditField,Figure,Figure_2,TextArea,WhattoPlot,TwoORThreeD)
%________________________________________________________________________________________

%% Function to compute static power spectrum over probe depth
% This function contains and uses functions from the Spike repository from Nick Steinmetz on Github at https://github.com/cortex-lab/spikes. 
% They are saved in: GUIPath/Modules/6.Spike_Module/Spike_Analysis/Modified_Spike_Repository and are modified to
% fit the purpose of this GUI
% Functions used from the Spike repository: 
% lfpBandPower
% plotLFPpower -- all modified for the purpose of this GUI

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: DataSource: string which data to use to compute? Either "Raw Data" or "Preprocessed Data"
% 3: PowerSpecResults: structure, if already computed in current GUI instance: this is non empty and contains the results from the previous calculation.
% So the lengthy computation does not have to happen again and results can be plotted immediately
% 4: Bandpower saves the results from the computation if they should take
% place 

% Outputs:
%PowerSpecResults = results of current computation or previously executed
%computation save in current GUI instance
%BandPower 

% NOTE: PowerSpecResults has a field for raw data and preprocessed data,
% since the spectrum can be computed for both 

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
plotLFPpower(BandPower.F, BandPower.allPowerEst, dispRange, BandPower.marginalChans, BandPower.freqBands, Figure, Figure_2, WhattoPlot,Data.Info.ChannelSpacing,TwoORThreeD);