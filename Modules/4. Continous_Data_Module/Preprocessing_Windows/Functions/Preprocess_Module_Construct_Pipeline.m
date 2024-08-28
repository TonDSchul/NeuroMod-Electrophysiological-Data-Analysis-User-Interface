function [Info,PreprocessingSteps,Texttoshow] = Preprocess_Module_Construct_Pipeline(type,Info,PreprocessingSteps,PlotExample,FilterMethod,FilterType,CuttoffFrequency,FilterDirection,FilterOrder,DownsampleFactor,SampleRate)
%________________________________________________________________________________________

%% Function that adds a preprocessing option to the pipeline. 
% When the user clicks on the 'Add to Pipeline' Button, this function is
% called to save the selected settings for later, when the
% 'Preprocess_Module_Apply_Pipeline' performs the actual preprocessing

% Input:
% 1. type: char name of preprocessing step applied. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 2. Info: Structure of preprocessing app that gets filled based on the other inputs to this function to save infos for later preprocessing. % NOTE: % Paremeters Saved in app.Info variable (NOT THE MAINAPP Original DATA)!! Only applied to the
% mainapp data after preprocessing pipeline finsihed. Has to be already saved here bc multiple filter can be applied. 
% 3. PreprocessingSteps: tring array that get filled with the name of the preprocesing step added and displayed in the textbox of the
% preprocessing window. When Pipiline is executed it loops over those names and based on the name applies the corresponding preprocessing function. 
% 4: PlotExample: true or false, if true all of the stuff here is temporary
% to plot an example of what the preprocessing would look like.
% 5. FilterMethod: char with name of filter when filtering selected. Either "Low-Pass" OR "High-Pass" OR "Band-Stop" OR "Median Filter" OR "Narrowband"
% 6. FilterType: char input Options: "Butterworth IR" OR "FIR-1" OR "Firls" 
% 7. CuttoffFrequency: number as char char, Cut off frequency for filters. Only requied when filter selected in PreproMethod field, Input as char in Hz
% 8. FilterDirection: char. Options: "Zero-phase forward and reverse" OR "Forward" OR "Reverse" OR "Zero-phase reverse and forward"
% 9. FilterOrder: number as char specifying the filter order for applied filter. Input as char. This only is required when a filter is selected as the methods field.
% 10. DownsampleFactor: number as char, New downsampled sampling rate in Hz; input as char. This only is required when a filter is selected as the methods field.
% 11. SampleRate: Sampling Rate in Hz as double

% Output: 
% 1. Info (app.Info, not part of the original main window dataset!). Holds
% all infos passed to this function to be read by the
% 'Preprocess_Module_Apply_Pipeline' to know what to do

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

Texttoshow = [];

%% Function that adds a preprocessing option to the pipeline. 
% Variable PreprocessingSteps is a s
%% This function also already saves the parameter of the preprocessing step added!


%% Check if a step that has to be added already was added
% If the user wants to add a filter
if strcmp(type,"Filter")
    % Variables that indicate if the respective filter was already added to
    % the pipeline. If so, the old settings for the old filter selection
    % get overwritten with the new ones.
    flagexist = 0;
    flagbandstop = 0;
    flagmedian = 0;

    % If PreprocessingSteps filled with values (already added steps to pipeline)
    if ~isempty(PreprocessingSteps)
        % Loop over already added steps
        for i = 1:length(PreprocessingSteps)
            % Identofy which filter was already added and mark it with the
            % flag variables
            if strcmp(PreprocessingSteps(i),"Low-Pass")
                Index = i;
                flagexist = 1;
            elseif strcmp(PreprocessingSteps(i),"High-Pass")
                Index = i;
                flagexist = 1;
            elseif strcmp(PreprocessingSteps(i),"Narrowband")
                Index = i;
                flagexist = 1;
            elseif strcmp(PreprocessingSteps(i),"Band-Stop")
                Index = i;
                flagbandstop = 1;
            elseif strcmp(PreprocessingSteps(i),"Median Filter")
                Index = i;
                flagmedian = 1;
            end
        end
    end
    
    %% Save selected filterparameter (overwriting old settings happens here!)
    % If a filter except of the following two is selected: Parameter names
    % are the same and only one of them can be applied at a time -->
    % handling all of these casess together
    if ~strcmp(FilterMethod,"Median Filter") && ~strcmp(FilterMethod,"Band-Stop")
        % Save all entered filter parameters
        Info.FilterMethod = FilterMethod;
        Info.FilterType = FilterType;
        Info.Cutoff = CuttoffFrequency;
        Info.FilterDirection = FilterDirection; 
        Info.FilterOrder = FilterOrder;
    elseif strcmp(FilterMethod,"Median Filter")
        % Median filter can be applied along with another filter. Therefore
        % the field holding the parameter has to be named differently
        Info.MedianFilterMethod = FilterMethod;
        Info.MedianFilterOrder = FilterOrder;
    elseif strcmp(FilterMethod,"Band-Stop")
        % Band-Stop filter can be applied along with another filter. Therefore
        % the field holding the parameter has to be named differently
        Info.BandStopFilterMethod = FilterMethod;
        Info.BandStopFilterType = FilterType;
        Info.BandStopFilterDirection = FilterDirection; 
        Info.BandStopCutoff = CuttoffFrequency;
        Info.BandStopFilterOrder = FilterOrder;
    end
    
    %% Replace old pipeline entry when a filter is added and a filter already was added that cannot be applied together
    % Check If flags for filters except of bandstop and median from which only one at a time can be
    % applied is set to 1 (if already part of the pipeline)
    if flagexist == 1 && strcmp(FilterMethod,"Low-Pass") || flagexist == 1 && strcmp(FilterMethod,"High-Pass") || flagexist == 1 && strcmp(FilterMethod,"Narrowband")
        % If filter already added: Replace entry with the new filter
        % selection. Parameters already got overwritten in the part above,
        if strcmp(FilterMethod,"Low-Pass")
            PreprocessingSteps(Index) = "Low-Pass";
        elseif strcmp(FilterMethod,"High-Pass")
            PreprocessingSteps(Index) = "High-Pass";
        elseif strcmp(FilterMethod,"Narrowband")
            PreprocessingSteps(Index) = "Narrowband";
        end
    
    %% Give info about overwriting
    % If bandstop or median filter already added: Old settings are
    % overwritten
    elseif flagbandstop == 1 && strcmp(FilterMethod,"Band-Stop") || flagmedian == 1 && strcmp(FilterMethod,"Median Filter")
        
        if strcmp(FilterMethod,"Band-Stop")
            f = msgbox("Band-Stop Filter was already added. Previous Settings got replaced by the current ones");
           
        end
        if strcmp(FilterMethod,"Median Filter")
            f = msgbox("Median-Filter was already added. Previous Settings got replaced by the current ones");
            
        end
    else
        % Add selected setp to the vector holding the pipeline order that
        % is used when the pipeline starts
        if isempty(PreprocessingSteps)
            PreprocessingSteps = [PreprocessingSteps,convertCharsToStrings(FilterMethod)];
        else
            PreprocessingSteps = [PreprocessingSteps;convertCharsToStrings(FilterMethod)];
        end
    end
    % display updated pipeline in preprocessing window textbox
end

%% If user seleceted downsampling 
% Check if it was already applied, If yes give a warning and overwrite
% values, ifnot save new paramter
if strcmp(type,"Downsample")
    if ~isempty(PreprocessingSteps)
        AlreadyFound = 0;
        for i = 1:length(PreprocessingSteps)
            % If downsampling was already applied
            if strcmp(PreprocessingSteps(i),"Downsampling")
                f = msgbox("Downsampling was already added. Previous Settings got replaced by the current ones");
                Info.DownsampledSampleRate = str2double(DownsampleFactor);
                Info.DownsampleFactor = round(SampleRate/Info.DownsampledSampleRate);

                %Info.DownsampledSampleRate = round(SampleRate/Info.DownsampleFactor);
                % function ends here, next lines only get executed when
                % downsampling was not already part of the pipeline
                AlreadyFound = 1;
            end
        end
    % If downsampling gets added the first time: Save parameter and add to
    % the pipeline vector PreprocessingSteps holding the steps for
    % later execution  of the pipeline
    if AlreadyFound == 0
        PreprocessingSteps = [PreprocessingSteps;"Downsampling"];
        Info.DownsampledSampleRate = str2double(DownsampleFactor);
        Info.DownsampleFactor = round(SampleRate/Info.DownsampledSampleRate);
    end

    elseif isempty(PreprocessingSteps)
        PreprocessingSteps = [PreprocessingSteps,"Downsampling"];
        Info.DownsampledSampleRate = str2double(DownsampleFactor);
        Info.DownsampleFactor = round(SampleRate/Info.DownsampledSampleRate);
    end
end
%% If user seleceted Normalize 
% Check if it was already applied, If yes give a warning and overwrite
% values, if not save new paramter
if strcmp(type,"Normalize")
    if ~isempty(PreprocessingSteps)
        % If Normalize was already applied
        AlreadyFound = 0;
        for i = 1:length(PreprocessingSteps)
            if strcmp(PreprocessingSteps(i),"Normalize")
                f = msgbox("Normalization was already added.");
                % function ends here, next lines only get executed when
                % Normalize was not already part of the pipeline
                AlreadyFound = 1;
            end
        end
        % If Normalize gets added the first time: Save parameter and add to
        % the pipeline vector PreprocessingSteps holding the steps for
        % later execution  of the pipeline
        if AlreadyFound == 0
            PreprocessingSteps = [PreprocessingSteps;"Normalize"];
            % Info saved to identofy that GrandAverage was applied
            Info.Normalize = "Normalization On";
        end
    elseif isempty(PreprocessingSteps)
        PreprocessingSteps = [PreprocessingSteps,"Normalize"];
        Info.Normalize = "Normalization On";
    end
end

%% If user seleceted GrandAverage 
% Check if it was already applied, If yes give a warning and overwrite
% values, if not save new paramter
if strcmp(type,"GrandAverage")
    if ~isempty(PreprocessingSteps)
        AlreadyFound = 0;
        for i = 1:length(PreprocessingSteps)
            % If GrandAverage was already applied
            if strcmp(PreprocessingSteps(i),"GrandAverage")
                f = msgbox("GrandAverage was already added.");
                % function ends here, next lines only get executed when
                % GrandAverage was not already part of the pipeline
                AlreadyFound = 1;
            end
        end
    % If GrandAverage gets added the first time: Save parameter and add to
    % the pipeline vector PreprocessingSteps holding the steps for
    % later execution  of the pipeline
        if AlreadyFound == 0
            PreprocessingSteps = [PreprocessingSteps;"GrandAverage"];
            % Info saved to identofy that GrandAverage was applied
            Info.GrandAverage = "GrandAverage On";
        end

    elseif isempty(PreprocessingSteps)
        PreprocessingSteps = [PreprocessingSteps,"GrandAverage"];
        Info.GrandAverage = "GrandAverage On";
    end
end
%% If user seleceted ChannelDeletion 
% Check if it was already applied, If yes give a warning and overwrite
% values, if not save new paramter
%%% Info was already save in the extra GUI for ChannelDeletion
if strcmp(type,"ChannelDeletion")
    if ~isempty(PreprocessingSteps)
        AlreadyFound = 0;
        for i = 1:length(PreprocessingSteps)
            % If GrandAverage was already applied
            if strcmp(PreprocessingSteps(i),"ChannelDeletion")
                msgbox("ChannelDeletion was already added. Channel Selection updated according to your inputs");
                AlreadyFound = 1;
                % function ends here, next lines only get executed when
                % GrandAverage was not already part of the pipeline
            end
        end
        if AlreadyFound == 0
            PreprocessingSteps = [PreprocessingSteps;"ChannelDeletion"]; 
        end
    elseif isempty(PreprocessingSteps)
       PreprocessingSteps = "ChannelDeletion"; 
    end
end

%% If user seleceted ChannelDeletion 
% Check if it was already applied, If yes give a warning and overwrite
% values, if not save new paramter
%%% Info was already save in the extra GUI for cutting time
if strcmp(type,"CutStart")  
    if ~isempty(PreprocessingSteps)
        % If CutStart was already applied
        AlreadyFound = 0;
        for i = 1:length(PreprocessingSteps)
            if strcmp(PreprocessingSteps(i),"CutStart")
                msgbox("Cutting start of the recording was already added. Cut time updated according to your inputs");
                % function ends here, next lines only get executed when
                % GrandAverage was not already part of the pipeline
                AlreadyFound = 1;
            end
        end
        if AlreadyFound == 0
            PreprocessingSteps = [PreprocessingSteps;"CutStart"]; 
        end
    elseif isempty(PreprocessingSteps)
       PreprocessingSteps = "CutStart"; 
    end
end

if strcmp(type,"CutEnd")
    if ~isempty(PreprocessingSteps)
        AlreadyFound = 0;
        for i = 1:length(PreprocessingSteps)
            % If CutEnd was already applied
            if strcmp(PreprocessingSteps(i),"CutEnd")
                msgbox("Cutting end of the recording was already added. Cut time updated according to your inputs");
                % function ends here, next lines only get executed when
                % GrandAverage was not already part of the pipeline
                AlreadyFound = 1;
            end
        end
        if AlreadyFound == 0
            PreprocessingSteps = [PreprocessingSteps;"CutEnd"]; 
        end
    elseif isempty(PreprocessingSteps)
       PreprocessingSteps = "CutEnd"; 
    end
end

% Delete Channel Deletion field in temporary variable to be able to show
% text --> has to be fixed
if isfield(Info,"ChannelDeletion")
    TempInfo = Info;
    fieldsToDelete = {'ChannelDeletion'};
    % Delete fields
    TempInfo = rmfield(TempInfo, fieldsToDelete);
    % Get the field names of the structure
    fieldNames = fieldnames(TempInfo);
else
    % Get the field names of the structure
    fieldNames = fieldnames(Info);
end

% Initialize a cell array to store strings for each field
plotStrings = cell(1, numel(fieldnames(Info)));

% Loop through each field
fieldNames = fieldnames(Info);
for i = 1:numel(fieldNames)
    % Get the field name
    fieldName = fieldNames{i};
    
    % Get the values of the field
    fieldValues = Info.(fieldName);
    
    % Create a string for the field and its values
    plotString = sprintf('%s: %s', fieldName, mat2str(fieldValues));
    
    % Store the string in the cell array
    plotStrings{i} = plotString;
end

% Convert cell array to a string vector
plotStringsVector = string(plotStrings);

% % Convert the structure fields into a cell array of strings
% structValues = cell(size(fieldNames));
% for i = 1:numel(fieldNames)
%     structValues{i} = string(Info.(fieldNames{i}));
% end

if PlotExample == 0
    % Combine the original string array with the structure values
    %Texttoshow = [PreprocessingSteps;"";"Pipeline Parameter:"; structValues];
    Texttoshow = [PreprocessingSteps;"";"Pipeline Parameter:"; plotStringsVector'];
else
    Texttoshow = [];
end


    



