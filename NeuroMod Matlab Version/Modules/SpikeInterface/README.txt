______________________________________________
NeuroMod Toolbox; SpikeInterface README
Author: Tony de Schultz
______________________________________________

This folder contains all custom python scripts to run SpikeInterface. It also contains a folder with .mat files holding spike sorting parameter that can be saved in the 'Spike Detection and Sorting' Window.

SpikeInterface_Sorting.py is the main function that is executed - and loads a .json file with all parameter (sorting parameter and script paramter) from the MATLAB 'Spike Detection and Sorting' window. It runs the individual functions for individual pipeline parts defined in the SpikeInterface_FunctionDeclaration.py function. Every script uses the SpikeInterface library. 

In order to be able to execute a python script via MATLAB, a path for the python.exe file in the environment in which SpikeInterface is installed has to be provided. 

The sorting parameter for the spike sorters are saved as a sorting_parameters.json file (saves a maltab cell coming from Spike_Module_ShowSpikeSortingSettings.m)
Example code:

jsonFilePath = fullfile(file_path, 'sorting_parameters.json');
fid = fopen(jsonFilePath, 'w');
fwrite(fid, SortingParameters, 'char');
fclose(fid);

This file exists also after sorting finished. 

The script parameter .json file containing GUI (NOT sorting) parameter to know what has to be done in python is deleted after reading into python.

After sorting was successful, the main script saves the results as .npy files with the export_to_phy function (like the native Kilosort output) and additionally saves a SpikePositions.mat file saving the spike locations from the SpikeInterface analyzer object of your sorting. Here is an example code how to get this information in SpikeInterface:

compute_dict = {
        .......
        'spike_locations':{},
        ......
    }
analyzer.compute(compute_dict)
ext_SpikeLocations = Analyzer.get_extension("spike_locations")
SpikePositions = ext_SpikeLocations.get_data()
savemat('YourFolder', mdic)
export_to_phy(sorting_analyzer=Analyzer, output_folder=PathForPhy, copy_binary=False)

Additionally, you need to save a max_template_channel_index.npy file with the maximum template channel for each cluster.

templates = Analyzer.get_extension("templates").get_data()
PeakToPeak = templates.ptp(axis=1)              
max_chan_idx = np.argmax(PeakToPeak, axis=1)   
np.save(PathForPhy, max_chan_idx)

This folder also contains the python script to extract Maxwell MEA .h5 files called SILoadMaxwell.py. This script is also loading a json file with all gui parameter the user set. After data extraction finished, amplifier data is saved as a SI_Saved_Channel_Data.dat file while metadata and event data are saved in a SI_Saved_MetaData.mat file. They are saved in a parent folder of the recording folder. This folder also contains the probe design if the user selected to save it for later use in the GUI.