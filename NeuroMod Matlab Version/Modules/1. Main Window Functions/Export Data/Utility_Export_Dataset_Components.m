function Utility_Export_Dataset_Components(Data,Component,Format,executableFolder,ExecuteOutsideGUI)

%________________________________________________________________________________________
%% Function to export some dataset components as txt,csv or .mat
% This function gets called in the Export Dataset Components Window when
% the user clicks the "Export" button

% NOTE: At standard the folder to save dataset components in is:
% Data_to_GUI\Analysis_Results

% NOTE: To export Raw and Preprocessed data, use the save dataset function.
% This saves the raw and/or preprocessed data as a .dat file which is faster and easier on memory.
% Also prevents .txt or csv files from not being readable due to to much data.

% Input Arguments:
% 1. Data: main window structure holding dataset components (i.e. Data.Events, Data.Spikes ...)
% 2. Component: Selected dataset component as string, i.e. "Events" or "Spikes"
% 3. Format: Format to save data in, as string, ".mat" OR ".txt" OR ".csv"
% 4. executableFolder_ Path to GUI currently executed as char (created on startup of Main Window)
% 5. ExecuteOutsideGUI: double 1 or 0, if executed outside of gui use 1

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Save Path
current_time = char(datetime('now'));
current_time(current_time==':') = '_';
current_time(current_time==' ') = '_';

if ExecuteOutsideGUI == 0
    SaveFolder = strcat(executableFolder,"\Analysis Results\");
else
    SaveFolder = strcat(Data.Info.Data_Path,"\Matlab\Exported Results\");
    if ~exist(SaveFolder, 'dir')
        mkdir(SaveFolder);
    end
end
dashindex = find(Data.Info.Data_Path=='\');

Savefile = strcat(Data.Info.Data_Path(dashindex(end)+1:end),"_",Component,"_",current_time,"_",Format);

if isfolder(SaveFolder)
    Fullsavefile = fullfile(SaveFolder,Savefile);
else
    msgbox("Please select a folder to save the results in.")
    % Prompt user to select a folder
    Fullsavefile = uigetfile;
    
    % Check if the user canceled the dialog
    if Fullsavefile == 0
        disp('User canceled folder selection.');
        return;
    else
        disp(['Selected folder: ', Fullsavefile]);
    end
end

if strcmp(Format,".xlsx")
    %% SAVE AS XLSX
    Utility_Export_Dataset_Components_as_XLSX(Data,Component,Format,SaveFolder,Fullsavefile,ExecuteOutsideGUI)
end

if strcmp(Format,".txt")
    %% SAVE AS TXT
    Utility_Export_Dataset_Components_as_TXT(Data,Component,Format,SaveFolder,Fullsavefile,ExecuteOutsideGUI)
end

%% SAVE AS MAT
if strcmp(Format,".mat")
    dlgbox = msgbox(strcat("Data Component ",Component," is saved. Please wait until a message appears that saving was succesfull! This window closes automatically."));

    Fullsavefile=convertStringsToChars(Fullsavefile);
    % Saved variable name is the name of the component selected
    DataToSave = Data.(Component);
    eval(strcat(Component," = DataToSave;"))
    %eval(strcat(Component, ' = DataToExport;'));
    % save as .mat
   
    save(Fullsavefile,Component,'-v7.3');      
    
    delete(dlgbox);

    if ExecuteOutsideGUI == 0
        msgbox(strcat("Succesfully exported Dataset to: ",Fullsavefile))
    else
        disp(strcat("Succesfully exported Dataset to: ",Fullsavefile))
    end
end



