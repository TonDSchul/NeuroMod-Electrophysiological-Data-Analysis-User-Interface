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

if strcmp(Type,"Auto")
    %% Check if SpikeInterface standard folder found
    if ~strcmp(app.SorterDropDown.Value,"Kilosort 4")
        StandardPath = strcat(app.Mainapp.Data.Info.Data_Path,'\SpikeInterface');
        [stringArray] = Utility_Extract_Contents_of_Folder(StandardPath);
        
        if sum(contains(stringArray,'.bin'))>0
            a = find(contains(stringArray,'.bin')==1);
            if length(a)>1 || isempty(a)
                disp(strcat("More than one .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",StandardPath))
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
        
                app.SpikeSortinBinPath = strcat(StandardPath,'\',stringArray(a));
            end
        else
            disp(strcat("More than one .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",StandardPath))
            app.CheckBox.Value = 0;
            app.Label.FontColor = [1.00,0.00,0.00];
            app.AutoSortingPathToBin = 0;
            app.Label.Text = "Auto-detection of exported .bin file " + ...
                "NOT Succesfull";
            app.SpikeSortinBinPath = [];
        end
    else
        StandardPath = strcat(app.Mainapp.Data.Info.Data_Path,'\SpikeInterface');
        [stringArray] = Utility_Extract_Contents_of_Folder(StandardPath);
        
        if sum(contains(stringArray,'.bin'))>0
            a = find(contains(stringArray,'.bin')==1);
            if length(a)>1 || isempty(a)
                disp(strcat("More than one .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",StandardPath))
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
        
                app.SpikeSortinBinPath = strcat(StandardPath,'\',stringArray(a));
            end
        else
            disp(strcat("More than one .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",StandardPath))
            app.CheckBox.Value = 0;
            app.Label.FontColor = [1.00,0.00,0.00];
            app.AutoSortingPathToBin = 0;
            app.Label.Text = "Auto-detection of exported .bin file " + ...
                "NOT Succesfull";
            app.SpikeSortinBinPath = [];
        end
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
                disp(strcat("More than one .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",filepath))
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
            disp(strcat("More than one .bin file found in autosearched directory. Autosearched path can not be taken for sorting. Please select a .bin file manually!.",filepath))
            app.CheckBox.Value = 0;
            app.Label.FontColor = [1.00,0.00,0.00];
            app.AutoSortingPathToBin = 0;
            app.Label.Text = "Manual-detection of exported .bin file " + ...
                "NOT Succesfull.";
            app.SpikeSortinBinPath = [];
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

end