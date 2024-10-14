function RUN_Spike_Module(app,ModuleFunctionName)

%% This function is executed when the user pressed the RUN button of the Spike Module
% It opens the windows of this module depending on the selection the user
% made in the module field to the right of the RUN button

if strcmp(ModuleFunctionName,"Internal Spike Detection")
    % Open app window for Internal Spike Detection
    Spike_Detection_Window(app);

elseif strcmp(ModuleFunctionName,"Save for Kilosort")
    
    if ~isfield(app.Data,'Raw')
        msgbox("Error: No Raw Data found. Data to be exported has to not be preprocessed! Returning.");
        return;
    end

    cd(app.executableFolder);

    Kilosort_Savefile_Format_Window(app);
    
elseif strcmp(ModuleFunctionName,"Load from Kilosort")
    
    if isfield(app.Data.Info,'CutStart')
        msgbox("Warning: Start time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end

    if isfield(app.Data.Info,'CutEnd') 
        msgbox("Warning: End time of current dataset was cut. Please ensure, that Kilosort results are based on the same dataset");
    end

    cd(app.executableFolder);

    KilosortLoadWindow = Kilosort_Loadfile_Format_Window(app);

    waitfor(KilosortLoadWindow);
    
    if isfield(app.Data,'Spikes')
        if ~isempty(app.Data.Spikes)
            % This resets the main window plots. This is bc. old spike
            % data can still be shown and has to be replaced with new
            % spike data

            % app.Plotspikes = Flag indicating that spikes are supposed
            % to be plotted. If show spike data was already selected,
            % plot spikes again
            if strcmp(app.Plotspikes,"Spikes")
                SpikeHandles = findobj(app.UIAxes, 'Type', 'line', 'Tag', 'Spikes');
                if ~isempty(SpikeHandles)
                    delete(SpikeHandles(:));
                end
                if strcmp(app.PlotEvents,"Events")
                    app.DropDown_2.Value = "Events";
                else
                    app.DropDown_2.Value = "Non";
                end
                
                app.Plotspikes = "No";
            end

            % Main function to plot data in main window after resetting plots
            Organize_Prepare_Plot_and_Extract_GUI_Info(app,1,"Initial","Static",app.PlotEvents,app.Plotspikes);

        else
            fieldsToDelete = {'Spikes'};
            % Delete fields
            app.Data = rmfield(app.Data, fieldsToDelete);
            app.Data.Info.SpikeType = "Non";
        end
    else
        app.Data.Info.SpikeType = "Non";
    end

    Utility_Show_Info_Loaded_Data(app)
                  
end