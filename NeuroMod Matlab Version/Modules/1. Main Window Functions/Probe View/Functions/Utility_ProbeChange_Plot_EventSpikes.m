function [app] = Utility_ProbeChange_Plot_EventSpikes(app)

%________________________________________________________________________________________
%% Function to update event related spike analysis plots when the user changed the active channel selection

% Executed only when the user changes the channelselection and event related spike analysis windows are supposed to be updated (in the dropdown menu of the probe view window)

% Inputs: 
% 1. app: probe view window object

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if ~isempty(app.Mainapp.EventKilosortSpikesWindow)

    app.Mainapp.EventKilosortSpikesWindow.UIAxes.Color = app.Mainapp.EventKilosortSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor;
    app.Mainapp.EventKilosortSpikesWindow.UIAxes.FontSize = app.Mainapp.EventKilosortSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotFontSize;
        
    [TempData,app.Mainapp.EventKilosortSpikesWindow.ChannelSelectionforPlottingEditField.Value,app.Mainapp.EventKilosortSpikesWindow.EventRangeEditField.Value,app.Mainapp.EventKilosortSpikesWindow.SpikeRateNumBinsEditField.Value,app.Mainapp.EventKilosortSpikesWindow.Mainapp.CurrentPlotData] = Events_Spikes_Manage_Analysis_Plots(app.Mainapp.EventKilosortSpikesWindow.Mainapp.Data,app.Mainapp.EventKilosortSpikesWindow.EventRangeEditField.Value,app.Mainapp.EventKilosortSpikesWindow.UIAxes,app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,app.Mainapp.EventKilosortSpikesWindow.SpikeRateNumBinsEditField.Value,app.Mainapp.EventKilosortSpikesWindow.TextArea,app.Mainapp.EventKilosortSpikesWindow.rgbMatrix,app.Mainapp.EventKilosortSpikesWindow.numCluster,app.Mainapp.EventKilosortSpikesWindow.ClustertoshowDropDown.Value,app.Mainapp.EventKilosortSpikesWindow.ChannelSelectionforPlottingEditField.Value,app.Mainapp.EventKilosortSpikesWindow.BaselineWindowStartStopinsEditField,app.Mainapp.EventKilosortSpikesWindow.BaselineNormalizeCheckBox.Value,app.Mainapp.EventKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField.Value,app.Mainapp.EventKilosortSpikesWindow.UIAxes_3,app.Mainapp.EventKilosortSpikesWindow.UIAxes_5,app.Mainapp.EventKilosortSpikesWindow.TwoORThreeD,app.Mainapp.EventKilosortSpikesWindow.Mainapp.CurrentPlotData,app.Mainapp.EventKilosortSpikesWindow.SpikeBinSettings,app.Mainapp.EventKilosortSpikesWindow.Mainapp.PlotAppearance,app.Mainapp.EventKilosortSpikesWindow.Mainapp.ActiveChannel,app.Mainapp.EventKilosortSpikesWindow.DataTypeDropDown.Value,app.Mainapp.EventKilosortSpikesWindow.EventChannelSelectionDropDown.Value,0);
    
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

    if strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Rate Heatmap") || strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Triggered Average")
        cb=colorbar('peer',app.Mainapp.EventKilosortSpikesWindow.UIAxes,'location','WestOutside');
        cb.Color = 'k';              % Sets tick mark and label color to black
        cb.Label.Rotation = 270;
        cb.Label.Color = 'k';        % Sets the color of the label text
        app.Mainapp.EventKilosortSpikesWindow.UIAxes.XColor = 'k';  
        app.Mainapp.EventKilosortSpikesWindow.UIAxes.XTickLabelMode = 'auto';  

        if strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Rate Heatmap")
            cb.Label.String = "Firing Rate [Hz]";
        elseif strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Triggered Average")
            cb.Label.String = "Signal [mV]";
        end
    end

    app.Mainapp.EventKilosortSpikesWindow.UIAxes.Title.Color = 'k';  
    app.Mainapp.EventKilosortSpikesWindow.UIAxes.YColor = 'k';  
    app.Mainapp.EventKilosortSpikesWindow.UIAxes.YLabel.Color = 'k';
    app.Mainapp.EventKilosortSpikesWindow.UIAxes.YTickLabelMode = 'auto';
    
    if strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Map") || strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Rate Heatmap") || strcmp(app.Mainapp.EventKilosortSpikesWindow.AnalysisTypeDropDown.Value,"Spike Triggered Average")
        % Custome YLabel
        Utility_Set_YAxis_Depth_Labels(app.Mainapp.Data,app.Mainapp.EventKilosortSpikesWindow.UIAxes,[],app.Mainapp.ActiveChannel)
    end

end