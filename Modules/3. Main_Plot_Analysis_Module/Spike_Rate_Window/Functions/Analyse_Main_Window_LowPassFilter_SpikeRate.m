function filteredSpikeRate = Analyse_Main_Window_LowPassFilter_SpikeRate(SpikeRate, cutoffFreq, samplingRate, filterOrder, BinSize)

%________________________________________________________________________________________

%% Function to applie a low-pass Butterworth filter with zero phase distortion to spike rate

% Inputs:
% 1. SpikeRate - Vector of spike rates to be filtered as 1x nbins double vector.
% 2. cutoffFreq - is hard coded at line 29 -- but preserved if changed to manual input from GUI or somewhere else, as double.
% 3. samplingRate - Sampling rate of the SpikeRate as double in Hz.
% 4. filterOrder - Order of the Butterworth filter as double.
% 5. BinSize - not necessary here, but maybe for autosetting cutoff and
% filter order?!

% Output:
% 1. filteredData: 1 x nbins double Low-pass filtered SpikeRate .

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Normalize the cutoff frequency with respect to Nyquist frequency
nyquistFreq = samplingRate / 2;

% Automatically set the cutoff frequency as a fraction of Nyquist frequency
cutoffFreq = (0.45 * nyquistFreq); %adjust the fraction as needed

%cutoffFreq = (cutoffFreq * scale / BinSize) + offset;

% Calculate the dynamic cutoff frequency based on BinSize
% Inverse relationship: lower BinSize -> higher cutoffFreq
% Ensure cutoffFreq stays within the min and max range

normalizedCutoffFreq = (cutoffFreq / nyquistFreq);

% Design Butterworth low-pass filter
[b, a] = butter(filterOrder, normalizedCutoffFreq, 'low');

% Apply filter with zero-phase distortion
filteredSpikeRate = filtfilt(b, a, SpikeRate);

filteredSpikeRate(filteredSpikeRate < 0) = 0;

