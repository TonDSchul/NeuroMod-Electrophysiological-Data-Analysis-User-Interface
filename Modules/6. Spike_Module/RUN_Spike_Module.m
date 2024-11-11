function RUN_Spike_Module(app,ModuleFunctionName)

%% This function is executed when the user pressed the RUN button of the Spike Module
% It opens the windows of this module depending on the selection the user
% made in the module field to the right of the RUN button

if strcmp(ModuleFunctionName,"Internal Spike Detection")
    % Open app window for Internal Spike Detection
    app.SpikeExtractionWindow = Spike_Detection_Window(app);

    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"ExtractSpikes");
    
elseif strcmp(ModuleFunctionName,"Save for Kilosort")
    
    if ~isfield(app.Data,'Raw')
        msgbox("Error: No raw data found! Preprocessing will be done in kilosort and can not be saved. Returning.");
        return;
    end

    cd(app.executableFolder);

    app.SaveforKilosortWindowWindow = Kilosort_Savefile_Format_Window(app);
    
elseif strcmp(ModuleFunctionName,"Load from Kilosort")
    
    if isfield(app.Data.Info,'CutStart')
        msgbox("Warning: Start time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end

    if isfield(app.Data.Info,'CutEnd') 
        msgbox("Warning: End time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end

    cd(app.executableFolder);

    app.LoadfromKilosortWindowWindow = Kilosort_Loadfile_Format_Window(app);
           
end