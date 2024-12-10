function [Python_Conda_Environment_Path] = Spike_Module_Check_Load_Conda_Python_exe(executablefolder)

Python_Conda_Environment_Path = [];

PathVariableLocation = strcat(executablefolder,"\Modules\MISC\Variables (do not edit)\Python_Conda_Path.mat");

if ~isfile(PathVariableLocation)
    msgbox("In order to be able to execute python functions within your conda base environment, you have to specify the path of your python.exe in that environment. The typical path is: 'C:\ProgramData\anaconda3\python.exe'. Also be aware of the Python/Matlab version compatibility table available at: https://de.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility.")
    
    % Prompt the user to select a file
    [filename, filepath] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select a File');
    
    % Check if the user selected a file or canceled the dialog
    if isequal(filename, 0)
        disp('User canceled the file selection.');
        return;
    else
        % Display the selected file's full path
        Python_Conda_Environment_Path = fullfile(filepath, filename);

        save(PathVariableLocation,'Python_Conda_Environment_Path')
    end

else
    load(PathVariableLocation,'Python_Conda_Environment_Path')

    if ~isfile(Python_Conda_Environment_Path)
        try
            delete(PathVariableLocation);
        catch
            disp("Could not delete previously saved variable.")
        end
        msgbox("In order to be able to execute python functions within your conda base environment, you have to specify the path of your python.exe in that environment. The typical path is: 'C:\ProgramData\anaconda3\python.exe'. Also be aware of the Python/Matlab version compatibility table available at: https://de.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility.")
        % Prompt the user to select a file
        [filename, filepath] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select a File');
        
        % Check if the user selected a file or canceled the dialog
        if isequal(filename, 0)
            disp('User canceled the file selection.');
            return;
        else
            % Display the selected file's full path
            Python_Conda_Environment_Path = fullfile(filepath, filename);

            save(PathVariableLocation,'Python_Conda_Environment_Path')
        end
    else
        disp("Conda Python.exe loaded and found succefully!")
    end
end