function [ChannelEditField,WaveformEditField,SpikeRateNumBinsEditField] = Continous_Internal_Spikes_Check_Inputs(Data,ChannelEditField,WaveformEditField,SpikeRateNumBinsEditField)

%________________________________________________________________________________________
%% Function to cheks whther user inputs for cintinous internal spike analysis are correct

% This function takes textfield objects of the cont. spike window, checks
% the input and replaces the value with a standard value when there is a
% format error. Output variables are taken directly as new values for
% textfield to visualzie autochange to standaradvalue if format error
% detected

%gets called in the Continous_Spikes_Prepare_Plots function

% Inputs: 
% 1.Data: Data structure with raw data for channel number used as standardvalue
% 2. ChannelEditField: char with channel selection of user. 
% 3. WaveformEditField: char with waveform selection of user. 
% 4. SpikeRateNumBinsEditField: char with spike rate bins selection of user. 
%-- all of the inputs have to be in the forma '1,10' with positive integers
%and so on.

% Outputs:
% 1. ChannelEditField: char with channel selection of user. 
% 2. WaveformEditField: char with waveform selection of user. 
% 3. SpikeRateNumBinsEditField: char with spike rate bins selection of user. 
%-- only changed when format error

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Spike Rate NUmbins

[SpikeRateNumBinsEditField.Value] = Utility_SimpleCheckInputs(SpikeRateNumBinsEditField.Value,"One",'100');

%% Nr of Waveforms to plot

[WaveformEditField.Value] = Utility_SimpleCheckInputs(WaveformEditField.Value,"Two",'1,10');

commaindicie = find(WaveformEditField.Value == ',');
NrWaveformstoplot(1)=str2double(WaveformEditField.Value(1:commaindicie(1)-1));
NrWaveformstoplot(2)=str2double(WaveformEditField.Value(commaindicie(1)+1:end));

%% NrChannels to plot

[ChannelEditField.Value] = Utility_SimpleCheckInputs(ChannelEditField.Value,"Two",strcat('1,',num2str(size(Data.Raw,1))));

