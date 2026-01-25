function [app] = Organize_Jump_in_Time(app,Direction,TimeLimit,TimeRange,SampleRate)
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

if strcmp(Direction,"Forward")
   
    %% Add Sample Number from Timespan showm to update what data plot shows
    if strcmp(app.TimeSpanControlDropDown.Value,'0.001s') 
        if app.CurrentTimePoints+(round(0.001*SampleRate))+TimeRange <= TimeLimit
            app.CurrentTimePoints = app.CurrentTimePoints+round(0.001*SampleRate);
        elseif app.CurrentTimePoints+(round(0.001*SampleRate))+TimeRange > TimeLimit
            app.CurrentTimePoints = TimeLimit-(round(0.001*SampleRate));
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.01s') 
        if app.CurrentTimePoints+(round(0.01*SampleRate))+TimeRange <= TimeLimit
            app.CurrentTimePoints = app.CurrentTimePoints+round(0.01*SampleRate);
        elseif app.CurrentTimePoints+(round(0.01*SampleRate))+TimeRange > TimeLimit
            app.CurrentTimePoints = TimeLimit-(round(0.01*SampleRate));
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.1s') 
        if app.CurrentTimePoints+(round(0.1*SampleRate))+TimeRange <= TimeLimit
            app.CurrentTimePoints = app.CurrentTimePoints+round(0.1*SampleRate);
        elseif app.CurrentTimePoints+(round(0.1*SampleRate))+TimeRange > TimeLimit
            app.CurrentTimePoints = TimeLimit-(round(0.1*SampleRate));
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.5s') 
        if app.CurrentTimePoints+(round(0.5*SampleRate))+TimeRange <= TimeLimit
            app.CurrentTimePoints = app.CurrentTimePoints+round(0.5*SampleRate);
        elseif app.CurrentTimePoints+(round(0.5*SampleRate))+TimeRange > TimeLimit
            app.CurrentTimePoints = TimeLimit-(round(0.5*SampleRate));
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'1s') 
        if app.CurrentTimePoints+(round(1*SampleRate))+TimeRange <= TimeLimit
            app.CurrentTimePoints = app.CurrentTimePoints+round(1*SampleRate);
        elseif app.CurrentTimePoints+(round(1*SampleRate))+TimeRange > TimeLimit
            app.CurrentTimePoints = TimeLimit-(round(1*SampleRate));
        end
    else % if smt else
        TimeSelected = str2double(app.TimeSpanControlDropDown.Value(1:end-1));
        if app.CurrentTimePoints+(round(TimeSelected*SampleRate))+TimeRange <= TimeLimit
            app.CurrentTimePoints = app.CurrentTimePoints+round(TimeSelected*SampleRate);
        elseif app.CurrentTimePoints+(round(TimeSelected*SampleRate))+TimeRange > TimeLimit
            app.CurrentTimePoints = TimeLimit-(round(TimeSelected*SampleRate));
        end
    end

elseif strcmp(Direction,"Backwards")
    if strcmp(app.TimeSpanControlDropDown.Value,'0.001s') 
        if app.CurrentTimePoints-round(0.001*SampleRate) >= 1
            app.CurrentTimePoints = app.CurrentTimePoints-round(0.001*SampleRate);
        elseif app.CurrentTimePoints-round(0.001*SampleRate) < 1
            app.CurrentTimePoints = 1;
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.01s') 
        if app.CurrentTimePoints-round(0.01*SampleRate) >= 1
            app.CurrentTimePoints = app.CurrentTimePoints-round(0.01*SampleRate);
        elseif app.CurrentTimePoints-round(0.01*SampleRate) < 1
            app.CurrentTimePoints = 1;
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.1s') 
        if app.CurrentTimePoints-round(0.1*SampleRate) >= 1
            app.CurrentTimePoints = app.CurrentTimePoints-round(0.1*SampleRate);
        elseif app.CurrentTimePoints-round(0.1*SampleRate) < 1
            app.CurrentTimePoints = 1;
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'0.5s') 
        if app.CurrentTimePoints-round(0.5*SampleRate) >= 1
            app.CurrentTimePoints = app.CurrentTimePoints-round(0.5*SampleRate);
        elseif app.CurrentTimePoints-round(0.5*SampleRate) < 1
            app.CurrentTimePoints = 1;
        end
    elseif strcmp(app.TimeSpanControlDropDown.Value,'1s') 
        if app.CurrentTimePoints-round(1*SampleRate) >= 1
            app.CurrentTimePoints = app.CurrentTimePoints-round(1*SampleRate);
        elseif app.CurrentTimePoints-round(1*SampleRate) < 1
            app.CurrentTimePoints = 1;
        end
    else % if smt else
        TimeSelected = str2double(app.TimeSpanControlDropDown.Value(1:end-1));
        if app.CurrentTimePoints-round(TimeSelected*SampleRate) >= 1
            app.CurrentTimePoints = app.CurrentTimePoints-round(TimeSelected*SampleRate);
        elseif app.CurrentTimePoints-round(TimeSelected*SampleRate) < 1
            app.CurrentTimePoints = 1;
        end
    end
end