function RUN_Main_Plot_Analysis_Module(app,ModuleFunctionName)

if strcmp(ModuleFunctionName,"Spike Rate")
    app.PSTHApp = Spike_Rate_Window(app);
elseif strcmp(ModuleFunctionName,"Power Estimate")
    app.SpectralEstApp = Spectral_Power_Estimate_Window(app);
elseif strcmp(ModuleFunctionName,"Current Source Density")
    app.CSDApp = CSD_Window(app);
end