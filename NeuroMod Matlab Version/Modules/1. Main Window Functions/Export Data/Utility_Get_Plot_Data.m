function PlottedData = Utility_Get_Plot_Data(PlottedData,Data,Format,executableFolder,TimeRangeLiveWindows,StartTime,AnalysisType)
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

% Output Arguments:
% 1. PlottedData: structure holding data that was plotted in case something
% about it was changed

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Error = 0;

PlottedData.TimeDuration = TimeRangeLiveWindows;
PlottedData.Time_Points_Plot = [StartTime,StartTime+TimeRangeLiveWindows];
PlottedData.Info = Data.Info;

%% Save Path
current_time = char(datetime('now'));
current_time(current_time==':') = '_';
current_time(current_time==' ') = '_';

SaveFolder = strcat(executableFolder,"\Analysis Results\");
dashindex = find(Data.Info.Data_Path=='\');

% if strcmp(Format,'.csv')
%     Format = '.xlsx';
% end

Savefile = strcat(Data.Info.Data_Path(dashindex(end)+1:end),"_",AnalysisType,"_",current_time,"_",Format);

if isfolder(SaveFolder)
    Fullsavefile = fullfile(SaveFolder,Savefile);
else
    msgbox("Please select a folder to save the results in.")
    % Prompt user to select a folder
    filetype = strcat('*',Format);
    [filename, filepath] = uiputfile(filetype, 'Save as');
    
    % Check if the user canceled the dialog
    if isequal(filename,0) || isequal(filepath,0)
        disp('User canceled folder selection.');
        return;
    else
        Fullsavefile = fullfile(filepath,filename);
        disp(['Selected folder: ', Fullsavefile]);
    end
end

%% Save Data

if strcmp(Format,'.mat')
    Error = Utility_Save_Data_as_MAT(Fullsavefile,PlottedData,AnalysisType);
elseif strcmp(Format,'.txt') || strcmp(Format,'.csv')
    Error = Utility_Save_Data_as_TXT_CSV(Fullsavefile,PlottedData,AnalysisType);
elseif strcmp(Format,'.xlsx')
    Error = Utility_Save_Data_as_xlsx(Fullsavefile,PlottedData,AnalysisType);
end

if Error == 0
    msgbox(strcat("Data was succesfully exported to: ",Fullsavefile))
end