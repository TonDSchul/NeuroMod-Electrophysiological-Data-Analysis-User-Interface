function app = Utility_Change_Light_Dark_Mode(app,Window)


if strcmp(Window,'MainWindow')
    % texts to black
    set(findall(app.NeuromodToolboxMainWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    % backgrounds to grey
    app.NeuromodToolboxMainWindowUIFigure.Color       = [0.85,0.85,0.85];
    app.ManageDatasetPanel.BackgroundColor            = [0.85,0.85,0.85];
    app.MainPlotAnalysisModulePanel.BackgroundColor   = [0.85,0.85,0.85];
    app.ContinousDataModulePanel.BackgroundColor      = [0.85,0.85,0.85];
    app.EventDataModulePanel.BackgroundColor          = [0.85,0.85,0.85];
    app.SpikeModulePanel_2.BackgroundColor            = [0.85,0.85,0.85];

    app.ManageDatasetPanel.ForegroundColor            = [0.85,0.85,0.85];
    app.MainPlotAnalysisModulePanel.ForegroundColor   = [0.85,0.85,0.85];
    app.ContinousDataModulePanel.ForegroundColor      = [0.85,0.85,0.85];
    app.EventDataModulePanel.ForegroundColor          = [0.85,0.85,0.85];
    app.SpikeModulePanel_2.ForegroundColor            = [0.85,0.85,0.85];

    app.TimeSpanControlDropDown.BackgroundColor       = [0.9,0.9,0.9];
    app.TimeRangeViewBox.BackgroundColor              = [0.9,0.9,0.9];
    app.DropDown.BackgroundColor                      = [0.9,0.9,0.9];
    app.DropDown_2.BackgroundColor                    = [0.9,0.9,0.9];
    app.EventChannelDropDown.BackgroundColor          = [0.9,0.9,0.9];
    
    app.ListBox_5.BackgroundColor                     = [0.9,0.9,0.9];
    app.ListBox_6.BackgroundColor                     = [0.9,0.9,0.9];
    app.ListBox_3.BackgroundColor                     = [0.9,0.9,0.9];
    app.ListBox_2.BackgroundColor                     = [0.9,0.9,0.9];
    app.ListBox.BackgroundColor                       = [0.9,0.9,0.9];

    %app.LeftPanel.BackgroundColor                     = [0.85,0.85,0.85];
   %app.RightPanel.BackgroundColor                    = [0.85,0.85,0.85];

    app.TimeSpanandAxisControlPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.ChannelandPlotControlPanel.BackgroundColor    = [0.85,0.85,0.85];
    app.TimeSpanandAxisControlPanel.ForegroundColor   = [0.85,0.85,0.85];
    app.ChannelandPlotControlPanel.ForegroundColor    = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor                      = [0.9,0.9,0.9];
    app.RecordingandDatasetInformationLabel.FontColor = [0,0,0];
    
    % Plot text to black
    if ~isempty(app.PlotAppearance)
        app.UIAxes.Color  = app.PlotAppearance.MainWindow.Data.Color.MainBackground;
    else
        app.UIAxes.Color  = [0.85,0.85,0.85];
    end
    app.UIAxes.XLabel.Color = [0 0 0];
    app.UIAxes.YLabel.Color = [0 0 0];
    app.UIAxes.Title.Color  = [0 0 0];

    app.UIAxes.YColor = 'k';  
    app.UIAxes.XTickLabelMode = 'auto';
    app.UIAxes.XColor = 'k';  
    app.UIAxes.Title.Color = 'k';  
    
    if ~isempty(app.PlotAppearance)
        app.UIAxes_2.Color  = app.PlotAppearance.MainWindow.Data.Color.TimeBackground;
    else
        app.UIAxes_2.Color  = [0.7,0.7,0.7];
    end
    app.UIAxes_2.XLabel.Color = [0 0 0];
    app.UIAxes_2.XColor = [0 0 0];
    app.UIAxes_2.YLabel.Color = [0 0 0];
    app.UIAxes_2.YColor = [0 0 0];
    app.UIAxes_2.Title.Color  = [0 0 0];
    app.UIAxes_2.Box  = 0;
    
    app.RUNButton.BackgroundColor = [0.9,0.9,0.9];
    app.RUNButton_2.BackgroundColor = [0.9,0.9,0.9];
    app.RUNButton_3.BackgroundColor = [0.9,0.9,0.9];
    app.RUNButton_4.BackgroundColor = [0.9,0.9,0.9];
    app.RUNButton_5.BackgroundColor = [0.9,0.9,0.9];

end

if strcmp(Window,"Probe_View_Window")    
    % texts to black
    set(findall(app.ProbeViewUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ProbeViewUIFigure.Color  = [0.85,0.85,0.85];

    app.ChangeforWindowDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.ChannelSelectionEditField.BackgroundColor   = [0.9,0.9,0.9];
    
    app.Panel.BackgroundColor   = [0.85,0.85,0.85];

    app.ScrollandclicktosetactiveanalysischannelLabel.BackgroundColor = [0.85,0.85,0.85];
    % Plot text to black
    app.UIAxes.Color  = [0.85,0.85,0.85];
    app.UIAxes.XLabel.Color = [0 0 0];
    app.UIAxes.YLabel.Color = [0 0 0];
    app.UIAxes.Title.Color  = [0 0 0];

    app.UIAxes2.Color  = [0.7,0.7,0.7];
    app.UIAxes2.XLabel.Color = [0 0 0];
    app.UIAxes2.XColor = [0 0 0];
    app.UIAxes2.YLabel.Color = [0 0 0];
    app.UIAxes2.YColor = [0 0 0];
    app.UIAxes2.Title.Color  = [0 0 0];
    app.UIAxes2.Box  = 0;
   
end


if strcmp(Window,"ExtractDataWindow")    

    % texts to black
    set(findall(app.ExtractDataWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];
    app.TextArea_3.BackgroundColor = [0.9,0.9,0.9];
    app.TextArea_4.BackgroundColor = [0.85,0.85,0.85];

   app.ExtractionOptionsPanel.BackgroundColor = [0.85,0.85,0.85];
   app.ExtractionOptionsPanel.ForegroundColor = [0.85,0.85,0.85];

   app.RecordingSystemDropDown.BackgroundColor                = [0.9,0.9,0.9];
   app.FileTypeDropDown.BackgroundColor                       = [0.9,0.9,0.9];
   app.AdditionalAmplificationFactorEditField.BackgroundColor = [0.9,0.9,0.9];
end

if strcmp(Window,"ProbeLayout_Window")    
    % texts to black
    set(findall(app.ProbeLayoutWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ProbeLayoutWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.ChannelOrderField.BackgroundColor   = [0.9,0.9,0.9];
    app.ActiveChannelField.BackgroundColor   = [0.9,0.9,0.9];

    app.SetProbeGeometryPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.SetProbeGeometryPanel.ForegroundColor = [0.85,0.85,0.85];

    app.AdditionalOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.AdditionalOptionsPanel.ForegroundColor = [0.85,0.85,0.85];
    
    app.SetChannelInformationPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.SetChannelInformationPanel.ForegroundColor = [0.85,0.85,0.85];

    
    app.LoadChannelOrderButton.BackgroundColor   = [0.79,0.95,0.70];
    app.LoadActiveChannelSelectionButton.BackgroundColor   = [0.79,0.95,0.70];

    app.NrChannelEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.ChannelSpacingumEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.HorizontalOffsetumEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.VerticalOffsetumEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.ChannelRowsDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.VerticalOffsetumEditField_2.BackgroundColor   = [0.9,0.9,0.9];

    app.UIAxes.Color  = [0.9,0.9,0.9];
    app.UIAxes.XColor = [0 0 0];
    app.UIAxes.YColor = [0 0 0];
    app.UIAxes.Title.Color  = [0 0 0];

    app.UIAxes2.Color  = [0.9,0.9,0.9];
    app.UIAxes2.XColor = [0 0 0];
    app.UIAxes2.YColor = [0 0 0];
    app.UIAxes2.Title.Color  = [0 0 0];


end

if strcmp(Window,"NP1_LFP_AP")    

    % texts to black
    set(findall(app.SelectRecordingWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor   = [0.85,0.85,0.85];

    app.TextArea_3.BackgroundColor   = [0.85,0.85,0.85];
end

if strcmp(Window,"OE_Multiple_Recordings_Window")    
    % texts to black
    set(findall(app.SelectRecordingWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor   = [0.85,0.85,0.85];

    app.TextArea_3.BackgroundColor   = [0.85,0.85,0.85];

    app.RecordingstoselectEditField.BackgroundColor   = [0.9,0.9,0.9];
end

if strcmp(Window,"Spike2_Select_Event_Channel_Window")    
    % texts to black
    set(findall(app.Spike2SelectEventChannelUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel.BackgroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.85,0.85,0.85];
    app.TextArea_2.BackgroundColor   = [0.85,0.85,0.85];

    app.EventChannelSelectionIntemptyfornonEditField.BackgroundColor   = [0.9,0.9,0.9];

end


if strcmp(Window,"Load_Data_Window")    
    % texts to black
    set(findall(app.LoadDataWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];

    app.DropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.DropDown_2.BackgroundColor   = [0.9,0.9,0.9];

    app.LoadingOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.LoadingOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.SelectDifferentFolderButton.BackgroundColor   = [0.79,0.95,0.70];
end

if strcmp(Window,"Save_Data_Window")    
    % texts to black
    set(findall(app.SaveDataWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];

    app.SaveTypeDropDown.BackgroundColor   = [0.9,0.9,0.9];

    app.SaveOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.SaveOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.SelectAllButton.BackgroundColor   = [0.9,0.9,0.9];

    app.RawDataButton.BackgroundColor   = [0.9,0.9,0.9];
    app.PreprocessedDataButton.BackgroundColor   = [0.9,0.9,0.9];
    app.SpikeIndiciesButton.BackgroundColor   = [0.9,0.9,0.9];
    app.EventRelatedDataButton.BackgroundColor   = [0.9,0.9,0.9];
    app.EventTimesButton.BackgroundColor   = [0.9,0.9,0.9];
    app.PreprocessedEventRelatedDataButton.BackgroundColor   = [0.9,0.9,0.9];
end

if strcmp(Window,"Probe_View_Help_Window")    
    % texts to black
    set(findall(app.ProbeViewHelpUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ProbeViewHelpUIFigure.Color  = [0.85,0.85,0.85];

    app.HelpInteractiveProbeViewWindowPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.HelpInteractiveProbeViewWindowPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];
end

if strcmp(Window,"Preprocess_Window")    
    % texts to black
    set(findall(app.PreprocessingWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.PreprocessingWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.FilteringPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.FilteringPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.DownsamplingPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.DownsamplingPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.NormalizePanel.BackgroundColor   = [0.85,0.85,0.85];
    app.NormalizePanel.ForegroundColor   = [0.85,0.85,0.85];

    app.OtherUtilitiesPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.OtherUtilitiesPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.GrandAveragePanel.BackgroundColor   = [0.85,0.85,0.85];
    app.GrandAveragePanel.ForegroundColor   = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor    = [0.9,0.9,0.9];

    app.FilterMethodDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.FilterTypeDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.FilterDirectionDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.CuttoffFrequencyHzEditField.BackgroundColor = [0.9,0.9,0.9];
    app.FilterOrderEditField.BackgroundColor = [0.9,0.9,0.9];

    app.PlotExampleButton.BackgroundColor = [0.9,0.9,0.9];
    app.InspectFilterButton.BackgroundColor = [0.9,0.9,0.9];

    app.DownsampleFactorEditField.BackgroundColor = [0.9,0.9,0.9];
    app.PlotExampleButton_2.BackgroundColor = [0.9,0.9,0.9];

    app.PlotExampleButton_4.BackgroundColor = [0.9,0.9,0.9];

    app.PlotExampleButton_3.BackgroundColor = [0.9,0.9,0.9];

    app.DeleteChannelButton.BackgroundColor = [0.9,0.9,0.9];
    app.CutStartandEndofRecordingButton_2.BackgroundColor = [0.9,0.9,0.9];
    app.StimulationArtefactRejectionButton.BackgroundColor = [0.9,0.9,0.9];

end

if strcmp(Window,"Artefact_Rejection_Window")    
    % texts to black
    set(findall(app.ContinousArtefactRejectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.ContinousArtefactRejectionUIFigure.Color  = [0.85,0.85,0.85];

    app.RejectionOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RejectionOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.EventChannelforStimulationDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.RejectionMethodDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.EventstoPlotDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.TimeAroundEventsEditField.BackgroundColor = [0.9,0.9,0.9];
    app.TimeAroundEventsEditField_2.BackgroundColor = [0.9,0.9,0.9];


    app.InformationTextArea.BackgroundColor   = [0.9,0.9,0.9];

    app.UIAxes.Color  = [0.85,0.85,0.85];
    app.UIAxes.XLabel.Color = [0 0 0];
    app.UIAxes.YLabel.Color = [0 0 0];
    app.UIAxes.Title.Color  = [0 0 0];

end

if strcmp(Window,"Ask_SaveName")   
    set(findall(app.SetNameUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SetNameUIFigure.Color  = [0.85,0.85,0.85];
    app.SaveNameEditField.BackgroundColor  = [0.9,0.9,0.9];
end

if strcmp(Window,"BinSizeChange")   
    set(findall(app.BinSizeChangeUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.BinSizeChangeUIFigure.Color  = [0.85,0.85,0.85];
    app.EditField.BackgroundColor  = [0.9,0.9,0.9];
end

if strcmp(Window,"ChangePlotSpeed")   
    set(findall(app.ChannelSpacingSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelSpacingSelectionUIFigure.Color  = [0.85,0.85,0.85];
    app.TimetoJumpsPressEntertoConfirmEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea_4.BackgroundColor  = [0.9,0.9,0.9];
end



if strcmp(Window,"ChangeChannelSpacing")   
    set(findall(app.ChannelSpacingSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelSpacingSelectionUIFigure.Color  = [0.85,0.85,0.85];
    app.SpacingLimitsminmaxEditField.BackgroundColor  = [0.9,0.9,0.9];
   
end



if strcmp(Window,"ControlsWindow")   
    set(findall(app.ControlsWindowsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ControlsWindowsUIFigure.Color  = [0.85,0.85,0.85];

    app.MainWindowPanel.BackgroundColor = [0.85,0.85,0.85];
    app.ProbeViewWindowPanel.BackgroundColor = [0.85,0.85,0.85];

    app.MainWindowPanel.ForegroundColor = [0.85,0.85,0.85];
    app.ProbeViewWindowPanel.ForegroundColor = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor = [0.9,0.9,0.9];
end

if strcmp(Window,"FigureChange")   
    set(findall(app.ChangePlotAppearanceWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChangePlotAppearanceWindowUIFigure.Color  = [0.85,0.85,0.85];
    app.EditField.BackgroundColor  = [0.9,0.9,0.9];
   
end

if strcmp(Window,"ManageDataset")   
    set(findall(app.ManageDatasetComponentsWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ManageDatasetComponentsWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    
    app.ManagementOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.ManagementOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];
    app.DropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.ExportFormatDropDown.BackgroundColor  = [0.9,0.9,0.9];
   
end


if strcmp(Window,"TimeSpanSelection")   
    set(findall(app.ChannelSpacingSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelSpacingSelectionUIFigure.Color  = [0.85,0.85,0.85];

    app.MaxTimeSpansEditField.BackgroundColor  = [0.9,0.9,0.9];
   
end


if strcmp(Window,"LowPassSettings")   
    set(findall(app.SetLowPassFilterSettingsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SetLowPassFilterSettingsUIFigure.Color  = [0.85,0.85,0.85];

    app.MaxTimeSpansEditField.BackgroundColor  = [0.9,0.9,0.9];
   
end

if strcmp(Window,"SpikeTrgAveragePrepro")   
    set(findall(app.PreproSTAWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.PreproSTAWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.FilterOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.FilterOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];

    app.CutoffFrequencyHzEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.FilterOrderEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.SaveasnewPreprocessedDatasetDropDown.BackgroundColor  = [0.9,0.9,0.9];
   
end

if strcmp(Window,"ManageModulesWindow")   
    set(findall(app.ManageModulesWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ManageModulesWindowUIFigure.Color  = [0.85,0.85,0.85];
    app.AllModulesPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.AllModulesPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.CurrentModulesPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.CurrentModulesPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.Panel.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel.ForegroundColor  = [0.85,0.85,0.85];

    app.Panel_1.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel_1.ForegroundColor  = [0.85,0.85,0.85];

    app.Panel_2.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel_2.ForegroundColor  = [0.85,0.85,0.85];

    app.Panel_3.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel_3.ForegroundColor  = [0.85,0.85,0.85];


    app.ListBox_5.BackgroundColor  = [0.9,0.9,0.9];
    app.ListBox_4.BackgroundColor  = [0.9,0.9,0.9];
    app.ListBox_2.BackgroundColor  = [0.9,0.9,0.9];
    app.ListBox.BackgroundColor  = [0.9,0.9,0.9];


    app.ListofSavedModulesTextArea.BackgroundColor  = [0.9,0.9,0.9];

    app.AllModulesPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.AllModulesPanel.ForegroundColor  = [0.85,0.85,0.85];



    app.SelectedModuleDropDown.BackgroundColor  = [0.9,0.9,0.9];
end

if strcmp(Window,"CutTime")   
    set(findall(app.CutRecordingTimeUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CutRecordingTimeUIFigure.Color  = [0.85,0.85,0.85];

    app.CutTimeOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.CutTimeOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];
    
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TimetocutfromstartsEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.TimetocutbeforeendsEditField.BackgroundColor  = [0.9,0.9,0.9];
   
end

if strcmp(Window,"DeleteChannel")   
    set(findall(app.ChannelDeletionWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelDeletionWindowUIFigure.Color  = [0.85,0.85,0.85];
    
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.ChanneltoDelete.BackgroundColor  = [0.9,0.9,0.9];
end


if strcmp(Window,"ContSpectrum")   
    set(findall(app.StaticSpectrumWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.StaticSpectrumWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.StaticSpectrumOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.StaticSpectrumOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];
    
    app.TextArea_2.BackgroundColor  = [0.85,0.85,0.85];
    

    app.AnalysisDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.ChannelDropDown.BackgroundColor  = [0.9,0.9,0.9];

    app.FrequencyRangeHzEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.DataTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];

    app.DataSourceDropDown.BackgroundColor  = [0.9,0.9,0.9];

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

    %Second axis
    app.UIAxes_2.Color  = app.Mainapp.PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;
    app.UIAxes_2.XColor = 'k';  
    %app.UIAxes_2.YColor = 'k';  

    app.UIAxes_2.XTickLabelMode = 'auto';  
    %app.UIAxes_2.YTickLabelMode = 'auto';
    app.UIAxes_2.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    %app.UIAxes_2.YLabel.Color = 'k';

    
   
end

if strcmp(Window,"ImportEvents")   
    set(findall(app.ImportEventsWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ImportEventsWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.ImportSettingsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.ImportSettingsPanel.ForegroundColor  = [0.85,0.85,0.85];
    
    app.Panel.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel.ForegroundColor  = [0.85,0.85,0.85];

    app.Panel_2.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel_2.ForegroundColor  = [0.85,0.85,0.85];

    app.ExtractEventRelatedDataPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.ExtractEventRelatedDataPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.InputChannelSelectionEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.InputChannelSelectionEditField_2.BackgroundColor  = [0.9,0.9,0.9];
    
    app.EventTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor  = [0.9,0.9,0.9];

    app.DatatoUseDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.EventChanneltoUseDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.TimeWindowAfterEventssEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.TimeWindowBeforeEventssEditField.BackgroundColor  = [0.9,0.9,0.9];

    app.TextArea_3.BackgroundColor  = [0.9,0.9,0.9];
end

if strcmp(Window,"ExtractEvents")   
    set(findall(app.ExtractEventsWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ExtractEventsWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.EventExtractionSettingsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.EventExtractionSettingsPanel.ForegroundColor  = [0.85,0.85,0.85];
    
    app.Panel.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel.ForegroundColor  = [0.85,0.85,0.85];

    app.Panel_2.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel_2.ForegroundColor  = [0.85,0.85,0.85];

    app.ExtractEventRelatedDataPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.ExtractEventRelatedDataPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.EventTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea_3.BackgroundColor  = [0.9,0.9,0.9];

    app.FileTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.AnalogThresholdVEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.EventTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.InputChannelSelectionEditField.BackgroundColor  = [0.9,0.9,0.9];
    

    app.DatatoUseDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.EventChanneltoUseDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.TimeWindowAfterEventssEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.TimeWindowBeforeEventssEditField.BackgroundColor  = [0.9,0.9,0.9];
    
end

if strcmp(Window,"PlotImportEvents")   
    set(findall(app.ShowImportedEventChannelUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ShowImportedEventChannelUIFigure.Color  = [0.85,0.85,0.85];

    app.PlotOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.PlotOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];
    
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    
    app.DowsampledSampleRateHzEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.FileTypeDropDown_2.BackgroundColor  = [0.9,0.9,0.9];

    app.UIAxes.Color  = [0.85,0.85,0.85];
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

end

if strcmp(Window,"PlotExtratedEvents")   
    set(findall(app.ShowEventChannelUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ShowEventChannelUIFigure.Color  = [0.85,0.85,0.85];

    app.PlotOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.PlotOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];
    
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    
    app.DowsampledSampleRateHzEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.FileTypeDropDown_2.BackgroundColor  = [0.9,0.9,0.9];
    app.FileTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.FileTypeDropDown_3.BackgroundColor  = [0.9,0.9,0.9];

    app.UIAxes.Color  = [0.85,0.85,0.85];
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
end

if strcmp(Window,"Load_Costume_Triggers")   
    set(findall(app.LoadCostumeTriggerIdentityUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LoadCostumeTriggerIdentityUIFigure.Color  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];
end


if strcmp(Window,"Clean_Events")   
    set(findall(app.CleanEventTriggerUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CleanEventTriggerUIFigure.Color  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];
end

if strcmp(Window,"Clean_Events")   
    set(findall(app.CleanEventTriggerUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CleanEventTriggerUIFigure.Color  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];
end

if strcmp(Window,"Preprocess_Events_Main_Window")   
    set(findall(app.PreprocessEventDataWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.PreprocessEventDataWindowUIFigure.Color  = [0.85,0.85,0.85];
    
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor  = [0.9,0.9,0.9];
end

if strcmp(Window,"Event_Trial_Rejection")   
    set(findall(app.TrialRejectionWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.TrialRejectionWindowUIFigure.Color  = [0.85,0.85,0.85];
    
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.TrialRejectionSettingsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.TrialRejectionSettingsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.ChannelofInterestDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.ClimfromtoEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.RejectTrialsfromtoEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.PlotTrialsfromtoEditField.BackgroundColor  = [0.9,0.9,0.9];

    app.UIAxes.Color  = [0.85,0.85,0.85];
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

    cb = colorbar(app.UIAxes);
    cb.Color = 'k';              % Sets tick mark and label color to black
    cb.Label.Color = 'k';        % Sets the color of the label text
    cb.Label.String = 'Signal [mV]';
    cb.Label.Rotation = 270;

    app.UIAxes_2.Color  = [0.85,0.85,0.85];
    app.UIAxes_2.XColor = 'k';  
    app.UIAxes_2.YColor = 'k';  

    app.UIAxes_2.XTickLabelMode = 'auto';  
    app.UIAxes_2.YTickLabelMode = 'auto';
    app.UIAxes_2.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    app.UIAxes_2.YLabel.Color = 'k';
end

if strcmp(Window,"EventChannelRejection")   
    set(findall(app.ChannelRejectionWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelRejectionWindowUIFigure.Color  = [0.85,0.85,0.85];
    
    app.ChannelSettingsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.ChannelSettingsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.RejectChannelFormat11or110EditField.BackgroundColor  = [0.9,0.9,0.9];

    app.UIAxes.Color  = [0.85,0.85,0.85];
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

end


if strcmp(Window,"EventLFPMain")   
    set(findall(app.Analyse_Event_Related_SignalUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.Analyse_Event_Related_SignalUIFigure.Color  = [0.85,0.85,0.85];
    
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.SelectEventRelatedAnalysisPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.SelectEventRelatedAnalysisPanel.ForegroundColor  = [0.85,0.85,0.85];

end

if strcmp(Window,"EventERP")   
    set(findall(app.EventRelatedAnalysisUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.EventRelatedAnalysisUIFigure.Color  = [0.85,0.85,0.85];

    app.ERPAnalysisSettingsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.ERPAnalysisSettingsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.DataTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.ChannelSelectionDropDown_2.BackgroundColor  = [0.9,0.9,0.9];
    app.EventNumberSelectionEditField.BackgroundColor  = [0.9,0.9,0.9];
    


    app.UIAxes.Color  = app.Mainapp.PlotAppearance.ERPWindow.SingleERP.BackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    

    app.UIAxes_2.Color  = app.Mainapp.PlotAppearance.ERPWindow.MultipleERP.BackgroundColor;
    app.UIAxes_2.XColor = 'k';  
    app.UIAxes_2.YColor = 'k';  

    app.UIAxes_2.XTickLabelMode = 'auto';  
    app.UIAxes_2.YTickLabelMode = 'auto';
    app.UIAxes_2.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    app.UIAxes_2.YLabel.Color = 'k';
end


if strcmp(Window,"EventCSD")   
    set(findall(app.CSDAnalysisUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CSDAnalysisUIFigure.Color  = [0.85,0.85,0.85];
    
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.CSDParameterPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.CSDParameterPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.DataTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.EventNumberSelectionEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.HammWindowEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.ClimminmaxEditField.BackgroundColor  = [0.9,0.9,0.9];
    

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.CSDWindow.BackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.CSDWindow.FontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    
    cb = colorbar(app.UIAxes);
    cb.Color = 'k';              % Sets tick mark and label color to black
    cb.Label.Color = 'k';        % Sets the color of the label text
    cb.Label.String = app.Mainapp.PlotAppearance.CSDWindow.CLabel;
    cb.Label.Rotation = 270;
    cb.FontSize =  app.Mainapp.PlotAppearance.CSDWindow.FontSize;  

end



if strcmp(Window,"EventTF")   
    set(findall(app.TFAnalysisUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.TFAnalysisUIFigure.Color  = [0.85,0.85,0.85];
    
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.EventandChannelSelectionPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.EventandChannelSelectionPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.WaveletAnalysisParameterPanel_2.BackgroundColor  = [0.85,0.85,0.85];
    app.WaveletAnalysisParameterPanel_2.ForegroundColor  = [0.85,0.85,0.85];

    app.AnalysisTypePanel.BackgroundColor  = [0.85,0.85,0.85];
    app.AnalysisTypePanel.ForegroundColor  = [0.85,0.85,0.85];

    app.DataTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.EventNumberSelectionEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.FrequencyRangeminmaxstepsEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.CycleWidthfromto23EditField.BackgroundColor  = [0.9,0.9,0.9];

    app.ClimminmaxEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.WaveletTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.CycleWidthfromto23EditField.BackgroundColor  = [0.9,0.9,0.9];
    

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.TFWindow.BackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.TFWindow.FontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    
    cb = colorbar(app.UIAxes);
    cb.Color = 'k';              % Sets tick mark and label color to black
    cb.Label.String = app.Mainapp.PlotAppearance.TFWindow.CLabel;
    cb.Label.Rotation = 270;
    cb.FontSize =  app.Mainapp.PlotAppearance.TFWindow.FontSize;  
    cb.Label.Color = 'k';        % Sets the color of the label text
end



if strcmp(Window,"EventSpectrum")   
    set(findall(app.EventStaticSpectrumWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.EventStaticSpectrumWindowUIFigure.Color  = [0.85,0.85,0.85];
    
    app.AnalysisSettingsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.AnalysisSettingsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.AnalysisDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.ChannelDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.DataTypeDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.FrequencyRangeHzEditField.BackgroundColor  = [0.9,0.9,0.9];

    app.DataSourceDropDown.BackgroundColor  = [0.9,0.9,0.9];
    app.EventSelectionEditField.BackgroundColor  = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor  = [0.9,0.9,0.9];
    
    app.UIAxes.Color  = app.Mainapp.PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.SpectrumWindow.Data.TimeFontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    


    app.UIAxes_2.Color  = app.Mainapp.PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;
    app.UIAxes_2.XColor = 'k';  


    app.UIAxes_2.XTickLabelMode = 'auto';  

    app.UIAxes_2.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes_2.FontSize = app.Mainapp.PlotAppearance.SpectrumWindow.Data.TimeFontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';

end


if strcmp(Window,"Spike_Detection_Window")    
    % texts to black
    set(findall(app.SpikeDetectionWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.SpikeDetectionWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.Panel.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel.ForegroundColor  = [0.85,0.85,0.85];

    app.Panel_2.BackgroundColor  = [0.85,0.85,0.85];
    app.Panel_2.ForegroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor = [0.9,0.9,0.9];
    app.TextArea_2.BackgroundColor = [0.9,0.9,0.9];
    app.TextArea_3.BackgroundColor = [0.9,0.9,0.9];

    app.DetectionMethodDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.ThresholdEditField.BackgroundColor = [0.9,0.9,0.9];
    app.MeanDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.VerticalSpikeOffsetToleranceSamplesEditField.BackgroundColor = [0.9,0.9,0.9];
    app.MinDepthofArtefactmEditField.BackgroundColor = [0.9,0.9,0.9];
    app.TimeOffsettoCombineSpikeIndiciessEditField.BackgroundColor = [0.9,0.9,0.9];

    app.SorterDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.OptionsDropDown_2.BackgroundColor = [0.9,0.9,0.9];

end

if strcmp(Window,"Spike_Sorting_Parameter")    
    % texts to black
    set(findall(app.SpikeInterfaceParameterSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SpikeInterfaceParameterSelectionUIFigure.Color  = [0.85,0.85,0.85];

    app.GeneralSettingsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.GeneralSettingsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor = [0.9,0.9,0.9];

    app.LoadSavedParameterDropDown.BackgroundColor = [0.9,0.9,0.9];

end

if strcmp(Window,"Load_Sorting_Window")    
    % texts to black
    set(findall(app.LoadSpikeSortingResultsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LoadSpikeSortingResultsUIFigure.Color  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.LoadingOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.LoadingOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.InformationTextArea.BackgroundColor = [0.9,0.9,0.9];

    app.SpikeSorterDropDown.BackgroundColor = [0.9,0.9,0.9];
    app.AmplitudeScalingFactorEditField.BackgroundColor = [0.9,0.9,0.9];

end

if strcmp(Window,"AskForHighPass_Window")    
    % texts to black
    set(findall(app.PreproSTAWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.PreproSTAWindowUIFigure.Color  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    
    app.FilterOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.FilterOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor = [0.9,0.9,0.9];

    app.CutoffFrequencyHzEditField.BackgroundColor = [0.9,0.9,0.9];
    app.FilterOrderEditField.BackgroundColor = [0.9,0.9,0.9];
    app.SaveasnewPreprocessedDatasetDropDown.BackgroundColor = [0.9,0.9,0.9];
end

if strcmp(Window,"Save_for_Sorting_Window")    
    % texts to black
    set(findall(app.SaveforSpikeSortingWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SaveforSpikeSortingWindowUIFigure.Color  = [0.85,0.85,0.85];
    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];

    app.SavingOptionsPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.SavingOptionsPanel.ForegroundColor  = [0.85,0.85,0.85];

    app.InformationTextArea.BackgroundColor = [0.9,0.9,0.9];

    app.Dataset.BackgroundColor = [0.9,0.9,0.9];
    app.SaveFormatDropDown_2.BackgroundColor = [0.9,0.9,0.9];
    app.SaveFormatDropDown.BackgroundColor = [0.9,0.9,0.9];

end


if strcmp(Window,"LiveCSDWindow")    
    % texts to black
    set(findall(app.CSDWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CSDWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    
    app.CurrentSourceDensityOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.CurrentSourceDensityOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.HammWindowEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.DataTypeDropDown.BackgroundColor   = [0.9,0.9,0.9];

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.LiveCSDWindow.BackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.LiveCSDWindow.FontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    
    cb = colorbar(app.UIAxes);
    cb.Color = 'k';              % Sets tick mark and label color to black
    cb.Label.String = app.Mainapp.PlotAppearance.LiveCSDWindow.CLabel;
    cb.Label.Rotation = 270;
    cb.FontSize =  app.Mainapp.PlotAppearance.LiveCSDWindow.FontSize;
    cb.Label.Color = 'k';        % Sets the color of the label text

end

if strcmp(Window,"LiveSpectralPowerWindow")    
    % texts to black
    set(findall(app.PowerEstimateWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.PowerEstimateWindowUIFigure.Color  = [0.85,0.85,0.85];
    
    app.PowerEstimateOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.PowerEstimateOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.DataTypeDropDown.BackgroundColor   = [0.9,0.9,0.9];

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.LivePowerEstimateWindow.BackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.LivePowerEstimateWindow.FontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    
end

if strcmp(Window,"LiveSpikeRatePowerWindow")    
    % texts to black
    set(findall(app.SpikeRateWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SpikeRateWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.LeftPanel.BackgroundColor  = [0.85,0.85,0.85];
    app.RightPanel.BackgroundColor  = [0.85,0.85,0.85];
    
    app.SpikeRateOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.SpikeRateOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.LiveSpikeRateWindow.BackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.LiveSpikeRateWindow.FontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    
end

if strcmp(Window,"ContSpikeAnalysis")    
    % texts to black
    set(findall(app.ContinuousSpikeAnalysisUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ContinuousSpikeAnalysisUIFigure.Color  = [0.85,0.85,0.85];

    app.SpikeAnalysisOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.SpikeAnalysisOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];
    app.WaveformOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.WaveformOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];
    app.TypeofAnalysisDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.ClustertoshowDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.EventstoshowDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.SpikeRateNumBinsEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.TimeWindowSpiketriggredLFPEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.WaveformSelectionforPlottingEditField.BackgroundColor   = [0.9,0.9,0.9];

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.XTickLabelMode = 'auto';  
    
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotFontSize;

    if ~strcmp(app.TypeofAnalysisDropDown.Value,"Spike Map")
        app.UIAxes.YColor = 'k';  
        app.UIAxes.YTickLabelMode = 'auto';
    else
        % Disable XTick labels
        app.UIAxes.XTickLabel = [];
        
        % Remove xlabel
        app.UIAxes.XLabel.String = '';
    end

    %app.UIAxes.FontColor = 'k';  % Tick label color
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_3.Title.Color = 'k';
    app.UIAxes_3.XLabel.Color = 'k';
    app.UIAxes_3.YLabel.Color = 'k';

    app.UIAxes_3.Color  = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRTimePlotBackgroundColor;
    app.UIAxes_3.XColor = 'k';  
    app.UIAxes_3.YColor = 'k';  

    app.UIAxes_3.XTickLabelMode = 'auto';  
    app.UIAxes_3.YTickLabelMode = 'auto';
    app.UIAxes_3.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes_3.FontSize = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRTimePlotFontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_5.Title.Color = 'k';
    app.UIAxes_5.XLabel.Color = 'k';
    app.UIAxes_5.YLabel.Color = 'k';

    app.UIAxes_5.Color  = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRChannelPlotBackgroundColor;
    app.UIAxes_5.XColor = 'k';  

    app.UIAxes_5.XTickLabelMode = 'auto';  
    app.UIAxes_5.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes_5.FontSize = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRChannelPlotFontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_5.Title.Color = 'k';
    app.UIAxes_5.XLabel.Color = 'k';
    
end

if strcmp(Window,"ContUnitAnalysis")    
    % texts to black
    set(findall(app.UnitAnalysisWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.UnitAnalysisWindowUIFigure.Color  = [0.85,0.85,0.85];

    app.PlotColumnSettingsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.PlotColumnSettingsPanel.ForegroundColor   = [0.85,0.85,0.85];
    app.GeneralSettingsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.GeneralSettingsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.UnitstoShowEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.NumWaveformsEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.UnitstoShowEditField_2.BackgroundColor   = [0.9,0.9,0.9];
    app.NumWaveformsEditField_2.BackgroundColor   = [0.9,0.9,0.9];
    
    app.MaxISItoshowsEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.BinNumberISIEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.DeleteUnitDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.TimeLagmsEditField.BackgroundColor   = [0.9,0.9,0.9];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_1.Title.Color = 'k';
    app.UIAxes_1.XLabel.Color = 'k';
    app.UIAxes_1.YLabel.Color = 'k';

    app.UIAxes_1.Color  = [0.85,0.85,0.85];
    app.UIAxes_1.XColor = 'k';  

    app.UIAxes_1.XTickLabelMode = 'auto';  
    app.UIAxes_1.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_1.Title.Color = 'k';
    app.UIAxes_1.XLabel.Color = 'k';
    
    app.UIAxes_1.YLabel.Color = 'k';
    app.UIAxes_1.YColor = 'k';  


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_4.Title.Color = 'k';
    app.UIAxes_4.XLabel.Color = 'k';
    app.UIAxes_4.YLabel.Color = 'k';

    app.UIAxes_4.Color  = [0.85,0.85,0.85];
    app.UIAxes_4.XColor = 'k';  

    app.UIAxes_4.XTickLabelMode = 'auto';  
    app.UIAxes_4.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_4.Title.Color = 'k';
    app.UIAxes_4.XLabel.Color = 'k';
    
    app.UIAxes_4.YLabel.Color = 'k';
    app.UIAxes_4.YColor = 'k';  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_7.Title.Color = 'k';
    app.UIAxes_7.XLabel.Color = 'k';
    app.UIAxes_7.YLabel.Color = 'k';

    app.UIAxes_7.Color  = [0.85,0.85,0.85];
    app.UIAxes_7.XColor = 'k';  
    
    app.UIAxes_7.XTickLabelMode = 'auto';  
    app.UIAxes_7.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_7.Title.Color = 'k';
    app.UIAxes_7.XLabel.Color = 'k';

    app.UIAxes_7.YLabel.Color = 'k';
    app.UIAxes_7.YColor = 'k';  



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    app.UIAxes_2.YLabel.Color = 'k';

    app.UIAxes_2.Color  = [0.85,0.85,0.85];
    app.UIAxes_2.XColor = 'k';  

    app.UIAxes_2.XTickLabelMode = 'auto';  
    app.UIAxes_2.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    
    app.UIAxes_2.YLabel.Color = 'k';
    app.UIAxes_2.YColor = 'k';  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_5.Title.Color = 'k';
    app.UIAxes_5.XLabel.Color = 'k';
    app.UIAxes_5.YLabel.Color = 'k';

    app.UIAxes_5.Color  = [0.85,0.85,0.85];
    app.UIAxes_5.XColor = 'k';  

    app.UIAxes_5.XTickLabelMode = 'auto';  
    app.UIAxes_5.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_5.Title.Color = 'k';
    app.UIAxes_5.XLabel.Color = 'k';
    
    app.UIAxes_5.YLabel.Color = 'k';
    app.UIAxes_5.YColor = 'k';  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_8.Title.Color = 'k';
    app.UIAxes_8.XLabel.Color = 'k';
    app.UIAxes_8.YLabel.Color = 'k';

    app.UIAxes_8.Color  = [0.85,0.85,0.85];
    app.UIAxes_8.XColor = 'k';  

    app.UIAxes_8.XTickLabelMode = 'auto';  
    app.UIAxes_8.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_8.Title.Color = 'k';
    app.UIAxes_8.XLabel.Color = 'k';
    
    app.UIAxes_8.YLabel.Color = 'k';
    app.UIAxes_8.YColor = 'k';  

end


if strcmp(Window,"EventSpikeAnalysis")    
    % texts to black
    set(findall(app.EventRelatedSpikeAnalysisUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.EventRelatedSpikeAnalysisUIFigure.Color  = [0.85,0.85,0.85];

    app.SpikeAnalysisOptionsPanel.BackgroundColor   = [0.85,0.85,0.85];
    app.SpikeAnalysisOptionsPanel.ForegroundColor   = [0.85,0.85,0.85];

    app.TextArea.BackgroundColor   = [0.9,0.9,0.9];
    app.AnalysisTypeDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.ClustertoshowDropDown.BackgroundColor   = [0.9,0.9,0.9];
    app.EventRangeEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.BaselineWindowStartStopinsEditField.BackgroundColor   = [0.9,0.9,0.9];

    app.SpikeRateNumBinsEditField.BackgroundColor   = [0.9,0.9,0.9];
    app.TimeWindowSpiketriggredLFPEditField.BackgroundColor   = [0.9,0.9,0.9];

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotBackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.XTickLabelMode = 'auto';  
    
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.InternalEventSpikePlot.MainPlotFontSize;

    if ~strcmp(app.AnalysisTypeDropDown.Value,"Spike Map")
        app.UIAxes.YColor = 'k';  
        app.UIAxes.YTickLabelMode = 'auto';
    else
        % Disable XTick labels
        app.UIAxes.XTickLabel = [];
        
        % Remove xlabel
        app.UIAxes.XLabel.String = '';
    end

    %app.UIAxes.FontColor = 'k';  % Tick label color
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_3.Title.Color = 'k';
    app.UIAxes_3.XLabel.Color = 'k';
    app.UIAxes_3.YLabel.Color = 'k';

    app.UIAxes_3.Color  = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRTimePlotBackgroundColor;
    app.UIAxes_3.XColor = 'k';  
    app.UIAxes_3.YColor = 'k';  

    app.UIAxes_3.XTickLabelMode = 'auto';  
    app.UIAxes_3.YTickLabelMode = 'auto';
    app.UIAxes_3.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes_3.FontSize = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRTimePlotFontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_5.Title.Color = 'k';
    app.UIAxes_5.XLabel.Color = 'k';
    app.UIAxes_5.YLabel.Color = 'k';

    app.UIAxes_5.Color  = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRChannelPlotBackgroundColor;
    app.UIAxes_5.XColor = 'k';  

    app.UIAxes_5.XTickLabelMode = 'auto';  
    app.UIAxes_5.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes_5.FontSize = app.Mainapp.PlotAppearance.InternalEventSpikePlot.SRChannelPlotFontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_5.Title.Color = 'k';
    app.UIAxes_5.XLabel.Color = 'k';
    
end