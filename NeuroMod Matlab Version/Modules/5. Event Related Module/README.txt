______________________________________________
NeuroMod Toolbox; Event Related Module README
Author: Tony de Schultz
______________________________________________

This Module contains app windows and functions to extract event data (TTL signals to your recording system) and accordingly event related data.
It also contains app windows and functions to preprocess event related data (artefact, trial and channel rejection), to analyse the LFP component of the event related data you extracted and to show event related spike analysis.

Event channel information can be extracted from every data format you can extract raw data from.

Neuralynx event extraction is fully handled by fieldtrip, see: https://github.com/fieldtrip/fieldtrip. In the Extract_Events_Module_Extract_Events_Neuralynx.m (called in Extract_Events_Module_Main_Function.m when the user presses the even extraction button) the ft_read_header and ft_read_event functions are called.

For Open Ephys data formats the Open Ephys Analysis Tools are used, see: https://github.com/open-ephys/open-ephys-matlab-tools/tree/main. They are implemented and called through a costume compatibility function called 'Extract_Events_Module_Extract_Open_Ephys_Events.m'

For Spike2 Analysis, event TTL's are recorded as a amplifier channel. The user has to select them when raw data is extracted. When extracting event data, those amplifier channel are loaded and thresholded to find TTL time stamps.

For extracting event data from Intan recordings, the Intan_RHD2000_Data_Extraction function is used. It originally stems from Intan under: https://intantech.com/downloads.html?tabSelect=Software&yPos=0
The functions used can be found in the RHD/RHS File Utilities, Matlab File Readers options of that website. NOTE: This function was heavily modified to fit the purpose of this GUI!

Since all files except those from fieldtrip are modified OR require compatibility functions, updating the toolboxes will very probably lead to errors!

The Intan file format saves the event channel with (except specified otherwise) the same sampling rate as the amplifier channel. To get the indices of start of each event, the signal has to be thresholded. The same hold true for Spike2 recordings. Thresholding and indices extraction is handled by a costume function Extract_Events_Module_Extract_Event_Indicies_Intan.m.

Open Ephys and Neuralynx recordings however just save state changes, therefore no thresholding is necessary! The same holds true for every format extracted with NEO.
 
For some aspects of the event related spike analysis, the spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes was used for one function. 
% Function is saved in: GUIPath/Modules/Toolboxes/Modified/Modified_Spike_Repository
These functions are modified to fit the purpose of the GUI  Continous_Spikes_Manage_Analysis_Plots.m function:

1. plotDriftmap

For the event spike analysis some functions necessary to run this window are located in the Spike Module! This is because they are shared over continuous and event spike analysis.

*****************

General Remarks:

Event related data is extracted 'on-the-fly' every time the user selects an event related analysis or changes a parameter that requires to compute it again (like changing the event channel from which it is extracted). After extraction it is saved as Data.EventRelatedData. Even when its already present and based on the same settings that a newly opened window has, it is computed again. The same holds true for preprocessed event related data.

When the "Extract Trigger Times" window opens, it auto-searches the folder, the raw data was extracted from (saved in Data.Info) to find event channel data. If this folder is no longer present, you have to select the folder holding your event channel data manually. 
If you have only one event input channel in which different triggers represent different events (like different tones being played) you can load custom trigger identities saved in a .txt or .csv file. With this you can divide the one event channel into as many trigger identities as are truly present. For information about the required format in which event times have to be saved, see the window opening when clicking the 'Load Costume Trigger Identities' button (menu on top)!!! Example files are also saved under Modules/MISC/docs.

The "Import Trigger Times" is structure the same way as the "Extract Trigger Times" window just with a simpler function to save event data since it only has to be read from a .txt or .mat file. For information about the required format in which event times have to be saved, see the window opening when clicking the 'Select File' button!!! Example files are also saved under Modules/MISC/docs.

Extracting events and event related data creates the data structures Data.Events and Data.EventRelatedData repectively. Data.EventRelatedData is computed on the fly every time a window analysis/plotting event data is opened. This is so that the user can select the event channel from inside these windows. However, ones it is not deleted after the windows close to be able to properly export results.

Each folder in this module contains one (or more) app windows for the respective functionality as well as a folder called "Functions" with all main functions necessary for this module. This folder also contains the RUN_Event_Data_Module.m function that is executed when the user clicks on the RUN button for this module. It manages which windows open based on what option is selected in the list to the left of the RUN button.

Each analysis the user can pick in this module is made out of an app window that is called in the main window when the user clicks in RUN of this module. 
NOTE: Some functionalities for running the app windows require utility and organize functions from the "1. Main_Window_Functions" folder.

All necessary functions for event extraction and event data analysis are designed in a way that you can also use them outside the GUI. You just have to specify the parameters of the app window manually. See AutorunConfig variable in the Autonrun_Config files.
The following workflows stem from the GUI. What is used outside the GUI is specified. The autorun functionality involves all aspects of the GUI possible and feasible to do outside of the GUI. Refer to those functions to get into more detail.

*****************

Event Extraction always goes according to this pipeline: 

1.  Extract_Events_Module_Determine_Available_EventChannel -- Searches in folder with raw recording (or    
    manually specified folder) for event files of the supported file formats.
    If it finds them, the app window is populated automatically with the info's found.

2.  Extract_Events_Module_Main_Function -- main function that takes the output of 
    Extract_Events_Module_Determine_Available_EventChannel as well as user specified input in the event
    window which events to extract with which threshold and so on. According to the file format found in 
    Extract_Events_Module_Determine_Available_EventChannel it calls 
    the right function for that format.
	
    The remaining function are for housekeeping of the extract events window, for autodetecting formats and for 
    showing the raw event channel data extracted:

3. Utility_Show_Info_Loaded_Data - update Data.Info with new information gathered from this window (like eventchannelnames).
4. Organize_Set_MainWindow_Dropdown - reorganize main window dropdown menus
5. Organize_Reset_Main_Plot -- Plot Prepro Data/ Raw Data in main window
6. Organize_Delete_All_Open_Windows - closes all opened windows

*****************

Workflow for Spike Analysis:

Continous and Event Spike Analysis have separate app windows. Each window uses the Spike_Module_Set_Up_Spike_Analysis_Windows to set up app window components.

Workflow for Event Spike Analysis: 
1. Event_Spikes_Prepare_Plots
2. Event_Spikes_Extract_Event_Related_Spikes
3. Further analysis functions
