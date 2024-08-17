function [Data] = Preprocess_Module_Apply_Pipeline (Data,SampleRate,PreprocessingSteps,PlotExample,PreProInfo,ChannelDeletion,TextObject)
%________________________________________________________________________________________

%% Function to Preprocess Raw Data 
% This function uses the fieldtrip tool box for the preprocessing steps
% involving filtering data (lowpass,highpass,bandstop,narrowband and median filter)
% Fieldtrip offical website: https://www.fieldtriptoolbox.org/
% Fieldtrip Github project: https://github.com/fieldtrip/fieldtrip
% Functions used from fieldtrip: 
%ft_preproc_lowpassfilter
%ft_preproc_highpassfilter
%ft_preproc_bandpassfilter
%ft_preproc_bandstopfilter
%ft_preproc_medianfilter -- functions were not modified

% Input:
% 1. Data: Data structure containing raw data as a Channel x Time matrix
% and Info structure with already applied preprocessing steps and other infos
% 2. Sampling Rate: as double in Hz. Not taken from Data.Info to preserve
%original sampling rate temporarily 
% 3. PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 4. PlotExample: 1 or 0 as double to specify whether preprocessing step is
%executed on whole dataset or just on a subsection (50000 samples)´to plot
%an example of what the preprocessing does. 1 for example plot
%5. PreProInfo: Structure containing parameters for each preprocessing
%step. This is populated in the 'Preprocess_Module_Construct_Pipeline'
%function
% 6. ChannelDeletion: double array of channels to be deleted, only required
%if Channeldeletion selected as preprocessing step
% 7. TextObject: App object of text are in the preprocessing window to show
% information about progress and settings. Can be defined as an empty
% variable if run outside of GUI

% Output: 
% 1. Data with added field Data.Preprocessed containing the
% preprocessed data as well addition of preprocessing settings to Data.Info
% to preserver info what has been done to data.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Now loop thorugh all strings in the string array holding the selcted pipeline. This means the code loops over all selected preprocessing steps
% Each time it checks what the string says. Based on this it
% accesses the saved preprocessing parameter (set in
% Preprocess_Construct_Pipeline function) and sets the
% filteroptions according to it. If Data.Info.Filtermethod =
% Butterworth IR, then the variable type is set to 'but' and
% passed into the preprocessing function 

TimeDownsampled = [];
h = [];

if PlotExample == 1
    if isfield(Data,'Raw')
        Data.Raw = Data.Raw(:,1:5000);
    end
end

%% Start Preprocessing Loop
for PPSteps = 1:length(PreprocessingSteps) % Loop thorugh preprocessing steps

    if PlotExample == 0 && ~isempty(TextObject)
        Texttoshow = strcat(PreprocessingSteps(PPSteps)," ...Processing");
        TextObject = Texttoshow;
        pause(0.2);
    end

    % If user selected any filter options except of median
    % filter (doesnt have most of the parameters the other filters have (only filterorder))
    if strcmp(PreprocessingSteps(PPSteps),"Low-Pass") || strcmp(PreprocessingSteps(PPSteps),"High-Pass") || strcmp(PreprocessingSteps(PPSteps),"Narrowband") || strcmp(PreprocessingSteps(PPSteps),"Band-Stop")
        
        h = waitbar(0, 'Applying Filter...', 'Name','Preprocessing...');

        %% Get Filter options
        [type,dir,filterorder,wintype,df,Cutoff,~] = Preprocess_Module_Set_Filter_Parameter(PPSteps,PreprocessingSteps,PreProInfo);

        %% Apply Preprocessing functions to dataset
        if strcmp(PreprocessingSteps(PPSteps),"Low-Pass")            
            % If first preprocessing step: Apply to raw data.
            % The seconf preprocessing step however has top be
            % applied to the already preprocessed dataset,
            % otherwise earlier preprocessing is overwritten
            if PPSteps == 1 % If first step in pipeline: apply to raw data
                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    msg = sprintf('Low Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~, ~] = ft_preproc_lowpassfilter(Data.Raw(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            else % If not first step in pipeline: apply to already preprocessed data
                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    msg = sprintf('Low Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~, ~] = ft_preproc_lowpassfilter(Data.Preprocessed(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            end
        elseif strcmp(PreprocessingSteps(PPSteps),"High-Pass")

            if PPSteps == 1 % If first step in pipeline: apply to raw data
                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    msg = sprintf('High Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~,~] = ft_preproc_highpassfilter(Data.Raw(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            else % If not first step in pipeline: apply to already preprocessed data
                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    msg = sprintf('High Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~, ~] = ft_preproc_highpassfilter(Data.Preprocessed(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            end
        elseif strcmp(PreprocessingSteps(PPSteps),"Narrowband")

            if PPSteps == 1 % If first step in pipeline: apply to raw data
                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    msg = sprintf('Narrowband Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~, ~] = ft_preproc_bandpassfilter(Data.Raw(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            else % If not first step in pipeline: apply to already preprocessed data
                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    msg = sprintf('Narrowband Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~, ~] = ft_preproc_bandpassfilter(Data.Preprocessed(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            end
        elseif strcmp(PreprocessingSteps(PPSteps),"Band-Stop")

            if PPSteps == 1 % If first step in pipeline: apply to raw data
                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    msg = sprintf('Band-Stop Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~, ~] = ft_preproc_bandstopfilter(Data.Raw(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            else % If not first step in pipeline: apply to already preprocessed data
                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    msg = sprintf('Band-Stop Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,:), ~, ~] = ft_preproc_bandstopfilter(Data.Preprocessed(channelnr,:), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            end
        end

    elseif strcmp(PreprocessingSteps(PPSteps),"Median Filter")

        %% Get Filter options
        [~,~,filterorder,~,~,~,~] = Preprocess_Module_Set_Filter_Parameter(PPSteps,PreprocessingSteps,PreProInfo);

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            [Data.Preprocessed] = ft_preproc_medianfilter(Data.Raw, filterorder);
        else % If not first step in pipeline: apply to already preprocessed data
            [Data.Preprocessed] = ft_preproc_medianfilter(Data.Preprocessed, filterorder);
        end

    elseif strcmp(PreprocessingSteps(PPSteps),"Downsampling")

        %% Get Filter options
        [~,~,~,~,~,~,DownsampleFactor] = Preprocess_Module_Set_Filter_Parameter(PPSteps,PreprocessingSteps,PreProInfo);
        
        %DownsampleFactor = round(Data.Info.NativeSamplingRate/DownsampleRate);

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            % Downsampling only works with matrixes cloumn
            % wise. Therefore it is transposed to Channel as
            % columns and then transposed back after
            % downsampling
            Data.Preprocessed = downsample(Data.Raw', DownsampleFactor);
            Data.Preprocessed = Data.Preprocessed';
            DownsampledSampleRate = PreProInfo.DownsampledSampleRate;
            % Create new time vector for downsampled data
            Data.TimeDownsampled = double(0:(1/DownsampledSampleRate):(size(Data.Preprocessed,2)-1)/DownsampledSampleRate);
        else % If not first step in pipeline: apply to already preprocessed data
            Data.Preprocessed = downsample(Data.Preprocessed', DownsampleFactor);
            Data.Preprocessed = Data.Preprocessed';
            DownsampledSampleRate = PreProInfo.DownsampledSampleRate;
            % Create new time vector for downsampled data
            Data.TimeDownsampled = double(0:(1/DownsampledSampleRate):(size(Data.Preprocessed,2)-1)/DownsampledSampleRate);
        end

    elseif strcmp(PreprocessingSteps(PPSteps),"Normalize")

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            % Downsampling only works with matrixes cloumn
            % wise. Therefore it is transposed to Channel as
            % columns and then transposed back after
            % downsampling
            Data.Preprocessed = zscore(Data.Raw');
            Data.Preprocessed = Data.Preprocessed';
        else % If not first step in pipeline: apply to already preprocessed data
            % Downsampling only works with matrixes cloumn
            % wise. Therefore it is transposed to Channel as
            % columns and then transposed back after
            % downsampling
            Data.Preprocessed = zscore(Data.Preprocessed');
            Data.Preprocessed = Data.Preprocessed';
        end
        
    elseif strcmp(PreprocessingSteps(PPSteps),"GrandAverage")

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            Data.Preprocessed = bsxfun(@minus,Data.Raw,mean(Data.Raw,1));
        else % If not first step in pipeline: apply to already preprocessed data
            Data.Preprocessed = bsxfun(@minus,Data.Preprocessed,mean(Data.Preprocessed,1));
        end

    elseif strcmp(PreprocessingSteps(PPSteps),"ChannelDeletion")
        
        [Data] = Preprocess_Module_ChannelDeletion(Data,ChannelDeletion);

    elseif strcmp(PreprocessingSteps(PPSteps),"CutStart")
       
        [Data] = Preprocessing_Module_Cut_Time(Data,"CutStart",PreProInfo.CutStart,PreprocessingSteps,PPSteps);
        
    elseif strcmp(PreprocessingSteps(PPSteps),"CutEnd")
          
        [Data] = Preprocessing_Module_Cut_Time(Data,"CutEnd",PreProInfo.CutEnd,PreprocessingSteps,PPSteps);

    end 
end

if ~isempty(h)
    close(h);
end

%% Plot Examples
if PlotExample == 1
    % Plotting
    figure();
    hold( 'on' );
    
    % When downsampled data: different time vector!
    if strcmp(PreprocessingSteps,"Downsampling")
        TimeToPlot = Data.Time <= 0.07;
        TimeDSToPlot = TimeDownsampled <= 0.07;
        plot(Data.Time(TimeToPlot == 1),Data.Raw(1,TimeToPlot == 1),'LineWidth',2,'Color','b');
        plot(TimeDownsampled(TimeDSToPlot == 1),Data.Preprocessed(1,TimeDSToPlot == 1),'LineWidth',2,'Color','r');
    else
        plot(Data.Time(1:5000),Data.Raw(1,1:5000),'LineWidth',2,'Color','b');
        plot(Data.Time(1:5000),Data.Preprocessed(1,1:5000),'LineWidth',2,'Color','r');
    end
    
    legend("Original Signal","Filtered Signal")
    xlabel('Time [s]');
    ylabel('Signal [mV]');
    titlestring = "Original vs. filtered Signal Channel 1";
    title(titlestring);
    drawnow;
    hold( 'off' );
end

%% Aftermath
% Combine the structures of recording info and preprocessing info to add the newly executed preprocessing steps and parameter to the Mainapp Data structure
TempInfo = Data.Info;
Data.Info = [];

% Add fields from the first structure
fieldsStruct1 = fieldnames(TempInfo);
for i = 1:numel(fieldsStruct1)
    Data.Info.(fieldsStruct1{i}) = TempInfo.(fieldsStruct1{i});
end

% Add fields from the second structure
fieldsStruct2 = fieldnames(PreProInfo);
for i = 1:numel(fieldsStruct2)
    if ~strcmp(fieldsStruct2{i},"ChannelDeletion") && ~strcmp(fieldsStruct2{i},"CutStart") && ~strcmp(fieldsStruct2{i},"CutEnd")
        Data.Info.(fieldsStruct2{i}) = PreProInfo.(fieldsStruct2{i});
    end
end

%% If event data extracted based on preprocesssed data, extract again
nrindependentsteps = 0;
ExtractEventDataAgaian = 1;

for i = 1:length(PreprocessingSteps)
    if strcmp(PreprocessingSteps(i),'CutStart')
        nrindependentsteps = nrindependentsteps+1;
    end
    if strcmp(PreprocessingSteps(i),'CutEnd')
        nrindependentsteps = nrindependentsteps+1;
    end
    if strcmp(PreprocessingSteps(i),'ChannelDeletion')
        nrindependentsteps = nrindependentsteps+1;
    end
end

if nrindependentsteps ~= 0 && nrindependentsteps==numel(PreprocessingSteps)
    ExtractEventDataAgaian = 0;
end

if isfield(Data,'EventRelatedData') && ExtractEventDataAgaian == 1
    if strcmp(Data.Info.EventRelatedDataType,'Preprocessed') 
        msgbox("Warning: Event Related Data was extracted based on preprocesssed data and is extracted again");
        spaceindicie = find(Data.Info.EventRelatedDataTimeRange == ' ');
        Timebefore = Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1));
        Timeafter = Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end);
        [Data,TimearoundEvent] = Event_Module_Extract_Event_Related_Data(Data,Data.Info.EventRelatedDataChannel,Timebefore,Timeafter,Data.Info.EventRelatedDataType);
    end
end

if isfield(Data,'PreprocessedEventRelatedData') && ExtractEventDataAgaian == 1
    fieldsToDelete = {'PreprocessedEventRelatedData'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
    msgbox("Warning: Preprocessed Event Related Data had to be deleted and has to be extracted again");
end




