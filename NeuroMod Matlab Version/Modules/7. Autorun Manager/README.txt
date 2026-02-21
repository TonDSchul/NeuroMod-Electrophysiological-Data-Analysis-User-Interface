______________________________________________
NeuroMod Toolbox; Autorun Manager README
Author: Tony de Schultz
______________________________________________

This module contains all functions and app windows to perform the autorun analysis. When the user selected folder and probe information in the autorun window and starts the selected autorun config file,
the Execute_Autorun_Config_Template.m is called as the main function of the autorun analysis. This calls one function for each module, depending on what pipeline the user
specified in the config file. 

Those module functions call the same functions the GUI uses to perform that action. The only things that are costume/modified is the creation of proper input arguments for those functions
based on the Config file. It sort of simulates the input possibilities of the GUI by tacking parameters from the config file. Additionally, there are helper functions like Execute_Autorun_Save_Figure.m to save analysis results and
Execute_Autorun_Set_Up_Folder.m to check the selected folder for proper contents.

IMPORTANT: The autorun analysis largely relies on the standard folder structure NeuroMod creates or supports natively to run smoothly:
1. If you select 'Save_Data', the data structure is automatically saved to 'Recording_Path/Matlab/Name_of_the_Recording.dat' (or whatever format was chosen).
2. If you select 'Load_Data', the data to load is searched in 'Recording_Path/Matlab/Name_of_the_Recording.dat' (or whatever format was chosen). 
3. If you select 'Save_for_Spike_Sorting', recording data is automatically saved to 'Recording_Path/Kilosort' or 'Recording_Path/SpikeInterface'
4. If you select 'Load_from_Spike_Sorting', it auto-searches Kilosort/SpiekInterface output files in 'Recording_Path/Kilosort/kilosort4' OR 'Recording_Path/Kilosort/kilosort3' OR 'Recording_Path/Kilosort/Mountainsort 5' OR 'Recording_Path/Kilosort/SpykingCircus 2'

-- Note:  When using the Kilosort user interface for spike sorting, dont change the standard output folder if you want NeuroMod to be able to auto-detect the results.
This means, that if you don't change any folder - or filenames created when saving/analyzing or exporting data, it can be automatically loaded when running an autorun config again without any effort! (or when laoding the spike sorting results into NeuroMod)

Adding your own module requires to add the option and parameters in the config files and add a main function for that module to the Execute_Autorun_Config_Template.m function when the pipeline name the user can select in the config file is detected.

*****************

General Remarks:

As for now, the autorun analysis still relies on NeuroMod, however, its only to start the autorun manager window. Of course it is possible with a few small changes to open that window completely independent of the main window (and without app windows in general).
