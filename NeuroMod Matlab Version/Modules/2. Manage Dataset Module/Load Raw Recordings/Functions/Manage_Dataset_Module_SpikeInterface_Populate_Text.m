function [ProbeInfoText,RecordingSystemDropDownItems,FileTypeDropDownItems,stringArray,SelectedFolder,Formatsfound] = Manage_Dataset_Module_SpikeInterface_Populate_Text(ProbeInfo,PathToOpen,JustCheck,SelectedFolder,RecordingType)

%________________________________________________________________________________________

%% This function shows infos about SpikeInterface library recording extraction in the text are of the load raw recording window

% Input:
% 1. ProbeInfo: struture holding probe info (if present) to add to text
% area content
% 2. PathToOpen: path to automatically open the file selection explorer in 
% 3. JustCheck: don let user seelct a folder, just check contents of
% already selected folder
% 4. SelectedFolder: char, path to an already selected recording fodler 
% 5. RecordingType: char, from Data.Info (not used anymore but will maybe get important)

% Output: 
% 1. ProbeInfoText: Text to show in the window text area
% RecordingSystemDropDownItems: cell array each containing a char with the
% options for the user for the auotdetected recording system dropdown
% FileTypeDropDownItems: cell array each containing a char with the
% options for the user for the file format dropdown menu
% stringArray: n x 1 string array holding the folder contents (files)
% SelectedFolder: char, folder to recording selected
% Formatsfound: string array with all formats found (from this selection: .ncs, .nlx, .nex)

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


stringArray = [];
RecordingSystemDropDownItems = cell(1,1);
FileTypeDropDownItems = cell(1,1);
Formatsfound = [];

SITextNoFolder = ["No folder or file selected to pass to SpikeInterface:";"";"Using the SpikeInterface library to extract data from a raw recording. If using SpikeInterface for the first time, you are asked for a path to the python.exe in the environment you installed the package in. Please refer to the README how to install SpikeInterface and select the python.exe.";"";"First select a folder or file containing your recording data. Currently supported formats that can be loaded into NeuroMod using SpikeInterface include Maxwell MEA .h5 recordings.";"You do not need to specify a probe design, it is automatically created based on the recording meta data. Probe design can be saved as .mat or .prb file to use in external Kilosort GUI and/or your own SpikeInterface pipeline.";"";"**NOTE**";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, it will be auto-searched for a suitable recording format. If it found one compatible with SpikeInterface, you can select it as the data extraction library to use.";"";"After SpikeInterface extracted data, it is saved in a newly created folder next to the recording folder to be loaded into NeuroMod. You can determine the format it is saved in (for further personal use) using the 'Format to Save and Read into Matlab' dropdown menu. 'Costum format' saves a .dat file for channel data and .mat file for meta – and event data. The next time you want to load a recording you already extracted, select the 'Load Already Saved Files' checkbox to skip data extraction with SpikeInterface and load the saved file immediately.";"";"After selecting a folder, you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here."];
SITextWithFolder = ["Using the SpikeInterface library to extract data from a raw recording. If using SpikeInterface for the first time, you are asked for a path to the python.exe in the environment you installed SpikeInterface in. Please refer to the README how to install SpikeInterface and select the python.exe.";"";"You do not need to specify a probe design, it is automatically created based on the recording meta data. Probe design can be saved as .mat or .prb file to use in external Kilosort GUI and/or your own SpikeInterface pipeline.";"";"**NOTE**";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, it will be auto-searched for a suitable recording format. If it found one compatible with SpikeInterface, you can select it as the data extraction library to use.";"";"After SpikeInterface extracted data, it is saved in a newly created folder next to the recording folder to be loaded into NeuroMod. You can determine the format it is saved in (for further personal use) using the 'Format to Save and Read into Matlab' dropdown menu. 'Costum format' saves a .dat file for channel data and .mat file for meta – and event data. The next time you want to load a recording you already extracted, select the 'Load Already Saved Files' checkbox to skip data extraction with SpikeInterface and load the saved file immediately.";"";"After selecting a folder, you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here."];
 
%% ----------------- Select Folder -----------------
if JustCheck == 0
    disp("Please select a folder with your recording.")
    if isfolder(PathToOpen)
        SelectedFolder = uigetdir(PathToOpen,'Select a folder with your recording data');
    else
        SelectedFolder = uigetdir('Select a folder with your recording data');
    end
end

%% ----------------- No Folder Selected -----------------
% Check Folder 
if SelectedFolder == 0
    disp('No folder selected. Exiting.');

    if ~isfield(ProbeInfo,'NrChannel')
        ProbeInfoText = [SITextNoFolder;"";"Probe Info:";"";"not defined"];
    else
        if isempty(ProbeInfo.NrChannel)
            ProbeInfoText = [SITextNoFolder;"";"Probe Info:";"";"not defined"];
            return;
        end
    
        if ~isempty(ProbeInfo.Channelorder) && sum(isnan(ProbeInfo.Channelorder))==0
            texttoshow = sprintf('%d, ', ProbeInfo.Channelorder);
            % Remove the trailing comma and whitespace
            texttoshow(end-1:end) = [];
            ProbeInfoText = [SITextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(ProbeInfo.OffSetRows));strcat("Nr Active Channel: ",num2str(length(ProbeInfo.ActiveChannel)))];
            
        else
            ProbeInfoText = [SITextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(ProbeInfo.OffSetRows));strcat("Nr Active Channel: ",num2str(length(ProbeInfo.ActiveChannel)))];
        end
    end
    return;
else
    [stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);
    TempFormatsfound = strings(size(stringArray)); % Preallocate

    for k = 1:numel(stringArray)
        [~,~,ext] = fileparts(stringArray(k));
        TempFormatsfound(k) = ext; % Keeps the dot, e.g., '.csv'
    end

end

MaxwellMEA = 0;
Formatsfound = [];

if sum(cell2mat(strfind(TempFormatsfound,'.h5'))) > 0
    MaxwellMEA = 1;
    Formatsfound = [Formatsfound,'Maxwell MEA .h5'];
end

%% ----------------- Wrap UP -----------------
if ~isfield(ProbeInfo,'NrChannel')
    ProbeInfoText = ["Path or file to recording that is passed to SpikeInterface:";"";SelectedFolder;"";SITextWithFolder;"";"Probe Info:";"";"not defined"];
else
    if isempty(ProbeInfo.NrChannel)
        ProbeInfoText = ["Path or file to recording that is passed to SpikeInterface:";"";SelectedFolder;"";SITextWithFolder;"";"Probe Info:";"";"not defined"];
        return;
    end

    if ~isempty(ProbeInfo.Channelorder) && sum(isnan(ProbeInfo.Channelorder))==0
        texttoshow = sprintf('%d, ', ProbeInfo.Channelorder);
        % Remove the trailing comma and whitespace
        texttoshow(end-1:end) = [];
        
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
    
        if isempty(SelectedFolder)

        else
             ProbeInfoText = ["Path or file to recording that is passed to SpikeInterface:";"";SelectedFolder;"";SITextWithFolder;"";ProbeInfoText];
        end
    else
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: No";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
    
        if isempty(SelectedFolder)

        else
            ProbeInfoText = ["Path or file to recording that is passed to SpikeInterface:";"";SelectedFolder;"";SITextWithFolder;"";ProbeInfoText];
        end
        
    end
end

TempFormatsfound(TempFormatsfound=="") = [];
RecordingSystemDropDownItems{1} = "SpikeInterface";
if ~isempty(TempFormatsfound)
    FileTypeDropDownItems{1} = TempFormatsfound;
else
    FileTypeDropDownItems{1} = [];
end
