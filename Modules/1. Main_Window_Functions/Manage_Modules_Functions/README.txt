This folder contains the following functions with respective Header:

 ###################################################### 

File: All_Module_Items.m
%%__________________________________________________________________________________________
%% This functions holds information about all modules added to the toolbox. If you want to add your own module,
%% add a new cell to the Module variable below and enter the necessary info. 
% Module{i}.Title holds the title of the Module shown in the main window
% Module{i}.Items holds the name of each function the user can select in
% module selection field of the main window (to the left of the RUN button)
% Module{i}.Function is the function name of the function executed when the
% User presses the RUN button of that module. It starts the app windows you
% can build yourself depending on what option the user selected in the
% module selection field.
% To get started, use the fifth cell array below containing the example
% module. Just add your own code to the module app window and your own
% functions to that folder to get your onw analysis running with the rest of
% the Toolbox.

%% Main Plot Analysis Module
Module{1}.Title = 'Main Plot Analysis Module';
Module{1}.Function = 'RUN_Main_Plot_Analysis_Module';
Module{1}.Items{1} = 'Spike Rate';
Module{1}.Items{2} = 'Power Estimate';
Module{1}.Items{3} = 'Current Source Density';
%% Continous Data Module
Module{2}.Title = 'Continous Data Module';
Module{2}.Function = 'RUN_Continous_Data_Module';
Module{2}.Items{1} = 'Preprocessing';
Module{2}.Items{2} = 'Band Power Analysis';
Module{2}.Items{3} = 'Spike Analysis';
Module{2}.Items{4} = 'Unit Analysis';
%% Event Data Module
Module{3}.Title = 'Event Data Module';
Module{3}.Function = 'RUN_Event_Data_Module';
Module{3}.Items{1} = 'Extract Events and Data';
Module{3}.Items{2} = 'Preprocessing';
Module{3}.Items{3} = 'LFP Analysis';
Module{3}.Items{4} = 'Spike Analysis';
Module{3}.Items{5} = 'Unit Analysis';
%% Spike Module
Module{4}.Title = 'Spike Module';
Module{4}.Function = 'RUN_Spike_Module';
Module{4}.Items{1} = 'Internal Spike Detection';
Module{4}.Items{2} = 'Save for Kilosort';
Module{4}.Items{3} = 'Load from Kilosort';
%% Example Module -- this could be yours!
Module{5}.Title = 'Example Module';
Module{5}.Function = 'RUN_Example';
Module{5}.Items{1} = 'Example App 1';

%%__________________________________________________________________________________________


 ###################################################### 

File: Change_Modules_Apply_Module_Change_To_MainWindow.m
%________________________________________________________________________________________

%% Function to apply the module changes the user selected in the manage modules window
% This function is called when the user presses the button to switch the
% module selected on the left with the module seleced in the
% dropdown menu of the manage modules window. it applies this change the
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

