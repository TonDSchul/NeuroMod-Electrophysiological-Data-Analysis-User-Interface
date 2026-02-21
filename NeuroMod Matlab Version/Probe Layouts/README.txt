______________________________________________
NeuroMod Toolbox; Probe Layouts Folder README
Author: Tony de Schultz
______________________________________________

This is the standard folder to save custom channel orders, active channel maps, kilosort channelmaps and quick load probe information. 

Folder Descriptions:

1. Active Channel:       Contains .mat files with a vector called ActiveChannel holding all active channel saved for a specific probe layout.
2. Channel Order:        Contains .mat files with a vector called Channelorder holding a custom channel order saved for a specific probe layout.
3. Kilosort Channelmaps: Contains .mat files with all variables needed to load a custom probe layout into the external Kilosort GUI.
4. Saved Probe Layouts:  Contains .mat files with a structure holding all variables needed to load a custom probe layout back into NeuroMod.
5. Trajectories:         Contains .mat files with all variables needed to load a probe trajectory saved with the Neuropixels Trajectory Explorer (can be opened in the Raw Data Extraction window when an allen brain atlas is selected (see README for more information)).

General Remarks:

All .mat files for folders 1 to 4 can be saved and loaded in the Probe Layout Window. It is recommended to save in those folders for the autodetection to work so that you can quickly select a file in the menu rather than first having to select a custom folder. 



