function Execute_Autorun_Export_DataSet_Components(AutorunConfig,DatasetComponent,Data,executableFolder)

for i = 1:length(DatasetComponent)
    if strcmp(DatasetComponent(i),"Raw")
        if ~strcmp(AutorunConfig.Export.DatasetFormat,'.mat')
            warning("Raw data can only be saved as .mat file.")
            continue;
        end
    end
    
    if strcmp(DatasetComponent(i),"Time")
        if ~strcmp(AutorunConfig.Export.DatasetFormat,'.mat')
            warning("Time can only be saved as .mat file.")
            continue;
        end
    end
    
    if strcmp(DatasetComponent(i),"TimeDownsampled")
        if ~strcmp(AutorunConfig.Export.DatasetFormat,'.mat')
            warning("Time can only be saved as .mat file.")
            continue;
        end
    end
    
    if strcmp(DatasetComponent(i),"Preprocessed")
        if ~isfield(Data,DatasetComponent(i))
            warning("No preprocessed data found to export! Please first preprocess your raw dataset.")
            continue;
        end
        if ~strcmp(AutorunConfig.Export.DatasetFormat,'.mat')
            warning("Preprocessed data can only be saved as .mat file.")
            continue;
        end
    end
    
    if strcmp(DatasetComponent(i),"Events")
        if ~isfield(Data,DatasetComponent(i))
            warning("No event data found to export! Please first extract event data.")
            continue;
        end
    end
    
    if strcmp(DatasetComponent(i),"Spikes")
        if ~isfield(Data,DatasetComponent(i))
            warning("No spike data found to export! Please first conduct spike detection or sorting.")
            continue;
        end
    end
    
    if strcmp(DatasetComponent(i),"EventRelatedData")
        if ~isfield(Data,DatasetComponent(i))
            warning("No event realted data found to export! Please first conduct event related analysis before you export.")
            continue;
        end
        if ~strcmp(AutorunConfig.Export.DatasetFormat,'.mat')
            warning("Event related data data can only be saved as .mat file.")
            continue;
        end
    end
    
    if strcmp(DatasetComponent(i),"EventRelatedSpikes")
        if ~isfield(Data,DatasetComponent(i))
            warning("No event related spike data found to export! Please first conduct event related spike analysis before you export.")
            continue;
        end
        if ~strcmp(AutorunConfig.Export.DatasetFormat,'.mat')
            warning("Event related spike data data can only be saved as .mat file.")
            continue;
        end
    end
    
    Utility_Export_Dataset_Components(Data,DatasetComponent(i),AutorunConfig.Export.DatasetFormat,executableFolder,1);
end