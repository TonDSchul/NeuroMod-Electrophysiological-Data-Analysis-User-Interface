function [app] = Utility_ProbeChange_Plot_EventRelatedLFP(app,Window)

if strcmp(Window,"ERP")
    spaceindicie = strfind(app.Mainapp.Data.Info.EventRelatedDataTimeRange," ");
    TimearoundEvent(1) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
    TimearoundEvent(2) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));
    
    commaindicie = strfind(app.Mainapp.EventLFPERP.EventNumberSelectionEditField.Value,",");
    EventNr(1) = str2double(app.Mainapp.EventLFPERP.EventNumberSelectionEditField.Value(1:commaindicie-1));
    EventNr(2) = str2double(app.Mainapp.EventLFPERP.EventNumberSelectionEditField.Value(commaindicie+1:end));
    
    %% Plot ERP
    
    if strcmp(app.Mainapp.Data.Info.EventRelatedDataType,"Preprocessed") && isfield(app.Mainapp.Data.Info,'DownsampledSampleRate')
        EventTime = 0-TimearoundEvent(1):1/app.Mainapp.Data.Info.DownsampledSampleRate:TimearoundEvent(2);
    else
        EventTime = 0-TimearoundEvent(1):1/app.Mainapp.Data.Info.NativeSamplingRate:TimearoundEvent(2);
    end
    
    if strcmp(app.Mainapp.EventLFPERP.DataTypeDropDown.Value,'Raw Event Related Data')
        [~,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPERP.UIAxes,app.Mainapp.EventLFPERP.UIAxes_2,app.Mainapp.Data.EventRelatedData(:,EventNr(1):EventNr(2),:),EventTime,app.Mainapp.ActiveChannel,[],app.Mainapp.EventLFPERP.colorMap,app.Mainapp.EventLFPERP.Slider.Value,'All',[],app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance,app.Mainapp.EventLFPERP.ChannelSelectionDropDown_2.Value);
    else
        [~,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPERP.UIAxes,app.Mainapp.EventLFPERP.UIAxes_2,app.Mainapp.Data.PreprocessedEventRelatedData(:,EventNr(1):EventNr(2),:),EventTime,app.Mainapp.ActiveChannel,[],app.colorMap,app.Mainapp.EventLFPERP.Slider.Value,'All',[],app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance,app.Mainapp.EventLFPERP.ChannelSelectionDropDown_2.Value);
    end
end

if strcmp(Window,"CSD")
    %% CSD
    spaceindicie = strfind(app.Mainapp.Data.Info.EventRelatedDataTimeRange," ");
    TimearoundEvent(1) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
    TimearoundEvent(2) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));
    
    commaindicie = strfind(app.Mainapp.EventLFPCSD.EventNumberSelectionEditField.Value,",");
    EventNr(1) = str2double(app.Mainapp.EventLFPCSD.EventNumberSelectionEditField.Value(1:commaindicie-1));
    EventNr(2) = str2double(app.Mainapp.EventLFPCSD.EventNumberSelectionEditField.Value(commaindicie+1:end));
    
    % Structure holding csd window specific infos
    CSD.ChannelSpacing = app.Mainapp.Data.Info.ChannelSpacing;
    CSD.HammWindow = str2double(app.Mainapp.EventLFPCSD.HammWindowEditField.Value);
    CSD.SelectedChannel = app.Mainapp.ActiveChannel;
    
    if strcmp(app.Mainapp.Data.Info.EventRelatedDataType,"Preprocessed") && isfield(app.Mainapp.Data.Info,'DownsampledSampleRate')
        EventTime = 0-TimearoundEvent(1):1/app.Mainapp.Data.Info.DownsampledSampleRate:TimearoundEvent(2);
    else
        EventTime = 0-TimearoundEvent(1):1/app.Mainapp.Data.Info.NativeSamplingRate:TimearoundEvent(2);
    end
    
    %% Plot CSD
    if strcmp(app.Mainapp.EventLFPCSD.DataTypeDropDown.Value,'Raw Event Related Data') 
        [app.Mainapp.EventLFPCSD.climCSD,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPCSD.UIAxes,[],app.Mainapp.Data.EventRelatedData(:,EventNr(1):EventNr(2),:),EventTime,app.Mainapp.ActiveChannel,CSD,[],[],[],app.Mainapp.EventLFPCSD.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance,[]);
    else
        [app.Mainapp.EventLFPCSD.climCSD,~,~,~,app.Mainapp.CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(app.Mainapp.Data,app.Mainapp.EventLFPCSD.UIAxes,[],app.Mainapp.Data.PreprocessedEventRelatedData(:,EventNr(1):EventNr(2),:),EventTime,app.Mainapp.ActiveChannel,CSD,[],[],[],app.Mainapp.EventLFPCSD.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance,[]); 
    end
end

if strcmp(Window,"EventSpectrum")
    app.UIAxes.Color = app.Mainapp.PlotAppearance.SpectrumWindow.Data.SpectrumBackgroundColor;
    app.UIAxes.FontSize = app.Mainapp.PlotAppearance.SpectrumWindow.Data.TimeFontSize;

    if strcmp(app.Mainapp.EventLFPSSP.AnalysisDropDown.Value,"Band Power Individual Channel ")

        SelectedChannel = str2double(app.Mainapp.EventLFPSSP.ChannelDropDown.Value);
        SelectedEvents = str2double(split(app.Mainapp.EventLFPSSP.EventSelectionEditField.Value,','))';

        set(app.Mainapp.EventLFPSSP.UIAxes, 'YDir', 'normal');
        cb = colorbar(app.Mainapp.EventLFPSSP.UIAxes);   % Create a colorbar (if it exists)
        if ~isempty(cb)
            delete(cb);                  % Delete the colorbar
        end

        [app.Mainapp.CurrentPlotData] = Event_Analyse_Static_Power_Spectrum(app.Mainapp.Data,app.Mainapp.EventLFPSSP.UIAxes,app.Mainapp.EventLFPSSP.DataTypeDropDown.Value,app.Mainapp.EventLFPSSP.DataSourceDropDown.Value,SelectedChannel,app.Mainapp.EventLFPSSP.ChannelDropDown.Value,app.Mainapp.EventLFPSSP.FrequencyRangeHzEditField.Value,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance,SelectedEvents);

        SelectedEvents = str2double(split(app.Mainapp.EventLFPSSP.EventSelectionEditField.Value,','))';

        [~,app.Mainapp.EventLFPSSP.BandPower,~] = Event_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.EventLFPSSP.DataSourceDropDown.Value,app.Mainapp.EventLFPSSP.BandPower,app.Mainapp.EventLFPSSP.FrequencyRangeHzEditField.Value,app.Mainapp.EventLFPSSP.UIAxes,app.Mainapp.EventLFPSSP.UIAxes_2,app.Mainapp.EventLFPSSP.TextArea,'Just Frequency Bands',app.Mainapp.EventLFPSSP.TwoORThreeD,app.Mainapp.CurrentPlotData,SelectedEvents,app.Mainapp.ActiveChannel); 

    elseif strcmp(app.Mainapp.EventLFPSSP.AnalysisDropDown.Value,"Band Power over Depth")

        app.Mainapp.EventLFPSSP.UIAxes.YScale = 'linear';
        
        SelectedEvents = str2double(split(app.Mainapp.EventLFPSSP.EventSelectionEditField.Value,','))';

        [~,app.Mainapp.EventLFPSSP.BandPower,~] = Event_Power_Spectrum_Over_Depth(app.Mainapp.Data,app.Mainapp.EventLFPSSP.DataSourceDropDown.Value,app.Mainapp.EventLFPSSP.BandPower,app.Mainapp.EventLFPSSP.FrequencyRangeHzEditField.Value,app.Mainapp.EventLFPSSP.UIAxes,app.Mainapp.EventLFPSSP.UIAxes_2,app.Mainapp.EventLFPSSP.TextArea,'All',app.Mainapp.EventLFPSSP.TwoORThreeD,app.Mainapp.CurrentPlotData,SelectedEvents,app.Mainapp.ActiveChannel); 
    end
end

if strcmp(Window,"TF")
% Extract Cell with eventindicies of selected event channel
    spaceindicie = find(app.Mainapp.Data.Info.EventRelatedDataTimeRange == ' ');
    Timearoundevent(1) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)));
    Timearoundevent(2) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));
    
    [~,DataChannelSelected,EventNrRange,~,TF] = Event_Module_Organize_TF_Window_Inputs(app.Mainapp.Data,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.ActiveChannel,app.Mainapp.EventLFPTF.EventNumberSelectionEditField.Value,app.Mainapp.EventLFPTF.FrequencyRangeminmaxstepsEditField.Value,app.Mainapp.EventLFPTF.CycleWidthfromto23EditField.Value,[],[]);
    
    if strcmp(app.Mainapp.Data.Info.EventRelatedDataType,'Raw')                
        if strcmp(app.Mainapp.EventLFPTF.DataTypeDropDown.Value,"Raw Event Data")
            [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.EventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
        elseif strcmp(app.Mainapp.EventLFPTF.DataTypeDropDown.Value,"Preprocessed Event Data")
            [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.PreprocessedEventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
        end
    else
        if isfield(app.Mainapp.Data.Info,"DownsampleFactor")
            if strcmp(app.Mainapp.EventLFPTF.DataTypeDropDown.Value,"Raw Event Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.EventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            elseif strcmp(app.Mainapp.EventLFPTF.DataTypeDropDown.Value,"Preprocessed Event Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.PreprocessedEventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.DownsampledSampleRate,DataChannelSelected,EventNrRange,Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            end
        else
            if strcmp(app.Mainapp.EventLFPTF.DataTypeDropDown.Value,"Raw Event Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.EventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            elseif strcmp(app.Mainapp.EventLFPTF.DataTypeDropDown.Value,"Preprocessed Event Data")
                [app.Mainapp.EventLFPTF.climsTF,app.Mainapp.CurrentPlotData] = Event_Module_Time_Frequency_Main(app.Mainapp.Data.PreprocessedEventRelatedData,app.Mainapp.EventLFPTF.UIAxes,app.Mainapp.Data.Info.NativeSamplingRate,DataChannelSelected,EventNrRange,Timearoundevent,TF,app.Mainapp.EventLFPTF.TFInfos.PlottedData,app.Mainapp.EventLFPTF.TFInfos.Addons,app.Mainapp.EventLFPTF.WaveletTypeDropDown.Value,app.Mainapp.EventLFPTF.TwoORThreeD,app.Mainapp.CurrentPlotData,app.Mainapp.PlotAppearance);
            end
        end
    end
end