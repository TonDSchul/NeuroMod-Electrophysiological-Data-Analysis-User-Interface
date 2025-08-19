______________________________________________
NeuroMod Toolbox; Manage Dataset Module README
Author: Tony de Schultz
______________________________________________

This module handles all amplifier data extraction aspects for the supported file formats as well as saving and loading the toolbox intern dataset.
It also contains the functions checking for file formats and preparing data extraction or loading.
This module cannot be switched with another modules since its essential!

*****************

Remarks about extraction of raw amplifier data from supported recording formats:

Neuralynx data extraction for the internal MATLAB Library is fully handled by fieldtrip, see: https://github.com/fieldtrip/fieldtrip. In the data extraction window the ft_read_header and ft_read_data functions are called with the folder and file the user selected.

For Open Ephys data formats the Open Ephys Analysis Tools are used, see: https://github.com/open-ephys/open-ephys-matlab-tools/tree/main. They are implemented and called through a costume compatibility function called 'Open_Ephys_Load_All_Formats.m'

For Spike2 Analysis, the user is required to install the Spike2 MATLAB SON Interface from: https://ced.co.uk/upgrades/spike2matson

For the Tucker Davis Tank Data format, the TDTMatlabSDK from GitHub is used
https://github.com/tdtneuro/TDTMatlabSDK

For extracting data from Intan recordings, the Intan_RHD2000_Data_Extraction function is used. It originally stems from Intan under: https://intantech.com/downloads.html?tabSelect=Software&yPos=0
The functions used can be found in the RHD/RHS File Utilities, Matlab File Readers options of that website. NOTE: This function was heavily modified to fit the purpose of this GUI!

Since all files except those from fieldtrip are modified OR require compatibility functions, updating the individual toolbox files in this GUI will very probably lead to errors!

*****************

When using the NEO python library, MATLAB calls a function called LoadWithNeo.py within the folder 'Path_to_NeuroMod/Modules/NEO with a few input arguments like the folder location selected and whether to use auto detection of formats with NEO. After a folder is selected, the format of files within is autodetected in MATLAB to ensure the current NEO implementation into NeuroMod actually supports that format. After NEO extracted raw data from a recording, the resulting NEO object with its relevant contents for NeuroMod are saved in separate files in a new folder next to the recording folder. Those are then loaded into NeuroMod after the python script finished and can be used in the extract raw recordings window to load the recording again without having to call NEO and actually extracting the recording again.

NOTE: For NEO to recognize your recording format, especially with the NEO autodetection, the original recording folder and file structure has the be preserved! Additional folder or files will most likely cause NEO to not be able to recognize your recording!

*****************

Remarks about the folder structure when saving or loading data:

1. For saving and loading data, the standard folder structure is 'Path_to_GUI/Recording Data/Saved GUI Data'. GUI data saved there is autodected on startup of the load data window and can be immediately loaded. 
NOTE: When saving GUI data in 'Your_Recording_Path/Matlab/Name_Of_Recording_Folder.dat' will enable you to load the saved data in the autorun functionality without any additional effort later on! The same holds true for all other formats you can save data in. All dataformats saved in NeuroMod can also be loaded back into NeuroMod!
NOTE: Make sure to not rename the created files since this can cause NeuroMod to not properly recognize them! Also make sure that if multiple files are saved for a recording (like a .dat for channel data and .mat file for meta data) all of them remain in the same folder to be able to load again later!

2. The Loading Data Window will auto-search the folder 'Path_to_GUI/Saved GUI Data' for saved files. Saving GUI data there ensures you can quickly load it without having to select a folder. 

*****************

General Remarks:

Each folder in this module contains one (or more) app windows for the respective functionality as well as a folder called "Functions" with all main functions necessary for this module.
Each analysis the user can pick in this module is made out of an app window that is called in the main window when the user clicks in RUN of this module. 

NOTE: Some functionalities for running the app windows require utility and organize functions from the "1. Main Window Functions" folder.
All necessary functions for data extraction, loading or saving are designed in a way that you can also use them outside the GUI. You just have to specify the parameters of the app window manually. See AutorunConfig variable in the Autonrun_Config files.
The following workflows stems from the GUI. What is used outside the GUI is specified. The autorun functionality involves all aspects (i.e. functions) of this GUI possible and feasible to do outside of the GUI. Refer to those functions to get more details.

__________________________
GUI workflow for loading saved GUI data:

-- to check data formats in the fodler:
Manage_Dataset_Module_LoadGUIDataCheckFolderContents

-- not used outside of GUI, just to initiate all GUI main window aspects:
[app.Mainapp] = Organize_Initialize_GUI (app.Mainapp,"Initial"); 
--
-- Main function for loading toolbox intern data:
[app.Mainapp.Data] = Manage_Dataset_Module_Load_NeuroModData(Format,FullPathData,FullPathInfo,app.TextArea); 
OR 
Manage_Dataset_Module_Load_NWBFile
OR 
Manage_Dataset_Module_Load_SpikeInterface
OR 
Manage_Dataset_Module_Load_NeoMatData
--
-- not used outside of GUI, just to initiate all GUI main window aspects:
[app.Mainapp] = Organize_Initialize_GUI (app.Mainapp,"Loading"); 
--
-- Plots time and data in the main window, not used in autorun config:
Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp,1,"Initial","Static",app.Mainapp.PlotEvents,app.Mainapp.Plotspikes); 

__________________________
GUI workflow for saving data:

-- Saves data components selected in the app.Whattosave variable:
Manage_Dataset_Module_SaveData(app.Mainapp.Data,app.SaveTypeDropDown.Value,app.Whattosave,app.Mainapp.executableFolder,"No");
OR
Manage_Dataset_SaveData_NeoMAT
OR
Manage_Dataset_SaveData_NWB
and within this function: Manage_Dataset_SavedData_ExportProbeToJSON
OR
Manage_Dataset_SaveData_SpikeInterfaceNumpy

% Side Note: Whattosave is a 1x6 double vector, each element stands for a data component. 1 means its saved, 0 means its not. This is the same when you configure the autorun configuration and wajnt to save your dataset

__________________________         
GUI Workflow Extracting Raw Data (with MATLAB internal library):

-- not used outside of GUI, just to initiate all GUI main window aspects:
[app.Load_Data_Window_Info.Mainapp] = Organize_Initialize_GUI (app.Load_Data_Window_Info.Mainapp,"Initial"); 
--
-- Main Function to Extract Data
[Data,HeaderInfo,SampleRate,RecordingType,Time] = Manage_Dataset_Module_Extract_Raw_Recording_Main(app.RecordingSystemDropDown.Value,app.FileTypeDropDown.Value,app.Load_Data_Window_Info.selectedFolder,app.TextArea,app.Load_Data_Window_Info.Mainapp.executableFolder);
--
-- initiate all aspects of the GUI dataset and variables after extracting data, not used in autorun config:
[app.Load_Data_Window_Info.Mainapp] = Organize_Initialize_GUI (app.Load_Data_Window_Info.Mainapp,"VariableDefinition",Data,HeaderInfo,SampleRate,app.Load_Data_Window_Info.selectedFolder,RecordingType,0,Time,app.Load_Data_Window_Info.ChannelSpacing); -- not used outside of GUI
-- 
-- Apply channel order if the user selected one
[app.Load_Data_Window_Info.Mainapp.Data] = Manage_Dataset_Module_Apply_ChannelOrder (app.Load_Data_Window_Info.Mainapp.Data,app.Load_Data_Window_Info.Channelorder);
--
-- Initialize Info's for Main Window based on extracted and saved variables (previous call of this function), not used in autorun config:
[app.Load_Data_Window_Info.Mainapp] = Organize_Initialize_GUI (app.Load_Data_Window_Info.Mainapp,"Extracting"); -- not used outside of GUI
--
-- Plots time and data in the main window, not used in autorun config:
Organize_Prepare_Plot_and_Extract_GUI_Info(app.Load_Data_Window_Info.Mainapp,1,"Initial","Static",app.Load_Data_Window_Info.Mainapp.PlotEvents,app.Load_Data_Window_Info.Mainapp.Plotspikes); -- not used outside of GUI
            