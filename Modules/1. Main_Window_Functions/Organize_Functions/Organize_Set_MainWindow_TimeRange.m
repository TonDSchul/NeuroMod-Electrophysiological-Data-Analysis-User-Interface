function Organize_Set_MainWindow_TimeRange(app,CurrentTimeRange,TimeLimit,Operation,event)

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

% Output:
% app object with updated app.CurrentTimePoints value capturing the first time
% point of the main window plot that is shown (in samples)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if strcmp(Operation,"NewTimeRange") % When time range editfield was changed

    if ~contains(app.TimeRangeViewBox.Value,'s')
        msgbox("Wrong Format! Please enter a number followed by a 's'")
        if isprop(event,'PreviousValue')
            if contains(app.TimeRangeViewBox.Value,'s')
                sindicie = find(app.TimeRangeViewBox.Value=='s');
                
                rest = app.TimeRangeViewBox.Value(sindicie:end);

                if isscalar(rest)
                    app.TimeRangeViewBox.Value = event.PreviousValue;
                else
                    app.TimeRangeViewBox.Value = '1s';
                end
            else
                app.TimeRangeViewBox.Value = '1s';
            end
        else
            app.TimeRangeViewBox.Value = '1s';
        end
    end
    
    sindicie = find(app.TimeRangeViewBox.Value=='s');
    number = str2double(app.TimeRangeViewBox.Value(1:sindicie-1));
    
    rest = app.TimeRangeViewBox.Value(sindicie:end);
    if length(rest)>1
        msgbox("Wrong Format! Please enter a number followed by a 's'")
        app.TimeRangeViewBox.Value = event.PreviousValue;
        return
    end

    if strcmp(app.DropDown.Value,"Preprocessed Data")
        if isfield(app.Data.Info,'DownsampleFactor')
            if app.CurrentTimePoints+(round(number*app.Data.Info.DownsampledSampleRate)) <= length(app.Data.Time)
                
            else 
                disp("Time window with new settings would exceed max time. Adjusted time window accordingly")
                Difference = length(app.Data.Time)-app.CurrentTimePoints;
                secs = num2str(floor(Difference/app.Data.Info.DownsampledSampleRate));
                app.TimeRangeViewBox.Value = strcat(secs,'s');
            end
        else
            if app.CurrentTimePoints+(round(number*app.Data.Info.NativeSamplingRate)) <= length(app.Data.Time)
            else
                disp("Time window with new settings would exceed max time. Adjusted time window accordingly")
                Difference = (length(app.Data.Time)-app.CurrentTimePoints);
                secs = num2str(floor(Difference/app.Data.Info.NativeSamplingRate));
                app.TimeRangeViewBox.Value = strcat(secs,'s');
            end
        end
    else
        if app.CurrentTimePoints+(round(number*app.Data.Info.NativeSamplingRate)) <= length(app.Data.Time)
           
        else
            disp("Time window with new settings would exceed max time. Adjusted time window accordingly")
            Difference = length(app.Data.Time)-app.CurrentTimePoints;
            secs = num2str(floor(Difference/app.Data.Info.NativeSamplingRate));
            app.TimeRangeViewBox.Value = strcat(secs,'s');
        end
    end
end

if strcmp(Operation,"Plus") || strcmp(Operation,"Minus")
    NewTimeRange = [];
    
    if strcmp(app.TimeSpanControlDropDown.Value,'0.1s')
        if strcmp(Operation,"Plus")
            if CurrentTimeRange + 0.1 <= TimeLimit(2)
                NewTimeRange = CurrentTimeRange + 0.1;
            end
        elseif strcmp(Operation,"Minus")
            if CurrentTimeRange - 0.1 >= TimeLimit(1)
                NewTimeRange = CurrentTimeRange - 0.1;
            end
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.5s')
        if strcmp(Operation,"Plus")
            if CurrentTimeRange + 0.5 <= TimeLimit(2)
                NewTimeRange = CurrentTimeRange + 0.5;
            end
        elseif strcmp(Operation,"Minus")
            if CurrentTimeRange - 0.5 >= TimeLimit(1)
                NewTimeRange = CurrentTimeRange - 0.5;
            end
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'1s')
        if strcmp(Operation,"Plus")
            if CurrentTimeRange + 1 <= TimeLimit(2)
                NewTimeRange = CurrentTimeRange + 1;
            end
        elseif strcmp(Operation,"Minus")
            if CurrentTimeRange - 1 >= TimeLimit(1)
                NewTimeRange = CurrentTimeRange - 1;
            end
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.01s')
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

    secs = NewTimeRange;

    if secs ~= 0
        if strcmp(app.DropDown.Value,"Preprocessed Data")
            if isfield(app.Data.Info,'DownsampleFactor')
                if app.CurrentTimePoints+(round(NewTimeRange*app.Data.Info.DownsampledSampleRate)) <= length(app.Data.Time)
                else 
                    disp("Time window with new settings would exceed max time. Adjusted time window accordingly")
                    Difference = length(app.Data.Time)-app.CurrentTimePoints;
                    secs = num2str(floor(Difference/app.Data.Info.DownsampledSampleRate));
                end
            else
                if app.CurrentTimePoints+(round(NewTimeRange*app.Data.Info.NativeSamplingRate)) <= length(app.Data.Time)
                else
                    disp("Time window with new settings would exceed max time. Adjusted time window accordingly")
                    Difference = (length(app.Data.Time)-app.CurrentTimePoints);
                    secs = num2str(floor(Difference/app.Data.Info.NativeSamplingRate));
                end
            end
        else
            if app.CurrentTimePoints+(round(NewTimeRange*app.Data.Info.NativeSamplingRate)) <= length(app.Data.Time)
            else
                disp("Time window with new settings would exceed max time. Adjusted time window accordingly")
                Difference = length(app.Data.Time)-app.CurrentTimePoints;
                secs = num2str(floor(Difference/app.Data.Info.NativeSamplingRate));
            end
        end
        
        if ~isempty(secs)
            app.TimeRangeViewBox.Value = strcat(num2str(secs),'s');
        else
            return;
        end
    end

end