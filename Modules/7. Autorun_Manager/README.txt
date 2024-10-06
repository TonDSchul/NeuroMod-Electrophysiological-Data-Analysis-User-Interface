______________________________________________
NeuroMod Toolbox; Autorun Manager README
Author: Tony de Schultz
______________________________________________

This module contains all functions and app windows to perform the autorun analysis. When the user selected folder and probe information in the autorun window and starts the selected autorun config file,
the Execute_Autorun_Config_Template.m is called as the main function of the autorun analysis. This calls one function for each module, depending on what pipeline the user
specified in the config file. 

Those module functions call the same functions the GUI uses to perfrom that action. The only things that are costume/modified is the creation of proper input arguments for those functions
based on the Config file. It sort of simulates the input possibilities of the GUI by tacking parameters from the config file. Additionally, there are helper functions like Execute_Autorun_Save_Figure.m to save analysis results and
Execute_Autorun_Set_Up_Folder.m to check the selcted folder for proper contents.

IMPORTANT: The autorun analysis largely relies on the standard folder strcuture the GUI creates or supports natively to run smoothly:
1. If you select 'Save_Data', the data structure is automatically saved to 'Recording_Path/Matlab/Name_of_the_Recording.dat'.
2. If you select 'Load_Data', the data to load is searched in 'Recording_Path/Matlab/Name_of_the_Recording.dat'. 
3. If you select 'Save_for_Kilosort', data is automatically saved to 'Recording_Path/Kilosort'
4. If you select 'Load_from_Kilosort', it auto searches kilosort output files in 'Recording_Path/Kilosort/kilosort4' OR 'Recording_Path/Kilosort/kilosort3'. 
-- Note: for Kilosort 3 you might have to modify the output foldername if not done in the Kilosort GUI, otherwise the foldername might not be kilosort3.

This means, that if you dont change any folder - or filenames created when saving/analysing or exporting data, it can be automatically loaded when running an autorun config again without any effort!

Adding your own module requires to add the option and parameters in the config files and add a main function for that module to the Execute_Autorun_Config_Template.m function when the pipeline name the user can select in the config file is detected.

*****************

General Remarks:

As for now, the autorun analysis still relies on the GUI, however, its only to start the autorun manager window. Of course it is possible with a few small changes to open that window completely indepenent of the main window. 
