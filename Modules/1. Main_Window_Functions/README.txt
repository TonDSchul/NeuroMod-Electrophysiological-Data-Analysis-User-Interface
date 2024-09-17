______________________________________________
NeuroMod Toolbox; Main Window Functions README
Author: Tony de Schultz
______________________________________________

This folder contains all functions and app windows needed for the organization, intitiation and functionality of the main window as well as 
extra utilities for other Modules. 
The folder contain the functions for the respective aspect of the GUI. The app windows saved here are of supportive nature. This means they are
only designated for the user to select or input one specific parameter at once. They only organize data(sets) or capture infos about how to organize.
Nothing is computed.

To plot raw data, preprocessed data, spikes or events in the main window data plot or update the main window time plot, call the 
Organize_Prepare_Plot_and_Extract_GUI_Info.m function. 

IMPORTANT: All functions that are inherent to the GUI itself take the app object as input (especially Organize_Functions). All other functions 
are designed to be also used outside the app, i.e. the autorun functionality