function Utility_Main_plot_Arrow_Key_Press(app,event)

%________________________________________________________________________________________
%% Function to handle callback when user uses arrow key to jump in time

% Input Arguments:
% 1. app: main window app object
% 2. event: event object created at callback

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Jump In time
switch event.Key
    case 'rightarrow' % Foward In TIME!
        if ~isfield(app.Data,'Raw') && ~isfield(app.Data,'Preprocessed')
            f = msgbox("Warning! No Data was extracted.");
            return;
        end
        
        app.PreviousThreshGrids = [];
        app.PlotThreshGrids = [];

        %% Determine new starting time point of data plot
       
        if isfield(app.Data.Info,'DownsampleFactor') && strcmp(app.DropDown.Value,'Preprocessed Data')
            [app] = Organize_Jump_in_Time(app,"Forward",numel(app.Data.TimeDownsampled),str2double(app.TimeRangeViewBox.Value(1:end-1))*app.Data.Info.DownsampledSampleRate,app.Data.Info.DownsampledSampleRate);
        else
            [app] = Organize_Jump_in_Time(app,"Forward",numel(app.Data.Time),str2double(app.TimeRangeViewBox.Value(1:end-1))*app.Data.Info.NativeSamplingRate,app.Data.Info.NativeSamplingRate);
        end
        
        %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
        % Plot functions are fully autonomous without needed the app
        % object. It is only needed to get the necessary parameter.
        % Both is combined in one function for convenience.
        %input 2: 1 if plot time, 0 if no time plot necessary
        %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
        %input 4: Whether Data plot should run in a movie or not
        Organize_Prepare_Plot_and_Extract_GUI_Info(app,1,"Subsequent","MainWindowTimeManipulation",app.PlotEvents,app.Plotspikes);
    case 'leftarrow' % back In TIME!
         if ~isfield(app.Data,'Raw') && ~isfield(app.Data,'Preprocessed')
            f = msgbox("Warning! No Data was extracted.");
            return;
        end

        app.PreviousThreshGrids = [];
        app.PlotThreshGrids = [];
        %% Determine new starting time point of data plot

        if isfield(app.Data.Info,'DownsampleFactor') && strcmp(app.DropDown.Value,'Preprocessed Data')
            [app] = Organize_Jump_in_Time(app,"Backwards",numel(app.Data.TimeDownsampled),str2double(app.TimeRangeViewBox.Value(1:end-1)),app.Data.Info.DownsampledSampleRate);
        else
            [app] = Organize_Jump_in_Time(app,"Backwards",numel(app.Data.Time),str2double(app.TimeRangeViewBox.Value(1:end-1)),app.Data.Info.NativeSamplingRate);
        end

        %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
        % Plot functions are fully autonomous without needed the app
        % object. It is only needed to get the necessary parameter.
        % Both is combined in one function for convenience.
        %input 2: 1 if plot time, 0 if no time plot necessary
        %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
        %input 4: Whether Data plot should run in a movie or not
        Organize_Prepare_Plot_and_Extract_GUI_Info(app,1,"Subsequent","MainWindowTimeManipulation",app.PlotEvents,app.Plotspikes);

%% Rescale data plot
case 'uparrow'
       if ~isfield(app.Data,'Raw') && ~isfield(app.Data,'Preprocessed')
            msgbox("Warning! No Data was extracted.");
            return;
        end
        
        Fraction = app.Slider.Limits(2)/100; % 100 steps
        % Get descending y values for each channel plot
        if app.Slider.Value + Fraction <= app.Slider.Limits(2)
            app.Slider.Value = app.Slider.Value + Fraction;
            app.PlotLineSpacing = app.Slider.Value;  % Height between each row plot
        else
            app.PlotLineSpacing = app.Slider.Limits(2);  % Height between each row plot
        end

        % If data is normalized: Adjust so that raw data and
        % preprocessed data scale is not far off
        if isfield(app.Data.Info, 'Normalize') && strcmp(app.DropDown.Value,'Preprocessed Data')
            app.PlotLineSpacing = app.PlotLineSpacing*10;  % Height between each row plot
        end
        % If data is normalized and high pass filtered: Adjust so that raw data and
        % preprocessed data scale is not far off, difference even
        % bigger than just normalization
        if isfield(app.Data.Info, 'Normalize') && isfield(app.Data.Info, 'FilterMethod') && strcmp(app.DropDown.Value,'Preprocessed Data')
            if strcmp(app.Data.Info.FilterMethod,"High-Pass")
                app.PlotLineSpacing = app.PlotLineSpacing*10;  % Height between each row plot
            end
        end
        %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
        % Plot functions are fully autonomous without needed the app
        % object. It is only needed to get the necessary parameter.
        % Both is combined in one function for convenience.
        %input 2: 1 if plot time, 0 if no time plot necessary
        %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
        %input 4: Whether Data plot should run in a movie or not
        Organize_Prepare_Plot_and_Extract_GUI_Info(app,0,"Subsequent","MainWindowTimeManipulation",app.PlotEvents,app.Plotspikes);
case 'downarrow'
        if ~isfield(app.Data,'Raw') && ~isfield(app.Data,'Preprocessed')
            msgbox("Warning! No Data was extracted.");
            return;
        end
        
        Fraction = app.Slider.Limits(2)/100; % 100 steps
        % Get descending y values for each channel plot
        if app.Slider.Value - Fraction > 0
            app.Slider.Value = app.Slider.Value - Fraction;
            app.PlotLineSpacing = app.Slider.Value;  % Height between each row plot
        else
            app.PlotLineSpacing = 0;  % Height between each row plot
        end

        % If data is normalized: Adjust so that raw data and
        % preprocessed data scale is not far off
        if isfield(app.Data.Info, 'Normalize') && strcmp(app.DropDown.Value,'Preprocessed Data')
            app.PlotLineSpacing = app.PlotLineSpacing*10;  % Height between each row plot
        end
        % If data is normalized and high pass filtered: Adjust so that raw data and
        % preprocessed data scale is not far off, difference even
        % bigger than just normalization
        if isfield(app.Data.Info, 'Normalize') && isfield(app.Data.Info, 'FilterMethod') && strcmp(app.DropDown.Value,'Preprocessed Data')
            if strcmp(app.Data.Info.FilterMethod,"High-Pass")
                app.PlotLineSpacing = app.PlotLineSpacing*10;  % Height between each row plot
            end
        end
        %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
        % Plot functions are fully autonomous without needed the app
        % object. It is only needed to get the necessary parameter.
        % Both is combined in one function for convenience.
        %input 2: 1 if plot time, 0 if no time plot necessary
        %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
        %input 4: Whether Data plot should run in a movie or not
        Organize_Prepare_Plot_and_Extract_GUI_Info(app,0,"Subsequent","MainWindowTimeManipulation",app.PlotEvents,app.Plotspikes);
end