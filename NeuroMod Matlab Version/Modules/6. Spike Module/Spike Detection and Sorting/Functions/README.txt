This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_Check_Bin_Dat_Files.m
%________________________________________________________________________________________
%% Function to check whether a .bin file for spikeinterface sorting was found in the selected path

% Inputs:
% 1. app: Spike detection and sorting window object
% 2. Type: string ,"Auto" OR "Manual"; Auto on app startup for auto search,
% manual if user seleted folder manually
% 3. filepath: char with path to the folder to search in

% Outputs
% 1. app: Spike detection and sorting window object 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Check_Load_Conda_Python_exe.m
%________________________________________________________________________________________
%% Function to check whether python.exe is present and promt to select a folder containing it if not

%% Creates a variable in GUI_Path/Modules/MISC/Variables (do not edit) that saves the path to the python exe if it was succesfully selected

% Inputs:
% 1. executablefolder: char, GUI path

% Outputs
% 1. Python_Conda_Environment_Path: char, path to the selected python conda
% exe

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_ConverStrucToTextArea.m
%________________________________________________________________________________________
%% Function to convert spike sorting parameter Structure to text containing all fields and values of the sorting parameter
%% structure 

%% cleans quotes from values

% Inputs:
% 1. Struc: spike sorting settings structure
% 2. Sorter: string, selected sorter, "Mountainsort 5" OR "SpykingCircus 2"
% OR "Kilosort 4"

% Outputs
% 1. Text: text containing all fields and values of the sorting parameter
% structure 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_ConvertTextToParameterStruc.m
%________________________________________________________________________________________
%% Function to convert text containing all fields and values of spike sorting parameter text back to a strcuture

% uses Spike_Module_updateSubStruct.m only for spykingcircus

% Inputs:
% 1. Text: text containing all spike sorting parameter settings 
% 2. Sorter: string, selected sorter, "Mountainsort 5" OR "SpykingCircus 2"
% OR "Kilosort 4"
% 3. SC2Parameter: only when sorter = "SpykingCircus 2"; standard spike sorting settings structure --> only values
% that changed are interchanged!

% Outputs
% 1. NewParameterStrcuture: spike sorting parameter structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Detect_WaveClus_Sorting.m
%________________________________________________________________________________________
%% Function to check waveclus sorting results are found within the Path specified

% Inputs:
% 1. app: Spike detection and sorting window object
% 2. Path: string ,Path to check for waveclus cluster results
% 3. Manual: double or logical, either 1 or 0, whether waveclus results
% folder was specified manually or not in the GUI; 1 will add '\Wave_Clus'
% to the end of the path

% Outputs
% 1. app: Spike detection and sorting window object 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


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
% 4. ChannelSpacing: in um as double from Data.Info.ChannelSpacing

% Output: Preserved Data structure with filtered spikes

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Internal_Spike_Sorting.m
%________________________________________________________________________________________

%% Function to manage wave clus 3 toolbox to conduct spike sorting

% This function is called when the user either creates a new spike sorting
% with wave clus 3 or loads existing spike data. It takes the spike times
% obtained from the internal spike detection, saves it as a .mat file and
% passes that path into wave clus 3 to perform spike sorting. Standard
% folder is 'Recording_Path/Wave_Clus'.

% Input:
% 1. Data: main window data structure
% 2. SpikeSortingPath: char, folder to save spike times to / load spike sorting from; standard 'Recording_Path/Wave_Clus'
% 3. WhatToDo: string, either "Clustering" to perform new spike sorting OR
% "Loading" to only load spike cluserting results (actually the string doesnt matter, spike sorting results have to be loaded in any case. Only determines if wave clus 3 is executed)
% 4. ClusterType: string, either "AllChannelTogether" OR "IndividualChannel"
% 5. CurrentSorter: string, currently only "Waveclus" (sets the Info.Sorter value)

% Output: 
% 1. Data structure with added field 'Spikes' (Data.Spikes); Now
% Spike.SpikeCluster contains the unit identities of each spike. 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Load_Sorting_Results_After_Sorting.m
%________________________________________________________________________________________
%% Function to autoload spike sorting results after sorting was succesfully finished

% Inputs:
% 1 app: Spike Detection and Sorting window app object
% 2. Sorter: string, name of the sorter for which results should be loaded,
% either "Mountainsort 5" OR "SpykingCircus 2" or "Kilosort 4" OR "WaveClus 3"
% 3. Path: string , Recording path with SpikeInterface or Kilosort folders

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_ShowSpikeSortingSettings.m
%________________________________________________________________________________________
%% Function to save and set the standard parameter struture for available sorters as well as converting them into a text to show in the GUI
% Standard parameter came from SpikeInterface, last updated 08.01.2025

% Inputs:
% 1. Sorter: string, name of the sorter to output settings for, either
% "Mountainsort 5" OR "SpykingCircus 2" OR "Kilosort 4"
% 2. ParameterStructure: stucture holding sufields for different sorters
% 3. ParameterPresent: string, only "ParameterNOTPresent" when parameter
% were not set yet and should be created. Some other string to only convert
% to text

% Outputs
% 1. ParameterStructure: Current structure holding spikesorting parameter
% 2. Text: char, holding all structure data

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
% 6. Tolerance: Tolerance of vertical spike artefacts in samples as double. For example 3 means: spike time +/- 3 samples to the left and right over specified depth are counted as artefacts 
% 7. ArtefactDepth: Depth over which same spike times have to occur to count
% as a artefact, in um and as double
% 8. TimeOffSetFilter: double, either 1 OR 0, 1 if Filter spikes in same
% waveforms should be execited
% 9. TimeOffset: double, waveform time (in seconds) around each spike to detect other
% spikes within

% Output: 
% 1. Data structure with added field 'Spikes' (Data.Spikes), called
% using app.Data.Spikes in GUI
% 2. ToKeep: strcuture saving information about spike filtering (when
% enabled) with deleting indicies and so on. Not implemented yet, thought
% of as a possibility for continous artefact rejection

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_cleanStructureQuotes.m
%________________________________________________________________________________________
%% Function to clean parameter structure that shows spike sorting settings 

%% cleans quotes from values

% Inputs:
% 1. inputStruct: spike sorting settings structure

% Outputs
% 1. cleanedStruct: cleaned spike sorting settings structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_convertTrueFalseStrings.m
%________________________________________________________________________________________
%% Function to convert true back to false if the user selcted so --> only when sorter = SpykingCircus 2
%% Just cleans up an unknown error occuring earlier

%% cleans quotes from values

% Inputs:
% 1. inputStruct: spike sorting parameter structure

% Outputs
% 1. updatedStruct: spike sorting parameter structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_extractMethodValues.m
%________________________________________________________________________________________
%% Function called when spike parameter text area was changed for spykingcircus 2

% SpykingCircus 2 parameter structure has 4 fields called 'method' for
% different categories. When the user changes parameters in the textare,
% these get extracted in a 1x4 cell array to save their identity. The first
% cell is the first method value and so on. Output methodValues is input
% for Spike_Module_replaceMethodValues after the text was converted to a
% strcuture to properly deal with mehtod values

% Inputs:
% 1. Parameterstrcuture: Parameterstrcuture holding SpykingCircus2 parameter

% Outputs
% 1. MethodValues: 1x4 cell array holding the values for all 4 mehtod fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_replaceMethodValues.m
%________________________________________________________________________________________
%% Function to take method field values from spykingcircus 2 parameterstructure to take as method values of the inputted structure

% Inputs:
% 1. OldSortingparameter: SpykingCircus 2 parameter structure 
% 2. NewMethodValues: 1x4 cell array which each cell holding a method field
% value 

% Outputs
% 1. UpdatedSortingparameter: spike sorting parameter structure

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_updateSubStruct.m
%________________________________________________________________________________________

%% Function to check for subfields in a nested structure -- only spykingcircus
% Used in searching through a structure (from text area) to extract
% a parametername and its value in the SorterParameter structure. 

% called in Spike_Module_ConvertTextToParameterStruc.m if param

% Input:
% 1. ParameterStrcuture: Parameter structure from text area
% 2. ParamName: string, field name searched for
% 3. ParamValue: value of ParamName if found (bc called recursively)

% Output: 
% 1. UpdatedParameterStructure: Parameter structure with the ParamValue
% added to the ParamName field of the structure if found

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

