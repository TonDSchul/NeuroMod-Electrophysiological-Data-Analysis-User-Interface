function [GlobalYlim,texttoshow,CurrentPlotData] = Analyse_Main_Window_Inst_Freq_Main(DataToCompute,Time,Samplefrequency,Figure1,Figure3,Figure4,Figure5,Data,ChannelToCompare,Cutoff,NarrowbandOrder,ActiveChannel,DataTypeDropDown,PlotAppearance,GlobalYlim,LockYLIM,StartIndex,StopIndex,WhatToDo,ColorMap,Method,ForceFilterOFF,ECHTFilterorder,CurrentPlotData,EventData,SelectedEventIndice,EventPlot,ShowAnayzedData,LowPassSettings,FilterType)

%________________________________________________________________________________________

%% Main Function to compute almost all phase sync measure available in phase syn analysis window

% Inputs:

% 1. DataToCompute: nchannel x ntime matrix with the signal
% 2. Time: 1 x n time vector with time of curent signal (in respect to whole recording)
% 3. Samplefrequency: double, in Hz. Not from Data.Info bc it was
% autodetected before if data was downsampled
% 4. Figure1: app object handle to figure to plot in --> polar plot for phase
% angles on unit circle
% 5. Figure3: app object handle to figure to plot in --> All to ALl sync plot
% 6. Figure4 : app object handle to figure to plot in --> phase angle time
% series
% 7. Figure5: app object handle to figure to plot in --> Amplitude
% envelope/data
% 8. Data: Main window data object
% 9. ChannelToCompare: 1 x 2 with both channel to compare in polar phase
% angle differences plot
% 10. Cutoff: narrowband cutoff for narrowbnad filter if it has to be
% applied (like for hilber transform), also used as cutoff for ecHT
% narrowband filter
% 11. NarrowbandOrder: double, order for barrowband filter
% 12. ActiveChannel: all currently active channel
% 13. DataTypeDropDown: either 'Raw Data' or 'Preprocessed Data' from live window data to extract from dropdown menu, 
% 14. PlotAppearance: structure holding information about plot appearances
% the user can select
% 15. GlobalYlim: double vector, highest ylim plotted since window was
% opened to lock ylim to biggest y value recorded
% 16. LockYLIM: either 1 or 0, if ylim should be locked to GlobalYlim
% 17. StartIndex: index of data (Data.Raw or Data.Preprocessed) at which
% currently anlyzed data snippet starts
% 18. StopIndex: index of data (Data.Raw or Data.Preprocessed) at which
% currently anlyzed data snippet ends
% 19. WhatToDo: char, what to compute, either 'All' OR 'Startup' OR
% 'AllToAllDifferences' OR 'AnglesEnvelops'
% 20. ColorMap: channel x 3 parula colormap
% 21. Method: Which method the user selcts to compute the phase angles,
% either "Endpoint Corrected Hilbert Transform" OR "Hilbert Transform" OR "Wavelet Convolution"
% 22. ForceFilterOFF: 1 or 0, whether to turn extra narrowband (for example
% for hilbert transform) on or off
% 23. ECHTFilterorder: double, filter order of narrowband for ecHT method
% 24. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 25. EventData: double vector with indices at which event trigger of the
% currently selected event channel happen (selected in main widnow) -->
% checks whether a trigger is within current window and plots the event
% time
% 26. SelectedEventIndice: indicie of event channel being selected in
% respect to cell array in Data.Info.EventChannelNames
% 27. EventPlot: char, either 'Events' to show event times within data
% plots or something else to not show it
% 28. ShowAnayzedData: either 1 or 0 whether to show amplitude envelops (0)
% or show data phase angle analysis is based on (1)
% 29. LowPassSettings: struc with fields: LowPassSettings.Cutoff, LowPassSettings.FilterOrder
% 30. FilterType: Narrowband filter type used, either 'Butter' OR 'FIR'

% Outputs:
% 1. GlobalYlim: double vector, highest ylim plotted since window was
% opened to lock ylim to biggest y value recorded --> if changed here, next
% time available
% 2. texttoshow: text to show filter infoes in of filter steps that where
% applied
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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
            if Data.Info.NativeSamplingRate>FsTarget
                DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
                DataToCompute = downsample(DataToCompute',DownsampleFactor)';
                Time = downsample(Time,DownsampleFactor);
                Samplefrequency = FsTarget;
                FlagActualDownsample = 1;
            else
                FlagActualDownsample = 0;
                Samplefrequency = Data.Info.NativeSamplingRate;
            end
            
            FlagActualLowPass = 1;
        elseif LowPassFlag == 1 && Downsampleflag == 0
            %downsample
            FsTarget = 1000;
            if Data.Info.NativeSamplingRate>FsTarget
                DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
                DataToCompute = downsample(DataToCompute',DownsampleFactor)';
                Time = downsample(Time,DownsampleFactor);
                Samplefrequency = FsTarget;
                FlagActualDownsample = 1;
            else
                Samplefrequency = Data.Info.NativeSamplingRate;
                FlagActualDownsample = 0;
            end
            
            
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
            if Data.Info.NativeSamplingRate>FsTarget
                DownsampleFactor = round(Data.Info.NativeSamplingRate/FsTarget);
                DataToCompute = downsample(DataToCompute',DownsampleFactor)';
                Time = downsample(Time,DownsampleFactor);
                Samplefrequency = FsTarget;
                FlagActualDownsample = 1;
            else
                Samplefrequency = Data.Info.NativeSamplingRate;
                FlagActualDownsample = 0;
            end
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