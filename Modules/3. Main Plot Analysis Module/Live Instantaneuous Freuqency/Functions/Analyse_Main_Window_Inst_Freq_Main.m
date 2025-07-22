function [GlobalYlim,texttoshow,CurrentPlotData] = Analyse_Main_Window_Inst_Freq_Main(DataToCompute,Time,Samplefrequency,Figure1,Figure3,Figure4,Figure5,Data,ChannelToCompare,Cutoff,NarrowbandOrder,ActiveChannel,DataTypeDropDown,PlotAppearance,GlobalYlim,LockYLIM,StartIndex,StopIndex,WhatToDo,ColorMap,Method,ForceFilterOFF,ECHTFilterorder,CurrentPlotData,EventData,SelectedEventIndice,EventPlot,ShowAnayzedData,LowPassSettings,FilterType)

%% ------------------------- Flag what was already computed ---------------------------
% detect already present filter and downsample step
NarrowBandPresent = 0;
Downsampleflag = 0;
LowPassFlag = 0;

texttoshow = [];

% Distinguish between downsampled data and normal data
if strcmp(DataTypeDropDown,'Raw Data')   
    NarrowBandPresent = 0;
    Downsampleflag = 0;
    LowPassFlag = 0;
elseif strcmp(DataTypeDropDown,'Preprocessed Data')
    if isfield(Data.Info,'DownsampleFactor')
        Downsampleflag = 1;
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
        
        if isfield(Data.Info,'NarrowbandFilterMethod')
            NarrowBandPresent = 1;
        end
        if isfield(Data.Info,'FilterMethod')
            if strcmp(Data.Info.FilterMethod,'Low-Pass')
                LowPassFlag = 1;
            end
        end
    end
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
            % low pass
            for nchannel = 1:size(DataToCompute,1)
                [DataToCompute(nchannel,:), ~, ~] = ft_preproc_lowpassfilter(double(DataToCompute(nchannel,:)), Data.Info.NativeSamplingRate, LowPassSettings.Cutoff, LowPassSettings.FilterOrder, 'but', 'twopass', 'no', [],'hamming', [], 'no', 'no');
            end
            %downsample
            FsTarget = 1000;
            DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
            DataToCompute = downsample(DataToCompute',DownsampleFactor)';
            Time = downsample(Time,DownsampleFactor);
            Samplefrequency = FsTarget;
            FlagActualDownsample = 1;
            FlagActualLowPass = 1;
        elseif LowPassFlag == 1 && Downsampleflag == 0
            %downsample
            FsTarget = 1000;
            DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
            DataToCompute = downsample(DataToCompute',DownsampleFactor)';
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
            DataToCompute = downsample(DataToCompute',DownsampleFactor)';
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
        
        if strcmp(FilterType,"Butter")
            [b, a] = butter(filterorder, Cutoff / nyquist, 'bandpass');

            % apply the filter to the data
            for nchannel = 1:size(DataToCompute,1)
                DataToCompute(nchannel,:) = filtfilt(b,a,double(DataToCompute(nchannel,:))); 
            end
            
        elseif strcmp(FilterType,"FIR")
            % filter kernel
            filtkern = fir1(filterorder,Cutoff/nyquist, 'bandpass');
        
            % apply the filter to the data
            for nchannel = 1:size(DataToCompute,1)
                DataToCompute(nchannel,:) = filtfilt(filtkern,1,double(DataToCompute(nchannel,:))); 
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

    [GlobalYlim,CurrentPlotData] = Analyse_Main_Window_Plot_PhaseAngles(Data,Figure4,Figure5,Phases,PhasesUnwrapped,Samplefrequency,Time,GlobalYlim,LockYLIM,ColorMap,Method,PlotAppearance,CurrentPlotData,EventData,SelectedEventIndice,EventPlot,ShowAnayzedData,DataToCompute(SelectedChannel,:));
end