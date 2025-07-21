This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_Convert_Indicies_to_Data_Channel.m
%________________________________________________________________________________________

%% Function to convert spike positions for a probe design with 2 rows. This is becuase spike depths of the neighbouring channel are the same.
%% However, to display all channel in the GUI from top to bottom, spike depths have to be adjusted

% This basically just takes spikes from the second to the last channel and
% adds Channelspacing to them.
%For Channelspacing = 20um:
% Ch 0 +0um
% Ch 1 + 20um
% Ch 2 + 20um
% Ch 3 + 40um
% Ch 4 + 40um and so on....
% 
% Input:
% 1. Data = structure containing all data. 

% Output:
% 1. Data structure of toolbox with added field:
% Data.Spikes.DataCorrectedSpikePositions with adjusted spikepositions and
% Data.Spikes.SpikeChannel to save the corresponding spike channel indices
% used for adjustments

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Determine_Sorters_Available.m
%________________________________________________________________________________________

%% Function to determine (automatically) which sorter outputs are available folder specified in SorterFolders

% Note: order of folder locations in SorterFolders is relevant!
% 
% Input:
% 1. Data = structure containing all data. 
% 2. SorterFolders: string array with each indicie containing a path to
% search spike sorting data in. First indicie is path to external Kilosort 4 GUI, second indicie is Kilosort3, third is Mpuntainsort 5, then
% SpykingCircus 2 and Kilpsort 4 from SpikeInterface as last -- when
% autosearch: path = recording_path/Kilosort or recording_path/SpikeInterface with their respective sunfolders
% 3. ManualSelection: NOT USED ANYMORE! double, either 1 or 0 to indicate whether input paths
% come from autodetection (recording path/Kilosort) or where manually
% selcted (auto adds subfolder extensions like /Kilosort/kilosort4)
% 4. ChangedSelectedSorter: NOT USED ANYMORE! double, either 1,2,3,4 or 5. Each number stands
% for a sorter thas was selected. This is used to search for just a single
% sorter (when the user selects a different folder in the GUI) to indicate
% which is searche for; 1 = external KS3 and 4; 2 = MS5; 3 = SC2; 4 = KS4
% SpikeInterface; 5=Waveclus

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


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
% 5. KSVersion: string, either "Kilosort 4 external GUI" or "Kilosort 3
% external GUI" to set which version should be loaded

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Load_SpikeInterface_Sorter.m
%________________________________________________________________________________________

%% Function to load .npy and .mat files SpikeInterface ouputs for Mountainsort 5, Spykingcircus 2 and Kilosort 4

% Note: NPY files are read using the respective readNPY function from the Open Ephys Analysis Tools from Github. 

% Input:
% 1. Data = structure containing all data. After loading, field Data.Spikes is added with
% several subfields. Those include most importantly a vector for SpikeTimes, SpikePositions,
% SpikeAmplitudes and SpikeCluster. Therefore, to plot/access specific spikes, logical
% indexing can be used.
% 2. SelectedFolder: char, folder location containing spike results
% 4. CurrentSorter: char, name of the sorter to load, used for
% Data.Info.Sorter, either 'Mountainsort5' or 'Spykingcircus2' or 'SpikeInterface Kilosort'

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

