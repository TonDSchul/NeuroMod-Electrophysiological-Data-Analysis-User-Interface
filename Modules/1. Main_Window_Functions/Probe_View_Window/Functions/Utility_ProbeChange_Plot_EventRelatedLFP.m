function [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,Window)

%________________________________________________________________________________________
%% Function to update event related LFP analysis plots when the user changed the active channel selection

% Executed only when the user changes the channelselection and event related LFP analysis windows are supposed to be updated (in the dropdown menu of the probe view window)

% Inputs: 
% 1. app: probe view window object
% 2. Window: string, either "ERP" OR "CSD" OR "EventSpectrum" OR "TF" (time frequency power window)

% Outputs:
% 1. app: probe view window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if strcmp(Window,"ERP")
    EventNr = eval(app.Mainapp.EventLFPERP.EventNumberSelectionEditField.Value);
            
    if strcmp(app.Mainapp.EventLFPERP.DataTypeDropDown.Value,'Raw Event Related Data')
        [~,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPERP.UIAxes,app.Mainapp.EventLFPERP.UIAxes_2,app.Mainapp.Data.EventRelatedData(:,EventNr,:),app.Mainapp.EventLFPERP.EventTime, app.Mainapp.ActiveChannel,[],app.Mainapp.EventLFPERP.colorMap,app.Mainapp.EventLFPERP.Slider.Value,'MultipleERPOnly',[],app.Mainapp.CurrentPlotData, app.Mainapp.PlotAppearance,app.Mainapp.EventLFPERP.ChannelSelectionDropDown_2.Value,app.Mainapp.EventLFPERP.DataTypeDropDown.Value);
    else
        [~,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPERP.UIAxes,app.Mainapp.EventLFPERP.UIAxes_2,app.Mainapp.Data.PreprocessedEventRelatedData(:,EventNr,:),app.Mainapp.EventLFPERP.EventTime, app.Mainapp.ActiveChannel,[],app.Mainapp.EventLFPERP.colorMap,app.Mainapp.EventLFPERP.Slider.Value,'MultipleERPOnly',[],app.Mainapp.CurrentPlotData, app.Mainapp.PlotAppearance,app.Mainapp.EventLFPERP.ChannelSelectionDropDown_2.Value,app.Mainapp.EventLFPERP.DataTypeDropDown.Value);
    end
end

if strcmp(Window,"CSD")
    %% CSD
    EventNr = eval(app.Mainapp.EventLFPCSD.EventNumberSelectionEditField.Value);
    
    % Structure holding csd window specific infos
    CSD.ChannelSpacing = app.Mainapp.Data.Info.ChannelSpacing;
    CSD.HammWindow = str2double(app.Mainapp.EventLFPCSD.HammWindowEditField.Value);
    CSD.SelectedChannel = app.Mainapp.ActiveChannel;

    %% Plot CSD
    if strcmp(app.Mainapp.EventLFPCSD.DataTypeDropDown.Value,'Raw Event Related Data') 
        [app.Mainapp.EventLFPCSD.climCSD,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPCSD.UIAxes,[],app.Mainapp.Data.EventRelatedData(:,EventNr,:),app.Mainapp.EventLFPCSD.EventTime,CSD.SelectedChannel,CSD,[],[],[],app.Mainapp.EventLFPCSD.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance,[],app.Mainapp.EventLFPCSD.DataTypeDropDown.Value);
    else
        [app.Mainapp.EventLFPCSD.climCSD,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPCSD.UIAxes,[],app.Mainapp.Data.PreprocessedEventRelatedData(:,EventNr,:),app.Mainapp.EventLFPCSD.EventTime,CSD.SelectedChannel,CSD,[],[],[],app.Mainapp.EventLFPCSD.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance,[],app.Mainapp.EventLFPCSD.DataTypeDropDown.Value);
    end

    cb = colorbar(app.Mainapp.EventLFPCSD.UIAxes);
    cb.Color = 'k';              % Sets tick mark and label color to black
    cb.Label.Color = 'k';        % Sets the color of the label text
    cb.Label.String = app.Mainapp.PlotAppearance.CSDWindow.CLabel;
    cb.Label.Rotation = 270;
    cb.FontSize =  app.Mainapp.PlotAppearance.CSDWindow.FontSize;  
end

if strcmp(Window,"EventSpectrum")
    if strcmp(app.Mainapp.EventLFPSSP.AnalysisDropDown.Value,"Band Power Individual Channel ")
        app.Mainapp.EventLFPSSP.ChannelDropDown.Enable = "on";
        app.Mainapp.EventLFPSSP.DataTypeDropDown.Enable = "on";
        app.Mainapp.EventLFPSSP.FrequencyRangeHzEditField.Enable = "on";

        set(app.Mainapp.EventLFPSSP.UIAxes, 'YDir', 'normal');
        cb = colorbar(app.Mainapp.EventLFPSSP.UIAxes);   % Create a colorbar (if it exists)
        if ~isempty(cb)
            delete(cb);                  % Delete the colorbar
        end

        [~,app.Mainapp.EventLFPSSP.BandPower,~] = Event_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.EventLFPSSP.DataSourceDropDown.Value,app.Mainapp.EventLFPSSP.BandPower,app.Mainapp.EventLFPSSP.FrequencyRangeHzEditField.Value,app.Mainapp.EventLFPSSP.UIAxes,app.Mainapp.EventLFPSSP.UIAxes_2,app.Mainapp.EventLFPSSP.TextArea,'Just Frequency Bands',app.Mainapp.EventLFPSSP.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.EventLFPSSP.SelectedEvents,app.Mainapp.ActiveChannel,app.Mainapp.PlotAppearance,app.Mainapp.EventLFPSSP.DataToExtractFromDropDown.Value);

    elseif strcmp(app.Mainapp.EventLFPSSP.AnalysisDropDown.Value,"Band Power over Depth")
        app.Mainapp.EventLFPSSP.ChannelDropDown.Enable = "off";
        app.Mainapp.EventLFPSSP.DataTypeDropDown.Enable = "off";
        app.Mainapp.EventLFPSSP.FrequencyRangeHzEditField.Enable = "on";

        app.Mainapp.EventLFPSSP.UIAxes.YScale = 'linear';
        
        [~,app.Mainapp.EventLFPSSP.BandPower,~] = Event_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.EventLFPSSP.DataSourceDropDown.Value,app.Mainapp.EventLFPSSP.BandPower,app.Mainapp.EventLFPSSP.FrequencyRangeHzEditField.Value,app.Mainapp.EventLFPSSP.UIAxes,app.Mainapp.EventLFPSSP.UIAxes_2,app.Mainapp.EventLFPSSP.TextArea,'All',app.Mainapp.EventLFPSSP.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.EventLFPSSP.SelectedEvents,app.Mainapp.ActiveChannel,app.Mainapp.PlotAppearance,app.Mainapp.EventLFPSSP.DataToExtractFromDropDown.Value);

        cb = colorbar(app.Mainapp.EventLFPSSP.UIAxes);
        cb.Color = 'k';              % Sets tick mark and label color to black
        cb.Label.String = "Power [dB]";
        cb.Label.Rotation = 270;
        %cb.FontSize =  app.Mainapp.PlotAppearance.SpectrumWindow.Data.TimeFontSize;
        cb.Label.Color = 'k';        % Sets the color of the label text
    end
end

if strcmp(Window,"TF")
% Extract Cell with eventindicies of selected event channel
    spaceindicie = find(app.Mainapp.Data.Info.EventRelatedDataTimeRange == ' ');
    Timearoundevent(1) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)));
    Timearoundevent(2) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));
    
    [~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(app.Mainapp.Data,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.ActiveChannel,app.Mainapp.EventLFPTF.EventNumberSelectionEditField.Value,app.Mainapp.EventLFPTF.FrequencyRangeminmaxstepsEditField.Value,app.Mainapp.EventLFPTF.CycleWidthfromto23EditField.Value,[],[]);
    
    if strcmp(app.Mainapp.EventLFPTF.DataToExtractFromDropDown.Value,'Raw Data')                
        if strcmp(app.Mainapp.EventLFPTF.DataSourceDropDown.Value,"Raw Event Related Data")
            [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.EventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,app.Mainapp.EventLFPTF.TFInfos.Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
        elseif strcmp(app.Mainapp.EventLFPTF.DataSourceDropDown.Value,"Preprocessed Event Related Data")
            [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.PreprocessedEventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,app.Mainapp.EventLFPTF.TFInfos.Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
        end
    else
        if isfield(app.Mainapp.Data.Info,"DownsampleFactor")
            if strcmp(app.Mainapp.EventLFPTF.DataSourceDropDown.Value,"Raw Event Related Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.EventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,app.Mainapp.EventLFPTF.TFInfos.Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            elseif strcmp(app.Mainapp.EventLFPTF.DataSourceDropDown.Value,"Preprocessed Event Related Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.PreprocessedEventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,app.Mainapp.EventLFPTF.TFInfos.Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            end
        else
            if strcmp(app.Mainapp.EventLFPTF.DataSourceDropDown.Value,"Raw Event Related Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.EventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,app.Mainapp.EventLFPTF.TFInfos.Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            elseif strcmp(app.Mainapp.EventLFPTF.DataSourceDropDown.Value,"Preprocessed Event Related Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.PreprocessedEventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,app.Mainapp.EventLFPTF.TFInfos.Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            end
        end
    end
end

if strcmp(Window,"PhaseSync")

    %% --------------------- Compute and Plot ---------------------
    if strcmp(app.Mainapp.EventPhaseSynchro.DataTypeDropDown.Value,'Raw Event Related Data')
        DataToCompute = app.Mainapp.Data.EventRelatedData(:,app.Mainapp.EventPhaseSynchro.EventsToShow,:);
    else
        DataToCompute = app.Mainapp.Data.PreprocessedEventRelatedData(:,app.Mainapp.EventPhaseSynchro.EventsToShow,:);
    end
    [app.Mainapp.EventPhaseSynchro.TextArea.Value,app.Mainapp.CurrentPlotData] = Event_Module_PhaseSync_Main(DataToCompute,app.Mainapp.EventPhaseSynchro.EventTime,app.Mainapp.EventPhaseSynchro.PolarPlot,app.Mainapp.EventPhaseSynchro.UIAxes_3,app.Mainapp.EventPhaseSynchro.UIAxes,app.Mainapp.EventPhaseSynchro.UIAxes_2,app.Mainapp.Data,app.Mainapp.EventPhaseSynchro.ChannelToCompare,app.Mainapp.EventPhaseSynchro.NarrowbandCutoffLowerHigherEditField.Value,app.Mainapp.EventPhaseSynchro.NarrowbandFilterorderEditField.Value,app.Mainapp.ActiveChannel,app.Mainapp.EventPhaseSynchro.DataTypeDropDown.Value,app.Mainapp.PlotAppearance,app.Mainapp.EventPhaseSynchro.Ccolormap,app.Mainapp.EventPhaseSynchro.CalculationMethodDropDown.Value,app.Mainapp.EventPhaseSynchro.ForceFilterOFFCheckBox.Value,app.Mainapp.EventPhaseSynchro.ECHTFilterorderEditField.Value,app.Mainapp.CurrentPlotData,app.Mainapp.EventPhaseSynchro.WhatToDo,app.Mainapp.EventPhaseSynchro.BasedOnERP,app.Mainapp.EventPhaseSynchro.ShowAnayzedData,app.Mainapp.EventPhaseSynchro.DataToExtractFromDropDown.Value);

end

