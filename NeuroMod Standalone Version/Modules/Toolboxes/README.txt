______________________________________________
NeuroMod Toolbox; Toolboxes README
Author: Tony de Schultz
______________________________________________

This folder contains the files used from other toolboxes. Except of '1. FieldTrip' and '3. Spike_Repository', they contain all functions and folders the original GitHub repo do. 

Original files except for the '3. Spike_Repository' remain unmodified. However there are functions calling and managing these toolboxes, which might not be compatible with future versions of these toolboxes or the full github repo being saved here -- like saving all fieldtrip files and folders which would create incompatibilities with other toolboxes!. 

License files of those toolboxes are saved in 'GUI_Path/Modules/MISC/LICENSES'.

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

The Neuropixels_trajectory_explorer is used to be called from the 'Extract Raw Recordings Window' to save trajectory and brain area information and load onto the probe design.

The EndPoint Corrected Hilbert Transform code is used in the phase synchronization windows when the analysis method selected is the EndPoint Corrected Hilbert Transform

The Artefact Subspace Reconstruction code is used in the preprocessing window to apply this method to the continuous data stream.

The Matnwb toolbox is used in the 'Save Dataset' window to when the user wants to save NeuroMod data in the .nwb format and load the .nwb file back into Matlab.

The TDT Matlab SDK is used to extract data and event times from a raw Tucker Davis tank data recording