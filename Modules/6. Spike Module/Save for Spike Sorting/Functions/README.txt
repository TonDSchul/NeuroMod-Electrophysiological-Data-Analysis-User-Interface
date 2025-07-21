This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_Save_for_Kilosort.m
%________________________________________________________________________________________

%% Function to save Raw Data in int format as a .dat file to load in Kilosort

% standard folder to save in is 'Recording_Path/Kilosort

% Input:
% 1. Data: Data structure of toolbox. Required fields:
% 1.1. Data.Raw with Channel x Time data matrix (Preprocessing happens in Kilosort!)
% 2. Autorun: Variable specifiying whether function is called from the
% autorun function or from the GUI; "SingleFolder" or "MultipleFolder" when
% called from autorun, something else as a string whe not
% 3. SelectedFolder: Folder from whioch data was extracted/loaded, as char
% 4. Format: Int Format for saving Data; Options: 'int16' OR 'int32' as
% char for .dat files AND 'double' as char for .bin file type
% 4. FileType: Data type to save data in; Options: '.dat' OR '.bin'; .bin
% can only be saved in format 'double'
% 5. DatasetType: char, either 'Raw Data' or 'Preprocessed Data' to take to
% corresponding dataset component and save it

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

