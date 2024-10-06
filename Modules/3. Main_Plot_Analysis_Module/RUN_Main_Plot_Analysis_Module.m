function RUN_Main_Plot_Analysis_Module(app,ModuleFunctionName)

%% This function is executed when the user pressed the RUN button of the Main Plot Analysis Module
% It opens the windows of this module depending on the selection the user
% made in the module field to the right of the RUN button

if strcmp(ModuleFunctionName,"Spike Rate")
    app.PSTHApp = Spike_Rate_Window(app);
elseif strcmp(ModuleFunctionName,"Power Estimate")
    app.SpectralEstApp = Spectral_Power_Estimate_Window(app);
elseif strcmp(ModuleFunctionName,"Current Source Density")
    app.CSDApp = CSD_Window(app);
end