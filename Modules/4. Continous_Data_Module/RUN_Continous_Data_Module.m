function RUN_Continous_Data_Module(app,ModuleFunctionName)

%% This function is executed when the user pressed the RUN button of the Continous Data Module
% It opens the windows of this module depending on the selection the user
% made in the module field to the right of the RUN button

if strcmp(ModuleFunctionName,"Preprocessing")

    app.PreproWindow = Preprocessing_Window(app);

elseif strcmp(ModuleFunctionName,"Static Spectrum Analysis")

    if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
    end

    if ~isempty(app.ProbeViewWindowHandle) && isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') % Add option to probe view when available
        AlreadyIn = 0;
        for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
            if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Static Spectrum Window')
                AlreadyIn = 1;
            end
        end
        if AlreadyIn == 0
            app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Static Spectrum Window';
        end 
    end

    app.ContStaticSpectrumWindow = Static_Power_Spectrum_Window(app);

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

        if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
            app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
        end

        if ~isempty(app.ProbeViewWindowHandle) && isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') % Add option to probe view when available
            AlreadyIn = 0;
            for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
                if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Cont. Kilosort Spikes')
                    AlreadyIn = 1;
                end
            end
            if AlreadyIn == 0
                app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Cont. Kilosort Spikes';
            end 
        end

        % Open app window for Analysis of Kilosort Data
        app.ConKilosortSpikesWindow = Continous_Kilosort_Spike_Window(app);

    elseif isfield(app.Data,'Spikes') && strcmp(app.Data.Info.SpikeType,'Internal')
        
        if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
            app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
        end

        if ~isempty(app.ProbeViewWindowHandle) && isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') % Add option to probe view when available
            AlreadyIn = 0;
            for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
                if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Cont. Internal Spikes')
                    AlreadyIn = 1;
                end
            end
            if AlreadyIn == 0
                app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Cont. Internal Spikes';
            end 
        end

        % Open app window for Analysis of Internal Spike Detection
        app.ConInternalSpikesWindow = Continous_Internal_Spike_Window(app);
    end

elseif strcmp(ModuleFunctionName,"Unit Analysis")
    if ~isfield(app.Data,'Spikes')
        msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
        return;
    else
        if strcmp(app.Data.Info.SpikeType,'Kilosort')
            if isfield(app.Data.Spikes,"Waveforms")
                app.UnitAnalysis = Continous_Waveform_Analysis_Window(app,"ContinousWindow");
            end
        elseif strcmp(app.Data.Info.SpikeType,'Internal')
            if isfield(app.Data.Info,'SpikeSorting')
                app.UnitAnalysis = Continous_Waveform_Analysis_Window(app,"ContinousWindow");
            else
                msgbox("No Spike Sorting Data found for Internal Spike Analysis.");
            end
        end
    end
end

