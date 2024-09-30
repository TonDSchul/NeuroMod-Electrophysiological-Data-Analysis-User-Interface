function RUN_Continous_Data_Module(app,ModuleFunctionName)

if strcmp(ModuleFunctionName,"Preprocessing")

    Preprocessing_Window(app);

elseif strcmp(ModuleFunctionName,"Band Power Analysis")

    Static_Power_Spectrum_Window(app);

elseif strcmp(ModuleFunctionName,"Spike Analysis")
    % Delete Part of CurrentPlotData holding previous spike
    % data if its there
    if isfield(app.CurrentPlotData,'MainRateUnitXData')
        app.CurrentPlotData = rmfield(app.CurrentPlotData, {'MainRateUnitXData', 'MainRateUnitYData','MainRateUnitCData', 'MainRateUnitType', 'MainRateUnitXTicks'});
    end
    if isfield(app.CurrentPlotData,'MainRateTimeXData')
        app.CurrentPlotData = rmfield(app.CurrentPlotData, {'MainRateTimeXData', 'MainRateTimeYData','MainRateTimeCData', 'MainRateTimeType', 'MainRateTimeXTicks'});
    end
    if isfield(app.CurrentPlotData,'MainRateChannelXData')
        app.CurrentPlotData = rmfield(app.CurrentPlotData, {'MainRateChannelXData', 'MainRateChannelYData','MainRateChannelCData', 'MainRateChannelType', 'MainRateChannelXTicks'});
    end
    if isfield(app.CurrentPlotData,'MainUnitXData')
        app.CurrentPlotData = rmfield(app.CurrentPlotData, {'MainUnitXData', 'MainUnitYData','MainUnitCData', 'MainUnitType', 'MainUnitXTicks'});
    end
    if isfield(app.CurrentPlotData,'MainXData')
        app.CurrentPlotData = rmfield(app.CurrentPlotData, {'MainXData', 'MainYData','MainCData', 'MainType', 'MainXTicks'});
    end
           
    if ~isfield(app.Data,'Spikes')
        msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        return;
    elseif isfield(app.Data,'Spikes') && strcmp(app.Data.Info.SpikeType,'Kilosort')
        % Open app window for Analysis of Kilosort Data
        Continous_Kilosort_Spike_Window(app);
    elseif isfield(app.Data,'Spikes') && strcmp(app.Data.Info.SpikeType,'Internal')
        % Open app window for Analysis of Internal Spike Detection
        Continous_Internal_Spike_Window(app);
    end

elseif strcmp(ModuleFunctionName,"Unit Analysis")
    if ~isfield(app.Data,'Spikes')
        msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        return;
    else
        if strcmp(app.Data.Info.SpikeType,'Kilosort')
            if isfield(app.Data.Spikes,"Waveforms")
                Continous_Waveform_Analysis_Window(app,"ContinousWindow");
            end
        elseif strcmp(app.Data.Info.SpikeType,'Internal')
            if isfield(app.Data.Info,'SpikeSorting')
                Continous_Waveform_Analysis_Window(app,"ContinousWindow");
            else
                msgbox("No Spike Sorting Data found for Internal Spike Analysis.");
            end
        end
    end
end