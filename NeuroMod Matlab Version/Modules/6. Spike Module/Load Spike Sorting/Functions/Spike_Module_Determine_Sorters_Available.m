function [Path,CurrentSorter,AmplitudeScalingFactorEditField,InfoText] = Spike_Module_Determine_Sorters_Available(Data,SorterFolders,ManualSelection,ChangedSelectedSorter)

%________________________________________________________________________________________

%% Function to determine (automatically) which sorter outputs are available folder specified in SorterFolders

% Note: order of folder locations in SorterFolders is relevant!
% 
% Input:
% 1. Data = structure containing all data. 
% 2. SorterFolders: string array with each indicie containing a path to
% search spike sorting data in. First indicie is path to external Kilosort 4 GUI, second indicie is Kilosort3, third is Mpuntainsort 5, then
% SpykingCircus 2 and Kilpsort 4 from SpikeInterface as last -- when
% autosearch: path = recording_path/Kilosort or recording_path/SpikeInterface with their respective sunfolders
% 3. ManualSelection: NOT USED ANYMORE! double, either 1 or 0 to indicate whether input paths
% come from autodetection (recording path/Kilosort) or where manually
% selcted (auto adds subfolder extensions like /Kilosort/kilosort4)
% 4. ChangedSelectedSorter: NOT USED ANYMORE! double, either 1,2,3,4 or 5. Each number stands
% for a sorter thas was selected. This is used to search for just a single
% sorter (when the user selects a different folder in the GUI) to indicate
% which is searche for; 1 = external KS3 and 4; 2 = MS5; 3 = SC2; 4 = KS4
% SpikeInterface; 5=Waveclus

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

InfoText = [];
            
Sorter = [];
CurrentSorter = [];

if ManualSelection == 0
    % External Kilsoort
    if isfolder(SorterFolders(1)) || isfolder(SorterFolders(2))
        if isfolder(SorterFolders(1))
            [stringArray] = Utility_Extract_Contents_of_Folder(SorterFolders(1));
            InfoText = strcat("Auto-searched Path (Original Recording Folder): ", SorterFolders(1));
            InfoText = [InfoText;"";"Searching for sorting output results (.npy files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
            Path = SorterFolders(1);
            CurrentSorter = "Kilosort4";
            Sorter = [Sorter,1];
        else
            [stringArray] = Utility_Extract_Contents_of_Folder(SorterFolders(2));
            InfoText = strcat("Auto-searched Path (Original Recording Folder): ", SorterFolders(2));
            InfoText = [InfoText;"";"Searching for sorting output results (.npy and .mat files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
            Path = SorterFolders(2);
            CurrentSorter = "Kilosort3";
            Sorter = [Sorter,2];
        end
    elseif isfolder(SorterFolders(3)) || isfolder(SorterFolders(4))
        if isfolder(SorterFolders(3)) || isfolder(SorterFolders(4))
            if isfolder(SorterFolders(3))
                [stringArray] = Utility_Extract_Contents_of_Folder(SorterFolders(3));
                InfoText = strcat("Auto-searched Path (Original Recording Folder): ", SorterFolders(3));
                InfoText = [InfoText;"";"Searching for sorting output results (.npy files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
                Path = SorterFolders(3);
                CurrentSorter = "Mountainsort5";
                Sorter = [Sorter,3];
            elseif isfolder(SorterFolders(4))
                [stringArray] = Utility_Extract_Contents_of_Folder(SorterFolders(4));
                InfoText = strcat("Auto-searched Path (Original Recording Folder): ", SorterFolders(4));
                InfoText = [InfoText;"";"Searching for sorting output results (.npy files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
                Path = SorterFolders(4);
                CurrentSorter = "SpykingCircus2";
                Sorter = [Sorter,4];
            end                     
        end
    elseif isfolder(SorterFolders(5)) % Waveclus
            [stringArray] = Utility_Extract_Contents_of_Folder(SorterFolders(5));
            InfoText = strcat("Auto-searched Path (Original Recording Folder): ", SorterFolders(5));
            InfoText = [InfoText;"";"Searching for sorting output results (spikes.mat and spike_times.mat)."];
            Path = SorterFolders(5);
            CurrentSorter = "WaveClus";
            Sorter = [Sorter,5];
            % SpikeInterface Kilsoort
    elseif isfolder(SorterFolders(6))
            [stringArray] = Utility_Extract_Contents_of_Folder(SorterFolders(6));
            InfoText = strcat("Auto-searched Path (Original Recording Folder): ", SorterFolders(6));
            InfoText = [InfoText;"";"Searching for sorting output results (.npy files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
            Path = SorterFolders(6);
            CurrentSorter = "SpikeInterface Kilosort";
            Sorter = [Sorter,6];
    else
        [stringArray] = Utility_Extract_Contents_of_Folder(Data.Info.Data_Path);
        
        IndicieToDelete = [];
        for i = 1:length(SorterFolders)
            if strcmp(SorterFolders(i),"")
                IndicieToDelete = [IndicieToDelete,i];
            end
        end

        if ~isempty(IndicieToDelete)
            SorterFolders(IndicieToDelete) = [];
        end

        JoinedSoterFolders = join(SorterFolders, ";     AND     ;");
        InfoText = strcat("Auto-searched Path for sorting output files (Original Recording Folder): ", JoinedSoterFolders);
        InfoText = [InfoText;"";"Searching for sorting output results (.npy files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
        
        if isfolder(Data.Info.Data_Path)
            Path = Data.Info.Data_Path;
        else
            Path = [];
        end
    end

    if ~strcmp(CurrentSorter,"WaveClus")
        % Filter files with .npy extension
        npyFiles = stringArray(endsWith(stringArray, '.npy'));
        
        if isempty(npyFiles)
            InfoText = ["Warning: No .npy sorter output files found in auto-searched folder. Please select a different folder."; ""; InfoText];
        else
            SorterNames = [];
            for i = 1:length(Sorter)
                if Sorter == 1
                    SorterNames = [SorterNames,"External Kilosort GUI"];
                elseif Sorter == 2
                    SorterNames = [SorterNames,"External Kilosort GUI"];
                elseif Sorter == 3
                    SorterNames = [SorterNames,"Mountainsort 5"];
                elseif Sorter == 4
                    SorterNames = [SorterNames,"SpykingCircus 2"];
                elseif Sorter == 5
                    SorterNames = [SorterNames,"WaveClus 3"];
                elseif Sorter == 6
                    SorterNames = [SorterNames,"SpikeInterface Kilosort"];
                end
                if i ~=length(Sorter)
                    SorterNames = [SorterNames,","];
                end
            end
            InfoText = [strcat(".npy output files for sorter(s) ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
        end
    else
        % Filter files with .npy extension
        npyFiles = stringArray(endsWith(stringArray, '.mat'));
        
        if isempty(npyFiles)
            InfoText = ["Warning: No .mat sorter output files found in auto-searched folder. Please select a different folder."; ""; InfoText];
        else
            SorterNames = [];
            for i = 1:length(Sorter)
                if Sorter == 1
                    SorterNames = [SorterNames,"External Kilosort GUI"];
                elseif Sorter == 2
                    SorterNames = [SorterNames,"External Kilosort GUI"];
                elseif Sorter == 3
                    SorterNames = [SorterNames,"Mountainsort 5"];
                elseif Sorter == 4
                    SorterNames = [SorterNames,"SpykingCircus 2"];
                elseif Sorter == 5
                    SorterNames = [SorterNames,"WaveClus 3"];
                elseif Sorter == 6
                    SorterNames = [SorterNames,"SpikeInterface Kilosort"];
                end
                if i ~=length(Sorter)
                    SorterNames = [SorterNames,","];
                end
            end
            InfoText = [strcat(".mat output files for sorter(s) ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
        end
    end

else % If manual Folderselection

    if isfolder(SorterFolders(1))
        [stringArray] = Utility_Extract_Contents_of_Folder(SorterFolders(1));
        InfoText = strcat("Manually selected Path: ", SorterFolders(1));
        InfoText = [InfoText;"";"Searching for sorting output results (.npy files for SpikeInterface and Kilosort, .mat file for Waveclus) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
        Path = SorterFolders(1);

        % Filter files with .npy extension
        npyFiles = stringArray(endsWith(stringArray, '.npy'));

        if ChangedSelectedSorter == 1 % external Kilsoort guis (kilosort 3 and 4)
            if ~isempty(npyFiles)
                CurrentSorter = [];
                if sum(contains(stringArray,"cluster_KSLabel.tsv"))>0
                    if sum(contains(stringArray,"rez.mat"))>0
                        SorterFolders(1) = strcat(Data.Info.Data_Path,"\Kilosort\kilosort3");
                        CurrentSorter = "Kilosort3"; 
                        SorterNames = "External Kilosort GUI"; 
                        InfoText = [strcat(".npy output files for sorter(s) ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
                    else
                        SorterFolders(1) = strcat(Data.Info.Data_Path,"\Kilosort\kilosort4");
                        CurrentSorter = "Kilosort4"; 
                        SorterNames = "External Kilosort GUI"; 
                        InfoText = [strcat(".npy output files for sorter(s) ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
                    end
                end
            else
                InfoText = ["Warning: No .npy sorter output files found in manually selected Path folder. Please select a different folder."; ""; InfoText];
            end
                       
        elseif ChangedSelectedSorter == 2 % SpikeInterface Mountainsort 5
            if ~isempty(npyFiles)
                CurrentSorter = [];
                if sum(contains(stringArray,"cluster_KSLabel.tsv"))==0
                    if sum(contains(stringArray,"SpikePositions.mat"))>0
                        CurrentSorter = "Mountainsort5"; 
                        SorterNames = "Mountainsort5";
                        InfoText = [strcat(".npy output files for sorter ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
                    else
                        InfoText = ["Warning: .npy file present but no SpikePosition.mat from SpikeInterface found."; ""; InfoText];
                    end
                else
                    CurrentSorter = "Mountainsort5"; 
                    SorterNames = "Mountainsort5";
                    InfoText = [strcat("Warning: No .npy sorter output files found for ",SorterNames," in manually selected Path folder. Please select a different folder."); ""; InfoText];
                end
            else
                InfoText = ["Warning: No .npy sorter output files for SpikeInterface found in manually selected Path folder. Please select a different folder."; ""; InfoText];
            end
        elseif ChangedSelectedSorter == 3 % SpikeInterface SpykingCircus 2
            if ~isempty(npyFiles)
                CurrentSorter = [];
                if sum(contains(stringArray,"cluster_KSLabel.tsv"))==0
                    if sum(contains(stringArray,"SpikePositions.mat"))>0
                        CurrentSorter = "SpykingCircus2"; 
                        SorterNames = "SpykingCircus2";
                        InfoText = [strcat(".npy output files for sorter(s) ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
                    else
                        InfoText = ["Warning: .npy file present but no SpikePosition.mat from SpikeInterface found."; ""; InfoText];
                    end
                else
                    CurrentSorter = "SpykingCircus2"; 
                    SorterNames = "SpykingCircus2";
                    InfoText = [strcat("Warning: No .npy sorter output files found for ",SorterNames," in manually selected Path folder. Please select a different folder."); ""; InfoText];
                end
            else
                InfoText = ["Warning: No .npy sorter output files for SpikeInterface found in manually selected Path folder. Please select a different folder."; ""; InfoText];
            end

        elseif ChangedSelectedSorter == 4 % Waveclus
            % Filter files with .npy extension
            npyFiles = stringArray(endsWith(stringArray, '.mat'));

            if ~isempty(npyFiles)
                CurrentSorter = [];
                if sum(contains(stringArray,"spikes.mat"))>0
                    if sum(contains(stringArray,"spc_log.txt"))>0
                        CurrentSorter = "WaveClus"; 
                        SorterNames = "WaveClus 3";
                        InfoText = [strcat(".output files for sorter(s) ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
                    else
                        InfoText = ["Warning: .mat file present but no spc_log.txt found."; ""; InfoText];
                    end
                else
                    CurrentSorter = "WaveClus"; 
                    SorterNames = "WaveClus 3";
                    InfoText = [strcat("Warning: No sorter output files found for ",SorterNames," in manually selected Path folder. Please select a different folder."); ""; InfoText];
                end
            else
                InfoText = ["Warning: No sorter output files for WaveClus 3 found in manually selected Path folder. Please select a different folder."; ""; InfoText];
            end
        
        elseif ChangedSelectedSorter == 5 % SpikeInterface Kilosort
            if ~isempty(npyFiles)
                CurrentSorter = [];
                if sum(contains(stringArray,"cluster_KSLabel.tsv"))==0
                    if sum(contains(stringArray,"SpikePositions.mat"))>0
                        CurrentSorter = "SpikeInterface Kilosort"; 
                        SorterNames = "SpikeInterface Kilosort";
                        InfoText = [strcat(".npy output files for sorter ",SorterNames," found.");"";InfoText;""; "Folder contents are:"; stringArray];
                    else
                        InfoText = ["Warning: .npy file present but no SpikePosition.mat from SpikeInterface found."; ""; InfoText];
                    end
                else
                    CurrentSorter = "SpikeInterface Kilosort"; 
                    SorterNames = "SpikeInterface Kilosort";
                    InfoText = [strcat("Warning: No .npy sorter output files found for ",SorterNames," in manually selected Path folder. Please select a different folder."); ""; InfoText];
                end
            else
                InfoText = ["Warning: No .npy sorter output files for SpikeInterface found in manually selected Path folder. Please select a different folder."; ""; InfoText];
            end
        end

        if isempty(CurrentSorter)
            SorterFolders(1) = strcat(Data.Info.Data_Path,"\Kilosort\kilosort4");
            SorterFolders(2) = strcat(Data.Info.Data_Path,"\Kilosort\kilosort3");
            SorterFolders(3) = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\Mountainsort 5");
            SorterFolders(4) = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\SpykingCircus 2");
            SorterFolders(5) = strcat(Data.Info.Data_Path,"\Wave_Clus");
            SorterFolders(6) = strcat(Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\Kilosort 4");
            
            IndicieToDelete = [];
            for i = 1:length(SorterFolders)
                if strcmp(SorterFolders(i),"")
                    IndicieToDelete = [IndicieToDelete,i];
                end
            end
    
            if ~isempty(IndicieToDelete)
                SorterFolders(IndicieToDelete) = [];
            end
    
            JoinedSoterFolders = join(SorterFolders, ";     AND     ;");
            InfoText = strcat("Auto-searched Path for sorting output files (Original Recording Folder): ", JoinedSoterFolders);
            InfoText = [InfoText;"";"Searching for sorting output results (.npy files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
            
            if isfolder(Data.Info.Data_Path)
                Path = Data.Info.Data_Path;
            else
                Path = [];
            end
        end

    else
        SorterFolders(1) = strcat(app.Mainapp.Data.Info.Data_Path,"\Kilosort\kilosort4");
        SorterFolders(2) = strcat(app.Mainapp.Data.Info.Data_Path,"\Kilosort\kilosort3");
        SorterFolders(3) = strcat(app.Mainapp.Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\Mountainsort 5");
        SorterFolders(4) = strcat(app.Mainapp.Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\SpykingCircus 2");
        SorterFolders(5) = strcat(app.Mainapp.Data.Info.Data_Path,"\Wave_Clus");
        SorterFolders(6) = strcat(app.Mainapp.Data.Info.Data_Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\Kilosort 4");
        
        IndicieToDelete = [];
        for i = 1:length(SorterFolders)
            if strcmp(SorterFolders(i),"")
                IndicieToDelete = [IndicieToDelete,i];
            end
        end

        if ~isempty(IndicieToDelete)
            SorterFolders(IndicieToDelete) = [];
        end

        JoinedSoterFolders = join(SorterFolders, ";     AND     ;");
        InfoText = strcat("Auto-searched Path for sorting output files (Original Recording Folder): ", JoinedSoterFolders);
        InfoText = [InfoText;"";"Searching for sorting output results (.npy files) that are used to start phy (either with native Kilosort ouput files or with Spikeinterface using the 'export to Phy' functionality). Scaling factor only needed when loading Kilosort output files.";"";"Note: When loading SpikeInterface results, a 'SpikePositions'.mat file is needed holding the spike positions in um. When Spikeinterface sorting is done via NeuroMod, it will be created automatically."];
        
        if isfolder(Data.Info.Data_Path)
            Path = Data.Info.Data_Path;
        else
            Path = [];
        end
    end
end
            
if strcmp(CurrentSorter,"Kilosort4") || strcmp(CurrentSorter,"Kilosort3")
    if isfield(Data.Info,'KilosortScalingFactor')
        AmplitudeScalingFactorEditField = num2str(Data.Info.KilosortScalingFactor);
        InfoText = [InfoText; "";"Scaling factor to convert int format of kilosort output to mV found as part of the recording info."];
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

            load(ScalingFactorPath32,'scalingFactor');
            InfoText = [InfoText; "Scaling factor to convert int format of kilosort output to mV found in 'Original_Recording_Path/Kilosort' saved as a .mat file."];
            AmplitudeScalingFactorEditField = num2str(scalingFactor);
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

            load(ScalingFactorPath16,'scalingFactor');
            InfoText = [InfoText; "Scaling factor to convert int format of kilosort output to mV found in 'Original_Recording_Path/Kilosort' saved as a .mat file."];
            AmplitudeScalingFactorEditField = num2str(scalingFactor);
            Data.Info.KilosortScalingFactor = scalingFactor;
        else
            InfoText = [InfoText; "Scaling factor to convert int format of kilosort output to mV was not found as part of the dataset or as a .mat file in 'Original_Recording_Path/Kilosort'. Select a folder containing a .mat file with a variable called scalingfactor (autosaved when saving dataset for kilosort), enter the scalingfactor manually or leave it empty (for no scaling)"];      
            AmplitudeScalingFactorEditField = "";
        end

    end

else
    AmplitudeScalingFactorEditField = "";
end

InfoText = ["When you conducted spike sorting on your dataset either with Kilosort (with the external Kilosort GUI yourself) or Spikeinterface (with your own python script or using NeuroMod), you can load the results in NeuroMod for spike analysis. When you exported your dataset in the automatically created folder (and dont change output folder in Kilosort or Spikeinterface), results can be loaded with one click. Otherwise manually select a folder containing the sorting output folder expected for the respective sorter (shown below).";"";InfoText];

