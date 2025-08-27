function [app,Module] = Change_Modules_Determine_Selected_Modules(app,ChangeApp,ModuleOrder,Module)

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
            disp("No costum module order found. Loading standard modules.")
            save(FileToSearchFor,'ModuleOrder')
        else
            disp("Loading costum module order.")
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
    % only 4 cells left!
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

    app.MainPlotAnalysisModuleLabel.Text = Module{1}.Title;
    app.ContinousDataModuleLabel.Text = Module{2}.Title;
    app.EventDataTTLModuleLabel.Text = Module{3}.Title;
    app.SpikeModuleLabel.Text = Module{4}.Title;

    for i = 1:length(Module)
        app.CurrentModules.Functions{i} = Module{i}.Function;
        app.CurrentModules.Title{i} = Module{i}.Title;
    end

end