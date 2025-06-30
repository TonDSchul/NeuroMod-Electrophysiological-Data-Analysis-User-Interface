function app = Preprocess_DeleteLastPipeline_Entry(app)

if strcmp(app.PreprocessingSteps(end),"High-Pass") || strcmp(app.PreprocessingSteps(end),"Low-Pass")
    if isfield(app.Info,'FilterMethod')
        % Fields to delete
        fieldsToDelete = {'Cutoff', 'FilterOrder', 'FilterMethod', 'FilterType', 'FilterDirection'};
        % Delete fields
        app.Info = rmfield(app.Info, fieldsToDelete);
    end
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"Narrowband")
    if isfield(app.Info,'NarrowbandFilterMethod')
        fields = {'NarrowbandFilterMethod','NarrowbandFilterType','NarrowbandFilterDirection','NarrowbandCutoff','NarrowbandFilterOrder'};
        app.Info = rmfield(app.Info,fields);
    end
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"Resampling")
    if isfield(app.Info,'Resample')
        fields = {'Resample','ResamplingFrequency'};
        app.Info = rmfield(app.Info,fields);
    end
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"Median-Filter") 
    if isfield(app.Info,'MedianFilterMethod')
        % Fields to delete
        fieldsToDelete = {'MedianFilterOrder', 'MedianFilterMethod'};
        % Delete fields
        app.Info = rmfield(app.Info, fieldsToDelete);
    end
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"Band-Stop")
    if isfield(app.Info,'BandStopFilterMethod')
        % Fields to delete
        fieldsToDelete = {'BandStopCutoff', 'BandStopFilterOrder', 'BandStopFilterMethod', 'BandStopFilterType', 'BandStopFilterDirection'};
        % Delete fields
        app.Info = rmfield(app.Info, fieldsToDelete);
    end
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"Downsampling")
    fieldsToDeleteInfo = {'DownsampleFactor','DownsampledSampleRate'};
    app.Info = rmfield(app.Info, fieldsToDeleteInfo);
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"Normalize")
    fieldsToDelete = {'Normalize'};
    app.Info = rmfield(app.Info, fieldsToDelete);
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"GrandAverage") 
    fieldsToDelete = {'GrandAverage'};
    app.Info = rmfield(app.Info, fieldsToDelete);
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"ChannelDeletion") 
    fieldsToDelete = {'ChannelDeletion'};
    app.Info = rmfield(app.Info, fieldsToDelete);
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"CutStart") 
    fieldsToDelete = {'CutStart'};
    app.Info = rmfield(app.Info, fieldsToDelete);
    app.PreprocessingSteps(end) = [];
elseif strcmp(app.PreprocessingSteps(end),"CutEnd") 
    fieldsToDelete = {'CutEnd'};
    app.Info = rmfield(app.Info, fieldsToDelete);
    app.PreprocessingSteps(end) = [];
end

if ~isempty(app.PreprocessingSteps)
    % Temporarily delete channeldeletion settings (channel
    % numbers) to be able to show the text in the window -->
    % has to be fixed
    if isfield(app.Info,"ChannelDeletion")
        TempInfo = app.Info;
        fieldsToDelete = {'ChannelDeletion'};
        % Delete fields
        TempInfo = rmfield(TempInfo, fieldsToDelete);
        % Get the field names of the structure
        fieldNames = fieldnames(TempInfo);
    else
        % Get the field names of the structure
        fieldNames = fieldnames(app.Info);
    end
    
    % Convert the structure fields into a cell array of strings
    structValues = cell(size(fieldNames));
    for i = 1:numel(fieldNames)
        structValues{i} = string(app.Info.(fieldNames{i}));
    end
    
    % Combine the original string array with the structure values
    Texttoshow = [app.PreprocessingSteps;"";"Pipeline Parameter:"; structValues];

    app.TextArea.Value = Texttoshow;

else
    Texttoshow = "No Pipeline Components selected. Add one and start pipeline";
    app.TextArea.Value = Texttoshow;
end