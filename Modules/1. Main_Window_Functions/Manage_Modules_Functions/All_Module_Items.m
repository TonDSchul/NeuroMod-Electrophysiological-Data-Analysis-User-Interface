function [Module,app] = All_Module_Items(app,ChangeApp,ModuleOrder)

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
Module{1}.Items{1} = 'Live Spike Rate';
Module{1}.Items{2} = 'Live Power Estimate';
Module{1}.Items{3} = 'Live Current Source Density';
%% Continous Data Module
Module{2}.Title = 'Continuous Data Module';
Module{2}.Function = 'RUN_Continous_Data_Module';
Module{2}.Items{1} = 'Preprocessing';
Module{2}.Items{2} = 'Static Spectrum Analysis';
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
Module{5}.Title = 'Example Module - this could be yours!';
Module{5}.Function = 'RUN_Example';
Module{5}.Items{1} = 'Example App 1';

%%__________________________________________________________________________________________

%% Determine which Modules the user selected in the manage modules window
% only if ChangeApp = 1

[app,Module] = Change_Modules_Determine_Selected_Modules(app,ChangeApp,ModuleOrder,Module);