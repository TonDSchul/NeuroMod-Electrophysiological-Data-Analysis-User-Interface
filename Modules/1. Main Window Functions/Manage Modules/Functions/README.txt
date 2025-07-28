This folder contains the following functions with respective Header:

 ###################################################### 

File: All_Module_Items.m
%%__________________________________________________________________________________________
%% This function holds information about all modules added to the toolbox. If you want to add your own module,
%% add a new cell to the Module variable below and enter the necessary info. 
% Module{i}.Title holds the title of the Module shown in the main window
% Module{i}.Items holds the name of each function the user can select in
% module selection field of the main window (to the left of the RUN button)
% Module{i}.Function is the function name of the function executed when the
% User presses the RUN button of that module. It starts the app windows you
% can build yourself depending on what option the user selected in the
% module selection field.
% To get started, use the fifth cell array below containing the example
% module or add a sixth cell yourself. Just add your own code to the module app window and your own
% functions to that folder to get your onw analysis running with the rest of
% the Toolbox.

% Inputs: 
% 1. ChangeApp: double, 1 to execute module switching code, 0 to not (and only get modules back)
% 2. ModuleOrder: vector with 4 numbers. Order of modules to use in respect
% to the original strcuture size with all modules, coming from the
% All_Module_Items.m function (saved in GUI_Path/Modules/MISC/Variables/ModuleOrder.mat)
% ---> if 1,2,3,4, The first 4 defined modules are currently selected

% Outputs: 
% Module: cell array with each cell containing a module.

%% General Remarks:
% the Module cell array contains ALL modules defined/available !!! Which
% modules are currently available is determined in the
% Change_Modules_Determine_Selected_Modules.m function below

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Change_Modules_Add_New_Module.m
%________________________________________________________________________________________

%% Function to take infos from creating new module window and save them in a .m function that is accessed by the GUI

% This function saves a cell array with the new module infos in the
% All_Module_Items.m function. This function is accessed to initiate
% modules in the
% main window

% Input:
% 1. ExecutableFolder: path GUI was started from, char (from mainapp window)
% 2. ItemsTextArea: 1x6 cell array with each cell containing either:
% 'Module Option 3:' or 'Module Option 2: Test3'. The first cell is the
% first Item that should be added to the module, the second cell to the
% second one and so on. If nothing is found after the ':' in each cell,
% nothing is saved. Therefore, only the cell arrays with strings after the
% ':' are regarded and added as new items!
% 3. NumModules: cell array with each cell being one module of the GUI.
% Just for getting the number of modules BEFORE the new one was added! 
% 4. NewModuleName: char, name of the new module
% 5. NewRunFunction: char, name of the matlab function executed when the
% user clicks the RUN button of the new module

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Change_Modules_Apply_Module_Change_To_MainWindow.m
%________________________________________________________________________________________

%% Function to apply the module changes the user selected in the manage modules window
% This function is called when the user presses the button to switch the
% module selected on the left with the module seleced in the
% dropdown menu of the manage modules window. it applies this change to the
% the main window

% Inputs:
% 1. app: manage modules window app structure (Mainapp saved as app.Mainapp)

% Outputs:
% 1. app: manage modules window app structure (Mainapp saved as app.Mainapp)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Change_Modules_Determine_Selected_Modules.m
%________________________________________________________________________________________

%% Function to only select the modules selected in the manage modules window from all module infos saved in All_Module_Items
% This function is called in the All_Module_Items.m function, takes the
% structure defined there holding all possible modules and deletes the
% fields not selected in the manage modules window
% 
% loads the standard template for modules saved in
% GUI_Path/Modules/MISC/Variables/Template_ModuleOrder.mat and saves it as
% the new default variable in GUI_Path/Modules/MISC/Variables/ModuleOrder.mat

% Inputs:
% 1. app: app object of the manage mdoules window holding the module data
% currently set in it and save.
% 2. ChangeApp: double, 1 to execute, 0 if not
% 3. ModuleOrder: vector with 4 numbers. Order of modules to use in respect
% to the original strcuture size with all modules, coming from the
% All_Module_Items.m function (saved in GUI_Path/Modules/MISC/Variables/ModuleOrder.mat)
% 4. Module: strcuture holding all module infos 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Change_Modules_Restore_Default.m
%________________________________________________________________________________________

%% Function to restore the standard modules in the manage modules window 
% This function loads the standard template for modules saved in
% GUI_Path/Modules/MISC/Variables/Template_ModuleOrder.mat and saves it as
% the new default variable in GUI_Path/Modules/MISC/Variables/ModuleOrder.mat

% Inputs:
% 1. app: app object of the manage mdoules window holding the module data
% currently set in it and save.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Change_Modules_Set_as_new_Default.m
%________________________________________________________________________________________

%% Function to set the selected modules in the manage mdoules window as new default
% This function takes the standard module structure from the
% All_Module_Items.m and Change_Modules_Determine_Selected_Modules.m
% functions (last one actually selects remaining modules)
% with only the newly selected modules remaining. It then saves a vector of
% 4 numbers, defining the number of the module currently selected in
% respect to the original structure holding all modules. Vector is saved
% under GUI_Path/Modules/MISC/Variables/ModuleOrder.mat. This is so
% that they can be loaded on a new startup of the app by checking for and
% reading the saved variable.

% Inputs:
% 1. app: app object of the manage mdoules window holding the module data
% currently set in it and save.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

