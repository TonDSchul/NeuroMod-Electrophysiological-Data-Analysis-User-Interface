This folder contains the following functions with respective Header:

 ###################################################### 

File: LineClicked.m
%________________________________________________________________________________________
%% Function to Handle Case that user clicks at a plotted line in the main window data plot to display channel name
% This function handles displaying a channel name in the main plot when the
% user clicks on a polotted line in the main plot. This has for some reason to be handled by a different callback function
% than clicking on a empty part of the plot. This function is called within
% the callback specified in the Utility_Initialize_Clicks_Plots function
% which gets called every time smt is plotted.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking containing x and y corrdinates, where the user clicked. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: LineClickedTime.m
%________________________________________________________________________________________
%% Function to Handle Case that user clicks at a plotted line in the main window time plot to switch displayed time
% This has for some reason to be handled by a different callback function
% than clicking on a empty part of the plot. This function is called within
% the callback specified in the Utility_Initialize_Clicks_Plots function,
% which is executed every time the plots get changed when the user clicks on some point of the time plot.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking containing x and y corrdinates, where the user clicked. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Menu_Extract_Data_Callback.m
%________________________________________________________________________________________

%% This is the callback function executed when the user clicks on a saved probe information in the 'Load Save Probe Information menu on top of the 'Extract Data Window'

% This fucntion is executed for every possible menu option shown and initiated in the Extract Data Window. The name of the selected menu is
% saved in the 'fileNames' variable.

% Input:
% 1. app: app object of the extract data window to access the
% Load_Data_Window_Info variable which holds the loaded channel order and
% channelspacing 
% 2. fileNames: string, name of the menu point the user clicked on (with a -mat at the end, equals savefilename)
% 3. DefaultFolder: char, default folder saving costume probe information:
% GUI_Path/Channel Maps/Saved Probe Information


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Menu_Extract_Data_Load_Manually_Callback.m
%________________________________________________________________________________________

%% This is the callback function executed when the user clicks on laoding a probe design manually (selecting folder themselves)

% This fucntion is executed when the user clicks on the Manually Select
% File menu option in the Extract Data Window

% Input:
% 1. app: app object of the extract data window to access the
% Load_Data_Window_Info variable which holds the loaded channel order and
% channelspacing 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: UIAxesButtonDown.m
%________________________________________________________________________________________
%% Callback Function that handles a click on the data plot and displays a corresponding channel
% This function captures the event when the user clicks on a plot. The
% event contains x and y coordinateds of the click in the event structure.
% It then searches for the closest available y value in the data matrix
% plotted to the y coordinate of the data plot the user clicked on.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: UIAxes_2ButtonDown.m
%________________________________________________________________________________________
%% Callback Function that handles a click on the time plot
% This function captures the event when the user clicks on a plot. The
% event contains x and y coordinateds of the click in the event structure.
% It then searches for the closest available time point in the time vector
% to the x coordinate of the time plot the user clicked on.

% Input Arguments:
% 1. app: app object of main window
% 2. event: Event handle of clicking. This is set up and initialized in the
% Utility_Initialize_Clicks_Plots

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_CreateChannelNames.m
%________________________________________________________________________________________
%% Function to create standard channel names (Channel1, Channel2 and so on)
% This function gets called for example to display the create channel names when the
% user clicks on the data plot of the main window

% Input Arguments:
% 1. app: app object with fields 'Data.Raw' needed for max channel nr

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Delete_Units.m
%________________________________________________________________________________________
%% Function to delete all spike information of a selected unit 

% This function gets called in the Unit Analysis window when the user
% clicks on the 'Delete Unit' Button

% Input Arguments:
% 1. Data: main window structure holding dataset (including spike data as Data.Spikes)
% 2. UnitToDelete: char, has to start with 'Unit' followed by a space
% and a number, i.e. 'Unit 10' -- space is important!

% Output Arguments:
% 1. Data: main window structure holding dataset with deleted spikes of the
% selected unit

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Export_Dataset_Components.m
%________________________________________________________________________________________
%% Function to export some dataset components as txt,csv or .mat
% This function gets called in the Export Dataset Components Window when
% the user clicks the "Export" button

% NOTE: At standard the folder to save dataset components in is:
% Data_to_GUI\Analysis_Results

% NOTE: To export Raw and Preprocessed data, use the save dataset function.
% This saves the raw and/or preprocessed data as a .dat file which is faster and easier on memory.
% Also prevents .txt or csv files from not being readable due to to much data.

% Input Arguments:
% 1. Data: main window structure holding dataset components (i.e. Data.Events, Data.Spikes ...)
% 2. Component: Selected dataset component as string, i.e. "Events" or "Spikes"
% 3. Format: Format to save data in, as string, ".mat" OR ".txt" OR ".csv"
% 4. executableFolder_ Path to GUI currently executed as char (created on startup of Main Window)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Extract_Contents_of_Folder.m
%________________________________________________________________________________________
%% Function to extract all contents of a selcted folder and output them in a string array for easy use
% This function gets called for example whenever the user makes a folder
% selection and the contents are checked for a proper recording format or
% the contents are shown in a textarea of a gui window

% Input Arguments:
% 1. Path: Path to the folder as char

% Output Arguments:
% 1. stringArray: Contens of folder in a n x 1 string array with n being
% the number of contents

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Extract_Function_Headers_to_txt.m
%________________________________________________________________________________________
%% Function to search for all function headers in all .m files of a folder and save in a txt. file
% This function can be used to automatically create a README file in each
% folder containing the function headers of each function

% Input Arguments:
% 1. folderPath: Path to the folder holding .m files as char
% 2. outputFileName: Name of the .txt file to save the header infos in (including the .txt file ending)

% Output Arguments:
% 1. stringArray: Contens of folder in a n x 1 string array with n being
% the number of contents

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Get_Plot_Data.m
%________________________________________________________________________________________
%% Function to export plotted/analysed data from each window with the menu option to do so
% This function gets called in all analysis windows with the option to
% export the analysed data when the user wants to export

% PlottedData is a structure holding all analysis results. It is filled in
% the functions computing the plotted data directly and is shared across
% all windows (Main window property). 

% NOTE: Spike Analysis, Main Window Analysis and LFP Analysis all create new fieldnames and are
% therefore saved seperately. This means that for example data from the continous spike
% analysis is overwritten when event related spike analysis is computed.

% Input Arguments:
% 1. PlottedData: structure holding data that was plotted. Spike Analysis,
% Main Window Analysis and LFP Analysis all create new fieldnames and are
% therefore saved seperately.
% 2. Data: Data structure from main window
% 3. Format: Format to save data in, as string, ".mat" OR ".txt" OR ".csv"
% 4. executableFolder_ Path to GUI currently executed as char (created on startup of Main Window)
% 5. TimeRangeLiveWindows: double, Time duration in seconds of analysis window
% 6. StartTime: double, Start time of window analysis (for main window plots its the satrt of the main data plot in the main window, otherwise 0 or negative for event related stuff)
% 7: AnalysisType: string specifying the name of the analysis. This has to
% obey some rules! For Unit analysis, it has to cointain the string "Unit".
% For Spike analyis it has to contain "Spike" or "Spikes"
% For Time Frequency power it has to contain the string "Phase"
% For CSD and ERP anylsis it has to contain the string "Current" or
% "Potential" and so on. See Utility_Save_Data_as_TXT_CSV and
% Utility_Save_Data_as_MAT functions

% Outout Arguments:
% 1. PlottedData: structure holding data that was plotted in case something
% about it was changed

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Initialize_Clicks_Plots.m
%________________________________________________________________________________________
%% Function to initilaze click functionality of plots
% This function gets called whenever something new is plotted in the main
% window to initiate the UIAxesButtonDown callcbacks that capture the x and
% y corrdinate of a point being clicked.

% UIAxesButtonDown and LineClicked = main window data plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)
% UIAxes_2ButtonDown and LineClickedTime = maine window time plot (buttondown when clicking on empty space of plot, lineclicked when clicking on a data line)

% Input Arguments:
% 1. app: main window app object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Save_Data_as_MAT.m
%________________________________________________________________________________________
%% Function to export plotted/analysed data as .mat files
% This function gets called in the Utility_Get_Plot_Data function

% Input Arguments:
% 1. Fullsavefile: char, Pcomplete path to the .mat file to save data in (including the .mat file ending)
% 2. PlottedData: structure holding data that was plotted. Spike Analysis,
% Main Window Analysis and LFP Analysis all create new fieldnames and are
% therefore saved seperately.
% 3: Analysis: string specifying the name of the analysis. This has to
% obey some rules! For Unit analysis, it has to cointain the string "Unit".
% For Spike analyis it has to contain "Spike" or "Spikes"
% For Time Frequency power it has to contain the string "Phase"
% For CSD and ERP anylsis it has to contain the string "Current" or
% "Potential" and so on. See Utility_Save_Data_as_TXT_CSV and
% Utility_Save_Data_as_MAT functions

% Output Arguments: 
% 1. Error: 1 if an error occured, 0 if not. gets checked in Utility_Get_Plot_Data function

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Save_Data_as_TXT_CSV.m
%________________________________________________________________________________________
%% Function to export plotted/analysed data as .csv or .txt files
% This function gets called in the Utility_Get_Plot_Data function

% Input Arguments:
% 1. Fullsavefile: char, Pcomplete path to the .mat file to save data in (including the .mat file ending)
% 2. PlottedData: structure holding data that was plotted. Spike Analysis,
% Main Window Analysis and LFP Analysis all create new fieldnames and are
% therefore saved seperately.
% 3: Analysis: string specifying the name of the analysis. This has to
% obey some rules! For Unit analysis, it has to cointain the string "Unit".
% For Spike analyis it has to contain "Spike" or "Spikes"
% For Time Frequency power it has to contain the string "Phase"
% For CSD and ERP anylsis it has to contain the string "Current" or
% "Potential" and so on. See Utility_Save_Data_as_TXT_CSV and
% Utility_Save_Data_as_MAT functions

% Output Arguments: 
% 1. Error: 1 if an error occured, 0 if not. gets checked in Utility_Get_Plot_Data function

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Save_Load_Delete_Plot_Appearance.m
%________________________________________________________________________________________

%% Function to Manage saving, loading and deleting then plot appearance variable
% This function is called in any window the user can modify the plot
% appearance and saves the costum appearance or deletes previosuly saved
% costum appearances. It is also called in the Organize_Initialize_GUI.m
% function on startup of the GUI to load the costum/standard appearance (depending on whether user saved costum)

% Appearances saved in GUI_Path/Modules/MISC/Variables (do not edit!)
% PlotAppearance.m holds the costum appearance saved by the user
% Template_PlotAppearance.m holds the standard settings.
% If non was found (also no template), new template is created by calling
% Organize_Set_Standard_PlotAppearance. which hard codes all standrad
% appearances

% Inputs:
% 1. PlotAppearance: structure holding plot appearance
% 2. executableFolder: string, path to gui currently executed (created on GUI startup)
% 3. Type: string, specifies what do do here, Either "Save" OR "Load" OR "Delete"

% Output:
% app object with initialized values

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Set_ToolTips.m
%________________________________________________________________________________________
%% Function show or disable tooltips in all opened app windows.
% all app windows are saved as a property of the GUI main window

% Inputs:
% 1: app: main window app object
% 2: Activated: double, 1 or 0 whether to activate tooltips
% 3. Window: string, name of the window that opened and for which tooltips
% should be shwon or not

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Utility_Show_Info_Loaded_Data.m
%________________________________________________________________________________________
%% Function to show all contents of the Data.Info object in the textarea on the bottom left of the main window 
% This function gets called whenever Data.Info is modified to update the
% recording infomation textarea. It rearranges the Data.Info structure so
% that subfields get primary fields that can be shown as is and converts
% double values to strings

% Input Arguments:
% 1. app: main window app object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_SimpleCheckInputs.m
%________________________________________________________________________________________
%% Function to check whether user input into a field like the channelnr obeys format regulations
% This is the primarily used function to check inputs and corrects them
% when they violate format. It is used in most app windows were the user
% has to give input

% Input Arguments:
% 1. Input: input to be checked as char. I diretly pass the app.Button.Value
% 2. Type: string, options: "One" to chekc format of a single number, "Two"
% for two numbers seperated by a comma
% 3. StandardValues: char containing a value the original input gets
% replaced by when the format is violated
% 4, CompareToStandard: double, 1 or 0, 1 if compare to standarad value. If
% bigger it gets resetted
% 5. Negative: double, 1 or 0, 1 if negative values are expected, 0
% otherwise

% Output Arguments:
% 1. Corrected_Input: char with either the original input when its format
% is proper, char with standardvalue if format was violated

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_findClosestLineDatPlot.m
%________________________________________________________________________________________
%% Function to identify the closest line to the point in the plot the user clicked on
% This function gets called when the user clicks on the data plot to
% display the channel nr. For this, the y value of the clicked position
% has to be compared to the y values of the plotteded data lines. The Nr of data line
% closest to the clicked point is the channel nr to display

% Input Arguments:
% 1. app: app -- not needed ynamore but maybe useful for modifications
% 2. axis: handle to fugure the user clicked on (data plot in main window)
% 3. clickPoint: 1 x 3 double containing the x and y and z value of the point the
% user clicked on (z==0) -- can also be 1 x 2 with just x and y

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: updateUIAxesProperty.m
%________________________________________________________________________________________
%% Function responsible to change figure properties when the user right-clicks on a figure and inputs a new propertie value

% Input Arguments:
% 1. UIAxes: Axis handle of figure for which a property has to be changed
% 2. type: Type of property changed as string, like "xlim" or "ylim" (normal matlab commands)
% 3. value: the value the user inputted replacing the old peroperty value,
% as string

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

