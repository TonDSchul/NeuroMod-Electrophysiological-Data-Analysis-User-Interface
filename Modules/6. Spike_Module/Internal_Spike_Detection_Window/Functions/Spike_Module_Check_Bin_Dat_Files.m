function app = Spike_Module_Check_Bin_Dat_Files(app,Type,filepath)

%________________________________________________________________________________________
%% Function to check whether a .bin file for spikeinterface sorting was found in the selected path

% Inputs:
% 1. app: Spike detection and sorting window object
% 2. Type: string ,"Auto" OR "Manual"; Auto on app startup for auto search,
% manual if user seleted folder manually
% 3. filepath: char with path to the folder to search in

% Outputs
% 1. app: Spike detection and sorting window object 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

KilosortPresent = 0;
Sortothersthankilosort = 0;

if strcmp(Type,"Auto")
    %% Check if SpikeInterface standard folder found
    if ~strcmp(app.SorterDropDown.Value,"Kilosort 4")
        
        StandardPath = strcat(app.Mainapp.Data.Info.Data_Path,'\SpikeInterface');
        [stringArray] = Utility_Extract_Contents_of_Folder(StandardPath);
        
        if sum(contains(stringArray,'.bin'))>0
            a = find(contains(stringArray,'.bin')==1);
            if length(a)>1 || isempty(a)
                disp(strcat("No .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",StandardPath))
                app.CheckBox.Value = 0;
                app.Label.FontColor = [1.00,0.00,0.00];
                app.AutoSortingPathToBin = 0;
                app.Label.Text = "Auto-detection of exported .bin file " + ...
                    "NOT Succesfull";
                app.SpikeSortinBinPath = [];
            else
                disp(strcat(".bin found in autosearched directory ",StandardPath))
                app.CheckBox.Value = 1;
                app.Label.FontColor = [0.47,0.67,0.19];
                app.AutoSortingPathToBin = 1;
                app.Label.Text = "Auto-detection of exported .bin file " + ...
                    "Succesfull";
                
                Sortothersthankilosort = 1;
                app.SpikeSortinBinPath = strcat(StandardPath,'\',stringArray(a));
            end
        end
    else
        StandardPath = strcat(app.Mainapp.Data.Info.Data_Path,'\SpikeInterface');
        [stringArray] = Utility_Extract_Contents_of_Folder(StandardPath);
        
        if sum(contains(stringArray,'.bin'))>0
            a = find(contains(stringArray,'.bin')==1);
            if length(a)>1 || isempty(a)
                disp(strcat("No .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",StandardPath))
                app.CheckBox.Value = 0;
                app.Label.FontColor = [1.00,0.00,0.00];
                app.AutoSortingPathToBin = 0;
                app.Label.Text = "Auto-detection of exported .bin file " + ...
                    "NOT Succesfull";
                app.SpikeSortinBinPath = [];
            else
                disp(strcat(".bin found in autosearched directory ",StandardPath))
                app.CheckBox.Value = 1;
                app.Label.FontColor = [0.47,0.67,0.19];
                app.AutoSortingPathToBin = 1;
                app.Label.Text = "Auto-detection of exported .bin file " + ...
                    "Succesfull";
        
                KilosortPresent = 1;
                app.SpikeSortinBinPath = strcat(StandardPath,'\',stringArray(a));
            end
        end
    end

    if KilosortPresent == 0 && Sortothersthankilosort == 0
        disp(strcat("No .bin or .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin or .bin file manually!.",StandardPath))
        app.CheckBox.Value = 0;
        app.Label.FontColor = [1.00,0.00,0.00];
        app.AutoSortingPathToBin = 0;
        app.Label.Text = "Auto-detection of exported .bin file " + ...
            "NOT Succesfull";
        app.SpikeSortinBinPath = [];
    end

    app.TextArea_3.Value = strcat("Auto-searched Folder: ",StandardPath);

elseif strcmp(Type,"Manual")
    %% Check if SpikeInterface standard folder found
    [stringArray] = Utility_Extract_Contents_of_Folder(filepath);
    
    if isempty(app.SpikeInterfaceParameter)
        TempMultipleRecordings = 0;
    else
        TempMultipleRecordings = app.SpikeInterfaceParameter.MultipleRecordings;
    end

    if TempMultipleRecordings == 0
        if sum(contains(stringArray,'.bin'))>0
            a = find(contains(stringArray,'.bin')==1);
            if length(a)>1 || isempty(a)
                disp(strcat("No .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",filepath))
                app.CheckBox.Value = 0;
                app.Label.FontColor = [1.00,0.00,0.00];
                app.AutoSortingPathToBin = 0;
                app.Label.Text = "Manual-detection of exported .bin file " + ...
                    "NOT Succesfull";
                app.SpikeSortinBinPath = [];
            else
                disp(strcat(".bin found in autosearched directory ",filepath))
                app.CheckBox.Value = 1;
                app.Label.FontColor = [0.47,0.67,0.19];
                app.AutoSortingPathToBin = 1;
                app.Label.Text = "Manual-detection of exported .bin file " + ...
                    "Succesfull";

                app.SpikeSortinBinPath = strcat(filepath,'\',stringArray(a));
            end
        else
            KilosortData = 0;
            if sum(contains(stringArray,'.bin'))>0 % Kilosort
                a = find(contains(stringArray,'.bin')==1);
                if length(a)>1 || isempty(a)
                    disp(strcat("No .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",filepath))
                    app.CheckBox.Value = 0;
                    app.Label.FontColor = [1.00,0.00,0.00];
                    app.AutoSortingPathToBin = 0;
                    app.Label.Text = "Manual-detection of exported .bin file " + ...
                        "NOT Succesfull";
                    app.SpikeSortinBinPath = [];
                else
                    disp(strcat(".bin found in autosearched directory ",filepath))
                    app.CheckBox.Value = 1;
                    app.Label.FontColor = [0.47,0.67,0.19];
                    app.AutoSortingPathToBin = 1;
                    app.Label.Text = "Manual-detection of exported .bin file " + ...
                        "Succesfull";
                    
                    KilosortData = 1;
                    app.SpikeSortinBinPath = strcat(filepath,'\',stringArray(a));
                end
            end

            if KilosortData == 0
                disp(strcat("No .bin or .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin or .bin file manually!.",filepath))
                app.CheckBox.Value = 0;
                app.Label.FontColor = [1.00,0.00,0.00];
                app.AutoSortingPathToBin = 0;
                app.Label.Text = "Manual-detection of exported .bin or .bin file " + ...
                    "NOT Succesfull.";
                app.SpikeSortinBinPath = [];
            end
        end
    else
            CuratedFoldercontents = [];
            for i = 1:length(stringArray)
                if contains(stringArray(i),".")
            
                elseif strcmp(stringArray(i),"")

                else
                    CuratedFoldercontents = [CuratedFoldercontents;stringArray(i)];
                end
            end
            
            if length(CuratedFoldercontents)>0
                app.CheckBox.Value = 1;
                app.Label.FontColor = [0.47,0.67,0.19];
                app.AutoSortingPathToBin = 1;
                app.Label.Text = strcat("Manual-selection of ",num2str(length(CuratedFoldercontents))," folder " + ...
                "Succesfull");
                app.SpikeSortinBinPath = filepath;
            else
                app.CheckBox.Value = 0;
                app.Label.FontColor = [1.00,0.00,0.00];
                app.AutoSortingPathToBin = 0;
                app.Label.Text = strcat("Manual-selection of ",num2str(length(CuratedFoldercontents))," folder " + ...
                "NOT Succesfull");
                app.SpikeSortinBinPath = [];
            end
            
    end

elseif strcmp(Type,"MultipleRecordings")

    [stringArray] = Utility_Extract_Contents_of_Folder(filepath);
    % Use isfolder to check if each item is a folder
    isFolder = arrayfun(@isfolder, filepath);
    % Get the names of folders
    folders = stringArray(isFolder);        
    if ~isempty(folders)
        if isscalar(folders)
            disp(strcat("Just one folder (recording) found in selected folder. You might want to select a folder with multiple recording folder. Path: ",filepath))
            app.CheckBox.Value = 0;
            app.Label.FontColor = [1.00,0.00,0.00];
            app.AutoSortingPathToBin = 0;
            app.Label.Text = strcat("Manual-selection of ",num2str(length(folders))," folder " + ...
            "NOT Succesfull");
            app.SpikeSortinBinPath = [];
        elseif length(folders) > 1
            disp(strcat("Multiple recording folders found in directory ",filepath))
            app.CheckBox.Value = 1;
            app.Label.FontColor = [0.47,0.67,0.19];
            app.AutoSortingPathToBin = 1;
            app.Label.Text = strcat("Manual-selection of ",num2str(length(folders))," folder " + ...
            "Succesfull");
            
            Sortothersthankilosort = 1;
            app.SpikeSortinBinPath = filepath;
        end
    else
        disp(strcat("No folder (recording) found in selected folder. You might want to select a folder with multiple recording folder. Path: ",filepath))
        app.CheckBox.Value = 0;
        app.Label.FontColor = [1.00,0.00,0.00];
        app.AutoSortingPathToBin = 0;
        app.Label.Text = strcat("Manual-selection of ",num2str(length(folders))," folder " + ...
        "NOT Succesfull");
        app.SpikeSortinBinPath = [];
    end
end