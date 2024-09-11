function Execute_Autorun_Config_Template(AutorunConfig,FunctionOrder,executableFolder,AutorunConfigName,Channelorder,NumIterations,LoadedData)
%________________________________________________________________________________________
%% This is the main functione executing all steps specified in the Config file in a loop

% This function is called when the user clicks on the execute config button
% in the autorun manager window

% Inputs:
% 1. AutorunConfig: Structure containing all analysis parameter
% specified in the config file selected
% 2. FunctionOrder: 1 x n string array containing the names of the
% analysis steps to execute
% 3. executableFolder: char, folder this instance of the Toolbox is saved in and
% executed from
% 4: AutorunConfigName: Name of the Autorun Config (set in the respective Config file at the
% beginning) to save Autorun structure at the end woth a proper name
% 5. Channelorder: 1 x nchannel double containing the true channel for each
% current channel position, empty if not selected
% 6. NumIterations: double, max nr of recordings that are analysed. If multiple recordings are analyzed, this function
% loops over them. If just one loaded this is set to 1 
% 7. LoadedData: 1 if data was loaded, 0 if data was extracted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


%______________________________________________________________________________________________________
%% Chain of functions. Do not edit unless you know what you are doing. Everything is automatically computed based on your inputs above
%______________________________________________________________________________________________________

Data = [];
Data.Raw = [];
Data.Preprocessed = [];

if find(FunctionOrder=='Load_Data')
    LoadedData = true;
else
    LoadedData = false;
end

%______________________________________________________________________________________________________
%% Loop over number of recordings and functions to be executed
%______________________________________________________________________________________________________
for nRecordings = AutorunConfig.StartFromFolder:NumIterations
    Data.CurrentPreproNr = 0;
    for nCurrentModuleIteration = 1:length(FunctionOrder)
        disp(strcat("Analyzing Folder number ",num2str(nRecordings)," of ",num2str(NumIterations),"; Step ",FunctionOrder(nCurrentModuleIteration)));
        %______________________________________________________________________________________________________
        %% 1. Manage Dataset Module Functions
        %______________________________________________________________________________________________________
        
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Extract_Raw_Recording') || strcmp(FunctionOrder(nCurrentModuleIteration),'Load_Data') || strcmp(FunctionOrder(nCurrentModuleIteration),'Save_Data')
            [Data] = Execute_Autorun_Manage_Dataset_Module_Functions(AutorunConfig,FunctionOrder(nCurrentModuleIteration),Data,nRecordings,Channelorder,executableFolder);
        end

        %% Skip this folder when no data found
        if isempty(Data)
            disp("No Data found, skipping folder.");
            continue;
        end

        disp(strcat("Folder: ",Data.Info.Data_Path));

        %% Handle Multiple Prepros
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Preprocess_Continous_Data')
            Data.CurrentPreproNr = Data.CurrentPreproNr+1;
        end
        %______________________________________________________________________________________________________
        %% 3. Continous Data Module
        %______________________________________________________________________________________________________
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Preprocess_Continous_Data') || strcmp(FunctionOrder(nCurrentModuleIteration),'Static_Power_Spectrum') || strcmp(FunctionOrder(nCurrentModuleIteration),'Continous_Spike_Analysis') || strcmp(FunctionOrder(nCurrentModuleIteration),'Continous_Unit_Analysis') 
           [Data] = Execute_Autorun_Continous_Data_Module_Functions (AutorunConfig,FunctionOrder(nCurrentModuleIteration),Data,Data.Info.Data_Path,LoadedData);
        end
        %% 4. Event Data Module
        %______________________________________________________________________________________________________
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Extract_Events') || strcmp(FunctionOrder(nCurrentModuleIteration),'Extract_Event_Related_Data') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Spike_Analysis') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Analysis_ERP') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Analysis_CSD') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Analysis_TimeFrequencyPower') || strcmp(FunctionOrder(nCurrentModuleIteration),'PreproEventDataModule') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Unit_Analysis')
            [Data] = Execute_Autorun_Extract_Events_Module_Functions(AutorunConfig,FunctionOrder(nCurrentModuleIteration),Data,Data.Info.Data_Path,LoadedData,executableFolder);
        end
        %______________________________________________________________________________________________________
        %% 5. Spike Module Functions
        %______________________________________________________________________________________________________
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Internal_Spike_Detection') || strcmp(FunctionOrder(nCurrentModuleIteration),'Load_from_Kilosort') || strcmp(FunctionOrder(nCurrentModuleIteration),'Save_for_Kilosort') || strcmp(FunctionOrder(nCurrentModuleIteration),'Create_Internal_Spike_Sorting') || strcmp(FunctionOrder(nCurrentModuleIteration),'Load_Internal_Spike_Sorting')
            [Data] = Execute_Autorun_Spike_Module_Functions(AutorunConfig,FunctionOrder(nCurrentModuleIteration),Data,nRecordings);
        end
        %______________________________________________________________________________________________________
    end

    if strcmp(AutorunConfig.SaveAutorunConfig,"on")
        if strcmp(AutorunConfig.ExtractMultipleRecordings,"on")
            if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
                FullPath = strcat(AutorunConfig.selected_folder,'\',AutorunConfig.FolderContents{nRecordings},'\Matlab\',AutorunConfig.ExtractRawRecording.FileType,'\');
            else
                FullPath = strcat(AutorunConfig.selected_folder,"\",AutorunConfig.FolderContents{nRecordings},"\Matlab\");
            end
        else
            if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Open Ephys")
                FullPath = strcat(AutorunConfig.selected_folder,"\","Matlab\",AutorunConfig.ExtractRawRecording.FileType,'\');
            else
                if LoadedData == 1
                    FullPath = strcat(AutorunConfig.selected_folder,"\");
                else
                    FullPath = strcat(AutorunConfig.selected_folder,"\Matlab\");
                end
            end
        end
        disp(strcat("Saving Autoconfig to: ",FullPath));
        folderName = 'Matlab';
        % Check if the folder already exists
        if ~exist(FullPath,'dir')
            % Create the folder if it does not exist
            mkdir(FullPath);
            %disp(['Folder "', folderName, '" created successfully.']);
        else
            disp(['Folder "', folderName, '" already exists.']);
        end

        Savefilename = convertStringsToChars(strcat(FullPath,"Autorun_Config_",AutorunConfigName,".mat"));

        save(Savefilename, 'AutorunConfig');
    end

    Data = [];
    Data.KilosortData = [];
    Data.Raw = [];
    Data.Preprocessed = [];

end

disp("Success. Autorun finsihed");

