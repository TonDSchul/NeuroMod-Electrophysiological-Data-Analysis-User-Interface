function [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,ChannelPosition,PlotInfo,ChannelEditField,WaveformEditField,UnitsEditField,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField] = Continous_Spikes_Prepare_Plots(Data,ChannelEditField,WaveformEditField,UnitsEditField,DifferentInput,SpikeType,SpikeAnalysisType,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField,ExecuteInGUI,Eventstoshow)

%________________________________________________________________________________________
%% Function to prepare plots for internal and kilosort continous spike analysis

% This function is called in the
% Continous_Kilosort_Spike_Window and Continous_Internal_Spike_Window app
% windows when something new has to be plotted. It prepares everything for
% the function that selects plotting functions based on input
% This means it checks the correct format of inputs, corrects it with
% standard values if necessary and pools them in a structure accessed later
% for analysis and plotting

% Inputs:
% 1. Data: main window app structure with Data.Info and Data.Spikes fields
% 2. ChannelEditField: text field of app containing userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10
% 3. WaveformEditField: text field of app containing userinput as char in
% the field WaveformEditField.Value, like '1,10' for waveforms 1 to 10
% 4. UnitsEditField: text field of app containing userinput as char in
% the field UnitsEditField.Value, like '1' for unit 1
% 5. DifferentInput -  not used now. Can be used to determine specific type
% of input at a certain time point
% 6. SpikeType: Type of spikes of dataset, either 'Kilosort' OR 'Internal'
% (from Data.Info.SpikeTpe)
% 7. SpikeAnalysisType: text field of app containing userinput as char in
% the field UnitsEditField.Value, specifies which analysis was selected by user,
% Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR "Waveforms from Raw Data" OR
% "Average Waveforms Across Channel" OR "Waveforms Templates" OR "Template from Max Amplitude Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 8. SpikeRateNumBinsEditField: text field of app containing userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins
% 9. TimeWindowSpiketriggredLFPEditField: text field of app containing userinput as char in
% the field TimeWindowSpiketriggredLFPEditField.Value, like '-0.005,0.2' 
% 10. ExecuteInGUI: Equals 1 if this function is called within the GUI, NOT
% the Autorun
% 11. Eventstoshow: char indicating the event to show in the plot; Either 'Non' or char with event channel name, like 'DIN-04'

%Outputs:
% 1. SpikeTimes: nspikes x 1 double in seconds and within the
% channelrange
% 2.SpikePositions: nspikes x 1 double with spike poisiton spike indicies within the
% channelrange (in um)
% 3.SpikeAmps: nspikes x 1 double with just spike amplitudes indicies within the
% channelrange
% 4. CluterPositions: nspikes x 1 double with just spike cluster ID's indicies within the
% channelrange
% 5. ChannelPosition: nchannel x 2 double matrix; :,1 = x ccordinates which are
% all 0 since this i s a single shank probe, :,2 = y coordinates/ channel
% depths in um
% 6. PlotInfo: structure holding gathered info about user input, contains
% field: PlotInfo.Units, PlotInfo.ChannelSelection;, PlotInfo.Waveforms, PlotInfo.NrWaveformsToExtract;, PlotInfo.SpikeRateNumBins
% 7. ChannelEditField: text field of app containing userinput as char in
% the field ChannelEditField.Value, like '1,10' for channel 1 to 10 --
% corrected if format was wrong
% 8. WaveformEditField: text field of app containing userinput as char in
% the field WaveformEditField.Value, like '1,10' for waveforms 1 to 10 --
% corrected if format was wrong
% 9. UnitsEditField: text field of app containing userinput as char in
% the field UnitsEditField.Value, like '1' for unit 1 --
% corrected if format was wrong
% 10. SpikeRateNumBinsEditField: text field of app containing userinput as char in
% the field SpikeRateNumBinsEditField.Value, like '100' for 100 bins --
% corrected if format was wrong
% 11. TimeWindowSpiketriggredLFPEditField: text field of app containing userinput as char in
% the field TimeWindowSpiketriggredLFPEditField.Value, like '-0.005,0.2' --
% corrected if format was wrong

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Check GUI Information
if strcmp(SpikeType,"Kilosort")
    [ChannelEditField,WaveformEditField,UnitsEditField,Error,SpikeRateNumBinsEditField] = Continous_Kilosort_Spikes_Check_Inputs(Data,ChannelEditField,WaveformEditField,UnitsEditField,SpikeAnalysisType.Value,SpikeRateNumBinsEditField);
    
    % If some error in check functions: one of those variables with be a
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

