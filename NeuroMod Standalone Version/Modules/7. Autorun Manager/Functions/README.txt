This folder contains the following functions with respective Header:

 ###################################################### 

File: Execute_Autorun_Check_Selected_Folder.m
%________________________________________________________________________________________
%% This function checks whether the folder selected is proper
% it checks whther the folder contains files with a proper file extension

% Inputs:
% 1. folderPath: char, path to the folder that has to be checked

% 2. filteredFolderContents: string array with name of valid folder
% contents

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Config_Simple_Check_FileEnding.m
%________________________________________________________________________________________
%% This function checks whether a folder has files with the specified file extension

% Inputs:
% 1. Folder: char, path to the folder that has to be checked
% 2. FileEnding: char, file extension to check for, i.e. '.dat'

% Output:
% 1. containsFiles: true if file(s) with file extension was found, 0 if not

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Config_Template.m
%________________________________________________________________________________________
%% This is the main functione executing all steps specified in the Config file in a loop

% This function is called when the user clicks on the execute config button
% in the autorun manager window

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute
% 3. executableFolder: char, folder this instance of the Toolbox is saved in and
% executed from
% 4: AutorunConfigName: Name of the Autorun Config (set in the respective Config file at the
% beginning) to save Autorun structure at the end woth a proper name
% 5. Channelorder: 1 x nchannel double containing the true channel for each
% current channel position, empty if not selected
% 6. NumIterations: double, max nr of recordings that are analysed. If multiple recordings are analyzed, this function
% loops over them. If just one loaded this is set to 1 
% 7. LoadedData: 1 if data was loaded, 0 if data was extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Continous_Data_Module_Functions.m
%________________________________________________________________________________________
%% This is the main function to execute continous autorun data analysis 

% This function is called in the Execute_Autorun_Config_Template function
% when specified in the FunctionOrder

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute
% 3. Data: main data structure 
% 4. DataPath: char, Path to currently analyzed folder
% 5. LoadedData: 1 if data was loaded, 0 if data was extracted

% Outputs:
% 1. Data: main data structure 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Convert_ConfigChannel_to_ActiveChannel.m
%________________________________________________________________________________________
%% Function to convert the channel selection in the autorun config into active channel for further analysis

% This function is called in the Execute_Autorun_Config_Template function
% in the Manage Dataset Module Functions

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. ActiveChannel: 1 x n double with all active channel defined in the
% probe information (Data.Info.ProbeInfo.ActiveChannel)

% Outputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected -- channel info for individual
% analysis parts where added and converted.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Extract_Events_Module_Functions.m
%________________________________________________________________________________________
%% This is the main function to execute event module autorun analysis 

% This function is called in the Execute_Autorun_Config_Template function
% when specified in the FunctionOrder

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute
% 3. Data: main data structure 
% 4. DataPath: char, Path to currently analyzed folder
% 5. LoadedData: 1 if data was loaded, 0 if data was extracted

% Outputs:
% 1. Data: main data structure 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Manage_Dataset_Module_Functions.m
%________________________________________________________________________________________
%% This is the main function to execute dataset management module autorun analysis 

% This function is called in the Execute_Autorun_Config_Template function
% when specified in the FunctionOrder

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute
% 3. Data: main data structure 
% 4. nRecordings: double, max number of folder iterated through
% 5. Channelorder: 1 x nchannel double, containing true channel nr as
% integers, empty if non
% 6. executableFolder: char, folder this instance of the Toolbox is saved in and
% executed from 
%7. AutorunConfig.selected_folder: char, Path to currently analyzed folder

% Outputs:
% 1. Data: main data structure 
% 2. AutorunConfig.selected_folder: char, extracted here

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Save_Figure.m
%________________________________________________________________________________________
%% This is the main function to save figures when plotted during an autorun

% This function is called every time, a plotted figure is supposed to be
% saved. This follows a standard folder scheme. 
% For Intan: Pictures of all analysis
% excecpt of waveform plots for individual units is save in the
% recordingfolder/Matlab in the specified format. Unit waveform plots are
% saved in recordingfolder/Matlab/Units.
% For Open Ephys: Pictures of all analysis
% excecpt of waveform plots for individual units is save in the
% recordingfolder/Matlab/Record Node in the specified format. Unit waveform plots are
% saved in recordingfolder/Matlab/Record Node/Units.

% Inputs:
% 1. Figure: figure axes handle to plot in
% 2. ImageFormat: char, Otions: 'png', 'svg', 'fig'
% 3. deletefigure: if 1: figure is deleted after saving, Otherwise 0
% 4. SaveName: char, name of the saved picture (gets combined with Plottype input argument)
% 5. LoadDataPath: char, path to currently analyzed folder
% 6. Plottype: char, specifies from which module the analysis comes (kilosort and internal spikes would have same name when save if the kind is not incorporated in the name)
% 7. OENodePath: Just open Ephys: name of the record node as the folder to
% save figures in (Path/Matlab/Record Node)
% 8. PlotAddons: char, If one analysis has multiple ways of plotting that
% are looped through, specified the name here. i.e. for time frequency power user
% can plot ITPC and Time Frequency Power which has to be incorporate in
% name to make the unique
% 9. RecordingsSystem: char, just important if 'Open Ephys', not relevant
% for other recording systems here
% 10. LoadedData: true when data was laoded, false when it was executed
% 11. PlotName: Name of the current plot to identify where this function is
% executed. For Options see below

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Set_Up_Figure.m
%________________________________________________________________________________________
%% This function costumizes a function based on the inputs

% Inputs:
% 1. Figure: figure axes handle to modify
% AddXticks: 1 to add costum x tick labels, 0 otherwise
% YReverse: 1 to reverse y axis, 0 otherwise
% XData: string array, All Xtick values if AddXticks=1
% NumXTicksToShow: double number of xticks to show in plot if AddXticks=1
% XLabel: char, costum x label
% Ylabel: char, costum y label
% Title: char, costum title
% Fontsize: double, costum fontsize
%
% Output:
% 1. Figure: modifed figure axes handle 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Set_Up_Folder.m
%________________________________________________________________________________________
%% This function takes the folder the user selected, chekcs for contents and modifies them for easier use later on
% Purpose is so that later functions can easily access standard folder structure that is created during the autorun
% which differs between open ephys and intan recordings bc of their stanrad
% folder structure AND to have an additional measure to check whther folder
% selected by user contains what is expected for the selected parameter

% This function is called in the
% Execute_Autorun_Continous_Data_Module_Functions folder before the data
% extraction or loading begins

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 3. Data: main data structure 
% 4. nRecordings: double, max number of folder iterated through
% 5. LoadedData: true if data is loaded, false if not (not loaded here!)

%Outputs:
% 1. Data: main data structure
% 3. SelectedFolder: char, modified folder 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Spike_Module_Functions.m
%________________________________________________________________________________________
%% This is the main function to execute spike module autorun analysis 

% This function is called in the Execute_Autorun_Config_Template function
% when specified in the FunctionOrder

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute
% 3. Data: main data structure 
% 4. nRecordings: double, max number of folder iterated through

% Outputs:
% 1. Data: main data structure 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Execute_Autorun_Window_Check_Selected_Folder_and_Channel_Order.m
%________________________________________________________________________________________
%% This function lets the user select a folder, check its contents and save it along with other variables 
% This function is called when the user selects a folder in the autorun manager window

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute

% Output:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected with added field
% AutorunConfig.selected_folder and AutorunConfig.FolderContents if
% recording system is intan
% 2. NumIterations: double, max number of folder and therefore iterations
% found, when multiple folder are suppossed to be analyzed
% 3. LoadedData: true if data is loaded, false if not (not loaded here!)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

