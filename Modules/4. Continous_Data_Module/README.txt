______________________________________________
NeuroMod Toolbox; Continous Data Module README
Author: Tony de Schultz
______________________________________________

This module is concerned with preprocessing and analysing the static spectrum of continuous data. When preprocessing is finished, it adds the field 'Preprocessed' to the dataset. 
When the Preprocessed field is already part of the dataset, it gets overwritten by the new pipeline. 

All Preprocessing steps involving filtering (high pass, low pass, band stop, narrowband and median filtering) are handled by fieldtrip, see: https://github.com/fieldtrip/fieldtrip.
The respective fieldtrip functions are unmodified and called in the Preprocess_Module_Apply_Pipeline.m function. 

Used functions from fieldtrip are: 
1. ft_preproc_lowpassfilter
2. ft_preproc_highpassfilter
3. ft_preproc_bandpassfilter
4. ft_preproc_bandstopfilter
5. ft_preproc_medianfilter

For the static power spectrum analysis, the spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes was used. 
% Functions are saved in: GUIPath/Modules/Toolboxes/Modified/Modified_Spike_Repository
These functions are modified to fit the purpose of the GUI

They are called in the Continous_Power_Spectrum_Over_Depth.m function:

1. lfpBandPower
2. plotLFPpower

*****************

General Remarks:

Using the 'Cut Time' and 'Channel Deletion' function modifies both raw and preprocessed data, so this step can not be reversed !!

Power spectrum data is only computed once for raw and preprocessed data (depending on if the user selects prepro data in the static spectrum window)
and then saved as a public property of the main window, so that it does not has to be computed again when the window is closed and opened again. 

Each folder in this module contains one (or more) app windows for the respective functionality as well as a folder called "Functions" with all main functions necessary for this module.
Each analysis the user can pick in this module is made out of an app window that is called in the main window when the user clicks in RUN of this module. 
NOTE: Some functionalities for running the app windows require utility and organize functions from the "1. Main_Window_Functions" folder.

All necessary functions for preprocessing and computing/plotting the static spectrum are designed in a way that you can also use them outside the GUI. You just have to specify the parameters of the app window manually. See AutorunConfig variable in the Autonrun_Config files.
The following workflows stem from the GUI. What is used outside the GUI is specified. The autorun functionality involves all aspects of the Toolbox possible and feasible to do outside of the GUI. Refer to those functions to get into more detail.

*****************

Workflow for preprocessing data: 

1.  Preprocess_Module_Construct_Pipeline -- add pipeline components like filters including their settings. can be filled with multiple prepro steps
2.  Preprocess_Module_Delete_Old_Settings -- deletes info about previous prepro steps if their were applied. (in Data.Info)
3.  Preprocess_Module_Set_Filter_Parameter -- sets all prepro paramemter based on user input to be readable for the Preprocess_Module_Apply_Pipeline function
4.  Preprocess_Module_Apply_Pipeline -- applies prepro steps specified in Preprocess_Module_Construct_Pipeline with the according parameters

Optionally (for GUI):
 
4. Utility_Show_Info_Loaded_Data(app.Mainapp) -- show new prepro settings in the recording info text box in the main window
5. Organize_Initialize_GUI -- organizes GUI and data components like prepro check boxes
6. Organize_Prepare_Plot_and_Extract_GUI_Info -- Plot Prepro Data/ Raw Data in main window

Workflow for analysing and plotting static spectrum: 

1. Analyse_Main_Window_Static_Power_Spectrum -- computes spectrum with pwelch either over a single channel or over the mean of all channel.
1. Continous_Power_Spectrum_Over_Depth -- computes spectrum over depth (from the spike repository of the Cortex Lab Github page)

