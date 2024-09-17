______________________________________________
NeuroMod Toolbox; Manage Dataset Module README
Author: Tony de Schultz
______________________________________________

Extract_Data_Window.mlapp is the main window for extracting data.
Probe_Layout_Window.mlapp and Probe_Layout_Window.mlapp are called within this window if the user clicks on the respective button

The Main Function to manage dataset extraction from all file formats is called 'Manage_Dataset_Module_Extract_Raw_Recording_Main.m' (in the Functions folder)
From there, functions for the specific file format detected are called.

NOTE: The extract recordings main window always checks the selected folder for the a supported recording file format. So if you select a
folder and see the proper content in the app window text area, it was succesfully detected as one of the supported formats.