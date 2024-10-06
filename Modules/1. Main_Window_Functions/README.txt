______________________________________________
NeuroMod Toolbox; Main Window Functions README
Author: Tony de Schultz
______________________________________________


This folder contains all functions and app windows needed for the organization, initiation and functionality of the main window as well as extra utilities for other modules. 

*****************

General Remarks:

The individual folder contain the functions/apps for the respective aspect of the GUI specified in its name. The app windows saved here are of supportive nature (Support_Windows folder). 
This means they are only designated for the user to select or input a few parameters necessary without plotting or doing computations. 
They only organize data(sets) or capture info's about how to organize. 
The biggest and most complex support app saved here is the Manage_Modules_Window with its own folder (Manage_Modules_Functions)
holding functions executed when the user uses the Manage_Modules_Window.

*****************

Some functions are essential to the main window operation. Those are:

Folder Organize_Functions: 
1. Organize_Initialize_GUI - to initiate all necessary main window and data structure components when extracting, loading or preprocessing data
2. Organize_Prepare_Plot_and_Extract_GUI_Info - function that plots data and time in the main window

Folder Plot_Main_Window_Functions:
1. Module_MainWindow_Plot_Data - plots data in the main window (called in Organize_Prepare_Plot_and_Extract_GUI_Info)
2. Module_MainWindow_Plot_Time - plots time in the main window (called in Organize_Prepare_Plot_and_Extract_GUI_Info)

Folder Utility_Misc_Functions:
1. Utility_Get_Plot_Data - saves data to export plotted/analysed data from each window with the menu option to do so
   This function has its own support functions: Utility_Save_Data_as_MAT.m and Utility_Save_Data_as_TXT_CSV.m
2. Utility_Initialize_Clicks_Plots - intiates the ability to click the main window time and data plot and execute a function in response to that. This enables to jump in time when clicking the time plot
   Most other functions of this module handle the case the user clicks the plots (or the plotted lines in those plot - this has to be handled separately) and what to do.
3. Utility_SimpleCheckInputs: Checks if the inputs of numbers the user has to give are of the correct format.

IMPORTANT: All functions that are inherent to the GUI itself take the app object as input (especially Organize_Functions). All other functions 
are designed to be also used outside the app, i.e. the autorun functionality

TIP: The README files that save the commented function headers of all .m files in a folder are automatically created using the Utility_Extract_Function_Headers_to_txt.m function