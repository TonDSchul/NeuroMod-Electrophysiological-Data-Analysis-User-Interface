function [ProbeInfoText,RecordingSystemDropDownItems,FileTypeDropDownItems,stringArray,SelectedFolder,Formatsfound] = Manage_Dataset_Module_NEO_Populate_Text(ProbeInfo,PathToOpen,JustCheck,SelectedFolder,RecordingType)

stringArray = [];
RecordingSystemDropDownItems = cell(1,1);
FileTypeDropDownItems = cell(1,1);
Formatsfound = [];

NeoTextNoFolder = ["No folder or file selected to pass to NEO:";"";"Using the NeuralEnsemble Neo library to extract data from a raw recording. If using NEO for the first time, you are asked for a path to the python.exe in the environment you installed Neo in. Please refer to the README how to install NEO and select the python.exe.";"";"First select a folder or file containing your recording data. Supported are all recording formats in the 'Select Recording System' dropdown menu.";" **NOTE** When you want to load Blackrock, NeuroExplorer or Plexon file formats, select a recording file, not a path! All recording formats in the 'Select Recording System' dropdown menu are supported. Selecting 'NEO Format Autodetection' will automatically detect the recording type. If that should not work, you can try without format autodetection by selecting your recording system in this window directly.";"";"**NOTE** Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, specify probe information. Required fields are channel number and channel spacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"";"After setting the probe information you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here. In doubt refer to the NEO documentation what folder or file to select for what recording type (for example there are differences between legacy and new open ephys recordings).";"";"After Neo extracted data, it is saved in the selected recording folder (extra folder is created) as a .dat file for channel data and .mat file for metadata. Those files are automatically loaded by Neuromod as soon as the python console closes and successfully saved the extracted recording. If you want to load the same dataset a second time, activate the 'Load Already Saved .dat file' checkbox to just load the .dat and .mat files saved earlier."];
NeoTextWithFolder = ["Using the NeuralEnsemble Neo library to extract data from a raw recording. If using NEO for the first time, you are asked for a path to the python.exe in the environment you installed Neo in. Please refer to the README how to install NEO and select the python.exe.";"";"First select a folder or file containing your recording data. Supported are all recording formats in the 'Select Recording System' dropdown menu.";" **NOTE** When you want to load Blackrock, NeuroExplorer or Plexon file formats, select a recording file, not a path! All recording formats in the 'Select Recording System' dropdown menu are supported. Selecting 'NEO Format Autodetection' will automatically detect the recording type. If that should not work, you can try without format autodetection by selecting your recording system in this window directly.";"";"**NOTE** Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, specify probe information. Required fields are channel number and channel spacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"";"After setting the probe information you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here. In doubt refer to the NEO documentation what folder or file to select for what recording type (for example there are differences between legacy and new open ephys recordings).";"";"After Neo extracted data, it is saved in the selected recording folder (extra folder is created) as a .dat file for channel data and .mat file for metadata. Those files are automatically loaded by Neuromod as soon as the python console closes and successfully saved the extracted recording. If you want to load the same dataset a second time, activate the 'Load Already Saved .dat file' checkbox to just load the .dat and .mat files saved earlier."];

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
        ProbeInfoText = [NeoTextNoFolder;"";"Probe Info:";"";"not defined"];
    else
        if isempty(ProbeInfo.NrChannel)
            ProbeInfoText = [NeoTextNoFolder;"";"Probe Info:";"";"not defined"];
            return;
        end
    
        if ~isempty(ProbeInfo.Channelorder) && sum(isnan(ProbeInfo.Channelorder))==0
            texttoshow = sprintf('%d, ', ProbeInfo.Channelorder);
            % Remove the trailing comma and whitespace
            texttoshow(end-1:end) = [];
            ProbeInfoText = [NeoTextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(ProbeInfo.OffSetRows));strcat("Nr Active Channel: ",num2str(length(ProbeInfo.ActiveChannel)))];
            
        else
            ProbeInfoText = [NeoTextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(ProbeInfo.OffSetRows));strcat("Nr Active Channel: ",num2str(length(ProbeInfo.ActiveChannel)))];
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

Neuralynx = 0;
Plexon = 0;
Formatsfound = [];
if sum(cell2mat(strfind(TempFormatsfound,'.ncs'))) > 0
    Neuralynx = 1;
    Formatsfound = [Formatsfound,'Neuralynx'];
end

if sum(cell2mat(strfind(TempFormatsfound,'.plx'))) > 0
    Formatsfound = [Formatsfound,'Plexon'];
end

%% ----------------- Wrap UP -----------------
if ~isfield(ProbeInfo,'NrChannel')
    ProbeInfoText = ["Path or file to recording that is passed to NEO:";"";SelectedFolder;"";NeoTextWithFolder;"";"Probe Info:";"";"not defined"];
else
    if isempty(ProbeInfo.NrChannel)
        ProbeInfoText = ["Path or file to recording that is passed to NEO:";"";SelectedFolder;"";NeoTextWithFolder;"";"Probe Info:";"";"not defined"];
        return;
    end

    if ~isempty(ProbeInfo.Channelorder) && sum(isnan(ProbeInfo.Channelorder))==0
        texttoshow = sprintf('%d, ', ProbeInfo.Channelorder);
        % Remove the trailing comma and whitespace
        texttoshow(end-1:end) = [];
        
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: Yes";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
    
        if isempty(SelectedFolder)

        else
             ProbeInfoText = ["Path or file to recording that is passed to NEO:";"";SelectedFolder;"";NeoTextWithFolder;"";ProbeInfoText];
        end
    else
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",num2str(ProbeInfo.NrChannel));strcat("Channel Spacing: ",num2str(ProbeInfo.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(ProbeInfo.NumberChannelRows));"Costum Channel Order: No";strcat("Active Channel: ",num2str(ProbeInfo.ActiveChannel))];
    
        if isempty(SelectedFolder)

        else
            ProbeInfoText = ["Path or file to recording that is passed to NEO:";"";SelectedFolder;"";NeoTextWithFolder;"";ProbeInfoText];
        end
        
    end
end

TempFormatsfound(TempFormatsfound=="") = [];
RecordingSystemDropDownItems{1} = "NEO";
if ~isempty(TempFormatsfound)
    FileTypeDropDownItems{1} = TempFormatsfound;
else
    FileTypeDropDownItems{1} = [];
end
