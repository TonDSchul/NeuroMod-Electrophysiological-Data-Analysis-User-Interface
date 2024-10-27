function [SelectedFolder,DataMatfileindex,DataDATfileindex,Infofileindex,InfoFiletoLoad,Formatsfound,DropDownMenuChar,DropDownMenu_2Char,stringArray] = Manage_Dataset_Module_LoadGUIDataCheckFolderContents(executableFolder,NewFolderSelection)

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

DataMatfileindex = [];
DataDATfileindex = [];
Infofileindex = [];
InfoFiletoLoad = [];
DropDownMenuChar = {};
DropDownMenu_2Char = {};

% Go in GUI directory
cd(executableFolder);

if isempty(NewFolderSelection) % If folder no manually set by user 
    % Autoset folder which contents should be checked 
    SelectedFolder = [executableFolder,'\Recording Data\Saved GUI Data'];
else
    SelectedFolder = NewFolderSelection;
end

% Extract components of the folder. stringArray = string for each component
% found (includes folder)
[stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);

% Some dont contain a dot for the data format since its a folder. those
% have to be excluded

% Find index of string with no dot
Indextodelete = [];
for i = 1:length(stringArray)
    if ~strcmp(stringArray(i),"")
        if ~contains(stringArray(i),'.')
            Indextodelete = [Indextodelete,i];
        end
    end
end
% Delete index of string with no dot
if ~isempty(Indextodelete)
    stringArray(Indextodelete) = [];
end

%% Loop through files types supported and determine whether they are part of the folder
% Use regular expression to extract filenames ending with '.smrx'
AllFormats = [".dat'";".mat'"];

Formatsfound = [];

% Loop through all contents of dfolder and compare file endings
% with prefedined endings. Save endings found as strings in Formatsfound
for i = 1:numel(AllFormats)
    StringFilexists = strcat("regexp(stringArray, '\S+\",AllFormats(i),", 'match')");
    Filexists = eval(StringFilexists);
    nonEmptyIndices = find(~cellfun(@isempty, Filexists));
    if ~isempty(nonEmptyIndices)
        Formatsfound = [Formatsfound;AllFormats(i)];   
    end
end

% If no supported format found: return
if isempty(Formatsfound)
    return;
end

%% Check if mat files are just info files or if they hold data
CheckJustInfo = 0;
matfilecount = 0;

for i = 1:length(stringArray)
    if ~strcmp(stringArray(i),"") && contains(stringArray(i),'.')
        currentstring = convertStringsToChars(stringArray(i));
        if length(currentstring) >=8
            if strcmp(currentstring(end-3:end),".mat") && ~strcmp(currentstring(end-7:end-4),"Info")
                %% Check if selected mat file contains correct variable
                variableName = 'Raw';  % Variable you want to load
                
                % Get the list of variables in the file
                variablesInFile = who('-file', strcat(SelectedFolder,'\',currentstring));
                
                % Check if the desired variable exists
                if ~ismember(variableName, variablesInFile)
                    %msgbox(strcat("Variable ", variableName," does not exist in the manually selected file ",ScalingFactorPath32));
                    continue;  % Exit if the variable does not exist
                else
                    matfilecount = matfilecount + 1;
                    DataMatfileindex = [DataMatfileindex,i];
                end
            end
        end

        if strcmp(currentstring(end-3:end),".dat")
            DataDATfileindex = [DataDATfileindex,i];
        end

        % No data mat file
        if length(currentstring) >=8
            if strcmp(currentstring(end-3:end),".mat") && strcmp(currentstring(end-7:end-4),"Info")
                %% Check if selected mat file contains correct variable
                variableName = 'Info';  % Variable you want to load
                
                % Get the list of variables in the file
                variablesInFile = who('-file', strcat(SelectedFolder,'\',currentstring));
                
                % Check if the desired variable exists
                if ~ismember(variableName, variablesInFile)
                    %msgbox(strcat("Variable ", variableName," does not exist in the manually selected file ",ScalingFactorPath32));
                    continue;  % Exit if the variable does not exist
                else
                    CheckJustInfo = CheckJustInfo +1;
                    Infofileindex = [Infofileindex,i];
                end

                
            end
        end
    end
end

%% Fill out fields automatically based on what was found in the folder
Index = 1;

DropDownMenuChar = cell(1,1);
DropDownMenu_2Char = cell(1,1);

if ~isempty(DataDATfileindex)
    DropDownMenu_2Char = cell(1,length(DataDATfileindex));
else
    if ~isempty(DataMatfileindex)
        DropDownMenu_2Char = cell(1,length(DataDATfileindex));
    end
end

if find(Formatsfound == ".dat'")
    DropDownMenuChar{Index} = '.dat';
    for i = 1:length(DataDATfileindex)
        DropDownMenu_2Char{i} = convertStringsToChars(stringArray(DataDATfileindex(i)));
    end
    Index = Index+1;
end

if ~isempty(DataMatfileindex)
    DropDownMenuChar{Index} = '.mat';
    if Index == 1
        for i = 1:length(DataMatfileindex)
            DropDownMenu_2Char{i} = convertStringsToChars(stringArray(DataMatfileindex(i)));
        end
    end
end

%% Save info files (.mat files) seperately. Each info file corresponds to a data file with the same name!
if find(Formatsfound == ".dat'")
    for i = 1:length(Infofileindex)
        Infofilename = convertStringsToChars(stringArray(Infofileindex(i)));
        if length(Infofilename) >= 10
            if strcmp(Infofilename(1:end-9),DropDownMenu_2Char{1}(1:end-4))
                InfoFiletoLoad = Infofilename;
            end
        end
    end
end