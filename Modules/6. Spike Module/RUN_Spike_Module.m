function RUN_Spike_Module(app,ModuleFunctionName)

%% This function is executed when the user pressed the RUN button of the Spike Module
% It opens the windows of this module depending on the selection the user
% made in the module field to the right of the RUN button

if strcmp(ModuleFunctionName,"Spike Detection and Sorting")
    % Open app window for Internal Spike Detection
    app.SpikeExtractionWindow = Spike_Detection_and_Sorting_Window(app);

    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"ExtractSpikes");
    
elseif strcmp(ModuleFunctionName,"Save for Spike Sorting")
    
    app.SaveforKilosortWindowWindow = Save_for_Spike_Sorting_Window(app);
    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"SaveSorting");
    
elseif strcmp(ModuleFunctionName,"Load Spike Sorting Results")
    
    if isfield(app.Data.Info,'CutStart')
        msgbox("Warning: Start time of current dataset was cut. Please ensure, that spike sorting results are based on the same dataset");
    end

    if isfield(app.Data.Info,'CutEnd') 
        msgbox("Warning: End time of current dataset was cut. Please ensure, that spike sorting results are based on the same dataset");
    end

    app.LoadfromKilosortWindowWindow = Load_Spike_Sorting_Window(app);
    [~] = Utility_Set_ToolTips(app,app.ShowToolTipsSetting,"LoadSorting");

elseif strcmp(ModuleFunctionName,"Open Sorting in Phy")
    % msgbox("Work in Progress.")
    % return;
    % 
    if isfield(app.Data,'Spikes')
        if strcmp(app.Data.Info.SpikeType,"SpikeInterface") || strcmp(app.Data.Info.SpikeType,"Kilosort")
            [~] = Manage_Dataset_Module_Start_Phy(app.Data,app.executableFolder);
        else
            msgbox("No spike sorting data found! Please first load sorted data for the current dataset.")
        end
    else
        msgbox("No spike sorting data found! Please first load sorted data for the current dataset.")
    end
end