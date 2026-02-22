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

File: Manage_Dataset_SaveData_FieldTrip.m
%________________________________________________________________________________________

%% This function saves NeuroMod data as a .mat file compatible with FieldTrip

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. DataType: char, either "Raw Data" or "Preprocessed Data" to indicate
% 3. SaveEvents: double 1 or 0 whether to save event data if present
% what component to save
% 4. SaveFieldTripMat: double, 1 or 0 whether mat file is saved (1) for later use in FieldTrip or whether
% this function puts data in a structure to use within NeuroMod
% 5. OpenRawDataBrowser: 1 or 0 to open fieldtrips raw data inspector
% 6. OpenEventDataBrowser: 1 or 0 to open fieldtrips event data inspector
% 7. Autorun: 1 or 0 whether executed in NeuroMod (0) or in batch autorun
% analysis(0)
% 8. FolderToSave: folder to save fieldtrip compatible fiel in
% 9. EventChannel: event channel for which event data is saved along with
% channel data for use in FieldTrip
% 10. EventDataType: char, wither "Raw Event Related Data" or "Preprocessed
% 11. Event Related Data" indicating which one the user wants to save/use

% Output: 
% 1. Error: 1 or 0 whether error occured
% 2. SavePath: path .mat file was actually saved to
% 3. raw: fieldtrip data structure holding metadata and channel data
% 4. event: currently empty
% 5. eventdata: fieldtrip data structure holding event data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_SaveData_NWB.m
%________________________________________________________________________________________

%% This function saves NeuroMod data as a .nwb file using the MatNWB toolbox

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. SaveEvents: double 1 or 0 whether to save event data if present
% 3. DataType: char, either "Raw Data" or "Preprocessed Data" to indicate
% what component to save
% 4. SampleRate: double, sample rate in Hz. not from Data.Info. bc it
% depends on potential downsampling and is handled on a higher level
% 5. Originalfoldername: char, name of the folder data was extracted from
% in the extract raw recordings window

% Output: 
% 1. SavePath: char, path the user selected to save in
% 2. Error.double 1 or 0 

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_SaveData_NeoDat.m
%________________________________________________________________________________________

%% This function saves NeuroMod data as a .mat file compatible with NEO

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. SampleRate: double, sample rate of data being saved
% 3. DataToSave: char, either "Raw Data" or "Preprocessed Data"
% 4. SaveEvents: double 1 or 0 whether to save event data if present
% 5. SaveSpikes: double 1 or 0 whether to save spike data if present
% 6. Time: double vector with time points in seconds of recording
% 7. Autorun: 1 or 0 whether executed in NeuroMod (0) or in batch autorun
% analysis(0)
% 8. FolderToSave: folder to save NEO compatible file in

% Output: 
% 1. PathToSave: path .mat file was actually saved to
% 2. Error: 1 or 0 whether error occured

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_SaveData_SpikeInterfaceNumpy.m
%________________________________________________________________________________________

%% This function saves NeuroMod data as a spikeinterface compatible numpy object 

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. DatasetType: char, either "Raw Data" or "Preprocessed Data"
% 3. SaveEvents: double 1 or 0 whether to save event data if present
% 4. Autorun: 1 or 0 whether executed in NeuroMod (0) or in batch autorun
% analysis(0)
% 5. FolderToSave: folder to save NEO compatible file in


% Output: 
% 1. folderPath: char, path the user selected to save in

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Manage_Dataset_SavedData_ExportProbeToJSON.m
%________________________________________________________________________________________

%% This function exports NeuroMod probe information into a json file to load into spikeinterface (saving is not happening here but in the save spineinterface function)

% Input:
% 1. Data: Main app window data structure holding all relevant dataset
% components

% Output: 
% 1. Probe: cell containing porbe structure to save

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

