function RUN_Main_Plot_Analysis_Module(app,ModuleFunctionName)

%% This function is executed when the user pressed the RUN button of the Main Plot Analysis Module
% It opens the windows of this module depending on the selection the user
% made in the module field to the right of the RUN button

if strcmp(ModuleFunctionName,"Live Spike Rate")
    if ~isfield(app.Data,'Spikes')
        msgbox("Warning: No spike data found. Please first use the Spike Module to extract or load spike data.");
        return;
    end

    if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
    end

    if ~isempty(app.ProbeViewWindowHandle) && isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') % Add option to probe view when available
        AlreadyIn = 0;
        for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
            if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Main Plot Spike Rate')
                AlreadyIn = 1;
            end
        end
        if AlreadyIn == 0
            app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Main Plot Spike Rate';
        end
    else % if no probe view available
 
    end

    app.PSTHApp = Spike_Rate_Window(app);
    
    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"LiveSpikeRate");
    
    if ~isvalid(app.PSTHApp)
        app.PSTHApp = [];
    end

elseif strcmp(ModuleFunctionName,"Live Power Estimate")

    if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
    end

    if ~isempty(app.ProbeViewWindowHandle) && isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') % Add option to probe view when available
        AlreadyIn = 0;
        for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
            if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Main Plot Power Estimate')
                AlreadyIn = 1;
            end
        end
        if AlreadyIn == 0
            app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Main Plot Power Estimate';
        end
    else % if no probe view available
 
    end

    app.SpectralEstApp = Spectral_Power_Estimate_Window(app);

    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"LivePowerEstimate");

elseif strcmp(ModuleFunctionName,"Live Current Source Density")

    if isempty(app.ProbeViewWindowHandle) || ~isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure')
        app.ProbeViewWindowHandle = Probe_View_Window(app,'MainWindow');
    end

    if ~isempty(app.ProbeViewWindowHandle) && isprop(app.ProbeViewWindowHandle,'ProbeViewUIFigure') % Add option to probe view when available
        AlreadyIn = 0;
        for i = 1:length(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items)
            if strcmp(app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{i},'Main Plot Current Source Density')
                AlreadyIn = 1;
            end
        end
        if AlreadyIn == 0
            app.ProbeViewWindowHandle.ChangeforWindowDropDown.Items{end+1} = 'Main Plot Current Source Density';
        end
    else % if no probe view available
 
    end

    app.CSDApp = CSD_Window(app);

    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"LiveCSD");


elseif strcmp(ModuleFunctionName,"Instantaneous Frequency")

    app.LiveECHTWindow = Live_InstFrequency_Window(app);
    
    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"LiveECHT");

end