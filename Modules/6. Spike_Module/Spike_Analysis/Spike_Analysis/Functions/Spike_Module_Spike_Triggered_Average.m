function [Data,mnLFP] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,ChannelSelection,appWindow,TextArea,TimeWindowSpiketriggredLFP,Plot,TwoORThreeD)

%% Check what data is available -- has to be low pass filtered and downsampled
% - but still leave it to the user by just giving a warning and option to
% low pass filter and downsample directly here

DatatoUse = 'Raw';
Downsampled = 0;
LowPass = 0;

if ~isfield(Data,'Preprocessed')
    %msgbox("Warning! No low pass filtered data found. Execution can take very long");
    DatatoUse = 'Raw';
else
    if ~isfield(Data.Info,'FilterMethod')
        %msgbox("Warning! No low pass filtered data found. Execution can take very long");
        DatatoUse = 'Raw';
    else
        if ~strcmp(Data.Info.FilterMethod,'Low-Pass')
            %msgbox("Warning! Data was filtered, but NOT low pass filtered. Results can be weird and execution can take very long");
            DatatoUse = 'Raw';
        else
            DatatoUse = 'Preprocessed';
            LowPass = 1;
            if ~isfield(Data.Info,'DownsampleFactor')
                %msgbox("Data was not downsampled. Execution can take very long");
                DatatoUse = 'Preprocessed';
            else
                Downsampled = 1;
            end
        end
    end
end

%% if no low pass and/or not downsampled open window to ask user to do it automatically
UserOptions = [];
if LowPass == 0 || Downsampled == 0
    PreproSpikeAverageWindow = SpikeTrgAvgAskPrepro(DatatoUse,Downsampled,LowPass);
    
    uiwait(PreproSpikeAverageWindow.SpikeTrgAvgPreproUIFigure);
    
    if isvalid(PreproSpikeAverageWindow)
        UserOptions = PreproSpikeAverageWindow.SpiketrgAvgPrepro;
    else
        return;
    end
    
    delete(PreproSpikeAverageWindow);

    %% Apply Preprocessing when user selected it
    if UserOptions.LowPass + UserOptions.Downsample >= 1
        PreproInfo = [];
        PreprocessingSteps = [];
        % if user just selects downsampling: also has to be low pass filtered
        % to avoid aliasing
        if UserOptions.LowPass == 0 && UserOptions.Downsample == 1
            msgbox("Warning: Low Pass filtering is required to avoid aliasing and will be computed regardless!");
        end
    
        if UserOptions.LowPass == 1 && UserOptions.Downsample == 1 || UserOptions.LowPass == 0 && UserOptions.Downsample == 1
            Methods = ["Filter","Downsample"];
            for i = 1:2
                [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods(i),PreproInfo,PreprocessingSteps,0,"Low-Pass","Butterworth IR","220","Zero-phase forward and reverse","3","1000",Data.Info.NativeSamplingRate);
            end
        elseif UserOptions.LowPass == 1 && UserOptions.Downsample == 0
            Methods = "Filter";
            [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods,PreproInfo,PreprocessingSteps,0,"Low-Pass","Butterworth IR","220","Zero-phase forward and reverse","3","1000",Data.Info.NativeSamplingRate);
        end
        
        if isempty(PreprocessingSteps)
            msgbox("Error: No pipeline components added");
            return;
        end
        
        if isfield(PreproInfo,'ChannelDeletion')
            ChannelDeletion = PreproInfo.ChannelDeletion;
        else
            ChannelDeletion = [];
        end
        
        TextArea = [];
        
        [Data,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
        
        [Data] = Preprocess_Module_Apply_Pipeline (Data,Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea);
    
    end

end % if prepro selected
%% Now check again what is available and ccan be computed 
DatatoUse = 'Raw';
Downsampled = 0;
LowPass = 0;

if ~isfield(Data,'Preprocessed')
    msgbox("Warning! No low pass filtered data found. Results can be weird and execution can take very long");
    DatatoUse = 'Raw';
else
    if ~isfield(Data.Info,'FilterMethod')
        msgbox("Warning! No low pass filtered data found. Results can be weird and execution can take very long");
        DatatoUse = 'Raw';
    else
        if ~strcmp(Data.Info.FilterMethod,'Low-Pass')
            msgbox("Warning! Data was filtered, but NOT low pass filtered. Results can be weird and execution can take very long");
            DatatoUse = 'Raw';
        else
            DatatoUse = 'Preprocessed';
            LowPass = 1;
            if ~isfield(Data.Info,'DownsampleFactor')
                msgbox("Data was not downsampled. Execution can take very long");
                DatatoUse = 'Preprocessed';
            else
                Downsampled = 1;
            end
        end
    end
end

%% Now finally compute the spiketriggeredaverage
if strcmp(DatatoUse,'Preprocessed')
    if ~isempty(Data.Preprocessed)
        if Downsampled == 0
            winAroundSpike = TimeWindowSpiketriggredLFP(1) : (1/Data.Info.NativeSamplingRate) : TimeWindowSpiketriggredLFP(2);
            mnLFP = spikeTrigLFP(Data.Time, Data.Preprocessed(ChannelSelection(1):ChannelSelection(2),:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.NativeSamplingRate,TextArea,Data.Info.ChannelSpacing,Data.Info.SpikeType,Plot,TwoORThreeD);
        else
            winAroundSpike = TimeWindowSpiketriggredLFP(1) : (1/Data.Info.DownsampledSampleRate) : TimeWindowSpiketriggredLFP(2);
            mnLFP = spikeTrigLFP(Data.TimeDownsampled, Data.Preprocessed(ChannelSelection(1):ChannelSelection(2),:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.DownsampledSampleRate,TextArea,Data.Info.ChannelSpacing,Data.Info.SpikeType,Plot,TwoORThreeD);
        end
    else
        winAroundSpike = TimeWindowSpiketriggredLFP(1) : (1/Data.Info.NativeSamplingRate) : TimeWindowSpiketriggredLFP(2);
        mnLFP = spikeTrigLFP(Data.Time, Data.Raw(ChannelSelection(1):ChannelSelection(2),:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.NativeSamplingRate,TextArea,Data.Info.ChannelSpacing,Data.Info.SpikeType,Plot,TwoORThreeD);
    end
else
    winAroundSpike = TimeWindowSpiketriggredLFP(1) : (1/Data.Info.NativeSamplingRate) : TimeWindowSpiketriggredLFP(2);
    mnLFP = spikeTrigLFP(Data.Time, Data.Raw(ChannelSelection(1):ChannelSelection(2),:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.NativeSamplingRate,TextArea,Data.Info.ChannelSpacing,Data.Info.SpikeType,Plot,TwoORThreeD);
end

%% Determine whether new prepro data is saved for main dataset
if ~isempty(UserOptions)
    if strcmp(UserOptions.SavePreproData,"No")
        Data = [];
    end
end

%________________________________________________________________________________________

%% Function to compute and plot spike rate over depth (as a Heatmap)
% This function takes all spikes and sorts for those in the event range
% every time, the window for event spike analysis is opened. It is saved as
% Data.EventRelatedSpikes structure, which gets overwritten every time

% This function gets called in the main window when the user clicks on run
% for event spike analysis (Internal and Kilosort)

% Input:
% 1. SpikeTimes: nspikes x 1 double in seconds. Spike time before event is
% negativ
% 2. SpikePositions: nspikes x 1 double with spike positions (in um) - for
% internal: channelnr * ChannelSpacing
% 3. Figure: Figure axes object to plot in
% 4. SR: SampleRate as double in Hz
% 5. time_bin_size: double, Bin size in seconds
% 6. depth_edges: edges of depth bins (in um)
% 7. time_edges: edges of depth bins (in s)
% 8. nevents: number of events to divide spike rate by to normalize for a
% single trial/event
% 9. eventtime: double, Time in seconds to plot event line at (default at 0s)
% 10. Normalize: 1 to basline normalized, 0 if not
% 11. NormWindow: 1x2 double with min and max of time range (in seconds with negativ possible)
% 12. Clustertoshow: char, 'Non' OR 'All' or a single number like '4' for
% unit 4
% 13. ClusterIdentity: nspikes x 1 double with unit identitiy for each spike
% 14. rgbMatrix: nunits x 3 double with rgb values 
% 15. ChannelsToPlot: 1 x 2 double with channel to plot, i.e. [1,10] for
% channel 1 to 10 
% 16. ChannelSpacing: in um from Data.Info.ChannelSpacing
% 17. appWindow: char, 'Kilosort' OR 'Internal' to see which window it
% comes from

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________