function Change_Modules_Restore_Default(app)

%% Currently Active Modules
FileToSearchFor = strcat(app.Mainapp.executableFolder,"\Modules\MISC\Variables (do not edit)\Template_ModuleOrder.mat");
load(FileToSearchFor,'ModuleOrder');

[app.Module,app.Mainapp] = All_Module_Items(app.Mainapp,1,ModuleOrder);

FileToSearchFor = strcat(app.Mainapp.executableFolder,"\Modules\MISC\Variables (do not edit)\ModuleOrder.mat");
if isfile(FileToSearchFor)
    delete(FileToSearchFor);
    save(FileToSearchFor,'ModuleOrder');
end

texttoshow = ["To add a new module click the button above directing you in the All_Module_Items.m function. There you have to add a new cell to the existing structure, entering title and items to show in your new module. Lastly add the function that should be executed when the user clicks the RUN button of your module.";"";"All module titles found in All_Module_Items.m function:";""];

for i = 1:length(app.Module)
    texttoshow = [texttoshow;convertCharsToStrings(app.Module{i}.Title)];
    app.SelectedModuleDropDown.Items{i} = app.Module{i}.Title;
end

texttoshow = [texttoshow;"";"To switch modules, select a module on the left that you want to replace with the module selected in dropdown menu below. Then click the 'Switch selected main window module with above selected modules' button to switch."];
app.ListofSavedModulesTextArea.Value = texttoshow;

%% Change View on the left

app.ListBox_5.Items = app.Module{1}.Items;
app.Panel.Title = app.Module{1}.Title;

app.ListBox_4.Items = app.Module{2}.Items;
app.Panel_2.Title = app.Module{2}.Title;

app.ListBox_2.Items = app.Module{3}.Items;
app.Panel_3.Title = app.Module{3}.Title;

app.ListBox.Items = app.Module{4}.Items;
app.Panel_4.Title = app.Module{4}.Title;

for i = 1:length(app.Module)
    app.Mainapp.CurrentModules.Functions{i} = app.Module{i}.Function;
    app.Mainapp.CurrentModules.Title{i} = app.Module{i}.Title;
end

[app.Module,app.Mainapp] = All_Module_Items(app.Mainapp,0,[]);

msgbox("Standard succesfully restored.")