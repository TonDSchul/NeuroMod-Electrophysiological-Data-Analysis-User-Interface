This folder contains the following functions with respective Header:

 ###################################################### 

File: Manage_Dataset_Module_SaveData.m
%________________________________________________________________________________________

%% Function to save data (Channel x Time single maxtrix) as a .dat file in in16 format or as a mat file.

% Saving is performed in chunks to increase performance and values get
% converted to binaries,w hich also increases loading performance 

% Input:
% 1. Data: Data structure containing preprocessed data as a Channel x Time
% matrix containing data.
% 2. Type: Which format to save data in. Possibilitioes are ".dat" and
% ".mat" (char or string)
% 3. Whattosave: vector with 6 numbers being either a 1 or a 0. Each
% indicie of the vector stands for a component of the dataset. The number 1 indicates, this component
% should be save. Components in the correct order are:
% [Raw,Preprocessed,Events,Spikes,EventrelatedData,PreprocessedEventrelatedData] --> [1,1,1,0,0,0] saves raw data, preprocessed data and event time points
% 4. executablefolder: Path to folder GUI is saved in as a string
% 5. Autorun: string specifying whether this function is called from the autorun functions or from the GUI
% if no Autorun: "No" ; if Autorun == "SingleFolder" or "MultipleFolder",
% depending on whether the autorun loops over multiple recordings
% (MultipleFolder).
% 6. SelectedFolder: Path as char to the folder the user selected containing the
% data to load. Only required when executed from Autorun with MultipleFolder, since
% then it automatically creates the save file folder, otherwise empty

% Output: 
% 1. filepath: string of path the file was saved in
% 2. Error: 1 if error occured, 0 otherwise

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

