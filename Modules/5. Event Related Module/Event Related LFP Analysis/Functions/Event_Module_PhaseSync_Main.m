function [texttoshow,CurrentPlotData] = Event_Module_PhaseSync_Main(DataToCompute,Time,Figure1,Figure3,Figure4,Figure5,Data,ChannelToCompare,Cutoff,NarrowbandOrder,ActiveChannel,DataTypeDropDown,PlotAppearance,ColorMap,Method,ForceFilterOFF,ECHTFilterorder,CurrentPlotData,WhatToDo,BasedOnERP,ShowAnalyzedData,DataTypeSelected,LowPassSettings,FilterType)


if BasedOnERP
    DataToCompute = squeeze(mean(DataToCompute,2));
end

%% ------------------------- Flag what was already computed ---------------------------
% detect already present filter and downsample step
NarrowBandPresent = 0;
Downsampleflag = 0;
LowPassFlag = 0;

texttoshow = [];

% Distinguish between downsampled data and normal data
if strcmp(DataTypeSelected,'Preprocessed Data')
    if isfield(Data.Info,'DownsampleFactor')
        Downsampleflag = 1;
        Samplefrequency = Data.Info.DownsampledSampleRate;
        if isfield(Data.Info,'NarrowbandFilterMethod')
            NarrowBandPresent = 1;
        end
        if isfield(Data.Info,'FilterMethod')
            if strcmp(Data.Info.FilterMethod,'Low-Pass')
                LowPassFlag = 1;
            end
        end
    else        
        Downsampleflag = 0;
        Samplefrequency = Data.Info.NativeSamplingRate;
        if isfield(Data.Info,'NarrowbandFilterMethod')
            NarrowBandPresent = 1;
        end
        if isfield(Data.Info,'FilterMethod')
            if strcmp(Data.Info.FilterMethod,'Low-Pass')
                LowPassFlag = 1;
            end
        end
    end
else
    Samplefrequency = Data.Info.NativeSamplingRate;
    NarrowBandPresent = 0;
    Downsampleflag = 0;
    LowPassFlag = 0;
end

%% ------------------------- Low Pass and Downsample if necessary ---------------------------
Cutoff = str2double(strsplit(Cutoff,','));
filterorder = str2double(NarrowbandOrder);

FlagActualDownsample = 0;
FlagActualLowPass = 0;
FlagActualBandpass = 0;

if ForceFilterOFF == 0
    if NarrowBandPresent == 0 
        if LowPassFlag == 0 && Downsampleflag == 0
            %% ------------------------- Low Pass ---------------------------
            if BasedOnERP
                for nchannel = 1:size(DataToCompute,1)
                    [DataToCompute(nchannel,:), ~, ~] = ft_preproc_lowpassfilter(squeeze(double(DataToCompute(nchannel,:))), Data.Info.NativeSamplingRate, LowPassSettings.Cutoff, LowPassSettings.FilterOrder, 'but', 'twopass', 'no', [],'hamming', [], 'no', 'no');
                end
            else
                for nchannel = 1:size(DataToCompute,1)
                    for ntrials = 1:size(DataToCompute,2)
                        [DataToCompute(nchannel,ntrials,:), ~, ~] = ft_preproc_lowpassfilter(squeeze(double(DataToCompute(nchannel,ntrials,:))), Data.Info.NativeSamplingRate, LowPassSettings.Cutoff, LowPassSettings.FilterOrder, 'but', 'twopass', 'no', [],'hamming', [], 'no', 'no');
                    end
                end
            end
            %% ------------------------- Downsample ---------------------------
            FsTarget = 1000;
            DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
            % dirty initialize
            if BasedOnERP
                a = downsample(squeeze(DataToCompute(1,:)),DownsampleFactor);
                TempDataToCompute = NaN(size(DataToCompute,1),length(a));
            else
                a = downsample(squeeze(DataToCompute(1,1,:))',DownsampleFactor);
                TempDataToCompute = NaN(size(DataToCompute,1),size(DataToCompute,2),length(a));
            end
            clear a
            % compute over channel
            for nchannel = 1:size(DataToCompute,1)
                if BasedOnERP
                    TempDataToCompute(nchannel,:) = downsample(DataToCompute(nchannel,:),DownsampleFactor);
                else
                    for ntrials = 1:size(DataToCompute,2)
                        TempDataToCompute(nchannel,ntrials,:) = downsample(squeeze(DataToCompute(nchannel,ntrials,:)),DownsampleFactor);
                    end
                end
            end
            DataToCompute = TempDataToCompute;
            clear TempDataToCompute;
            Time = downsample(Time,DownsampleFactor);
            Samplefrequency = FsTarget;
            FlagActualDownsample = 1;
            FlagActualLowPass = 1;
        elseif LowPassFlag == 1 && Downsampleflag == 0
            %downsample
            FsTarget = 1000;
            DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
            if BasedOnERP
                a = downsample(squeeze(DataToCompute(1,:)),DownsampleFactor);
                TempDataToCompute = NaN(size(DataToCompute,1),length(a));
            else
                a = downsample(squeeze(DataToCompute(1,1,:))',DownsampleFactor);
                TempDataToCompute = NaN(size(DataToCompute,1),size(DataToCompute,2),length(a));
            end
            clear a

            for nchannel = 1:size(DataToCompute,1)
                if BasedOnERP
                    TempDataToCompute(nchannel,:) = downsample(DataToCompute(nchannel,:),DownsampleFactor);
                else
                    for ntrials = 1:size(DataToCompute,2)
                        TempDataToCompute(nchannel,ntrials,:) = downsample(squeeze(DataToCompute(nchannel,ntrials,:)),DownsampleFactor);
                    end
                end
            end

            DataToCompute = TempDataToCompute;
            Time = downsample(Time,DownsampleFactor);
            Samplefrequency = FsTarget;
            FlagActualDownsample = 1;
        elseif LowPassFlag == 1 && Downsampleflag == 1
            Samplefrequency = Data.Info.DownsampledSampleRate;
        elseif LowPassFlag == 0 && Downsampleflag == 1
            disp('No Low pass applied to avoid aliasing bc data was already downsampled.')
            Samplefrequency = Data.Info.DownsampledSampleRate;
        end

    else
        if Downsampleflag == 0
            %downsample
            FsTarget = 1000;
            DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
            if BasedOnERP
                a = downsample(squeeze(DataToCompute(1,:)),DownsampleFactor);
                TempDataToCompute = NaN(size(DataToCompute,1),length(a));
            else
                a = downsample(squeeze(DataToCompute(1,1,:))',DownsampleFactor);
                TempDataToCompute = NaN(size(DataToCompute,1),size(DataToCompute,2),length(a));
            end
            clear a

            for nchannel = 1:size(DataToCompute,1)
                if BasedOnERP
                    TempDataToCompute(nchannel,:) = downsample(DataToCompute(nchannel,:),DownsampleFactor);
                else
                    for ntrials = 1:size(DataToCompute,2)
                        TempDataToCompute(nchannel,ntrials,:) = downsample(squeeze(DataToCompute(nchannel,ntrials,:)),DownsampleFactor);
                    end
                end
            end

            DataToCompute = TempDataToCompute;
            Time = downsample(Time,DownsampleFactor);
            Samplefrequency = FsTarget;
            FlagActualDownsample = 1;
        end
    end
    %% ------------------------- Narrowbandfilter if necessary ---------------------------
    if NarrowBandPresent == 0
        %% 1. Narrowband filter
        % filter parameters
        nyquist = Samplefrequency/2;
        
        if strcmp(FilterType,"FIR")
            % filter kernel
            filtkern = fir1(filterorder,Cutoff/nyquist, 'bandpass');
        elseif strcmp(FilterType,"Butter")
            % filter kernel
            [b, a] = butter(filterorder, Cutoff/nyquist, 'bandpass');
        end
    
        % apply the filter to the data
        for nchannel = 1:size(DataToCompute,1)
           if BasedOnERP
               if strcmp(FilterType,"FIR")
                    DataToCompute(nchannel,:) = filtfilt(filtkern,1,double(DataToCompute(nchannel,:))); 
               else
                    DataToCompute(nchannel,:) = filtfilt(b,a,double(DataToCompute(nchannel,:))); 
               end
           else
               if strcmp(FilterType,"FIR")
                    for ntrials = 1:size(DataToCompute,2)
                        DataToCompute(nchannel,ntrials,:) = filtfilt(filtkern,1,squeeze(double(DataToCompute(nchannel,ntrials,:)))); 
                    end
               else
                    for ntrials = 1:size(DataToCompute,2)
                        DataToCompute(nchannel,ntrials,:) = filtfilt(b,a,squeeze(double(DataToCompute(nchannel,ntrials,:)))); 
                    end
               end
           end
        end
        FlagActualBandpass = 1;
    end

end

%% ----------------------Populate Info Field with what was done--------------------------------------------------------

[texttoshow] = Analyse_Main_Window_Populate_Processing_Info(FlagActualDownsample,FlagActualLowPass,FlagActualBandpass,Samplefrequency,LowPassSettings);

%% ----------------------Channel Selection, Phase calculation--------------------------------------------------------

if Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
    TempActiveChannel = (str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows)+1)-sort(Data.Info.ProbeInfo.ActiveChannel);
    [SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(TempActiveChannel,ActiveChannel,'MainPlot');
else
    [SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainPlot');
end

if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"Startup") || strcmp(WhatToDo,"AllToAllDifferences") || strcmp(WhatToDo,"AnglesEnvelops")
    [Phases,PhasesUnwrapped] = Analyse_Main_Window_Hilbert_Echt_Wavelet(DataToCompute(SelectedChannel,:),Method,[],Samplefrequency,Cutoff,str2double(ECHTFilterorder));
elseif strcmp(WhatToDo,"ChannelChange") %% phases are calculated in the Phase Angle Differences Polar Plot section below
    SelectedChannel = [];
end

%% ----------------------All To All Sync Plot--------------------------------------------------------

if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"Startup") || strcmp(WhatToDo,"AllToAllDifferences")
    
    CurrentPlotData = Analyse_Main_Window_AllToAllSync(Figure3,Phases,PlotAppearance,CurrentPlotData,ActiveChannel);
end

%% ----------------------Phase Angle Differences Polar Plot--------------------------------------------------------

if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"ChannelChange") || strcmp(WhatToDo,"Startup") || strcmp(WhatToDo,"AllToAllDifferences")
    
    if isempty(SelectedChannel)
        [Channel1Data,~] = Analyse_Main_Window_Hilbert_Echt_Wavelet(DataToCompute(:,:),Method,ChannelToCompare(1),Samplefrequency,Cutoff,str2double(ECHTFilterorder));
    else
        if sum(SelectedChannel==ChannelToCompare(1))==0
            [Channel1Data,~] = Analyse_Main_Window_Hilbert_Echt_Wavelet(DataToCompute(:,:),Method,ChannelToCompare(1),Samplefrequency,Cutoff,str2double(ECHTFilterorder));
        else
            Indicies = find(SelectedChannel==ChannelToCompare(1));
            Channel1Data = Phases(Indicies,:);
        end
    end

    if isempty(SelectedChannel)
        [Channel2Data,~] = Analyse_Main_Window_Hilbert_Echt_Wavelet(DataToCompute(:,:),Method,ChannelToCompare(2),Samplefrequency,Cutoff,str2double(ECHTFilterorder));
    else
        if sum(SelectedChannel==ChannelToCompare(2))==0
            [Channel2Data,~] = Analyse_Main_Window_Hilbert_Echt_Wavelet(DataToCompute(:,:),Method,ChannelToCompare(2),Samplefrequency,Cutoff,str2double(ECHTFilterorder));
        else
            Indicies = find(SelectedChannel==ChannelToCompare(2));
            Channel2Data = Phases(Indicies,:);
        end
    end

    CurrentPlotData = Analyse_Main_Window_Phase_Angle_Differences_Polar(Channel1Data,Channel2Data,Figure1,Time,ChannelToCompare,PlotAppearance,CurrentPlotData);
end

%% ----------------------Phase Angle Time Series Plot--------------------------------------------------------

if strcmp(WhatToDo,"All") || strcmp(WhatToDo,"Startup") || strcmp(WhatToDo,"AnglesEnvelops")
    ColorMap = ColorMap(SelectedChannel,:);

    [~,CurrentPlotData] = Analyse_Main_Window_Plot_PhaseAngles(Data,Figure4,Figure5,Phases,PhasesUnwrapped,Samplefrequency,Time,[0,1],0,ColorMap,Method,PlotAppearance,CurrentPlotData,[],[],'Non',ShowAnalyzedData,DataToCompute(SelectedChannel,:));
end