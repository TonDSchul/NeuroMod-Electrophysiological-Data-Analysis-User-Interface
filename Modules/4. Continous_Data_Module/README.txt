______________________________________________
NeuroMod Toolbox; Continous Data Module README
Author: Tony de Schultz
______________________________________________

All Preprocessing steps involving filtering (high pass, low pass, band stop, narrwoband and median filtering) are handled by fieldtrip, see: https://github.com/fieldtrip/fieldtrip.
The respective fieldtrip functions are unmodfied and called in the Preprocess_Module_Apply_Pipeline.m function. 

Preprocessing always goes according to this pipeline: 

1.  Preprocess_Module_Construct_Pipeline -- add pipeline components like filters including their settings. can be filled with multiple prepro steps
2.  Preprocess_Module_Delete_Old_Settings -- deletes info about previous prepro steps if their were applied. (in Data.Info)
3.  Preprocess_Module_Apply_Pipeline -- applies prepro steps specified in Preprocess_Module_Construct_Pipeline with the according parameters

Optionally (for GUI):
 
4. Utility_Show_Info_Loaded_Data(app.Mainapp) -- show new prepro settings in the recording info text box in the main window
5. Organize_Initialize_GUI -- organizes GUI and data compontens like prepro check boxes
6. Organize_Prepare_Plot_and_Extract_GUI_Info -- Plot Prepro Data/ Raw Data in main window

For the Static Power Spectrum the Spike repository from the Cortex Lab on Github at https://github.com/cortex-lab/spikes was used. 
% They are saved in: GUIPath/Modules/6.Spike_Module/Spike_Analysis/Modified_Spike_Repository
These functions are modified to fit the purpose of the GUI

- Power Spectrum Data is only computed once for raw and preprocessed data (depending on if the user selects prepro data in the static spectrum window)
 and then saved, so that it does not has to be computed again. 