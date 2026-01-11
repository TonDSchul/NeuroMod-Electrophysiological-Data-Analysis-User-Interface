______________________________________________
NeuroMod Toolbox; MISC README
Author: Tony de Schultz
______________________________________________

The 'Variables (do not edit)' folder contains permanently saved files usually not modified or if, then automatically in the 'Variables (do not edit)' folder.

Variables are:
1. 'CEDS64Path.mat' file, holding the path to the MATLAB Son Library for analysis of Spike2 data. 
This variable is autosaved and updated automatically if necessary.
2. PlotAppearance: saves the costume plot appearances the user saved. Only if they where modified and saved as new default
3. ModuleOrder: saves costume modules shown on startup of the main window the user selected and saves as new default. 
4. Python_Conda_Path.mat: saves the path to the python.exe for the conda environment SpikeInterface is installed in
5. ShowToolTipsSetting.mat: saves whether tooltips should be shown for next startup
6. SavedColorScheme.mat: saves the GUI colorscheme (light/dark;dark/light) that is loaded when the GUI is opened
7. Example_Events.csv: example file containing 50 trigger times in samples to load into the 'Import Trigger Times'
8. Example_Events.txt: example file containing 50 trigger times in samples to load into the 'Import Trigger Times'
9. ExampleTriggerIdentities.txt: example file containing trigger identities for trigger. This can be loaded in the 'Extract Trigger Times' to divide a single event channel with 50 triggers into two different event channel called T1 and T2 (see text file contents) with 25 trigger each
10. NEO_Python_Conda_Path.mat: saves path to anaconda environment in which NEO was installed
11. Phy_Python_Conda_Path.mat: saves path to anaconda environment in which Phy2 was installed

---------------------- Take these example files as reference for the expected format! ------------------


Also, there are files in the 'Default Autorun Configs (do not edit!)' folder containing templates for all standard configs available right out of the box, namely:

1. Autorun_Config_TEMPLATE_INTAN_DAT_Analysis
2. Autorun_Config_TEMPLATE_INTAN_RHD_Analysis
3. Autorun_Config_TEMPLATE_Neuralynx_Analysis
4. Autorun_Config_TEMPLATE_OPEN_EPHYS_Analysis
5. Autorun_Config_TEMPLATE_Spike2_Analysis
6. Autorun_Config_TEMPLATE_Plexon_Analysis
7. Autorun_Config_TEMPLATE_TDT_Analysis
8. Autorun_Config_TEMPLATE_Maxwell_MEAH5_Analysis

The 'docs' folder contains example python script to load the formats NeuroMod offers to save into the python toolboxes NEO, pynwb and SpikeInterface

Those are the standard/default config files you can reset the currently selected config file to in the autorun window 

The 'Images' folder contains the Logo and the pictures for the readme file while the 'LICENCES' folder contains  Licenses of all other toolboxes used.
