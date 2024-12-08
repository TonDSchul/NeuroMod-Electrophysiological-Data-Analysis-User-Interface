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
        [Data,~] = Spike_Module_Spike_Detection(Data,AutorunConfig.InternalSpikeDetection.Detectionmethod,AutorunConfig.InternalSpikeDetection.Type,str2double(AutorunConfig.InternalSpikeDetection.STDThreshold),AutorunConfig.InternalSpikeDetection.Filterspikes,str2double(AutorunConfig.InternalSpikeDetection.FilterSpikeTimeOffset),str2double(AutorunConfig.InternalSpikeDetection.FilterArtefactDepth),AutorunConfig.InternalSpikeDetection.FilterSpikeinSameWaveform,str2double(AutorunConfig.InternalSpikeDetection.TimeSpantoCombineIndices));
    end
end

% 5.2 Internal Spike Clustering
%______________________________________________________________________________________________________

if strcmp(FunctionOrder,'Create_Internal_Spike_Sorting')   
    SpikeSortingPath = strcat(Data.Info.Data_Path,'\Wave_Clus');

    if strcmp(AutorunConfig.InternalSpikeDetection.SpikeSortingType,'AllChannelTogether')
        SortingType = "AllChannelTogether";
    elseif strcmp(AutorunConfig.InternalSpikeDetection.SpikeSortingType,'IndividualChannel')
        SortingType = "IndividualChannel";
    end

    [Data] = Spike_Module_Internal_Spike_Sorting(Data,SpikeSortingPath,"Clustering",SortingType);
elseif strcmp(FunctionOrder,'Load_Internal_Spike_Sorting')
    SpikeSortingPath = strcat(Data.Info.Data_Path,'\Wave_Clus');
    [Data] = Spike_Module_Internal_Spike_Sorting(Data,SpikeSortingPath,"Loading");
end

%______________________________________________________________________________________________________
% 5.3 Load from Kilosort
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Load_from_Kilosort')
    
    if strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Kilosort4")
        SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
        SelectedFolder = strcat(SelectedFolder,"kilosort4");
    elseif strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Kilosort3")
        SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
        SelectedFolder = strcat(SelectedFolder,"kilosort3");
    elseif strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Mountainsort5")
        SelectedFolder = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\");
        SelectedFolder = strcat(SelectedFolder,"mountainsort5");
    elseif strcmp(AutorunConfig.LoadfromKilosort.Sorter,"SpykingCircus2")
        SelectedFolder = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\");
        SelectedFolder = strcat(SelectedFolder,"spikingcircus2");
    end

    if ~exist(SelectedFolder,'dir')
        msgbox("Automatic detection of saved kilosort data failed, please select a folder manually");
        AutorunSpikeDetection = "SingleFolder";
        SelectedFolder = [];
    else
        AutorunSpikeDetection = "MultipleRecordings"; 
    end

    if isfield(Data.Info,'CutStart')
        msgbox("Warning: Start time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end
    
    if isfield(Data.Info,'CutEnd') 
        msgbox("Warning: End time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end

    if strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Kilosort4") || strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Kilosort3")
        %% Autoseach scalingfactor
        if ~isempty(AutorunConfig.LoadfromKilosort.ScalingFactor)
            ScalingFactor = str2double(AutorunConfig.LoadfromKilosort.ScalingFactor);
        else
            ScalingFactorPath32 = strcat(Data.Info.Data_Path,'\Kilosort\Scaling Factor int32.mat');
            ScalingFactorPath16 = strcat(Data.Info.Data_Path,'\Kilosort\Scaling Factor int16.mat');
        
            if isfile(ScalingFactorPath32) 
                %% Check if selected mat file contains correct variable
                variableName = 'scalingFactor';  % Variable you want to load
                
                % Get the list of variables in the file
                variablesInFile = who('-file', ScalingFactorPath32);
                
                % Check if the desired variable exists
                if ismember(variableName, variablesInFile)
                    load(ScalingFactorPath32, variableName);  % Load only the specific variable
                else
                    msgbox(strcat("Variable ", variableName," does not exist in the manually selected file ",ScalingFactorPath32));
                    return;  % Exit if the variable does not exist
                end
                disp("Found Scalingfactor saved as .mat file.")
                load(ScalingFactorPath32,'scalingFactor');
                ScalingFactor = scalingFactor;
                Data.Info.KilosortScalingFactor = scalingFactor;
    
            elseif isfile(ScalingFactorPath16) 
                %% Check if selected mat file contains correct variable
                variableName = 'scalingFactor';  % Variable you want to load
                
                % Get the list of variables in the file
                variablesInFile = who('-file', ScalingFactorPath16);
                
                % Check if the desired variable exists
                if ismember(variableName, variablesInFile)
                    load(ScalingFactorPath16, variableName);  % Load only the specific variable
                else
                    msgbox(strcat("Variable ", variableName," does not exist in the manually selected file ",ScalingFactorPath16));
                    return;  % Exit if the variable does not exist
                end
                
                disp("Found Scalingfactor saved as .mat file.")
                load(ScalingFactorPath16,'scalingFactor');
                ScalingFactor = scalingFactor;
                Data.Info.KilosortScalingFactor = scalingFactor;
            else
                disp("Scaling factor to convert int format of the kilosort output to mV was not found as part of the dataset or as a .mat file in 'Original_Recording_Path/Kilosort'. Select a .mat file with a variable called scalingfactor, enter the scalingfactor manually or leave it empty (for no scaling)");      
                ScalingFactor = [];
            end
        end
    else
        ScalingFactor = [];
    end

    if strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Mountainsort5") || strcmp(AutorunConfig.LoadfromKilosort.Sorter,"SpykingCircus2")
        [Data,~] = Spike_Module_Load_SpikeInterface_Sorter(Data,SelectedFolder);
    end

    if strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Kilosort4") || strcmp(AutorunConfig.LoadfromKilosort.Sorter,"Kilosort3")
        % Function to load all relevant npy and .mat files Kilosort outputs
        [Data,~] = Spike_Module_Load_Kilosort_Data(Data,"No",SelectedFolder,ScalingFactor);
    end

end

%______________________________________________________________________________________________________
% 5.4 Save for Kilosort
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Save_for_Kilosort')
    Execute = 1;
    if ~isfield(Data,'Raw')
        msgbox("Error: No Raw Data found. Data to be exported has to not be preprocessed! Returning.");
        Execute = 0;
    end

    if Execute == 1

        if strcmp(AutorunConfig.SaveforKilosort.FileFormat,'.dat')
            if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
                SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
                Filename = strcat(AutorunConfig.FolderContents{nRecordings},".dat");
            else
                dashindex = find(Data.Info.Data_Path=='\');
                Filename = strcat(Data.Info.Data_Path(dashindex(end)+1:end),".dat");
                SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
            end
        elseif strcmp(AutorunConfig.SaveforKilosort.FileFormat,'.bin')
            if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
                SelectedFolder = strcat(Data.Info.Data_Path,"\SpikeInterface\");
                Filename = strcat(AutorunConfig.FolderContents{nRecordings},".bin");
            else
                dashindex = find(Data.Info.Data_Path=='\');
                Filename = strcat(Data.Info.Data_Path(dashindex(end)+1:end),".bin");
                SelectedFolder = strcat(Data.Info.Data_Path,"\SpikeInterface\");
            end          
        end

        if ~exist(SelectedFolder,'dir')
            % Create a folder
            % Create the folder
            [status, msg, msgID] = mkdir(SelectedFolder);
        
            % Check the status and print an appropriate message
            if status == 1
                fprintf('The folder "%s" has been successfully created.\n', SelectedFolder);
                AutorunDetection = "MultipleRecordings"; 
            else
                fprintf('Failed to create the folder "%s".\nError: %s\n', SelectedFolder, msg);
                AutorunDetection = "SingleFolder"; 
            end
            
        else
            AutorunDetection = "MultipleRecordings"; 
        end

        FullPath = strcat(SelectedFolder,Filename);

        % Function to Save Raw Data as int32 in a .dat file
        [Data] = Spike_Module_Save_for_Kilosort(Data,AutorunDetection,FullPath,AutorunConfig.SaveforKilosort.SaveFormat,AutorunConfig.LoadfromKilosort.Sorter,AutorunConfig.LoadfromKilosort.Dataset);
    end
end