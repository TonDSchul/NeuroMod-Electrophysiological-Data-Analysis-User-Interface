function [Module,app] = All_Module_Items(app,ChangeApp,ModuleOrder)

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

%% Main Plot Analysis Module
Module{1}.Title = 'Main Plot Analysis Module';
Module{1}.Function = 'RUN_Main_Plot_Analysis_Module';
Module{1}.Items{1} = 'Live Spike Rate';
Module{1}.Items{2} = 'Live Power Estimate';
Module{1}.Items{3} = 'Live Current Source Density';
Module{1}.Items{4} = 'Live Instantaneous Frequency';
%% Continous Data Module
Module{2}.Title = 'Continuous Data Module';
Module{2}.Function = 'RUN_Continous_Data_Module';
Module{2}.Items{1} = 'Preprocessing';
Module{2}.Items{2} = 'Static Spectrum Analysis';
Module{2}.Items{3} = 'Spike Analysis';
Module{2}.Items{4} = 'Unit Analysis';
%% Event Data Module
Module{3}.Title = 'Event Related Data Module';
Module{3}.Function = 'RUN_Event_Data_Module';
Module{3}.Items{1} = 'Extract Trigger Times';
Module{3}.Items{2} = 'Import Trigger Times';
Module{3}.Items{3} = 'Event Related Preprocessing';
Module{3}.Items{4} = 'Event Related LFP Analysis';
Module{3}.Items{5} = 'Event Related Spike Analysis';
%% Spike Module
Module{4}.Title = 'Spike Data Module';
Module{4}.Function = 'RUN_Spike_Module';
Module{4}.Items{1} = 'Spike Detection and Sorting';
Module{4}.Items{2} = 'Save for Spike Sorting';
Module{4}.Items{3} = 'Load Spike Sorting Results';
Module{4}.Items{4} = 'Open Sorting in Phy';
%% Example Module -- this could be yours!
Module{5}.Title = 'Example Module - this could be yours!';
Module{5}.Function = 'RUN_Example';
Module{5}.Items{1} = 'Example App 1';

%% Test1
Module{6}.Title = 'Test1';
Module{6}.Function = 'RUN_Example';
Module{6}.Items{1} = 'Open Example';
%% end of definition (do not edit this!)
%%__________________________________________________________________________________________

%% Determine which Modules the user selected in the manage modules window
% only if ChangeApp = 1

[app,Module] = Change_Modules_Determine_Selected_Modules(app,ChangeApp,ModuleOrder,Module);











