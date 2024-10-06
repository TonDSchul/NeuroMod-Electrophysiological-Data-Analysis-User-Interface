______________________________________________
NeuroMod Toolbox; MISC README
Author: Tony de Schultz
______________________________________________

This folder contains permanently saved files usually not modified or if, then automatically in the 'Variables (do not edit)' folder.

Variables are:
1. 'CEDS64Path.mat' file, holding the path to the MATLAB Son Library for analysis of Spike2 data. 
This variable is autosaved and updated automatically if necessary.
2. Template_PlotAppearance.mat: saves to standrad plot appearances of the GUI (when the user resets to default, those are the settings taken) - read if no PlotAppearance.mat is saved (costume plot appearance)
3. Template_ModuleOrder.mat: saves default modules shown on startup of the main window. This is called when the user presses the button to reset module order to default. - read if no ModuleOrder.mat is saved (costume module order)

Optionally: 
1. PlotAppearance: saves the costume plot appearances the user saved. Only if they where modified and saved as new default
2. ModuleOrder: saves costume modules shown on startup of the main window the user selected and saves as new default. 


Also, there are files in the Default(do not edit!) folder containing templates for all standard configs available right out of the box, namely:

1. Autorun_Config_TEMPLATE_INTAN_DAT_Analysis
2. Autorun_Config_TEMPLATE_INTAN_RHD_Analysis
3. Autorun_Config_TEMPLATE_Neuralynx_Analysis
4. Autorun_Config_TEMPLATE_OPEN_EPHYS_Analysis
5. Autorun_Config_TEMPLATE_Spike2_Analysis

They should not be modified, since they serve as the default templates you can select when resetting a config file to default. 

This folder also contains the Logo and the pictures for the readme file and Licenses of other toolboxes.
