function PlottedData = Utility_Get_Plot_Data(PlottedData,Data,Format,executableFolder,TimeRangeLiveWindows,StartTime,AnalysisType)

PlottedData.TimeDuration = TimeRangeLiveWindows;
PlottedData.Time_Points_Plot = [StartTime,StartTime+TimeRangeLiveWindows];
PlottedData.Info = Data.Info;

%% Save Path
current_time = char(datetime('now'));
current_time(current_time==':') = '_';
current_time(current_time==' ') = '_';

SaveFolder = strcat(executableFolder,"\Analysis Results\");
dashindex = find(Data.Info.Data_Path=='\');

Savefile = strcat(Data.Info.Data_Path(dashindex(end)+1:end),"_",AnalysisType,"_",current_time,"_",Format);

if isfolder(SaveFolder)
    Fullsavefile = fullfile(SaveFolder,Savefile);
else
    msgbox("Please select a folder to save the results in.")
    % Prompt user to select a folder
    Fullsavefile = uigetdir;
    
    % Check if the user canceled the dialog
    if Fullsavefile == 0
        disp('User canceled folder selection.');
        return;
    else
        disp(['Selected folder: ', Fullsavefile]);
    end
end

%% Save Data

if strcmp(Format,'.mat')
    Error = Utility_Save_Data_as_MAT(Fullsavefile,PlottedData,AnalysisType);
elseif strcmp(Format,'.txt') || strcmp(Format,'.csv')
    Error = Utility_Save_Data_as_TXT_CSV(Fullsavefile,PlottedData,AnalysisType);
end

if Error == 0
    msgbox(strcat("Data was succesfully exported to: ",Fullsavefile))
end