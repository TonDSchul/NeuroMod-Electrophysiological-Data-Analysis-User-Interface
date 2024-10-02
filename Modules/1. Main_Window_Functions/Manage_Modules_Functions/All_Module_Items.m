function [Module,app] = All_Module_Items(app,ChangeApp,ModuleOrder)

%%__________________________________________________________________________________________

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

%% Determine which Modules the user selected in the manage modules window
% only if ChangeApp = 1

[app,Module] = Change_Modules_Determine_Selected_Modules(app,ChangeApp,ModuleOrder,Module);