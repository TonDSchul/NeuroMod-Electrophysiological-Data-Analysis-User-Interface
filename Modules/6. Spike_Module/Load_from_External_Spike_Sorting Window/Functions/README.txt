This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_Load_Kilosort_Data.m
%________________________________________________________________________________________

%% Function to load .npy and .mat files Kilosort ouputs after finishing the analysis

% This functions includes and uses function from the Spike repository on
% Github from Cortex Lab available at https://github.com/cortex-lab/spikes

% Note: NPY files are read using the respective readNPY function from the Open Ephys Analysis Tools from Github. 
% Functions from the spike-master github page from Cortex Lab where used:
% ksDriftmap (modified for the purpose of this GUI)

% Input:
% 1. Data = structure containing all data. After loading, field Data.Spikes is added with
% several subfields. Those include most importantly a vector for SpikeTimes, SpikePositions,
% SpikeAmplitudes and SpikeCluster. Therefore, to plot/access specific spikes, logical
% indexing can be used.
% 2. Autorun: Variable specifiying whether function is called from the
% autorun function or from the GUI; "SingleFolder" or "MultipleFolder" when
% called from autorun, something else as a string whe not
% 3. SelectedFolder: Folder from whioch data was extracted/loaded, as char
% 4. ScalingFactor: single value as double specfying the scalingfactor used
% to transform raw data to int. This is used to compute real amplitude values of
% spikes from kilosort

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

