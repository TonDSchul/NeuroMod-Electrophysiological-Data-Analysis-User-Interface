______________________________________________
NeuroMod Toolbox; Manage Plot Analysis Module README
Author: Tony de Schultz
______________________________________________

IMPORTANT: All functions are designed in a way to work outside the GUI (no app pbject required as input). However, the High level function calling 
those analyis functions with the correct input arguments is the Organize_Prepare_Plot_and_Extract_GUI_Info.m function,which requires the app object of the main window.
The main app window has a public peroperty saving the analysis window components of this module to extract the necessary inputs.
To be able to use outside the window, you have to organize/create the input arguments yourself.

This Module contains app windows and functions to analyse the data shown in the main app window data plot.
Each analysis is made out of an app window that is called in the main window when the user clicks in RUN of this module. 
In this newly opened app window, the Organize_Prepare_Plot_and_Extract_GUI_Info.m function is called. This function is responsible for preparing data 
to be plotted in the main window data plot and also takes care of all three analysis methods in this module. 

For this purpose, the app window handles in this module are saved as public properties of the main window so that the main window can acess the 
analyis app objects, like the channel selection and the figure axes.

NOTE: The Analysis functions all take CurrentPlotData as input and output. This saves the anaysis results in case the user wants to export them.