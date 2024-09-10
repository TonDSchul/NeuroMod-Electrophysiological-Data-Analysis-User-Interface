function PlottedData = Utility_Get_Plot_Data(Data,Figure,Format,executableFolder,TimeRangeLiveWindows,StartTime,AnalysisType)

% Get all children of the Figure (these will be the plotted data objects)
plotObjects = Figure.Children;

% Initialize an empty cell array to hold the data
PlottedData = cell(length(plotObjects), 1);

% Loop through each plot object
for i = 1:length(plotObjects)
    obj = plotObjects(i);
    
    % Check if the plot is 2D or 3D by checking the existence of ZData
    if isprop(obj, 'ZData') && ~isempty(obj.ZData)
        % 3D Plot (Surface, etc.)
        PlottedData{i}.XData = obj.XData;
        PlottedData{i}.YData = obj.YData;
        PlottedData{i}.ZData = obj.ZData;
        if isprop(obj, 'CData') % Surface plots may have CData
            PlottedData{i}.CData = obj.CData;
        end
    else
        % 2D Plot (Line, etc.)
        PlottedData{i}.XData = obj.XData;
        PlottedData{i}.YData = obj.YData;
        % No ZData for 2D plots, CData for color, if applicable
        if isprop(obj, 'CData')
            PlottedData{i}.CData = obj.CData;
        end
    end

    PlottedData{i}.TimeDuration = TimeRangeLiveWindows;
    PlottedData{i}.Time_Points_Plot = [StartTime,StartTime+TimeRangeLiveWindows];
end

if strcmp(AnalysisType,"Event_CSD") || strcmp(AnalysisType,"Event_Time_Frequency") || strcmp(AnalysisType,"Event_ERP")
    PlottedData(1) = []; 
end

%% Save Path
current_time = char(datetime('now'));
current_time(current_time==':') = '_';
current_time(current_time==' ') = '_';

SaveFolder = strcat(executableFolder,"\Analysis Results\");
dashindex = find(Data.Info.Data_Path=='\');

Savefile = strcat(Data.Info.Data_Path(dashindex(end)+1:end),"_",AnalysisType,"_Time_",current_time,"_",Format);

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
    save(Fullsavefile,"PlottedData");
    disp(strcat("Data succesfully saved in: ",Fullsavefile));
elseif strcmp(Format,'.txt') 
    % Extract XTick labels and positions
    xtickLabels = Figure.XTickLabel;
    %xtick = Figure.XTick;

    Utility_Save_Data_as_TXT(Fullsavefile,PlottedData,xtickLabels);
    
elseif strcmp(Format,'.csv')
    xtickLabels = Figure.XTickLabel;

    Utility_Save_Data_as_CSV(Fullsavefile,PlottedData,xtickLabels);

elseif strcmp(Format,'.xlsx')
    xtickLabels = Figure.XTickLabel;

    %Utility_Save_Data_as_CSV(Fullsavefile,PlottedData,xtickLabels);
    Utility_Save_Data_as_Excel(Fullsavefile,PlottedData,xtickLabels)
end