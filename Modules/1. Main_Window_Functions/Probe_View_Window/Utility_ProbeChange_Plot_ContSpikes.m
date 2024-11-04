function [app] = Utility_ProbeChange_Plot_ContSpikes(app)

if ~isempty(app.Mainapp.ConInternalSpikesWindow)
    app.Mainapp.ConInternalSpikesWindow.UIAxes.Color = app.Mainapp.ConInternalSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor;
    app.Mainapp.ConInternalSpikesWindow.UIAxes.FontSize = app.Mainapp.ConInternalSpikesWindow.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotFontSize;
    
    if strcmp(app.Mainapp.ConInternalSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel") && isempty(app.Mainapp.ConInternalSpikesWindow.AverageWaveforms)
        %% Data needs to be high pass filtered! Otherwise waveforms are weird. Recommended is also grand average
        % Detect high pass filter
        HigPassFiltered = 1;
        
        if isfield(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,'Preprocessed') 
            if isfield(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Info,'FilterMethod') 
                if ~strcmp(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Info.FilterMethod,'High-Pass')
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
            [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods,PreproInfo,PreprocessingSteps,0,"High-Pass","Butterworth IR",Cutoff,"Zero-phase forward and reverse",FilterOrder,[],app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Info.NativeSamplingRate);
                
            if isfield(PreproInfo,'ChannelDeletion')
                ChannelDeletion = PreproInfo.ChannelDeletion;
            else
                ChannelDeletion = [];
            end
            
            PlaceholderTextArea = [];
            
            if strcmp(SaveFilter,"No")
                [TempData,PreproInfo,PlaceholderTextArea] = Preprocess_Module_Delete_Old_Settings(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,PreproInfo,PreprocessingSteps,ChannelDeletion,PlaceholderTextArea);
                [TempData] = Preprocess_Module_Apply_Pipeline (TempData,TempData.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,PlaceholderTextArea);
                
                %% Now extract Waveforms
                % For Kilosort we dont have channel information to extract from raw or
                % preprocessed data --> Therefor we take channel closest to position
                [app.Mainapp.ConInternalSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(TempData,TempData.Spikes.SpikeTimes,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Spikes.SpikePositions(:,2),"AverageWaveforms");
                clear TempData;
            else
                [app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,PreproInfo,PlaceholderTextArea] = Preprocess_Module_Delete_Old_Settings(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,PreproInfo,PreprocessingSteps,ChannelDeletion,PlaceholderTextArea);
                [app.Mainapp.ConInternalSpikesWindow.Mainapp.Data] = Preprocess_Module_Apply_Pipeline (app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,PlaceholderTextArea);
        
                %% Now extract Waveforms
                % For Kilosort we dont have channel information to extract from raw or
                % preprocessed data --> Therefor we take channel closest to position
                [app.Mainapp.ConInternalSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Spikes.SpikeTimes,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Spikes.SpikePositions(:,2),"AverageWaveforms");
    
                Utility_Show_Info_Loaded_Data(app.Mainapp.ConInternalSpikesWindow.Mainapp);
    
                if strcmp(SaveFilter,"Yes")
                    [app.Mainapp.ConInternalSpikesWindow.Mainapp] = Organize_Initialize_GUI (app.Mainapp.ConInternalSpikesWindow.Mainapp,"Preprocessing",app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,[],[],[],[],[]);
                end
    
                Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp.ConInternalSpikesWindow.Mainapp,1,"Initial","Static",app.Mainapp.ConInternalSpikesWindow.Mainapp.PlotEvents,app.Mainapp.ConInternalSpikesWindow.Mainapp.Plotspikes);
            end
        else % If high pass was already applied
            [app.Mainapp.ConInternalSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Spikes.SpikeTimes,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Spikes.SpikePositions(:,2),"AverageWaveforms");
        end
    end
    
    if strcmp(app.Mainapp.ConInternalSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel")
        [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,ChannelPosition,PlotInfo,app.Mainapp.ConInternalSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.ClustertoshowDropDown,app.Mainapp.ConInternalSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField] = Continous_Spikes_Prepare_Plots(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,app.Mainapp.ConInternalSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.ClustertoshowDropDown,"Non","Internal",app.Mainapp.ConInternalSpikesWindow.TypeofAnalysisDropDown,app.Mainapp.ConInternalSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField,1,app.Mainapp.ConInternalSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConInternalSpikesWindow.AverageWaveforms,app.Mainapp.ConInternalSpikesWindow.Mainapp.ActiveChannel);
    else
        [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,ChannelPosition,PlotInfo,app.Mainapp.ConInternalSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.ClustertoshowDropDown,app.Mainapp.ConInternalSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField] = Continous_Spikes_Prepare_Plots(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,app.Mainapp.ConInternalSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConInternalSpikesWindow.ClustertoshowDropDown,"Non","Internal",app.Mainapp.ConInternalSpikesWindow.TypeofAnalysisDropDown,app.Mainapp.ConInternalSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField,1,app.Mainapp.ConInternalSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Spikes.Waveforms,app.Mainapp.ConInternalSpikesWindow.Mainapp.ActiveChannel);
    end
    
    [TempData,app.Mainapp.ConInternalSpikesWindow.Mainapp.CurrentPlotData] = Continous_Internal_Spikes_Manage_Analysis_Plots(app.Mainapp.ConInternalSpikesWindow.TypeofAnalysisDropDown.Value,app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,SpikeTimes,SpikePositions,CluterPositions,SpikeAmps,Waveforms,PlotInfo,app.Mainapp.ConInternalSpikesWindow.TextArea,ChannelPosition,app.Mainapp.ConInternalSpikesWindow.UIAxes,app.Mainapp.ConInternalSpikesWindow.UIAxes_3,app.Mainapp.ConInternalSpikesWindow.UIAxes_5,app.Mainapp.ConInternalSpikesWindow.rgbMatrix,app.Mainapp.ConInternalSpikesWindow.TwoORThreeD,app.Mainapp.ConInternalSpikesWindow.ClustertoshowDropDown.Value,app.Mainapp.ConInternalSpikesWindow.Mainapp.CurrentPlotData,app.Mainapp.ConInternalSpikesWindow.Mainapp.PlotAppearance);
    
    if strcmp(app.Mainapp.ConInternalSpikesWindow.TypeofAnalysisDropDown.Value,"Spike Triggered LFP")
        if ~isempty(TempData)
            app.Mainapp.ConInternalSpikesWindow.Mainapp.Data = TempData;
            PreviousChannelDeletetion = 0;
            % If Channel were deleted in previous preprocessing flag this
            % to reset main window parameter after + only allow for prepro
            % view if prepro was generated
            if isfield(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Info,"ChannelDeletion")
                PreviousChannelDeletetion = 1;
            end
            %% Update Textbox "Recording Information" in Main window with new preprocessing infos
            Utility_Show_Info_Loaded_Data(app.Mainapp.ConInternalSpikesWindow.Mainapp);
            %% Wrap up preprocessing
            [app.Mainapp.ConInternalSpikesWindow.Mainapp] = Organize_Initialize_GUI (app.Mainapp.ConInternalSpikesWindow.Mainapp,"Preprocessing",app.Mainapp.ConInternalSpikesWindow.Mainapp.Data,[],[],[],[],PreviousChannelDeletetion);
            if strcmp(app.Mainapp.ConInternalSpikesWindow.Mainapp.DropDown.Value,'Preprocessed Data')
                if isfield(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Info,'DownsampleFactor')
                    TimeinSecs = app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.Time(app.Mainapp.ConInternalSpikesWindow.Mainapp.CurrentTimePoints);
                    % Calculate the absolute differences
                    differences = abs(app.Mainapp.ConInternalSpikesWindow.Mainapp.Data.TimeDownsampled - TimeinSecs);
                    
                    % Find the index of the minimum difference
                    [~, app.Mainapp.ConInternalSpikesWindow.Mainapp.CurrentTimePoints] = min(differences);
                end
            end
            %% Get all necessary Infos from GUI, set time scale based on time window, select data based on this AND plot
            % Plot functions are fully autonomous without needed the app.Mainapp.ConInternalSpikesWindow
            % object. It is only needed to get the necessary parameter.
            % Both is combined in one function for convenience.
            %input 2: 1 if plot time, 0 if no time plot necessary
            %input 3: Update time plot = Subsequent; Replot whole time plot = "Initial"
            %input 4: Whether Data plot should run in a movie or not
            Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp.ConInternalSpikesWindow.Mainapp,1,"Initial","Static",app.Mainapp.ConInternalSpikesWindow.Mainapp.PlotEvents,app.Mainapp.ConInternalSpikesWindow.Mainapp.Plotspikes);
        end
    else
        app.Mainapp.ConInternalSpikesWindow.Mainapp.Data = TempData;
    end
end

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
                SpikePositions = (TempData.Spikes.SpikePositions(:,2)./TempData.Info.ChannelSpacing)+1;
                SpikePositions = round(SpikePositions);
                [app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(TempData,TempData.Spikes.SpikeTimes,SpikePositions,"AverageWaveforms");
                clear TempData;
            else
                [app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,PreproInfo,PlaceholderTextArea] = Preprocess_Module_Delete_Old_Settings(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,PreproInfo,PreprocessingSteps,ChannelDeletion,PlaceholderTextArea);
                [app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data] = Preprocess_Module_Apply_Pipeline (app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,PlaceholderTextArea);
        
                %% Now extract Waveforms
                % For Kilosort we dont have channel information to extract from raw or
                % preprocessed data --> Therefor we take channel closest to position
                SpikePositions = (app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikePositions(:,2)./app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info.ChannelSpacing)+1;
                SpikePositions = round(SpikePositions);
                [app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikeTimes,SpikePositions,"AverageWaveforms");

                Utility_Show_Info_Loaded_Data(app.Mainapp.ConKilosortSpikesWindow.Mainapp);
    
                if strcmp(SaveFilter,"Yes")
                    [app.Mainapp.ConKilosortSpikesWindow.Mainapp] = Organize_Initialize_GUI (app.Mainapp.ConKilosortSpikesWindow.Mainapp,"Preprocessing",app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,[],[],[],[],[]);
                end
    
                Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp.ConKilosortSpikesWindow.Mainapp,1,"Initial","Static",app.Mainapp.ConKilosortSpikesWindow.Mainapp.PlotEvents,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Plotspikes);
            end
        else % If high pass was already applied
            SpikePositions = (app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikePositions(:,2)./app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Info.ChannelSpacing)+1;
            SpikePositions = round(SpikePositions);
            [app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,~] = Spikes_Module_Get_Waveforms(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.SpikeTimes,SpikePositions,"AverageWaveforms");
        end
    end
    
    if strcmp(app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,"Average Waveforms Across Channel")
        [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,WaveformChannel] = Continous_Spikes_Prepare_Plots(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,[],"Kilosort",app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,1,app.Mainapp.ConKilosortSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.AverageWaveforms,app.Mainapp.ConKilosortSpikesWindow.Mainapp.ActiveChannel);
    else
        [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,~,PlotInfo,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,WaveformChannel] = Continous_Spikes_Prepare_Plots(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,app.Mainapp.ConKilosortSpikesWindow.ChannelSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown,[],"Kilosort",app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown,app.Mainapp.ConKilosortSpikesWindow.SpikeRateNumBinsEditField,app.Mainapp.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField,1,app.Mainapp.ConKilosortSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data.Spikes.Waveforms,app.Mainapp.ConKilosortSpikesWindow.Mainapp.ActiveChannel);
    end

    [TempData,app.Mainapp.ConKilosortSpikesWindow.Mainapp.CurrentPlotData] = Continous_Kilosort_Spikes_Manage_Analysis_Plots(app.Mainapp.ConKilosortSpikesWindow.Mainapp.Data,PlotInfo,SpikePositions,SpikeAmps,SpikeTimes,Waveforms,WaveformChannel,CluterPositions,app.Mainapp.ConKilosortSpikesWindow.UIAxes,app.Mainapp.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.TextArea,app.Mainapp.ConKilosortSpikesWindow.EventstoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.rgbMatrix,app.Mainapp.ConKilosortSpikesWindow.numCluster,app.Mainapp.ConKilosortSpikesWindow.ClustertoshowDropDown.Value,app.Mainapp.ConKilosortSpikesWindow.UIAxes_3,app.Mainapp.ConKilosortSpikesWindow.UIAxes_5,app.Mainapp.ConKilosortSpikesWindow.TwoORThreeD,app.Mainapp.ConKilosortSpikesWindow.Mainapp.CurrentPlotData,app.Mainapp.ConKilosortSpikesWindow.Mainapp.PlotAppearance);
   
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

end