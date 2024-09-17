______________________________________________
NeuroMod Toolbox; Manage Dataset Module README
Author: Tony de Schultz
______________________________________________

IMPORTANT: All functions are desinged in a way that you can also use them outside the GUI. You just have to specify the parameters of the app window manually. See AutorunConfig variable in the Autonrun_Config files.
The following workflows stem from the GUI. What is used outisde the GUI is specified. Also see Atourun Module to see use outside of GUI-


Neuralynx and Plexon data extraction is handled by fieldtrip, see: https://github.com/fieldtrip/fieldtrip. In the data extraction window the ft_read_header and ft_read_data functions are called with the folder and file the user selected.

For Open Ephys data formats the Open Ephys Analysis Tools are used, see: https://github.com/open-ephys/open-ephys-matlab-tools/tree/main. They are implemented and called through a costum compatibility function called 'Open_Ephys_Load_All_Formats.m'

For Spike2 Analysis, the user is required to install the Spike2 MATLAB SON Interface from: https://ced.co.uk/upgrades/spike2matson

For Extraction of Intan recordings, the Intan_RHD2000_Data_Extraction function is used. It originally stems from Intan under: https://intantech.com/downloads.html?tabSelect=Software&yPos=0
used are the RHD/RHS File Utilities, Matlab File Readers. NOTE: This function was heavily modified to fit the prupose of this GUI!

Since all files except those from fieldtrip are modified OR require compatibility functions, updating the toolboxes will very probably lead to errors!

Each folder in this module contains one (or more) app windows for the respective functionality as well as a folder called "Functions" with all main functions necessary for this module 
(NOTE 1: can also require utility fucctions forom the "1. Main_Window_Functions" folder).
NOTE 2: If multiple app windows: One is always the main window, the others are just of supportive nature. 

__________________________
GUI Workflow Loading Data:
[app.Mainapp] = Organize_Initialize_GUI (app.Mainapp,"Initial"); -- not used outside of GUI

[app.Mainapp.Data] = Manage_Dataset_Module_LoadData(Format,FullPathData,FullPathInfo,app.TextArea);

if ~isempty(app.Mainapp.Data)
    [app.Mainapp] = Organize_Initialize_GUI (app.Mainapp,"Loading"); -- not used outside of GUI
else
    return;
end

Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp,1,"Initial","Static",app.Mainapp.PlotEvents,app.Mainapp.Plotspikes); -- not used in autorun config

__________________________
GUI Workflow Saving Data:
% Side Note: Whattosave is a 1x6 double vector, each elemt stands for a data component. 1 means its saved, 0 means its not
[filepath,Error] = Manage_Dataset_Module_SaveData(app.Mainapp.Data,app.SaveTypeDropDown.Value,app.Whattosave,app.Mainapp.executableFolder,"No");

__________________________         
GUI Workflow Extracting Raw Data:

[app.Load_Data_Window_Info.Mainapp] = Organize_Initialize_GUI (app.Load_Data_Window_Info.Mainapp,"Initial"); -- not used outside of GUI

%% Extract Data
[Data,HeaderInfo,SampleRate,RecordingType,Time] = Manage_Dataset_Module_Extract_Raw_Recording_Main(app.RecordingSystemDropDown.Value,app.FileTypeDropDown.Value,app.Load_Data_Window_Info.selectedFolder,app.TextArea,app.Load_Data_Window_Info.Mainapp.executableFolder);

%% Apply/save Header Infos

[app.Load_Data_Window_Info.Mainapp] = Organize_Initialize_GUI (app.Load_Data_Window_Info.Mainapp,"VariableDefinition",Data,HeaderInfo,SampleRate,app.Load_Data_Window_Info.selectedFolder,RecordingType,0,Time,app.Load_Data_Window_Info.ChannelSpacing); -- not used outside of GUI

%% Apply ChannelOrder

if ~isempty(app.Load_Data_Window_Info.Channelorder)
    [app.Load_Data_Window_Info.Mainapp.Data] = Manage_Dataset_Module_Apply_ChannelOrder (app.Load_Data_Window_Info.Mainapp.Data,app.Load_Data_Window_Info.Channelorder);
end

%% Initialize Infos for Main Window based on extracted and saved variables (previous call of this function)
[app.Load_Data_Window_Info.Mainapp] = Organize_Initialize_GUI (app.Load_Data_Window_Info.Mainapp,"Extracting"); -- not used outside of GUI

Organize_Prepare_Plot_and_Extract_GUI_Info(app.Load_Data_Window_Info.Mainapp,1,"Initial","Static",app.Load_Data_Window_Info.Mainapp.PlotEvents,app.Load_Data_Window_Info.Mainapp.Plotspikes); -- not used outside of GUI
            