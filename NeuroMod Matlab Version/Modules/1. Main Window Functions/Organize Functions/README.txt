This folder contains the following functions with respective Header:

 ###################################################### 

File: Organize_Check_Path_Variables.m
%________________________________________________________________________________________
%% Function to check all paths to python.exe environments and the CED64 Spike2 tools
% python.exes for environments with: SpikeInterface, NEO, Phy

% Input Arguments:
% 1. executablefolder: char, folder NeuroMod is executed from to load
% variables and check if paths exist

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Convert_ActiveChannel_to_DataChannel.m
%________________________________________________________________________________________
%% Function to convert active channel selection to a data channel.
% This function is necessary bc. the active channel can have interruptions
% (i.e. 1,2,4,5,6,8..) which can not be used to index the data matrix. Therefore this has to be changed to an index within the data channel range 

% Input Arguments:
% 1. AllActiveChannel: vector, all active channel the user set when
% specifying probe design
% 2. SelectedActiveChannel: vector, all channel the user currently selected
% in the probe view window
% 3. Type: char, either 'Spikes' or someting else, 'Spikes' for spike analysis 

% Output Arguments:
% 1. DataChannel: vector, contains selected data channel indices 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Delete_All_Open_Windows.m
%________________________________________________________________________________________
%% Function to close all related app widows when app is closed or new data is loaded

% Input Arguments:
% 1. app: main app window object containing all app windows as property (or empty if not opened)
% 2. DeleteProbeView: double, 1 or 0, specify whether the probe window is
% supposed to be closed

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Delete_Dataset_Components.m
%________________________________________________________________________________________

%% Function to delete a specific field of the Data structure. 

% Gets called in the Manage dataset components window when the user clicks
% the 'Delete Dataset Component' Button

% Inputs:
% 1. Data: Data structure with Data.Raw or Data.Preprocessed, Data.Spikes
% and so on as well as Data.Info for information about data.
% 2: ComponentToDelete: string, determines which part of the dataset should
% be deleted, otions: 
%"Spikes" OR "EventRelatedSpikes" OR "EventRelatedData" OR "Events" OR "Preprocessed" OR "Raw" Or "PreprocessedEventRelatedData"

% Output:
% 1. Data: main window data structure
% 2. Error: 1 if no data would be left after deleting, 0 if otherwise; If 1,
% deletion is not executed

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Export_Components_to_WorkSpace.m
%________________________________________________________________________________________

%% This function exports a component of the main window data structure to the matlab workspace

% Input:
% 1. Data: main window data structure
% 2. Component: string specifying the name of the dataset component to
% export; see below for options
% 3. ExecutedInGUI: double, 1 or 0 whether it is executed in GUI (1) or not
% (0)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Initialize_GUI.m
%________________________________________________________________________________________

%% Function to Organize all basic mainapp values, properties, app parts and variables. 
% This function is called all over the toolbox to initiate and organize app
% windows and datasets

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
% 3. Data: Data structure of the main window
% 4. HeaderInfo: Infos about recording extracted from raw datasets. Gets
% fused with Data.Info when Type = "VariableDefinition"
% 5. SampleRate in Hz as double when Type = "VariableDefinition"
% 6. SelectedFolder: Folder from which data was exracted or loaded from, as char
% only applicable when Type = "VariableDefinition"
% 7. RecordingType: string specifying the recording system when Type =
%"Extracting", Options: "IntanDat", "IntanRHD", "Spike2", "Open Ephys"
% 8. PreviousChannelDeletetion: not needed anymore!!
% 9. Time: double array with time point for each value of the raw dataset. Becomes app.Data.Time when Type = "VariableDefinition"
% 10. Load_Data_Window_Info: structure holding probe info like
% channelspacing or nrchannel

% Output:
% 1. app: object with initialized values

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
% 3. TimeLimit: Max Time in seconds to determine whether jump violates time
% limits. (app.Data.Time(end)) as double
% 4. TimeRange: Time to jump, as double in seconds
% 5. SampleRate in Hz as double

% Output:
% app object with updated app.CurrentTimePoints value capturing the first time
% point of the main window plot that is shown (in samples)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Plot_Trigger_Indices.m
%________________________________________________________________________________________

%% Function to plot event related data around trigger

% This function is called in the Trigger Deletion Window to plot data
% around each selected trigger.


% Inputs: 
% 1. Data: main app object holding all main dataset components
% 2. Figure: app.UIAxes object handle from app to plot in
% 3. EventToPlot: double, trigger number selected to plot (except mean was selected)
% 4. Time: double vector with time plotted around events, specified in the
% app window
% 5. ActiveChannel: double vector with all currently active channel from
% the probe view window
% 6. EventstoPlotDropDown: char, from event to plot dropdown, to check if it is "Mean over all Trigger" 
% 7. SpacingSlider: double, spacing selected in the slider of the app
% window
% 8. EventTriggerChannel: Name of the event channel from which trigger are
% extracted, from Info.EventChannelNames
% 9. TimearoundEvent: 1x2 double with time around event (before and after trigger, both positive)
% DataToExtractFromDropDown: char, either 'Raw Data' or 'Preprocessed
% Data', depending from which dataset channel data is extracted
% DataSourceDropDown: char, either 'Raw Event Related Data' or 'Preprocessed Event Related Data'
% ColorMap: nchannel x 3 parula color map

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
% time plot to show new data. This includes spikes and event data. 

% Inputs: 
% 1. app: app object of GUI main window
% 2. PlotTime: 1 or 0, specifying whether time plot should be updated
% 3. TimePlotInitial: string specifying if time plot is hard-resetted. So far only
% Otions: "Initial" (hard reset) or "subsequent"
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

File: Organize_Reset_Main_Plot.m
%________________________________________________________________________________________

%% Function to reset the data and/or time plot of the main window 

% This function gets called whenever data is extracted/changed that might be shown
% in the main window like events and spikes and preprocessing as well as
% when new data is loaded or the user selects the reset plots button. It
% ensures proper colormap, variable reset and callback initiation

% Input:
% 1. app: app object of the extract data window to access the
% Load_Data_Window_Info variable which holds the loaded channel order and
% channelspacing 
% 2. DeleteChannelData: Hard reset of data plot; double, 1 or 0, determines whether main data plot
%channeldata is deleted. Can be set to 0 if only event or spike data
%changes
% 4: KeepEvents: double, 1 or 0, determines whether events lines should continue to be shown
% when they were already selected - set 1 when spikes are extracted to keep
% event line plots, set to 0 to delete event line plots
% 5: KeepSpikes: double, 1 or 0, determines whether spikes should continue to be shown
% when they were already selected - set 1 when events are extracted to keep
% spike plots, set to 0 to delete spike plots
% 6: ReplaceDataType: double, 1 or 0, set to 1 the set plotted datatype to
% 'Raw Data', otherwise userselection is not changed
% 8: PlotTime: number of samples time plot currently is set to

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Set_MainWindow_Dropdown.m
%________________________________________________________________________________________

%% Function to reset the dropwdonw menu of the main app window enabling to select events or spikes and raw/preprocessed data as well as event channel names

% This function gets called whenever dataset components are changed 

% Input:
% 1. app: Main window app object
% 2. Data: Main object data stuccture with all relevant data components

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Set_MainWindow_TimeRange.m
%________________________________________________________________________________________

%% Function to increase or decrease the amopunt of time plotted in the main window
% This function is called when the user clicks on the + or - button in the
% time control panel of the main window to change the amount of time shown.
% The amount the time range is changed by is based on the checkboxes of the
% time control panel

%NOTE: app.TimeSpanControlDropDown are the check box fields in the GUI time control
%specifying the amount of data to plot

% Inputs: 
% 1. app: app object of GUI main window
% 2. CurrentTimeRange: Time in seconds (double) the plot is currently
% showing and gets is increased/decreased
% 3. TimeLimit: 1x2 double vetor with min and max time in seconds the plot
% is allowed to show.
% 4. Operation: Specifies whether time is increased or decreased, Either
% "Plus" OR "Minus"
% 5. event: event strcuture from callback, used to get previousvalue

% Output:
% app object with updated app.CurrentTimePoints value capturing the first time
% point of the main window plot that is shown (in samples)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Organize_Set_Standard_PlotAppearance.m
%________________________________________________________________________________________

%% Function to set the standrad appearance settings of each plot.  
% This function hard codes standard plot appearances. It is called when no
% .m file is saved in GUI_Path/Modules/MISC/Variables (do not edit!) to
% create a new PlotAppearance.m file. This file is overwritten when the
% user saves a new custom plot appearance and loaded when NeuroMod is
% started again. If new components are added, the PlotAppearance.m file in
% Modules/Misc/Variables has to be deleted!

% Inputs
% 1. Type: string, Specifies what settings to reset to standard. "All" to
% reset all appearances OR "MainDataPlot" OR "MainTimePlot" OR
% "SpectrumPlot" to reet window specific plot settings.
% 2. PlotAppearance: strcuture holding all appearances.

% Outputs
% 1. PlotAppearance: strcuture holding all appearances.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

