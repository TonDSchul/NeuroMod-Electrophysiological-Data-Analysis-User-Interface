______________________________________________
NeuroMod Toolbox; Event Related Module README
Author: Tony de Schultz
______________________________________________

This Module contains app windows and functions to extract event data (ttl signals to your recording system) and accordingly event related data.
It also contains app windows and functions to preprocess event related data (artefact, trial and channel rejection), to analyse the LFP component of the event related data you extracted and to show event related spike analysis.

Event channel information can be extracted from every data format you can extract raw data from.

Neuralynx and Plexon event extraction is fully handled by fieldtrip, see: https://github.com/fieldtrip/fieldtrip. In the Extract_Events_Module_Extract_Events_Neuralynx.m (called in Extract_Events_Module_Main_Function.m when the user presses the even extraction button) the ft_read_header and ft_read_event functions are called.

For Open Ephys data formats the Open Ephys Analysis Tools are used, see: https://github.com/open-ephys/open-ephys-matlab-tools/tree/main. They are implemented and called through a costume compatibility function called 'Extract_Events_Module_Extract_Open_Ephys_Events.m'

For Spike2 Analysis, event ttl's are recording in one or more of the amplifier channel. The user has to select them when raw data is extracted. When extracting event data, the same scripts as for raw data extraction are called, just that all amplifier channel except of those with event data are deleted. 

For extracting event data from Intan recordings, the Intan_RHD2000_Data_Extraction function is used. It originally stems from Intan under: https://intantech.com/downloads.html?tabSelect=Software&yPos=0
The functions used can be found in the RHD/RHS File Utilities, Matlab File Readers options of that website. NOTE: This function was heavily modified to fit the purpose of this GUI!

Since all files except those from fieldtrip are modified OR require compatibility functions, updating the toolboxes will very probably lead to errors!

The Intan file format saves the event channel with (except specified otherwise) the same sampling rate as the amplifier channel. To get the indices of start of each event, the signal has to be thresholded. The same hold true for Spike2 recordings. Thresholding and indice extraction is handled by a costume function Extract_Events_Module_Extract_Event_Indicies_Intan.m.
Open Ephys and Neuralynx recordings however just save state changes, therefore no thresholding is necessary!
 
For the event related spike analysis, the spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes was used for one function. 
% Function is saved in: GUIPath/Modules/Toolboxes/Modified/Modified_Spike_Repository
These functions are modified to fit the purpose of the GUI  Continous_Spikes_Manage_Analysis_Plots.m function:

1. plotDriftmap

For the event spike analysis, one window is used independent of the type of sorter or spike data present. 
Some functions necessary to run this window are located in the Spike Module! They are shared over continuous and event spike analysis.

*****************

General Remarks:

When the "Extract Events and Data" window opens, it auto-searches the folder, the raw data was extracted from (saved in Data.Info) to find event channel data. If this folder is no longer present, you have to select the folder holding your event channel data manually. 

Extracting events and event related data creates the data structures Data.Events and Data.EventRelatedData.

Spike Analysis and Unit Analysis windows and functions are saved in the Spike_Module!!

Each folder in this module contains one (or more) app windows for the respective functionality as well as a folder called "Functions" with all main functions necessary for this module.
Each analysis the user can pick in this module is made out of an app window that is called in the main window when the user clicks in RUN of this module. 
NOTE: Some functionalities for running the app windows require utility and organize functions from the "1. Main_Window_Functions" folder.

All necessary functions for event extraction and event data analysis are designed in a way that you can also use them outside the GUI. You just have to specify the parameters of the app window manually. See AutorunConfig variable in the Autonrun_Config files.
The following workflows stem from the GUI. What is used outside the GUI is specified. The autorun functionality involves all aspects of the Toolbox possible and feasible to do outside of the GUI. Refer to those functions to get into more detail.

*****************

Event Extraction always goes according to this pipeline: 

1.  Extract_Events_Module_Determine_Available_EventChannel -- Searches in folder with raw recording (or manually   
    specified folder) for event files of the supported file formats.
    If it finds them, the app window is populated automatically with the info's found.

2.  Extract_Events_Module_Main_Function -- main function that takes the output of 
    Extract_Events_Module_Determine_Available_EventChannel as well as user specified input in the event
    window which events to extract with which threshold and so on. According to the file format found in 
    Extract_Events_Module_Determine_Available_EventChannel it calls 
    the right function for that format.

	
    The remaining function are for housekeeping of the extract events window, for autodetecting formats and for 
    showing the raw event channel data extracted:

3. Utility_Show_Info_Loaded_Data
4. Organize_Prepare_Plot_and_Extract_GUI_Info


*****************

Workflow for Spike Analysis:

Continous and Event Spike Analysis have separate app windows. Each window uses the Spike_Module_Set_Up_Spike_Analysis_Windows to set up app window components.

Workflow for Event Spike Analysis: 
1. Event_Spikes_Prepare_Plots
2. Either Events_Internal_Spikes_Manage_Analysis_Plots OR Events_Kilosort_Spikes_Manage_Analysis_Plots, depending on whether spike data is from kilosort or internal spike detection

