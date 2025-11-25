function [Data,mnLFP,CurrentPlotData] = Spike_Module_Spike_Triggered_Average(Data,SpikeTimes,SpikePositions,Figure,ChannelSelection,appWindow,TextArea,TimeWindowSpiketriggredLFP,Plot,TwoORThreeD,ClustertoShow,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations)

%________________________________________________________________________________________
%% Function to prepare and execute spike triggered average analysis
% This function organizes inputs, checks for proper filtering of data (low pass and downsampled)
% and calls the functions to calculate and plot the Spike triggered average

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. SpikeTimes: nspikes x 1 with spike times in samples
% 3. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 4. Figure: handle to plot object to plot in 
% 5. ChannelSelection: 1x2 channelselcteion [from, to], i.e [1,10] for
% channel 1 to 10
% 6. appWindow: string, "Continous" or "Events", depending what module is
% executing this function
% 7. TextArea: text area object of window to plot nr of spikes and cluster
% in
% 8. TimeWindowSpiketriggredLFP: 1x2 double with time window to extract STA
% from
% 8. Plot: double, 1 to plot data, 0 if only computation required
% 9. TwoORThreeD: either "TwoD" or "ThreeD" for 2d or 3d plot
% 10. ClustertoShow: char, contains the unit selection the user
% makes, Either "All" OR "Non" OR "1" or whatever over unit number
% 11. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 12.PreservePlotChannelLocations: double, 1 or 0 whether to preserve
% original spacing between active channel (in case of inactiove islands between active channel)

% Outputs
% 1. Data: data structure from the main window holding spike data
% 2. mnLFP: ndepth x ntime field triggered average
% 3. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


%% Check what data is available -- has to be low pass filtered and downsampled
% - but still leave it to the user by just giving a warning and option to
% low pass filter and downsample directly here

SaveFilter = "No";
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

if LowPass == 0 && Downsampled == 0
    LowPassFilterSettings = [];
    Spike_Extraction_LowPassWindow = SpikeTrgAvgAskPrepro(LowPassFilterSettings);
    
    uiwait(Spike_Extraction_LowPassWindow.PreproSTLFPWindowUIFigure);
    
    if isvalid(Spike_Extraction_LowPassWindow)
        Cutoff = Spike_Extraction_LowPassWindow.LowPassFilterSettings.Cutoff;
        FilterOrder = Spike_Extraction_LowPassWindow.LowPassFilterSettings.FilterOrder;
        SaveFilter = Spike_Extraction_LowPassWindow.LowPassFilterSettings.SaveFilter;
        delete(Spike_Extraction_LowPassWindow);
    else
        msgbox("Preprocessing canceled. Spike triggered LFP not computed.")
        mnLFP = [];
        CurrentPlotData = [];
        return;
    end

    PreproInfo = [];
    PreprocessingSteps = [];

    Methods = ["Filter","Downsample"];
    for i = 1:2
        [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods(i),PreproInfo,PreprocessingSteps,0,"Low-Pass","Butterworth IR",Cutoff,"Zero-phase forward and reverse",FilterOrder,"1000",Data.Info.NativeSamplingRate);
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
            [mnLFP,CurrentPlotData] = spikeTrigLFP(Data, Data.Time, Data.Preprocessed(ChannelSelection,:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.NativeSamplingRate,TextArea,Data.Info.ChannelSpacing,appWindow,Plot,TwoORThreeD,ClustertoShow,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations);
        else
            winAroundSpike = TimeWindowSpiketriggredLFP(1) : (1/Data.Info.DownsampledSampleRate) : TimeWindowSpiketriggredLFP(2);
            [mnLFP,CurrentPlotData] = spikeTrigLFP(Data,Data.TimeDownsampled, Data.Preprocessed(ChannelSelection,:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.DownsampledSampleRate,TextArea,Data.Info.ChannelSpacing,appWindow,Plot,TwoORThreeD,ClustertoShow,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations);
        end
    else
        winAroundSpike = TimeWindowSpiketriggredLFP(1) : (1/Data.Info.NativeSamplingRate) : TimeWindowSpiketriggredLFP(2);
        [mnLFP,CurrentPlotData] = spikeTrigLFP(Data,Data.Time, Data.Raw(ChannelSelection,:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.NativeSamplingRate,TextArea,Data.Info.ChannelSpacing,appWindow,Plot,TwoORThreeD,ClustertoShow,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations);
    end
else
    winAroundSpike = TimeWindowSpiketriggredLFP(1) : (1/Data.Info.NativeSamplingRate) : TimeWindowSpiketriggredLFP(2);
    [mnLFP,CurrentPlotData] = spikeTrigLFP(Data,Data.Time, Data.Raw(ChannelSelection,:), SpikeTimes, SpikePositions, ChannelSelection, winAroundSpike, Figure,Data.Info.NativeSamplingRate,TextArea,Data.Info.ChannelSpacing,appWindow,Plot,TwoORThreeD,ClustertoShow,CurrentPlotData,PlotAppearance,PreservePlotChannelLocations);
end

%% Determine whether new prepro data is saved for main dataset
if strcmp(SaveFilter,"No")
    Data = [];
end


