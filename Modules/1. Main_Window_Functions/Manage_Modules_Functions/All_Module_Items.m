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
%% Test
Module{5}.Title = 'Test1';
Module{5}.Function = 'RUN_Test1';
Module{5}.Items{1} = 'erh frgeg Deterhection';
Module{5}.Items{2} = 'eh ferheror rhe';
Module{5}.Items{3} = 'erhe erhe ehr';
%% Test
Module{6}.Title = 'Test2';
Module{6}.Function = 'RUN_Test2';
Module{6}.Items{1} = '2';
Module{6}.Items{2} = '3';
Module{6}.Items{3} = '4';

%%__________________________________________________________________________________________

if ChangeApp
    
    if isempty(ModuleOrder)
        %% Currently Active Modules
        FileToSearchFor = strcat(app.executableFolder,"\Modules\MISC\Variables (do not edit)\ModuleOrder.mat");
        % when no standard found, establish template (first 4 modules)
        if ~isfile(FileToSearchFor)
            ModuleOrder = NaN(1,4);
            for i = 1:4
                ModuleOrder(i) = i;
            end
            save(FileToSearchFor,'ModuleOrder')
        else
            load(FileToSearchFor,'ModuleOrder')
        end
    else

    end
    
    %% Only Keep Info about Modules selected
    
    NumToDelete = [];
    for i = 1:length(Module)
        if ~ismember(ModuleOrder,i)
            NumToDelete = [NumToDelete,i];
        end
    end
    
    if ~isempty(NumToDelete)
        Module(NumToDelete) = [];
    end
    
    %% Populate Main Window areas
    Placeholder = {};

    app.ListBox_6.Items = Placeholder;
    app.ListBox_3.Items = Placeholder;
    app.ListBox_2.Items = Placeholder;

    app.ListBox_6.Items = Module{1}.Items;
    app.ListBox_3.Items = Module{2}.Items;
    app.ListBox_2.Items = Module{3}.Items;
    app.ListBox.Items = Module{4}.Items;
    
    app.MainPlotAnalysisModulePanel.Title = Module{1}.Title;
    app.ContinousDataModulePanel.Title = Module{2}.Title;
    app.EventDataModulePanel.Title = Module{3}.Title;
    app.SpikeModulePanel_2.Title = Module{4}.Title;

    for i = 1:length(Module)
        app.CurrentModules.Functions{i} = Module{i}.Function;
        app.CurrentModules.Title{i} = Module{i}.Title;
    end

end