______________________________________________
NeuroMod Toolbox; Event Related Module README
Author: Tony de Schultz
______________________________________________

IMPORTANT: All functions are designed in a way to work outside the GUI (no app pbject required as input).

NOTE: Spike Analysis and Unit Analysis windows and functions are saved in the Spike_Module!!

NOTE: The Analysis functions all take CurrentPlotData as input and output. This saves the anaysis results in case the user wants to export them.

This Module contains app windows and functions to extract event data (ttl signals to your recording system) and accordingly event related data.
It also contains app windows and functions to preprocess event related data (artefact, trial and channel rejection) and to analyse the LFP component of the event related data.

Event Extraction always goes according to this pipeline: 

1.  Extract_Events_Module_Determine_Available_EventChannel -- Searches in folder with raw recording (or manually specified folder) after event files of the supported file formats.
    If it finds them, it saves the indicie in  the corresponding folder components for the Extract_Events_Module_Main_Function function.
    Note: Outputs [app.EventInfo,FileEndingsExist,FilePaths,texttoshow,Info]; 

2.  Extract_Events_Module_Main_Function -- main function that takes the output of Extract_Events_Module_Determine_Available_EventChannel as well as user specified input in the event
    window which events to extract with which treshold and so on. According to the file fromat found in Extract_Events_Module_Determine_Available_EventChannel it calls 
    the right functiojn for that format.

    All Neuralynx and Plexon event data is extracted from raw data files using the fieldtrip toolbox, see https://github.com/fieldtrip/fieldtrip. 
    Used Fieldtrip functions:
    ft_read_event
    ft_read_header
    in the Extract_Events_Module_Extract_Events_Neuralynx.m function 

    All Intan Recording event data is extracted using the the Intan_RHD2000_Data_Extraction function. It originally stems from Intan under: https://intantech.com/downloads.html?tabSelect=Software&yPos=0
    Used are the RHD/RHS File Utilities, Matlab File Readers. NOTE: This function was heavily modified to fit the prupose of this GUI!
    NOTE: This function only extracts raw event data. Thresholding and indicie extraction is handled by a costum function (Extract_Events_Module_Extract_Event_Indicies_Intan.m)
    
    All Open Ephys event data is extracted using the Open Ephys Analysis Tools, see: https://github.com/open-ephys/open-ephys-matlab-tools/tree/main. 
    They are implemented and called through a costum compatibility function called 'Extract_Events_Module_Extract_Open_Ephys_Events.m'
    
    Spike 2 raw event data is extracted using the Spike2 MATLAB SON Interface from: https://ced.co.uk/upgrades/spike2matson
    Thresholding and indicie extraction is handled by a costum function (Extract_Events_Module_Extract_Event_Indicies_Intan.m)

    The remaining function are for housekeeping of the extract events window, for autodetecting formats and for showing the raw event channel data extracted.

Optionally (for GUI): 

3. Utility_Show_Info_Loaded_Data
4. Organize_Prepare_Plot_and_Extract_GUI_Info