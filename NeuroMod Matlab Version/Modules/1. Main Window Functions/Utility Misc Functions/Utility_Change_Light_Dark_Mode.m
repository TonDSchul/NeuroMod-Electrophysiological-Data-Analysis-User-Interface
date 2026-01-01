function app = Utility_Change_Light_Dark_Mode(app,Window)

%________________________________________________________________________________________
%% Function to change the color scheme of EVERY window in the GUI. This is first to enable the user to select different colotschemes.
%% But also it circumvents issues when activating the matlab dark mode (i.e. automatic black plot background in which things sometimes are harder to see)

% At the start of this function colors for colorschemes are created. One
% color is for the general backround and one for all selectable/editable
% fields an plots (two color scheme).
% This function is executed in the startup section of every window with
% Window variabel holding info which window it is 
% In normal GUI operation user can select a colorscheme or Mode. Based on

% Input Arguments:
% 1. app: main window app object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


if isfield(app,'Mainapp') || isprop(app,'Mainapp') || ~isprop(app,'Image')
    try
        Mode = app.Mainapp.Colorscheme;
    catch
        Mode = 'DarkMode_Dark_Light';
    end
else
    try
        Mode = app.Colorscheme;
    catch
        Mode = 'DarkMode_Dark_Light';
    end
end

%%%
if strcmp(Mode,'DarkMode_Dark_Light')
    WindowBackgroundColor = [0.8,0.8,0.8];
    ComponentsInWindowColor = [0.85,0.85,0.85];
elseif strcmp(Mode,'DarkMode_Light_Dark')
    ComponentsInWindowColor = [0.8,0.8,0.8];
    WindowBackgroundColor = [0.85,0.85,0.85];

elseif strcmp(Mode,'LightMode_Dark_Light')
    ComponentsInWindowColor = [0.95,0.95,0.95];
    WindowBackgroundColor = [1,1,1];
elseif strcmp(Mode,'LightMode_Light_Dark')
    ComponentsInWindowColor = [1,1,1];
    WindowBackgroundColor = [0.95,0.95,0.95];
end

if strcmp(Window,'MainWindow')
    % texts to black
    set(findall(app.NeuromodToolboxMainWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    % backgrounds to grey
    app.NeuromodToolboxMainWindowUIFigure.Color       = WindowBackgroundColor;
    app.ManageDatasetPanel.BackgroundColor            = WindowBackgroundColor;
    app.MainPlotAnalysisModulePanel.BackgroundColor   = WindowBackgroundColor;
    app.ContinousDataModulePanel.BackgroundColor      = WindowBackgroundColor;
    app.EventDataModulePanel.BackgroundColor          = WindowBackgroundColor;
    app.SpikeModulePanel_2.BackgroundColor            = WindowBackgroundColor;

    app.ManageDatasetPanel.ForegroundColor            = WindowBackgroundColor;
    app.MainPlotAnalysisModulePanel.ForegroundColor   = WindowBackgroundColor;
    app.ContinousDataModulePanel.ForegroundColor      = WindowBackgroundColor;
    app.EventDataModulePanel.ForegroundColor          = WindowBackgroundColor;
    app.SpikeModulePanel_2.ForegroundColor            = WindowBackgroundColor;

    app.TimeSpanControlDropDown.BackgroundColor       = ComponentsInWindowColor;
    app.TimeRangeViewBox.BackgroundColor              = ComponentsInWindowColor;
    app.DropDown.BackgroundColor                      = ComponentsInWindowColor;
    app.DropDown_2.BackgroundColor                    = ComponentsInWindowColor;
    app.EventChannelDropDown.BackgroundColor          = ComponentsInWindowColor;
    app.EventTriggerNumberField.BackgroundColor       = ComponentsInWindowColor;
    
    app.ListBox_5.BackgroundColor                     = ComponentsInWindowColor;
    app.ListBox_6.BackgroundColor                     = ComponentsInWindowColor;
    app.ListBox_3.BackgroundColor                     = ComponentsInWindowColor;
    app.ListBox_2.BackgroundColor                     = ComponentsInWindowColor;
    app.ListBox.BackgroundColor                       = ComponentsInWindowColor;

    app.TimeSpanandAxisControlPanel.BackgroundColor   = WindowBackgroundColor;
    app.ChannelandPlotControlPanel.BackgroundColor    = WindowBackgroundColor;
    app.TimeSpanandAxisControlPanel.ForegroundColor   = WindowBackgroundColor;
    app.ChannelandPlotControlPanel.ForegroundColor    = WindowBackgroundColor;

    app.TextArea.BackgroundColor                      = ComponentsInWindowColor;
    app.RecordingandDatasetInformationLabel.FontColor = [0,0,0];
    
    % Plot text to black
    if ~isempty(app.PlotAppearance)
        app.UIAxes.Color  = app.PlotAppearance.MainWindow.Data.Color.MainBackground;
    else
        app.UIAxes.Color  = WindowBackgroundColor;
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
    
    app.RUNButton.BackgroundColor = ComponentsInWindowColor;
    app.RUNButton_2.BackgroundColor = ComponentsInWindowColor;
    app.RUNButton_3.BackgroundColor = ComponentsInWindowColor;
    app.RUNButton_4.BackgroundColor = ComponentsInWindowColor;
    app.RUNButton_5.BackgroundColor = ComponentsInWindowColor;

end

if strcmp(Window,"Probe_View_Window")    
    % texts to black
    set(findall(app.ProbeViewUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ProbeViewUIFigure.Color  = WindowBackgroundColor;

    app.ChangeforWindowDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.ChannelSelectionEditField.BackgroundColor   = ComponentsInWindowColor;
    
    app.Panel.BackgroundColor   = WindowBackgroundColor;
    app.Panel.ForegroundColor   = WindowBackgroundColor;

    app.ScrollandclicktosetactiveanalysischannelLabel.BackgroundColor = WindowBackgroundColor;
    % Plot text to black
    app.UIAxes.Color  = WindowBackgroundColor;
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
    app.ExtractDataWindowUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.TextArea_3.BackgroundColor = ComponentsInWindowColor;
    
    app.TextArea_4.BackgroundColor = WindowBackgroundColor;
    app.RecordingSystemDropDown_2.BackgroundColor = ComponentsInWindowColor;
    app.FormatToSaveandReadintoMatlabDropDown.BackgroundColor = ComponentsInWindowColor;
    app.AdditionalAmplificationFactorEditField_3.BackgroundColor = ComponentsInWindowColor;

    app.ExtractionOptionsPanel.BackgroundColor = WindowBackgroundColor;
    app.ExtractionOptionsPanel.ForegroundColor = WindowBackgroundColor;
    app.AdditionalAmplificationFactorEditField_2.BackgroundColor = ComponentsInWindowColor;

    app.RecordingSystemDropDown.BackgroundColor                = ComponentsInWindowColor;
    app.FileTypeDropDown.BackgroundColor                       = ComponentsInWindowColor;
    app.AdditionalAmplificationFactorEditField.BackgroundColor = ComponentsInWindowColor;
end

if strcmp(Window,"ProbeLayout_Window")    
    % texts to black
    set(findall(app.ProbeLayoutWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ProbeLayoutWindowUIFigure.Color  = WindowBackgroundColor;

    app.ChannelOrderField.BackgroundColor   = ComponentsInWindowColor;
    app.ActiveChannelField.BackgroundColor   = ComponentsInWindowColor;

    app.SetProbeGeometryPanel.BackgroundColor   = WindowBackgroundColor;
    app.SetProbeGeometryPanel.ForegroundColor = WindowBackgroundColor;

    app.AdditionalOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.AdditionalOptionsPanel.ForegroundColor = WindowBackgroundColor;
    
    app.SetChannelInformationPanel.BackgroundColor   = WindowBackgroundColor;
    app.SetChannelInformationPanel.ForegroundColor = WindowBackgroundColor;

    
    app.LoadChannelOrderButton.BackgroundColor   = [0.79,0.95,0.70];
    app.LoadActiveChannelSelectionButton.BackgroundColor   = [0.79,0.95,0.70];

    app.NrChannelEditField.BackgroundColor   = ComponentsInWindowColor;
    app.ChannelSpacingumEditField.BackgroundColor   = ComponentsInWindowColor;
    app.HorizontalOffsetumEditField.BackgroundColor   = ComponentsInWindowColor;
    app.VerticalOffsetumEditField.BackgroundColor   = ComponentsInWindowColor;
    app.ChannelRowsDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.VerticalOffsetumEditField_2.BackgroundColor   = ComponentsInWindowColor;

    app.UIAxes.Color  = ComponentsInWindowColor;
    app.UIAxes.XColor = [0 0 0];
    app.UIAxes.YColor = [0 0 0];
    app.UIAxes.Title.Color  = [0 0 0];

    app.UIAxes2.Color  = ComponentsInWindowColor;
    app.UIAxes2.XColor = [0 0 0];
    app.UIAxes2.YColor = [0 0 0];
    app.UIAxes2.Title.Color  = [0 0 0];

end

if strcmp(Window,"NP1_LFP_AP")    

    % texts to black
    set(findall(app.NPDataTypeUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    app.NPDataTypeUIFigure.Color  = WindowBackgroundColor;


    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor   = WindowBackgroundColor;

    app.TextArea_3.BackgroundColor   = WindowBackgroundColor;
end

if strcmp(Window,"OE_Multiple_Recordings_Window")    
    % texts to black
    set(findall(app.SelectRecordingWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    app.SelectRecordingWindowUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor   = WindowBackgroundColor;

    app.TextArea_3.BackgroundColor   = WindowBackgroundColor;

    app.RecordingstoselectEditField.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Spike2_Select_Event_Channel_Window")    
    % texts to black
    set(findall(app.Spike2SelectEventChannelUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    app.Spike2SelectEventChannelUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.Panel.BackgroundColor   = WindowBackgroundColor;
    app.Panel.ForegroundColor   = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = WindowBackgroundColor;
    app.TextArea_2.BackgroundColor   = WindowBackgroundColor;

    app.EventChannelSelectionIntemptyfornonEditField.BackgroundColor   = ComponentsInWindowColor;

end


if strcmp(Window,"Load_Data_Window")    
    % texts to black
    set(findall(app.LoadDataWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    app.LoadDataWindowUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;

    app.DropDown.BackgroundColor   = ComponentsInWindowColor;
    app.DropDown_2.BackgroundColor   = ComponentsInWindowColor;
    app.DropDown_3.BackgroundColor   = ComponentsInWindowColor;

    app.LoadingOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.LoadingOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.SelectDifferentFolderButton.BackgroundColor   = [0.79,0.95,0.70];
end

if strcmp(Window,"Save_Data_Window")    
    % texts to black
    set(findall(app.SaveDataWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    app.SaveDataWindowUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;

    app.SaveTypeDropDown.BackgroundColor   = ComponentsInWindowColor;

    app.SaveOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.SaveOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.SelectAllButton.BackgroundColor   = ComponentsInWindowColor;

    app.RawDataButton.BackgroundColor   = ComponentsInWindowColor;
    app.PreprocessedDataButton.BackgroundColor   = ComponentsInWindowColor;
    app.SpikeIndiciesButton.BackgroundColor   = ComponentsInWindowColor;
    app.EventRelatedDataButton.BackgroundColor   = ComponentsInWindowColor;
    app.EventTimesButton.BackgroundColor   = ComponentsInWindowColor;
    app.PreprocessedEventRelatedDataButton.BackgroundColor   = ComponentsInWindowColor;
    app.SaveTypeDropDown_2.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Probe_View_Help_Window")    
    % texts to black
    set(findall(app.ProbeViewHelpUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ProbeViewHelpUIFigure.Color  = WindowBackgroundColor;

    app.HelpInteractiveProbeViewWindowPanel.BackgroundColor   = WindowBackgroundColor;
    app.HelpInteractiveProbeViewWindowPanel.ForegroundColor   = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Preprocess_Window")    
    % texts to black
    set(findall(app.PreprocessingWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.PreprocessingWindowUIFigure.Color  = WindowBackgroundColor;

    app.FilteringPanel.BackgroundColor   = WindowBackgroundColor;
    app.FilteringPanel.ForegroundColor   = WindowBackgroundColor;

    app.DownsamplingPanel.BackgroundColor   = WindowBackgroundColor;
    app.DownsamplingPanel.ForegroundColor   = WindowBackgroundColor;

    app.NormalizePanel.BackgroundColor   = WindowBackgroundColor;
    app.NormalizePanel.ForegroundColor   = WindowBackgroundColor;

    app.OtherUtilitiesPanel.BackgroundColor   = WindowBackgroundColor;
    app.OtherUtilitiesPanel.ForegroundColor   = WindowBackgroundColor;

    app.GrandAveragePanel.BackgroundColor   = WindowBackgroundColor;
    app.GrandAveragePanel.ForegroundColor   = WindowBackgroundColor;

    app.TextArea.BackgroundColor    = ComponentsInWindowColor;

    app.FilterMethodDropDown.BackgroundColor = ComponentsInWindowColor;
    app.FilterTypeDropDown.BackgroundColor = ComponentsInWindowColor;
    app.FilterDirectionDropDown.BackgroundColor = ComponentsInWindowColor;
    app.CuttoffFrequencyHzEditField.BackgroundColor = ComponentsInWindowColor;
    app.FilterOrderEditField.BackgroundColor = ComponentsInWindowColor;
    app.ArtefactSubspaceReconstructionButton.BackgroundColor = ComponentsInWindowColor;
    app.PlotExampleButton.BackgroundColor = ComponentsInWindowColor;
    app.InspectFilterButton.BackgroundColor = ComponentsInWindowColor;

    app.DownsampleFactorEditField.BackgroundColor = ComponentsInWindowColor;
    app.PlotExampleButton_2.BackgroundColor = ComponentsInWindowColor;

    app.PlotExampleButton_4.BackgroundColor = ComponentsInWindowColor;

    app.PlotExampleButton_3.BackgroundColor = ComponentsInWindowColor;

    app.DeleteChannelButton.BackgroundColor = ComponentsInWindowColor;
    app.CutStartandEndofRecordingButton_2.BackgroundColor = ComponentsInWindowColor;
    app.StimulationArtefactRejectionButton.BackgroundColor = ComponentsInWindowColor;
    app.DeleteEventTriggerIndicesButton.BackgroundColor = ComponentsInWindowColor;
end

if strcmp(Window,"Artefact_Rejection_Window")    
    % texts to black
    set(findall(app.ContinousArtefactRejectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.ContinousArtefactRejectionUIFigure.Color  = WindowBackgroundColor;

    app.RejectionOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.RejectionOptionsPanel.ForegroundColor  = WindowBackgroundColor;

    app.EventChannelforStimulationDropDown.BackgroundColor = ComponentsInWindowColor;
    app.RejectionMethodDropDown.BackgroundColor = ComponentsInWindowColor;
    app.EventstoPlotDropDown.BackgroundColor = ComponentsInWindowColor;
    app.TimeAroundEventsEditField.BackgroundColor = ComponentsInWindowColor;
    app.TimeAroundEventsEditField_2.BackgroundColor = ComponentsInWindowColor;
    app.TimeAroundEventsEditField_3.BackgroundColor = ComponentsInWindowColor;

    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;

    app.UIAxes.Color  = ComponentsInWindowColor;
    app.UIAxes.XLabel.Color = [0 0 0];
    app.UIAxes.YLabel.Color = [0 0 0];
    app.UIAxes.Title.Color  = [0 0 0];

end

if strcmp(Window,"Ask_SaveName")   
    set(findall(app.SetNameUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SetNameUIFigure.Color  = WindowBackgroundColor;
    app.SaveNameEditField.BackgroundColor  = ComponentsInWindowColor;
end

if strcmp(Window,"BinSizeChange")   
    set(findall(app.BinSizeChangeUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.BinSizeChangeUIFigure.Color  = WindowBackgroundColor;
    app.EditField.BackgroundColor  = ComponentsInWindowColor;
end

if strcmp(Window,"ChangePlotSpeed")   
    set(findall(app.ChannelSpacingSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelSpacingSelectionUIFigure.Color  = WindowBackgroundColor;
    app.TimetoJumpsPressEntertoConfirmEditField.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea_4.BackgroundColor  = ComponentsInWindowColor;
end



if strcmp(Window,"ChangeChannelSpacing")   
    set(findall(app.ChannelSpacingSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelSpacingSelectionUIFigure.Color  = WindowBackgroundColor;
    app.SpacingLimitsminmaxEditField.BackgroundColor  = ComponentsInWindowColor;
   
end



if strcmp(Window,"ControlsWindow")   
    set(findall(app.ControlsWindowsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ControlsWindowsUIFigure.Color  = WindowBackgroundColor;

    app.MainWindowPanel.BackgroundColor = WindowBackgroundColor;
    app.ProbeViewWindowPanel.BackgroundColor = WindowBackgroundColor;

    app.MainWindowPanel.ForegroundColor = WindowBackgroundColor;
    app.ProbeViewWindowPanel.ForegroundColor = WindowBackgroundColor;

    app.TextArea.BackgroundColor = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor = ComponentsInWindowColor;
end

if strcmp(Window,"FigureChange")   
    set(findall(app.ChangePlotAppearanceWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChangePlotAppearanceWindowUIFigure.Color  = WindowBackgroundColor;
    app.EditField.BackgroundColor  = ComponentsInWindowColor;
   
end

if strcmp(Window,"ManageDataset")   
    set(findall(app.ManageDatasetComponentsWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ManageDatasetComponentsWindowUIFigure.Color  = WindowBackgroundColor;

    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    
    app.ManagementOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.ManagementOptionsPanel.ForegroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor  = ComponentsInWindowColor;
    app.DropDown.BackgroundColor  = ComponentsInWindowColor;
    app.ExportFormatDropDown.BackgroundColor  = ComponentsInWindowColor;
   
end


if strcmp(Window,"TimeSpanSelection")   
    set(findall(app.ChannelSpacingSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelSpacingSelectionUIFigure.Color  = WindowBackgroundColor;

    app.MaxTimeSpansEditField.BackgroundColor  = ComponentsInWindowColor;
   
end


if strcmp(Window,"LowPassSettings")   
    set(findall(app.SetLowPassFilterSettingsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SetLowPassFilterSettingsUIFigure.Color  = WindowBackgroundColor;

    app.MaxTimeSpansEditField.BackgroundColor  = ComponentsInWindowColor;
   
end

if strcmp(Window,"SpikeTrgAveragePrepro")   
    set(findall(app.PreproSTLFPWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.PreproSTLFPWindowUIFigure.Color  = WindowBackgroundColor;

    app.FilterOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.FilterOptionsPanel.ForegroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor  = ComponentsInWindowColor;

    app.CutoffFrequencyHzEditField.BackgroundColor  = ComponentsInWindowColor;
    app.FilterOrderEditField.BackgroundColor  = ComponentsInWindowColor;
    app.SaveasnewPreprocessedDatasetDropDown.BackgroundColor  = ComponentsInWindowColor;
   
end

if strcmp(Window,"ManageModulesWindow")   
    set(findall(app.ManageModulesWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ManageModulesWindowUIFigure.Color  = WindowBackgroundColor;
    app.AllModulesPanel.BackgroundColor  = WindowBackgroundColor;
    app.AllModulesPanel.ForegroundColor  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.CurrentModulesPanel.BackgroundColor  = WindowBackgroundColor;
    app.CurrentModulesPanel.ForegroundColor  = WindowBackgroundColor;

    app.Panel.BackgroundColor  = WindowBackgroundColor;
    app.Panel.ForegroundColor  = WindowBackgroundColor;

    app.Panel_1.BackgroundColor  = WindowBackgroundColor;
    app.Panel_1.ForegroundColor  = WindowBackgroundColor;

    app.Panel_2.BackgroundColor  = WindowBackgroundColor;
    app.Panel_2.ForegroundColor  = WindowBackgroundColor;

    app.Panel_3.BackgroundColor  = WindowBackgroundColor;
    app.Panel_3.ForegroundColor  = WindowBackgroundColor;


    app.ListBox_5.BackgroundColor  = ComponentsInWindowColor;
    app.ListBox_4.BackgroundColor  = ComponentsInWindowColor;
    app.ListBox_2.BackgroundColor  = ComponentsInWindowColor;
    app.ListBox.BackgroundColor  = ComponentsInWindowColor;


    app.ListofSavedModulesTextArea.BackgroundColor  = ComponentsInWindowColor;

    app.AllModulesPanel.BackgroundColor  = WindowBackgroundColor;
    app.AllModulesPanel.ForegroundColor  = WindowBackgroundColor;



    app.SelectedModuleDropDown.BackgroundColor  = ComponentsInWindowColor;
end

if strcmp(Window,"CutTime")   
    set(findall(app.CutRecordingTimeUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CutRecordingTimeUIFigure.Color  = WindowBackgroundColor;

    app.CutTimeOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.CutTimeOptionsPanel.ForegroundColor  = WindowBackgroundColor;
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.TimetocutfromstartsEditField.BackgroundColor  = ComponentsInWindowColor;
    app.TimetocutbeforeendsEditField.BackgroundColor  = ComponentsInWindowColor;
   
end

if strcmp(Window,"DeleteChannel")   
    set(findall(app.ChannelDeletionWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelDeletionWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.ChanneltoDelete.BackgroundColor  = ComponentsInWindowColor;
end


if strcmp(Window,"ContSpectrum")   
    set(findall(app.StaticSpectrumWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.StaticSpectrumWindowUIFigure.Color  = WindowBackgroundColor;

    app.StaticSpectrumOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.StaticSpectrumOptionsPanel.ForegroundColor  = WindowBackgroundColor;
    
    app.TextArea_2.BackgroundColor  = WindowBackgroundColor;
    

    app.AnalysisDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.ChannelDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.FrequencyRangeHzEditField_2.BackgroundColor  = ComponentsInWindowColor;
    app.FrequencyRangeHzEditField.BackgroundColor  = ComponentsInWindowColor;
    app.DataTypeDropDown.BackgroundColor  = ComponentsInWindowColor;

    app.DataSourceDropDown.BackgroundColor  = ComponentsInWindowColor;

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
    set(findall(app.ImportTriggerTimesWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ImportTriggerTimesWindowUIFigure.Color  = WindowBackgroundColor;

    app.ImportSettingsPanel.BackgroundColor  = WindowBackgroundColor;
    app.ImportSettingsPanel.ForegroundColor  = WindowBackgroundColor;
    
    app.Panel.BackgroundColor  = WindowBackgroundColor;
    app.Panel.ForegroundColor  = WindowBackgroundColor;

    app.Panel_2.BackgroundColor  = WindowBackgroundColor;
    app.Panel_2.ForegroundColor  = WindowBackgroundColor;

    app.ExtractEventRelatedDataPanel.BackgroundColor  = WindowBackgroundColor;
    app.ExtractEventRelatedDataPanel.ForegroundColor  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.InputChannelSelectionEditField.BackgroundColor  = ComponentsInWindowColor;
    app.InputChannelSelectionEditField_2.BackgroundColor  = ComponentsInWindowColor;
    
    app.EventTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor  = ComponentsInWindowColor;

    app.TimeWindowAfterEventssEditField.BackgroundColor  = ComponentsInWindowColor;
    app.TimeWindowBeforeEventssEditField.BackgroundColor  = ComponentsInWindowColor;
end

if strcmp(Window,"ExtractEvents")   
    set(findall(app.ExtractTriggerTimesWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ExtractTriggerTimesWindowUIFigure.Color  = WindowBackgroundColor;

    app.EventExtractionSettingsPanel.BackgroundColor  = WindowBackgroundColor;
    app.EventExtractionSettingsPanel.ForegroundColor  = WindowBackgroundColor;
    
    app.Panel.BackgroundColor  = WindowBackgroundColor;
    app.Panel.ForegroundColor  = WindowBackgroundColor;

    app.Panel_2.BackgroundColor  = WindowBackgroundColor;
    app.Panel_2.ForegroundColor  = WindowBackgroundColor;

    app.ExtractEventRelatedDataPanel.BackgroundColor  = WindowBackgroundColor;
    app.ExtractEventRelatedDataPanel.ForegroundColor  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.EventTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor  = ComponentsInWindowColor;

    app.FileTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.AnalogThresholdVEditField.BackgroundColor  = ComponentsInWindowColor;
    app.EventTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.InputChannelSelectionEditField.BackgroundColor  = ComponentsInWindowColor;
    
    app.TimeWindowAfterEventssEditField.BackgroundColor  = ComponentsInWindowColor;
    app.TimeWindowBeforeEventssEditField.BackgroundColor  = ComponentsInWindowColor;
    
end

if strcmp(Window,"PlotImportEvents")   
    set(findall(app.ShowImportedEventChannelUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ShowImportedEventChannelUIFigure.Color  = WindowBackgroundColor;

    app.PlotOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.PlotOptionsPanel.ForegroundColor  = WindowBackgroundColor;
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    
    app.DowsampledSampleRateHzEditField.BackgroundColor  = ComponentsInWindowColor;
    app.FileTypeDropDown_2.BackgroundColor  = ComponentsInWindowColor;

    app.UIAxes.Color  = ComponentsInWindowColor;
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
    
    app.ShowEventChannelUIFigure.Color  = WindowBackgroundColor;

    app.PlotOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.PlotOptionsPanel.ForegroundColor  = WindowBackgroundColor;
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    
    app.DowsampledSampleRateHzEditField.BackgroundColor  = ComponentsInWindowColor;
    app.FileTypeDropDown_2.BackgroundColor  = ComponentsInWindowColor;
    app.FileTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.FileTypeDropDown_3.BackgroundColor  = ComponentsInWindowColor;

    app.UIAxes.Color  = ComponentsInWindowColor;
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
    
    app.LoadCostumeTriggerIdentityUIFigure.Color  = WindowBackgroundColor;

    app.TextArea.BackgroundColor  = ComponentsInWindowColor;
end


if strcmp(Window,"Clean_Events")   
    set(findall(app.CleanEventTriggerUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CleanEventTriggerUIFigure.Color  = WindowBackgroundColor;

    app.TextArea.BackgroundColor  = ComponentsInWindowColor;
end

if strcmp(Window,"Clean_Events")   
    set(findall(app.CleanEventTriggerUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CleanEventTriggerUIFigure.Color  = WindowBackgroundColor;

    app.TextArea.BackgroundColor  = ComponentsInWindowColor;
end

if strcmp(Window,"Preprocess_Events_Main_Window")   
    set(findall(app.PreprocessEventDataWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.PreprocessEventDataWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor  = ComponentsInWindowColor;
end

if strcmp(Window,"Event_Trial_Rejection")   
    set(findall(app.TrialRejectionWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.TrialRejectionWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;

    app.TrialRejectionSettingsPanel.BackgroundColor  = WindowBackgroundColor;
    app.TrialRejectionSettingsPanel.ForegroundColor  = WindowBackgroundColor;

    app.TrialRejectionSettingsPanel_2.BackgroundColor  = WindowBackgroundColor;
    app.TrialRejectionSettingsPanel_2.ForegroundColor  = WindowBackgroundColor;

    app.ThresholdEditField.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea.BackgroundColor  = ComponentsInWindowColor;

    app.DataToExtractFromDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventChannelSelectionDropDown.BackgroundColor  = ComponentsInWindowColor;

    app.ChannelofInterestDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.ClimfromtoEditField.BackgroundColor  = ComponentsInWindowColor;
    app.RejectTrialsfromtoEditField.BackgroundColor  = ComponentsInWindowColor;
    app.PlotTrialsfromtoEditField.BackgroundColor  = ComponentsInWindowColor;

    app.UIAxes.Color  = ComponentsInWindowColor;
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

    app.UIAxes_2.Color  = ComponentsInWindowColor;
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
    set(findall(app.ChannelInterpolationWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.ChannelInterpolationWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.ChannelSettingsPanel.BackgroundColor  = WindowBackgroundColor;
    app.ChannelSettingsPanel.ForegroundColor  = WindowBackgroundColor;

    app.RejectChannelFormat11or110EditField.BackgroundColor  = ComponentsInWindowColor;
    app.DataToExtractFromDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventChannelSelectionDropDown.BackgroundColor  = ComponentsInWindowColor;

    app.UIAxes.Color  = ComponentsInWindowColor;
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
    
    app.Analyse_Event_Related_SignalUIFigure.Color  = WindowBackgroundColor;
    
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;

    app.SelectEventRelatedAnalysisPanel.BackgroundColor  = WindowBackgroundColor;
    app.SelectEventRelatedAnalysisPanel.ForegroundColor  = WindowBackgroundColor;

end

if strcmp(Window,"EventERP")   
    set(findall(app.EventRelatedAnalysisUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.EventRelatedAnalysisUIFigure.Color  = WindowBackgroundColor;

    app.ERPAnalysisSettingsPanel.BackgroundColor  = WindowBackgroundColor;
    app.ERPAnalysisSettingsPanel.ForegroundColor  = WindowBackgroundColor;

    app.DataTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.ChannelSelectionDropDown_2.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField.BackgroundColor  = ComponentsInWindowColor;
    app.DataToExtractFromDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventChannelSelectionDropDown.BackgroundColor  = ComponentsInWindowColor;
    
    app.EventNumberSelectionEditField_3.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField_2.BackgroundColor  = ComponentsInWindowColor;

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
    
    app.CSDAnalysisUIFigure.Color  = WindowBackgroundColor;
    
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;

    app.CSDParameterPanel.BackgroundColor  = WindowBackgroundColor;
    app.CSDParameterPanel.ForegroundColor  = WindowBackgroundColor;

    app.DataTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField.BackgroundColor  = ComponentsInWindowColor;
    app.HammWindowEditField.BackgroundColor  = ComponentsInWindowColor;
    app.ClimminmaxEditField.BackgroundColor  = ComponentsInWindowColor;
    app.DataToExtractFromDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventTriggerChannel.BackgroundColor  = ComponentsInWindowColor;
    
    app.EventNumberSelectionEditField_2.BackgroundColor = ComponentsInWindowColor;
    app.EventNumberSelectionEditField_3.BackgroundColor = ComponentsInWindowColor;

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
    
    app.TFAnalysisUIFigure.Color  = WindowBackgroundColor;
    
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;

    app.EventandChannelSelectionPanel.BackgroundColor  = WindowBackgroundColor;
    app.EventandChannelSelectionPanel.ForegroundColor  = WindowBackgroundColor;

    app.WaveletAnalysisParameterPanel_2.BackgroundColor  = WindowBackgroundColor;
    app.WaveletAnalysisParameterPanel_2.ForegroundColor  = WindowBackgroundColor;

    app.AnalysisTypePanel.BackgroundColor  = WindowBackgroundColor;
    app.AnalysisTypePanel.ForegroundColor  = WindowBackgroundColor;

    app.DataToExtractFromDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventTriggerChannel.BackgroundColor  = ComponentsInWindowColor;
    app.DataSourceDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField.BackgroundColor  = ComponentsInWindowColor;

    app.EventNumberSelectionEditField.BackgroundColor  = ComponentsInWindowColor;
    app.FrequencyRangeminmaxstepsEditField.BackgroundColor  = ComponentsInWindowColor;
    app.CycleWidthfromto23EditField.BackgroundColor  = ComponentsInWindowColor;

    app.EventNumberSelectionEditField_2.BackgroundColor = ComponentsInWindowColor;
    app.EventNumberSelectionEditField_3.BackgroundColor = ComponentsInWindowColor;

    app.ClimminmaxEditField.BackgroundColor  = ComponentsInWindowColor;
    app.WaveletTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.CycleWidthfromto23EditField.BackgroundColor  = ComponentsInWindowColor;
    

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
    
    app.EventStaticSpectrumWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.AnalysisSettingsPanel.BackgroundColor  = WindowBackgroundColor;
    app.AnalysisSettingsPanel.ForegroundColor  = WindowBackgroundColor;

    app.AnalysisDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.ChannelDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.DataTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.FrequencyRangeHzEditField.BackgroundColor  = ComponentsInWindowColor;
    app.DataToExtractFromDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventTriggerChannel.BackgroundColor  = ComponentsInWindowColor;
    
    app.EventNumberSelectionEditField_2.BackgroundColor = ComponentsInWindowColor;
    app.EventNumberSelectionEditField.BackgroundColor = ComponentsInWindowColor;

    app.DataSourceDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventSelectionEditField.BackgroundColor  = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor  = ComponentsInWindowColor;
    
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
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    app.SpikeDetectionWindowUIFigure.Color  = WindowBackgroundColor;

    app.Panel.BackgroundColor  = WindowBackgroundColor;
    app.Panel.ForegroundColor  = WindowBackgroundColor;

    app.Panel_2.BackgroundColor  = WindowBackgroundColor;
    app.Panel_2.ForegroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor = ComponentsInWindowColor;
    app.TextArea_3.BackgroundColor = ComponentsInWindowColor;

    app.DetectionMethodDropDown.BackgroundColor = ComponentsInWindowColor;
    app.ThresholdEditField.BackgroundColor = ComponentsInWindowColor;
    app.MeanDropDown.BackgroundColor = ComponentsInWindowColor;
    app.VerticalSpikeOffsetToleranceSamplesEditField.BackgroundColor = ComponentsInWindowColor;
    app.MinDepthofArtefactmEditField.BackgroundColor = ComponentsInWindowColor;
    app.TimeOffsettoCombineSpikeIndiciessEditField.BackgroundColor = ComponentsInWindowColor;

    app.SorterDropDown.BackgroundColor = ComponentsInWindowColor;
    app.OptionsDropDown_2.BackgroundColor = ComponentsInWindowColor;

end

if strcmp(Window,"Spike_Sorting_Parameter")    
    % texts to black
    set(findall(app.SpikeInterfaceParameterSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SpikeInterfaceParameterSelectionUIFigure.Color  = WindowBackgroundColor;

    app.GeneralSettingsPanel.BackgroundColor  = WindowBackgroundColor;
    app.GeneralSettingsPanel.ForegroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor = ComponentsInWindowColor;

    app.LoadSavedParameterDropDown.BackgroundColor = ComponentsInWindowColor;

end

if strcmp(Window,"Load_Sorting_Window")    
    % texts to black
    set(findall(app.LoadSpikeSortingResultsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LoadSpikeSortingResultsUIFigure.Color  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.LoadingOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.LoadingOptionsPanel.ForegroundColor  = WindowBackgroundColor;

    app.OpenWithCurationSoftwarePanel.BackgroundColor  = WindowBackgroundColor;
    app.OpenWithCurationSoftwarePanel.ForegroundColor  = WindowBackgroundColor;

    app.GeneralOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.GeneralOptionsPanel.ForegroundColor  = WindowBackgroundColor;

    app.InformationTextArea.BackgroundColor = ComponentsInWindowColor;

    app.SpikeSorterDropDown.BackgroundColor = ComponentsInWindowColor;
    app.AmplitudeScalingFactorEditField.BackgroundColor = ComponentsInWindowColor;

    app.CurationSoftwaretoOpenDropDown.BackgroundColor = ComponentsInWindowColor;

end

if strcmp(Window,"AskForHighPass_Window")    
    % texts to black
    set(findall(app.PreproSTAWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.PreproSTAWindowUIFigure.Color  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    
    app.FilterOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.FilterOptionsPanel.ForegroundColor  = WindowBackgroundColor;

    app.TextArea.BackgroundColor = ComponentsInWindowColor;

    app.CutoffFrequencyHzEditField.BackgroundColor = ComponentsInWindowColor;
    app.FilterOrderEditField.BackgroundColor = ComponentsInWindowColor;
    app.SaveasnewPreprocessedDatasetDropDown.BackgroundColor = ComponentsInWindowColor;
end

if strcmp(Window,"Save_for_Sorting_Window")    
    % texts to black
    set(findall(app.SaveforSpikeSortingWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SaveforSpikeSortingWindowUIFigure.Color  = WindowBackgroundColor;
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.SavingOptionsPanel.BackgroundColor  = WindowBackgroundColor;
    app.SavingOptionsPanel.ForegroundColor  = WindowBackgroundColor;

    app.InformationTextArea.BackgroundColor = ComponentsInWindowColor;

    app.Dataset.BackgroundColor = ComponentsInWindowColor;
    app.SaveFormatDropDown_2.BackgroundColor = ComponentsInWindowColor;
    app.SaveFormatDropDown.BackgroundColor = ComponentsInWindowColor;

end


if strcmp(Window,"LiveCSDWindow")    
    % texts to black
    set(findall(app.CSDWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.CSDWindowUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    
    app.CurrentSourceDensityOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.CurrentSourceDensityOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.HammWindowEditField.BackgroundColor   = ComponentsInWindowColor;
    app.DataTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
    
    app.TimeWindowfromtoinsEditField.BackgroundColor   = ComponentsInWindowColor;

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
    
    app.PowerEstimateWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.PowerEstimateOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.PowerEstimateOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.DataTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.TimeWindowfromtoinsEditField.BackgroundColor   = ComponentsInWindowColor;

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

if strcmp(Window,'LiveSpectrogramWindow')
    % texts to black
    set(findall(app.SpectrogramWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.SpectrogramWindowUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor = WindowBackgroundColor;

    app.Panel.BackgroundColor = WindowBackgroundColor;

    app.FrequencyRangeMinMaxEditField.BackgroundColor   = ComponentsInWindowColor;
    app.WindowsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.DataTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.ChannelToPlotDropDown.BackgroundColor   = ComponentsInWindowColor;
    
    app.TimeWindowfromtoinsEditField.BackgroundColor   = ComponentsInWindowColor;

    app.UIAxes.Color  = app.Mainapp.PlotAppearance.LiveSpectrogramWindow.BackgroundColor;
    app.UIAxes.XColor = 'k';  
    app.UIAxes.YColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.YTickLabelMode = 'auto';
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.LiveSpectrogramWindow.FontSize;
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';
    
    cb = colorbar(app.UIAxes);
    cb.Color = 'k';              % Sets tick mark and label color to black
    cb.Label.String = app.Mainapp.PlotAppearance.LiveSpectrogramWindow.CLabel;
    cb.Label.Rotation = 270;
    cb.FontSize =  app.Mainapp.PlotAppearance.LiveSpectrogramWindow.FontSize-1;
    cb.Label.Color = 'k';        % Sets the color of the label text
    
end

if strcmp(Window,"LiveSpikeRatePowerWindow")    
    % texts to black
    set(findall(app.SpikeRateWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.SpikeRateWindowUIFigure.Color  = WindowBackgroundColor;

    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;
    
    app.SpikeRateOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.SpikeRateOptionsPanel.ForegroundColor   = WindowBackgroundColor;
    app.TimeWindowfromtoinsEditField.BackgroundColor   = ComponentsInWindowColor;

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
    
    app.ContinuousSpikeAnalysisUIFigure.Color  = WindowBackgroundColor;

    app.SpikeAnalysisOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.SpikeAnalysisOptionsPanel.ForegroundColor   = WindowBackgroundColor;
    app.WaveformOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.WaveformOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.TypeofAnalysisDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.ClustertoshowDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.EventstoshowDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.SpikeRateNumBinsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.TimeWindowSpiketriggredLFPEditField.BackgroundColor   = ComponentsInWindowColor;
    app.WaveformSelectionforPlottingEditField.BackgroundColor   = ComponentsInWindowColor;
    
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
    
    app.UnitAnalysisWindowUIFigure.Color  = WindowBackgroundColor;

    app.PlotColumnSettingsPanel.BackgroundColor   = WindowBackgroundColor;
    app.PlotColumnSettingsPanel.ForegroundColor   = WindowBackgroundColor;
    app.GeneralSettingsPanel.BackgroundColor   = WindowBackgroundColor;
    app.GeneralSettingsPanel.ForegroundColor   = WindowBackgroundColor;

    app.UnitstoShowEditField.BackgroundColor   = ComponentsInWindowColor;
    app.NumWaveformsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.UnitstoShowEditField_2.BackgroundColor   = ComponentsInWindowColor;
    app.NumWaveformsEditField_2.BackgroundColor   = ComponentsInWindowColor;
    
    app.MaxISItoshowsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.BinNumberISIEditField.BackgroundColor   = ComponentsInWindowColor;
    app.DeleteUnitDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.TimeLagmsEditField.BackgroundColor   = ComponentsInWindowColor;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set title, xlabel, ylabel colors
    app.UIAxes_1.Title.Color = 'k';
    app.UIAxes_1.XLabel.Color = 'k';
    app.UIAxes_1.YLabel.Color = 'k';

    app.UIAxes_1.Color  = WindowBackgroundColor;
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

    app.UIAxes_4.Color  = WindowBackgroundColor;
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

    app.UIAxes_7.Color  = WindowBackgroundColor;
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

    app.UIAxes_2.Color  = WindowBackgroundColor;
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

    app.UIAxes_5.Color  = WindowBackgroundColor;
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

    app.UIAxes_8.Color  = WindowBackgroundColor;
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
    
    app.EventRelatedSpikeAnalysisUIFigure.Color  = WindowBackgroundColor;

    app.SpikeAnalysisOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.SpikeAnalysisOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.AnalysisTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.ClustertoshowDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.EventRangeEditField.BackgroundColor   = ComponentsInWindowColor;
    app.BaselineWindowStartStopinsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.EventChannelSelectionDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.SpikeRateNumBinsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.TimeWindowSpiketriggredLFPEditField.BackgroundColor   = ComponentsInWindowColor;
    
    app.DataTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
    
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

if strcmp(Window,"AutorunWindow")    
    % texts to black
    set(findall(app.AutorunManagerWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.AutorunManagerWindowUIFigure.Color  = WindowBackgroundColor;

    app.ConfigSelectionPanel.BackgroundColor   = WindowBackgroundColor;
    app.ConfigSelectionPanel.ForegroundColor   = WindowBackgroundColor;

    app.AutorunSettingsPanel.BackgroundColor   = WindowBackgroundColor;
    app.AutorunSettingsPanel.ForegroundColor   = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.TextArea_2.BackgroundColor   = ComponentsInWindowColor;

    app.ConfigSelectedDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.FoldertoskipEditField.BackgroundColor   = ComponentsInWindowColor;
    app.PictureFormatDropDown.BackgroundColor   = ComponentsInWindowColor;
end
if strcmp(Window,"AutorunWindowSelectTemplate")    
    % texts to black
    set(findall(app.SelectAutorunTemplateWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])
    
    app.LeftPanel.BackgroundColor  = WindowBackgroundColor;
    app.RightPanel.BackgroundColor  = WindowBackgroundColor;

    app.SelectAutorunTemplateWindowUIFigure.Color  = WindowBackgroundColor;

    app.SelectTemplateDropDown.BackgroundColor   = ComponentsInWindowColor;

    app.TextArea.BackgroundColor   = WindowBackgroundColor;
    app.TextArea_2.BackgroundColor   = WindowBackgroundColor;

end

if strcmp(Window,"Autorun_Reset_Config")    
    % texts to black
    set(findall(app.ResetConfigWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ResetConfigWindowUIFigure.Color  = WindowBackgroundColor;

    app.DefaultTemplatetoResetConfigtoDropDown.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"AutorunShowFunction")    
    % texts to black
    set(findall(app.Show_Function_WindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.Show_Function_WindowUIFigure.Color  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,'AddNewModuleWindow')
    % texts to black
    set(findall(app.AddNewModuleWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.AddNewModuleWindowUIFigure.Color  = WindowBackgroundColor;

    app.Step1Panel.BackgroundColor   = WindowBackgroundColor;
    app.Step1Panel.ForegroundColor   = WindowBackgroundColor;

    app.Step2Panel.BackgroundColor   = WindowBackgroundColor;
    app.Step2Panel.ForegroundColor   = WindowBackgroundColor;

    app.Step3Panel.BackgroundColor   = WindowBackgroundColor;
    app.Step3Panel.ForegroundColor   = WindowBackgroundColor;

    app.NameoftheNewModuleEditField.BackgroundColor   = ComponentsInWindowColor;
    app.InformationTextArea_2.BackgroundColor   = ComponentsInWindowColor;
    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;

end

if strcmp(Window,'ChangeLowPassSettings')
    % texts to black
    set(findall(app.SelectSpikeRateFilterOptionsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.SelectSpikeRateFilterOptionsUIFigure.Color  = WindowBackgroundColor;

    app.EnternewCutoffFrequencyHzEditField.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"AskForResampling")    
    % texts to black
    set(findall(app.AskforResampleWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.AskforResampleWindowUIFigure.Color  = WindowBackgroundColor;
    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"InstFrequWindow")    
    % texts to black
    set(findall(app.InstantaneousFrequencyUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.InstantaneousFrequencyUIFigure.Color  = WindowBackgroundColor;
    
    app.SettingsPanel.BackgroundColor   = WindowBackgroundColor;
    app.SettingsPanel.ForegroundColor   = WindowBackgroundColor;

    app.Panel.BackgroundColor   = WindowBackgroundColor;
    app.Panel.ForegroundColor   = WindowBackgroundColor;

    app.ChannelSelectionDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.NarrowbandCutoffLowerHigherEditField.BackgroundColor   = ComponentsInWindowColor;
    app.NarrowbandFilterorderEditField.BackgroundColor   = ComponentsInWindowColor;
    app.ECHTFilterorderEditField.BackgroundColor   = ComponentsInWindowColor;
    app.TextArea.BackgroundColor   = ComponentsInWindowColor;

    app.DataTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.ChannelSelectionDropDown_2.BackgroundColor   = ComponentsInWindowColor;
    app.CalculationMethodDropDown.BackgroundColor   = ComponentsInWindowColor;
    
    app.TimeWindowfromtoinsEditField.BackgroundColor   = ComponentsInWindowColor;
    
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

    app.UIAxes.Color  = ComponentsInWindowColor;
    app.UIAxes.XColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    
    app.UIAxes.YLabel.Color = 'k';
    app.UIAxes.YColor = 'k';

    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    app.UIAxes_2.YLabel.Color = 'k';

    app.UIAxes_2.Color  = ComponentsInWindowColor;
    app.UIAxes_2.XColor = 'k';  

    app.UIAxes_2.XTickLabelMode = 'auto';  
    app.UIAxes_2.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    
    app.UIAxes_2.YLabel.Color = 'k';
    app.UIAxes_2.YColor = 'k';

    app.UIAxes_3.Title.Color = 'k';
    app.UIAxes_3.XLabel.Color = 'k';
    app.UIAxes_3.YLabel.Color = 'k';

    app.UIAxes_3.Color  = ComponentsInWindowColor;
    app.UIAxes_3.XColor = 'k';  

    app.UIAxes_3.XTickLabelMode = 'auto';  
    app.UIAxes_3.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_3.Title.Color = 'k';
    app.UIAxes_3.XLabel.Color = 'k';
    
    app.UIAxes_3.YLabel.Color = 'k';
    app.UIAxes_3.YColor = 'k';

end

if strcmp(Window,'ASR_Window')
    % texts to black
    set(findall(app.ASRWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ASRWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.ArtefactSubspaceReconstructionPanel.BackgroundColor   = WindowBackgroundColor;
    app.ArtefactSubspaceReconstructionPanel.ForegroundColor   = WindowBackgroundColor;

    app.LineNoiseCriterioninStandardDevationsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.HighPassTransitionBandLTHTEditField.BackgroundColor   = ComponentsInWindowColor;
    app.BurstCriterioninStandardDevationsRange520EditField.BackgroundColor   = ComponentsInWindowColor;
    app.WindowCriterionRange00503EditField.BackgroundColor   = ComponentsInWindowColor;

end

if strcmp(Window,"EventPhaseSyncWindow")    
    % texts to black
    set(findall(app.PhaseSynchroFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.PhaseSynchroFigure.Color  = WindowBackgroundColor;
    
    app.SettingsPanel.BackgroundColor   = WindowBackgroundColor;
    app.SettingsPanel.ForegroundColor   = WindowBackgroundColor;

    app.Panel.BackgroundColor   = WindowBackgroundColor;
    app.Panel.ForegroundColor   = WindowBackgroundColor;

    app.MultipleTimeRangesComparisonPanel.BackgroundColor   = WindowBackgroundColor;
    app.MultipleTimeRangesComparisonPanel.ForegroundColor   = WindowBackgroundColor;

    app.ChannelSelectionDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.NarrowbandCutoffLowerHigherEditField.BackgroundColor   = ComponentsInWindowColor;
    app.NarrowbandFilterorderEditField.BackgroundColor   = ComponentsInWindowColor;
    app.ECHTFilterorderEditField.BackgroundColor   = ComponentsInWindowColor;
    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.TrialSelectionMatlabExpressionsEditField.BackgroundColor   = ComponentsInWindowColor;
    
    app.DataToExtractFromDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.EventChannelSelectionDropDown.BackgroundColor   = ComponentsInWindowColor;

    app.TimeRange1fromtoinsEditField.BackgroundColor   = ComponentsInWindowColor;
    app.TimeRange2fromtoinsEditField.BackgroundColor   = ComponentsInWindowColor;

    app.DataTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.ChannelSelectionDropDown_2.BackgroundColor   = ComponentsInWindowColor;
    app.CalculationMethodDropDown.BackgroundColor   = ComponentsInWindowColor;

    app.EventNumberSelectionEditField_2.BackgroundColor = ComponentsInWindowColor;
    app.EventNumberSelectionEditField.BackgroundColor = ComponentsInWindowColor;

    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

    app.UIAxes.Color  = ComponentsInWindowColor;
    app.UIAxes.XColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    
    app.UIAxes.YLabel.Color = 'k';
    app.UIAxes.YColor = 'k';

    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    app.UIAxes_2.YLabel.Color = 'k';

    app.UIAxes_2.Color  = ComponentsInWindowColor;
    app.UIAxes_2.XColor = 'k';  

    app.UIAxes_2.XTickLabelMode = 'auto';  
    app.UIAxes_2.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    %app.UIAxes.FontColor = 'k';  % Tick label color
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_2.Title.Color = 'k';
    app.UIAxes_2.XLabel.Color = 'k';
    
    app.UIAxes_2.YLabel.Color = 'k';
    app.UIAxes_2.YColor = 'k';

    app.UIAxes_3.Title.Color = 'k';
    app.UIAxes_3.XLabel.Color = 'k';
    app.UIAxes_3.YLabel.Color = 'k';

    app.UIAxes_3.Color  = ComponentsInWindowColor;
    app.UIAxes_3.XColor = 'k';  

    app.UIAxes_3.XTickLabelMode = 'auto';  
    app.UIAxes_3.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    
    % Set title, xlabel, ylabel colors
    app.UIAxes_3.Title.Color = 'k';
    app.UIAxes_3.XLabel.Color = 'k';
    
    app.UIAxes_3.YLabel.Color = 'k';
    app.UIAxes_3.YColor = 'k';

end


if strcmp(Window,'DeleteTriggerIndices')
    % texts to black
    set(findall(app.DeleteTriggerWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.DeleteTriggerWindowUIFigure.Color  = WindowBackgroundColor;
    
    app.LeftPanel.BackgroundColor   = WindowBackgroundColor;
    app.LeftPanel.ForegroundColor   = WindowBackgroundColor;

    app.RightPanel.BackgroundColor   = WindowBackgroundColor;
    app.RightPanel.ForegroundColor   = WindowBackgroundColor;

    app.RejectionOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.RejectionOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.DataToExtractFromDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.EventChannelforStimulationDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.EventstoPlotDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.TriggerToRejectMatlabExpressionsEditField.BackgroundColor   = ComponentsInWindowColor;

    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;
    
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    app.UIAxes.YLabel.Color = 'k';

    app.UIAxes.Color  = ComponentsInWindowColor;
    app.UIAxes.XColor = 'k';  

    app.UIAxes.XTickLabelMode = 'auto';  
    app.UIAxes.TickLabelInterpreter = 'none';  % Avoid LaTeX/TeX interpretation if not needed
    
    % Set title, xlabel, ylabel colors
    app.UIAxes.Title.Color = 'k';
    app.UIAxes.XLabel.Color = 'k';
    
    app.UIAxes.YLabel.Color = 'k';
    app.UIAxes.YColor = 'k';
end

if strcmp(Window,'AskForFilterSettingsInstFrequ')
    % texts to black
    set(findall(app.ChangeFilterOptionsUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.ChangeFilterOptionsUIFigure.Color  = WindowBackgroundColor;
    
    app.ChangeFilterOptionsPanel.BackgroundColor   = WindowBackgroundColor;
    app.ChangeFilterOptionsPanel.ForegroundColor   = WindowBackgroundColor;

    app.CutoffFreuqencyEditField.BackgroundColor   = ComponentsInWindowColor;
    app.FilterOrderEditField.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Ask_For_ERD_Parameter")    
    % texts to black
    set(findall(app.AskForEventRelatedDataExtractionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.AskForEventRelatedDataExtractionUIFigure.Color  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
    app.DataToExtractFromDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.EventChannelSelectionDropDown.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Combine_Events_Window")    
    % texts to black
    set(findall(app.CombineEventChannelUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.CombineEventChannelUIFigure.Color  = WindowBackgroundColor;

    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;
    app.CombineEventscommaseparatedIntegersEditField.BackgroundColor   = ComponentsInWindowColor;
    app.NewCombinedEventNamescommaseparatedstringsEditField.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Ask_For_NEO_Parameter")    
    % texts to black
    set(findall(app.NeoParameterUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.NeoParameterUIFigure.Color  = WindowBackgroundColor;

    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;
    app.RecordingSystemDropDown.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Delete_Time_Violating_Trigger")    
    % texts to black
    set(findall(app.DeleteTimeViolatingTriggerUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.DeleteTimeViolatingTriggerUIFigure.Color  = WindowBackgroundColor;

    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"TDTSelectLFPorAP")    
    % texts to black
    set(findall(app.TDTDataSelectionUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.TDTDataSelectionUIFigure.Color  = WindowBackgroundColor;

    app.TextArea.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"OpenCurationSoftwareWindow")    
    % texts to black
    set(findall(app.OpenCurationSoftwareWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.OpenCurationSoftwareWindowUIFigure.Color  = WindowBackgroundColor;


    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;
    app.CurationSoftwaretoOpenDropDown.BackgroundColor   = ComponentsInWindowColor;
end

if strcmp(Window,"Select_Event_Window")    
    % texts to black
    set(findall(app.SelectEventWindowUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.SelectEventWindowUIFigure.Color  = WindowBackgroundColor;


    app.InformationTextArea.BackgroundColor   = ComponentsInWindowColor;
    app.EventChannelToUseDropDown.BackgroundColor   = ComponentsInWindowColor;
    app.EventRelatedDataTypeDropDown.BackgroundColor   = ComponentsInWindowColor;
end


if strcmp(Window,"FieldTripEventWindow")    
    % texts to black
    set(findall(app.FieldTripEventAnalysisUIFigure, '-property', 'FontColor'), 'FontColor', [0 0 0])

    app.FieldTripEventAnalysisUIFigure.Color  = WindowBackgroundColor;
    
    app.EventRelatedPotentialPanel.BackgroundColor   = WindowBackgroundColor;
    app.EventRelatedPotentialPanel.ForegroundColor   = WindowBackgroundColor;

    app.AnalysisParameterPanel.BackgroundColor   = WindowBackgroundColor;
    app.AnalysisParameterPanel.ForegroundColor   = WindowBackgroundColor;

    app.TimeFrequencyPowerandConnectivityAnalysisPanel.BackgroundColor   = WindowBackgroundColor;
    app.TimeFrequencyPowerandConnectivityAnalysisPanel.ForegroundColor   = WindowBackgroundColor;

    app.DataTypeDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.ChannelSelectionDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField.BackgroundColor  = ComponentsInWindowColor;
    app.DataToExtractFromDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventChannelSelectionDropDown.BackgroundColor  = ComponentsInWindowColor;

    app.EventNumberSelectionEditField_2.BackgroundColor  = ComponentsInWindowColor;

    app.TFMethodDropDown.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField_4.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField_3.BackgroundColor  = ComponentsInWindowColor;
    app.EventNumberSelectionEditField_5.BackgroundColor  = ComponentsInWindowColor;

    app.EventNumberSelectionEditField_6.BackgroundColor  = ComponentsInWindowColor;

    app.CurrentlyAvailableVariablestoExportTextArea.BackgroundColor  = ComponentsInWindowColor;
end