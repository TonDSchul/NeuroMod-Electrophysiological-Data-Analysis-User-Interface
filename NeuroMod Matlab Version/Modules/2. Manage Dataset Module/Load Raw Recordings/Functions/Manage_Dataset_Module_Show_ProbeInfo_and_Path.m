function [Load_Data_Window_Info,ProbeInfoText,FolderContentsText] = Manage_Dataset_Module_Show_ProbeInfo_and_Path(app,Load_Data_Window_Info,ProbeInfoOrFolder,PathToOpen,JustCheck,FolderToCheck,ExtractWithNeo,RecordingType,JustChangeLibrary)

%________________________________________________________________________________________

%% This function shows the info about selected path and probe info in the extract data window

% gets called whenever the user selects a new probe desing or folder

% Input:
% 1. app: extract data window object
% 2. Load_Data_Window_Info: structure with info about selected folder and probe.
% 3. ProbeInfoOrFolder: string, specifies what to do when, either "ProbeInfo" OR
% "FolderSelection" OR "AutorunFolderSelection", deoending on which info
% the user changed
% 4: PathToOpen: char, path to auto-open when windows file explorer is used
% to get folder selection from user
% 5. JustCheck: double, 1 or 0; 1 to just check a folder and not ask to
% seelct a new one
% 6. FolderToCheck: char, path to the folder to check if JustCheck is 1
% 7. ExtractWithNeo: char, either 'NeuroMod Matlab' OR 'NeuralEnsemble NEO Python Library'
% 8. RecordingType: char, data format selected when extracting data with
% neo

% Output: 
% 1. Load_Data_Window_Info: same as input struvture
% 2. ProbeInfoText: Text to show in window
% 3. FolderContentsText: Folder contents found

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

ProbeInfoText = [];
FolderContentsText = [];

NeoTextNoFolder = ["No folder or file selected to pass to NEO:";"";"Using the NeuralEnsemble NEO library to extract data from a raw recording. If using NEO for the first time, you are asked for a path to the python.exe in the environment you installed the package in. Please refer to the README how to install NEO and select the python.exe.";"";"First select a folder or file containing your recording data. Currently supported formats that can be loaded into NeuroMod using NEO include Neuralynx, Plexon and Open Ephys recordings.";"";"**NOTE**";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, it will be auto-searched for a suitable recording format. If it found one compatible with NEO, you can select it as the data extraction library to use. The 'Select Recording System' dropdown allows you to use NEO's format autodetection or directly use the format detection already done in Matlab (switch in case of incompatibilities).";"";"After Neo extracted data, it is saved in a newly created folder next to the recording folder to be loaded into NeuroMod. You can determine the format it is saved in (for further personal use) using the 'Format to Save and Read into Matlab' dropdown menu. Neo format .mat files are created using a function of NEO directly, while 'costum format' saves a .dat file for channel data and .mat file for meta – and event data. The next time you want to load a recording you already extracted, select the 'Load Already Saved Files' checkbox to skip data extraction with NEO and load the saved file immediately.";"";"After selecting a folder, specify probe information. Required fields are channel number and channel spacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"";"After setting the probe information you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here."];
NeoTextWithFolder = ["Using the NeuralEnsemble Neo library to extract data from a raw recording. If using NEO for the first time, you are asked for a path to the python.exe in the environment you installed Neo in. Please refer to the README how to install NEO and select the python.exe.";"";"**NOTE**";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software!";"";"After selecting a folder, it will be auto-searched for a suitable recording format. If it found one compatible with NEO, you can select it as the data extraction library to use. The 'Select Recording System' dropdown allows you to use NEO's format autodetection or directly use the format detection already done in Matlab (switch in case of incompatibilities).";"";"After Neo extracted data, it is saved in a newly created folder next to the recording folder to be loaded into NeuroMod. You can determine the format it is saved in (for further personal use) using the 'Format to Save and Read into Matlab' dropdown menu. Neo format .mat files are created using a function of NEO directly, while 'costum format' saves a .dat file for channel data and .mat file for meta – and event data. The next time you want to load a recording you already extracted, select the 'Load Already Saved Files' checkbox to skip data extraction with NEO and load the saved file immediately.";"";"After selecting a folder, specify probe information. Required fields are channel number and channel spacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"";"After setting the probe information you can start the data extraction.";"This opens a python console prompt window showing the progress of data extraction. If something should not work, activate the 'Keep Console Open' checkbox to see potential error messages (and make sure to press enter in the console after the python script finished!). If the folder should NOT contain a suitable recording, you are being informed about it here."];
             
MatlabTextNoFolder = ["No folder or file selected to pass to Matlab:";"";"Please select a folder containing your recording data. Supported are formats recorded with the Open Ephys GUI, Intan RHX data acquisition software (and legacy RHD software), Spike2 as well as Neuralynx Cheetah and Tucker Davis (TDT) recordings. This includes binary, .nwb and Open Ephys data formats from the Open Ephys GUI recorded with Neuropixels, Open Ephys and Intan acquisition boards; .dat and .rhd files from the Intan RHX and RHD software; .smrx files from Spike2, .ncs (and accompanying) Neuralynx files from Chetaah and .sev (and accompanying) files for TDT recordings. Folder contents, file types and recording system will be shown automatically if folder contains one of the supported file types.";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software OR this GUI!";"";"After selecting a folder, specify probe information. Required fields are channel number and channelspacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"After setting the probe information you can start the data extraction.";"";"Note: For Open Ephys data the expected folder structure is Date/Record Node/experiment/recordings/.... Multiple recordings within the same sessions can be concatonated or loaded individually. Please make sure only one recording session is present in the selected file, independent of the file format and recording system!"];
MatlabTextWithFolder = ["Folder contents, file types and recording system will be shown automatically if folder contains one of the supported file types.";"Please make sure that the standard folder structure created by the recording software is NOT changed and the recording folder only contains files and folder created by the recording software OR this GUI!";"";"After selecting a folder, specify probe information. Required fields are channel number and channelspacing to specify the probe geometry. Active channel specify the amount and identity of probe channels you recorded from. The number of channels in your recording has to be the same as the number of elements in your active channel selection!";"After setting the probe information you can start the data extraction.";"";"Note: For Open Ephys data the expected folder structure is Date/Record Node/experiment/recordings/.... Multiple recordings within the same sessions can be concatonated or loaded individually. Please make sure only one recording session is present in the selected file, independent of the file format and recording system!"];

%%------------------- Set Probe View Information -------------------
if strcmp(ProbeInfoOrFolder,"ProbeInfo")
    
    FolderContentsText = []; % not needed here but got to be defined as a output argument

    if ~isfield(Load_Data_Window_Info,'selectedFolder')
        Load_Data_Window_Info.selectedFolder = [];
    end
    
    if isempty(app.ChannelSpacingumEditField.Value)
        msgbox("Error: Please first input a channel spacing for your probe design! Returning")
        return;
    end
    if isempty(app.NrChannelEditField.Value)
        msgbox("Error: Please first input a channel number for your probe design! Returning")
        return;
    end
    
    Load_Data_Window_Info.ChannelSpacing = str2double(app.ChannelSpacingumEditField.Value);
    Load_Data_Window_Info.NrRows = str2double(app.ChannelRowsDropDown.Value);

    Load_Data_Window_Info.SwitchTopBottomChannel = double(app.ReverseTopandBottomChannelNumberCheckBox.Value);
    Load_Data_Window_Info.SwitchLeftRightChannel = double(app.SwitchLeftandRightChannelNumberCheckBox.Value);

    Load_Data_Window_Info.FlipLoadedData = double(app.ReverseTopandBottomChannelNumberCheckBox_2.Value);
    
    if isempty(app.ActiveChannelField.Value{1})
        Load_Data_Window_Info.ActiveChannel = 1:str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value);
    else
        if length(str2double(strsplit(app.ActiveChannelField.Value{1},','))) > str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value)
            msgbox("Error: Number of active channel exceeds number of channel specified!")
            return;
        else
            Load_Data_Window_Info.ActiveChannel = sort(str2double(strsplit(app.ActiveChannelField.Value{1},',')));
            if Load_Data_Window_Info.SwitchTopBottomChannel == 1
                Load_Data_Window_Info.ActiveChannel = (str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value)+1)-Load_Data_Window_Info.ActiveChannel;
            end
        end
    end
    
    Load_Data_Window_Info.NumberChannelRows = str2double(app.ChannelRowsDropDown.Value);
    Load_Data_Window_Info.NrChannel = str2double(app.NrChannelEditField.Value);
    
    Load_Data_Window_Info.OffSetRows = app.CheckBox.Value;
    Load_Data_Window_Info.ECoGArray = app.ECoGArrayCheckBox.Value;

    if ~isempty(app.VerticalOffsetumEditField_2.Value)
        Load_Data_Window_Info.OffSetRowsDistance = app.VerticalOffsetumEditField_2.Value;
    else
        Load_Data_Window_Info.OffSetRowsDistance = '0';
    end

    if isempty(app.HorizontalOffsetumEditField.Value)
        Load_Data_Window_Info.HorizontalOffsetum = 0;
    else
        Load_Data_Window_Info.HorizontalOffsetum = str2double(app.HorizontalOffsetumEditField.Value);
    end
    if isempty(app.HorizontalOffsetumEditField.Value)
        Load_Data_Window_Info.VerticalOffsetum = 0;
    else
        Load_Data_Window_Info.VerticalOffsetum = str2double(app.VerticalOffsetumEditField.Value);
    end
    
    if isempty(app.ChannelOrderField.Value)
        Load_Data_Window_Info.Channelorder = [];
    else
        if length(str2double(strsplit(app.ChannelOrderField.Value{1}, ','))) > str2double(app.NrChannelEditField.Value)*str2double(app.ChannelRowsDropDown.Value) || length(str2double(strsplit(app.ChannelOrderField.Value{1}, ','))) > length(Load_Data_Window_Info.ActiveChannel)
            msgbox("Error: Number of channel order elements exceeds number of active channel or total number of channel!")
            return;
        else
    
        end
        % Split the string by commas
        split_array = strsplit(app.ChannelOrderField.Value{1}, ',');
        
        % Convert each element to double
        Load_Data_Window_Info.Channelorder = str2double(split_array);
    end
end

%% ------------------- Define Text After Probe View Window is closed -------------------
if strcmp(ProbeInfoOrFolder,"ProbeInfo") 
    %tempChOrder = app.Load_Data_Window_Info.Channelorder;

    if ~isempty(Load_Data_Window_Info.Channelorder) && sum(isnan(Load_Data_Window_Info.Channelorder))==0
        
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",app.NrChannelEditField.Value);strcat("Channel Spacing: ",app.ChannelSpacingumEditField.Value);strcat("Nr Channel Rows: ",app.ChannelRowsDropDown.Value);"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(app.CheckBox.Value));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
         
        if isempty(Load_Data_Window_Info.selectedFolder)
            if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                ProbeInfoText = [MatlabTextNoFolder;"";ProbeInfoText];
            else
                ProbeInfoText = [NeoTextNoFolder;"";ProbeInfoText];
            end

            %app.ExtractRecordingWindow.TextArea.Value = ProbeInfoText;
        else
            if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                ProbeInfoText = ["Path to recording folder that is passed to Matlab:";"";Load_Data_Window_Info.selectedFolder;"";MatlabTextWithFolder;"";ProbeInfoText];
            else
                ProbeInfoText = ["Path to recording folder that is passed to NEO:";"";Load_Data_Window_Info.selectedFolder;"";NeoTextWithFolder;"";ProbeInfoText];
            end
            %app.ExtractRecordingWindow.TextArea.Value = ["Data Folder:";"";Load_Data_Window_Info.selectedFolder;"";ProbeInfoText];
        end
    else
        ProbeInfoText = ["Probe Information:";"";strcat("Nr Channel: ",app.NrChannelEditField.Value);strcat("Channel Spacing: ",app.ChannelSpacingumEditField.Value);strcat("Nr Channel Rows: ",app.ChannelRowsDropDown.Value);"Costum Channel Order: No";strcat("Offset Every Second Row: ",num2str(app.CheckBox.Value));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
    
        if isempty(Load_Data_Window_Info.selectedFolder)
            if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                ProbeInfoText = [MatlabTextNoFolder;"";ProbeInfoText];
            else
                ProbeInfoText = [NeoTextNoFolder;"";ProbeInfoText];
            end
        else
            %app.ExtractRecordingWindow.TextArea.Value = ["Data Folder:";"";Load_Data_Window_Info.selectedFolder;"";ProbeInfoText];
            if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                ProbeInfoText = ["Path to recording folder that is passed to Matlab:";"";Load_Data_Window_Info.selectedFolder;"";MatlabTextWithFolder;"";ProbeInfoText];
            else
                ProbeInfoText = ["Path to recording folder that is passed to NEO:";"";Load_Data_Window_Info.selectedFolder;"";NeoTextWithFolder;"";ProbeInfoText];
            end
        end
    end
    
    %% Probe Trajectory if loaded
    
    if isfield(app.ProbeTrajectoryInfo,'AreaNamesLong')
       Load_Data_Window_Info.ProbeTrajectoryInfo = app.ProbeTrajectoryInfo;
    else
    
    end
end

%% ----------------- Populate Text are after folder selection button was pressed -----------------
if strcmp(ProbeInfoOrFolder,"FolderSelection") || strcmp(ProbeInfoOrFolder,"AutorunFolderSelection") || strcmp(ProbeInfoOrFolder,"JustChangeLibrary")
    NoFormatFound = 0;

    %% -------- First check if Matlab Library Format --------
    [TempFormatsfound,FolderContentsText,ProbeInfoText,RecordingSystemDropDownItems,FileTypeDropDownItems,stringArray,SelectedFolder] = Manage_Dataset_Module_CheckFolderContents(app.ProbeInfoandPath,PathToOpen,JustCheck,FolderToCheck);
    
    if isempty(TempFormatsfound)
        NoFormatFound = 1;
    end
    if length(TempFormatsfound)>1 && isempty(RecordingSystemDropDownItems)
        FolderContentsText = "Folder possibly contains recordings of multiple recording systems. Please select a folder with only a single recording of a single recording system.";
        Load_Data_Window_Info.selectedFolder = [];
        ProbeInfoText = strcat("Multiple File Formats selected: ",TempFormatsfound,". Make sure to only have one of those in the selcted folder!");
        return;
    end
    % initialize
    Formatsfound = [];

    %% Only for OE NEO! 
    OENEODropdownSet = 0;
    % open ephys when NEO selected: offer new and legacy version support
    if JustChangeLibrary == 1 && strcmp(ExtractWithNeo,"NeuralEnsemble NEO Python Library")
        if ~isempty(RecordingSystemDropDownItems)
            if contains(TempFormatsfound,"Open Ephys")
                RecordingSystemDropDownItems = {};
                RecordingSystemDropDownItems{1} = 'NEO New Open Ephys Format';
                RecordingSystemDropDownItems{2} = 'NEO Legacy Open Ephys Format';
                OENEODropdownSet = 1;
            end
        end
    end

    if ~isempty(RecordingSystemDropDownItems)
        Formatsfound.Format = TempFormatsfound;
        Formatsfound.Library = [];
        if contains(TempFormatsfound,".ncs")
            if JustChangeLibrary == 0 % on startup
                ExtractWithNeo = "NeuralEnsemble NEO Python Library";
                Formatsfound.Library = ["NeuralEnsemble NEO Python Library","NeuroMod Matlab"];
            else
                Formatsfound.Library = ["NeuralEnsemble NEO Python Library","NeuroMod Matlab"];
            end
        elseif contains(TempFormatsfound,"Open Ephys")
            if JustChangeLibrary == 0 % on startup
                ExtractWithNeo = "NeuroMod Matlab";
                Formatsfound.Library = ["NeuroMod Matlab","NeuralEnsemble NEO Python Library"];
            else
                Formatsfound.Library = ["NeuroMod Matlab","NeuralEnsemble NEO Python Library"];
            end
        % elseif contains(TempFormatsfound,"NeuroExplorer")
        %     if JustChangeLibrary == 0 % on startup
        %         ExtractWithNeo = "NeuralEnsemble NEO Python Library";
        %         Formatsfound.Library = "NeuralEnsemble NEO Python Library";
        %     else
        %         Formatsfound.Library = "NeuralEnsemble NEO Python Library";
        %     end
        elseif contains(TempFormatsfound,".raw.h5")
            ExtractWithNeo = "SpikeInterface Python Library";
            Formatsfound.Library = "SpikeInterface Python Library";
        else
            if JustChangeLibrary == 0 % on startup
                ExtractWithNeo = "NeuroMod Matlab";
                Formatsfound.Library = [Formatsfound.Library,"NeuroMod Matlab"];
            else
                Formatsfound.Library = [Formatsfound.Library,"NeuroMod Matlab"];
            end
        end
    end
    
    % No Matlab internal supported format found -- search for NEO
    % compatible formats
    if ~isempty(TempFormatsfound)
        FormatIndice = [];
        for ii = 1:length(TempFormatsfound)
            if contains(TempFormatsfound(ii),'.plx') ||  contains(TempFormatsfound(ii),'.sev') || contains(TempFormatsfound(ii),'.tev') || contains(TempFormatsfound(ii),'.nex')
                if contains(TempFormatsfound(ii),'.plx')
                    Formatsfound.Format = 'Plexon';
                elseif contains(TempFormatsfound(ii),'.sev') || contains(TempFormatsfound(ii),'.tev')
                    Formatsfound.Format = 'TdT';
                elseif contains(TempFormatsfound(ii),'.nex')
                    Formatsfound.Format = 'NeurExplorer';
                end

                if strcmp(Formatsfound.Format,'TdT')
                    ExtractWithNeo = "NeuroMod Matlab";
                    Formatsfound.Library = "NeuroMod Matlab";
                else
                    ExtractWithNeo = "NeuralEnsemble NEO Python Library";
                    Formatsfound.Library = "NeuralEnsemble NEO Python Library";
                end

                break;
            end
        end
        if isempty(Formatsfound)
            NoFormatFound = 1;
        end
    else
        if isempty(RecordingSystemDropDownItems)
            NoFormatFound = 1;
        end
    end
   

    %% get infos from selected neo folder
    if ~isempty(ExtractWithNeo)
        if strcmp(ExtractWithNeo ,"NeuralEnsemble NEO Python Library") && NoFormatFound == 0
    
            if SelectedFolder == 0 % if not on startup
                SelectedFolder = FolderToCheck;
            end
            
            [ProbeInfoText,TempRecordingSystemDropDownItems,tempFileTypeDropDownItems,stringArray,SelectedFolder,~] = Manage_Dataset_Module_NEO_Populate_Text(app.ProbeInfoandPath,PathToOpen,1,SelectedFolder,RecordingType);
            
            if OENEODropdownSet == 0
                if ~isempty(TempRecordingSystemDropDownItems) && ~isempty(RecordingSystemDropDownItems)
                    RecordingSystemDropDownItems{1} = convertStringsToChars(strcat("NEO ",RecordingSystemDropDownItems{1}));
                end
                if ~isempty(TempRecordingSystemDropDownItems) && isempty(RecordingSystemDropDownItems)
                    RecordingSystemDropDownItems{1} = convertStringsToChars(strcat(TempRecordingSystemDropDownItems{1}," ",Formatsfound.Format));
                end
            end
            FolderContentsText = [];
            if isempty(FileTypeDropDownItems)
                if length(tempFileTypeDropDownItems{1}) > 1 && strcmp(RecordingSystemDropDownItems{1},"NEO TdT")
                    a = tempFileTypeDropDownItems{1} == ".sev";
                    b = find(a == 1);
                    FileTypeDropDownItems{1} = convertStringsToChars(tempFileTypeDropDownItems{1}(b(1)));
                else
                    FileTypeDropDownItems{1} = convertStringsToChars(tempFileTypeDropDownItems{1});
                end
            end
            
            %FileTypeDropDownItems{1} = convertStringsToChars(strcat(FileTypeDropDownItems{1}," ",Formatsfound));
        end
    end
    %% get infos from selected SpikeInterface folder
    if ~isempty(ExtractWithNeo)
        if strcmp(ExtractWithNeo ,"SpikeInterface Python Library") && NoFormatFound == 0
    
            if SelectedFolder == 0 % if not on startup
                SelectedFolder = FolderToCheck;
            end
            
            [ProbeInfoText,TempRecordingSystemDropDownItems,tempFileTypeDropDownItems,stringArray,SelectedFolder,~] = Manage_Dataset_Module_SpikeInterface_Populate_Text(app.ProbeInfoandPath,PathToOpen,1,SelectedFolder,RecordingType);

            if ~isempty(TempRecordingSystemDropDownItems) && ~isempty(RecordingSystemDropDownItems)
                RecordingSystemDropDownItems{1} = convertStringsToChars(strcat("SpikeInterface ",RecordingSystemDropDownItems{1}));
            end
            if ~isempty(TempRecordingSystemDropDownItems) && isempty(RecordingSystemDropDownItems)
                RecordingSystemDropDownItems{1} = convertStringsToChars(strcat(TempRecordingSystemDropDownItems{1}," ",Formatsfound.Format));
            end
           
            FolderContentsText = [];
            if isempty(FileTypeDropDownItems)
                FileTypeDropDownItems{1} = convertStringsToChars(tempFileTypeDropDownItems{1});
            end
        end
    end
    %% No folder selected  / found
    if ~ischar(SelectedFolder)
        FolderContentsText = MatlabTextNoFolder;
        Load_Data_Window_Info.selectedFolder = [];
        if isfield(Load_Data_Window_Info,'NrChannel')
            if ~isempty(Load_Data_Window_Info.NrChannel)
                if ~isempty(Load_Data_Window_Info.Channelorder) && sum(isnan(Load_Data_Window_Info.Channelorder))==0
                    if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                        ProbeInfoText = [MatlabTextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(Load_Data_Window_Info.NrChannel));strcat("Channel Spacing: ",num2str(Load_Data_Window_Info.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(Load_Data_Window_Info.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(Load_Data_Window_Info.OffSetRows));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
                    else
                        ProbeInfoText = [NeoTextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(Load_Data_Window_Info.NrChannel));strcat("Channel Spacing: ",num2str(Load_Data_Window_Info.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(Load_Data_Window_Info.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(Load_Data_Window_Info.OffSetRows));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
                    end
                else
                    if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                        ProbeInfoText = [MatlabTextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(Load_Data_Window_Info.NrChannel));strcat("Channel Spacing: ",num2str(Load_Data_Window_Info.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(Load_Data_Window_Info.NumberChannelRows));"Costum Channel Order: No";strcat("Offset Every Second Row: ",num2str(Load_Data_Window_Info.OffSetRows));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
                    else
                        ProbeInfoText = [NeoTextNoFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(Load_Data_Window_Info.NrChannel));strcat("Channel Spacing: ",num2str(Load_Data_Window_Info.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(Load_Data_Window_Info.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(Load_Data_Window_Info.OffSetRows));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
                    end
                end
            end
        end
        return;
    end
    
    if ~isempty(ExtractWithNeo)
        if isempty(Formatsfound) && strcmp(ExtractWithNeo ,"NeuroMod Matlab") 
            FolderContentsText = strcat("Path ",SelectedFolder," contains no suitable recording formats!");
            Load_Data_Window_Info.selectedFolder = [];
            if isfield(Load_Data_Window_Info,'NrChannel')
                if ~isempty(Load_Data_Window_Info.NrChannel)
                    if ~isempty(Load_Data_Window_Info.Channelorder) && sum(isnan(Load_Data_Window_Info.Channelorder))==0
                        if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                            ProbeInfoText = ["Path to recording folder that is passed to Matlab:";"";SelectedFolder;"";MatlabTextWithFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(Load_Data_Window_Info.NrChannel));strcat("Channel Spacing: ",num2str(Load_Data_Window_Info.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(Load_Data_Window_Info.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(Load_Data_Window_Info.OffSetRows));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
                        else
                            ProbeInfoText = ["Path to recording folder that is passed to NEO:";"";SelectedFolder;"";NeoTextWithFolder;"";"Probe Information:";"";strcat("Nr Channel: ",num2str(Load_Data_Window_Info.NrChannel));strcat("Channel Spacing: ",num2str(Load_Data_Window_Info.ChannelSpacing));strcat("Nr Channel Rows: ",num2str(Load_Data_Window_Info.NumberChannelRows));"Costum Channel Order: Yes";strcat("Offset Every Second Row: ",num2str(Load_Data_Window_Info.OffSetRows));strcat("Nr Active Channel: ",num2str(length(Load_Data_Window_Info.ActiveChannel)))];
                        end
                    else
                        if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                            ProbeInfoText = [MatlabTextWithFolder;"";"Probe Information:";"";"not defined"];
                        else
                            ProbeInfoText = [NeoTextWithFolder;"";"Probe Information:";"";"not defined"];
                        end
                    end
                end
            else
                if strcmp(ExtractWithNeo ,"NeuroMod Matlab")
                    ProbeInfoText = [MatlabTextWithFolder;"";"Probe Info:";"";"not defined"];
                else
                    ProbeInfoText = [NeoTextWithFolder;"";"Probe Info:";"";"not defined"];
                end
            end
            return;
        end
    end
    % Check if mutliple recording folder found
    if isempty(FileTypeDropDownItems) || isempty(RecordingSystemDropDownItems)
        FolderContentsText = "Please select a different folder!";
        ProbeInfoText = "Folder possibly contains no recordings with a supported format. Please select a folder with only a single recording of a single recording system. Make sure to just have the native recording files in that folder, no additional ones!";
        Load_Data_Window_Info.selectedFolder = [];
        return;
    else
        app.FileTypeDropDown.Items = {};
        app.RecordingSystemDropDown.Items = {};
        for ii = 1:length(RecordingSystemDropDownItems)
            app.RecordingSystemDropDown.Items{ii} = RecordingSystemDropDownItems{ii};
        end
        app.FileTypeDropDown.Items{1} = FileTypeDropDownItems{1};
        for jj = 1:length(Formatsfound.Library)
            app.RecordingSystemDropDown_2.Items{jj} = convertStringsToChars(Formatsfound.Library(jj));
        end

        Load_Data_Window_Info.selectedFolder = SelectedFolder;
    end

    %% Show recording files (equivalent to folder contents)
    if isempty(FolderContentsText)
        if ~isempty(stringArray)
            if strcmp(RecordingSystemDropDownItems{1},'Open Ephys') || strcmp(RecordingSystemDropDownItems{1},'NEO New Open Ephys Format') || strcmp(RecordingSystemDropDownItems{1},'NEO Legacy Open Ephys Format') 
                for i = 1:length(stringArray)
                    if strcmp(stringArray(i),"Record Node 101")
                        stringArray(i) = strcat(stringArray(i));
                    elseif strcmp(stringArray(i),"Record Node 105")
                        stringArray(i) = strcat(stringArray(i));
                    elseif strcmp(stringArray(i),"Record Node 113")
                        stringArray(i) = strcat(stringArray(i));
                    end
                end
                stringArray = ["Selected folder contains the following recording files:";RecordingSystemDropDownItems{1};"";stringArray];
                FolderContentsText = stringArray;
            else
                if size(stringArray,2) > 1
                    stringArray = ["Selected folder contains the following recording files:";RecordingSystemDropDownItems{1};"";stringArray'];
                    FolderContentsText = stringArray;
                else
                    stringArray = ["Selected folder contains the following recording files:";RecordingSystemDropDownItems{1};"";stringArray];
                    FolderContentsText = stringArray;
                end
            end         
        end
    end
end
