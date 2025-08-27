function [NEOPython_Conda_Environment_Path] = Manage_Dataset_Load_NEO_Conda_Python_exe(executablefolder)

%________________________________________________________________________________________
%% Function to check whether python.exe is present and promt to select a folder containing it if not

%% Creates a variable in GUI_Path/Modules/MISC/Variables (do not edit) that saves the path to the python exe if it was succesfully selected

% Inputs:
% 1. executablefolder: char, GUI path

% Outputs
% 1. Python_Conda_Environment_Path: char, path to the selected python conda
% exe

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

NEOPython_Conda_Environment_Path = [];

PathVariableLocation = strcat(executablefolder,"\Modules\MISC\Variables (do not edit)\NEO_Python_Conda_Path.mat");

if ~isfile(PathVariableLocation)
    msgbox("This code has to execute a python function to open and work with the Neuralensemble NEO library. In order to be able to execute a python function within the anaconda environment (costum or base environment) you installed Spikeinterface in, you have to specify the path of your python.exe in that environment. The typical path is: 'C:\ProgramData\anaconda3\python.exe'. Also be aware of the Python/Matlab version compatibility table available at: https://de.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility. In doubt look in the README file!")
    
    % Prompt the user to select a file
    [filename, filepath] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select a File');
    
    % Check if the user selected a file or canceled the dialog
    if isequal(filename, 0)
        disp('User canceled the file selection.');
        return;
    else
        % Display the selected file's full path
        NEOPython_Conda_Environment_Path = fullfile(filepath, filename);

        save(PathVariableLocation,'NEOPython_Conda_Environment_Path')
    end

else
    load(PathVariableLocation,'NEOPython_Conda_Environment_Path')

    if ~isfile(NEOPython_Conda_Environment_Path)
        try
            delete(PathVariableLocation);
        catch
            disp("Could not delete previously saved variable.")
        end
        msgbox("This code has to execute a python function to open and work with Neuralensemble NEO. In order to be able to execute a python function within the anaconda environment (costum or base environment) you installed Spikeinterface in, you have to specify the path of your python.exe in that environment. The typical path is: 'C:\ProgramData\anaconda3\python.exe'. Also be aware of the Python/Matlab version compatibility table available at: https://de.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility. In doubt look in the README file!")
        
        % Prompt the user to select a file
        [filename, filepath] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select a File');
        
        % Check if the user selected a file or canceled the dialog
        if isequal(filename, 0)
            disp('User canceled the file selection.');
            return;
        else
            % Display the selected file's full path
            NEOPython_Conda_Environment_Path = fullfile(filepath, filename);

            save(PathVariableLocation,'NEOPython_Conda_Environment_Path')
        end
    else
        disp("NEO Conda Python.exe loaded and found succefully!")
    end
end