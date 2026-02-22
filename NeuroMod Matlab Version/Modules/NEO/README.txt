______________________________________________
NeuroMod Toolbox; NEO README
Author: Tony de Schultz
______________________________________________

This folder contains all custom python scripts to run NEO based data extraction. 

LoadWithNeo.py is the main function that is executed - and loads a .json file with all parameter for the script like the selected folder from the MATLAB 'Extract Data' window. It runs the individual functions for individual pipeline parts defined in the Neo_FunctionDeclaration.py function. Every script uses the neo library. 

In order to be able to execute a python script via MATLAB, a path for the python.exe file in the environment in which NEO is installed has to be provided. 

NEO loads the recording in the folder specified along with event data and saves amplifier data as NEO_Saved_Channel_Data.dat, event data as NEO_Saved_EventData.mat and meta data as NEO_Saved_MetaData.mat in a folder called 'RecordingName Neo SaveFile' within the parent folder of the recording folder.

This is done because format detection by neo can be hindered by custom files and folders in the recording folder.

The saved files containing recording data get loaded automatically into MATLAB after the neo script finished and the console was closed (and the user pressed enter in the MALTAB command window if selected to let the python console stay open).
