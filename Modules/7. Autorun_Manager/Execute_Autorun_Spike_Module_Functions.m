function [Data] = Execute_Autorun_Spike_Module_Functions(AutorunConfig,FunctionOrder,Data,nRecordings)

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


%______________________________________________________________________________________________________
%% 5. Spike Module Functions
%______________________________________________________________________________________________________
% 5.1 Internal Spike Detection
%______________________________________________________________________________________________________

if strcmp(FunctionOrder,'Internal_Spike_Detection')
    Execute = 1;
    %% Check if high pass filtered data is available. If not, display error message and return
    if ~isfield(Data,'Preprocessed')
        f = msgbox("Error: No preprocessed Data detected. Spike Detection on Raw Data wont work! High pass filter and open this window again!");
        Execute = 0;
    else
        if ~isfield(Data.Info,'FilterMethod')
            f = msgbox("Error: No high pass filtered Data detected. Spike Detection on Raw Data wont work! High pass filter and open this window again!");
            Execute = 0;
        else
            if ~strcmp(Data.Info.FilterMethod,"High-Pass")
                f = msgbox("Error: No high pass filtered Data detected. Spike Detection on Raw Data wont work! High pass filter and open this window again!");
                Execute = 0;
            end
        end
    end

    if Execute == 1
        [Data,~] = Spike_Module_Spike_Detection(Data,AutorunConfig.InternalSpikeDetection.Detectionmethod,AutorunConfig.InternalSpikeDetection.Type,str2double(AutorunConfig.InternalSpikeDetection.STDThreshold),AutorunConfig.InternalSpikeDetection.Filterspikes,str2double(AutorunConfig.InternalSpikeDetection.FilterSpikeTimeOffset),str2double(AutorunConfig.InternalSpikeDetection.FilterArtefactDepth));
    end
end

%______________________________________________________________________________________________________
% 5.2 Load from Kilosort
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Load_from_Kilosort')

    if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
        SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings},"\Kilosort\");
        SelectedFolder = strcat(SelectedFolder,"kilosort4");
        if ~exist(SelectedFolder,'dir')
            msgbox("Automatic detection of saved kilosort data failed, please select a folder manually");
            AutorunSpikeDetection = "SingleFolder";
            SelectedFolder = [];
        else
            AutorunSpikeDetection = "MultipleRecordings"; 
        end
    else
        AutorunSpikeDetection = "SingleFolder";
        SelectedFolder = [];
    end

    if isfield(Data.Info,'CutStart')
        msgbox("Warning: Start time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end
    
    if isfield(Data.Info,'CutEnd') 
        msgbox("Warning: End time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end
        
    % Function to load all relevant/necessary? npy and .mat files Kilosort outputs,
    if isempty(AutorunConfig.LoadfromKilosort.ScalingFactor)
        if isfield(Data.Info,'KilosortScalingFactor')
            ScalingFactor = Data.Info.KilosortScalingFactor;
        else
            ScalingFactor = [];
        end
    else
        ScalingFactor = [];
    end

    [Data] = Spike_Module_Load_Kilosort_Data(Data,AutorunSpikeDetection,SelectedFolder,ScalingFactor);

end

%______________________________________________________________________________________________________
% 5.3 Save for Kilosort
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Save_for_Kilosort')
    Execute = 1;
    if ~isfield(Data,'Raw')
        msgbox("Error: No Raw Data found. Data to be exported has to not be preprocessed! Returning.");
        Execute = 0;
    end

    if Execute == 1

        if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
            FullPath = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings},"\Kilosort\");
            SelectedFolder = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings});
            AutorunDetection = "MultipleFolder";
            % Define the name of the folder you want to create
            folderName = 'Kilosort';
            
            % Check if the folder already exists
            if ~exist(FullPath,'dir')
                % Create the folder if it does not exist
                mkdir(FullPath);
                %disp(['Folder "', folderName, '" created successfully.']);
            else
                disp(['Folder "', folderName, '" already exists.']);
            end

            SelectedFolder = convertStringsToChars(strcat(SelectedFolder,"\Kilosort"));

        else
            AutorunDetection = "SingleFolder";
            SelectedFolder = [];
        end

        % Function to Save Raw Data as int32 in a .dat file
        [Data] = Spike_Module_Save_for_Kilosort(Data,AutorunDetection,SelectedFolder,AutorunConfig.SaveforKilosort.SaveFormat);
    end
end