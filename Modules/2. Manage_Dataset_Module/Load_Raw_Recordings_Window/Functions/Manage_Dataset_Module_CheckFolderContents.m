function [Formatsfound,TextAreaText,ProbeInfoText,RecordingSystemDropDownItems,FileTypeDropDownItems,stringArray,SelectedFolder] = Manage_Dataset_Module_CheckFolderContents(ProbeInfo,PathToOpen)

%________________________________________________________________________________________

%% This function gets called when the user selects a folder in the Extract_Data_Window app window and checks the folder contents

% This function loops through all recording formats this toolbox supports
% and searches for them in the selected folder to determine the recording
% system and formats the user can select. This is a basic check whether a
% proper recording is found the GUI can handle every time the user selects a folder to extract raw data from. If nothing is found, the
% user will be informed and cant extract. This function also manages what
% is shown in the app window text area as info about available data

% Note: Open Ephys saves the recordings in a subfolder system that has
% standard names. Instead of checking the file ending of the recording
% files in the selected path
% (like .dat or .ncs), the code checks the subfolder names. More
% specifically if the folder contains subfolder having 'Record Node' in their
% name. Workflow: check all file endings (.dat .ncs and so on), if found than recording system was identified. If none
% found check for subfolder containg the string Record Node. If so, Open
% Ephys is the recording format, if not nothing was found. 

% Input:
% 1. ChannelOrder: To display channelorder in the textarea of the Extract_Data_Window app window
% 2. PathToOpen: char, path to auto-open when windows file explorer is used
% to get folder selection from user

% Output: 
% 1. Formatsfound: string array saving the format from AllFormats variable
% that was found in recording; options:
% [".dat'";".rhd'";".smrx'";".ncs'";".nse'";".dma'";".sdma'"] or folder
% named Record Node when open ephys is the format.
% 2. TextAreaText: Text area of Extract_Data_Window app window to show info
% when no proper data was found
% 3. ProbeInfoText: Text area of Extract_Data_Window app window to show
% folder contens and channelorder
% 4. RecordingSystemDropDownItems: Items shown in Extract_Data_Window app
% window capturing the recording system that was found. Cell array containg
% a char for each item. Either "Intan" OR "Spike2" OR "Neuralynx" OR "Open Ephys"
% 5. FileTypeDropDownItems: Items shown in Extract_Data_Window app
% window capturing the file formats found (.dat, .ncs and so on). Cell array containg
% a char for each item. Either ".dat" OR ".rhd" OR ".smrx" OR ".ncs" OR
% "Record Node ..." for open ephys
% 6: stringArray: nfoldercontens x 1 string array with as many elements as
% folder contens, capturing their name.
% 7. SelectedFolder: folderpath as char containing recording files

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

TextAreaText = [];
ProbeInfoText = [];
RecordingSystemDropDownItems = [];
FileTypeDropDownItems = [];
Formatsfound = [];
stringArray = [];

%% Show Info what file type the loaded folder should contain 
% If Intan selected as recording system

% stringtoshow = "Please select a folder containing data files of your recording.";
% msgbox(stringtoshow);

%% Get user selected folder and save as SelectedFolder
% Prompt the user to select a folder

if isfolder(PathToOpen)
    SelectedFolder = uigetdir(PathToOpen,'Select a folder with your recording data');
else
    SelectedFolder = uigetdir('Select a folder with your recording data');
end

if SelectedFolder == 0
    disp('No folder selected. Exiting.');

    if ~isfield(ProbeInfo,'NrChannel')
        ProbeInfoText = ["No folder selected or probe info specified!"];
    else
        if isempty(ProbeInfo.NrChannel)
            ProbeInfoText = ["No folder selected or probe info specified!"];
            return;
        end
    
        if ~isempty(ProbeInfo.Channelorder) && sum(isnan(ProbeInfo.Channelorder))==0
            texttoshow = sprintf('%d, ', ProbeInfo.Channelorder);
            % Remove the trailing comma and whitespace
            texttoshow(end-1:end) = [];
            
            ProbeInfoText = ["No folder selected!";"";"Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
        
        else
            ProbeInfoText = ["No folder selected!";"""Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: No";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
            
        end
    end
    return;
end

[stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);
% Convert the cell array to a string array

%% Loop through files types supported and determine whether they are part of the folder
% Use regular expression to extract filenames ending with '.smrx'
AllFormats = [".dat'";".rhd'";".smrx'";".ncs'";".nse'";".dma'";".sdma'";".plx'"];

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
    %% Search for open ephys data
    FolderIndicieWithEphysData = [];
    for foldercontents = 1:length(stringArray)
        if contains(stringArray(foldercontents),'Record Node')
            if isfolder(strcat(SelectedFolder,'\',stringArray(foldercontents)))
                FolderIndicieWithEphysData = [FolderIndicieWithEphysData,foldercontents];
            end
        end
    end

    if isempty(FolderIndicieWithEphysData) % if no open ephys data found
        TextAreaText = strcat("Error: No supported file types or recording systems found in ",SelectedFolder,".");
        TextAreaText = [TextAreaText;"Make sure the folder contains any of the Intan recording formats (.dat and .rhd), Open Ephys recording formats (.dat, .nwb, .continous), .ncs Neualynx format or .smrx Spike2 format."];
        %msgbox(TextAreaText);
        ProbeInfoText = "";
        return;
    else % if open ephys data found
        Formatsfound = [Formatsfound;"Open Ephys"];   
    end
end

% Check what file endings where found and set up window
% according to that
%% Intan 
if numel(Formatsfound) > 1 
    if numel(Formatsfound) == 2 && sum(contains(Formatsfound,".dat")) == 1 && sum(contains(Formatsfound,".rhd")) == 1
    else
        stringtoshow = strcat("Error: more than one file format found."," (",Formatsfound,")");
        msgbox(stringtoshow);
        return;
    end
end

if sum(contains(Formatsfound,".dat")) >= 1 || sum(contains(Formatsfound,".rhd")) >= 1
    RecordingSystemDropDownItems = {};
    RecordingSystemDropDownItems{1} =  'Intan';
    if sum(contains(Formatsfound,".dat")) >= 1 && sum(contains(Formatsfound,".rhd")) >= 1
        EmptyPlaceholder = {};
        FileTypeDropDownItems = EmptyPlaceholder;
        FileTypeDropDownItems{1} = 'Intan .dat';
    else
        EmptyPlaceholder = {};
        FileTypeDropDownItems = EmptyPlaceholder;
        FileTypeDropDownItems{1} = 'Intan .rhd';
    end
end

%% Neuralynx
% Loop through all file formats explicitely supported
FileTypeSelection = {};
currentit = 1;
if sum(contains(Formatsfound,".ncs")) >= 1 || sum(contains(Formatsfound,".nse")) >= 1 || sum(contains(Formatsfound,".dma")) >= 1 || sum(contains(Formatsfound,".sdma")) >= 1
    
    RecordingSystemDropDownItems = {};
    RecordingSystemDropDownItems{1} = 'Neuralynx';

    for i = 1:length(Formatsfound)
        if sum(contains(Formatsfound(i),".ncs")) >= 1
            FileTypeSelection{currentit} = 'neuralynx_ncs';
        elseif sum(contains(Formatsfound(i),".nse")) >= 1
            FileTypeSelection{currentit} = 'neuralynx_nse';
        elseif sum(contains(Formatsfound(i),".dma")) >= 1
            FileTypeSelection{currentit} = 'neuralynx_dma';
        elseif sum(contains(Formatsfound(i),".sdma")) >= 1
            FileTypeSelection{currentit} = 'neuralynx_sdma';
        end
        currentit = currentit+1;
    end
    FileTypeDropDownItems = FileTypeSelection;
end

%% Plexon
% Loop through all file formats explicitely supported
FileTypeSelection = {};
currentit = 1;
if sum(contains(Formatsfound,".plx")) >= 1 
    
    RecordingSystemDropDownItems = {};
    RecordingSystemDropDownItems{1} = 'Plexon';

    for i = 1:length(Formatsfound)
        if sum(contains(Formatsfound(i),".plx")) >= 1
            FileTypeSelection{currentit} = 'plexon_plx';
        end
        currentit = currentit+1;
    end
    FileTypeDropDownItems = FileTypeSelection;
end

%% Spike2
if sum(contains(Formatsfound,".smrx")) >= 1 
    RecordingSystemDropDownItems = {};
    RecordingSystemDropDownItems{1} = 'Spike2';
    EmptyPlaceholder = {};
    FileTypeDropDownItems = EmptyPlaceholder;
    FileTypeDropDownItems{1} = '.smrx';
end

%% Open Ephys

if contains(Formatsfound,"Open Ephys")
    RecordingSystemDropDownItems = {};
    RecordingSystemDropDownItems{1} =  'Open Ephys';
    EmptyPlaceholder = {};
    FileTypeDropDownItems = EmptyPlaceholder;
    for k = 1:length(FolderIndicieWithEphysData)
        FileTypeDropDownItems{k} = convertStringsToChars(stringArray(FolderIndicieWithEphysData(k)));
    end
end

%% Wrap up
if ~isfield(ProbeInfo,'NrChannel')

    ProbeInfoText = ["Data Folder:";SelectedFolder;"";"Probe Info:";"";"not defined"];
else
    if isempty(ProbeInfo.NrChannel)
        ProbeInfoText = ["Data Folder:";SelectedFolder;"";"Probe Info:";"";"not defined"];
        return;
    end

    if ~isempty(ProbeInfo.Channelorder) && sum(isnan(ProbeInfo.Channelorder))==0
        texttoshow = sprintf('%d, ', ProbeInfo.Channelorder);
        % Remove the trailing comma and whitespace
        texttoshow(end-1:end) = [];
        
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
    
        if isempty(SelectedFolder)

        else
            ProbeInfoText = ["Data Folder:";"";SelectedFolder;"";ProbeInfoText];
        end
    else
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: No";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
    
        if isempty(SelectedFolder)

        else
            ProbeInfoText = ["Data Folder:";"";SelectedFolder;"";ProbeInfoText];
        end
        
    end

    %ProbeInfoText = ["Data Folder:";SelectedFolder;"";ProbeInfoText];
end

