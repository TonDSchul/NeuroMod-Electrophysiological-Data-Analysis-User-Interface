function [containsFiles] = Execute_Autorun_Config_Check_Intan_Folder_Contents(Folder,AutorunConfig)

if strcmp(AutorunConfig.ExtractRawRecording.RecordingsSystem,"Intan")

    if strcmp(AutorunConfig.ExtractRawRecording.FileType,"Intan .dat")

        % Get the contents of the folder
        contents = dir(Folder);
        
        % Initialize a flag to indicate if .dat files are found
        containsFiles = false;
        
        % Check each item in the folder
        for i = 1:length(contents)
            item = contents(i);
            
            % Skip the current and parent directory entries
            if strcmp(item.name, '.') || strcmp(item.name, '..')
                continue;
            end
            
            % Check if the item is a .dat file
            [~, ~, ext] = fileparts(item.name);
            if strcmp(ext, '.dat')
                containsFiles = true;
                break;
            end
        end
        
    elseif strcmp(AutorunConfig.ExtractRawRecording.FileType,"Intan .rhd")
        
        % Get the contents of the folder
        contents = dir(Folder);
        
        % Initialize a flag to indicate if .dat files are found
        containsFiles = false;
        
        % Check each item in the folder
        for i = 1:length(contents)
            item = contents(i);
            
            % Skip the current and parent directory entries
            if strcmp(item.name, '.') || strcmp(item.name, '..')
                continue;
            end
            
            % Check if the item is a .dat file
            [~, ~, ext] = fileparts(item.name);
            if strcmp(ext, '.rhd')
                containsFiles = true;
                break;
            end
        end

    end

end
