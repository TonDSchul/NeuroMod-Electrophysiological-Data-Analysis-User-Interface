function [Data,AutorunConfig] = Execute_Autorun_Manage_Dataset_Module_Functions(AutorunConfig,FunctionOrder,Data,nRecordings,Channelorder,executableFolder)

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

    if ~isempty(SelectedFolder)
        PlaceholderTextare.Value = 1;
        %% Extract Data
        SelectedFolder = convertStringsToChars(SelectedFolder);
        [TempData,HeaderInfo,SampleRate,RecordingType,Time] = Manage_Dataset_Module_Extract_Raw_Recording_Main(AutorunConfig.ExtractRawRecording.RecordingsSystem,AutorunConfig.ExtractRawRecording.FileType,SelectedFolder,PlaceholderTextare,executableFolder,AutorunConfig.AdditionalAmpFactor,AutorunConfig.ProbeInfo.NrChannel,AutorunConfig.ProbeInfo.NrRows);
        
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

        %% Define all important Variables based on extracted dat files
        Data.Raw = single(TempData);
        Data.Time = Time;
        clear TempData;
    
        if strcmp(RecordingType,"IntanDat") || strcmp(RecordingType,"IntanRHD") || strcmp(RecordingType,"Spike2") || strcmp(RecordingType,"Open Ephys")
            Data.Info = HeaderInfo;
        else % Neuralynx
            fieldsToDelete = {'Header'};
            % Delete fields
            Data.Info = rmfield(HeaderInfo.orig(1).hdr, fieldsToDelete);
        end
    
        Data.Info.num_data_points = size(Data.Raw,2);
        Data.Info.NrChannel = size(Data.Raw,1);
        Data.Info.Data_Path = SelectedFolder;
        Data.Info.NativeSamplingRate = SampleRate;
        Data.Info.RecordingType = RecordingType;
        Data.Info.ChannelSpacing = AutorunConfig.ExtractRawRecording.ChannelSpacing;
        Data.Info.SpikeType = "Non";

        Data.Info.ProbeInfo.NrChannel = num2str(AutorunConfig.ProbeInfo.NrChannel);
        Data.Info.ProbeInfo.NrRows = num2str(AutorunConfig.ProbeInfo.NumberChannelRows);
        Data.Info.ProbeInfo.VertOffset = num2str(AutorunConfig.ProbeInfo.VerticalOffsetum);
        Data.Info.ProbeInfo.HorOffset = num2str(AutorunConfig.ProbeInfo.HorizontalOffsetum);
        Data.Info.ProbeInfo.ActiveChannel = sort(AutorunConfig.ProbeInfo.ActiveChannel);
    
        Data.Info.ProbeInfo.SwitchTopBottomChannel = AutorunConfig.ProbeInfo.SwitchTopBottomChannel;
        Data.Info.ProbeInfo.SwitchLeftRightChannel = AutorunConfig.ProbeInfo.SwitchLeftRightChannel;
        Data.Info.ProbeInfo.FlipLoadedData = AutorunConfig.ProbeInfo.FlipLoadedData;

        Data.Info.ProbeInfo.OffSetRows = sort(AutorunConfig.ProbeInfo.OffSetRows);
        Data.Info.ProbeInfo.OffSetRowsDistance = sort(AutorunConfig.ProbeInfo.OffSetRowsDistance);
    
        if isfield(AutorunConfig.ProbeInfo,'ProbeTrajectoryInfo')
            Data.Info.ProbeInfo.CompleteAreaNames = AutorunConfig.ProbeInfo.ProbeTrajectoryInfo.AreaNamesLong;
            Data.Info.ProbeInfo.ShortAreaNames = AutorunConfig.ProbeInfo.ProbeTrajectoryInfo.AreaNamesShort;
            Data.Info.ProbeInfo.AreaDistanceFromTip = AutorunConfig.ProbeInfo.ProbeTrajectoryInfo.AreaTipDistance;
        end

        % If extraction was succesfull and dat variable is
        % filled, indicate that it was succesful. This is
        % implemented bc. right after this module finished the extraction, the
        % window is closed and data is plotted. But it should
        % only be plotted when the user succesfully extracted data

        if isempty(Data)
            stringtoshow = "Error. No data could be extracted";
            msgbox(stringtoshow);
            return;
        end

        if AutorunConfig.ExtractRawRecording.CostumChannelOrder == true
            %% Apply ChannelOrder
            [Data] = Manage_Dataset_Module_Apply_ChannelOrder (Data,Channelorder);
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
        stringtoshow = "Error. No folder selected";
        msgbox(stringtoshow);
        return;
    end
end

%______________________________________________________________________________________________________
% 1.2 Loading Data saved from GUI
%______________________________________________________________________________________________________
%% Loading Data

if strcmp(FunctionOrder,'Load_Data')

    if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Neuralynx") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Spike2")
        if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
            path = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings},"\","Matlab\");
            file = strcat(AutorunConfig.FolderContents{nRecordings},AutorunConfig.LoadData.Format);
        else
            dashindex = find(AutorunConfig.selected_folder=='\');
            path = strcat(AutorunConfig.selected_folder,"\","Matlab\");
            file = strcat(AutorunConfig.selected_folder(dashindex(end)+1:end),AutorunConfig.LoadData.Format);
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
        [stringArray] = Utility_Extract_Contents_of_Folder(path);
        % Use endsWith to create a logical array indicating which elements end with '.dat'
        isDatFile = endsWith(stringArray, '.dat');
        
        % Find the indices of .dat files
        datFileIndices = find(isDatFile);
    
        if isempty(datFileIndices) || length(datFileIndices) > 1
            error("Error: No .dat file or more than one .dat files found.");
        end
    
        InfoleFile = strcat(file(1:end-4),'_Info.mat');
       
    
        FullPathInfo = fullfile(path,InfoleFile);
    
        PlaceholderTextbox.Value = [];
        
        if exist(path,'dir') == 7
            if exist(fullfile(path,file),'file') == 2
                [Data] = Manage_Dataset_Module_LoadData(AutorunConfig.LoadData.Format,fullfile(path,file),FullPathInfo,PlaceholderTextbox);
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
    Execute = 1;
    if ~isfield(Data,'Raw') && ~isfield(Data,'Preprocessed')
        msgbox("Warning! No Data was extracted.");
        Execute = 0;
    end

    if Execute == 1
        
        if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Neuralynx") || strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Spike2")
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

        [~] = Manage_Dataset_Module_SaveData(Data,AutorunConfig.SaveData.FileType,AutorunConfig.SaveData.Whattosave,executableFolder,AutorunDetection,FullPath);
    end
end