______________________________________________
NeuroMod Toolbox; Main Plot Analysis Module README
Author: Tony de Schultz
______________________________________________

This Module contains app windows and functions to analyze the data shown in the main app window data plot.

*****************

Remarks about how the app windows and functions in this module are used by NeuroMod:

Each folder in this module contains one (or more) app windows for the respective functionality as well as a folder called "Functions" with all main functions necessary for this module. This folder also contains the RUN_Main_Plot_Analysis_Module.m function that is executed when the user clicks on the RUN button for this module. It manages which windows open based on what option is selected in the list to the left of the RUN button.

Each analysis the user can pick in this module is made out of an app window that is called in the main window when the user clicks in RUN of this module.

In this newly opened app window, the Organize_Prepare_Plot_and_Extract_GUI_Info.m function is called, responsible for preparing data to be plotted in the main window data plot and also takes care of all four analysis methods of this module (since they are updated simultaneously by default)

For this purpose, the individual app window handles are saved as public properties of the main window so that the main window can access the analysis app objects, like the channel selection and the figure axes. (This holds true for every NeuroMod windows)

*****************

General Remarks:

All functions of this module to analyze and plot data are designed in a way to work outside the GUI (no app object required as input). However, the high level function calling 
the analysis and plot functions with the correct input arguments is the Organize_Prepare_Plot_and_Extract_GUI_Info.m function, which requires the app object of the main window.
To be able to use functions of this module outside the GUI, you have to go into the Organize_Prepare_Plot_and_Extract_GUI_Info.m function, copy the code portions handling the module aspect you want to use and organized the necessary input arguments yourself.

NOTE: The Analysis functions all take a variable called CurrentPlotData as input and output. This saves the analysis results in case the user wants to export them. Standard folder to save 
exported data is 'GUI_Path/Analysis Results'
They also take a variable called PlotAppearances as an input, saving the appearance of plotted components the user can change.

Since the CSD, power estimate, spike rate and phase analysis windows depend on the probe view active channel selection, the analysis and plotting functions are also found in the probe view window functions.
