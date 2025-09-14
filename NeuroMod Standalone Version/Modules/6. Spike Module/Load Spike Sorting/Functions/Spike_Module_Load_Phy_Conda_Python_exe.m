function [PhyPython_Conda_Environment_Path] = Spike_Module_Load_Phy_Conda_Python_exe(executablefolder)

%________________________________________________________________________________________
%% Function to check whether python.exe is present and prompt to select a folder containing it if not

%% Creates a variable in GUI_Path/Modules/MISC/Variables (do not edit) that saves the path to the python exe if it was succesfully selected

% Inputs:
% 1. executablefolder: char, GUI path

% Outputs
% 1. Python_Conda_Environment_Path: char, path to the selected python conda
% exe

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

PhyPython_Conda_Environment_Path = [];

PathVariableLocation = strcat(executablefolder,"\Modules\MISC\Variables (do not edit)\Phy_Python_Conda_Path.mat");

if ~isfile(PathVariableLocation)
    msgbox("This code has to execute a python function to open and work with Phy. In order to be able to execute a python function within the anaconda environment (costum or base environment) you installed phy in, you have to specify the path of your python.exe in that environment. The typical path is: 'C:\ProgramData\anaconda3\python.exe'. Also be aware of the Python/Matlab version compatibility table available at: https://de.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility. In doubt look in the README file!")
    
    % Prompt the user to select a file
    [filename, filepath] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select a File');
    
    % Check if the user selected a file or canceled the dialog
    if isequal(filename, 0)
        disp('User canceled the file selection.');
        return;
    else
        % Display the selected file's full path
        PhyPython_Conda_Environment_Path = fullfile(filepath, filename);

        save(PathVariableLocation,'PhyPython_Conda_Environment_Path')
    end

else
    load(PathVariableLocation,'PhyPython_Conda_Environment_Path')

    if ~isfile(PhyPython_Conda_Environment_Path)
        try
            delete(PathVariableLocation);
        catch
            disp("Could not delete previously saved variable.")
        end
        msgbox("This code has to execute a python function to open and work with Phy. In order to be able to execute a python function within the anaconda environment (costum or base environment) you installed Phy in, you have to specify the path of your python.exe in that environment. The typical path is: 'C:\ProgramData\anaconda3\python.exe'. Also be aware of the Python/Matlab version compatibility table available at: https://de.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility. In doubt look in the README file!")
        
        % Prompt the user to select a file
        [filename, filepath] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select a File');
        
        % Check if the user selected a file or canceled the dialog
        if isequal(filename, 0)
            disp('User canceled the file selection.');
            return;
        else
            % Display the selected file's full path
            PhyPython_Conda_Environment_Path = fullfile(filepath, filename);

            save(PathVariableLocation,'PhyPython_Conda_Environment_Path')
        end
    else
        disp("Phy conda Python.exe loaded and found succefully!")
    end
end