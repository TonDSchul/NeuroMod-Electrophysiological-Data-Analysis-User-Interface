function [app] = Change_Modules_Apply_Module_Change_To_MainWindow(app)

%________________________________________________________________________________________

%% Function to apply the module changes the user selected in the manage modules window
% This function is called when the user presses the button to switch the
% module selected on the left with the module seleced in the
% dropdown menu of the manage modules window. it applies this change to the
% the main window

% Inputs:
% 1. app: manage modules window app structure (Mainapp saved as app.Mainapp)

% Outputs:
% 1. app: manage modules window app structure (Mainapp saved as app.Mainapp)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Apply switch in manage modlue window

%% Check if Seelction was proper and operation can be done
SumSelections = app.SelectCheckBox_2.Value + app.SelectCheckBox_3.Value + app.SelectCheckBox_4.Value + app.SelectCheckBox_5.Value;

if SumSelections>1
    msgbox("Error: Please only select one module at a time to switch.")
    return;
end

if SumSelections==0
    msgbox("Error: Please select a module to switch.")
    return;
end

app.Titles{1} = app.Panel.Title;
app.Titles{2} = app.Panel_1.Title;
app.Titles{3} = app.Panel_2.Title;
app.Titles{4} = app.Panel_3.Title;

for ntitles = 1:length(app.Titles)
    if strcmp(app.SelectedModuleDropDown.Value,app.Titles{ntitles})
        msgbox("Error: Module already part of the main window. Please select a module in the dropdown menu thats not part of the main window.")
        return;
    end
end

%% Change View on the left

for i = 1:length(app.Module)
    if strcmp(app.SelectedModuleDropDown.Value,app.Module{i}.Title)
        NewModuleNr = i;
    end
end

if app.SelectCheckBox_2.Value == 1
    app.ListBox_5.Items = app.Module{NewModuleNr}.Items;
    app.Panel.Title = app.Module{NewModuleNr}.Title;
    ModuleOrder(1) = NewModuleNr;
elseif app.SelectCheckBox_3.Value == 1
    app.ListBox_4.Items = app.Module{NewModuleNr}.Items;
    app.Panel_1.Title = app.Module{NewModuleNr}.Title;
    ModuleOrder(2) = NewModuleNr;
elseif app.SelectCheckBox_4.Value == 1
    app.ListBox_2.Items = app.Module{NewModuleNr}.Items;
    app.Panel_2.Title = app.Module{NewModuleNr}.Title;
    ModuleOrder(3) = NewModuleNr;
elseif app.SelectCheckBox_5.Value == 1
    app.ListBox.Items = app.Module{NewModuleNr}.Items;
    app.Panel_3.Title = app.Module{NewModuleNr}.Title;
    ModuleOrder(4) = NewModuleNr;
end

%% Change Main Window objects

%[app.Module,~] = All_Module_Items(app.Mainapp,1,ModuleOrder);

for i = 1:length(app.Module)
    if strcmp(app.SelectedModuleDropDown.Value,app.Module{i}.Title)
        NewModuleNr = i;
    end
end

if app.SelectCheckBox_2.Value == 1
    app.Mainapp.ListBox_6.Items = app.Module{NewModuleNr}.Items;
    app.Mainapp.MainPlotAnalysisModulePanel.Title = app.Module{NewModuleNr}.Title;
    app.Mainapp.CurrentModules.Functions{1} = app.Module{NewModuleNr}.Function;
    app.Mainapp.CurrentModules.Title{1} = app.Module{NewModuleNr}.Title;
elseif app.SelectCheckBox_3.Value == 1
    app.Mainapp.ListBox_3.Items = app.Module{NewModuleNr}.Items;
    app.Mainapp.ContinousDataModulePanel.Title = app.Module{NewModuleNr}.Title;
    app.Mainapp.CurrentModules.Functions{2} = app.Module{NewModuleNr}.Function;
    app.Mainapp.CurrentModules.Title{2} = app.Module{NewModuleNr}.Title;
elseif app.SelectCheckBox_4.Value == 1
    app.Mainapp.ListBox_2.Items = app.Module{NewModuleNr}.Items;
    app.Mainapp.EventDataModulePanel.Title = app.Module{NewModuleNr}.Title;
    app.Mainapp.CurrentModules.Functions{3} = app.Module{NewModuleNr}.Function;
    app.Mainapp.CurrentModules.Title{3} = app.Module{NewModuleNr}.Title;
elseif app.SelectCheckBox_5.Value == 1
    app.Mainapp.ListBox.Items = app.Module{NewModuleNr}.Items;
    app.Mainapp.SpikeModulePanel_2.Title = app.Module{NewModuleNr}.Title;
    app.Mainapp.CurrentModules.Functions{4} = app.Module{NewModuleNr}.Function;
    app.Mainapp.CurrentModules.Title{4} = app.Module{NewModuleNr}.Title;
end

app.SelectCheckBox_2.Value = 0;
app.SelectCheckBox_3.Value = 0;
app.SelectCheckBox_4.Value = 0;
app.SelectCheckBox_5.Value = 0;
