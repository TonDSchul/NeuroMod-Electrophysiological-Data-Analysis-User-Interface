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

%Organize_Delete_All_Open_Windows(app,0);

if Activated
    %% Main Window
    if strcmp(Window,"MainWindow") || strcmp(Window,"All")
        app.TimeRangeViewBox.Tooltip = "Edit to change plotted time; Format: Number followed by a 's' i.e. 1s.";
        app.Button.Tooltip = "Click to increase plotted time by the time specified in 'Time to Manipulate Main Plot' dropdown menu.";
        app.Button_2.Tooltip = "Click to decrease plotted time by the time specified in 'Time to Manipulate Main Plot' dropdown menu.";
    
        app.Button_3.Tooltip = "Click to go forward in time by the time specified in 'Time to Manipulate Main Plot' dropdown menu. Alternatively press the right arrow key.";
        app.Button_4.Tooltip = "Click to go backwards in time by the time specified in 'Time to Manipulate Main Plot' dropdown menu. Alternatively press the left arrow key.";
    
        app.PlayButton.Tooltip = "Click to start play data as a movie. Right click to change plotting/playback speed.";
        app.PauseButton.Tooltip = "Click to stop playing data as a movie.";
    
        app.OpenProbeViewButton.Tooltip = "Click to open probe view window to manipulate channel selection.";
        app.Slider.Tooltip = "Click to change spacing inbetween plotted data lines; Right click to change limits. Alternatively press the up or down arrow keys.";
    
        app.DropDown.Tooltip = "Select data type plotted. When data was preprocessed, the option 'Preprocessed Data' will appear.";
        app.DropDown_2.Tooltip = "Select addons to plot like spikes and events. These get available to select when the respective data part was extracted.";
        
        app.EventChannelDropDown.Tooltip = "Select the event channel for which trigger times are plotted in the main window. Is populated ones events are extracted.";

        app.TextArea.Tooltip = "See all additional information about your recording. This includes info about extracted data, preprocessing, spike and event detection and so on for later referencing.";
    end
    
    %% Extract Data window
    if strcmp(Window,"ExtractDataWindow") || strcmp(Window,"All")
        if ~isempty(app.ExtractDataWindow) && isvalid(app.ExtractDataWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.ExtractDataWindow.RecordingSystemDropDown.Tooltip = "If folder with a supported format was selected and detected, this shows the detected format.";
            app.ExtractDataWindow.FileTypeDropDown.Tooltip = "Some formats can have multiple datasets (i.e. differrent recording nodes for OE recordings) that can be selected and extracted individually.";
            app.ExtractDataWindow.AdditionalAmplificationFactorEditField.Tooltip = "If additional amplification after the headstage (not save in recording data) took place. Raw dataset gets multiplied by this factor.";
            app.ExtractDataWindow.AddProbeInformationButton.Tooltip = "Click to specify probe information necessary to start data extraction. Alternatively load saved probe information using the menu above.";
            app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder containing ONE recording of the supported formats. If the GUI, NEO or SpikeInterface have problems detecting a specific recording format in the selected folder, consider deleting all files and folders within the recording folder that are not created by the recording software. To load and analyse multiple recordings one after another consider using the Autorun function of this GUI (see menu in main window). NOTE: For Open Ephys recordings, select the folder containing the recording node(s) folder(s).";
            app.ExtractDataWindow.ExtractDataButton.Tooltip = "Only if folder and probe information was specified.";
            
            app.ExtractDataWindow.FormatToSaveandReadintoMatlabDropDown.Tooltip = "When using the NEO library to extract recording data, the extracted data within python is saved and loaded into Matlab. The format it is saved in is a costum .dat and .mat file format OR the .mat format NEO officially supplies a function for to save in. In practice this makes no difference except that the costum format can handle larger recordings (when trying to save too much data in a .mat file you will get the error: Python int too large to convert to C long). On the other hand, the NEO created .mat file contains all NEO meta-data, not only the necessary ones to run NeuroMod like in the costum format.";
            app.ExtractDataWindow.Save_Probe_SpikeInterface.Tooltip = "Since the probe design (mapping) is extracted using SpikeInterface, you have to specify whether you want to save it while data is extracted. Save location is the folder data is saved in after data extraction (parent folder of recording folder/{Recording name} SpikeInterface SaveFile)";
            
            app.ExtractDataWindow.AdditionalAmplificationFactorEditField.Tooltip = "Choose which channel to extract from all available amplifier channel in the recording. Must be as many channel as active channel specified. Although active channel only determine channel within the probe being active, not the how manythed channel is extracted. If you have 9 channel and want to extract only 3, enter '1:3' with a probe design with 9 channel and 3 active channel or 3 channel and 3 active channel.";
            app.ExtractDataWindow.RecordingSystemDropDown_2.Tooltip = "Select which code based you want to use to extract your recording data. The Neuroensemble NEO library is a python package  which supports other file formats than NeuroMod does natively and can be used with a few clicks and installations. See the README file for more information. Use NEO for Neuralynx, Plexon, Blackrock and NeuroExplorer recordings. Open Ephys recordings are supported by NeuroMod and NEO, so you can choose. For all other supported recording formats use Neuromod.";
            app.ExtractDataWindow.KeepConsoleOpen_2.Tooltip = "When you already extracted a recording with NEO, NeuroMod saves the channel and metadata in a new folder. Those can be directly loaded without having to access NEO, greatly increasing loading speed when loading multiple times.";
            app.ExtractDataWindow.KeepConsoleOpen.Tooltip = "Activate to keep the python console that opens when using NEO open to see progress of the data extraction and if some error occurs, like NEO being unable to find a supported format in the selected folder/file.";
            
            app.ExtractDataWindow.AdditionalAmplificationFactorEditField_2.Tooltip = "Specify which channel are extract from the raw recording. This is done BEFORE applying a channel order, so channel numbers are for the order of channel in the raw recording, not a user defined channel order. Format: 'All' to extract all channel, otherwise Matlab expressions like [1,2,3,5]. If you want to use the NEO library and enable the checkbox 'Load already saved .dat file', this field is automatically populated with the value set when extracting the recording. Its is requiring the saved NEO_Saved_MetaData.mat file saved in the same folder as the .dat file from NEO data extraction.";
            app.ExtractDataWindow.AdditionalAmplificationFactorEditField_3.Tooltip = "Specify time range to extract from the raw recording. Format: 'from,to' in seconds like '0,Inf' for the whole time range or '0,10' for the first ten seconds. NOTE: For Open Ephys recordings, multiple acquisition starts within one recording node can be combined to a single recording. Time to extract is taken from EVERY recording acquisition period. With two recordings and time to extract = '1,10', 20 seconds are extracted. If you want to use the NEO library and enable the checkbox 'Load already saved .dat file', this field is automatically populated with the value set when extracting the recording. Its is requiring the saved NEO_Saved_MetaData.mat file saved in the same folder as the .dat file from NEO data extraction.";
        end
    end

    %% Save Data window
    if strcmp(Window,"SaveDataWindow") || strcmp(Window,"All")
        if ~isempty(app.SaveDataWindow) && isvalid(app.SaveDataWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.SaveDataWindow.SaveTypeDropDown.Tooltip = "Select the format you want to save channel data in. If you save as a .dat file, a .mat file containing the recording information will be saved along with the .dat file!.";
            app.SaveDataWindow.SelectAllButton.Tooltip = "Click to select that all of the components below availbale in the dataset are saved.";
            
            app.SaveDataWindow.RawDataButton.Tooltip = "Click to save the raw dataset component.";
            app.SaveDataWindow.PreprocessedDataButton.Tooltip = "Click to save the preprocessed dataset component.";
            app.SaveDataWindow.SpikeIndiciesButton.Tooltip = "Click to save the spike dataset component.";
            app.SaveDataWindow.EventRelatedDataButton.Tooltip = "Click to save the event related dataset component. Since this component is extracted on the fly as needed, you first have to conduct an analysis requiring the extraction of event related data to be able to save it here (for example in the even related LFP analysis)! Make sure the settings for its extraction are set correct in the corresponding window!";
            app.SaveDataWindow.EventTimesButton.Tooltip = "Click to save the event dataset component (event trigger times).";
            app.SaveDataWindow.PreprocessedEventRelatedDataButton.Tooltip = "Click to save the preprocessed event related dataset component. Since this component is extracted on the fly as needed, you first have to conduct an analysis requiring the extraction of preprocessed event related data to be able to save it here (for example in the even related LFP analysis)! Make sure the settings for its extraction are set correct in the corresponding window (ig data type was set to preprocessed event related data)!";
        end
    end

    %% Load Data window
    if strcmp(Window,"LoadDataWindow") || strcmp(Window,"All")
        if ~isempty(app.LoadDataWindow) && isvalid(app.LoadDataWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.LoadDataWindow.SelectDifferentFolderButton.Tooltip = "Click here to search in another folder than the autosearched folder (see information) for saved GUI data.";
            app.LoadDataWindow.DropDown_2.Tooltip = "List of all GUI file recognized in the folder selected or autosearched.";
            app.LoadDataWindow.DropDown_3.Tooltip = "Select the format to load.";
        end
    end

    %% Probe Layout Window
    if strcmp(Window,"SetProbeInfoWindow") || strcmp(Window,"All")
        if ~isempty(app.ExtractDataWindow) && isvalid(app.ExtractDataWindow)
            if ~isempty(app.ExtractDataWindow.ProbeLayoutWindow)
                if isprop(app.ExtractDataWindow.ProbeLayoutWindow,'ProbeLayoutWindowUIFigure')
                    app.ExtractDataWindow.ProbeLayoutWindow.NrChannelEditField.Tooltip = "Edit Nr of channel columns of your probe. This number times the number entered in 'Nr Probe Rows' equals the total channel count.";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelSpacingumEditField.Tooltip = "Edit the spacing between channel columns in µm. Necessary to plot.";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelRowsDropDown.Tooltip = "Edit the number of channel rows per shank. Second channel row is to the right of the first one. Note: For Neuropixels probe designs ~= Phase 3B, select 2 channel rows and activate the 'Horizontal Offset Between Every Second Column' checkbox.";
                    app.ExtractDataWindow.ProbeLayoutWindow.HorizontalOffsetumEditField.Tooltip = "Edit distance between channel rows; in µm. Must be bigger than 0 µm if probe has more than 1 channel row!";
                    app.ExtractDataWindow.ProbeLayoutWindow.VerticalOffsetumEditField.Tooltip = "Only applicable if two rows are selected. Edit vertical offset of second channel row on the right compared to the first channel row; in µm.";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.VerticalOffsetumEditField_2.Tooltip = "Horizontal distance by which even channel columns are shifted to the right; Should be smaller than the horizontal distance between channel rows; in µm.";
                    app.ExtractDataWindow.ProbeLayoutWindow.CheckBox.Tooltip = "Only applicable if two channel rows selected. When activated, even channel columns are shifted to the right (still counts as two channel rows when two rows are selected).";
   
                    app.ExtractDataWindow.ProbeLayoutWindow.ActiveChannelField.Tooltip = "Active channel are those that you recorded from in respect to the probe geometry on the right. [1,2,3] means that the first three channel of the probe design on the right represent the first three data channel you recorded from. Number of channel specified here has to be the same as channel found in your recording (BUT can be less than the number of all channel on the probe). Leave empty to mark all channel as active. Note: The top channel used in every analysis is the lowest channel number (if not reversed using the 'Reverse Top and Bottom Channel Number Names' checkbox)";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelOrderField.Tooltip = "If channel are recorded and therefore loaded not in the correct order, you can change the order here. [5,4,1] means that the first loaded channel will be changed to the position of channel 5 in the probe view after extracting the dataset (specific location changes if channelnames are reversed!). Has to have the same length as active channel. Empty for no costum channel order. Note: Even tho the active channel specified do not have to start at 1, channel order has to. So even if the first active channel is channel 5 on the probe geometry, channel order starts with 1.";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadChannelOrderButton.Tooltip = "Load a saved channel order. Has to be a .mat file containing a single vector with integers specifying the channel.";
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadActiveChannelSelectionButton.Tooltip = "Load a saved channel order. Has to be a .mat file containing a single vector with integers specifying the channel.";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.SetProbeInformationandContinueButton.Tooltip = "If you specified all aspects of your probe design press this button which adds probe info to the 'Extract Data' window to be able to start data extraction.";
                    app.ExtractDataWindow.ProbeLayoutWindow.ShowChannelSpacingCheckBox.Tooltip = "Click to show channel spacing on the zoomed channel on the right side."; 
                    
                    app.ExtractDataWindow.ProbeLayoutWindow.ReverseTopandBottomChannelNumberCheckBox.Tooltip = "Enabling this will flip channel 1 from the top to the bottom of the probe. It only changes the channel names in the plot for convenience, not how data is displayed (starts with top channel either defined in channel order or first channel extracted in the respective function.).";
                    app.ExtractDataWindow.ProbeLayoutWindow.ReverseTopandBottomChannelNumberCheckBox_2.Tooltip = "Enabling this will flip the extracted dataset so that the first extracted channel becomes the last one and the last extracted channel becomes the first one. Note: Applied after the channelorder. Top channel in data analysis is always the top channel of the probe plot.";

                end
            end
        end
    end
    %% Probe View Main Window
    if strcmp(Window,"ProbeViewMainWindow") || strcmp(Window,"All")
        if ~isempty(app.ProbeViewWindowHandle) && isvalid(app.ProbeViewWindowHandle)
            if isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') || isfield(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
                app.ProbeViewWindowHandle.ChangeforWindowDropDown.Tooltip = "Select window for which channel changes are applied. Applying for multiple windows can decrease performance significantly.";
                app.ProbeViewWindowHandle.ChannelSelectionEditField.Tooltip = "Enter channel range to activate. Format: matlab expressions like 1:10 for channel 1 to 10 or [3,5] for channel 3 and 5.";
                app.ProbeViewWindowHandle.ShowChannelSpacingCheckBox.Tooltip = "Activate to preserve probe distances between channel in analysis plots (when active channnel are divided into individualy 'islands' delimited by inactive channel inbetween).";
            end
        end
    end
    %% Live Spike Rate
    if strcmp(Window,"LiveSpikeRate") || strcmp(Window,"All")
        if ~isempty(app.PSTHApp) && isvalid(app.PSTHApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.PSTHApp.Slider.Tooltip = "Change number of bins for which spike rate is calculated. Warning: high number of bins for a small time window leads to artificially high spike rates. Bin size should not get too small.";
            app.PSTHApp.LockYLimCheckBox.Tooltip = "Enable to lock the plot ylimit to the biggest values found since opening this window. Useful when updating the main plot to keep track of amplitudes.";
            app.PSTHApp.DownsampleCheckBox.Tooltip = "Downsample then binned spike rate to reduce the effect of artificially high spike rate with low bin size. Alternatively reduce number of bins to increase bin size.";
            
            app.PSTHApp.TimeWindowfromtoinsEditField.Tooltip = "Enter the time range for analysis when the 'Couple Time to Main Window' checkbox is deactivated. Format: comma separated numbers like 0,10 for the first ten seconds of the recording.";
            app.PSTHApp.CoupleTimetoMainWindowCheckBox.Tooltip = "Select whether time range for the analysis is coupled to the main window data plot or to the 'Time Range' edit field in this window.";
        end
    end

    %% Live main window plot Power Estimate
    if strcmp(Window,"LivePowerEstimate") || strcmp(Window,"All")
        if ~isempty(app.SpectralEstApp) && isvalid(app.SpectralEstApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.SpectralEstApp.LockYLimCheckBox.Tooltip = "Enable to lock the ylimit to the biggest values found since opening this window. Useful when updating the main plot to keep track of amplitudes.";
            app.SpectralEstApp.DataTypeDropDown.Tooltip = "Select whether power is calculate for raw or preprocessed dataset.";

            app.SpectralEstApp.TimeWindowfromtoinsEditField.Tooltip = "Enter the time range for analysis when the 'Couple Time to Main Window' checkbox is deactivated. Format: comma separated numbers like 0,10 for the first ten seconds of the recording.";
            app.SpectralEstApp.CoupleTimetoMainWindowCheckBox.Tooltip = "Select whether time range for the analysis is coupled to the main window data plot or to the 'Time Range' edit field in this window.";
        end
    end
    %% Live CSD
    if strcmp(Window,"LiveCSD") || strcmp(Window,"All")
        if ~isempty(app.CSDApp) && isvalid(app.CSDApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.CSDApp.HammWindowEditField.Tooltip = "Change hamm window size applied to data to smooth results (has to be odd!). Recommended to be smaller than 9.";
            app.CSDApp.LockCLimCheckBox.Tooltip = "Enable to lock the ylimit to the biggest values found since opening this window. Useful when updating the main plot to keep track of amplitudes.";
            app.CSDApp.DataTypeDropDown.Tooltip = "Select whether CSD is calculate for raw or preprocessed dataset.";

            app.CSDApp.TimeWindowfromtoinsEditField.Tooltip = "Enter the time range for analysis when the 'Couple Time to Main Window' checkbox is deactivated. Format: comma separated numbers like 0,10 for the first ten seconds of the recording.";
            app.CSDApp.CoupleTimetoMainWindowCheckBox.Tooltip = "Select whether time range for the analysis is coupled to the main window data plot or to the 'Time Range' edit field in this window.";
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
                app.PreproWindow.StimulationArtefactRejectionButton.Tooltip = "Press to open a window in which you can interpolate stimulation artefacts. This requires you to extract event data for the stimulation first. Then you can interpolate in a time window around triggers in those events.";
                app.PreproWindow.ArtefactSubspaceReconstructionButton.Tooltip = "Press to open a window in which you can apply the subspace artefact rejection method implemented by the eeglab toolbox.";
                app.PreproWindow.DeleteEventTriggerIndicesButton.Tooltip = "Press to open a window in which you can delete individual trigger indicies (or trials) from the dataset.";
                
                app.PreproWindow.DeleteLastPipelineEntryButton.Tooltip = "Press to delete the last pipeline component you added from the current pipeline.";
                
                app.PreproWindow.StartPipelineButton.Tooltip = "Press to apply all preprocessing steps of the current pipeline above to the raw dataset. This overwrites preprocessed data if it already exists! The order the steps are applied is the same as specified in the window above. After this finished you can view the preprocessed data in the main window.";
            end
        end
    end
    
    %% Stim artefact rejection
    if strcmp(Window,"StimArtefactRejection") || strcmp(Window,"All")
        if ~isempty(app.PreproArtefactRejection) && isvalid(app.PreproArtefactRejection)

            app.PreproArtefactRejection.EventChannelforStimulationDropDown.Tooltip = "Select the event channel holding stimulation time stamps.";
            app.PreproArtefactRejection.EventstoPlotDropDown.Tooltip = "Select a trigger to show artefact signal in the plot below.";
            app.PreproArtefactRejection.TimeAroundEventsEditField_3.Tooltip = "Trigger for which you want to apply the interpolation step. Format: Matlab expressions. Empty for all trigger.";
            app.PreproArtefactRejection.TimeAroundEventsEditField.Tooltip = "Specify time to be plotted to the left and right of the trigger in the plot below.";

            app.PreproArtefactRejection.TimeAroundEventsEditField_2.Tooltip = "Select start and stop time of period in which data is interpolated. This should be set to fit the boundaries of the artefact.";
            app.PreproArtefactRejection.AddArtefactRejectiontoPipelineButton.Tooltip = "Click to add the artefact rejection step with the current settings to the preprocessing pipeline.";
            app.PreproArtefactRejection.Slider.Tooltip = "Slider to change spacing inbetween data lines plotted below.";
            
        end
    end

    %% Continous Static Spectrum Analysis
    if strcmp(Window,"ConStaticSpectrum") || strcmp(Window,"All")
        if ~isempty(app.ContStaticSpectrumWindow) && isvalid(app.ContStaticSpectrumWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.ContStaticSpectrumWindow.AnalysisDropDown.Tooltip = "Change the type of analysis shown. 'Band Power Individual Channel' shows the pwelch spectrum for a single channel (or mean over all data channel), while 'Band Power over Depth' shows the pwelch spectrum over all data channel.";
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
            app.EventExtractionWindow.InputChannelSelectionEditField.Tooltip = "Select which of the found input channel of the selected type you want to extract trigger from. [1,2,4,6] for digital input types means that the digital recording system input channel nr. 1,2,4 and 6 are scanned for trigger. If they contain trigger above the threshold, they are saved. NOTE: Event related analysis can only be conducted for individual event channel (which one can be selected in the respective analysis window)! To combine triggers from different input channel for event related analysis, use the 'Combine Input Channel' button.";
            
            app.EventExtractionWindow.EventTypeDropDown.Tooltip = "Select whether to extract the rising or falling edge time of each trigger. For Open Ephys event data, this corresponds to state 1 (rising edge) or 0 (falling edge).";

            app.EventExtractionWindow.LoadCostumeTriggerIdentityButton.Tooltip = "Click to open a window that allows to divide triggers within a single event input channel into multiple different event input channel, each containing individual trigger of the original channel. For example, 200 trigger in a single event channel each representing one of 4 different auditory stimulus frequencies being played can be divided into 4 different channel, each for one frequency. Consequently, event related analysis can be coducted for each event channel individually.";

            app.EventExtractionWindow.SetFoldermanuallyButton.Tooltip = "Event channel data is auto-searched for in the folder the data was extracted from. When this folder does not contain your recording data or switched location, you can manually select a folder which contains your event data for the current recording.";
            app.EventExtractionWindow.PlotInputChannelButton.Tooltip = "To see which input channel types and numbers contain your event data and which threshold to use (if applicable), click this button to plot the event data over time. For somerecording systems, trigger data is represented as a continous data stream over time with the signal showing a 1 for each trigger time stamp plus 5ms after that. Inbetween triggers, signal is 0. This simulates a continuous signal from individual and discrete trigger times.";
            app.EventExtractionWindow.StartEventExtractionButton.Tooltip = "Press to start event extraction which the settings specified above. You are being informed about the trigger numbers found within each extracted input channl in the text area above.";
            
            app.EventExtractionWindow.CombineInputChannelButton.Tooltip = "Normally, event related analysis can only be conducted for individual event channel specified in the 'Input Channel Selection' edit field. If you want to analyse the combined trigger times of multiple different event channel, use this button.";

            app.EventExtractionWindow.TimeWindowAfterEventssEditField.Tooltip = "Time before each trigger in seconds to extract data from for event related analysis. This represents the trial time before each trigger taken into analysis. Values are just saved for later since event related data is extracted on the fly.";
            app.EventExtractionWindow.TimeWindowBeforeEventssEditField.Tooltip = "Time after each trigger in seconds to extract data from for event related analysis. This represents the trial time after each trigger taken into analysis. Values are just saved for later since event related data is extracted on the fly.";
            
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

            app.ImportEventTTLWindow.TimeWindowAfterEventssEditField.Tooltip = "Time before each trigger in seconds to extract data from for event related analysis. This represents the trial time around each trigger. Values are just saved for later since event related data is extracted on the fly.";
            app.ImportEventTTLWindow.TimeWindowBeforeEventssEditField.Tooltip = "Time before each trigger in seconds to extract data from for event related analysis. This represents the trial time around each trigger. Values are just saved for later since event related data is extracted on the fly.";

        end
    end

    %% Event ERP
    if strcmp(Window,"EventERP") || strcmp(Window,"All")
        if ~isempty(app.EventLFPERP) && isvalid(app.EventLFPERP)

            app.EventLFPERP.DataToExtractFromDropDown.Tooltip = "Select if event related data is extracted from raw or preprocessed data.";
            app.EventLFPERP.EventChannelSelectionDropDown.Tooltip = "Select the event channel for which event related data is extracted.";
            app.EventLFPERP.DataTypeDropDown.Tooltip = "Select if raw or preprocessed event related data is extracted.";
            app.EventLFPERP.ChannelSelectionDropDown_2.Tooltip = "Select a single channel for which the ERP and trial wise signal is plotted in the upper plot.";

            app.EventLFPERP.BaselineNormalizeCheckBox.Tooltip = "Select whether to perform baseline normalization with the time specified in the baseline window text field. ";
            app.EventLFPERP.EventNumberSelectionEditField_3.Tooltip = "Select the baseline time window used to baseline normalize; Format: comma separated numbers like '-0.2,0'.";
            app.EventLFPERP.EventNumberSelectionEditField_2.Tooltip = "Info field showing the total number of trigger for the currently selected trigger channel.";
            
            app.EventLFPERP.EventNumberSelectionEditField.Tooltip = "Specify trigger for which the ERP is computed and which are shown in the upper plot.";
            app.EventLFPERP.Slider.Tooltip = "Change spacing inbetween data lines in the lower plot.";
            
        end
    end

    %% Event CSD
    if strcmp(Window,"EventCSD") || strcmp(Window,"All")
        if ~isempty(app.EventLFPCSD) && isvalid(app.EventLFPCSD)

            app.EventLFPCSD.DataToExtractFromDropDown.Tooltip = "Select if event related data is extracted from raw or preprocessed data.";
            app.EventLFPCSD.EventTriggerChannel.Tooltip = "Select the event channel for which event related data is extracted.";
            app.EventLFPCSD.DataTypeDropDown.Tooltip = "Select if raw or preprocessed event related data is extracted.";
            app.EventLFPCSD.EventNumberSelectionEditField.Tooltip = "Specify trigger for which the ERP is computed and which are shown in the upper plot.";
            
            app.EventLFPCSD.BaselineNormalizeCheckBox.Tooltip = "Select whether to perform baseline normalization with the time specified in the baseline window text field. ";
            app.EventLFPCSD.EventNumberSelectionEditField_3.Tooltip = "Select the baseline time window used to baseline normalize; Format: comma separated numbers like '-0.2,0'.";
            app.EventLFPCSD.EventNumberSelectionEditField_2.Tooltip = "Info field showing the total number of trigger for the currently selected trigger channel.";
            
            app.EventLFPCSD.HammWindowEditField.Tooltip = "Specify hamm window 'smooting' the results. Has to be odd (recommended smaller than 9).";
            app.EventLFPCSD.ClimminmaxEditField.Tooltip = "Specify the color plot limits. Format: [LowerLimit,UpperLimit]";
            app.EventLFPCSD.AutoClimButton.Tooltip = "Click the restore the default color plot limits.";
            
        end
    end

    %% Event Static Spectrum Analysis
    if strcmp(Window,"EventStaticSpectrum") || strcmp(Window,"All")
        if ~isempty(app.EventLFPSSP) && isvalid(app.EventLFPSSP)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.EventLFPSSP.DataToExtractFromDropDown.Tooltip = "Select if event related data is extracted from raw or preprocessed data.";
            app.EventLFPSSP.EventTriggerChannel.Tooltip = "Select the event channel for which event related data is extracted.";
            
            app.EventLFPSSP.BaselineNormalizeCheckBox.Tooltip = "Select whether to perform baseline normalization with the time specified in the baseline window text field. ";
            app.EventLFPSSP.EventNumberSelectionEditField.Tooltip = "Select the baseline time window used to baseline normalize; Format: comma separated numbers like '-0.2,0'.";
            app.EventLFPSSP.EventNumberSelectionEditField_2.Tooltip = "Info field showing the total number of trigger for the currently selected trigger channel.";
            
            app.EventLFPSSP.EventSelectionEditField.Tooltip = "Specify trigger (trials) over which the ERP is computed to compute the static spectrum.";
            app.EventLFPSSP.AnalysisDropDown.Tooltip = "Change the type of analysis shown. 'Band Power Individual Channel' shows the pwelch spectrum for a single channel (or mean over all data channel), while 'Band Power over Depth' shows the pwelch spectrum over all data channel.";
            app.EventLFPSSP.ChannelDropDown.Tooltip = "Change the channel for which the spectrum is shown. This is only enable when 'Band Power Individual Channel' is selected as analysis type. When spectrum over depth is plotted, channel selection in the 'Probe View window is applied!'";
            app.EventLFPSSP.FrequencyRangeHzEditField.Tooltip = "Change frequency range for which spectrum is shown. Format [1,100] for 1 to 100Hz.";

            app.EventLFPSSP.DataTypeDropDown.Tooltip = "Select whether to show spectrum for a single channel or mean over all channel. Only enabled when 'Band Power Individual Channel' is selected as analysis type.";
            app.EventLFPSSP.DataSourceDropDown.Tooltip = "Select whether spectrum is calculate for raw or preprocessed event related data.";
        end
    end
    
    %% Event Time Frequency Power
    if strcmp(Window,"EventTimeFrequencyPower") || strcmp(Window,"All")
        if ~isempty(app.EventLFPTF) && isvalid(app.EventLFPTF)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "Click to select a folder. If data format was detected, it will be sh";
            app.EventLFPTF.DataToExtractFromDropDown.Tooltip = "Select if event related data is extracted from raw or preprocessed data.";
            app.EventLFPTF.EventTriggerChannel.Tooltip = "Select the event channel for which event related data is extracted.";
            
            app.EventLFPTF.DataSourceDropDown.Tooltip = "Select whether time frequency power is calculate for raw or preprocessed event related data.";
            app.EventLFPTF.EventNumberSelectionEditField.Tooltip = "Specify trigger (trials) for which time frequency power is computed.";
            app.EventLFPTF.FrequencyRangeminmaxstepsEditField.Tooltip = "Change frequency range and number of steps inbetween range limits for which time frequency power is computed. Format: [LowerLimit,Steps,UpperLimit]";
            app.EventLFPTF.CycleWidthfromto23EditField.Tooltip = "Time frequency power is computed with varying cycle widths of moorlet wavelets to tackle the time frequency tradeoff (the higher the frequency, the better the time resolution). Specify range of cycles. The higher the cycle width, the higher the frequency resolution.";
            app.EventLFPTF.ClimminmaxEditField.Tooltip = "Specify the color plot limits. Format: [LowerLimit,UpperLimit]";
            app.EventLFPTF.AutoClimButton.Tooltip = "Click the restore the default color plot limits.";
            
            app.EventLFPTF.WaveletTypeDropDown.Tooltip = "Currently only Moorlet wavelets available.";
            
            app.EventLFPTF.BaselineNormalizeCheckBox.Tooltip = "Select whether to perform baseline normalization with the time specified in the baseline window text field. ";
            app.EventLFPTF.EventNumberSelectionEditField_3.Tooltip = "Select the baseline time window used to baseline normalize; Format: comma separated numbers like '-0.2,0'.";
            app.EventLFPTF.EventNumberSelectionEditField_2.Tooltip = "Info field showing the total number of trigger for the currently selected trigger channel.";

            app.EventLFPTF.TimeFrequencyCheckBox.Tooltip = "If checkbox is activated, time frequency power is plotted across all selected trial.";
            app.EventLFPTF.IntertrialPhaseClusteringCheckBox.Tooltip = "If checkbox is activated, intertrial phase clustering is plotted across all selected trials.";

            app.EventLFPTF.PhaseindependentCheckBox.Tooltip = "If checkbox is activated, time frequency power is computed for phase locked and non-phase locked components. For this, all trials are concatonated to a supertrial to avoid averaging out the non-phase locked components across trials.";
            app.EventLFPTF.PhaselockedCheckBox.Tooltip = "If checkbox is activated, time frequency power for all phase locked components is computed, i.e. over the ERP.";
            app.EventLFPTF.NonphaselockedCheckBox.Tooltip = "If checkbox is activated, time frequency power for all non-phase locked components is computed, i.e. all components minus phase locked components.";
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

    %% Delete trigger indices
    if strcmp(Window,"DeleteEventIndices") || strcmp(Window,"All")
        if ~isempty(app.EventIndiceRejectionWindow) && isvalid(app.EventIndiceRejectionWindow)
            
            app.EventIndiceRejectionWindow.TextArea.Tooltip = "Trial indices for selected channel that exceed the specified threshold. Copy and paste into the 'Reject Trials' edit field to reject those trials from the selected channel. Note, that it is currently only possible to reject the specified trials from all channel at the same time!";
            app.EventIndiceRejectionWindow.ThresholdEditField.Tooltip = "Select a threshold to automatically determine trials exceeding those limits. Must be positive!";
            
            app.EventIndiceRejectionWindow.CheckBox.Tooltip = "Activate to determine trials exceeding the postive threshold.";
            app.EventIndiceRejectionWindow.CheckBox_2.Tooltip = "Activate to determine trials exceeding the negative threshold.";
            app.EventIndiceRejectionWindow.PlotThresholdCheckBox.Tooltip = "Activate plot the threshold in the lower plot.";

            app.EventIndiceRejectionWindow.ClimfromtoEditField.Tooltip = "Change the clims in the upper plot. Example: [-1,1]";
            app.EventIndiceRejectionWindow.RejectTrialsfromtoEditField.Tooltip = "Specify all trials to be rejected for the currently selected channel. Example: [1,2,3,4] or 1:10; Note, that it is currently only possible to reject the specified trials from all channel at the same time!";
            app.EventIndiceRejectionWindow.PlotTrialsfromtoEditField.Tooltip = "Specify which trials are plotted in the upper and lower plot. Example: [1,2,3,4] or 1:10";
            app.EventIndiceRejectionWindow.ChannelofInterestDropDown.Tooltip = "Specify the channel for which to visualize and reject trials. This is only for plotting. Note, that it is currently only possible to reject the specified trials from all channel at the same time!";
            
            app.EventIndiceRejectionWindow.SaveasnewDatasetButton.Tooltip = "Click to add the currently selected trials to reject to the preprocessed event related dataset. Note, that it is currently only possible to reject the specified trials from all channel at the same time!";


            app.EventIndiceRejectionWindow.EventChannelSelectionDropDown.Tooltip = "Specify the event channel to take trigger times from.";
            app.EventIndiceRejectionWindow.DataToExtractFromDropDown.Tooltip = "Specify whether plotted data is extracted from the raw - or preprocessed dataset.";
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
            
            app.LiveECHTWindow.DataTypeDropDown.Tooltip = "Select whether phase is calculated based on raw or preprocessed data.";
            app.LiveECHTWindow.CalculationMethodDropDown.Tooltip = "Select the method to calculate phase. ECHT is the Matlab Hilbert implementation with an additional narrowband filter coefficient multiplied with the fft result.";
            app.LiveECHTWindow.NarrowbandCutoffLowerHigherEditField.Tooltip = "Enter the cutoff frequency for the automatically applied narrowband filter (if not already present in preprocessed data). Also used as cutoff for the ECHT narrowband filter. Format: [lowerF,higherF]";

            app.LiveECHTWindow.NarrowbandFilterorderEditField.Tooltip = "Enter the filter order for the automatically applied narrowband filter. NOT used for ECHT narrowband filter!";
            app.LiveECHTWindow.ECHTFilterorderEditField.Tooltip = "Enter the filter order for the Echt narrowband filter.";
            app.LiveECHTWindow.LockYlimCheckBox.Tooltip = "Click to lock the ylim of the lower plot to the max value.";
            app.LiveECHTWindow.ForceFilterOFFCheckBox.Tooltip = "Click to activate/deactivate automatically filtering the signal. Let always active for Hilbert transform.";

            app.LiveECHTWindow.ChannelSelectionDropDown.Tooltip = "Select the channel for which you want to compute the ECHT";
            app.LiveECHTWindow.ChannelSelectionDropDown.Tooltip = "Select the channel for which you want to compute the ECHT";

            app.LiveECHTWindow.ChangeLowPassParameterMenu.Tooltip = "Change filter parameter for the automatically applied low-pass filter (done to be able to downsample without aliasing).";
            app.LiveECHTWindow.ShowDataAnalysedMenu.Tooltip = "Use the inst. frequency plot to show the narrowband pass filtered signal used for phase calculation instead.";
            app.LiveECHTWindow.ChangeFilterTypeMenu.Tooltip = "Select the kind of narrowband filter type used for narrowband filtering.";
            
            app.LiveECHTWindow.TimeWindowfromtoinsEditField.Tooltip = "Enter the time range for analysis when the 'Couple Time to Main Window' checkbox is deactivated. Format: comma separated numbers like 0,10 for the first ten seconds of the recording.";
            app.LiveECHTWindow.CoupleTimetoMainWindowCheckBox.Tooltip = "Select whether time range for the analysis is coupled to the main window data plot or to the 'Time Range' edit field in this window.";
        end
    end

    %% LIVE Spectrogram
    if strcmp(Window,"LiveSpectogram") || strcmp(Window,"All")
        if ~isempty(app.LiveSpectrogramApp) && isvalid(app.LiveSpectrogramApp)
            
            app.LiveSpectrogramApp.ChannelToPlotDropDown.Tooltip = "Select the channel for which the spectrogram is calculated.";
            app.LiveSpectrogramApp.FrequencyRangeMinMaxEditField.Tooltip = "Set the frequency range to show in the analysis. Format: [Min Freq in Hz, Max Freq in Hz] like 1,500 for 1-500Hz.";
            app.LiveSpectrogramApp.WindowsEditField.Tooltip = "Set the window length to divide the signal into segments. In samples, must be smaller than amount of data points in the current analysis time window.";

            app.LiveSpectrogramApp.DataTypeDropDown.Tooltip = "Select whether to calculate the spectrogram with the raw - or preprocessed data (if available) dataset within the analysis time window.";
            app.LiveSpectrogramApp.LockCLimCheckBox.Tooltip = "Click to lock the clim of the lower plot to the max value.";
            app.LiveSpectrogramApp.TimeWindowfromtoinsEditField.Tooltip = "Enter the time range for analysis when the 'Couple Time to Main Window' checkbox is deactivated. Format: comma separated numbers like 0,10 for the first ten seconds of the recording.";
            app.LiveSpectrogramApp.CoupleTimetoMainWindowCheckBox.Tooltip = "Select whether time range for the analysis is coupled to the main window data plot or to the 'Time Range' edit field in this window.";
        end
    end
    
    %% LIVE ECHT Events
    if strcmp(Window,"EventECHT") || strcmp(Window,"All")
        if ~isempty(app.EventPhaseSynchro) && isvalid(app.EventPhaseSynchro)
            
            app.EventPhaseSynchro.DataToExtractFromDropDown.Tooltip = "Select if event related data is extracted from raw or preprocessed data.";
            app.EventPhaseSynchro.EventChannelSelectionDropDown.Tooltip = "Select the event channel for which event related data is extracted.";
            app.EventPhaseSynchro.DataTypeDropDown.Tooltip = "Select whether time frequency power is calculate for raw or preprocessed event related data.";

            app.EventPhaseSynchro.CalculationMethodDropDown.Tooltip = "Select the method to calculate phase. ECHT is the Matlab Hilbert implementation with an additional narrowband filter coefficient multiplied with the fft result.";
            app.EventPhaseSynchro.NarrowbandCutoffLowerHigherEditField.Tooltip = "Enter the cutoff frequency for the automatically applied narrowband filter (if not already present in preprocessed data). Also used as cutoff for the ECHT narrowband filter. Format: [lowerF,higherF]";
            
            app.EventPhaseSynchro.TrialSelectionMatlabExpressionsEditField.Tooltip = "Enter the trials for which phase is calculated. Format: Matlab Expressions.";

            app.EventPhaseSynchro.NarrowbandFilterorderEditField.Tooltip = "Enter the filter order for the automatically applied narrowband filter. NOT used for ECHT narrowband filter!";
            app.EventPhaseSynchro.ECHTFilterorderEditField.Tooltip = "Enter the filter order for the Echt narrowband filter.";
            app.EventPhaseSynchro.ForceFilterOFFCheckBox.Tooltip = "Click to activate/deactivate automatically filtering the signal. Let always active for Hilbert transform.";

            app.EventPhaseSynchro.ChannelSelectionDropDown.Tooltip = "Select the channel for which you want to compute the ECHT";
            app.EventPhaseSynchro.ChannelSelectionDropDown.Tooltip = "Select the channel for which you want to compute the ECHT";

            app.EventPhaseSynchro.ChangeLowPassParameterMenu.Tooltip = "Change filter parameter for the automatically applied low-pass filter (done to be able to downsample without aliasing).";
            app.EventPhaseSynchro.ShowDataAnalysedMenu.Tooltip = "Use the inst. frequency plot to show the narrowband pass filtered signal used for phase calculation instead.";
            app.EventPhaseSynchro.ChangeFilterTypeMenu.Tooltip = "Select the kind of narrowband filter type used for narrowband filtering.";
            
        end
    end

    %% Load Spike Sorting results
    if strcmp(Window,"LoadSorting") || strcmp(Window,"All")
        if ~isempty(app.LoadfromKilosortWindowWindow) && isvalid(app.LoadfromKilosortWindowWindow)
            app.LoadfromKilosortWindowWindow.SpikeSorterDropDown.Tooltip = "Select the sorter for which you want to load sorting results.";
            app.LoadfromKilosortWindowWindow.AmplitudeScalingFactorEditField.Tooltip = "If Kilosort was used, spike amplitudes are saved as integers and have to be converted back to mV which this factor. This factor is generated and saved automatically when saving data for spike sorting with Kilosort. Autosearched folder shown above is also searched through for this factor.";

            app.LoadfromKilosortWindowWindow.SelectKilosortFolderManuallyButton.Tooltip = "Manully select the folder in which spike sorting results of one of the support sorters is saved.";
            app.LoadfromKilosortWindowWindow.SelectAmplitudeScalingManuallyButton.Tooltip = "Only for Kilosort: Manully select the amplitude scaling factor .mat file created when saving data for Kilosort.";
            
            app.LoadfromKilosortWindowWindow.SelectAmplitudeScalingManuallyButton.Tooltip = "Only for Kilosort: Manully select the amplitude scaling factor .mat file created when saving data for Kilosort.";
            
            app.LoadfromKilosortWindowWindow.SpikeChannelTypeDropDown.Tooltip = "Select how the data channel for each spike is determined. This influences waveform extraction and the ploted position in the main window plot. 'Channel closest to X and Y of respective spikes' means, that each spike channel is the channel closest to the physical position of the spike. 'Single channel for all spikes in one unit (max template channel)' means, that the channel of all spikes of a unit are set to the channel with the maximum template.";

            app.LoadfromKilosortWindowWindow.LoadButton.Tooltip = "Click to load sorting results with the parameters above.";
        end
    end
    
    %% Save Spike Sorting results
    if strcmp(Window,"SaveSorting") || strcmp(Window,"All")
        if ~isempty(app.SaveforKilosortWindowWindow) && isvalid(app.SaveforKilosortWindowWindow)
            app.SaveforKilosortWindowWindow.Dataset.Tooltip = "Choose whether you want to save your raw or preprocessed dataset. Recommended: raw dataset.";
            app.SaveforKilosortWindowWindow.SaveFormatDropDown_2.Tooltip = "Specify whether you want to save for later use in the external Kilosort GUI (export as .dat file with int16 or int32 format) or in SpikeInterface (.dat file with double as format (float64))";

            app.SaveforKilosortWindowWindow.SaveFormatDropDown.Tooltip = "Select whether you want to save data for Kilosort in int16 or int32 format. No choice when saving for SpikeInterface.";
            app.SaveforKilosortWindowWindow.SelectFolderManuallyButton.Tooltip = "Manaully select a folder to save data in for spike sorting.";
        end
    end

    %% Automaoic Unit Curation Window
    if strcmp(Window,"UnitCurationWindow") || strcmp(Window,"All")
        if ~isempty(app.LoadfromKilosortWindowWindow.AutomaticCurationWindow) && isvalid(app.LoadfromKilosortWindowWindow.AutomaticCurationWindow)
            
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.SNRCheckBox.Tooltip = "Signal-to-noise ratio of the unit waveform. Higher = better.";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.FiringRangeCheckBox.Tooltip = "Dynamic range of firing rate across the recording (difference between max and min firing rate over time bins). Smaller = better";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.NoiseCutoffCheckBox.Tooltip = "How much of the spike amplitude distribution is cut off by detection threshold (unit amplitude close to threshold --> unreliable detection). Smaller = better";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.ISIViolationRatioCheckBox.Tooltip = "Fraction of spikes that violate a refractory period. Lower = better";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.NoiseRatioCheckBox.Tooltip = "Fraction of spikes with amplitudes close to noise level. Smaller = better";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.MedianAmplitudeCheckBox.Tooltip = "Median spike amplitude for each unit. Larger absolute values = better";
            
        end
    end

    %disp("Tooltips turned ON");

%--------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------
else %% Not activated
    
    %% Main Window
    if strcmp(Window,"MainWindow") || strcmp(Window,"All")
        app.TimeRangeViewBox.Tooltip = "";
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

        app.TextArea.Tooltip = "";
    end
    
    %% Extract Data window
    if strcmp(Window,"ExtractDataWindow") || strcmp(Window,"All")
        if ~isempty(app.ExtractDataWindow) && isvalid(app.ExtractDataWindow)
            app.ExtractDataWindow.RecordingSystemDropDown.Tooltip = "";
            app.ExtractDataWindow.FileTypeDropDown.Tooltip = "";
            app.ExtractDataWindow.AdditionalAmplificationFactorEditField.Tooltip = "";
            app.ExtractDataWindow.AddProbeInformationButton.Tooltip = "";
            app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.ExtractDataWindow.ExtractDataButton.Tooltip = "";

            app.ExtractDataWindow.FormatToSaveandReadintoMatlabDropDown.Tooltip = "";

            app.ExtractDataWindow.RecordingSystemDropDown_2.Tooltip = "";
            app.ExtractDataWindow.KeepConsoleOpen_2.Tooltip = "";
            app.ExtractDataWindow.KeepConsoleOpen.Tooltip = "";
        end
    end

    %% Save Data window
    if strcmp(Window,"SaveDataWindow") || strcmp(Window,"All")
        if ~isempty(app.SaveDataWindow) && isvalid(app.SaveDataWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.SaveDataWindow.SaveTypeDropDown.Tooltip = "";
            app.SaveDataWindow.SelectAllButton.Tooltip = "";
            
            app.SaveDataWindow.RawDataButton.Tooltip = "";
            app.SaveDataWindow.PreprocessedDataButton.Tooltip = "";
            app.SaveDataWindow.SpikeIndiciesButton.Tooltip = "";
            app.SaveDataWindow.EventRelatedDataButton.Tooltip = "";
            app.SaveDataWindow.EventTimesButton.Tooltip = "";
            app.SaveDataWindow.PreprocessedEventRelatedDataButton.Tooltip = "";
        end
    end

    %% Load Data window
    if strcmp(Window,"LoadDataWindow") || strcmp(Window,"All")
        if ~isempty(app.LoadDataWindow) && isvalid(app.LoadDataWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.LoadDataWindow.SelectDifferentFolderButton.Tooltip = "";
            app.LoadDataWindow.DropDown_2.Tooltip = "";
            app.LoadDataWindow.DropDown_3.Tooltip = "";
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
            
                    app.ExtractDataWindow.ProbeLayoutWindow.VerticalOffsetumEditField_2.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.CheckBox.Tooltip = "";
   
                    app.ExtractDataWindow.ProbeLayoutWindow.ActiveChannelField.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.ChannelOrderField.Tooltip = "";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadChannelOrderButton.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.LoadActiveChannelSelectionButton.Tooltip = "";
            
                    app.ExtractDataWindow.ProbeLayoutWindow.SetProbeInformationandContinueButton.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.ShowChannelSpacingCheckBox.Tooltip = ""; 
                    
                    app.ExtractDataWindow.ProbeLayoutWindow.ReverseTopandBottomChannelNumberCheckBox.Tooltip = "";
                    app.ExtractDataWindow.ProbeLayoutWindow.ReverseTopandBottomChannelNumberCheckBox_2.Tooltip = "";

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
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.PSTHApp.Slider.Tooltip = "";
            app.PSTHApp.LockYLimCheckBox.Tooltip = "";
            app.PSTHApp.DownsampleCheckBox.Tooltip = "";
        end
    end

    %% Live main window plot Power Estimate
    if strcmp(Window,"LivePowerEstimate") || strcmp(Window,"All")
        if ~isempty(app.SpectralEstApp) && isvalid(app.SpectralEstApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.SpectralEstApp.LockYLimCheckBox.Tooltip = "";
            app.SpectralEstApp.DataTypeDropDown.Tooltip = "";
        end
    end
    %% Live CSD
    if strcmp(Window,"LiveCSD") || strcmp(Window,"All")
        if ~isempty(app.CSDApp) && isvalid(app.CSDApp)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.CSDApp.HammWindowEditField.Tooltip = "";
            app.CSDApp.LockCLimCheckBox.Tooltip = "";
            app.CSDApp.DataTypeDropDown.Tooltip = "";
        end
    end

    %% Preprocessing Window
    if strcmp(Window,"Preprocessing") || strcmp(Window,"All")
        if ~isempty(app.PreproWindow) && isvalid(app.PreproWindow)
            if isprop(app.PreproWindow,'PreprocessingWindowUIFigure')
                %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
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
                app.PreproWindow.ArtefactSubspaceReconstructionButton.Tooltip = "";
                app.PreproWindow.DeleteEventTriggerIndicesButton.Tooltip = "";
                
                app.PreproWindow.DeleteLastPipelineEntryButton.Tooltip = "";
                
                app.PreproWindow.StartPipelineButton.Tooltip = "";
            end
        end
    end
    
    %% Stim artefact rejection
    if strcmp(Window,"StimArtefactRejection") || strcmp(Window,"All")
        if ~isempty(app.PreproArtefactRejection) && isvalid(app.PreproArtefactRejection)

            app.PreproArtefactRejection.EventChannelforStimulationDropDown.Tooltip = "";
            app.PreproArtefactRejection.EventstoPlotDropDown.Tooltip = "";
            app.PreproArtefactRejection.TimeAroundEventsEditField_3.Tooltip = "";
            app.PreproArtefactRejection.TimeAroundEventsEditField.Tooltip = "";

            app.PreproArtefactRejection.TimeAroundEventsEditField_2.Tooltip = "";
            app.PreproArtefactRejection.AddArtefactRejectiontoPipelineButton.Tooltip = "";
            app.PreproArtefactRejection.Slider.Tooltip = "";
            
        end
    end

    %% Continous Static Spectrum Analysis
    if strcmp(Window,"ConStaticSpectrum") || strcmp(Window,"All")
        if ~isempty(app.ContStaticSpectrumWindow) && isvalid(app.ContStaticSpectrumWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.ContStaticSpectrumWindow.AnalysisDropDown.Tooltip = "";
            app.ContStaticSpectrumWindow.ChannelDropDown.Tooltip = "";
            app.ContStaticSpectrumWindow.FrequencyRangeHzEditField.Tooltip = "";

            app.ContStaticSpectrumWindow.DataTypeDropDown.Tooltip = "";
            app.ContStaticSpectrumWindow.DataSourceDropDown.Tooltip = "";
        end
    end

    %% Cont spike analysis
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
    
            app.EventExtractionWindow.EventTypeDropDown.Tooltip = "";
    
            app.EventExtractionWindow.LoadCostumeTriggerIdentityButton.Tooltip = "";
    
            app.EventExtractionWindow.SetFoldermanuallyButton.Tooltip = "";
            app.EventExtractionWindow.PlotInputChannelButton.Tooltip = "";
            app.EventExtractionWindow.StartEventExtractionButton.Tooltip = "";
    
            app.EventExtractionWindow.TimeWindowAfterEventssEditField.Tooltip = "";
            app.EventExtractionWindow.TimeWindowBeforeEventssEditField.Tooltip = "";
    
        end
    end
    
    %% Import Events window
    if strcmp(Window,"ImportEvents") || strcmp(Window,"All")
        if ~isempty(app.ImportEventTTLWindow) && isvalid(app.ImportEventTTLWindow) 
    
            app.ImportEventTTLWindow.InputChannelSelectionEditField.Tooltip = "";
            app.ImportEventTTLWindow.InputChannelSelectionEditField_2.Tooltip = "";
    
            app.ImportEventTTLWindow.SelectFilecsvortxtButton.Tooltip = "";
            app.ImportEventTTLWindow.PlotEventDataButton.Tooltip = "";
            app.ImportEventTTLWindow.TakeasnewEventDataButton.Tooltip = "";
    
            app.ImportEventTTLWindow.TimeWindowAfterEventssEditField.Tooltip = "";
            app.ImportEventTTLWindow.TimeWindowBeforeEventssEditField.Tooltip = "";
    
        end
    end
    
    %% Event ERP
    if strcmp(Window,"EventERP") || strcmp(Window,"All")
        if ~isempty(app.EventLFPERP) && isvalid(app.EventLFPERP)
    
            app.EventLFPERP.DataToExtractFromDropDown.Tooltip = "";
            app.EventLFPERP.EventChannelSelectionDropDown.Tooltip = "";
            app.EventLFPERP.DataTypeDropDown.Tooltip = "";
            app.EventLFPERP.ChannelSelectionDropDown_2.Tooltip = "";
    
            app.EventLFPERP.EventNumberSelectionEditField.Tooltip = "";
            app.EventLFPERP.Slider.Tooltip = "";
    
        end
    end
    
    %% Event CSD
    if strcmp(Window,"EventCSD") || strcmp(Window,"All")
        if ~isempty(app.EventLFPCSD) && isvalid(app.EventLFPCSD)
    
            app.EventLFPCSD.DataToExtractFromDropDown.Tooltip = "";
            app.EventLFPCSD.EventTriggerChannel.Tooltip = "";
            app.EventLFPCSD.DataTypeDropDown.Tooltip = "";
            app.EventLFPCSD.EventNumberSelectionEditField.Tooltip = "";
    
            app.EventLFPCSD.HammWindowEditField.Tooltip = "";
            app.EventLFPCSD.ClimminmaxEditField.Tooltip = "";
            app.EventLFPCSD.AutoClimButton.Tooltip = "";
    
        end
    end
    
    %% Event Static Spectrum Analysis
    if strcmp(Window,"EventStaticSpectrum") || strcmp(Window,"All")
        if ~isempty(app.EventLFPSSP) && isvalid(app.EventLFPSSP)
    
            app.EventLFPSSP.DataToExtractFromDropDown.Tooltip = "";
            app.EventLFPSSP.EventTriggerChannel.Tooltip = "";
    
            app.EventLFPSSP.EventSelectionEditField.Tooltip = "";
            app.EventLFPSSP.AnalysisDropDown.Tooltip = "";
            app.EventLFPSSP.ChannelDropDown.Tooltip = "";
            app.EventLFPSSP.FrequencyRangeHzEditField.Tooltip = "";
    
            app.EventLFPSSP.DataTypeDropDown.Tooltip = "";
            app.EventLFPSSP.DataSourceDropDown.Tooltip = "";
    
        end
    end
    
    %% Event Time Frequency Power
    if strcmp(Window,"EventTimeFrequencyPower") || strcmp(Window,"All")
        if ~isempty(app.EventLFPTF) && isvalid(app.EventLFPTF)
    
            app.EventLFPTF.DataToExtractFromDropDown.Tooltip = "";
            app.EventLFPTF.EventTriggerChannel.Tooltip = "";
    
            app.EventLFPTF.DataSourceDropDown.Tooltip = "";
            app.EventLFPTF.EventNumberSelectionEditField.Tooltip = "";
            app.EventLFPTF.FrequencyRangeminmaxstepsEditField.Tooltip = "";
            app.EventLFPTF.CycleWidthfromto23EditField.Tooltip = "";
            app.EventLFPTF.ClimminmaxEditField.Tooltip = "";
            app.EventLFPTF.AutoClimButton.Tooltip = "";
    
            app.EventLFPTF.WaveletTypeDropDown.Tooltip = "";
    
            app.EventLFPTF.TimeFrequencyCheckBox.Tooltip = "";
            app.EventLFPTF.IntertrialPhaseClusteringCheckBox.Tooltip = "";
    
            app.EventLFPTF.PhaseindependentCheckBox.Tooltip = "";
            app.EventLFPTF.PhaselockedCheckBox.Tooltip = "";
            app.EventLFPTF.NonphaselockedCheckBox.Tooltip = "";
    
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

    %% Delete trigger indices
    if strcmp(Window,"Deletetriggerindices") || strcmp(Window,"All")
        if ~isempty(app.EventIndiceRejectionWindow) && isvalid(app.EventIndiceRejectionWindow)
            %app.ExtractDataWindow.SelectDataFolderButton.Tooltip = "";
            app.EventIndiceRejectionWindow.DataToExtractFromDropDown.Tooltip = "";
            app.EventIndiceRejectionWindow.EventChannelforStimulationDropDown.Tooltip = "";
            
            app.EventIndiceRejectionWindow.EventstoPlotDropDown.Tooltip = "";
            app.EventIndiceRejectionWindow.TriggerToRejectMatlabExpressionsEditField.Tooltip = "";
            app.EventIndiceRejectionWindow.DeleteSelectedEventButton.Tooltip = "";

            app.EventIndiceRejectionWindow.Slider.Tooltip = "";
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
            
            app.LiveECHTWindow.DataTypeDropDown.Tooltip = "";
            app.LiveECHTWindow.CalculationMethodDropDown.Tooltip = "";
            app.LiveECHTWindow.NarrowbandCutoffLowerHigherEditField.Tooltip = "";

            app.LiveECHTWindow.NarrowbandFilterorderEditField.Tooltip = "";
            app.LiveECHTWindow.ECHTFilterorderEditField.Tooltip = "";
            app.LiveECHTWindow.LockYlimCheckBox.Tooltip = "";
            app.LiveECHTWindow.ForceFilterOFFCheckBox.Tooltip = "";

            app.LiveECHTWindow.ChannelSelectionDropDown.Tooltip = "";
            app.LiveECHTWindow.ChannelSelectionDropDown.Tooltip = "";

            app.LiveECHTWindow.ChangeLowPassParameterMenu.Tooltip = "";
            app.LiveECHTWindow.ShowDataAnalysedMenu.Tooltip = "";
            app.LiveECHTWindow.ChangeFilterTypeMenu.Tooltip = "";
            
        end
    end
    
    %% LIVE ECHT Events
    if strcmp(Window,"EventECHT") || strcmp(Window,"All")
        if ~isempty(app.EventPhaseSynchro) && isvalid(app.EventPhaseSynchro)
            
            app.EventPhaseSynchro.DataToExtractFromDropDown.Tooltip = "";
            app.EventPhaseSynchro.EventChannelSelectionDropDown.Tooltip = "";
            app.EventPhaseSynchro.DataTypeDropDown.Tooltip = "";

            app.EventPhaseSynchro.CalculationMethodDropDown.Tooltip = "";
            app.EventPhaseSynchro.NarrowbandCutoffLowerHigherEditField.Tooltip = "";
            
            app.EventPhaseSynchro.TrialSelectionMatlabExpressionsEditField.Tooltip = "";

            app.EventPhaseSynchro.NarrowbandFilterorderEditField.Tooltip = "";
            app.EventPhaseSynchro.ECHTFilterorderEditField.Tooltip = "";
            app.EventPhaseSynchro.ForceFilterOFFCheckBox.Tooltip = "";

            app.EventPhaseSynchro.ChannelSelectionDropDown.Tooltip = "";
            app.EventPhaseSynchro.ChannelSelectionDropDown.Tooltip = "";

            app.EventPhaseSynchro.ChangeLowPassParameterMenu.Tooltip = "";
            app.EventPhaseSynchro.ShowDataAnalysedMenu.Tooltip = "";
            app.EventPhaseSynchro.ChangeFilterTypeMenu.Tooltip = "";
            
        end
    end

    %% Load Spike Sorting results
    if strcmp(Window,"LoadSorting") || strcmp(Window,"All")
        if ~isempty(app.LoadfromKilosortWindowWindow) && isvalid(app.LoadfromKilosortWindowWindow)
            app.LoadfromKilosortWindowWindow.SpikeSorterDropDown.Tooltip = "";
            app.LoadfromKilosortWindowWindow.AmplitudeScalingFactorEditField.Tooltip = "";

            app.LoadfromKilosortWindowWindow.SelectKilosortFolderManuallyButton.Tooltip = "";
            app.LoadfromKilosortWindowWindow.SelectAmplitudeScalingManuallyButton.Tooltip = "";

            app.LoadfromKilosortWindowWindow.SpikeChannelTypeDropDown.Tooltip = "";

            app.LoadfromKilosortWindowWindow.CurationSoftwaretoOpenDropDown.Tooltip = "";

            app.LoadfromKilosortWindowWindow.LoadButton.Tooltip = "";
        end
    end
    
    %% Save Spike Sorting results
    if strcmp(Window,"SaveSorting") || strcmp(Window,"All")
        if ~isempty(app.SaveforKilosortWindowWindow) && isvalid(app.SaveforKilosortWindowWindow)
            app.SaveforKilosortWindowWindow.Dataset.Tooltip = "";
            app.SaveforKilosortWindowWindow.SaveFormatDropDown_2.Tooltip = "";

            app.SaveforKilosortWindowWindow.SaveFormatDropDown.Tooltip = "";
            app.SaveforKilosortWindowWindow.SelectFolderManuallyButton.Tooltip = "";
        end
    end  

    %% Automaoic Unit Curation Window
    if strcmp(Window,"UnitCurationWindow") || strcmp(Window,"All")
        if ~isempty(app.LoadfromKilosortWindowWindow.AutomaticCurationWindow) && isvalid(app.LoadfromKilosortWindowWindow.AutomaticCurationWindow)
            
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.SNRCheckBox.Tooltip = "";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.FiringRangeCheckBox.Tooltip = "";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.NoiseCutoffCheckBox.Tooltip = "";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.ISIViolationRatioCheckBox.Tooltip = "";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.NoiseRatioCheckBox.Tooltip = "";
            app.LoadfromKilosortWindowWindow.AutomaticCurationWindow.MedianAmplitudeCheckBox.Tooltip = "";
            
        end
    end

end
