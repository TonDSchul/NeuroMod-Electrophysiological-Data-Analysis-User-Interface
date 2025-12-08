function Execute_Autorun_Export_DataSet_Components(AutorunConfig,DatasetComponent,Data,executableFolder)

AutorunConfig.Export.DatasetComponent = ["Info","Events","EventRelatedData","Spikes"]; % .txt OR .csv OR .mat

if strcmp(DatasetComponent,"Preprocessed")
    if ~isfield(Data,DatasetComponent)
        warning("No preprocessed data found to export! Please first preprocess your raw dataset.")
        return;
    end
end

if strcmp(DatasetComponent,"Events")
    if ~isfield(Data,DatasetComponent)
        warning("No event data found to export! Please first extract event data.")
        return;
    end
end

if strcmp(DatasetComponent,"Spikes")
    if ~isfield(Data,DatasetComponent)
        warning("No spike data found to export! Please first conduct spike detection or sorting.")
        return;
    end
end

if strcmp(DatasetComponent,"EventRelatedData")
    if ~isfield(Data,DatasetComponent)
        warning("No event realted data found to export! Please first conduct event related analysis before you export.")
        return;
    end
end

if strcmp(DatasetComponent,"EventRelatedSpikes")
    if ~isfield(Data,DatasetComponent)
        warning("No event related spike data found to export! Please first conduct event related spike analysis before you export.")
        return;
    end
end

Utility_Export_Dataset_Components(Data,DatasetComponent,AutorunConfig.Export.DatasetFormat,executableFolder,1);