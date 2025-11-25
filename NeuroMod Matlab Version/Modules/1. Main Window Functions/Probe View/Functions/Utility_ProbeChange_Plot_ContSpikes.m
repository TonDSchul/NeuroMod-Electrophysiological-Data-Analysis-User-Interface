function [app] = Utility_ProbeChange_Plot_ContSpikes(app)

%________________________________________________________________________________________
%% Function to update continous spike analysis plots when the user changed the active channel selection

% Executed only when the user changes the channelselection and cont. spike
% analysis windows are supposed to be updated (in the dropdown menu of the probe view window)

% Inputs: 
% 1. app: probe view window object

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if ~isempty(app.Mainapp.ConKilosortSpikesWindow)
    app.Mainapp.ConKilosortSpikesWindow.UIAxes.Color = app.Mainapp.ConKilosortSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor;
    app.Mainapp.ConKilosortSpikesWindow.UIAxes.FontSize = app.Mainapp.ConKilosortSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotFontSize;

    if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel") && isempty(app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms)
        %% Data needs to be high pass filtered! Otherwise waveforms are weird. Recommended is also grand average
        % Detect high pass filter
        HigPassFiltered = 1;
        
        if isfield(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,'Preprocessed') 
            if isfield(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info,'FilterMethod') 
                if ~strcmp(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info.FilterMethod,'High-Pass')
                    msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
                    HigPassFiltered = 0;
                end
            else
                msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
                HigPassFiltered = 0;
            end
        else
            msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
            HigPassFiltered = 0;
        end

        %%% if it has to be high pass filtered --> save as TempData, extract
        %%% waveforms and delete temp variable
        if HigPassFiltered == 0
            HighPassFilterSettings = [];
            Spike_Extraction_HighPassWindow = Spike_Extraction_AskforHighPass(HighPassFilterSettings);
            
            uiwait(Spike_Extraction_HighPassWindow.PreproSTAWindowUIFigure);
            
            if isvalid(Spike_Extraction_HighPassWindow)
                Cutoff = Spike_Extraction_HighPassWindow.HighPassFilterSettings.Cutoff;
                FilterOrder = Spike_Extraction_HighPassWindow.HighPassFilterSettings.FilterOrder;
                SaveFilter = Spike_Extraction_HighPassWindow.HighPassFilterSettings.SaveFilter;
                delete(Spike_Extraction_HighPassWindow);
            else
                disp("High pass filter settings window closed before manual config was saved. Using standad high pass filter settings (300Hz cutoff, filterorder 6)")
                Cutoff = "300";
                FilterOrder = "6";
                SaveFilter = "No";
            end
        
            PreproInfo = [];
            PreprocessingSteps = [];
        
            Methods = ["Filter"];
            [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods,PreproInfo,PreprocessingSteps,0,"High-Pass","Butterworth IR",Cutoff,"Zero-phase forward and reverse",FilterOrder,[],app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info.NativeSamplingRate);
                
            if isfield(PreproInfo,'ChannelDeletion')
                ChannelDeletion = PreproInfo.ChannelDeletion;
            else
                ChannelDeletion = [];
            end
            
            PlaceholderTextArea = [];
            
            if strcmp(SaveFilter,"No")
                [TempData,PreproInfo,PlaceholderTextArea] = Preprocess_Module_Delete_Old_Settings(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,PreproInfo,PreprocessingSteps,ChannelDeletion,PlaceholderTextArea);
                [TempData] = Preprocess_Module_Apply_Pipeline (TempData,TempData.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,PlaceholderTextArea);
                
                %% Now extract Waveforms
                % For Kilosort we dont have channel information to extract from raw or
                % preprocessed data --> Therefor we take channel closest to position
                [app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(TempData,TempData.Spikes.SpikeTimes,TempData.Spikes.SpikeChannel,"AverageWaveforms");
                clear TempData;
            else
                [app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,PreproInfo,PlaceholderTextArea] = Preprocess_Module_Delete_Old_Settings(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,PreproInfo,PreprocessingSteps,ChannelDeletion,PlaceholderTextArea);
                [app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data] = Preprocess_Module_Apply_Pipeline (app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,PlaceholderTextArea);
        
                %% Now extract Waveforms
                % For Kilosort we dont have channel information to extract from raw or
                % preprocessed data --> Therefor we take channel closest to position
                [app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikeTimes,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikeChannel,"AverageWaveforms");

                Utility_Show_Info_Loaded_Data(app.Mainapp.ConKilosortSpikesWindow.Mainapp);
    
                if strcmp(SaveFilter,"Yes")
                    [app.Mainapp.ConKilosortSpikesWindow.Mainapp] = Organize_Initialize_GUI (app.Mainapp.ConKilosortSpikesWindow.Mainapp,"Preprocessing",app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,[],[],[],[],[]);
                end
    
                Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp.ConKilosortSpikesWindow.Mainapp,1,"Initial","Static",app.Mainapp.ConKilosortSpikesWindow.Mainapp.PlotEvents,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Plotspikes);
            end
        else % If high pass was already applied
            [app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikeTimes,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikeChannel,"AverageWaveforms");
        end
    end
    
    if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel")
        [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,WaveformChannel] = Continous_Spikes_Prepare_Plots(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,[],app.Mainapp.Data.Info.SpikeType,app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,1,app.Mainapp.ConKilosortSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,app.Mainapp.ConKilosortSpikesWindow.Mainapp.ActiveChannel,app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,app.Mainapp.PreservePlotChannelLocations);
    else
        [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,WaveformChannel] = Continous_Spikes_Prepare_Plots(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,[],app.Mainapp.Data.Info.SpikeType,app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,1,app.Mainapp.ConKilosortSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.Waveforms,app.Mainapp.ConKilosortSpikesWindow.Mainapp.ActiveChannel,app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,app.Mainapp.PreservePlotChannelLocations);
    end

    [TempData,app.Mainapp.ConKilosortSpikesWindow.Mainapp.CurrentPlotData] = Continous_Spikes_Manage_Analysis_Plots(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,Waveforms,WaveformChannel,CluterPositions,app.Mainapp.ConKilosortSpikesWindow.UIAxes,app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.TextArea,app.Mainapp.ConKilosortSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.rgbMatrix,app.Mainapp.ConKilosortSpikesWindow.numCluster,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.UIAxes_3,app.Mainapp.ConKilosortSpikesWindow.UIAxes_5,app.Mainapp.ConKilosortSpikesWindow.TwoORThreeD,app.Mainapp.ConKilosortSpikesWindow.Mainapp.CurrentPlotData,app.Mainapp.ConKilosortSpikesWindow.Mainapp.PlotAppearance,0,app.Mainapp.ActiveChannel,app.Mainapp.PreservePlotChannelLocations);
   
    if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Triggered LFP")
        if ~isempty(TempData)
            app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data = TempData;
            PreviousChannelDeletetion = 0;
            % If Channel were deleted in previous preprocessing flag this
            % to reset main window parameter after + only allow for prepro
            % view if prepro was generated
            if isfield(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info,"ChannelDeletion")
                PreviousChannelDeletetion = 1;
            end
            %% Update Textbox "Recording Information" in Main window with new preprocessing infos
            Utility_Show_Info_Loaded_Data(app.Mainapp.ConKilosortSpikesWindow.Mainapp);
            %% Wrap up preprocessing
            [app.Mainapp.ConKilosortSpikesWindow.Mainapp] = Organize_Initialize_GUI (app.Mainapp.ConKilosortSpikesWindow.Mainapp,"Preprocessing",app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,[],[],[],[],PreviousChannelDeletetion);
            if strcmp(app.Mainapp.ConKilosortSpikesWindow.Mainapp.DropDown.Value,'Preprocessed Data')
                if isfield(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info,'DownsampleFactor')
                    TimeinSecs = app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Time(app.Mainapp.ConKilosortSpikesWindow.Mainapp.CurrentTimePoints);
                    % Calculate the absolute differences
                    differences = abs(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.TimeDownsampled - TimeinSecs);
                    
                    % Find the index of the minimum difference
                    [~, app.Mainapp.ConKilosortSpikesWindow.Mainapp.CurrentTimePoints] = min(differences);
                end
            end
            %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
            % Plot functions are fully autonomous without needed the app.Mainapp.ConKilosortSpikesWindow
            % object. It is only needed to get the necessary parameter.
            % Both is combined in one function for convenience.
            %input 2: 1 if plot time, 0 if no time plot necessary
            %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
            %input 4: Whether Data plot should run in a movie or not
            Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp.ConKilosortSpikesWindow.Mainapp,1,"Initial","Static",app.Mainapp.ConKilosortSpikesWindow.Mainapp.PlotEvents,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Plotspikes);
        end
    else
        app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data = TempData;
    end

    if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Amplitude Density Along Depth") || strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Cumulative Spike Amplitude Density Along Depth") || strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel") || strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Triggered LFP")
        cb=colorbar('peer',app.Mainapp.ConKilosortSpikesWindow.UIAxes,'location','WestOutside');
        cb.Color = 'k';              % Sets tick mark and label color to black
        cb.Label.Rotation = 270;
        cb.Label.Color = 'k';        % Sets the color of the label text
    
        if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel")
            cb.Label.String = "Amplitude [mV]";
        elseif strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Triggered LFP")
            cb.Label.String = "Signal [mV]";
        else
            cb.Label.String = "Firing Rate [Hz]";
        end
    end
    
    app.Mainapp.ConKilosortSpikesWindow.UIAxes.YColor = 'k';  
    app.Mainapp.ConKilosortSpikesWindow.UIAxes.YTickLabelMode = 'auto';
    app.Mainapp.ConKilosortSpikesWindow.UIAxes.XColor = 'k';  
    app.Mainapp.ConKilosortSpikesWindow.UIAxes.Title.Color = 'k';  
    %app.UIAxes.YTickLabelMode = 'auto';
    if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Map")
        % Disable XTick labels
        app.Mainapp.ConKilosortSpikesWindow.UIAxes.XTickLabel = [];
        app.Mainapp.ConKilosortSpikesWindow.UIAxes.Title.Color = 'k'; 
        % Remove xlabel
        app.Mainapp.ConKilosortSpikesWindow.UIAxes.XLabel.String = '';
        app.Mainapp.ConKilosortSpikesWindow.UIAxes.YColor = 'k';  
        app.Mainapp.ConKilosortSpikesWindow.UIAxes.YTickLabelMode = 'auto';
    end

    if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Map") || strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel") || strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Triggered LFP") || strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Cumulative Spike Amplitude Density Along Depth") || strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Amplitude Density Along Depth")
        % Custome YLabel
        Utility_Set_YAxis_Depth_Labels(app.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.UIAxes,[],app.Mainapp.ActiveChannel,app.Mainapp.PreservePlotChannelLocations)
    end

end

