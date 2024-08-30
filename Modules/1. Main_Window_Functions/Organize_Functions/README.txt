This folder contains the following functions with respective Header:

 ###################################################### 

File: Organize_Delete_Dataset_Components.m
%________________________________________________________________________________________

%% Function to delete a specific field of the Data structure. 
% Inputs:
% 1. Data: Data structure with Data.Raw or Data.Preprocessed, Data.Spikes
% and so on for Data and Data.Info for information about data.
% 2: ComponentToDelete: string, determines which part of the dataset should
% be deleted, otions: 
%"Spikes" OR "EventRelatedSpikes" OR "EventRelatedData" OR "Events" OR "Preprocessed" OR "Raw" Or "PreprocessedEventRelatedData"

% Output:
% Error: 1 if no data would be left after deleting, 0 if otherwise, If 1,
% deletion is not executed

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Initialize_GUI.m
%________________________________________________________________________________________

%% Function to Organize all basic mainapp values, properties, app parts and variables. 
% This function is called all over the toolbox to reorganizes datasets.
% This is used, to initiate variables when the GUI is started, when data is
% extracted (delete old data and autoset some values to match the new dataset), data is loaded (delete old data and autoset some values to match the new dataset)
% or preprocessed 

% NOTE: this only works with the main window app object as first input
% NOTE: Type "VariableDefinition" as input defines all necessary Data.Info
% fiels
% Inputs:
% 1. app: app object of GUI main window
% 2. Type: string, specifies why/at which point this function is called. % Options: "Initial" when GUI is started or reset, "Loading" when a new
% dataset is loaded (previosuly saved with GUI), "Extracting" when dataset
% was extracted from raw data, "Preprocessing" after preprocessing steps
% were applied or "VariableDefinition" during the data extractionf from raw
% data to centralize the fundamental infos of the Data.Info field 
% 3. HeaderInfo: Infos about recording extracted from raw datasets. Gets
% fused with Data.Info when Type = "VariableDefinition"
% 4. SampleRate in Hz as double when Type = "VariableDefinition"
% 5. SelectedFolder: Folder from whioch data was exracted or loade, as char
% when Type = "VariableDefinition"
% 6. RecordingType: string specifying the recording system when Type =
%"Extracting", Options: "IntanDat", "IntanRHD", "Spike2", "Open Ephys"
% 7. Time: double array with time point for each value of the raw dataset. Becomes app.Data.Time when Type = "VariableDefinition"
% 8. ChannelSpacing: in um as double


% Output:
% app object with initialized values

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Jump_in_Time.m
%________________________________________________________________________________________

%% %% Function to determine new starting time of data plot when user changes the time control forward/backward
% This function is called when the user wants to jump in time in the main
% window plot by clicking on the forward or backwards button in the
% time control panel of the main window

%NOTE: app.sCheckBox are the check box fields in the GUI time control
%specifying the amount of time to jump

% Inputs: 
% 1. app: app object of GUI main window
% 2. Direction: string, Options: "Backwards" to go backwards in time OR "Forward" to go forwards in time
% 3. TimeLimit: Max Time to determine whether jump violates time limits. (app.Data.Time(end))
% 4. TimeRange: Time to jump, as double in seconds
% 5. SampleRate in Hz as double

% Output:
% app object with updated app.CurrentTimePoints value capturing the first time
% point of the main window plot that is shown (in samples)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Prepare_Plot_and_Extract_GUI_Info.m
%________________________________________________________________________________________

%% Function to plot data in main window based on selecteions and datatypes of the GUI
% This function is called when the user changes the main window data or
% time plot to plot new data. This includes spikes and events

% Inputs: 
% 1. app: app object of GUI main window
% 2. PlotTime: Time in samples of the first datapoint plotted
% 3. TimePlotInitial: string specifying what is plotted in time plot. So far only
% Otions: "Initial"
% 4. DataPlotType: string specifying if movie or normal single plot is
% executed/selected. Either "Static" or "Movie"
% 5. EventPlot: string, "Events" to plot events, any other string to not
% plot events, like "Non"
% 6. Plotspikes: string, "Spikes" to plot spikes, any other string to not
% plot spikes, like "Non"

% Output:
% app object with updated app.CurrentTimePoints value capturing the first time
% point of the main window plot that is shown (in samples)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Set_MainWindow_TimeRange.m
%________________________________________________________________________________________

%% Function to increase or decrease the amopunt of time plotted in the main window
% This function is called when the user clicks on the + or - button in the
% time control panel of the main window to change the amount of time shown.
% The amount the plot window is changed is based on the checkboxes of the
% time control panel

%NOTE: app.sCheckBox are the check box fields in the GUI time control
%specifying the amount of data to plot

% Inputs: 
% 1. app: app object of GUI main window
% 2. CurrentTimeRange: Time in seconds (double) the plot is currently
% showing and gets is increased/decreased
% 3. TimeLimit: 1x2 double vetor with min and max time in seconds the plot
% is allowed to show.
% 4. Operation: Specifies whether time is increased or decreased, Either
% "Plus" OR "Minus"

% Output:
% app object with updated app.CurrentTimePoints value capturing the first time
% point of the main window plot that is shown (in samples)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

