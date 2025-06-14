function Change_Modules_Set_as_new_Default(app)

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


ModuleOrder = [];
% First Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel.Title,app.Module{i}.Title)
        ModuleOrder = [ModuleOrder,i];
    end
end
% Second Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel_1.Title,app.Module{i}.Title)
        ModuleOrder = [ModuleOrder,i];
    end
end
% Third Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel_2.Title,app.Module{i}.Title)
        ModuleOrder = [ModuleOrder,i];
    end
end
% Fourth Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel_3.Title,app.Module{i}.Title)
        ModuleOrder = [ModuleOrder,i];
    end
end

if length(ModuleOrder)<4
    msgbox("Error: Less then 4 modules found based on title.")
end

[app.Module,app.Mainapp] = All_Module_Items(app.Mainapp,0,[]);

%% Currently Active Modules
FileToSearchFor = strcat(app.Mainapp.executableFolder,"\Modules\MISC\Variables (do not edit)\ModuleOrder.mat");

if ~isfile(FileToSearchFor)
    save(FileToSearchFor,'ModuleOrder');
    msgbox("New standard succesfully set.");
else
    delete(FileToSearchFor);
    save(FileToSearchFor,'ModuleOrder');
    msgbox("New standard succesfully set.");
end