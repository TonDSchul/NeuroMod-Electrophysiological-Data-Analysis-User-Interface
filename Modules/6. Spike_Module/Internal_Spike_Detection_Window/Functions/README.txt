This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_FilterSpikes.m
%________________________________________________________________________________________

%% Function to filter Data.Spikes in Terms of vertical artefacets. 
%If a spike occurs at the same indicie +/- as many samples as specified in
%Tolerance variable over a minimum amount of depth, the count as artefacts
%and are deleted. This can be used to remove spike artefacts from optogenetic stimulation
%artefacts

% Input:
% 1. Data: Data structure containing Data.Spikes field created in the
% 'Spike_Module_Spike_Detection' function
% 2. Tolerance: Tolerance of vertical spike artefacts in samples as char. For example 3 means: spike time +/- 3 samples to the left and right over specified depth are counted as artefacts 
% 3. ArtefactDepth: Depth in um as char over which same spike times have to occur to count as a artefact.
% 4. ChannelSpacing in um as double

% Output: Preserved Data structure with filtered spikes

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Spike_Detection.m
%________________________________________________________________________________________

%% Function to extract Data.Spikes from preprocessed (high pass filtered) data using thresholding
%% NOTE: Only negative spikes are etracted, data amplitude therefore has to be smaller than threshold and biggest amplitude is the smallest value
% Input:
% 1. Data: Data structure containing high pass filtered preprocessed data as a Channel x Time matrix in Data.Preprocessed field.
% High pass filter required!
% 2. Detectionmethod: Thresholding Method. Options: "Quiroga Method" OR "Threshold: Mean - Std" OR "Threshold: Median - Std"; 
% 3. Type: Method to compute mean and std with. Options: "All Channel" OR "Individual Ch."
% 4. STDThreshold: Number of std's signal has to deviate from mean to count
% as spike. Standard: 4; Can vary depending on type selected
% 5. Filter: true or false, specify whether vertical artefacts should be
% filtered (same spike times +/- tolerance time over more channel then
% specified as ArtefactDepth are rejected) --> i.e. same spike time over 10
% Channel are deleted
% Tolerance: Tolerance of vertical spike artefacts in samples as double. For example 3 means: spike time +/- 3 samples to the left and right over specified depth are counted as artefacts 
% ArtefactDepth: Depth over which same spike times have to occur to count
% as a artefact, in um and as double

% Output: Data structure with added field 'Spikes' (Data.Spikes), called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

