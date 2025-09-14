This folder contains the following functions with respective Header:

 ###################################################### 

File: Manage_Dataset_Module_LoadData.m
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

