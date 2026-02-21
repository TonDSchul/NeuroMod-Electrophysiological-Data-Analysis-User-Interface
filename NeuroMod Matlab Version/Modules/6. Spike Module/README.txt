______________________________________________
NeuroMod Toolbox; Spike Module README
Author: Tony de Schultz
______________________________________________

This Module contains app windows and functions for:
1. Internal spike detection using thresholding as well as spike sorting with SpikeInterface. 
2. Apply or load spike sorting of this internal spike detection with the Wave_Clus 3 MATLAB Toolbox from https://github.com/csn-le/wave_clus.
3. Save raw or preprocessed GUI data for Kilosort and/or SpikeInterface.
4. Spike analysis functions that are shared over event and continuous spike analysis. 

Spike data from the internal thresholding, from Kilosort and from SpikeInterface are mutually exclusive - you can only have spike data from one at a time. The representation in the Data.Spikes field is the same for Kilosort, SpikeInterface and the internal spikes - so field names are the same. However, spike data from internal thresholding naturally has no pc components ,template information or cluster identities - fields like those remain empty. Also, the spike positions are saved as channel when only having internal thresholding or WaveClus_3 spike data. From any other sorter, spike position are saved in µm.

Functions of Wave_Clus 3 remain unchanged. Only a compatibility function is used called Spike_Module_Internal_Spike_Sorting.m

IMPORTANT: 

SpikeInterface runs via compatibility functions in the 'SpikeInterface' module folder of the GUI.

For smooth operation and one-click loading, saving and execution of spike sorting with any of the sorters, use the automatically created/suggested folders when saving for spike sorting!

*****************

All about Kilosort and SpikeInterface data save folder structure:

Kilosort output data is loaded through a costume function calling the ksDriftmap.m function from the spike repository of the Cortex Lab on Github at https://github.com/cortex-lab/spikes. 

When saving data, the 'Save for Sorting' window will automatically suggest a folder and name to save it as. This is the standard file structure the autorun config functions use too and creates a .dat file in 'Path_to_your_recording/Kilosort' OR a .bin file in 'Path_to_your_recording/SpikeInterface' that can be loaded into the spike sorters.

When you load this previously saved file into Kilosort and analyze the data, at standard, Kilosort output data is saved in a folder called kilosort4 within the Kilosort folder created before (Kilosort/kilosort4 or Kilosort/kilosort3, or in other words in the folder of the file you loaded into Kilosort). Don't change this name and structure, otherwise auto detections of Kilosort data can have trouble and you have to select a folders manually and the workflow wont be as smooth. SpikeInterface sorting results are autosaved in folder with the selected sorter as name, i.e 'Path_to_your_recording/SpikeInterface/Mountainsort 5' or SpykingCircus 2.
 
This means, all your sorting data is (supposed to be) saved in a file named Kilosort/kilosort4 or SpikeInterface/SorterName, that is located in the path of the recording you are analyzing. When opening the 'Load Spike Sorting' window, sorting data is auto searched in those locations too, so you just have to click on load (and in the autorun functions, so you dont have to do any additional steps there). Currently only loading of output .npy files is supported. For SpikeInterface they are obtained through the export_to_phy function (see main Github README) and by saving spike locations and max template channel as additional .mat files.

When saving data for Kilosort, along with the .dat file a .mat file is saved that holds the scaling factor used to convert your recoding data into int16 or int32 which Kilosort requires. When you load Kilosort sorting output files into NeuroMod, this scaling factor is auto searched in the directory 'Path_to_your_recording/Kilosort' and applied to your data, so that spikes amplitudes are converted back from integers into mV.


*****************

All about Internal spike data save folder structure:

For internal spike detection and spike sorting with Wave_clus 3 no additional software is required and it can all be done in Neuromod. 

To create a new spike sorting, you first have to extract spike data with one of the thresholding techniques. Then spike times are saved in a .mat file for Wave_clus to take over, load that file and perform the actual spike sorting. Spike times and spike sorting results are saved in the standard directory: 'Path_to_your_recording/Wave_Clus'. For smooth operation of auto detection functions and autorun functions that  load results without requiring you to manually select a folder, keep that folder structure!

When you extract the same raw data again in the GUI, you don't have to perform spike detection again to get your spike data. All you have to do is click on 'Load Existing Spike Sorting' and spike data along with spike sorting data is loaded! It auto-searches the directory 'Path_to_your_recording/Wave_Clus' for data!

Or save the GUI data with the spike data as part of the dataset and load it again, then you don't have to do anything.


*****************

General Remarks:

Each folder in this module contains one (or more) app windows for the respective functionality as well as a folder called "Functions" with all main functions necessary for this module. This folder also contains the RUN_Spike_Module.m function that is executed when the user clicks on the RUN button for this module. It manages which windows open based on what option is selected in the list to the left of the RUN button.

Each analysis the user can pick in this module is made out of an app window that is called in the main window when the user clicks in RUN of this module. 
NOTE: Some functionalities for running the app windows require utility and organize functions from the "1. Main_Window_Functions" folder.

All necessary functions are designed in a way that you can also use them outside the GUI. You just have to specify the parameters of the app window manually. See AutorunConfig variable in the Autonrun_Config files.

TIP:
All spike data is represented as a 1 x nspikes vector. There is a vector for spike time points, spike positions, spike cluster and so on.
Selecting parts of the spike data (i.e. just of a specific cluster) can be easily achieved with logical indexing -- i.e. ClusterSpikes = Spikes.CluserPosition == 1 
Waveforms for each spike in a nspike x ntimewaveform matrix is extracted when spike indices are loaded/extracted.
(When computing average waveforms over channel, a nchannel x nspikes x ntimewaveform is extracted. No perma-save since it takes longer and takes a lot of memory) 


Note: Some functions are used across all windows. They don't have continuous or event in their name.


