function Change_Modules_Set_as_new_Default(app)

ModuleOrder = [];
% First Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel.Title,app.Module{i}.Title)
        ModuleOrder = [ModuleOrder,i];
    end
end
% Second Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel_2.Title,app.Module{i}.Title)
        ModuleOrder = [ModuleOrder,i];
    end
end
% Third Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel_3.Title,app.Module{i}.Title)
        ModuleOrder = [ModuleOrder,i];
    end
end
% Fourth Module Nr
for i = 1:length(app.Module)
    if strcmp(app.Panel_4.Title,app.Module{i}.Title)
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