function [app] = Utility_Set_ToolTips(app,Activated,Window)


%________________________________________________________________________________________
%% Function show or disable tooltips in all opened app windows.
% all app windows are saved as a property of the GUI main window

% Inputs:
% 1: app: main window app object
% 2: Activated: double, 1 or 0 whether to activate tooltips
% 3. Window: string, name of the window that opened and for which tooltips
% should be shwon or not

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if Activated
    %% Main Window
    if strcmp(Window,"MainWindow") || strcmp(Window,"All")
        app.TimeRangeViewBox.Tooltip = "Edit to change plotted time; Format [1s]";
        app.Button.Tooltip = "Click to increase plotted time by the time specified in 'Time to Manipulate Main Plot'";
        app.Button_2.Tooltip = "Click to decrease plotted time by the time specified in 'Time to Manipulate Main Plot'";
    
        app.Button_3.Tooltip = "Click to go forward in time by the time specified in 'Time to Manipulate Main Plot'";
        app.Button_4.Tooltip = "Click to go backwards in time by the time specified in 'Time to Manipulate Main Plot'";
    
        app.PlayButton.Tooltip = "Click to start play data as a movie. Right click to change plotting speed.";
        app.PauseButton.Tooltip = "Click to stop playing data as a movie.";
    
        app.OpenProbeViewButton.Tooltip = "Click to open probe layout to manipulate channel selection";
        app.Slider.Tooltip = "Click to change spaceing inbetween plotted lines; Right click to change limits";
    
        app.DropDown.Tooltip = "Select data type plotted";
        app.DropDown_2.Tooltip = "Select addons to plot like spikes and events";
    
        app.EventChannelDropDown.Tooltip = "Select event channel to plot";

        app.TextArea.Tooltip = "See all additional information about your recording. This includes infos from extracting data, preprocessing, spike and event detection and so on. So if you want to see what was done to the dataset all information is stored here.";
    end
    
    %% Extract Data window
    if strcmp(Window,"ExtractDataWindow") || strcmp(Window,"All")
        if ~isempty(app.ExtractDataWindow) && isvalid(app.ExtractDataWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.ExtractDataWindow.RecordingSystemDropDown.Tooltip = "If folder with a supported format was selected, this shows the detected format.";
            app.ExtractDataWindow.FileTypeDropDown.Tooltip = "Some formats can have multiple datasets (i.e. recording nodes for OE recordings) that can be selected and extracted individually.";
            app.ExtractDataWindow.AdditionalAmplificationFactorEditField.Tooltip = "If additional amplification after the headstage (not save in recording data) took place. Dataset gets multiplied by this factor.";
            app.ExtractDataWindow.AddProbeInformationButton.Tooltip = "Click to specify probe information necessary to start data extraction. Alternatively load saved probe information using the menu above.";
  
            app.ExtractDataWindow.ExtractDataButton.Tooltip = "Only if folder and probe information was specified.";
        end
    end
    %% Probe Layout Window
    if strcmp(Window,"SetProbeInfoWindow") || strcmp(Window,"All")
        if ~isempty(app.ExtractDataWindow) && isvalid(app.ExtractDataWindow)
            if ~isempty(app.ExtractDataWindow.ProbeLayoutWindow)
                if isprop(app.ExtractDataWindow.ProbeLayoutWindow,'ProbeLayoutWindowUIFigure')
                    app.ExtractDataWindow.ProbeLayoutWindow.NrChannelEditField.Tooltip = "Edit Nr of channel of your probe. For multiple channel rows set number of one row! Necessary to plot.";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelSpacingumEditField.Tooltip = "Edit channel spacing between channels in a row in µm. Necessary to plot.";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelRowsDropDown.Tooltip = "Edit the number of channel rows per Shank. Second channel row is to the right of the first one.";
                    app.ExtractDataWindow.ProbeLayoutWindow.HorizontalOffsetumEditField.Tooltip = "Edit distance between channel rows; in µm.";
                    app.ExtractDataWindow.ProbeLayoutWindow.VerticalOffsetumEditField.Tooltip = "Only applied when two rows selected. Edit vertical offset of second channel row on the right compared to the first channel row; in µm.";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.VerticalOffsetumEditField_2.Tooltip = "Vertical offset between indented channels; in µm.";
                    app.ExtractDataWindow.ProbeLayoutWindow.CheckBox.Tooltip = "When activated odd and even channel rows are indented (Still counts as one channel row when one row is selected).";
   
                    app.ExtractDataWindow.ProbeLayoutWindow.ActiveChannelField.Tooltip = "Active channel are those that you recorded from in respect to the probe geometry on the right. [1,2,3] means that the first three channel of the Probe design on the right represent the first three channel you recorded from. Number of channel specified here has to be the same as channel found in your recording. Leave empty to mark channel as active. Note 1: When two channel rows are selected and this field is empty, number of active channel is nr of channel*2! Note 2: The top channel used in every analysis is the lowest channel number if not reversed and the highest channel number if reversed";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelOrderField.Tooltip = "If channel are recorded and therefore loaded not in the correct order, you can change the order here. [5,4,1] means that the first loaded channel will be changed to the position of channel 5 in the probe view after extracting the dataset (specific location changes if channelnames are reversed!). Has to have the same length as active channel. Empty for no costum channel order.";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadChannelOrderButton.Tooltip = "Load a saved channel order. Has to be a .mat file containing a single vector with integers specifying the channel.";
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadActiveChannelSelectionButton.Tooltip = "Load a saved channel order. Has to be a .mat file containing a single vector with integers specifying the channel.";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.SetProbeInformationandContinueButton.Tooltip = "If you specified all aspects of your probe design press this button which adds probe info to the 'Extract Data' window to be able to start data extraction.";
                    app.ExtractDataWindow.ProbeLayoutWindow.ShowChannelSpacingCheckBox.Tooltip = "Click to show channel spacing on the zoomed channel on the right side."; 
                    
                    app.ExtractDataWindow.ProbeLayoutWindow.ReverseTopandBottomChannelNumberCheckBox.Tooltip = "Enabling this will flip channel 1 from the top to the bottom of the probe. It only changes the channel names and position of active channel as well as channelorders as can be seen in the plot, not how data is displayed (starts with top channel).";
                    app.ExtractDataWindow.ProbeLayoutWindow.ReverseTopandBottomChannelNumberCheckBox_2.Tooltip = "Enabling this will flip the extracted datset so that the first extracted channel becomes the last one and the last extracted channel becomes the first one. Note: Applied after the channelorder. Top channel in data analysis is always the top channel of the probe plot.";

                end
            end
        end
    end
    %% Probe View Main Window
    if strcmp(Window,"ProbeViewMainWindow") || strcmp(Window,"All")
        if ~isempty(app.ProbeViewWindowHandle) && isvalid(app.ProbeViewWindowHandle)
            if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
                app.ProbeViewWindowHandle.ChangeforWindowDropDown.Tooltip = "Select window for which channel changes are applied. Applying for multiple windows can decrease performance significantly.";
                app.ProbeViewWindowHandle.ChannelSelectionEditField.Tooltip = "Enter channel range to activate. Format: [1,10] meaning channel 1 to 10 are activated.";
                app.ProbeViewWindowHandle.ShowChannelSpacingCheckBox.Tooltip = "Click to show channel spacing on the zoomed channel on the right side.";
            end
        end
    end
    %% Live Spike Rate
    if strcmp(Window,"LiveSpikeRate") || strcmp(Window,"All")
        if ~isempty(app.PSTHApp) && isvalid(app.PSTHApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.PSTHApp.Slider.Tooltip = "Change number of bins for which spike rate is calculated. Warning: high number of bins for a small time window leads to artificially high spike rates. Bin size should not get too small.";
            app.PSTHApp.LockYLimCheckBox.Tooltip = "Enable to lock the ylimit to the biggest values found since opening this window. Useful when updating the main plot to keep track of amplitudes.";
            app.PSTHApp.DownsampleCheckBox.Tooltip = "Downsample then binned spike rate to reduce the effect of artificially high spike rate with low bin size. Alternatively reduce number of bins to increase bin size.";
        end
    end

    %% Live main window plot Power Estimate
    if strcmp(Window,"LivePowerEstimate") || strcmp(Window,"All")
        if ~isempty(app.SpectralEstApp) && isvalid(app.SpectralEstApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.SpectralEstApp.LockYLimCheckBox.Tooltip = "Enable to lock the ylimit to the biggest values found since opening this window. Useful when updating the main plot to keep track of amplitudes.";
            app.SpectralEstApp.DataTypeDropDown.Tooltip = "Select whether power is calculate for raw or preprocessed dataset.";
        end
    end
    %% Live CSD
    if strcmp(Window,"LiveCSD") || strcmp(Window,"All")
        if ~isempty(app.CSDApp) && isvalid(app.CSDApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.CSDApp.HammWindowEditField.Tooltip = "Change hamm window size applied to data to smooth results. Recommended to be smaller than 9 and odd.";
            app.CSDApp.LockCLimCheckBox.Tooltip = "Enable to lock the ylimit to the biggest values found since opening this window. Useful when updating the main plot to keep track of amplitudes.";
            app.CSDApp.DataTypeDropDown.Tooltip = "Select whether CSD is calculate for raw or preprocessed dataset.";
        end
    end

    %% Preprocessing Window
    if strcmp(Window,"Preprocessing") || strcmp(Window,"All")
        if ~isempty(app.PreproWindow) && isvalid(app.PreproWindow)
            if isprop(app.PreproWindow,'PreprocessingWindowUIFigure')
                %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
                app.PreproWindow.AddtoPipelineButton.Tooltip = "A pipeline with multiple preprocessing steps can be created. Click to add the method and settings above to the pipeline. Current pipeline components can be seen on the right.";
                app.PreproWindow.AddtoPipelineButton_2.Tooltip = "A pipeline with multiple preprocessing steps can be created. Click to add the method and settings above to the pipeline. Current pipeline components can be seen on the right.";
                app.PreproWindow.AddtoPipelineButton_3.Tooltip = "A pipeline with multiple preprocessing steps can be created. Click to add the method and settings above to the pipeline. Current pipeline components can be seen on the right.";
                app.PreproWindow.AddtoPipelineButton_4.Tooltip = "A pipeline with multiple preprocessing steps can be created. Click to add the method and settings above to the pipeline. Current pipeline components can be seen on the right.";
                
                app.PreproWindow.PlotExampleButton.Tooltip = "Press to plot a small time window of a channel in the middle of the recording channel range to see the effects of the method and settings above.";
                app.PreproWindow.PlotExampleButton_2.Tooltip = "Press to plot a small time window of a channel in the middle of the recording channel range to see the effects of the method and settings above.";
                app.PreproWindow.PlotExampleButton_4.Tooltip = "Press to plot a small time window of a channel in the middle of the recording channel range to see the effects of the method and settings above.";
                app.PreproWindow.PlotExampleButton_3.Tooltip = "Press to plot a small time window of a channel in the middle of the recording channel range to see the effects of the method and settings above.";
    
                app.PreproWindow.DeleteChannelButton.Tooltip = "Press to open a window in which you can select which channel to delete. Selection can be added to the current pipeline. Deletion is applied to raw and preprocessed dataset. Some dataset components might have to be calculated again.";
                app.PreproWindow.CutStartandEndofRecordingButton_2.Tooltip = "Press to open a window in which you can select time windows to delete. Selection can be added to the current pipeline. Deletion is applied to raw and preprocessed dataset. Some dataset components might have to be calculated again.";
                app.PreproWindow.StimulationArtefactRejectionButton.Tooltip = "Press to open a window in which you can interpolate stimulation artefacts. This requires you to extract event data for the stimulation first. Then you can interpolate in a time window around those events.";
                
                app.PreproWindow.DeleteLastPipelineEntryButton.Tooltip = "Press to delete the last pipeline component you added from the current pipeline.";
                
                app.PreproWindow.StartPipelineButton.Tooltip = "Press to apply all preprocessing steps of the current pipeline above to the raw dataset. This overwrites preprocessed data if it already exists! The order the steps are applied is the same as specified in the window above. After this finished you can view the preprocessed data in the main window.";
            end
        end
    end

    %% Continous Static Spectrum Analysis
    if strcmp(Window,"ConStaticSpectrum") || strcmp(Window,"All")
        if ~isempty(app.ContStaticSpectrumWindow) && isvalid(app.ContStaticSpectrumWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.ContStaticSpectrumWindow.AnalysisDropDown.Tooltip = "Change the type of analysis shown. 'Band Power Individual Channel' shows the pwelch spectrum for a single channel (or mean over all channel), while 'Band Power over Depth' shows the pwelch spectrum over all channel.";
            app.ContStaticSpectrumWindow.ChannelDropDown.Tooltip = "Change the channel for which the spectrum is shown. This is only enable when 'Band Power Individual Channel' is selected as analysis type. When spectrum over depth is plotted, channel selection in the 'Probe View window is applied!'";
            app.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Tooltip = "Change frequency range for which spectrum is shown. Format [1,100] for 1 to 100Hz.";

            app.ContStaticSpectrumWindow.DataTypeDropDown.Tooltip = "Select whether to show spectrum for a single channel or mean over all channel. Only enabled when 'Band Power Individual Channel' is selected as analysis type.";
            app.ContStaticSpectrumWindow.DataSourceDropDown.Tooltip = "Select whether spectrum is calculate for raw or preprocessed dataset.";
        end
    end

    %% Cont spike analysis
    if strcmp(Window,"ConSpikes") || strcmp(Window,"All")
        if ~isempty(app.ConInternalSpikesWindow) && isvalid(app.ConInternalSpikesWindow) || ~isempty(app.ConKilosortSpikesWindow) && isvalid(app.ConKilosortSpikesWindow)
            if ~isempty(app.ConInternalSpikesWindow) && isvalid(app.ConInternalSpikesWindow)
                app.ConInternalSpikesWindow.TypeofAnalysisDropDown.Tooltip = "Change analysis shown in the plot in the middle. When 'Spike Map' is selected, spikes are color coded based on amplitude of all currently shown spikes. When channel selection in the 'Probe View' window is changed, color coding can change too. 'Spike Triggered LFP' requires low pass filtered data, which can be done directly here. Just select it and see what happens. When selecting 'Average Waveforms Across Channel', waveforms for all spikes over all channel are extracted. For large numbers of spikes this can require a lot of RAM.";
                app.ConInternalSpikesWindow.ClustertoshowDropDown.Tooltip = "Select the unit/cluster shown in the analysis plots. 'All' will mark all units with a different color.";
                app.ConInternalSpikesWindow.EventstoshowDropDown.Tooltip = "Select whether you want to mark the time points of an event channel in the plot.";
                app.ConInternalSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "Change the number of bins for the spike rate plots. Note: high bin numbers and therefore low bin size can artificially increase spike rate!";
                
                app.ConInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "Time range to extract data from around each spike selected for the analysis (all spikes or unit spikes). High spike numbers and time windows rapidly decrease performance.";
                app.ConInternalSpikesWindow.WaveformSelectionforPlottingEditField.Tooltip = "Select the number of waveforms to show in the plot in the middle. Only applies when a waveform analysis type is selected. '100' will show the 100 biggest waveforms found for the spikes selected (all spikes or unit spikes).";
            else
                app.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Tooltip = "Change analysis shown in the plot in the middle. When 'Spike Map' is selected, spikes are color coded based on amplitude of all currently shown spikes. When channel selection in the 'Probe View' window is changed, color coding can change too. 'Spike Triggered LFP' requires low pass filtered data, which can be done directly here. Just select it and see what happens. When selecting 'Average Waveforms Across Channel', waveforms for all spikes over all channel are extracted. For large numbers of spikes this can require a lot of RAM.";
                app.ConKilosortSpikesWindow.ClustertoshowDropDown.Tooltip = "Select the unit/cluster shown in the analysis plots. 'All' will mark all units with a different color.";
                app.ConKilosortSpikesWindow.EventstoshowDropDown.Tooltip = "Select whether you want to mark the time points of an event channel in the plot.";
                app.ConKilosortSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "Change the number of bins for the spike rate plots. Note: high bin numbers and therefore low bin size can artificially increase spike rate!";
                
                app.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "Time range to extract data from around each spike selected for the analysis (all spikes or unit spikes). High spike numbers and time windows rapidly decrease performance.";
                app.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField.Tooltip = "Select the number of waveforms to show in the plot in the middle. Only applies when a waveform analysis type is selected. '100' will show the 100 biggest waveforms found for the spikes selected (all spikes or unit spikes).";
            end
        end
    end

    %% Extract Events window
    if strcmp(Window,"EventExtraction") || strcmp(Window,"All")
        if ~isempty(app.EventExtractionWindow) && isvalid(app.EventExtractionWindow) 
           
            app.EventExtractionWindow.RecordingSystem.Tooltip = "This shows the recording system determined when data was extracted.";
            app.EventExtractionWindow.FileTypeDropDown.Tooltip = "Depending on the recording system and file format you might have multipe event channel types. This can be analog or digital inputs lines as well as different recording nodes. To see which types contain your event data click the 'Plot Input Channel' button.";
            app.EventExtractionWindow.NrInputChinfolderEditField.Tooltip = "Nr of event input channel of the type specified above were found. 3 with 'Digital Inputs' selected above means that 3 different digital event channel were found. Depends on the recording system.";
            app.EventExtractionWindow.AnalogThresholdVEditField.Tooltip = "When your event data is present as a continous recording (unlike Open Ephys or Neuralynx recordings), a threshold has to be applied to determine the time points of the event onsets. If the signal exceeds this value, the time point is captured as a trigger.";
            app.EventExtractionWindow.InputChannelSelectionEditField.Tooltip = "Select which of the found input channel of the selected type you want to extract trigger from. [1,2,4,6] for digital input types means that the digital recording system input channel nr. 1,2,4 and 6 are scanned for trigger.";
            
            app.EventExtractionWindow.EventTypeDropDown.Tooltip = "Select whether to extract the rising or falling edge of a trigger. For Open Ephys event data, this corresponds to state 1 (rising edge) or 0 (falling edge).";

            app.EventExtractionWindow.LoadCostumeTriggerIdentityButton.Tooltip = "Click to open a window that allows to divide triggers in a single event input channel into multiple different event input channel. For example, 200 trigger in a single event channel each representing one of 4 different auditory stimulus frequency being played can be divided into 4 different channel, each for one frequency. Consequently, event related analysis can be coducted for each event channel individually.";

            app.EventExtractionWindow.SetFoldermanuallyButton.Tooltip = "Event channel data is auto-searched for in the folder the data was extracted from. When this folder does not contain your recording data or switched location, you can manually select a folder which contains your event data for the current recording.";
            app.EventExtractionWindow.PlotInputChannelButton.Tooltip = "To see which input channel types and numbers contain your event data and which threshold to use (if applicable), click this button to plot the event data over time. For Open Ephys time stamps, trigger data is represented as a continous data stream over time with the signal showing a 1 for each trigger time stamp plus 5ms after that. Inbetween triggers, signal is 0.";
            app.EventExtractionWindow.StartEventExtractionButton.Tooltip = "Press to start event extraction which the settings specified above. Once finsihed (with valid event times found) this enables the 'Exract Event Related Data' section below, which is necessary to analyse event related data.";

            app.EventExtractionWindow.DatatoUseDropDown.Tooltip = "Specify if event related data should be extracted from your raw or preprocessed dataset.";
            app.EventExtractionWindow.EventChanneltoUseDropDown.Tooltip = "Specify which event channel extracted above to use for event related data extraction.";
            app.EventExtractionWindow.TimeWindowAfterEventssEditField.Tooltip = "Time before each event in seconds to extract data from.";
            app.EventExtractionWindow.TimeWindowBeforeEventssEditField.Tooltip = "Time after each event in seconds to extract data from.";

            app.EventExtractionWindow.ExtractEventRelatedDataButton.Tooltip = "Start event related data extraction with the settings above. Once finished you can analyse event related LFP and spike data.";
           
        end
    end

    %% Import Events window
    if strcmp(Window,"ImportEvents") || strcmp(Window,"All")
        if ~isempty(app.ImportEventTTLWindow) && isvalid(app.ImportEventTTLWindow) 
           
            app.ImportEventTTLWindow.InputChannelSelectionEditField.Tooltip = "This shows the number of event channel found within the loaded file.";
            app.ImportEventTTLWindow.InputChannelSelectionEditField_2.Tooltip = "Here you can change the name of each of the event channel found in the loaded file that is eventually displayed in all GUI windows. At standard this shows the name of each event channel within the loaded file (see the textare to the right for information about the required format).";
            
            app.ImportEventTTLWindow.SelectFilecsvortxtButton.Tooltip = "Click to select a .csv or .txt file containing your trigger time stamps (in samples) for each event channel. See the text area above for more information about the required format.";
            app.ImportEventTTLWindow.PlotEventDataButton.Tooltip = "Click to see a plot of all trigger within each event channel found in the loaded file. Trigger data is represented as a continous data stream over time with the signal showing a 1 for each trigger time stamp plus 5ms after that. Inbetween triggers, signal is 0.";
            app.ImportEventTTLWindow.TakeasnewEventDataButton.Tooltip = "Press to start event extraction which the settings specified above. Once finsihed (with valid event times found) this enables the 'Exract Event Related Data' section below, which is necessary to analyse event related data.";


            app.ImportEventTTLWindow.DatatoUseDropDown.Tooltip = "Specify if event related data should be extracted from your raw or preprocessed dataset.";
            app.ImportEventTTLWindow.EventChanneltoUseDropDown.Tooltip = "Specify which event channel extracted above to use for event related data extraction.";
            app.ImportEventTTLWindow.TimeWindowAfterEventssEditField.Tooltip = "Time before each event in seconds to extract data from.";
            app.ImportEventTTLWindow.TimeWindowBeforeEventssEditField.Tooltip = "Time after each event in seconds to extract data from.";

            app.ImportEventTTLWindow.ExtractEventRelatedDataButton.Tooltip = "Start event related data extraction with the settings above. Once finished you can analyse event related LFP and spike data.";
        end
    end

    %% Event spike analysis
    if strcmp(Window,"EventSpikes") || strcmp(Window,"All")
        if ~isempty(app.EventInternalSpikesWindow) && isvalid(app.EventInternalSpikesWindow) || ~isempty(app.EventKilosortSpikesWindow) && isvalid(app.EventKilosortSpikesWindow)
            if ~isempty(app.EventInternalSpikesWindow) && isvalid(app.EventInternalSpikesWindow)
                app.EventInternalSpikesWindow.AnalysisTypeDropDown.Tooltip = "Change analysis shown in the plot in the middle. When 'Spike Map' is selected, spikes are color coded based on amplitude of all currently shown spikes. When channel selection in the 'Probe View' window is changed, color coding can change too. 'Spike Triggered LFP' requires low pass filtered data, which can be done directly here. Just select it and see what happens.";
                app.EventInternalSpikesWindow.ClustertoshowDropDown.Tooltip = "Select the unit/cluster shown in the analysis plots. 'All' will mark all units with a different color.";
                app.EventInternalSpikesWindow.BaselineNormalizeCheckBox.Tooltip = "Only when 'Spike Rate Heatmap' is selected as analysis. If activated, data will be baseline normalized using the time specified below as the baseline.";
                app.EventInternalSpikesWindow.BaselineWindowStartStopinsEditField.Tooltip = "Specify the time used as a basline in seconds. Format: [-0.2,0] for 200ms before the trigger to the trigger time at 0 seconds";
                
                app.EventInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "Time range to extract data from around each spike selected for the analysis (all spikes or unit spikes). High spike numbers and time windows rapidly decrease performance.";
                app.EventInternalSpikesWindow.EventRangeEditField.Tooltip = "Specify the number of events/trials for which data is shown. Format: [1,10] to show all spikes around event/trial times 1 to 10";
                app.EventInternalSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "Change the number of bins for the spike rate plots. Note: high bin numbers and therefore low bin size can artificially increase spike rate!";
            
            else
                app.EventKilosortSpikesWindow.AnalysisTypeDropDown.Tooltip = "Change analysis shown in the plot in the middle. When 'Spike Map' is selected, spikes are color coded based on amplitude of all currently shown spikes. When channel selection in the 'Probe View' window is changed, color coding can change too. 'Spike Triggered LFP' requires low pass filtered data, which can be done directly here. Just select it and see what happens.";
                app.EventKilosortSpikesWindow.ClustertoshowDropDown.Tooltip = "Select the unit/cluster shown in the analysis plots. 'All' will mark all units with a different color.";
                app.EventKilosortSpikesWindow.BaselineNormalizeCheckBox.Tooltip = "Only when 'Spike Rate Heatmap' is selected as analysis. If activated, data will be baseline normalized using the time specified below as the baseline.";
                app.EventKilosortSpikesWindow.BaselineWindowStartStopinsEditField.Tooltip = "Specify the time used as a basline in seconds. Format: [-0.2,0] for 200ms before the trigger to the trigger time at 0 seconds";
                
                app.EventKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "Time range to extract data from around each spike selected for the analysis (all spikes or unit spikes). High spike numbers and time windows rapidly decrease performance.";
                app.EventKilosortSpikesWindow.EventRangeEditField.Tooltip = "Specify the number of events/trials for which data is shown. Format: [1,10] to show all spikes around event/trial times 1 to 10";
                app.EventKilosortSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "Change the number of bins for the spike rate plots. Note: high bin numbers and therefore low bin size can artificially increase spike rate!";
            
            end
        end
    end

    %% Extract Spikes
    if strcmp(Window,"ExtractSpikes") || strcmp(Window,"All")
        if ~isempty(app.SpikeExtractionWindow) && isvalid(app.SpikeExtractionWindow) 
            app.SpikeExtractionWindow.DetectionMethodDropDown.Tooltip = "Change the thresholding method used to detect spikes.";
            app.SpikeExtractionWindow.ThresholdEditField.Tooltip = "The number of standard deviations the mean is substracted by to get the spike detection threshold.";
            app.SpikeExtractionWindow.MeanDropDown.Tooltip = "Specify whether the mean and standard deviation is calculated for each channel individually or for all channel together.";
            app.SpikeExtractionWindow.FilterVerticalSpikeArtefactsCheckBox.Tooltip = "Enable to reject spike artefacts that occur during the same time +/- a number of samples over a certain depth. Number of samples and minimum depth over which artefacts have to occur can be specified in the fields below.";
            
            app.SpikeExtractionWindow.FilterDoubleSpikeIndiciesCheckBox.Tooltip = "In recordings with low snr, multiple spike indicies can be detected within the same spike waveform due to fast changing threshold crossings. Enabling this combines all spike times found within the time range specified and just retains the indicie of the peak amplitude value.";
            app.SpikeExtractionWindow.VerticalSpikeOffsetToleranceSamplesEditField.Tooltip = "Number of samples the spike times can deviate to still count as a potential vertical artefact.";
            app.SpikeExtractionWindow.MinDepthofArtefactmEditField.Tooltip = "Minimum depth over which spikes within the same time +/- the specified amount of samples have to occur to count as a artefact. With a channel spacing of 20um and 200um specified in this field, the spike times have to be the same over at least 10 consecutive channel.";
            
            app.SpikeExtractionWindow.TimeOffsettoCombineSpikeIndiciessEditField.Tooltip = "Time range in seconds for which spike times get combined when inside the same waveform.";
            app.SpikeExtractionWindow.StartSpikeDetectionButton.Tooltip = "This will start the spike extraction and enable you to cluster the detected spikes using Wave_clus 3 in the section below. It also enables to open all spike analysis windows. Spike sorters other than Wave_Clus 3 do not need and use the spike detection results!";

            app.SpikeExtractionWindow.OptionsDropDown_2.Tooltip = "Change which action you want to execute using the 'Run' button below. When 'Load Sorting Results' is selected check in the right if cluster results you might already have were autodetected. If you saved the clustering results in a different folder to the one checked for autodetection, select a folder manually by selecting 'Manually Select Folder with Sorting Results'.";
            app.SpikeExtractionWindow.SortallChannelTogetherCheckBox.Tooltip = "Combines all spike times together to do a channel independent analysis using waveclus.";
            app.SpikeExtractionWindow.SortforIndividualChannelCheckBox.Tooltip = "Applies waveclus clustering to spikes of each channel individually.";
            app.SpikeExtractionWindow.RUNButton_2.Tooltip = "Execute the option you specified on the left for the selected sorter.";

            app.SpikeExtractionWindow.Label.Tooltip = "When required files for Kilosort, Mountainsort or Spykingcircus (.bin file of recording) were found in auto-searched or manually selected folder, this turns green and shows the corresponding message. If Wave_Clus3 is selected as sorter, a spike_times-mat files is searched for.";
            app.SpikeExtractionWindow.SetOutputFolderManuallyButton.Tooltip = "Applies waveclus clustering to spikes of each channel individually.";
        end
    end

    %% Manage Modules window
    if strcmp(Window,"ManageModuleWindow") || strcmp(Window,"All")
        if ~isempty(app.ManageModulesWindow) && isvalid(app.ManageModulesWindow) 
           
            app.ManageModulesWindow.SelectCheckBox_2.Tooltip = "Activate to mark the module on the left as the one to be switched out with the one selected in the dropdown menu on the right.";
            app.ManageModulesWindow.SelectCheckBox_3.Tooltip = "Activate to mark the module on the left as the one to be switched out with the one selected in the dropdown menu on the right.";
            app.ManageModulesWindow.SelectCheckBox_4.Tooltip = "Activate to mark the module on the left as the one to be switched out with the one selected in the dropdown menu on the right.";
            app.ManageModulesWindow.SelectCheckBox_5.Tooltip = "Activate to mark the module on the left as the one to be switched out with the one selected in the dropdown menu on the right.";
            
            app.ManageModulesWindow.ListBox_5.Tooltip = "Currently active module in the main window that can be replaced by a different module.";
            app.ManageModulesWindow.ListBox_4.Tooltip = "Currently active module in the main window that can be replaced by a different module.";
            app.ManageModulesWindow.ListBox_2.Tooltip = "Currently active module in the main window that can be replaced by a different module.";
            app.ManageModulesWindow.ListBox.Tooltip = "Currently active module in the main window that can be replaced by a different module.";
            
            app.ManageModulesWindow.SelectedModuleDropDown.Tooltip = "Selection of all modules added to the GUI (all specified in 'All_Mdoule_Items.m'). Pick one that should replace the module on the left you marked.";
            app.ManageModulesWindow.SwitchandApplytoMainWindowButton.Tooltip = "Click to exchange the module you marked on the left with the module selected in the dropdown menu on the right and apply this change to the main window.";
            app.ManageModulesWindow.CreateNewModuleButton.Tooltip = "Opens the 'All_Mdoule_Items.m' function which holds information about all active modules. To add your own, add a new cell and specify the module names. Then add the name of a function you want to execute when the user presses the RUN button - thats it!";
            app.ManageModulesWindow.SetasnewdefaultButton.Tooltip = "Set the current modules arrangement as the new standard, which means that it will be applied on startup of the main window and doesnt has to be configured again.";
            app.ManageModulesWindow.RestoreStandardButton.Tooltip = "Restores the standard module order of the main window as it is out of the box.";
            
        end
    end

    %% Autorun Manager window
    if strcmp(Window,"AutorunWindow") || strcmp(Window,"All")
        if ~isempty(app.AutorunWindow) && isvalid(app.AutorunWindow) 
           
            app.AutorunWindow.AddNewConfigButton.Tooltip = "Autorun requires a config file that contains all necessary analysis parameter. Add a new config here. You are prompted to select a template as a starting point which you can then edit as you want.";
            app.AutorunWindow.SelectdifferentConfigFolderButton.Tooltip = "The configs you can select from are auto-searched for in the folder 'GUI_Patch/Autorun Configs\Config_Files'. If you saved your config(s) somewhere else, select the folder by clicking this button.";
            app.AutorunWindow.ConfigSelectedDropDown.Tooltip = "All config files found in the auto-searched folder. The config you select here is used for the autorun!";
            app.AutorunWindow.ShowConfiginGUIButton.Tooltip = "Click to open the currently selected config in a app window to see and modify all settings.";
            app.AutorunWindow.ShowConfiginMatlabButton.Tooltip = "Click to open the Matlab function of the currently selected config to see and modify all settings.";

            app.AutorunWindow.LoopovermultiplefolderCheckBox.Tooltip = "When activated, the GUI expects multiple recording folder in the selected folder to loop over them. Every analysis parameter specified in the Config will be applied to every recording. Inactivate to only analyse a single recording (then only folder containing a single recording are allowed!)";
            app.AutorunWindow.FoldertoskipEditField.Tooltip = "Skip the first n-number of recordings found in the selected folder. Useful when previous autorun attempt failed or config had to be changed without wanting to go through the already analyzed folder again.";
            app.AutorunWindow.PictureFormatDropDown.Tooltip = "All analysis visualizations of the GUI are also available in the Autorun. With the difference that visualizations are saved as images for the autorun. Select the format of the analysis pictures the autorun saves in the recording folder.";
            
            app.AutorunWindow.SaveAnalysisFiguresCheckBox.Tooltip = "Activate to save all analysis images in the reording folder and format specified.";
            app.AutorunWindow.CloseFiguresafterPlottingCheckBox.Tooltip = "When looping over a lot of recordings with a lot of different analysis, iot can create a lot of figures. Activate to close figures after they were saved. ";
            app.AutorunWindow.ProbeDesignButton.Tooltip = "Click to specify probe information necessary to start data extraction. This is the same as for normal data extraction in the GUI.";
            app.AutorunWindow.SelectFolderButton.Tooltip = "Either select a folder containing multiple recordings, each in their own folder or a folder with a single recording.";
            app.AutorunWindow.ExecuteSelectedConfigButton.Tooltip = "Click to start the autorun config with the selected settings and folders. Progress can be seen in the Matlab command window.";
        end
    end

    %% Sorting parameter window
    if strcmp(Window,"SortingParameterWindow") || strcmp(Window,"All")
        if ~isempty(app.SpikeExtractionWindow) && isvalid(app.SpikeExtractionWindow)
            if ~isempty(app.SpikeExtractionWindow.SortingParameterWindow) && isvalid(app.SpikeExtractionWindow.SortingParameterWindow)
                app.SpikeExtractionWindow.SortingParameterWindow.OpenSpikeInterfaceGUIaftersortingCheckBox.Tooltip = "When sorting finshed, automatically open the SpikeInterface GUI to see the sorting results. In order to be able to proceed with the Matlab GUI, you have to close the SpikeInterface GUI and press 'Enter' in the Python and Matlab console to continue when the 'Keep Python Console Open when Finishied' option is set to on.";
                app.SpikeExtractionWindow.SortingParameterWindow.LoadSpikeSortingCheckBox.Tooltip = "When data was already sorted with the selected sorter, you can simply load the results to avoid sorting again.";
                app.SpikeExtractionWindow.SortingParameterWindow.PreprocessDataBandPassandWhiteningCheckBox.Tooltip = "Specify whether data should be preprocessed before sorting using SpikeInterface (seto to on) or if data should be preprocessed in the specified sorter itself (set to off).";
                app.SpikeExtractionWindow.SortingParameterWindow.LoopovermultipleRecordingsCheckBox.Tooltip = "When selecting this, you can run the sorting over all recording folders within a folder you select automatically. For this dont select a folder with a single .bin file. but a folder with subfolders being the recording folder. The .bin files have to be saved in a folder called 'SpikeInterface' in the recording folder.";
                app.SpikeExtractionWindow.SortingParameterWindow.KeepConsoleOpen.Tooltip = "When enabled, the python console will stay opened after the script finished to enable to see through the information. You have to press enter in the python and Matlab console to be able to continue with this GUI.";
                app.SpikeExtractionWindow.SortingParameterWindow.PlotTracesCheckBox.Tooltip = "When enabled, raw vs. preprocessed data streams along with the probe design will be plotted. You have to close these plots to continue the sorting.";
                app.SpikeExtractionWindow.SortingParameterWindow.PlotsomesortingresultsCheckBox.Tooltip = "When enabled, spike trains and some unit analysis plots with the shown. You have to close these plots to continue the sorting.";
                
                app.SpikeExtractionWindow.SortingParameterWindow.LoadSavedParameterDropDown.Tooltip = "Select previously saved sorting parameter to load.";
                app.SpikeExtractionWindow.SortingParameterWindow.TextArea.Tooltip = "Change sorting paramter here! Only change the values behind the ':', not the variable name!";
                app.SpikeExtractionWindow.SortingParameterWindow.SaveSettingsButton.Tooltip = "Save all currently set sorting parameter to be able to load later.";
                app.SpikeExtractionWindow.SortingParameterWindow.RestoreDefaultButton.Tooltip = "When pressed, the standard sorting parameter are restored.";
                app.SpikeExtractionWindow.SortingParameterWindow.SetNewSettingsandContinueButton.Tooltip = "Press this button to confrim the changes you made and proceed in the 'Spike Detection and Sorting' window.";
                
            end
        end
    end

    %% Manage Dataset Window
    if strcmp(Window,"ManageDataset") || strcmp(Window,"All")
        if ~isempty(app.Manage_Dataset_ComponentsWindow) && isvalid(app.Manage_Dataset_ComponentsWindow)
            app.Manage_Dataset_ComponentsWindow.DropDown.Tooltip = "Select the dataset component you want to delete or save. Raw data, Time and Info fields cannot be deleted since they are necessary for this GUI to work.";
        end
    end

    %% LIVE ECHT
    if strcmp(Window,"LiveECHT") || strcmp(Window,"All")
        if ~isempty(app.LiveECHTWindow) && isvalid(app.LiveECHTWindow)
            
            app.LiveECHTWindow.ChannelSelectionDropDown.Tooltip = "Select the channel for which you want to compute the ECHT";
        end
    end

    %disp("Tooltips turned ON");

else % Not activated
    %% Main Window
    if strcmp(Window,"MainWindow") || strcmp(Window,"All")
        app.TimeRangeViewBox.Tooltip= "";
        app.Button.Tooltip = "";
        app.Button_2.Tooltip = "";
    
        app.Button_3.Tooltip = "";
        app.Button_4.Tooltip = "";
    
        app.PlayButton.Tooltip = "";
        app.PauseButton.Tooltip = "";
    
        app.OpenProbeViewButton.Tooltip = "";
        app.Slider.Tooltip = "";
    
        app.DropDown.Tooltip = "";
        app.DropDown_2.Tooltip = "";
    
        app.EventChannelDropDown.Tooltip = "";
    end

    %% Extract Data window
    if strcmp(Window,"ExtractDataWindow") || strcmp(Window,"All")
        if ~isempty(app.ExtractDataWindow) && isvalid(app.ExtractDataWindow)
            app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.ExtractDataWindow.RecordingSystemDropDown.Tooltip = "";
            app.ExtractDataWindow.FileTypeDropDown.Tooltip = "";
            app.ExtractDataWindow.AdditionalAmplificationFactorEditField.Tooltip = "";
            app.ExtractDataWindow.AddProbeInformationButton.Tooltip = "";
  
            app.ExtractDataWindow.ExtractDataButton.Tooltip = "";
        end
    end
    %% Probe Layout Window
    if strcmp(Window,"SetProbeInfoWindow") || strcmp(Window,"All")
        if ~isempty(app.ExtractDataWindow) && isvalid(app.ExtractDataWindow)
            if ~isempty(app.ExtractDataWindow.ProbeLayoutWindow)
                if isprop(app.ExtractDataWindow.ProbeLayoutWindow,'ProbeLayoutWindowUIFigure')
                    app.ExtractDataWindow.ProbeLayoutWindow.NrChannelEditField.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelSpacingumEditField.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelRowsDropDown.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.HorizontalOffsetumEditField.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.VerticalOffsetumEditField.Tooltip = "";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.ActiveChannelField.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelOrderField.Tooltip = "";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadChannelOrderButton.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadActiveChannelSelectionButton.Tooltip = "";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.SetProbeInformationandContinueButton.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.ShowChannelSpacingCheckBox.Tooltip = "";
                end
            end
        end
    end
    %% Probe View Main Window
    if strcmp(Window,"ProbeViewMainWindow") || strcmp(Window,"All")
        if ~isempty(app.ProbeViewWindowHandle) && isvalid(app.ProbeViewWindowHandle)
            if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
                app.ProbeViewWindowHandle.ChangeforWindowDropDown.Tooltip = "";
                app.ProbeViewWindowHandle.ChannelSelectionEditField.Tooltip = "";
                app.ProbeViewWindowHandle.ShowChannelSpacingCheckBox.Tooltip = "";
            end
        end
    end
    %% Live Spike Rate
    if strcmp(Window,"LiveSpikeRate") || strcmp(Window,"All")
        if ~isempty(app.PSTHApp) && isvalid(app.PSTHApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.PSTHApp.Slider.Tooltip = "";
            app.PSTHApp.LockYLimCheckBox.Tooltip = "";
            app.PSTHApp.DownsampleCheckBox.Tooltip = "";
        end
    end
    %% Live main window plot Power Estimate
    if strcmp(Window,"LivePowerEstimate") || strcmp(Window,"All")
        if ~isempty(app.SpectralEstApp) && isvalid(app.SpectralEstApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.SpectralEstApp.LockYLimCheckBox.Tooltip = "";
            app.SpectralEstApp.DataTypeDropDown.Tooltip = "";
        end
    end
    %% Live CSD
    if strcmp(Window,"LiveCSD") || strcmp(Window,"All")
        if ~isempty(app.CSDApp) && isvalid(app.CSDApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.CSDApp.HammWindowEditField.Tooltip = "";
            app.CSDApp.LockCLimCheckBox.Tooltip = "";
            app.CSDApp.DataTypeDropDown.Tooltip = "";
        end
    end

    %% Preprocessing Window
    if strcmp(Window,"Preprocessing") || strcmp(Window,"All")
        if ~isempty(app.PreproWindow) && isvalid(app.PreproWindow)
            app.PreproWindow.AddtoPipelineButton.Tooltip = "";
            app.PreproWindow.AddtoPipelineButton_2.Tooltip = "";
            app.PreproWindow.AddtoPipelineButton_3.Tooltip = "";
            app.PreproWindow.AddtoPipelineButton_4.Tooltip = "";
            
            app.PreproWindow.PlotExampleButton.Tooltip = "";
            app.PreproWindow.PlotExampleButton_2.Tooltip = "";
            app.PreproWindow.PlotExampleButton_4.Tooltip = "";
            app.PreproWindow.PlotExampleButton_3.Tooltip = "";

            app.PreproWindow.DeleteChannelButton.Tooltip = "";
            app.PreproWindow.CutStartandEndofRecordingButton_2.Tooltip = "";
            app.PreproWindow.StimulationArtefactRejectionButton.Tooltip = "";
            
            app.PreproWindow.DeleteLastPipelineEntryButton.Tooltip = "";
            
            app.PreproWindow.StartPipelineButton.Tooltip = "";
        end
    end

    %% Continous Static Spectrum Analysis
    if strcmp(Window,"ConStaticSpectrum") || strcmp(Window,"All")
        if ~isempty(app.ContStaticSpectrumWindow) && isvalid(app.ContStaticSpectrumWindow)
            app.ContStaticSpectrumWindow.AnalysisDropDown.Tooltip = "";
            app.ContStaticSpectrumWindow.ChannelDropDown.Tooltip = "";
            app.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Tooltip = "";

            app.ContStaticSpectrumWindow.DataTypeDropDown.Tooltip = "";
            app.ContStaticSpectrumWindow.DataSourceDropDown.Tooltip = "";
        end
    end

    if strcmp(Window,"ConSpikes") || strcmp(Window,"All")
        if ~isempty(app.ConInternalSpikesWindow) && isvalid(app.ConInternalSpikesWindow) || ~isempty(app.ConKilosortSpikesWindow) && isvalid(app.ConKilosortSpikesWindow)
            if ~isempty(app.ConInternalSpikesWindow) && isvalid(app.ConInternalSpikesWindow)
                app.ConInternalSpikesWindow.TypeofAnalysisDropDown.Tooltip = "";
                app.ConInternalSpikesWindow.ClustertoshowDropDown.Tooltip = "";
                app.ConInternalSpikesWindow.EventstoshowDropDown.Tooltip = "";
                app.ConInternalSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "";
                
                app.ConInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "";
                app.ConInternalSpikesWindow.WaveformSelectionforPlottingEditField.Tooltip = "";
            else
                app.ConKilosortSpikesWindow.TypeofAnalysisDropDown.Tooltip = "";
                app.ConKilosortSpikesWindow.ClustertoshowDropDown.Tooltip = "";
                app.ConKilosortSpikesWindow.EventstoshowDropDown.Tooltip = "";
                app.ConKilosortSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "";
                
                app.ConKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "";
                app.ConKilosortSpikesWindow.WaveformSelectionforPlottingEditField.Tooltip = "";
            end
        end
    end
    
    %% Extract Events window
    if strcmp(Window,"EventExtraction") || strcmp(Window,"All")
        if ~isempty(app.EventExtractionWindow) && isvalid(app.EventExtractionWindow) 
           
            app.EventExtractionWindow.RecordingSystem.Tooltip = "";
            app.EventExtractionWindow.FileTypeDropDown.Tooltip = "";
            app.EventExtractionWindow.NrInputChinfolderEditField.Tooltip = "";
            app.EventExtractionWindow.AnalogThresholdVEditField.Tooltip = "";
            app.EventExtractionWindow.InputChannelSelectionEditField.Tooltip = "";

            app.EventExtractionWindow.SetFoldermanuallyButton.Tooltip = "";
            app.EventExtractionWindow.PlotInputChannelButton.Tooltip = "";
            app.EventExtractionWindow.StartEventExtractionButton.Tooltip = "";

            app.EventExtractionWindow.DatatoUseDropDown.Tooltip = "";
            app.EventExtractionWindow.EventChanneltoUseDropDown.Tooltip = "";
            app.EventExtractionWindow.TimeWindowAfterEventssEditField.Tooltip = "";
            app.EventExtractionWindow.TimeWindowBeforeEventssEditField.Tooltip = "";

            app.EventExtractionWindow.ExtractEventRelatedDataButton.Tooltip = "";

        end
    end

    %% Event spike analysis
    if strcmp(Window,"EventSpikes") || strcmp(Window,"All")
        if ~isempty(app.EventInternalSpikesWindow) && isvalid(app.EventInternalSpikesWindow) || ~isempty(app.EventKilosortSpikesWindow) && isvalid(app.EventKilosortSpikesWindow)
            if ~isempty(app.EventInternalSpikesWindow) && isvalid(app.EventInternalSpikesWindow)
                app.EventInternalSpikesWindow.AnalysisTypeDropDown.Tooltip = "";
                app.EventInternalSpikesWindow.ClustertoshowDropDown.Tooltip = "";
                app.EventInternalSpikesWindow.BaselineNormalizeCheckBox.Tooltip = "";
                app.EventInternalSpikesWindow.BaselineWindowStartStopinsEditField.Tooltip = "";
                
                app.EventInternalSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "";
                app.EventInternalSpikesWindow.EventRangeEditField.Tooltip = "";
                app.EventInternalSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "";
            
            else
                app.EventKilosortSpikesWindow.AnalysisTypeDropDown.Tooltip = "";
                app.EventKilosortSpikesWindow.ClustertoshowDropDown.Tooltip = "";
                app.EventKilosortSpikesWindow.BaselineNormalizeCheckBox.Tooltip = "";
                app.EventKilosortSpikesWindow.BaselineWindowStartStopinsEditField.Tooltip = "";
                
                app.EventKilosortSpikesWindow.TimeWindowSpiketriggredLFPEditField.Tooltip = "";
                app.EventKilosortSpikesWindow.EventRangeEditField.Tooltip = "";
                app.EventKilosortSpikesWindow.SpikeRateNumBinsEditField.Tooltip = "";
            
            end
        end
    end

    %% Extract Spikes
    if strcmp(Window,"ExtractSpikes") || strcmp(Window,"All")
        if ~isempty(app.SpikeExtractionWindow) && isvalid(app.SpikeExtractionWindow) 
            app.SpikeExtractionWindow.DetectionMethodDropDown.Tooltip = "";
            app.SpikeExtractionWindow.ThresholdEditField.Tooltip = "";
            app.SpikeExtractionWindow.MeanDropDown.Tooltip = "";
            app.SpikeExtractionWindow.FilterVerticalSpikeArtefactsCheckBox.Tooltip = "";
            
            app.SpikeExtractionWindow.FilterDoubleSpikeIndiciesCheckBox.Tooltip = "";
            app.SpikeExtractionWindow.VerticalSpikeOffsetToleranceSamplesEditField.Tooltip = "";
            app.SpikeExtractionWindow.MinDepthofArtefactmEditField.Tooltip = "";
            
            app.SpikeExtractionWindow.TimeOffsettoCombineSpikeIndiciessEditField.Tooltip = "";
            app.SpikeExtractionWindow.StartSpikeDetectionButton.Tooltip = "";

            app.SpikeExtractionWindow.OptionsDropDown_2.Tooltip = "";
            app.SpikeExtractionWindow.SortallChannelTogetherCheckBox.Tooltip = "";
            app.SpikeExtractionWindow.SortforIndividualChannelCheckBox.Tooltip = "";
            app.SpikeExtractionWindow.RUNButton_2.Tooltip = "";

            app.SpikeExtractionWindow.Label.Tooltip = "";
            app.SpikeExtractionWindow.SetOutputFolderManuallyButton.Tooltip = "";
        end
    end

    %% Manage Modules window
    if strcmp(Window,"ManageModuleWindow") || strcmp(Window,"All")
        if ~isempty(app.ManageModulesWindow) && isvalid(app.ManageModulesWindow) 
           
            app.ManageModulesWindow.SelectCheckBox_2.Tooltip = "";
            app.ManageModulesWindow.SelectCheckBox_3.Tooltip = "";
            app.ManageModulesWindow.SelectCheckBox_4.Tooltip = "";
            app.ManageModulesWindow.SelectCheckBox_5.Tooltip = "";
            
            app.ManageModulesWindow.ListBox_5.Tooltip = "";
            app.ManageModulesWindow.ListBox_4.Tooltip = "";
            app.ManageModulesWindow.ListBox_2.Tooltip = "";
            app.ManageModulesWindow.ListBox.Tooltip = "";
            
            app.ManageModulesWindow.SelectedModuleDropDown.Tooltip = "";
            app.ManageModulesWindow.SwitchandApplytoMainWindowButton.Tooltip = "";
            app.ManageModulesWindow.CreateNewModuleButton.Tooltip = "";
            app.ManageModulesWindow.SetasnewdefaultButton.Tooltip = "";
            app.ManageModulesWindow.RestoreStandardButton.Tooltip = "";
            
        end
    end

    %% Autorun Manager window
    if strcmp(Window,"AutorunWindow") || strcmp(Window,"All")
        if ~isempty(app.AutorunWindow) && isvalid(app.AutorunWindow) 
           
            app.AutorunWindow.AddNewConfigButton.Tooltip = "";
            app.AutorunWindow.SelectdifferentConfigFolderButton.Tooltip = "";
            app.AutorunWindow.ConfigSelectedDropDown.Tooltip = "";
            app.AutorunWindow.ShowConfiginGUIButton.Tooltip = "";
            app.AutorunWindow.ShowConfiginMatlabButton.Tooltip = "";

            app.AutorunWindow.LoopovermultiplefolderCheckBox.Tooltip = "";
            app.AutorunWindow.FoldertoskipEditField.Tooltip = "";
            app.AutorunWindow.PictureFormatDropDown.Tooltip = "";
            
            app.AutorunWindow.SaveAnalysisFiguresCheckBox.Tooltip = "";
            app.AutorunWindow.CloseFiguresafterPlottingCheckBox.Tooltip = "";
            app.AutorunWindow.ProbeDesignButton.Tooltip = "";
            app.AutorunWindow.SelectFolderButton.Tooltip = "";
            app.AutorunWindow.ExecuteSelectedConfigButton.Tooltip = "";
            
        end
    end

    %% Sorting parameter window
    if strcmp(Window,"SortingParameterWindow") || strcmp(Window,"All")
        if ~isempty(app.SpikeExtractionWindow) && isvalid(app.SpikeExtractionWindow)
            if ~isempty(app.SpikeExtractionWindow.SortingParameterWindow) && isvalid(app.SpikeExtractionWindow.SortingParameterWindow)
                app.SpikeExtractionWindow.SortingParameterWindow.OpenSpikeInterfaceGUIaftersortingCheckBox.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.LoadSpikeSortingCheckBox.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.PreprocessDataBandPassandWhiteningCheckBox.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.LoopovermultipleRecordingsCheckBox.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.KeepConsoleOpen.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.PlotTracesCheckBox.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.PlotsomesortingresultsCheckBox.Tooltip = "";
                
                app.SpikeExtractionWindow.SortingParameterWindow.LoadSavedParameterDropDown.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.TextArea.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.SaveSettingsButton.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.RestoreDefaultButton.Tooltip = "";
                app.SpikeExtractionWindow.SortingParameterWindow.SetNewSettingsandContinueButton.Tooltip = "";
                
            end
        end
    end

    %% Manage Dataset Window
    if strcmp(Window,"ManageDataset") || strcmp(Window,"All")
        if ~isempty(app.Manage_Dataset_ComponentsWindow) && isvalid(app.Manage_Dataset_ComponentsWindow)
            app.Manage_Dataset_ComponentsWindow.DropDown.Tooltip = "";
        end
    end

    %% LIVE ECHT
    if strcmp(Window,"LiveECHT") || strcmp(Window,"All")
        if ~isempty(app.LiveECHTWindow) && isvalid(app.LiveECHTWindow)
            app.LiveECHTWindow.DownsampledSampleRateHzEditField.Tooltip = "";
            app.LiveECHTWindow.CenterFrequencyHzEditField.Tooltip = "";
            app.LiveECHTWindow.ChannelSelectionDropDown.Tooltip = "";
        end
    end


end
