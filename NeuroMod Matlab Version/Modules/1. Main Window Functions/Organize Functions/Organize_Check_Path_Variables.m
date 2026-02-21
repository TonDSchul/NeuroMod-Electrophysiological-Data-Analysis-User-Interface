function Organize_Check_Path_Variables(executablefolder)

%________________________________________________________________________________________
%% Function to check all paths to python.exe environments and the CED64 Spike2 tools
% python.exes for environments with: SpikeInterface, NEO, Phy

% Input Arguments:
% 1. executablefolder: char, folder NeuroMod is executed from to load
% variables and check if paths exist

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% ------------------------ Check Variable path of current NeuroMod instance ------------------------ 
FolderToSearchIn = strcat(executablefolder,"/Modules/MISC/Variables (do not edit)");
if ~isfolder(FolderToSearchIn)
    warning("/Modules/MISC/Variables (do not edit) within NeuroMod folder was not found! Cannot check proper files!");
    return;
end

%% ------------------------ Set paths to variables that have to be checked ------------------------ 
CED64VariablePath = strcat(executablefolder,"/Modules/MISC/Variables (do not edit)/CEDS64Path.mat");

SpikeInterfacePythonVariablePath = strcat(executablefolder,"/Modules/MISC/Variables (do not edit)/Python_Conda_Path.mat");
NEOVariablePath = strcat(executablefolder,"/Modules/MISC/Variables (do not edit)/NEO_Python_Conda_Path.mat");
PhyVariablePath = strcat(executablefolder,"/Modules/MISC/Variables (do not edit)/Phy_Python_Conda_Path.mat");

%% ------------------------ Check CED64VariablePath ------------------------ 
if isfile(CED64VariablePath)
    try % try loading
        load(CED64VariablePath)
        % check if variable expected from loading exists!
        if exist('selectedFolder','var') % variable exists
            if isfolder(selectedFolder) %check path withion variable
                disp("Valid path to the CED64ML folder from installing the Spike2 Matlab/SON Interface found!")
            else
                delete(CED64VariablePath)
                disp("File /Modules/MISC/Variables (do not edit)/CEDS64Path.mat found but it does not contain a valid path to the CED64ML folder from installing the Spike2 Matlab/SON Interface. Variable is deleted. Path has to be set when extracting a Spike2 recording next time.")
            end
        else
            delete(CED64VariablePath)
            disp("CEDS64Path variable in NeuroModPath/Modules/MISC/Variables (do not edit) could be loaded but does not contain the expected variable selectedFolder! Variable is deleted. Path has to be set when extracting a Spike2 recording next time.")
        end
    catch
        disp("CEDS64Path variable in NeuroModPath/Modules/MISC/Variables (do not edit) could not be loaded and is deleted. Path has to be set when extracting a Spike2 recording next time.")
        delete(CED64VariablePath)
    end
else
    disp("No CED64 variable path found. Path to the CED64ML folder from installing the Spike2 Matlab/SON Interface has to be set when extracting a Spike2 recording next time.")
end

%% ------------------------ Check SpikeInterface python path variabel ------------------------ 
if isfile(SpikeInterfacePythonVariablePath)
    try % try loading
        load(SpikeInterfacePythonVariablePath)
        % check if variable expected from loading exists!
        if exist('Python_Conda_Environment_Path','var') % variable exists
            if isfile(Python_Conda_Environment_Path) %check path withion variable
                disp("Valid path to the python.exe of the SpikeInterface environment folder found!")
            else
                delete(SpikeInterfacePythonVariablePath)
                disp("File /Modules/MISC/Variables (do not edit)/Python_Conda_Path.mat found but it does not contain a valid path to a python.exe. Variable is deleted. Path has to be set when sorting data with SpikeInterface within Matlab next time.")
            end
        else
            delete(SpikeInterfacePythonVariablePath)
            disp("Python_Conda_Path.mat file in NeuroModPath/Modules/MISC/Variables (do not edit) could be loaded but does not contain the expected variable Python_Conda_Environment_Path! Variable is deleted. Path has to be set when sorting data with SpikeInterface within Matlab next time.")
        end
    catch
        disp("Python_Conda_Path variable in NeuroModPath/Modules/MISC/Variables (do not edit) could not be loaded and is deleted. Path has to be set when sorting data with SpikeInterface within Matlab next time.")
        delete(SpikeInterfacePythonVariablePath)
    end
else
    disp("No path to SpikeInterface python.exe found. Path has to be set when sorting data with SpikeInterface within Matlab next time")
end


%% ------------------------ Check NEO python path variabel ------------------------ 
if isfile(NEOVariablePath)
    try % try loading
        load(NEOVariablePath)
        % check if variable expected from loading exists!
        if exist('NEOPython_Conda_Environment_Path','var') % variable exists
            if isfile(NEOPython_Conda_Environment_Path) %check path withion variable
                disp("Valid path to the python.exe of the NEO environment folder found!")
            else
                delete(NEOVariablePath)
                disp("File /Modules/MISC/Variables (do not edit)/NEO_Python_Conda_Path.mat found but it does not contain a valid path to a python.exe. Variable is deleted. Path has to be set when extracting a raw recording with NEO next time.")
            end
        else
            delete(NEOVariablePath)
            disp("NEO_Python_Conda_Path.mat file in NeuroModPath/Modules/MISC/Variables (do not edit) could be loaded but does not contain the expected variable NEOPython_Conda_Environment_Path! Variable is deleted. Path has to be set when extracting a raw recording with NEO next time.")
        end
    catch
        disp("NEO_Python_Conda_Path.mat file in NeuroModPath/Modules/MISC/Variables (do not edit) could not be loaded and is deleted. Path has to be set when extracting a raw recording with NEO next time.")
        delete(NEOVariablePath)
    end
else
    disp("No path to NEO python.exe found. Path has to be set when extracting a raw recording with NEO next time.")
end


%% ------------------------ Check Phy envirnment python path variable ------------------------ 
if isfile(PhyVariablePath)
    try % try loading
        load(PhyVariablePath)
        % check if variable expected from loading exists!
        if exist('PhyPython_Conda_Environment_Path','var') % variable exists
            if isfile(PhyPython_Conda_Environment_Path) %check path withion variable
                disp("Valid path to the python.exe of the Phy environment folder found!")
            else
                delete(PhyVariablePath)
                disp("File /Modules/MISC/Variables (do not edit)/Phy_Python_Conda_Path.mat found but it does not contain a valid path to a python.exe. Variable is deleted. Path has to be set again when wanting to open Phy next time.")
            end
        else
            delete(PhyVariablePath)
            disp("Phy_Python_Conda_Path.mat file in NeuroModPath/Modules/MISC/Variables (do not edit) could be loaded but does not contain the expected variable PhyPython_Conda_Environment_Path! Variable is deleted. Path has to be set again when wanting to open Phy next time.")
        end
    catch
        disp("Phy_Python_Conda_Path.mat file in NeuroModPath/Modules/MISC/Variables (do not edit) could not be loaded and is deleted. Path has to be set again when wanting to open Phy next time.")
        delete(PhyVariablePath)
    end
else
    disp("No path to Phy python.exe found. Path has to be set again when wanting to open Phy next time.")
end