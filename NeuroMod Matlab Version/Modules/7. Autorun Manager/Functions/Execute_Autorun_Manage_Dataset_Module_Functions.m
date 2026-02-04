function [Data,AutorunConfig] = Execute_Autorun_Manage_Dataset_Module_Functions(AutorunConfig,FunctionOrder,Data,nRecordings,Channelorder,executableFolder,TimeAndChannelToExtract)

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
% 7. AutorunConfig.selected_folder: char, Path to currently analyzed folder
% 8. TimeAndChannelToExtract: struc with to fields, one holding info about
% channel to extract the other containing info about time to extract

% Outputs:
% 1. Data: main data structure 
% 2. AutorunConfig.selected_folder: char, extracted here

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%______________________________________________________________________________________________________
%% 1. Manage Dataset Module Functions
%______________________________________________________________________________________________________
% 1.1 Extract Data from Raw Recordings
%______________________________________________________________________________________________________
% Make Sure loading and extracting data are not both selected

TempData = [];

Numberexecutions = 0;
for i = 1:length(FunctionOrder)
    if strcmp(FunctionOrder(i),'Extract_Raw_Recording')
        Numberexecutions = Numberexecutions+1;
    end
    if strcmp(FunctionOrder(i),'Load_Data')
        Numberexecutions = Numberexecutions+1;
    end
end

if Numberexecutions == 2
    stringtoshow = ("Error: Extracting from raw recordings and loading data both selected. Only one can be active at a time. Please set one to false.");
    msgbox(stringtoshow);
    return;
elseif Numberexecutions == 0 && ~strcmp(FunctionOrder(i),'Save_Data')
    stringtoshow = ("Error: Neither loading data nor extracting data from recordings was set to true. Exiting.");
    msgbox(stringtoshow);
    return;
end

if strcmp(FunctionOrder,'Extract_Raw_Recording')

    [Data,SelectedFolder] = Execute_Autorun_Set_Up_Folder(AutorunConfig,Data,nRecordings);
    
    if contains(AutorunConfig.ExtractRawRecording.RecordingsSystem,'NEO')
        if contains(SelectedFolder,'Neo SaveFile')
            warning("Current folder name contains 'Neo SaveFile' and is identified as a automatically created NEO save folder. Skipping. If this should be a proper recording folder with the native recording files, consider renaming the folder.")
            SelectedFolder = [];
            Data = [];
        end
    end

    if ~isempty(SelectedFolder)
        
        PlaceholderTextare.Value = 1;
        SelectedFolder = convertStringsToChars(SelectedFolder);
        
        % Extract Data
        if strcmp(AutorunConfig.ExtractRawRecording.LibraryToUse,"NeuroMod Matlab")
            [TempData,HeaderInfo,SampleRate,RecordingType,Time] = Manage_Dataset_Module_Extract_Raw_Recording_Main(AutorunConfig.ExtractRawRecording.RecordingsSystem,AutorunConfig.ExtractRawRecording.FileType,SelectedFolder,PlaceholderTextare,executableFolder,AutorunConfig.AdditionalAmpFactor,AutorunConfig.ProbeInfo.ActiveChannel,AutorunConfig.ProbeInfo.Channelorder,TimeAndChannelToExtract);
        elseif strcmp(AutorunConfig.ExtractRawRecording.LibraryToUse,"NeuralEnsemble NEO Python Library")
            % first chekc if its a neuropixels 1.0 recording. If
            % yes, ask if user wants LFP or AP signal

            [IsNP1,DataPartToextract] = Manage_Dataset_Check_NEO_NP1_Recording(Data,SelectedFolder);
            
            % Open extra window, get more settings, start NEO python
            [Success] = Manage_Dataset_Module_Start_Neo(SelectedFolder,executableFolder,AutorunConfig.ExtractRawRecording.NEOJustLoadRecording,AutorunConfig.ExtractRawRecording.NEOLeaveConsolOpen,AutorunConfig.ExtractRawRecording.NEOFormat,AutorunConfig.ExtractRawRecording.FormatToSaveAndReadIntoMatlab,IsNP1,DataPartToextract,TimeAndChannelToExtract.TimeToExtract,TimeAndChannelToExtract.ChannelToExtract);
            if Success == 0
                return;
            end

            % Load saved results from NEO
            [TempData,SampleRate,HeaderInfo,RecordingType,Time,~] = Manage_Dataset_Load_NEO_RawData_Save_Files(SelectedFolder,AutorunConfig.ExtractRawRecording.NEOFormat,AutorunConfig.ExtractRawRecording.FormatToSaveAndReadIntoMatlab,TimeAndChannelToExtract);
        
        elseif strcmp(AutorunConfig.ExtractRawRecording.LibraryToUse,"SpikeInterface Python Library") % If SpikeInterface data extraction
                    
            % Open extra window, get more settings, start SpikeInterface python
            [Success] = Manage_Dataset_Module_Start_SpikeInterface(SelectedFolder,executableFolder,AutorunConfig.ExtractRawRecording.SpikeInterfaceJustLoadRecording,AutorunConfig.ExtractRawRecording.SpikeInterfaceLeaveConsolOpen,AutorunConfig.ExtractRawRecording.SpiekInterfaceFormat,AutorunConfig.ExtractRawRecording.SpikeInterfaceFormatToSaveAndReadIntoMatlab,AutorunConfig.ExtractRawRecording.SaveProbe,AutorunConfig.ExtractRawRecording.SaveProbe_Format,AutorunConfig.ExtractRawRecording.TimeToExtract,AutorunConfig.ExtractRawRecording.ChannelToExtract);
            if Success == 0
                return;
            end
            
            % Load saved results from NEO

            [TempData,SampleRate,HeaderInfo,RecordingType,Time,~] = Manage_Dataset_Load_SpikeInterface_RawData_Save_Files(SelectedFolder,TimeAndChannelToExtract);
            
        end

        %% Apply/save Header Infos

        % Use some header infos and the data structure to define all necessary variables for this toolbox
        % Variable definitions necessary:
        % Data = Data.Raw and or Data.Preprocessed, depending on what is available;
        % Data.Time = Time;
        % Data.Info = HeaderInfo;
        % Data.Info.num_data_points = size(Data.Raw,2);
        % Data.Info.NrChannel = size(Data.Raw,1);
        % Data.Info.Data_Path = SelectedFolder;
        % Data.Info.NativeSamplingRate = SampleRate;
        % Data.Info.RecordingType = RecordingType;
        
        %% Define All Variables

        Data = Execute_Autorun_Initialize_Data(AutorunConfig,TempData,Time,HeaderInfo,SampleRate,RecordingType,SelectedFolder);

        if isempty(Data)
            stringtoshow = "Error. No data could be extracted";
            msgbox(stringtoshow);
            return;
        end
        
        if strcmp(AutorunConfig.ExtractRawRecording.LibraryToUse,"SpikeInterface Python Library")
            % [NewChannelOrder] = Organize_Convert_ActiveChannel_to_DataChannel(app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.Mainapp.Data.Info.ProbeInfo.MEAChannelOrder,'MainPlot');
            % [app.Mainapp.Data] = Manage_Dataset_Module_Apply_ChannelOrder(app.Mainapp.Data,NewChannelOrder);
        else
            [Data] = Manage_Dataset_Module_Apply_ChannelOrder(Data,Channelorder);
        end

        %% FLip Data
        if Data.Info.ProbeInfo.FlipLoadedData == 1
            [Data.Raw] = Manage_Dataset_Module_Apply_DataFlip(Data.Raw);
        end

        AutorunConfig.PlotAppearance = [];
        AutorunConfig.PlotAppearance = Utility_Save_Load_Delete_Plot_Appearance(AutorunConfig.PlotAppearance,executableFolder,"Load");
        
        % Initite structure to save analysis results   
        AutorunConfig.CurrentPlotData = [];

        if isempty(AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.depth_bin_size)
            AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.depth_bin_size = Data.Info.ChannelSpacing;
        end
    else
        % If the user hasnt selected a folder yet, display that and
        % return
        disp("Error. No folder selected");
        return;
    end
end

%______________________________________________________________________________________________________
% 1.2 Loading Data saved from GUI
%______________________________________________________________________________________________________
%% Loading Data

if strcmp(FunctionOrder,'Load_Data')

    if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Neuralynx") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Spike2") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"NEO") 
        if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
            path = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings},"\","Matlab\");
            file = strcat(AutorunConfig.FolderContents{nRecordings},'.dat');
        else
            dashindex = find(AutorunConfig.selected_folder=='\');
            path = strcat(AutorunConfig.selected_folder,"\","Matlab\");
            file = strcat(AutorunConfig.selected_folder(dashindex(end)+1:end),'.dat');
        end
    elseif strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
        if ~isempty(AutorunConfig.FolderContents) % multiple recordings
            path = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings},"\","Matlab\",AutorunConfig.ExtractRawRecording.FileType);
        else % single recording
            path = strcat(AutorunConfig.selected_folder,"\","Matlab\",AutorunConfig.ExtractRawRecording.FileType);
        end
        if isstring(path)
            path = convertStringsToChars(path);
        end
        dashindex = find(path=='\');
        file = convertStringsToChars(strcat(path(dashindex(end-2)+1:dashindex(end-1)-1),".dat"));
    end
    
    if isfolder(path)
        % File Location for Data saved for NeuroMod
        if strcmp(AutorunConfig.LoadData.Format,"Saved NeuroMod format")
            [stringArray] = Utility_Extract_Contents_of_Folder(path);
            % Use endsWith to create a logical array indicating which elements end with '.dat'
            isDatFile = endsWith(stringArray, '.dat');
            
            % Find the indices of .dat files
            datFileIndices = find(isDatFile);
        
            if isempty(datFileIndices) || length(datFileIndices) > 1
                error("Error: No .dat file or more than one .dat files found.");
            end
        
            InfoleFile = strcat(file(1:end-4),'_Info.mat');

            FullPathInfo = convertStringsToChars(fullfile(path,InfoleFile));
            FullPathData = convertStringsToChars(fullfile(path,file));

        elseif strcmp(AutorunConfig.LoadData.Format,"Saved Neo readable .mat file")
            [stringArray] = Utility_Extract_Contents_of_Folder(path);
            % Use endsWith to create a logical array indicating which elements end with '.dat'
            isMatFile = endsWith(stringArray, '.mat');
            
            NEOMatfileindex = [];
            if sum(isMatFile)>0
                AllMatFiles = stringArray(isMatFile);
            else
                disp("No readable .mat file found!")
                return
            end
            
            for i = 1:length(AllMatFiles)
                currentstring = AllMatFiles(i);
                %% Check if selected mat file contains correct variable
                variableName = 'Raw';  % Variable you want to load
                
                % Get the list of variables in the file
                variablesInFile = who('-file', fullfile(path,currentstring));
                
                % Check if the desired variable exists
                if ~ismember(variableName, variablesInFile)
                    %% Check if selected mat file contains correct variable
                    variableName = 'block';  % Variable you want to load
                    
                    % Get the list of variables in the file
                    variablesInFile = who('-file', fullfile(path,currentstring));
                    
                    if ismember(variableName, variablesInFile)
                        NEOMatfileindex = [NEOMatfileindex,i];
                    else % neo file
                        % No neo file
                        continue;  % Exit if the variable does not exist
                    end
                end
            end
            
            if isempty(NEOMatfileindex)
                disp("No readable NEO .mat file found!")
                return
            end

            File = convertStringsToChars(AllMatFiles(NEOMatfileindex));
            dotindex = find(File=='.');
            InfoFile = strcat(File(1:dotindex(end)-1),'_Info.mat');
            
            FullPathData = convertStringsToChars(fullfile(path,File));
            FullInfoPath = convertStringsToChars(fullfile(path,InfoFile));

            if ~isfile(FullInfoPath)
                disp("No Info .mat file found for readable NEO .mat file!")
                return
            end

        elseif strcmp(AutorunConfig.LoadData.Format,"Saved SpikeInterface format")
            [stringArray] = Utility_Extract_Contents_of_Folder(path);
            % Use endsWith to create a logical array indicating which elements end with '.dat'
            isBinFile = endsWith(stringArray, '.bin');
            
            if sum(isBinFile) == 0 
                error("No spikeinterface .bin file found!")
            end
            if sum(isBinFile)>1
                error("Two or more spikeinterface .bin file found!")
            end
            % Find the indices of .dat files
            datFileIndices = find(isBinFile);
        
            if isempty(datFileIndices) || length(datFileIndices) > 1
                error("Error: No .bin file or more than one .dat files found.");
            end
      
            FullPathData = convertStringsToChars(fullfile(path,stringArray(datFileIndices)));
        
        elseif strcmp(AutorunConfig.LoadData.Format,"Saved NWB format")
            [stringArray] = Utility_Extract_Contents_of_Folder(path);
            % Use endsWith to create a logical array indicating which elements end with '.dat'
            isnwbFile = endsWith(stringArray, '.nwb');
            
            if sum(isnwbFile) == 0 
                error("No spikeinterface .nwb file found!")
            end
            if sum(isnwbFile)>1
                error("Two or more spikeinterface .nwb file found!")
            end
            % Find the indices of .dat files
            datFileIndices = find(isnwbFile);
        
            if isempty(datFileIndices) || length(datFileIndices) > 1
                error("Error: No .bin file or more than one .dat files found.");
            end
      
            FullPathData = convertStringsToChars(fullfile(path,stringArray(datFileIndices)));
        end

        PlaceholderTextbox.Value = [];
        
        if exist(path,'dir') == 7
            if exist(FullPathData,'file') == 2

                if strcmp(AutorunConfig.LoadData.Format,"Saved NeuroMod format")
                    [Data] = Manage_Dataset_Module_Load_NeuroModData(AutorunConfig.LoadData.Format,FullPathData,FullPathInfo,PlaceholderTextbox);
                elseif strcmp(AutorunConfig.LoadData.Format,"Saved Neo readable .mat file")
                    
                    [Data,~] = Manage_Dataset_Module_Load_NeoMatData(FullPathData,FullInfoPath);
    
                elseif strcmp(AutorunConfig.LoadData.Format,"Saved NWB format")
                    
                    [Data] = Manage_Dataset_Module_Load_NWBFile(FullPathData);
    
                elseif strcmp(AutorunConfig.LoadData.Format,"Saved SpikeInterface format")
    
                    [Data] = Manage_Dataset_Module_Load_SpikeInterface(FullPathData);

                end

                Data.CurrentPreproNr = 0;
            else
                disp("Error: Directory to load from not found or data to load not existent. Skipping folder.")
                Data = [];
                return;
            end
        else
            disp("Error: Directory to load from not found or data to load not existent. Skipping folder.")
            Data = [];
            return;
        end
    else
        disp("Error: Directory to load from not found or data to load not existent. Skipping folder.")
        Data = [];
        return;
    end
    
    % Initite Plotappearacnes
    AutorunConfig.PlotAppearance = [];
    AutorunConfig.PlotAppearance = Utility_Save_Load_Delete_Plot_Appearance(AutorunConfig.PlotAppearance,executableFolder,"Load");
    % Initite structure to save analysis results   
    AutorunConfig.CurrentPlotData = [];

    if isempty(AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.depth_bin_size)
        AutorunConfig.AnalyseEventSpikesModule.SpikeBinSettings.depth_bin_size = Data.Info.ChannelSpacing;
    end
end

%______________________________________________________________________________________________________
% 1.2 Saving Data from GUI
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Save_Data')

    % first check whether selected components are actually present
    % Preprocessed
    if AutorunConfig.SaveData.Whattosave(2)==1
        if ~isfield(Data,'Preprocessed')
            AutorunConfig.SaveData.Whattosave(2) = 0;
        end
    end
    % Events
    if AutorunConfig.SaveData.Whattosave(3)==1
        if ~isfield(Data,'Events')
            AutorunConfig.SaveData.Whattosave(3) = 0;
        end
    end
    % Spikes
    if AutorunConfig.SaveData.Whattosave(4)==1
        if ~isfield(Data,'Spikes')
            AutorunConfig.SaveData.Whattosave(4) = 0;
        end
    end
    % EventRelatedData
    if AutorunConfig.SaveData.Whattosave(5)==1
        if ~isfield(Data,'EventRelatedData')
            AutorunConfig.SaveData.Whattosave(5) = 0;
        end
    end
    % Preprocessed EventRelatedData
    if AutorunConfig.SaveData.Whattosave(6)==1
        if ~isfield(Data,'PreprocesedEventRelatedData')
            AutorunConfig.SaveData.Whattosave(6) = 0;
        end
    end

    Execute = 1;
    if ~isfield(Data,'Raw') && ~isfield(Data,'Preprocessed')
        msgbox("Warning! No Data was extracted.");
        Execute = 0;
    end

    if Execute == 1
        
        if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Neuralynx") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Spike2") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"NEO")
            FullPath = strcat(Data.Info.Data_Path,"\Matlab\");
        elseif strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
            if ~isempty(AutorunConfig.FolderContents) % multiple recordings
                FullPath = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings},"\","Matlab\",AutorunConfig.ExtractRawRecording.FileType);
            else % single recording
                FullPath = strcat(AutorunConfig.selected_folder,"\Matlab\",AutorunConfig.ExtractRawRecording.FileType);
            end
        end

        AutorunDetection = "MultipleFolder";
        % Define the name of the folder you want to create
        
        % Check if the folder already exists
        if ~exist(FullPath,'dir')
            mkdir(FullPath);
        end
        
        if strcmp(AutorunConfig.SaveData.SaveFor,"NeuroMod")
            [filepath,Error] = Manage_Dataset_Module_SaveData(Data,AutorunConfig.SaveData.SaveAs,AutorunConfig.SaveData.Whattosave,executableFolder,AutorunDetection,FullPath);
        elseif strcmp(AutorunConfig.SaveData.SaveFor,"Other")
            if strcmp(AutorunConfig.SaveData.SaveAs,"NWB File (Neuroscience Without Borders)")
                
                dashindex = find(Data.Info.Data_Path=='/');
                if isempty(dashindex)
                    dashindex = find(Data.Info.Data_Path=='\');
                end
                OriginalfolderName = Data.Info.Data_Path(dashindex(end)+1:end); 

                if AutorunConfig.SaveData.Whattosave(1)==1 
                    [filepath,Error] = Manage_Dataset_SaveData_NWB(Data,AutorunConfig.SaveData.Whattosave(3),"Raw Data",Data.Info.NativeSamplingRate,OriginalfolderName,AutorunDetection,FullPath);
                else
                    if isfield(Data.Info,'DownsampledSampleRate')
                        [filepath,Error] = Manage_Dataset_SaveData_NWB(Data,AutorunConfig.SaveData.Whattosave(3),"Preprocessed Data",Data.Info.DownsampledSampleRate,OriginalfolderName,AutorunDetection,FullPath);
                    else
                        [filepath,Error] = Manage_Dataset_SaveData_NWB(Data,AutorunConfig.SaveData.Whattosave(3),"Preprocessed Data",Data.Info.NativeSamplingRate,OriginalfolderName,AutorunDetection,FullPath);
                    end
                end
            elseif strcmp(AutorunConfig.SaveData.SaveAs,"SpikeInterface Compatible Binary File")
                % managing potential downsampling in function!
                Error = 0;
                if AutorunConfig.SaveData.Whattosave(1)==1 
                    [filepath] = Manage_Dataset_SaveData_SpikeInterfaceNumpy(Data,"Raw Data",AutorunConfig.SaveData.Whattosave(3),AutorunDetection,FullPath);
                else
                    [filepath] = Manage_Dataset_SaveData_SpikeInterfaceNumpy(Data,"Preprocessed Data",AutorunConfig.SaveData.Whattosave(3),AutorunDetection,FullPath);
                end
            end
        elseif strcmp(AutorunConfig.SaveData.SaveFor,"NEO")
            if strcmp(AutorunConfig.SaveData.SaveAs,"Neo Compatible .mat File")
                if AutorunConfig.SaveData.Whattosave(1) == 1
                    [filepath,Error] = Manage_Dataset_SaveData_NeoMAT(Data,Data.Info.NativeSamplingRate,"Raw Data",AutorunConfig.SaveData.Whattosave(3),AutorunConfig.SaveData.Whattosave(4),Data.Time,AutorunDetection,FullPath);
                else
                    if isfield(Data.Info,'DownsampledSampleRate')
                        [filepath,Error] = Manage_Dataset_SaveData_NeoMAT(Data,Data.Info.DownsampledSampleRate,"Preprocessed Data",AutorunConfig.SaveData.Whattosave(3),AutorunConfig.SaveData.Whattosave(4),Data.TimeDownsampled,AutorunDetection,FullPath);
                    else
                        [filepath,Error] = Manage_Dataset_SaveData_NeoMAT(Data,Data.Info.NativeSamplingRate,"Preprocessed Data",AutorunConfig.SaveData.Whattosave(3),AutorunConfig.SaveData.Whattosave(4),Data.Time,AutorunDetection,FullPath);
                    end
                end
            end
        end

        %% Check if Saving was succesfull.
        if ~isempty(filepath) && Error == 0
            if strcmp(AutorunConfig.SaveData.SaveFor,"NEO")
                disp("Attempting to save Probe Information.");
                try
                    dashindex = find(filepath=='\');
                    filepathProbe = filepath(1:dashindex(end)-1);
                    filename = filepath(dashindex(end)+1:end);
                    
                    dotindice = find(filename=='.');
                    
                    if ~isempty(dotindice)
                        filename(dotindice:end) = [];
                    end
                    
                    Info = Data.Info;

                    filepathProbe = strcat(filepathProbe,"\",filename,"_Info.mat");
                    save(filepathProbe,'Info')
                catch
                    msgbox("Probe information could not be saved! When loading this dataset, you are being asked to specify the probe layout again!")
                    warning("Probe information could not be saved! When loading this dataset, you are being asked to specify the probe layout again!")
                end

                disp(convertStringsToChars(strcat("Data was succesfully saved to: ",filepath)));

            elseif strcmp(AutorunConfig.SaveData.SaveFor,"Other")
                disp(convertStringsToChars(strcat("Data was succesfully saved to: ",filepath)));
            else
                disp(convertStringsToChars(strcat("Data was succesfully saved to: ",filepath)));
            end
        else
            disp(convertStringsToChars("Saving Data failed. Check that you selected a proper save location and have permissions to create and write in files in that location!"));
        end

    end
end