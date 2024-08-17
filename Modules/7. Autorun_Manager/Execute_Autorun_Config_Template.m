function Execute_Autorun_Config_Template(AutorunConfig,FunctionOrder,executableFolder,AutorunConfigName,Channelorder,NumIterations,LoadedData)
%______________________________________________________________________________________________________
%% Chain of functions. Do not edit unless you know what you are doing. Everything is automatically computed based on your inputs above
%______________________________________________________________________________________________________

Data = [];
Data.Raw = [];
Data.Preprocessed = [];
LoadDataPath = [];

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
            [Data,LoadDataPath] = Execute_Autorun_Manage_Dataset_Module_Functions(AutorunConfig,FunctionOrder(nCurrentModuleIteration),Data,nRecordings,Channelorder,executableFolder,LoadDataPath);
        end

        %% Skip this folder when no data found
        if isempty(Data)
            disp("No Data found, skipping folder.");
            continue;
        end

        disp(strcat("Folder: ",LoadDataPath));

        %% Handle Multiple Prepros
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Preprocess_Continous_Data')
            Data.CurrentPreproNr = Data.CurrentPreproNr+1;
        end
        %______________________________________________________________________________________________________
        %% 3. Continous Data Module
        %______________________________________________________________________________________________________
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Preprocess_Continous_Data') || strcmp(FunctionOrder(nCurrentModuleIteration),'Static_Power_Spectrum') || strcmp(FunctionOrder(nCurrentModuleIteration),'Continous_Spike_Analysis') 
           [Data] = Execute_Autorun_Continous_Data_Module_Functions (AutorunConfig,FunctionOrder(nCurrentModuleIteration),Data,LoadDataPath,LoadedData);
        end
        %% 4. Event Data Module
        %______________________________________________________________________________________________________
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Extract_Events') || strcmp(FunctionOrder(nCurrentModuleIteration),'Extract_Event_Related_Data') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Spike_Analysis') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Analysis_ERP') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Analysis_CSD') || strcmp(FunctionOrder(nCurrentModuleIteration),'Event_Analysis_TimeFrequencyPower')
            [Data] = Execute_Autorun_Extract_Events_Module_Functions(AutorunConfig,FunctionOrder(nCurrentModuleIteration),Data,LoadDataPath,LoadedData);
        end
        %______________________________________________________________________________________________________
        %% 5. Spike Module Functions
        %______________________________________________________________________________________________________
        if strcmp(FunctionOrder(nCurrentModuleIteration),'Internal_Spike_Detection') || strcmp(FunctionOrder(nCurrentModuleIteration),'Load_from_Kilosort') || strcmp(FunctionOrder(nCurrentModuleIteration),'Save_for_Kilosort')
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
                FullPath = strcat(AutorunConfig.selected_folder,"\Matlab\");
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

