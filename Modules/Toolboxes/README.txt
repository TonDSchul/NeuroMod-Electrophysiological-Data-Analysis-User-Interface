______________________________________________
NeuroMod Toolbox; Toolboxes README
Author: Tony de Schultz
______________________________________________

This folder contains the files used from other toolboxes. This includes the 'fileio', 'perproc' and 'private' folder from fieldtrip, the complete spike repository from the cortex lab GitHub page and the complete Open Ephys analysis tool.
Additionally it contains the Wave_clus 3 toolbox from Github

Original files from fieldtrip, Wave_clus and the Open Ephys tools are unmodified. However there are functions calling and managing these toolboxes, which might not be compatible with future versions of these toolboxes. 

License files of thos toolboxes are saved in 'GUI_Path/Modules/MISC/LICENSES'.

(Note: Functions are save in their respective module folder, not here)

NOTE: in 6. Modified/Open Ephys Tools the BinaryRecording.m function was fixed (wrong index in a loop)

*****************

General Remarks:

Some functions of the spike repository from the cortex lab GitHub page are modified to fit the purpose of this GUI and are save in 4. Modified.

Field trip functions are used for:

1. Extracting raw - and event data from Neuralynx (.ncs, .nev) and Plexon (.plx) recording systems
2. All filtering steps in the preprocessing window (low pass, high pass, narrowband, band-stop and median filter)

Open Ephys analysis tool functions are used for:

1. Extracting raw - and event data from all open ephys formats (.nwb, .dat and .continous)
2. Open/Read .npy files.

Spike repository from the cortex lab where used as a template for:

2. Plot Kilosort drift map with amplitude color coding (modified)

3. Calculate and plot LFP band power over depth (modified)

4. Calculate and plot spike triggered average (modified)

5. Plot Waveform amplitude CDF's and PDF's (modified)

-- modified files usually only contain some parts of the original computations, all plotting and general management are modified completely.

Wave_clus functions are used for:

1. Spike Clustering/Sorting of internally detected spikes with thresholding