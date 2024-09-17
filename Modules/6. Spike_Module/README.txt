______________________________________________
NeuroMod Toolbox; Spike Module README
Author: Tony de Schultz
______________________________________________

IMPORTANT: All functions are desinged in a way that you can also use them outside the GUI. You just have to specify the parameters of the app window manually. See AutorunConfig variable in the Autonrun_Config files.
The following workflows stem from the GUI. What is used outisde the GUI is specified. Also see Atourun Module to see use outside of GUI-

IMPORTANT: All spike data is represented as a 1xnspikes vector. There is a vector for spike time points, spike positions, spike cluster and so on.
Selecting parts of the spike data (i.e. just of a specific cluster) can be easily achieved with logical indexing -- i.e. ClusterSpikes = Spikes.CluserPosition == 1 
Waveforms for each spike in a nspike x ntimewaveform matrix is extracted when spike indicies are loaded/extracted.
(When computing average waveforms over channel, a nchannel x nspikes x ntimewaveform is extracted. No perma-save or instan computation since it takes longer and takes a lot of memory) 

*Important*: This code currently only works for Kilosort 4 and 3! It takes the results in the oupput data folder Kilosort creates after finishing spike sorting.
*Important*: app.Data.KilososortData and app.Data.Spikes have to be always part of the dataset, but empty when not loaded
*Important* : Only one spike dataset is allowed to exist at once. So if internal spikes are loaded, app.Data.KilosortData has to set to be empty and vise versa.

Note: Some functions are used across all windows. They dont have continous or event in their name.

This Module contains app windows and functions for:
1. Internal spike detection using thresholding, 
2. Apply or load spike sorting of this internal spike detection with the Wave_Clus Toolbox
3. Save Raw data for Kilosort and load Kilsoort results.
4. All spike analysis functions and windows. 

Internally found spike data can be clustered/sorted with the Wave_Clus Toolbox from https://github.com/csn-le/wave_clus
Functions of this toolbox remain unchanged. Only a compatiblity function is used called Spike_Module_Internal_Spike_Sorting.m

Data structure (app.Data) contains two fields that handle spike data, dependent on whether the data comes from the internal thresholding spike detection or from Kilosort. The field handling internal spike data is saved as app.Data.Spikes.
Since Kilosort analysis yields more data than the internal thresholding, like spike clustering, it is handled in a different field calles app.Data.KilosortData.
Both fields (app.Data.Spikes and app.Data.KilosortData) contain different fields, like soike times and spike channel. 
Internal spike detection consists of simple thresholding methods (mean-std and median-std) in a channelwise fashion. 

Workflow for all spike extraction, spike loading or saving only contains a single function without necessary support functions.
Workflow for Spike Analysis:

Continous and Event Spike Analysis have seperate app windows. Each window uses the Spike_Module_Set_Up_Spike_Analysis_Windows to set up app window components.

Workflow for Continous Spike Analysis: 
1. Continous_Spikes_Prepare_Plots
2. Either Continous_Kilosort_Spikes_Manage_Analysis_Plots OR Continous_Internal_Spikes_Manage_Analysis_Plots, depending on whether spike data is from kilosort or intnernal spike detection

Workflow for Event Spike Analysis: 
1. Event_Spikes_Prepare_Plots
2. Either Events_Internal_Spikes_Manage_Analysis_Plots OR Events_Kilosort_Spikes_Manage_Analysis_Plots, depending on whether spike data is from kilosort or intnernal spike detection

