function [DatFilePaths,AmplifierDataIndex,EventChannelIndex,TimeChannel,InfoRhd,selectedFolder] = CheckIntanDatFiles(selectedFolder)

%________________________________________________________________________________________

%% This function searches through folder contents containing an Intan recording and collects path to amplifier and event channel that are available

% This function is basically checking the contents of a folder when
% extracting Intan data recording as .dat files. Contents are strings with
% their own indice. For example, when an event channel is found among these strings (digital, analog or aux), the index is
% saved in the DIChannel variable. This gives basic infos about available files that
% can be analyze. It helps displaying available things in the GUI windows
% and set up data extraction by providing paths to specific files.

% Input:
% 1. selectedFolder: char of path to folder containing .dat files of intan
% recording

% Output: 
% 1. DatFilePaths: cell array with as many cells as folder has contents,
% saving the name of the content as string. 
% 2. AmplifierDataIndex: double vector with index of amplifier data
% contents (index of DatFilePaths)
% 3. EventChannel: double vector with index of event channel
% contents (index of DatFilePaths)
% 4. TimeChannel: double vector with index of time data
% contents (index of DatFilePaths)
% 5. InfoRhd: double vector with index of .rhd header file
% (index of DatFilePaths). NOTE: The folder has to contain a single .rhd file saving infos
% about the recording (Header). 
% 6. selectedFolder: outputting folder path in case it has to be modified. Not done yet, but keep it as option

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

% Initialize an empty cell array to store file paths

DatFilePaths = {};
rhdFilePaths = {};

% Function to recursively find and save CSV file paths
function findFilesInFolder(folder)
    % Get a list of all files and folders in the current folder
    contents = dir(folder);
    
    % Loop through the contents of the folder
    for i = 1:length(contents)
        item = contents(i);
        
        % Check if the item is a directory and not '.' or '..'
        if item.isdir && ~ismember(item.name, {'.', '..'})
            % Recursively call the function for subfolders
            findFilesInFolder(fullfile(folder, item.name));
        elseif endsWith(item.name, '.dat')
            filePath = fullfile(folder, item.name);
            DatFilePaths{end + 1} = filePath;
        elseif endsWith(item.name, '.rhd')
            filePath = fullfile(folder, item.name);
            rhdFilePaths{end + 1} = filePath;
        end
    end
end

% Start the recursive search process from the selected folder
findFilesInFolder(selectedFolder);

%% Find out what the dat files save
AmplifierDataIndex = [];
EventChannelIndex = [];

TimeChannel = [];
InfoRhd = [];
IndexToDelete = [];
% Delete unrelevant .dat files
for k = 1:length(DatFilePaths)
    if ~strcmp(DatFilePaths{k}(end-12:end-10),"amp") && ~strcmp(DatFilePaths{k}(end-16:end-16+6),"DIGITAL") && ~strcmp(DatFilePaths{k}(end-9:end-7),"ADC") && ~strcmp(DatFilePaths{k}(end-7:end-5),"AUX") && ~strcmp(DatFilePaths{k}(end-9:end-9+2),"DIN") && ~strcmp(DatFilePaths{k}(end-7:end-7+3),"time")
        IndexToDelete = [IndexToDelete,k];
    end
end

if ~isempty(IndexToDelete)
    DatFilePaths(IndexToDelete) = [];
end

for k = 1:length(DatFilePaths)
    if strcmp(DatFilePaths{k}(end-12:end-10),"amp")
        AmplifierDataIndex = [AmplifierDataIndex,k];
    elseif strcmp(DatFilePaths{k}(end-16:end-16+6),"DIGITAL")
        if ~isfield(EventChannelIndex,'DIChannel')
            EventChannelIndex.DIChannel = [];
        end
        EventChannelIndex.DIChannel = [EventChannelIndex.DIChannel,k];
    elseif strcmp(DatFilePaths{k}(end-9:end-7),"ADC")
        if ~isfield(EventChannelIndex,'ADCChannel')
            EventChannelIndex.ADCChannel = [];
        end
        EventChannelIndex.ADCChannel = [EventChannelIndex.ADCChannel,k];
    elseif strcmp(DatFilePaths{k}(end-7:end-5),"AUX")
        if ~isfield(EventChannelIndex,'AUXChannel')
            EventChannelIndex.AUXChannel = [];
        end
        EventChannelIndex.AUXChannel = [EventChannelIndex.AUXChannel,k];
    elseif strcmp(DatFilePaths{k}(end-9:end-9+2),"DIN")
        if ~isfield(EventChannelIndex,'DINChannel')
            EventChannelIndex.DINChannel = [];
        end
        EventChannelIndex.DINChannel = [EventChannelIndex.DINChannel,k];
    elseif strcmp(DatFilePaths{k}(end-7:end-7+3),"time")
        TimeChannel = [TimeChannel,k];
    end
end


if ~isfield(EventChannelIndex,'DIChannel') && ~isfield(EventChannelIndex,'ADCChannel') && ~isfield(EventChannelIndex,'AUXChannel') && ~isfield(EventChannelIndex,'DINChannel')
    EventChannelIndex = [];
end

%% Find out the poath and filename of the .rhd info file
if isempty(rhdFilePaths)
    return;
end

InfoRhd = rhdFilePaths{1};

if isempty(AmplifierDataIndex) 
    disp("Warning: No .dat file for amplifier channel found.")
elseif isempty(EventChannelIndex)
    disp("Warning: No .dat file for event trigger found.")
elseif isempty(TimeChannel)
    disp("Warning: No .dat file time found.")
elseif isempty(InfoRhd)
    disp("Warning: No info.rhd file found.")
end

end