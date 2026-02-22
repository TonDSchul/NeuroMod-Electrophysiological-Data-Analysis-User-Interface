This folder contains the following functions with respective Header:

 ###################################################### 

File: Manage_Dataset_Module_LoadGUIDataCheckFolderContents.m
%________________________________________________________________________________________

%% Function to check the contents of a folder and looking for GUI compatible files that can be loaded to display them as options for the user

% Input:
% 1. executableFolder: Folder the GUI that currently runs is located (string)
% 2. NewFolderSelection: If user selected a new folder, path is passed and
% not asked from user in this function. Only for GUI purposes. When running
% as standalone function leave this empty! Within GUI this argument should
% be empty whenever you take the autofolder (GUIPath/SavedData)

% Output: 
%%%%% All outputs are empty when smt goes wrong (i.e. no suitable data files found)
% 1. SelectedFolder = Folder the user selected in this function (or NewFolderSelection when non empty)
% 2. DataMatfileindex = If .mat file containing data found, save index this file is in according to the order of folder components in stringArray (if .mat file first component of stringarray (first thing in folder), then this is 1)
% 3. DataDATfileindex = If .dat file containing data found, save index this file is in according to the order of folder components in stringArray (if .mat file first component of stringarray (first thing in folder), then this is 1)
% 4. Infofileindex = If .dat file containing data found, save index of all info files that corresponds to that .dat files (contains header and GUI infos like what preprocessing was applied)
% 5. InfoFiletoLoad = User selects a filename in the GUI he/she wants to load. When this is a .dat file, InfoFiletoLoad contains the info file that corresponds to that particular .dat file
% 6. Formatsfound = string array which formats where found. Contains .mat,
% .dat or both, depending in which formats where found. Empty if nothing
% found
% 7. DropDownMenuChar = Cell array containing chars that give the user the
% option to select file type. Ultimatively its Formatsfound variable in a
% cell format to pass as the .Items object of a dropdownmenu
% 8. DropDownMenu_2Char = Cell array containing chars that give the user the
% option to select different file names found under the file format selected.
% 9. stringArray = All folder components that where analyzed, excluding folder

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_Module_Load_NWBFile.m
%________________________________________________________________________________________

%% This function loads data saved in NeuroMod in the .nwb format using the MatNWB Toolbox

% Input:
% 1. FullDataPath: char, path to the .nwb file

% Output: 
% 1. Data: main app data structure holding all relevant data components
% 2. Textbox: char, result to show in the app text area. 

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_Module_Load_NeoDatData.m
%________________________________________________________________________________________

%% This function loads data saved in NeuroMod in a NEO compatible .mat file (can be loaded with NEO.io)

% Input:
% 1. FullDataPath: char, path to the .mat file with NEO data
% 2. FullPathInfo: char, path to the .mat file containing the Data.Info
% structure to load back into Neuromod with all necessary info

% Output: 
% 1. Data: main app data structure holding all relevant data components
% 2. Textbox: char, result to show in the app text area. 

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_Module_Load_NeuroModData.m
%________________________________________________________________________________________

%% Function to load data this toolbox created, saved either as a .mat or as a .dat file
% loading is performed with memory mapping function which gives the highest
% performance

% Input:
% 1. Format: Format of data to load; string either ".mat" or ".dat"
% 2. FullPath: Full Path the user selected to save data at. String
% including filename and fileending.
% 3. FullPathInfo: Path to the Info file saved along with the .dat data
% file, when .dat is selected as data format. If .mat is selected, Info file is saved in
% same .mat file as data and this input is disregarded
% 4. Textbox = handle to text in GUI displaying info

% Output: Datatoload = structure containing all data loaded (including info
% file) - i.e. Datatoload.Raw and Datatoload.Info and so on.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_Module_Load_SpikeInterface.m
%________________________________________________________________________________________

%% This function loads NeuroMod data back that was earlier saved in a spikeinterface compatible format 

% Input:
% 1. DataPath: char, path to the folder containing the saved spikeinterface
% data

% Output: 
% 1. Data: app.Data structure holding all relevant data components

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

