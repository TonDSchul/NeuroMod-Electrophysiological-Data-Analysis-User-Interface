function [app,Module] = Change_Modules_Determine_Selected_Modules(app,ChangeApp,ModuleOrder,Module)

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
            disp("No costum module order. Loading standard modules.")
            save(FileToSearchFor,'ModuleOrder')
        else
            disp("Loading costum modules.")
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