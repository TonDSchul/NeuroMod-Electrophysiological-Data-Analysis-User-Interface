function app = Preprocess_DeleteLastPipeline_Entry(app)

%________________________________________________________________________________________

%% Function to delete the last preprocessing pipeline step added

%Input/Output:
% app: preprocessing app window object

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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

elseif strcmp(app.PreprocessingSteps(end),"Stimulation Artefact Rejection")
    if isfield(app.Info,'StimArtefactChannel')
        fieldsToDelete = {'StimArtefactChannel','TimeAroundStimArtefact','ArtefactRejectedTrigger'};
        % Delete fields
        app.Info = rmfield(app.Info, fieldsToDelete);
    end
    app.PreprocessingSteps(end) = [];

elseif strcmp(app.PreprocessingSteps(end),"ASR")
    if isfield(app.Info,'ASR')
        fields = {'ASRLineNoiseC','ASRHPTransitions','ASRBurstC','WindowC','ASR'};
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
    
    % Initialize a cell array to store strings for each field
    plotStrings = cell(1, numel(fieldnames(app.Info)));
    
    % Loop through each field
    fieldNames = fieldnames(app.Info);
    for i = 1:numel(fieldNames)
        % Get the field name
        fieldName = fieldNames{i};
        
        % Get the values of the field
        fieldValues = app.Info.(fieldName);
        
        % Create a string for the field and its values
        plotString = sprintf('%s: %s', fieldName, mat2str(fieldValues));
        
        % Store the string in the cell array
        plotStrings{i} = plotString;
    end
    
    % Convert cell array to a string vector
    plotStringsVector = string(plotStrings);
    
    Texttoshow = [app.PreprocessingSteps;"";"Pipeline Parameter:"; plotStringsVector'];

    app.TextArea.Value = Texttoshow;

else
    Texttoshow = "No Pipeline Components selected. Add one and start pipeline";
    app.TextArea.Value = Texttoshow;
end