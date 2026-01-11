function [IsNP1,DataPartToextract] = Manage_Dataset_Check_NEO_NP1_Recording(Data,RecordingPath)

%________________________________________________________________________________________

%% Function to detect lfp and ap signal of Neuropixel recordings and asks the user which one to extract
% info if it is NP recording is searched for in sync_messages.txt in the
% Open Ephys recording folder

% Input:
% 1. Data: main window data structure
% 2. RecordingPath: Path to the recording selected at data extraction

% Output: IsNP1 =double, 1 or 0 whether NP1 recording (in other words
% sync_messages.txt) was found inf passed recording path
% DataPartToextract: double, 1 or 0 whether the user selected to extract LFP
%or AP data. 1=LFP, 2 = AP

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


IsNP1 = 0;
DataPartToextract = 0;

% Search recursively for the file
fileinfo = dir(fullfile(RecordingPath, '**', 'sync_messages.txt'));

if ~isempty(fileinfo)
    synmessagepath = fullfile(fileinfo(1).folder, fileinfo(1).name);
else
    disp('sync_messages.txt not found.')
    return;
end

% Read file into a string
fileText = fileread(synmessagepath);

% Check if strings are present
hasPXI = contains(fileText, 'Neuropix-PXI');
hasNeuropix = contains(fileText, 'Neuropix');

if sum(hasPXI)>0 || sum(hasNeuropix)>0 % NP recording?
    
    hasLFP = contains(fileText, 'LFP');
    hasAP = contains(fileText, 'AP');

    if sum(hasLFP)>0 && sum(hasAP)>0 % NP 1.0 recording?
        IsNP1 = 1;
        
        % Ask user what he wants
        NPRecordings = Neuropixels1_LFP_or_AP(IsNP1);
        
        uiwait(NPRecordings.NPDataTypeUIFigure);
        
        if isvalid(NPRecordings)
            DataPartToextract = NPRecordings.SelectedRecordings; % == 1 if LFP data selected, == 2 if AP data selected
            delete(NPRecordings);
        else
            disp("Error: Selection of either AP or LFP data failed. LFP data is exctracted by default. Rename 'SelectedStream' variable in Open_Ephys_Load_All_Formats.m")
            DataPartToextract = 1; % == 1 if LFP data selected, == 2 if AP data selected
        end

    end
end
