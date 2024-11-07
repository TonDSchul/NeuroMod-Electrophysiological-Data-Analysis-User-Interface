function RUN_Event_Data_Module(app,ModuleFunctionName)

%% This function is executed when the user pressed the RUN button of the Event Data Module
% It opens the windows of this module depending on the selection the user
% made in the module field to the right of the RUN button

if strcmp(ModuleFunctionName,"Extract Events and Data")

    app.EventExtractionWindow = Extract_Events_Window(app);

elseif strcmp(ModuleFunctionName,"Preprocessing")

    if ~isfield(app.Data,'EventRelatedData')
        msgbox("Error: No event related data found. Please first extract events and event related data");
    else
        if isempty(app.Data.EventRelatedData)
            msgbox("Error: No event related data found. Please first extract events and event related data");
        else
            app.PreproEventsMainWindow = Preprocessing_Events_Main_Window(app);
        end
    end
    
elseif strcmp(ModuleFunctionName,"LFP Analysis")
    if ~isfield(app.Data,'EventRelatedData')
        msgbox("Error: No event related data found. Please first extract events and event related data");
    else
        app.LFPEventsMainWindow = Analyse_Event_Related_Signal(app);
    end
    
    if isempty(app.ProbeViewWindowHandle)
        app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
    end

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
    
    if ~isfield(app.Data,'EventRelatedData')
        msgbox("Error: No event related data found. Please first extract events and event related data");
    else
        if ~isfield(app.Data,'Spikes')
            msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
            return;
        elseif isfield(app.Data,'Spikes') && strcmp(app.Data.Info.SpikeType,'Kilosort')
            %% Start GUI

            if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
                app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
            end

            if ~isempty(app.ProbeViewWindowHandle) && isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') % Add option to probe view when available
                AlreadyIn = 0;
                for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
                    if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Event Kilosort Spikes')
                        AlreadyIn = 1;
                    end
                end
                if AlreadyIn == 0
                    app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Event Kilosort Spikes';
                end 
            end

            [app.Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(app.Data,'Kilosort',0);

            if Error == 0
                app.EventKilosortSpikesWindow = Events_Kilosort_Spike_Window(app);
            end
        elseif isfield(app.Data,'Spikes') && strcmp(app.Data.Info.SpikeType,'Internal')

            if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
                app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
            end

            if ~isempty(app.ProbeViewWindowHandle) % Add option to probe view when available
                AlreadyIn = 0;
                for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
                    if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Event Internal Spikes')
                        AlreadyIn = 1;
                    end
                end
                if AlreadyIn == 0
                    app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Event Internal Spikes';
                end 
            end

            [app.Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(app.Data,'Internal',0);

            if Error == 0
                app.EventInternalSpikesWindow = Events_Internal_Spike_Window(app);
            end
        end     
    end

elseif strcmp(ModuleFunctionName,"Unit Analysis")
    if ~isfield(app.Data,'EventRelatedData')
        msgbox("Error: No event related data found. Please first extract events and event related data");
    else
        if ~isfield(app.Data,'Spikes')
            msgbox("Warning: No Kilosort - or internal spike data found. Please first use the Spike Module to extract spike data");
            return;
        elseif isfield(app.Data,'Spikes') && strcmp(app.Data.Info.SpikeType,'Kilosort')
            %% Start GUI
            [app.Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(app.Data,'Kilosort',0);

            if isfield(app.Data.Spikes,"Waveforms")
                Continous_Waveform_Analysis_Window(app,"EventWindow");
            end
        elseif isfield(app.Data,'Spikes') && strcmp(app.Data.Info.SpikeType,'Internal')

            [app.Data,Error] = Event_Spikes_Extract_Event_Related_Spikes(app.Data,'Internal',0);

            if isfield(app.Data.Spikes,"Waveforms")
                if isfield(app.Data.Info,'SpikeSorting')
                    Continous_Waveform_Analysis_Window(app,"EventWindow");
                else
                    msgbox("No Spike Sorting Data found for Internal Spike Analysis.")
                end
            end
        end       
    end
end               

