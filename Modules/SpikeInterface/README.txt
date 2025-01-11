______________________________________________
NeuroMod Toolbox; SpikeInterface README
Author: Tony de Schultz
______________________________________________

This folder contains all costume python scripts to run SpikeInterface. 

SpikeInterface_Sorting.py is the main function that is executed by - and receives arguments from the MATLAB 'Spike Detection and Sorting' window (ProbeInfo, file of binary file and sorting parameters). It runs the individual functions for individual pipeline parts defined in the SpikeInterface_FunctionDeclaration.py function. Every script uses the SpikeInterface library. 

The sorting parameter for the spikesorters are saved as a sorting_parameters.json file (saves a maltab cell coming from Spike_Module_ShowSpikeSortingSettings.m)
Example code:

jsonFilePath = fullfile(file_path, 'sorting_parameters.json');
fid = fopen(jsonFilePath, 'w');
fwrite(fid, SortingParameters, 'char');
fclose(fid);

After sorting was succsefull, the main script save the results as .npy files with the export_to_phy function (like the native Kilosort output) and additionally saves a SpikePositions.mat file saving the spike locations from the SpikeInterface analyzer object of your sorting. Here is an example code how to get this information in SpikeInterface:

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

