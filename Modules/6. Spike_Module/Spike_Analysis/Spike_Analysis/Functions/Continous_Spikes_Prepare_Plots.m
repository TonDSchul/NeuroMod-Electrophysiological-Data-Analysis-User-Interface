function [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,ChannelPosition,PlotInfo,ChannelEditField,WaveformEditField,UnitsEditField,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField] = Continous_Spikes_Prepare_Plots(Data,ChannelEditField,WaveformEditField,UnitsEditField,DifferentInput,SpikeType,SpikeAnalysisType,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField,ExecuteInGUI,Eventstoshow)

%% Check GUI Information
if strcmp(SpikeType,"Kilosort")
    [ChannelEditField,WaveformEditField,UnitsEditField,Error,SpikeRateNumBinsEditField] = Continous_Kilosort_Spikes_Manage_Unit_Wavelet_ChannelInput(Data,DifferentInput,ChannelEditField,WaveformEditField,UnitsEditField,SpikeAnalysisType.Value,SpikeRateNumBinsEditField);
    
    % If some error in check functions: one of thoise variables with be a
    % string saying "Error"
    if Error
        if strcmp(SpikeAnalysisType.Value,"Waveforms from Raw Data")
            WaveformEditField.Enable = "on";
            ChannelEditField.Enable = "on";
            if strcmp(SpikeType,"Kilosort")
                UnitsEditField.Enable = "on";
            end
        end

        SpikeTimes = "Error";
        SpikePositions = [];
        SpikeAmps = [];
        CluterPositions = [];
        ChannelPosition = [];
        PlotInfo = [];
        return;
    end

end
if strcmp(SpikeType,"Internal")
    [ChannelEditField,WaveformEditField,SpikeRateNumBinsEditField] = Continous_Internal_Spikes_Check_Inputs(Data,ChannelEditField,WaveformEditField,SpikeRateNumBinsEditField);
end

%% Extract GUI Information
PlotInfo.Units = [];
PlotInfo.ChannelSelection = [];
PlotInfo.Waveforms = [];
PlotInfo.NrWaveformsToExtract = [];
PlotInfo.SpikeRateNumBins = [];

if strcmp(SpikeType,"Kilosort")
    PlotInfo.Units(1) = str2double(UnitsEditField.Value);
end

commaindicie = find(ChannelEditField.Value == ',');
PlotInfo.ChannelSelection(1) = str2double(ChannelEditField.Value(1:commaindicie(1)-1));
PlotInfo.ChannelSelection(2) = str2double(ChannelEditField.Value(commaindicie(1)+1:end));

commaindicie = find(WaveformEditField.Value == ',');
PlotInfo.Waveforms(1) = str2double(WaveformEditField.Value(1:commaindicie(1)-1));
PlotInfo.Waveforms(2) = str2double(WaveformEditField.Value(commaindicie(1)+1:end));

commaindicie = find(TimeWindowSpiketriggredLFPEditField.Value == ',');
PlotInfo.TimeWindowSpiketriggredLFP(1) = str2double(TimeWindowSpiketriggredLFPEditField.Value(1:commaindicie(1)-1));
PlotInfo.TimeWindowSpiketriggredLFP(2) = str2double(TimeWindowSpiketriggredLFPEditField.Value(commaindicie(1)+1:end));

PlotInfo.NrWaveformsToExtract = numel(PlotInfo.Waveforms(1):PlotInfo.Waveforms(2));
PlotInfo.SpikeRateNumBins = str2double(SpikeRateNumBinsEditField.Value);

if strcmp(SpikeAnalysisType.Value,"Spike Map")
    Eventindicie = [];
    if isfield(Data.Info,"EventChannelNames") && ~strcmp(Eventstoshow,"Non")
        for i = 1:length(Data.Info.EventChannelNames)
            if strcmp(Data.Info.EventChannelNames{i},Eventstoshow)
                Eventindicie = i;
            end
        end
        if isempty(Eventindicie)
            PlotInfo.Plotevents = 0;
            Eventindicie = 1;
            PlotInfo.EventData = [];
        else
            PlotInfo.Plotevents = 1;
            PlotInfo.EventData = Data.Events{Eventindicie}/Data.Info.NativeSamplingRate;
        end
    else
        PlotInfo.EventData = [];
        PlotInfo.Plotevents = 0;
    end
end

%% Set GUI Component Properties based on selection
if ExecuteInGUI == 1
    if strcmp(SpikeAnalysisType.Value,"Spike Map")
        TimeWindowSpiketriggredLFPEditField.Enable = "off";
        ChannelEditField.Enable = "on";
        WaveformEditField.Enable = "off";
        if strcmp(SpikeType,"Kilosort")
            UnitsEditField.Enable = "off";
        end
    end

    if strcmp(SpikeAnalysisType.Value,"Spike Triggered LFP")
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        WaveformEditField.Enable = "off";
        if strcmp(SpikeType,"Kilosort")
            UnitsEditField.Enable = "off";
        end
    end
    
    if strcmp(SpikeAnalysisType.Value,"Average Waveforms Across Channel")
        TimeWindowSpiketriggredLFPEditField.Enable = "off";
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "on";
        if strcmp(SpikeType,"Kilosort")
            UnitsEditField.Enable = "on";
        end
    end
    
    if strcmp(SpikeAnalysisType.Value,"Waveforms from Raw Data") || strcmp(SpikeAnalysisType.Value,"Channel Waveforms")
        TimeWindowSpiketriggredLFPEditField.Enable = "off";
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "on";
        if strcmp(SpikeType,"Kilosort")
            UnitsEditField.Enable = "on";
        end
    end
    
    if strcmp(SpikeAnalysisType.Value,"Waveforms Templates")
        TimeWindowSpiketriggredLFPEditField.Enable = "off";
        WaveformEditField.Enable = "off";
        ChannelEditField.Enable = "on";
        if strcmp(SpikeType,"Kilosort")
            UnitsEditField.Enable = "on";
        end
    end
    
    if strcmp(SpikeAnalysisType.Value,"Template from Max Amplitude Channel")
        TimeWindowSpiketriggredLFPEditField.Enable = "off";
        WaveformEditField.Enable = "off";
        ChannelEditField.Enable = "off";
        if strcmp(SpikeType,"Kilosort")
            UnitsEditField.Enable = "on";
        end
    end
    
    if strcmp(SpikeAnalysisType.Value,"Cumulative Spike Amplitude Density Along Depth") || strcmp(SpikeAnalysisType.Value,"Spike Amplitude Density Along Depth")
        TimeWindowSpiketriggredLFPEditField.Enable = "off";
        WaveformEditField.Enable = "off";
        ChannelEditField.Enable = "on";
        if strcmp(SpikeType,"Kilosort")
            UnitsEditField.Enable = "off";
        end
    end
end

%% Prepare Data for Plotting based on GUI inputs
if ~strcmp(SpikeAnalysisType.Value,"Channel Waveforms") && ~strcmp(SpikeAnalysisType.Value,"Average Waveforms Across Channel") && ~strcmp(SpikeAnalysisType.Value,"Waveforms from Raw Data")
    SpikeTimes = Data.Spikes.SpikeTimes/Data.Info.NativeSamplingRate;
else
    SpikeTimes = Data.Spikes.SpikeTimes;
end

[SpikeTimes,SpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange(SpikeTimes,Data.Spikes.SpikePositions(:,2),Data.Info.ChannelSpacing,PlotInfo.ChannelSelection,Data.Info.SpikeType);

if isempty(SpikeTimes)
    SpikeTimes = "Error";
    SpikePositions = [];
    SpikeAmps = [];
    CluterPositions = [];
    ChannelPosition = [];
    PlotInfo = [];
    return;
end

if strcmp(SpikeType,"Kilosort")
    SpikeAmps = Data.Spikes.SpikeAmps(SelectedChannelIndicies==1);
    CluterPositions = Data.Spikes.SpikeCluster(SelectedChannelIndicies==1);
    ChannelPosition = Data.Spikes.ChannelPosition;
else
    CluterPositions = zeros(1,length(SpikePositions))';
    SpikeAmps = Data.Spikes.SpikeAmps(SelectedChannelIndicies==1);
    ChannelPosition = Data.Spikes.ChannelPosition;
end

