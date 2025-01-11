______________________________________________
NeuroMod Toolbox; Example Module README
Author: Tony de Schultz
______________________________________________

This is an example folder you can use to implement your own module in the toolbox. It is also the origin of the example module that can be selected in the 'Manage Modules' window. It contains an example app window with just the backbone needed to access the whole dataset and do an example plot. The folder also contains a RUN_ function, which specifies the app window that should be opened, when the user clicks on the 'RUN' button for your module in the main window. The Functions folder contains all functions necessary for the app window(s) of this module to work. 

Note: To implement your own module into the GUI and make it selectable in the 'Manage Modules' window, you have to add it to the 'All_Module_Items.m' function in Path_to_GUI\Modules\1. Main_Window_Functions\Manage_Modules_Functions. Just add the module name, the options shown in the main window and the name of the RUN_ function mentioned above in a new cell.  