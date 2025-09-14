function [W1,W2,BinSize,ISIMaxTime] = Spike_Module_Prepare_WaveForm_Window_and_Analysis_Check_Inputs(W1,W2,BinSize,ISIMaxTime)

%________________________________________________________________________________________
%% Function to check inputs for waveform plots in unit analyisis windows

% This function is called in the unit analysis window to prepare and check data for
% plotting. If the inputs have the wrong format, they are checked and
% autochanged if format was violated.

% Inputs:
% 1. W1: char, irst (most left)
% app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 2. W2: char, second (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 3. W3: char, third (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 4. BinSize: char, editfield of nr of bins to show
% 5. ISIMaxTime : char, editfield of max time for ISI to plot

% Outputs
% 1. W1: char, irst (most left)
% app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 2. W2: char, second (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 3. W3: char, third (most left) app window textarea to write nr of waveforms in. (saved in
% W1.Value)
% 4. BinSize: char, editfield of nr of bins to show
% 5. ISIMaxTime : char, editfield of max time for ISI to plot


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Check Inputs 

[W1] = Utility_SimpleCheckInputs(W1,"One",'20',0,0);
[W2] = Utility_SimpleCheckInputs(W2,"One",'20',0,0);

[BinSize] = Utility_SimpleCheckInputs(BinSize,"One",'150',0,0);
[ISIMaxTime] = Utility_SimpleCheckInputs(ISIMaxTime,"One",'0.15',0,0);

