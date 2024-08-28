function [filteredFolderContents] = Execute_Autorun_Check_Selected_Folder(folderPath)

% Step 2: Get the contents of the folder
contents = dir(folderPath);

% Step 3: Initialize an empty string array for filtered names
filteredFolderContents = strings(0);

% Step 4: Iterate through the contents
for i = 1:length(contents)
    item = contents(i);
    
    % Skip the current and parent directory entries
    if strcmp(item.name, '.') || strcmp(item.name, '..')
        continue;
    end
    
    % Check if the item is a file with any extension
    [~, name, ext] = fileparts(item.name);
    if isfile(fullfile(folderPath, item.name)) && ~isempty(ext)
        % Skip files with any extension
        continue;
    end
    
    % Check if the item is a directory
    if isfolder(fullfile(folderPath, item.name))
        % Check if the folder is empty
        subfolderContents = dir(fullfile(folderPath, item.name));
        if length(subfolderContents) > 2
            % The folder is not empty, add it to the filtered names
            filteredFolderContents(end+1) = string(item.name);
        end
    else
        % It's a file without the specific extensions
        filteredFolderContents(end+1) = string(item.name);
    end
end