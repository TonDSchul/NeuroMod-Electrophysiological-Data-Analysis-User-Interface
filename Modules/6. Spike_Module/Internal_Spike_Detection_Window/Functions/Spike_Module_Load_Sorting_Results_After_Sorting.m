function Spike_Module_Load_Sorting_Results_After_Sorting(app,Sorter,Path)

if ~strcmp(Sorter,"WaveClus 3")

    if strcmp(Sorter,"Mountainsort 5")
        SorterFolders(1) = "";
        SorterFolders(2) = "";
        SorterFolders(3) = strcat(Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\Mountainsort 5");      
        SorterFolders(4) = "";
        SorterFolders(5) = "";
        SorterFolders(6) = "";
    elseif strcmp(Sorter,"SpykingCircus 2")
        SorterFolders(1) = "";
        SorterFolders(2) = "";
        SorterFolders(3) = "";
        SorterFolders(4) = strcat(Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\SpykingCircus 2");
        SorterFolders(5) = "";
        SorterFolders(6) = "";
    elseif strcmp(Sorter,"Kilosort 4")
        SorterFolders(1) = "";
        SorterFolders(2) = "";
        SorterFolders(3) = "";
        SorterFolders(4) = "";
        SorterFolders(5) = "";
        SorterFolders(6) = strcat(Path,"\SpikeInterface\SpikeInterface_Sorting_Phy_Results\Kilosort 4");
    end

    [Path,CurrentSorter,AmplitudeScalingFactorEditField,InfoText] = Spike_Module_Determine_Sorters_Available(app.Mainapp.Data,SorterFolders,0,0);
    
    if isempty(Path)
        msgbox("No Path selected. Please first select a folder.");
        return;
    end
    
    if ~isfolder(Path)
        msgbox("Selected Path does not exist. Please select an exisitng folder.");
        return;
    end
    
    if isempty(CurrentSorter)
        msgbox("No valid sorting files found in selected folder.");
        return;
    end
    
    if isempty(AmplitudeScalingFactorEditField)
        KilosortScalingFactor = [];
    else
        KilosortScalingFactor = str2double(AmplitudeScalingFactorEditField);
    end
    
    if strcmp(Sorter,"Mountainsort 5") || strcmp(Sorter,"SpykingCircus 2") || strcmp(Sorter,"Kilosort 4")
        [app.Mainapp.Data,SaveFilter] = Spike_Module_Load_SpikeInterface_Sorter(app.Mainapp.Data,Path,CurrentSorter);
    end
    
    % if strcmp(Sorter,"Kilosort External")
    %     % Function to load all relevant npy and .mat files Kilosort outputs
    %     [app.Mainapp.Data,SaveFilter] = Spike_Module_Load_Kilosort_Data(app.Mainapp.Data,"No",Path,KilosortScalingFactor);
    % end
    
    app.Mainapp.UIAxes.NextPlot = "replace"; 
    plot(app.Mainapp.UIAxes,0,0);
    app.Mainapp.UIAxes.NextPlot = "add"; 
    app.Mainapp.UIAxes_2.NextPlot = "replace"; 
    plot(app.Mainapp.UIAxes_2,0,0);
    app.Mainapp.UIAxes_2.NextPlot = "add"; 
    
    %Take care of potentially changed backgroundcolor
    app.Mainapp.UIAxes.Color = app.Mainapp.PlotAppearance.MainWindow.Data.Color.MainBackground;
    app.Mainapp.UIAxes_2.Color = app.Mainapp.PlotAppearance.MainWindow.Data.Color.TimeBackground;
    app.Mainapp.UIAxes.FontSize = app.Mainapp.PlotAppearance.MainWindow.Data.MainFontSize;
    app.Mainapp.UIAxes_2.FontSize = app.Mainapp.PlotAppearance.MainWindow.Data.TimeFontSize;
    
    if ~isfield(app.Mainapp.Data,'Events')
        if strcmp(app.Mainapp.PlotEvents,"Events")
            app.Mainapp.PlotEvents = "No";
        end
        Placeholder = {};
        app.Mainapp.DropDown_2.Items = Placeholder;
        app.Mainapp.DropDown_2.Items{1} = 'Non';
    else
        Placeholder = {};
        app.Mainapp.DropDown_2.Items = Placeholder;
        app.Mainapp.DropDown_2.Items{1} = 'Non';
        app.Mainapp.DropDown_2.Items{2} = 'Events';
        if strcmp(app.Mainapp.PlotEvents,"Events")
            app.Mainapp.DropDown_2.Value = 'Events';
        end
    end
    
    if ~isfield(app.Mainapp.Data,'Spikes')
        % if strcmp(app.Mainapp.Plotspikes,"Spikes")
        %     app.Mainapp.Plotspikes = "No";
        % end
    else
        app.Mainapp.DropDown_2.Items = Placeholder;
        app.Mainapp.DropDown_2.Items{1} = 'Non';
        if isfield(app.Mainapp.Data,'Events')
            app.Mainapp.DropDown_2.Items{2} = 'Events';
            app.Mainapp.DropDown_2.Items{3} = 'Spikes';
        else
            app.Mainapp.DropDown_2.Items{2} = 'Spikes';
        end
        
        if strcmp(app.Mainapp.PlotEvents,"Events")
            app.Mainapp.DropDown_2.Value = 'Events';
        else
            app.Mainapp.DropDown_2.Value = 'Non';
        end
    end
    
    if strcmp(app.Mainapp.Plotspikes,"Spikes")
        SpikeHandles = findobj(app.Mainapp.UIAxes, 'Type', 'line', 'Tag', 'Spikes');
        if ~isempty(SpikeHandles)
            delete(SpikeHandles(:));
        end
        app.Mainapp.Plotspikes = "No";
    end
    
    Utility_Show_Info_Loaded_Data(app.Mainapp);
    
    if strcmp(SaveFilter,"Yes")
        [app.Mainapp] = Organize_Initialize_GUI (app.Mainapp,"Preprocessing",app.Mainapp.Data,[],[],[],[],[]);
    end
    
    Organize_Prepare_Plot_and_Extract_GUI_Info(app.Mainapp,1,"Initial","SpikeExtraction",app.Mainapp.PlotEvents,app.Mainapp.Plotspikes);

else

    LoadFolder = strcat(Path,"\Wave_Clus");

    [app.Mainapp.Data] = Spike_Module_Internal_Spike_Sorting(app.Mainapp.Data,LoadFolder,"Loading",[],"WaveClus");
    SaveFilter = "No";

end