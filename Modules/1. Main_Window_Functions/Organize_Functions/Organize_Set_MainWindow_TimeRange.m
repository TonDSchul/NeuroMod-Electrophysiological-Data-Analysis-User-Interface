function Organize_Set_MainWindow_TimeRange(app,CurrentTimeRange,TimeLimit,Operation)

%________________________________________________________________________________________

%% Function to increase or decrease the amopunt of time plotted in the main window
% This function is called when the user clicks on the + or - button in the
% time control panel of the main window to change the amount of time shown.
% The amount the time range is changed by is based on the checkboxes of the
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

NewTimeRange = [];

if app.sCheckBox.Value == 1
    if strcmp(Operation,"Plus")
        if CurrentTimeRange + 0.1 <= TimeLimit(2)
            NewTimeRange = CurrentTimeRange + 0.1;
        end
    elseif strcmp(Operation,"Minus")
        if CurrentTimeRange - 0.1 >= TimeLimit(1)
            NewTimeRange = CurrentTimeRange - 0.1;
        end
    end
elseif app.sCheckBox_2.Value == 1
    if strcmp(Operation,"Plus")
        if CurrentTimeRange + 0.5 <= TimeLimit(2)
            NewTimeRange = CurrentTimeRange + 0.5;
        end
    elseif strcmp(Operation,"Minus")
        if CurrentTimeRange - 0.5 >= TimeLimit(1)
            NewTimeRange = CurrentTimeRange - 0.5;
        end
    end
elseif app.sCheckBox_3.Value == 1
    if strcmp(Operation,"Plus")
        if CurrentTimeRange + 1 <= TimeLimit(2)
            NewTimeRange = CurrentTimeRange + 1;
        end
    elseif strcmp(Operation,"Minus")
        if CurrentTimeRange - 1 >= TimeLimit(1)
            NewTimeRange = CurrentTimeRange - 1;
        end
    end
elseif app.sCheckBox_4.Value == 1
    if strcmp(Operation,"Plus")
        if CurrentTimeRange + 0.01 <= TimeLimit(2)
            NewTimeRange = CurrentTimeRange + 0.01;
        end
    elseif strcmp(Operation,"Minus")
        if CurrentTimeRange - 0.01 >= TimeLimit(1)
            NewTimeRange = CurrentTimeRange - 0.01;
        end
    end
end

if ~isempty(NewTimeRange)
    app.TimeRangeViewBox.Value = strcat(num2str(NewTimeRange),"s");
else
    return;
end