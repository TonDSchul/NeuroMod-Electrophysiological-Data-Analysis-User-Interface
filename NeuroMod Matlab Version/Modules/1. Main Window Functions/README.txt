______________________________________________
NeuroMod Toolbox; Main Window Functions README
Author: Tony de Schultz
______________________________________________


This folder contains all functions and app windows needed for the organization, initiation and functionality of the main window as well as extra utilities for other modules and windows. 

*****************

General Remarks:

The individual folder contain the functions/apps for the respective aspect of the GUI specified in its name. The app windows saved here are of supportive nature (Support_Windows folder). 
This means they are only designated for the user to select or specify a few parameters necessary without plotting or doing computations. The exception are 'Plot Main Window Functions' handling the main window data and time plot.


*****************

Contents:

1. Export Data: All functions related to exporting analysis results or dataset components. Hierarchy to export analysis results:
 1.1. Utility_Get_Plot_Data
 1.2  Utility_Save_Data_as_MAT, Utility_Save_Data_as_TXT_CSV, Utility_Save_Data_as_xlsx

2. Manage Modules: All functions and windows related to changing currently active modules or add new ones. 

3. Organize Functions: Functions to organize data structures and to organize functions handling main window functions with some general utilities that are useful:
 3.1. Organize_Convert_ActiveChannel_to_DataChannel: Convert active channel selection to data matrix indices
 3.2. Organize_Delete_All_Open_Windows: close all windows currently opened except of the main window
 3.3  Organize_Delete_Dataset_Components: delete a specific data component of the main window data structure.
 3.4. Organize_Initialize_GUI: Initializes all main window parameter needed to load a new recording or when 			       preprocessing was finished.
 3.5. Organize_Prepare_Plot_and_Extract_GUI_Info: handles all plotting components of main window data and time           
      plot as well as all live window analysis functions (since they update along with main window at    
      standard)
 3.6. Organize_Reset_Main_Plot: Specifically handles plot axis labels, colormaps and callback functions to be  
      able to interactively click the data/time plot of the main window. Comes after 
      Organize_Prepare_Plot_and_Extract_GUI_Info to initialize and handle these extra things
 3.7. Organize_Set_Standard_PlotAppearance: Saves all standard plotting parameters for every plot in all 
      windows, like linewidths, titles etc. This contains the standard values set when the user resets 
      the plot appearance. All plot appearances specified in this function (or when the user saved a custom 
      plot appearance in a app window), are saved as a .mat file in the MISC/Variables folder. 
      This .mat file is loaded upon starting NeuroMod to be able to load custom plot appearances. SO if you 
      add new plot appearances (new app windows) 
      delete this .mat file to create it again when NeuroMod is started! This is detected and done 
      automatically
 
4. Plot Main Window Functions: All functions related to main window data and time plot. Almost all are called in Organize_Prepare_Plot_and_Extract_GUI_Info.m

5. Probe View: All windows and functions handling the probe view window. Utility_Plot_Interactive_Probe_View.m    
   is the main function to plot/update the probe plot. ProbeViewClickCallback and ProbeViewClickLineCallback   
   are callback functions handling the user clicking on the probe. ProbeViewClickLineCallback handles 
   activating/inactivating active channel. Functions containing 'plot' in their name handle updating analysis 
   plots after changing active channel.

6. Support Windows: contains all app windows of supportive nature to select or set single parameter. Also  
   contains the app to export or delete dataset components. This includes:
   6.1. Menu_Extract_Data_Callback and Menu_Extract_Data_Load_Manually_Callback are callback 
        functions handling the user seleting a menu option in the extract data window.
   6.2  ButtonDown functions to handle clicks in the main window data and time plot.
   6.3  Utility_Change_Light_Dark_Mode.m: contains all components of all windows (edit fields, plots etc) to 
        set their color based on the selected color scheme. Necessary to make it look good in MATLAB dark mode
   6.4  Utility_Set_ToolTips: sets all tooltips across all NeuroMod windows
   6.5  Utility_Show_Info_Loaded_Data: used to display metadata in 'recording information' text area of the 
        main window (for example after preprocessing to update metadata being displayed)

IMPORTANT: Almost all functions that are inherent to the GUI itself and take the app object as input (especially Organize_Functions). All other functions 
are designed to be also used outside the app, i.e. the autorun functionality

TIP: The README files that save the commented function headers of all .m files in a folder are automatically created using the Utility_Extract_Function_Headers_to_txt.m function