function PlotAppearance = Utility_Save_Load_Delete_Plot_Appearance(PlotAppearance,executableFolder,Type)

%________________________________________________________________________________________

%% Function to Manage saving, loading and deleting then plot appearance variable
% This function is called in any window the user can modify the plot
% appearance and saves the costum appearance or deletes previosuly saved
% costum appearances. It is also called in the Organize_Initialize_GUI.m
% function on startup of the GUI to load the costum/standard appearance (depending on whether user saved costum)

% Appearances saved in GUI_Path/Modules/MISC/Variables (do not edit!)
% PlotAppearance.m holds the costum appearance saved by the user
% Template_PlotAppearance.m holds the standard settings.
% If non was found (also no template), new template is created by calling
% Organize_Set_Standard_PlotAppearance. which hard codes all standrad
% appearances

% Inputs:
% 1. PlotAppearance: structure holding plot appearance
% 2. executableFolder: string, path to gui currently executed (created on GUI startup)
% 3. Type: string, specifies what do do here, Either "Save" OR "Load" OR "Delete"

% Output:
% app object with initialized values

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if strcmp(Type,"Save")

    %% Save standard Plot appearance
    % standard file with may costum stuff of user
    PlotAppearancePath = strcat(executableFolder,'\Modules\MISC\Variables (do not edit)\PlotAppearance.mat');
    if isfile(PlotAppearancePath)
        delete(PlotAppearancePath);
    end

    save(PlotAppearancePath,'PlotAppearance')
    msgbox("Costum Plot Appearance succesfully saved as new standard!")

elseif strcmp(Type,"Delete")
    %% Delete standard Plot appearance
    % standard file with may costum stuff of user
    PlotAppearancePath = strcat(executableFolder,'\Modules\MISC\Variables (do not edit)\PlotAppearance.mat');

    % Delete the file
    if isfile(PlotAppearancePath)
        delete(PlotAppearancePath);
        msgbox("Costum Plot Appearance succesfully deleted!");
    else
        disp(['File PlotAppearance.mat not found. Was probably already deleted or not created yet']);
    end

elseif strcmp(Type,"Load")
    %% Load standard Plot appearance
    % standard file with may costum stuff of user
    PlotAppearancePath = strcat(executableFolder,'\Modules\MISC\Variables (do not edit)\PlotAppearance.mat');
    % check an load
    if isfile(PlotAppearancePath)
        load(PlotAppearancePath,'PlotAppearance');
        disp("Loaded Costum Plot Appearance (Select 'Delete Costum Appearance' in the main window menu to reset the costum appearance back to standard)!");
    else% If costum appearance not found, load template instead
        PlotAppearancePath = strcat(executableFolder,'\Modules\MISC\Variables (do not edit)\PlotAppearance.mat');
        if isfile(PlotAppearancePath)
            load(PlotAppearancePath,'PlotAppearance');
            disp("Loaded Standard Plot Appearance Template! (no costum appearance saved, can be done in the 'Save costum Appearance' menu of the main window)");
        else % If no template found, create new one
            [PlotAppearance] = Organize_Set_Standard_PlotAppearance("All",PlotAppearance);
            Savefilename = strcat(executableFolder,'\Modules\MISC\Variables (do not edit)\PlotAppearance.mat');
            save(Savefilename,'PlotAppearance')
            disp("Couldn find any autosaved plot appearance template. Organize_Set_Standard_PlotAppearance.m is executed to create a new one!");
        end
    end
end