______________________________________________
NeuroMod Toolbox; Example Module README
Author: Tony de Schultz
______________________________________________

This is an example folder you can use to implement your own module in the GUI. It is also the origin of the example module that can be selected in the 'Manage Modules' window. It contains an example app window with just the backbone needed to access the whole dataset and do an example plot. The folder also contains a RUN_ function, which specifies the app window that should be opened, when the user clicks on the 'RUN' button for this module in the main window. The functions folder contains all functions necessary for the app window(s) of this module to work. 

Note: To implement your own module into the GUI and make it selectable in the 'Manage Modules' window, you have to add it to the 'All_Module_Items.m' function in Path_to_GUI\Modules\1. Main_Window_Functions\Manage_Modules_Functions. Just add the module name, the options shown in the main window and the name of the RUN_ function mentioned above.  

For this either create a new cell in the 'All_Module_Items.m' function like the ones above just with your names or directly modify the entry for this example module. If you want to use this module for your purposes and create your own window or rename the 'Example_App_1'.mlapp GUI file, make sure to adjust the window names called in the RUN_Example function! 