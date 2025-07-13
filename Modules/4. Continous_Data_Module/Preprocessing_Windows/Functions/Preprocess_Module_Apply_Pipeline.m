function [Data] = Preprocess_Module_Apply_Pipeline (Data,SampleRate,PreprocessingSteps,PlotExample,PreProInfo,ChannelDeletion,TextObject)
%________________________________________________________________________________________

%% Function to Preprocess Data 
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

%% loop thorugh all strings in the string array holding the selcted pipeline. This means the code loops over all selected preprocessing steps
% Each time it checks what the string says. Based on this it
% accesses the saved preprocessing parameter (set in
% Preprocess_Construct_Pipeline function) and sets the
% filteroptions according to it. If Data.Info.Filtermethod =
% Butterworth IR, then the variable type is set to 'but' and
% passed into the preprocessing function 

TimeDownsampled = [];
h = [];

Inspectfilter = 0;
if isfield(PreProInfo,'FilterKernel')
    if PreProInfo.FilterKernel == 1
        Inspectfilter = 1;
    end
end

if PlotExample == 1 || Inspectfilter == 1
    if ~strcmp(PreprocessingSteps(1),"GrandAverage")
        Data.Raw = Data.Raw(round(size(Data.Raw,1)/2),:);
        Data.Time = Data.Time(1:Data.Info.NativeSamplingRate*10);
        if isfield(Data,'Preprocessed')
            Data.Preprocessed = Data.Preprocessed(round(size(Data.Raw,1)/2),:);
        end
    else
        Data.Raw = Data.Raw(:,1:round(size(Data.Raw,2)/2));
        Data.Time = Data.Time(1:Data.Info.NativeSamplingRate*10);
        if isfield(Data,'Preprocessed')
            Data.Preprocessed = Data.Preprocessed(:,1:round(size(Data.Raw,2)/2));
        end
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
        
        %% Get Filter options
        [type,dir,filterorder,wintype,df,Cutoff,~] = Preprocess_Module_Set_Filter_Parameter(PPSteps,PreprocessingSteps,PreProInfo);
        
        if Inspectfilter == 1
            A = 0;
            B = 0;
            NonNan = [];
            %% Inspect filter
            Preprocess_Module_Inspect_Filter(Data,PreProInfo,PreprocessingSteps,PPSteps,SampleRate,A,B,Cutoff,filterorder,NonNan);
            if ~isempty(h)
                close(h);
            end
            return;
        end

        %% Apply Preprocessing functions to dataset
        if strcmp(PreprocessingSteps(PPSteps),"Low-Pass") 
            h = waitbar(0, 'Applying Filter...', 'Name','Low Pass Filtering...');
            % If first preprocessing step: Apply to raw data.
            % The seconf preprocessing step however has top be
            % applied to the already preprocessed dataset,
            % otherwise earlier preprocessing is overwritten
            if PPSteps == 1 % If first step in pipeline: apply to raw data
                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    NonNan = ~isnan(Data.Raw(channelnr,:));
                    msg = sprintf('Low Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);

                    [Data.Preprocessed(channelnr,NonNan), B, A] = ft_preproc_lowpassfilter(double(Data.Raw(channelnr,NonNan)), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            else % If not first step in pipeline: apply to already preprocessed data
                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    NonNan = ~isnan(Data.Preprocessed(channelnr,:));
                    msg = sprintf('Low Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
   
                    [Data.Preprocessed(channelnr,NonNan), B, A] = ft_preproc_lowpassfilter(double(Data.Preprocessed(channelnr,NonNan)), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            end
            
            close(h);

        elseif strcmp(PreprocessingSteps(PPSteps),"High-Pass")
            h = waitbar(0, 'Applying Filter...', 'Name','High-Pass Filtering...');
            if PPSteps == 1 % If first step in pipeline: apply to raw data
                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    NonNan = ~isnan(Data.Raw(channelnr,:));
                    msg = sprintf('High Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);

                    [Data.Preprocessed(channelnr,NonNan), B,A] = ft_preproc_highpassfilter(double(Data.Raw(channelnr,NonNan)), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            else % If not first step in pipeline: apply to already preprocessed data
                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    NonNan = ~isnan(Data.Preprocessed(channelnr,:));
                    msg = sprintf('High Pass Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);

                    [Data.Preprocessed(channelnr,NonNan), B, A] = ft_preproc_highpassfilter(double(Data.Preprocessed(channelnr,NonNan)), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            end
            close(h);
        elseif strcmp(PreprocessingSteps(PPSteps),"Narrowband")
            h = waitbar(0, 'Applying Filter...', 'Name','Narrowband Filtering...');
            if PPSteps == 1 % If first step in pipeline: apply to raw data
                % filter parameters
                nyquist = Data.Info.NativeSamplingRate/2;
                
                if strcmp(PreProInfo.NarrowbandFilterType,"Butterworth IR")
                    Wn = Cutoff / nyquist;  % Normalized cutoff
                    [b, a] = butter(filterorder, Wn, 'bandpass');
                else
                    % filter kernel
                    filtkern = fir1(filterorder,Cutoff/nyquist, 'bandpass');
                end

                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    NonNan = ~isnan(Data.Raw(channelnr,:));
                    msg = sprintf('Narrowband Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);

                    if strcmp(PreProInfo.NarrowbandFilterType,"Butterworth IR")
                        Data.Preprocessed(channelnr,NonNan) = filtfilt(b, a, double(Data.Raw(channelnr,NonNan)));
                    else
                    % apply the filter to the data
                        Data.Preprocessed(channelnr,NonNan) = filtfilt(filtkern,1,double(Data.Raw(channelnr,NonNan)));
                    end
                end
            else % If not first step in pipeline: apply to already preprocessed data
                if ~isempty(find(PreprocessingSteps(1:PPSteps)=='Downsampling')) % downsampling already applied
                    % filter parameters
                    nyquist = DownsampledSampleRate/2;
                else
                    % filter parameters
                    nyquist = Data.Info.NativeSamplingRate/2;
                end
                
                if strcmp(PreProInfo.NarrowbandFilterType,"Butterworth IR")
                    Wn = Cutoff / nyquist;  % Normalized cutoff
                    [b, a] = butter(filterorder, Wn, 'bandpass');
                else
                    % filter kernel
                    filtkern = fir1(filterorder,Cutoff/nyquist, 'bandpass');
                end

                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    NonNan = ~isnan(Data.Preprocessed(channelnr,:));
                    msg = sprintf('Narrowband Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);

                    % apply the filter to the data
                    if strcmp(PreProInfo.NarrowbandFilterType,"Butterworth IR")
                        Data.Preprocessed(channelnr,NonNan) = filtfilt(b, a, double(Data.Preprocessed(channelnr,NonNan)));
                    else
                        Data.Preprocessed(channelnr,NonNan) = filtfilt(filtkern,1,double(Data.Preprocessed(channelnr,NonNan)));
                    end
                end
            end

            close(h);

        elseif strcmp(PreprocessingSteps(PPSteps),"Band-Stop")
            h = waitbar(0, 'Applying Filter...', 'Name','Band-Stop Filtering...');
            if PPSteps == 1 % If first step in pipeline: apply to raw data
                Data.Preprocessed = single(zeros(size(Data.Raw)));
                cN = size(Data.Raw,1);
                for channelnr = 1:size(Data.Raw,1)
                    NonNan = ~isnan(Data.Raw(channelnr,:));
                    msg = sprintf('Band-Stop Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,NonNan), ~, ~] = ft_preproc_bandstopfilter(double(Data.Raw(channelnr,NonNan)), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            else % If not first step in pipeline: apply to already preprocessed data
                cN = size(Data.Preprocessed,1);
                for channelnr = 1:size(Data.Preprocessed,1)
                    NonNan = ~isnan(Data.Preprocessed(channelnr,:));
                    msg = sprintf('Band-Stop Filtering... (%d%% done)', round(100*(channelnr/cN)));
                    waitbar(channelnr/cN, h, msg);
                    [Data.Preprocessed(channelnr,NonNan), ~, ~] = ft_preproc_bandstopfilter(double(Data.Preprocessed(channelnr,NonNan)), SampleRate, Cutoff, filterorder, type, dir, 'no', [],wintype, [], 'no', 'no');
                end
            end
            close(h);
        end

        clear NonNan

    elseif strcmp(PreprocessingSteps(PPSteps),"Median Filter")
        h = waitbar(0, 'Applying Filter...', 'Name','Median Filtering...');
        if PPSteps == 1 % If first step in pipeline: apply to raw data
            NonNan = ~isnan(Data.Raw);
            TempRaw = zeros(size(Data.Raw));
            for nchannel = 1:size(Data.Raw,1)
                TempRaw(nchannel,1:sum(NonNan(nchannel,:))) = double(Data.Raw(nchannel,NonNan(nchannel,:)));
            end
        else
            NonNan = ~isnan(Data.Preprocessed);
            TempPreprocessed = zeros(size(Data.Preprocessed));
            for nchannel = 1:size(Data.Preprocessed,1)
                TempPreprocessed(nchannel,1:sum(NonNan(nchannel,:))) = double(Data.Preprocessed(nchannel,NonNan(nchannel,:)));
            end
        end
        

        %% Get Filter options
        [~,~,filterorder,~,~,~,~] = Preprocess_Module_Set_Filter_Parameter(PPSteps,PreprocessingSteps,PreProInfo);
        msg = sprintf('Median Filtering... (%d%% done)', round(100*(1/2)));
        waitbar(1/2, h, msg);

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            [Data.Preprocessed] = ft_preproc_medianfilter(TempRaw, filterorder);
        else % If not first step in pipeline: apply to already preprocessed data
            [Data.Preprocessed] = ft_preproc_medianfilter(TempPreprocessed, filterorder);
        end

        msg = sprintf('Median Filtering... (%d%% done)', round(100*(2/2)));
        waitbar(2/2, h, msg);

        clear TempPreprocessed TempRaw NonNan
        close(h);
    elseif strcmp(PreprocessingSteps(PPSteps),"Resampling")
        h2 = waitbar(0, 'Resampling...', 'Name','Preprocessing...');
        %% Get Filter options
        
        msg = sprintf('Resampling... (%d%% done)', 0);
        waitbar(0, h2, msg);

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            FsOriginal = Data.Info.NativeSamplingRate; % <-- Replace with your actual sampling rate
            FsTarget = PreProInfo.ResamplingFrequency;
            
            [p, q] = rat(FsTarget / FsOriginal); % Rational approximation for resampling

            % Preallocate
            [nChannels, ~] = size(Data.Raw);
            Data.Preprocessed = zeros(nChannels, ceil(size(Data.Raw,2) * FsTarget / FsOriginal));
            
            % Resample each channel
            for ch = 1:nChannels
                Data.Preprocessed(ch, :) = resample(double(Data.Raw(ch, :)), p, q);

                progress = (ch/nChannels)*100;
                msg = sprintf('Downsampling... (%d%% done)', round(progress));
                waitbar(round(progress), h2, msg);
            end
        else
            
            FsOriginal = Data.Info.NativeSamplingRate; % <-- Replace with your actual sampling rate
            FsTarget = PreProInfo.ResamplingFrequency;

            [p, q] = rat(FsTarget / FsOriginal); % Rational approximation for resampling

            % Preallocate
            [nChannels, ~] = size(Data.Preprocessed);
            DataResampled = zeros(nChannels, ceil(size(Data.Preprocessed,2) * FsTarget / FsOriginal));
            
            % Resample each channel
            for ch = 1:nChannels
                DataResampled(ch, :) = resample(double(Data.Preprocessed(ch, :)), p, q);
                progress = (ch/nChannels)*100;
                msg = sprintf('Downsampling... (%d%% done)', round(progress));
                waitbar(round(progress), h2, msg);
            end

            Data.Preprocessed = DataResampled;
            clear DataResampled
        end
        
        close(h2);
        
        Data.TimeDownsampled = double(0:(1/PreProInfo.ResamplingFrequency):(size(Data.Preprocessed,2)-1)/PreProInfo.ResamplingFrequency);

        PreProInfo.DownsampledSampleRate = PreProInfo.ResamplingFrequency;
        PreProInfo.DownsampleFactor =  FsOriginal/FsTarget; 
        
    elseif strcmp(PreprocessingSteps(PPSteps),"Downsampling")

        h2 = waitbar(0, 'Downsampling...', 'Name','Preprocessing...');
        %% Get Filter options
        [~,~,~,~,~,~,DownsampleFactor] = Preprocess_Module_Set_Filter_Parameter(PPSteps,PreprocessingSteps,PreProInfo);
        msg = sprintf('Downsampling... (%d%% done)', round(100*(1/4)));
        waitbar(1/4, h2, msg);
        %DownsampleFactor = round(Data.Info.NativeSamplingRate/DownsampleRate);
        
        if PPSteps == 1 % If first step in pipeline: apply to raw data
            % Downsampling only works with matrixes cloumn
            % wise. Therefore it is transposed to Channel as
            % columns and then transposed back after
            % downsampling
            msg = sprintf('Downsampling... (%d%% done)', round(100*(2/4)));
            waitbar(2/4, h2, msg);
            Data.Preprocessed = downsample(Data.Raw', DownsampleFactor);
            msg = sprintf('Downsampling... (%d%% done)', round(100*(3/4)));
            waitbar(3/4, h2, msg);
            Data.Preprocessed = Data.Preprocessed';
            DownsampledSampleRate = PreProInfo.DownsampledSampleRate;
            % Create new time vector for downsampled data
            Data.TimeDownsampled = double(0:(1/DownsampledSampleRate):(size(Data.Preprocessed,2)-1)/DownsampledSampleRate);
            msg = sprintf('Downsampling... (%d%% done)', round(100*(4/4)));
            waitbar(4/4, h2, msg);
        else % If not first step in pipeline: apply to already preprocessed data
            Data.Preprocessed = downsample(Data.Preprocessed', DownsampleFactor);
            msg = sprintf('Downsampling... (%d%% done)', round(100*(2/4)));
            waitbar(2/4, h2, msg);
            Data.Preprocessed = Data.Preprocessed';
            DownsampledSampleRate = PreProInfo.DownsampledSampleRate;
            msg = sprintf('Downsampling... (%d%% done)', round(100*(3/4)));
            waitbar(3/4, h2, msg);
            % Create new time vector for downsampled data
            Data.TimeDownsampled = double(0:(1/DownsampledSampleRate):(size(Data.Preprocessed,2)-1)/DownsampledSampleRate);
            msg = sprintf('Downsampling... (%d%% done)', round(100*(4/4)));
            waitbar(4/4, h2, msg);
        end

        close(h2);


    elseif strcmp(PreprocessingSteps(PPSteps),"ASR")
        if PPSteps == 1 % If first step in pipeline: apply to raw data
            [cleanData] = Utility_Translate_Into_EEGLAB_struc(Data.Raw,PPSteps,Data,0,PreProInfo);
        else % recognize already applied downsampling
            if ~isempty(find(PreprocessingSteps == "Downsampling"))
                if find(PreprocessingSteps == "Downsampling")<PPSteps
                    [cleanData] = Utility_Translate_Into_EEGLAB_struc(Data.Preprocessed,PPSteps,Data,1,PreProInfo);
                else
                    [cleanData] = Utility_Translate_Into_EEGLAB_struc(Data.Preprocessed,PPSteps,Data,0,PreProInfo);
                end
            else
                [cleanData] = Utility_Translate_Into_EEGLAB_struc(Data.Preprocessed,PPSteps,Data,0,PreProInfo);
            end
        end

        Data.Preprocessed = cleanData;
        clear cleanData;

    elseif strcmp(PreprocessingSteps(PPSteps),"Normalize")
        
        if PPSteps == 1 % If first step in pipeline: apply to raw data
            % Downsampling only works with matrixes cloumn
            % wise. Therefore it is transposed to Channel as
            % columns and then transposed back after
            % downsampling
            Data.Preprocessed = zscore(double(Data.Raw'));
            Data.Preprocessed = Data.Preprocessed';
        else % If not first step in pipeline: apply to already preprocessed data
            % Downsampling only works with matrixes cloumn
            % wise. Therefore it is transposed to Channel as
            % columns and then transposed back after
            % downsampling
            Data.Preprocessed = zscore(double(Data.Preprocessed'));
            Data.Preprocessed = Data.Preprocessed';
        end
        
    elseif strcmp(PreprocessingSteps(PPSteps),"GrandAverage")

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            Data.Preprocessed = bsxfun(@minus,Data.Raw,mean(Data.Raw,1,'omitnan'));
        else % If not first step in pipeline: apply to already preprocessed data
            Data.Preprocessed = bsxfun(@minus,Data.Preprocessed,mean(Data.Preprocessed,1,'omitnan'));
        end

    elseif strcmp(PreprocessingSteps(PPSteps),"Stimulation Artefact Rejection")

        if PPSteps == 1 % If first step in pipeline: apply to raw data
            Data.Preprocessed = Preprocess_ApplyStimArtefactRejection(Data.Raw,Data.Info,Data.Events,PreProInfo);
        else % If not first step in pipeline: apply to already preprocessed data
            Data.Preprocessed = Preprocess_ApplyStimArtefactRejection(Data.Preprocessed,Data.Info,Data.Events,PreProInfo);
        end

    elseif strcmp(PreprocessingSteps(PPSteps),"ChannelDeletion")
        
        [Data] = Preprocess_Module_ChannelDeletion(Data,ChannelDeletion);

    elseif strcmp(PreprocessingSteps(PPSteps),"CutStart")
       
        [Data] = Preprocessing_Module_Cut_Time(Data,"CutStart",PreProInfo.CutStart,PreprocessingSteps,PPSteps);
        
    elseif strcmp(PreprocessingSteps(PPSteps),"CutEnd")
          
        [Data] = Preprocessing_Module_Cut_Time(Data,"CutEnd",PreProInfo.CutEnd,PreprocessingSteps,PPSteps);

    end 
end

%% Plot Examples
if PlotExample == 1 && Inspectfilter == 0
    % Plotting
    figure();
    hold( 'on' );
    
    ChannelToPlot = round(size(Data.Raw,1)/2);

    % When downsampled data: different time vector!
    if strcmp(PreprocessingSteps,"Downsampling")
        TimeToPlot = Data.Time <= 1;
        TimeDSToPlot = Data.TimeDownsampled <= 1;
        plot(Data.Time(TimeToPlot == 1),Data.Raw(ChannelToPlot,TimeToPlot == 1),'LineWidth',1.5,'Color',[0, 0.4470, 0.7410]);
        plot(Data.TimeDownsampled(TimeDSToPlot == 1),Data.Preprocessed(ChannelToPlot,TimeDSToPlot == 1),'LineWidth',1,'Color',[0.8500, 0.3250, 0.0980]);
    else
        plot(Data.Time(1:Data.Info.NativeSamplingRate),Data.Raw(ChannelToPlot,1:Data.Info.NativeSamplingRate),'LineWidth',1,'Color',[0, 0.4470, 0.7410]);
        plot(Data.Time(1:Data.Info.NativeSamplingRate),Data.Preprocessed(ChannelToPlot,1:Data.Info.NativeSamplingRate),'LineWidth',1.,'Color',[0.8500, 0.3250, 0.0980]);
    end
    
    legend("Original Signal","Filtered Signal")
    xlabel('Time [s]');
    ylabel('Signal [mV]');
    titlestring = strcat("Channel ",num2str(ChannelToPlot)," Original vs. filtered Signal");
    title(titlestring);
    ax = gca;              % Get current axes
    ax.FontSize = 9;      % Set font size for the tick labels
    drawnow;
    hold( 'off' );
    return;
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






