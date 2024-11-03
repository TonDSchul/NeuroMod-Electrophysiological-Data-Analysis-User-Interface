function [app] = Utility_ProbeChange_Plot_EventSpikes(app)

if ~isempty(app.Mainapp.EventInternalSpikesWindow)

    app.Mainapp.EventInternalSpikesWindow.UIAxes.Color = app.Mainapp.EventInternalSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor;
    app.Mainapp.EventInternalSpikesWindow.UIAxes.FontSize = app.Mainapp.EventInternalSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotFontSize;
    
    % if strcmp(app.Mainapp.EventInternalSpikesWindow.AnalysisTypeDropDown.Value,"Spike Triggered Average")
    %     [app.Mainapp.EventInternalSpikesWindow.Mainapp.Data,~] = Event_Spikes_Extract_Event_Related_Spikes(app.Mainapp.EventInternalSpikesWindow.Mainapp.Data,'Kilosort',1);
    % else
    %     if strcmp(event.PreviousValue,"Spike Triggered Average")
    %         [app.Mainapp.EventInternalSpikesWindow.Mainapp.Data,~] = Event_Spikes_Extract_Event_Related_Spikes(app.Mainapp.EventInternalSpikesWindow.Mainapp.Data,'Kilosort',0);
    %     end
    % end
    
    [TempData,app.Mainapp.EventInternalSpikesWindow.ChannelSelectionforPlottingEditField.Value,app.Mainapp.EventInternalSpikesWindow.EventRangeEditField.Value,app.Mainapp.EventInternalSpikesWindow.SpikeRateNumBinsEditField.Value,app.Mainapp.EventInternalSpikesWindow.Mainapp.CurrentPlotData] = Events_Internal_Spikes_Manage_Analysis_Plots(app.Mainapp.EventInternalSpikesWindow.Mainapp.Data,app.Mainapp.EventInternalSpikesWindow.EventRangeEditField.Value,app.Mainapp.EventInternalSpikesWindow.UIAxes,app.Mainapp.EventInternalSpikesWindow.AnalysisTypeDropDown.Value,app.Mainapp.EventInternalSpikesWindow.SpikeRateNumBinsEditField.Value,app.Mainapp.EventInternalSpikesWindow.TextArea,app.Mainapp.EventInternalSpikesWindow.rgbMatrix,app.Mainapp.EventInternalSpikesWindow.ChannelSelectionforPlottingEditField.Value,app.Mainapp.EventInternalSpikesWindow.BaselineWindowStartStopinsEditField,app.Mainapp.EventInternalSpikesWindow.BaselineNormalizeCheckBox.Value,app.Mainapp.EventInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField.Value,app.Mainapp.EventInternalSpikesWindow.UIAxes_3,app.Mainapp.EventInternalSpikesWindow.UIAxes_5,app.Mainapp.EventInternalSpikesWindow.TwoORThreeD,app.Mainapp.EventInternalSpikesWindow.ClustertoshowDropDown.Value,app.Mainapp.EventInternalSpikesWindow.numCluster,app.Mainapp.EventInternalSpikesWindow.Mainapp.CurrentPlotData,app.Mainapp.EventInternalSpikesWindow.SpikeBinSettings,app.Mainapp.EventInternalSpikesWindow.Mainapp.PlotAppearance,app.Mainapp.EventInternalSpikesWindow.Mainapp.ActiveChannel);
    
    if strcmp(app.Mainapp.EventInternalSpikesWindow.AnalysisTypeDropDown.Value,"Spike Rate Heatmap")
        app.Mainapp.EventInternalSpikesWindow.BaselineNormalizeCheckBox.Enable = "on";
        app.Mainapp.EventInternalSpikesWindow.BaselineWindowStartStopinsEditField.Enable = "on";
    else
        app.Mainapp.EventInternalSpikesWindow.BaselineNormalizeCheckBox.Enable = "off";
        app.Mainapp.EventInternalSpikesWindow.BaselineWindowStartStopinsEditField.Enable = "off";
    end
    
    if ~isempty(TempData)
        app.Mainapp.EventInternalSpikesWindow.Mainapp.Data = TempData;
        PreviousChannelDeletetion = 0;
        % If Channel were deleted in previous preprocessing flag this
        % to reset main window parameter after + only allow for prepro
        % view if prepro was generated
        if isfield(app.Mainapp.EventInternalSpikesWindow.Mainapp.Data.Info,"ChannelDeletion")
            PreviousChannelDeletetion = 1;
        end
        %% Update Textbox "Recording Information" in Main window with new preprocessing infos
        Utility_Show_Info_Loaded_Data(app.Mainapp.EventInternalSpikesWindow.Mainapp);
        %% Wrap up preprocessing
        [app.Mainapp.EventInternalSpikesWindow.Mainapp] = Organize_Initialize_GUI (app.Mainapp.EventInternalSpikesWindow.Mainapp,"Preprocessing",app.Mainapp.EventInternalSpikesWindow.Mainapp.Data,[],[],[],[],PreviousChannelDeletetion);
        if strcmp(app.Mainapp.EventInternalSpikesWindow.Mainapp.DropDown.Value,'Preprocessed Data')
            if isfield(app.Mainapp.EventInternalSpikesWindow.Mainapp.Data.Info,'DownsampleFactor')
                TimeinSecs = app.Mainapp.EventInternalSpikesWindow.Mainapp.Data.Time(app.Mainapp.EventInternalSpikesWindow.Mainapp.CurrentTimePoints);
                % Calculate the absolute differences
                differences = abs(app.Mainapp.EventInternalSpikesWindow.Mainapp.Data.TimeDownsampled - TimeinSecs);
                
                % Find the index of the minimum difference
                [~, app.Mainapp.EventInternalSpikesWindow.Mainapp.CurrentTimePoints] = min(differences);
            end
        end
        %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
        % Plot functions are fully autonomous without needed the app.Mainapp.EventInternalSpikesWindow
        % object. It is only needed to get the necessary parameter.
        % Both is combined in one function for convenience.
        %input 2: 1 if plot time, 0 if no time plot necessary
        %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
        %input 4: Whether Data plot should run in a movie or not
        Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp.EventInternalSpikesWindow.Mainapp,1,"Initial","Static",app.Mainapp.EventInternalSpikesWindow.Mainapp.PlotEvents,app.Mainapp.EventInternalSpikesWindow.Mainapp.Plotspikes);
    end
end

if ~isempty(app.Mainapp.EventKilosortSpikesWindow)

    app.Mainapp.EventKilosortSpikesWindow.UIAxes.Color = app.Mainapp.EventKilosortSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor;
    app.Mainapp.EventKilosortSpikesWindow.UIAxes.FontSize = app.Mainapp.EventKilosortSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotFontSize;
    
    % if strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Triggered Average")
    %     [app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data,~] = Event_Spikes_Extract_Event_Related_Spikes(app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data,'Kilosort',1);
    % else
    %     if strcmp(event.PreviousValue,"Spike Triggered Average")
    %         [app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data,~] = Event_Spikes_Extract_Event_Related_Spikes(app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data,'Kilosort',0);
    %     end
    % end
    
    [TempData,app.Mainapp.EventKilosortSpikesWindow.ChannelSelectionforPlottingEditField.Value,app.Mainapp.EventKilosortSpikesWindow.EventRangeEditField.Value,app.Mainapp.EventKilosortSpikesWindow.SpikeRateNumBinsEditField.Value,app.Mainapp.EventKilosortSpikesWindow.Mainapp.CurrentPlotData] = Events_Kilosort_Spikes_Manage_Analysis_Plots(app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data,app.Mainapp.EventKilosortSpikesWindow.EventRangeEditField.Value,app.Mainapp.EventKilosortSpikesWindow.UIAxes,app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,app.Mainapp.EventKilosortSpikesWindow.SpikeRateNumBinsEditField.Value,app.Mainapp.EventKilosortSpikesWindow.TextArea,app.Mainapp.EventKilosortSpikesWindow.rgbMatrix,app.Mainapp.EventKilosortSpikesWindow.numCluster,app.Mainapp.EventKilosortSpikesWindow.ClustertoshowDropDown.Value,app.Mainapp.EventKilosortSpikesWindow.ChannelSelectionforPlottingEditField.Value,app.Mainapp.EventKilosortSpikesWindow.BaselineWindowStartStopinsEditField,app.Mainapp.EventKilosortSpikesWindow.BaselineNormalizeCheckBox.Value,app.Mainapp.EventKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField.Value,app.Mainapp.EventKilosortSpikesWindow.UIAxes_3,app.Mainapp.EventKilosortSpikesWindow.UIAxes_5,app.Mainapp.EventKilosortSpikesWindow.TwoORThreeD,app.Mainapp.EventKilosortSpikesWindow.Mainapp.CurrentPlotData,app.Mainapp.EventKilosortSpikesWindow.SpikeBinSettings,app.Mainapp.EventKilosortSpikesWindow.Mainapp.PlotAppearance,app.Mainapp.EventKilosortSpikesWindow.Mainapp.ActiveChannel);
    
    if ~isempty(TempData)
        app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data = TempData;
        PreviousChannelDeletetion = 0;
        % If Channel were deleted in previous preprocessing flag this
        % to reset main window parameter after + only allow for prepro
        % view if prepro was generated
        if isfield(app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data.Info,"ChannelDeletion")
            PreviousChannelDeletetion = 1;
        end
        %% Update Textbox "Recording Information" in Main window with new preprocessing infos
        Utility_Show_Info_Loaded_Data(app.Mainapp.EventKilosortSpikesWindow.Mainapp);
        %% Wrap up preprocessing
        [app.Mainapp.EventKilosortSpikesWindow.Mainapp] = Organize_Initialize_GUI (app.Mainapp.EventKilosortSpikesWindow.Mainapp,"Preprocessing",app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data,[],[],[],[],PreviousChannelDeletetion);
        if strcmp(app.Mainapp.EventKilosortSpikesWindow.Mainapp.DropDown.Value,'Preprocessed Data')
            if isfield(app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data.Info,'DownsampleFactor')
                TimeinSecs = app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data.Time(app.Mainapp.EventKilosortSpikesWindow.Mainapp.CurrentTimePoints);
                % Calculate the absolute differences
                differences = abs(app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data.TimeDownsampled - TimeinSecs);
                
                % Find the index of the minimum difference
                [~, app.Mainapp.EventKilosortSpikesWindow.Mainapp.CurrentTimePoints] = min(differences);
            end
        end
        %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
        % Plot functions are fully autonomous without needed the app.Mainapp.EventKilosortSpikesWindow
        % object. It is only needed to get the necessary parameter.
        % Both is combined in one function for convenience.
        %input 2: 1 if plot time, 0 if no time plot necessary
        %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
        %input 4: Whether Data plot should run in a movie or not
        Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp.EventKilosortSpikesWindow.Mainapp,1,"Initial","Static",app.Mainapp.EventKilosortSpikesWindow.Mainapp.PlotEvents,app.Mainapp.EventKilosortSpikesWindow.Mainapp.Plotspikes);
    end

end