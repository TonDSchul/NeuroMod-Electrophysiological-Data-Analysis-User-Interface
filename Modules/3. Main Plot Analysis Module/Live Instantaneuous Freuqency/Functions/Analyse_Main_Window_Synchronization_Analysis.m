function Analyse_Main_Window_Synchronization_Analysis(Figure1,Figure3,DataToCompute,Info,ChannelToCompare,Time,NarrowBandApplied,Cutoff,NarrowbandOrder,ActiveChannel,DataTypeDropDown,PlotAppearance)
    
    Cutoff = str2double(strsplit(Cutoff,','));
    Samplefrequency = Info.NativeSamplingRate;
    filterorder = str2double(NarrowbandOrder);
      
    Downsampleflag = 0;
    if isfield(Info,'DownsampledSampleRate') && strcmp(DataTypeDropDown,'Preprocessed Data')
        Downsampleflag = 1;
    end
    
    Resampleanyway = 0;
    if strcmp(DataTypeDropDown,'Raw Data')
        if NarrowBandApplied == 1 && Downsampleflag == 1
            Resampleanyway = 1;
        end
    end

    if NarrowBandApplied == 0 || Resampleanyway == 1
        if Downsampleflag == 0
            
            %% resample and narrowband filter
            if Info.NativeSamplingRate>1000
                %% 1. Low Pass and downsample
                % low pass only when not already applied
                if isfield(Info,'FilterMethod')
                    if ~strcmp(Info.FilterMethod,'Low-Pass')
                        for nchannel = 1:size(DataToCompute,1)
                            [DataToCompute(nchannel,:), ~, ~] = ft_preproc_lowpassfilter(double(DataToCompute(nchannel,:)), Info.NativeSamplingRate, 300, 4, 'but', 'twopass', 'no', [],'hamming', [], 'no', 'no');
                        end
                    end
                else
                    for nchannel = 1:size(DataToCompute,1)
                        [DataToCompute(nchannel,:), ~, ~] = ft_preproc_lowpassfilter(double(DataToCompute(nchannel,:)), Info.NativeSamplingRate, 300, 4, 'but', 'twopass', 'no', [],'hamming', [], 'no', 'no');
                    end
                end

                FsTarget = 1000;
                DownsampleFactor = round(Info.NativeSamplingRate/FsTarget);
                DataToCompute = downsample(DataToCompute',DownsampleFactor)';
                Time = downsample(Time,DownsampleFactor);
                Samplefrequency = FsTarget;
    
            end
            %% 1. Narrowband filter
            % filter parameters
            nyquist = Samplefrequency/2;
            
            % filter kernel
            filtkern = fir1(filterorder,Cutoff/nyquist, 'bandpass');
    
            % apply the filter to the data
            for nchannel = 1:size(DataToCompute,1)
                DataToCompute(nchannel,:) = filtfilt(filtkern,1,double(DataToCompute(nchannel,:))); 
            end
        else
            %% Take raw data and resample and narrowband filter
            
            Samplefrequency = Info.DownsampledSampleRate;
    
            %% 1. Narrowband filter
            % filter parameters
            nyquist = Samplefrequency/2;
            
            % filter kernel
            filtkern = fir1(filterorder,Cutoff/nyquist, 'bandpass');
    
            % apply the filter to the data
            for nchannel = 1:size(DataToCompute,1)
                DataToCompute(nchannel,:) = filtfilt(filtkern,1,double(DataToCompute(nchannel,:)));   
            end
    
        end
    else
        if Downsampleflag == 0
            %% just downsample
            if Info.NativeSamplingRate>1000
                DownsampleFactor = round(Info.NativeSamplingRate/1000);
                DataToCompute = downsample(DataToCompute,DownsampleFactor);
                Time = downsample(Time,DownsampleFactor);
                Samplefrequency = 1000;
            end
        else
            %% Do nothing
            Samplefrequency = Info.DownsampledSampleRate;
        end
    end 
    %% ------------------------------------------------------------------------------

    %% All To All Sync Plot

    if Info.ProbeInfo.SwitchTopBottomChannel == 1
        TempActiveChannel = (str2double(Info.ProbeInfo.NrChannel)*str2double(Info.ProbeInfo.NrRows)+1)-sort(Info.ProbeInfo.ActiveChannel);
        [SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(TempActiveChannel,ActiveChannel,'MainPlot');
    else
        [SelectedChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainPlot');
    end

    Analyse_Main_Window_AllToAllSync(Figure3,DataToCompute(SelectedChannel,:),PlotAppearance);
    
    %% Phase Angle Differences Polar Plot
    Channel1Data = DataToCompute(ChannelToCompare(1),:);
    Channel2Data = DataToCompute(ChannelToCompare(2),:);
    Analyse_Main_Window_Phase_Angle_Differences_Polar(Channel1Data,Channel2Data,Figure1,Time,ChannelToCompare,PlotAppearance)
    




    


    