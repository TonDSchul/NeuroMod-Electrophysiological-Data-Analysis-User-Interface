function Change_Modules_Add_New_Module(ExecutableFolder,ItemsTextArea,NumModules,NewModuleName,NewRunFunction)

%________________________________________________________________________________________

%% Function to take infos from creating new module window and save them in a .m function that is accessed by the GUI

% This function saves a cell array with the new module infos in the
% All_Module_Items.m function. This function is accessed to initiate
% modules in the
% main window

% Input:
% 1. ExecutableFolder: path GUI was started from, char (from mainapp window)
% 2. ItemsTextArea: 1x6 cell array with each cell containing either:
% 'Module Option 3:' or 'Module Option 2: Test3'. The first cell is the
% first Item that should be added to the module, the second cell to the
% second one and so on. If nothing is found after the ':' in each cell,
% nothing is saved. Therefore, only the cell arrays with strings after the
% ':' are regarded and added as new items!
% 3. NumModules: cell array with each cell being one module of the GUI.
% Just for getting the number of modules BEFORE the new one was added! 
% 4. NewModuleName: char, name of the new module
% 5. NewRunFunction: char, name of the matlab function executed when the
% user clicks the RUN button of the new module

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

LaufVariable = 1;
NewItems = {};

for i = 1:length(ItemsTextArea)
    line = ItemsTextArea{i}; % Get the current line
    colonIndex = strfind(line, ':'); % Find the colon
    
    if ~isempty(colonIndex)
        % Extract text after the last colon and trim spaces
        afterColon = strtrim(line(colonIndex(end)+1:end));
        
        % Check if the extracted text is empty
        isEmptyAfterColon(i) = isempty(afterColon);
    else
        % If no colon is found, assume it's missing data
        isEmptyAfterColon(i) = true;
    end

    if ~isempty(afterColon)
        NewItems{LaufVariable} = afterColon;
    end

    LaufVariable = LaufVariable +1;
end

Path = strcat(ExecutableFolder,'\Modules\1. Main Window Functions\Manage Modules\Functions\All_Module_Items.m');
% Read the function file
fileContent = fileread(Path);
fileLines = strsplit(fileContent, '\n');

% Define the search string
searchString = '%% end of definition (do not edit this!)';

% Find the line index where the search string appears
idx = find(contains(fileLines, searchString), 1);

if isempty(idx)
    msgbox(strcat("Error: Search string ",searchString ," not found in All_Module_Items.m (GUI_Path\Modules\1. Main_Window_Functions\Manage_Modules_Functions\Functions). This function needs to be unmodified!"));
    return;
end

NewCellCount = length(NumModules) + 1;
LaufVariable = 1;
newCode = {};
% Define the new cell array code
for n = 1:length(NewItems)+3
    if n == 1
        newCode{n} = strcat("%%", " ", NewModuleName);
    elseif n == 2 % Module anme
        newCode{n} = strcat("Module{",num2str(NewCellCount),"}.Title = '",NewModuleName,"';");
    elseif n == 3 % Function name
        newCode{n} = strcat("Module{",num2str(NewCellCount),"}.Function = '",NewRunFunction,"';");
    elseif n > 3 % Item names
        newCode{n} = strcat("Module{",num2str(NewCellCount),"}.Items{",num2str(LaufVariable),"} = '",NewItems{LaufVariable},"';");
        ''; % Blank line for readability
        LaufVariable = LaufVariable + 1;
    end
end
% Ensure newCode is a column cell array
newCode = newCode(:);

% Construct the updated file content
updatedFileLines = [fileLines(1:idx-1), newCode', fileLines(idx:end)]; % Ensure all are column vectors

% Write the updated content back to the file
fid = fopen(Path, 'w');
fprintf(fid, '%s\n', updatedFileLines{:});
fclose(fid);
