This folder contains the following functions with respective Header:

 ###################################################### 

File: Event_Module_FieldTrip_Event_Analysis.m
%________________________________________________________________________________________

%% Function to Use some of the FieldTrip functionality within NeuroMod

% Naturally, this function uses functions from the FieldTrip Matlab toolbox

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. DataType: char, either "Raw Data" or "Preprocecssed Data" whether to
% construct struc for fieldtrip with one of both datasets
% 3. AnalysisType: char, what type of analysis do handle with FieldTrip;
% see below
% 4. SingleERPChannel: double, channel to show single channel ERP for (active channel, not data matrix channel)
% EventChannelToUse: char, event channel from which event time stamps are
% taken
% EventTimeBeforeAfter: 1x2 vector with pre and post stimulus time (prestimulus time postive!)
% Info: struc with feilds holding parameter for analysis, like
% Info.BaselineNormalizeERP (1 or 0) Info.BaseLineWindow (actual
% window),TimeFrequenyPowerFreqs (freqs for time frequency power)
% EventDataType: char, either 'Raw Event Related Data' OR 'Preprocessed Event Related Data'
% TrialSelection: char, matlab expression with user selected trial range to
% analyze

% Output: 
% 1. CurrentPlotData: struc saving results for export; NOT implemented yet!

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

