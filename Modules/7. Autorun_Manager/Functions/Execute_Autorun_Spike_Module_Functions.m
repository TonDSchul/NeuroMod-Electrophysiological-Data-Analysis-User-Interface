function [Data] = Execute_Autorun_Spike_Module_Functions(AutorunConfig,FunctionOrder,Data,nRecordings,executableFolder)

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

if strcmp(FunctionOrder,'Create_Spike_Sorting') 
    
    if ~strcmp(AutorunConfig.CreateSpikeSorting.Sorter,"WaveClus 3")

        [pythonPath] = Spike_Module_Check_Load_Conda_Python_exe(executableFolder);
        SpikeInterfaceScriptPath = strcat(executableFolder,'\Modules\SpikeInterface\SpikeInterface_Sorting.py');
    
        AutorunConfig.CreateSpikeSorting.JustOpenSpikeInterfaceGUI = '0';
        AutorunConfig.CreateSpikeSorting.MultipleRecordings = '0';

        % path
        file_path = strcat(Data.Info.Data_Path,'\SpikeInterface');

        if ~isfolder(file_path)
            disp(strcat("Folder ",file_path," does not exist. Skipping Spike Sorting."))
            return;
        end

        [stringArray] = Utility_Extract_Contents_of_Folder(file_path);
        BinIndex = [];
        for i = 1:length(stringArray)
            if contains(stringArray(i),'.bin')
                BinIndex = i;
                break;
            end
        end

        if isempty(BinIndex)
            disp(strcat("No .bin file found in folder ",file_path,". Skipping Spike Sorting."))
            return;
        else
            file_path = strcat(file_path,'\',stringArray(BinIndex));
        end
        
        SampleRate = Data.Info.NativeSamplingRate;
        NumChannel = size(Data.Raw,1);
        ypitch = Data.Info.ChannelSpacing;

        % Build the command string
        VerChannelOffset = str2double(Data.Info.ProbeInfo.VertOffset);
        HorChannelOffset = str2double(Data.Info.ProbeInfo.HorOffset);
        NumberRows = str2double(Data.Info.ProbeInfo.NrRows);
        RowOffset = double(Data.Info.ProbeInfo.OffSetRows);
        RowOffsetDistance = str2double(Data.Info.ProbeInfo.OffSetRowsDistance);

        if strcmp(AutorunConfig.CreateSpikeSorting.Sorter,"Mountainsort 5")
            % Loop over all fields
            fields = fieldnames(AutorunConfig.CreateSpikeSorting.ParameterStructure.MS5);
            for i = 1:numel(fields)
                field = fields{i}; % Get the field name
                value = AutorunConfig.CreateSpikeSorting.ParameterStructure.MS5.(field); % Get the field value
                
                if ischar(value) % Only process strings
                    % Remove leading and trailing single/double quotes
                    value = strip(value, '"');
                    value = strip(value, '''');
                    
                    % Check if the value is 'None'
                    if strcmpi(value, 'None')
                        AutorunConfig.CreateSpikeSorting.ParameterStructure.MS5.(field) = []; % Convert to empty
                    else
                        AutorunConfig.CreateSpikeSorting.ParameterStructure.MS5.(field) = value; % Assign the cleaned value back
                    end
                end
            end

            % Convert Sorter Parameter into dictionary
            SortingParameters = jsonencode(AutorunConfig.CreateSpikeSorting.ParameterStructure.MS5);

        elseif strcmp(AutorunConfig.CreateSpikeSorting.Sorter,"SpykingCircus 2")
            AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2 = Spike_Module_cleanStructureQuotes(AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2);
            AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2 = Spike_Module_convertTrueFalseStrings(AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2);
            
            % Loop over all fields
            fields = fieldnames(AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2);
            for i = 1:numel(fields)
                field = fields{i}; % Get the field name
                value = AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2.(field); % Get the field value
                
                if ischar(value) % Only process strings
                    % Remove leading and trailing single/double quotes
                    value = strip(value, '"');
                    value = strip(value, '''');
                    
                    % Check if the value is 'None'
                    if strcmpi(value, 'None')
                        AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2.(field) = []; % Convert to empty
                    else
                        AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2.(field) = value; % Assign the cleaned value back
                    end
                end
            end
            
            % Convert Sorter Parameter into dictionary
            SortingParameters = jsonencode(AutorunConfig.CreateSpikeSorting.ParameterStructure.SC2);

        elseif strcmp(AutorunConfig.CreateSpikeSorting.Sorter,"Kilosort 4")
            % Loop over all fields
            fields = fieldnames(AutorunConfig.CreateSpikeSorting.ParameterStructure.KS4);
            for i = 1:numel(fields)
                field = fields{i}; % Get the field name
                value = AutorunConfig.CreateSpikeSorting.ParameterStructure.KS4.(field); % Get the field value
                
                if ischar(value) % Only process strings
                    % Remove leading and trailing single/double quotes
                    value = strip(value, '"');
                    value = strip(value, '''');
                    
                    % Check if the value is 'None'
                    if strcmpi(value, 'None')
                        AutorunConfig.CreateSpikeSorting.ParameterStructure.KS4.(field) = []; % Convert to empty
                    else
                        AutorunConfig.CreateSpikeSorting.ParameterStructure.KS4.(field) = value; % Assign the cleaned value back
                    end
                end
            end
    
            % Convert Sorter Parameter into dictionary
            SortingParameters = jsonencode(AutorunConfig.CreateSpikeSorting.ParameterStructure.KS4);
        end
        
        % Save JSON to a temporary file
        Tempfilepath = convertStringsToChars(file_path);
        filePathDash = find(Tempfilepath=='\');
        Tempfilepath = Tempfilepath(1:filePathDash(end)-1);

        if isfile(fullfile(Tempfilepath, 'sorting_parameters.json'))
            delete(fullfile(Tempfilepath, 'sorting_parameters.json'))
        end
        jsonFilePath = fullfile(Tempfilepath, 'sorting_parameters.json');
        fid = fopen(jsonFilePath, 'w');
        fwrite(fid, SortingParameters, 'char');
        fclose(fid);
        
        AutorunConfig.CreateSpikeSorting.OpenSpikeInterface = str2double(AutorunConfig.CreateSpikeSorting.OpenSpikeInterface);
        AutorunConfig.CreateSpikeSorting.Preprocess = str2double(AutorunConfig.CreateSpikeSorting.Preprocess);
        AutorunConfig.CreateSpikeSorting.PlotTraces = str2double(AutorunConfig.CreateSpikeSorting.PlotTraces);
        AutorunConfig.CreateSpikeSorting.PlotSortingResults = str2double(AutorunConfig.CreateSpikeSorting.PlotSortingResults);
        AutorunConfig.CreateSpikeSorting.LoadSorting = str2double(AutorunConfig.CreateSpikeSorting.LoadSorting);
        AutorunConfig.CreateSpikeSorting.KeepConsoleOpen = str2double(AutorunConfig.CreateSpikeSorting.KeepConsoleOpen);
        AutorunConfig.CreateSpikeSorting.MultipleRecordings = str2double(AutorunConfig.CreateSpikeSorting.MultipleRecordings);

        command = sprintf('"%s" "%s" "%s" %d "%s" %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d', ...
            pythonPath, SpikeInterfaceScriptPath, Tempfilepath, AutorunConfig.CreateSpikeSorting.MultipleRecordings, AutorunConfig.CreateSpikeSorting.Sorter, ...
            AutorunConfig.CreateSpikeSorting.Preprocess, AutorunConfig.CreateSpikeSorting.LoadSorting, AutorunConfig.CreateSpikeSorting.OpenSpikeInterface, ...
            AutorunConfig.CreateSpikeSorting.PlotSortingResults, AutorunConfig.CreateSpikeSorting.JustOpenSpikeInterfaceGUI, SampleRate, NumChannel, ypitch, AutorunConfig.CreateSpikeSorting.KeepConsoleOpen, AutorunConfig.CreateSpikeSorting.PlotTraces,VerChannelOffset,HorChannelOffset,NumberRows,RowOffset,RowOffsetDistance);
        
        % Execute the Python script
        [status, cmdout] = system(command);
        
        % Check status

        if status == 0
            disp('Python script executed successfully:');
            disp(cmdout);
        else
            disp('Error executing Python script:');
            disp(cmdout);
        end

    else

        SpikeSortingPath = strcat(Data.Info.Data_Path,'\Wave_Clus');

        if strcmp(AutorunConfig.InternalSpikeDetection.WaveClus3_SpikeSortingType,'AllChannelTogether')
            SortingType = "AllChannelTogether";
        elseif strcmp(AutorunConfig.InternalSpikeDetection.WaveClus3_SpikeSortingType,'IndividualChannel')
            SortingType = "IndividualChannel";
        end
        if isfield(Data,'Spikes')
            [Data] = Spike_Module_Internal_Spike_Sorting(Data,SpikeSortingPath,"Clustering",SortingType,'WaveClus');
        else
            warning("No spikes extracted for Waveclus clustering. Please first add the Spike Detection step to the pipeline. Skipping Step")
            return;
        end
    end
elseif strcmp(FunctionOrder,'Load_Internal_Spike_Sorting')
    SpikeSortingPath = strcat(Data.Info.Data_Path,'\Wave_Clus');
    [Data] = Spike_Module_Internal_Spike_Sorting(Data,SpikeSortingPath,"Loading",[],'WaveClus');
end

%______________________________________________________________________________________________________
% 5.3 Load from SpikeSorting
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Load_from_SpikeSorting')

    if strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Kilosort external GUI")
        SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
        SelectedFolder = strcat(SelectedFolder,"kilosort4");
    elseif strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Kilosort3")
        SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
        SelectedFolder = strcat(SelectedFolder,"kilosort3");
    elseif strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Kilosort SpikeInterface")
        SelectedFolder = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\");
        SelectedFolder = strcat(SelectedFolder,"Kilosort 4");
    elseif strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Mountainsort 5")
        SelectedFolder = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\");
        SelectedFolder = strcat(SelectedFolder,"Mountainsort 5");
    elseif strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"SpykingCircus 2")
        SelectedFolder = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\");
        SelectedFolder = strcat(SelectedFolder,"SpykingCircus 2");
    elseif strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"WaveClus 3")
        SelectedFolder = strcat(Data.Info.Data_Path,"\Wave_Clus\");
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

    if strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Kilosort external GUI")
        %% Autoseach scalingfactor
        if ~isempty(AutorunConfig.LoadfromSpikeSorting.ScalingFactor)
            ScalingFactor = str2double(AutorunConfig.LoadfromSpikeSorting.ScalingFactor);
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

    if strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Mountainsort 5") || strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"SpykingCircus 2") || strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Kilosort SpikeInterface")
        [Data,~] = Spike_Module_Load_SpikeInterface_Sorter(Data,SelectedFolder,AutorunConfig.LoadfromSpikeSorting.Sorter);
    end

    if strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"Kilosort external GUI")
        % Function to load all relevant npy and .mat files Kilosort outputs
        [Data,~] = Spike_Module_Load_Kilosort_Data(Data,"No",SelectedFolder,ScalingFactor);
    end

    if strcmp(AutorunConfig.LoadfromSpikeSorting.Sorter,"WaveClus 3")
        [Data] = Spike_Module_Internal_Spike_Sorting(Data,SelectedFolder,"Loading",[],'WaveClus');
    end

end

%______________________________________________________________________________________________________
% 5.4 Save for SpikeSorting
%______________________________________________________________________________________________________
if strcmp(FunctionOrder,'Save_for_SpikeSorting')
    Execute = 1;
    if ~isfield(Data,'Raw')
        msgbox("Error: No Raw Data found. Data to be exported has to not be preprocessed! Returning.");
        Execute = 0;
    end

    if Execute == 1

        if strcmp(AutorunConfig.SaveforSpikeSorting.Dataset,"Preprocessed Data")
            if ~isfield(Data,'Preprocessed')
                warning("Selected preprocessed data to save for spike sorting but its not part of the dataset yet. Skipping step.")
                return;
            end
        end
        
        if strcmp(AutorunConfig.SaveforSpikeSorting.Sorter,"Kilosort")
            AutorunConfig.SaveforSpikeSorting.FileFormat = '.dat'; % '.dat' for Kilosort OR '.bin' for SpikeInterface
        else
            AutorunConfig.SaveforSpikeSorting.SaveFormat = 'double';
            AutorunConfig.SaveforSpikeSorting.FileFormat = '.bin'; % '.dat' for Kilosort OR '.bin' for SpikeInterface
        end

        if strcmp(AutorunConfig.SaveforSpikeSorting.FileFormat,'.dat')
            if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
                SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
                Filename = strcat(AutorunConfig.FolderContents{nRecordings},".dat");
            else
                dashindex = find(Data.Info.Data_Path=='\');
                Filename = strcat(Data.Info.Data_Path(dashindex(end)+1:end),".dat");
                SelectedFolder = strcat(Data.Info.Data_Path,"\Kilosort\");
            end
        elseif strcmp(AutorunConfig.SaveforSpikeSorting.FileFormat,'.bin')
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
        [Data] = Spike_Module_Save_for_Kilosort(Data,AutorunDetection,FullPath,AutorunConfig.SaveforSpikeSorting.SaveFormat,AutorunConfig.SaveforSpikeSorting.Sorter,AutorunConfig.SaveforSpikeSorting.Dataset);
    end
end