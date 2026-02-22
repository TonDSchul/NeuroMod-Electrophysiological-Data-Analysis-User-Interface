This folder contains the following functions with respective Header:

 ###################################################### 

File: Utility_Check_Saved_Spike_PlotData.m
%________________________________________________________________________________________

%% This function checks what kind of spike data the user wants to save and gives warnings/messages how/what/what is not possible

% Input:
% 1. PlottedData: struc with saved data from plot to export
% 2. Analysis: string specifying the name of the analysis the user wants to
% export

% Output:
% 1. Error: double, 1 or 0 whether an error occured

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
% 5. ExecuteOutsideGUI: double 1 or 0, if executed outside of gui use 1

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Export_Dataset_Components_as_TXT.m
%________________________________________________________________________________________

%% This function exports dataset components, i.e. app.Data field structures as a .txt file

% Input:
% 1. Data: struc with main window data
% 2. Component: char, dataset component to extract. "Info" OR "Events" OR "Spikes" OR "Time" OR "TimeDownsampled"
% 3. Format: not necessary anymore but preserverd -- ToDO
% 4. SaveFolder: not necessary anymore but preserverd -- ToDO
% 5. Fullsavefile: path to save data in (with filename and ending)
% 6. ExecuteOutsideGUI: double, 1 or 0 whether called in GUI or
% outside of GUI in Autorun/batch analysis

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Utility_Export_Dataset_Components_as_XLSX.m
%________________________________________________________________________________________

%% This function exports dataset components, i.e. app.Data field structures as a .xlsx file

% Input:
% 1. Data: struc with main window data
% 2. Component: char, dataset component to extract. "Info" OR "Events" OR "Spikes" OR "Time" OR "TimeDownsampled"
% 3. Format: not necessary anymore but preserverd -- ToDO
% 4. SaveFolder: not necessary anymore but preserverd -- ToDO
% 5. Fullsavefile: path to save data in (with filename and ending)
% 6. ExecuteOutsideGUI: double, 1 or 0 whether called in GUI or
% outside of GUI in Autorun/batch analysis

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
% 8. ExecutedOutsideGUI: double, 1 or 0. Determines savepath (in Matlab folder) and whether
% messages are shown as msgbox (1 means executed in autorun or outside of gui)

% Output Arguments:
% 1. PlottedData: structure holding data that was plotted in case something
% about it was changed

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
%% Function to export plotted/Analyzed data as .txt file
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

File: Utility_Save_Data_as_xlsx.m
%________________________________________________________________________________________
%% Function to export plotted/Analyzed data as .xlsx file
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

File: Utility_Save_xlsx_Set_VariableNames.m
%________________________________________________________________________________________

%% This function puts x,y, and xtick data that is supposed to be exported in a table to save in a .xlsx file

% Input:
% 1. PlottedData: struc with info about data to be exported (which is the
% same as plotted data, therefore the name)
% 2. Analysis: char, kind of analysis for which data is exported. sets
% header name of each table row
% 3. XData: double vector with x data to be exported
% 4. YData: double vector with y data to be exported
% 5. XTick: cell array with each cell holding a char representing one xtick
% label


% Output: 
% 1. folderPath: char, path the user selected to save in

%% Note: searches for Meta_Data.json, probe.json and the channel data bin file

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

