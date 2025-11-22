function [SpikeTimes,SpikePositions,SpikeAmps,CluterPositions,Waveforms,ChannelPosition,PlotInfo,ChannelEditField,WaveformEditField,ClustertoshowDropDown,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField,WaveformChannel] = Continous_Spikes_Prepare_Plots(Data,ChannelEditField,WaveformEditField,ClustertoshowDropDown,DifferentInput,SpikeType,SpikeAnalysisType,SpikeRateNumBinsEditField,TimeWindowSpiketriggredLFPEditField,ExecuteInGUI,Eventstoshow,Waveforms,ActiveChannel,Analysis)

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
% 4. ClustertoshowDropDown: text field of app containing userinput as char in
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
% 12: Waveforms: nspikes x ntimewaveforms matrix with waveforms for each
% spikes (spikes in Data.Spikes.Waveforms)
% 13. ActiveChannel: double vector, currently user defined active channel from probe view window

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
% 12. WaveformChannel: if order of waveforms changed or waveforms deleted,
% this has to be capture in the channel for each waveform too. Unchanged,
% channel info comes from Data.Spikes.SpikePositions. Not necessary yet but
% usefull to have ready.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

PlotInfo.Units = [];
PlotInfo.ChannelSelection = [];
PlotInfo.Waveforms = [];
PlotInfo.NrWaveformsToExtract = [];
PlotInfo.SpikeRateNumBins = [];

%% Check if GUI Information is proper
[ChannelEditField,WaveformEditField,Error,SpikeRateNumBinsEditField] = Continous_Spikes_Check_Inputs(Data,ChannelEditField,WaveformEditField,SpikeAnalysisType.Value,SpikeRateNumBinsEditField);

% If some error in check functions: one of those variables with be a
% string saying "Error"
if Error
    if strcmp(SpikeAnalysisType.Value,"Waveforms from Raw Data")
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "on";
    end

    SpikeTimes = "Error";
    SpikePositions = [];
    SpikeAmps = [];
    CluterPositions = [];
    ChannelPosition = [];
    PlotInfo = [];
    return;
end

%% Extract GUI Information

if strcmp(ClustertoshowDropDown.Value,"All") || strcmp(ClustertoshowDropDown.Value,"Non")
    PlotInfo.Units(1) = NaN;
else
    PlotInfo.Units(1) = str2double(ClustertoshowDropDown.Value);
end
% get channel in terms of active channel
[PlotInfo.ChannelSelection] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainPlot');

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
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        ChannelEditField.Enable = "on";
        WaveformEditField.Enable = "on";
    end

    if strcmp(SpikeAnalysisType.Value,"Spike Triggered LFP")
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        WaveformEditField.Enable = "on";
    end
    
    if strcmp(SpikeAnalysisType.Value,"Average Waveforms Across Channel")
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "on";
    end
    
    if strcmp(SpikeAnalysisType.Value,"Waveforms from Raw Data") || strcmp(SpikeAnalysisType.Value,"Channel Waveforms")
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "on";
    end
    
    if strcmp(SpikeAnalysisType.Value,"Waveforms Templates")
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "on";
        if strcmp(ClustertoshowDropDown.Value,"All") || strcmp(ClustertoshowDropDown.Value,"Non")
            ClustertoshowDropDown.Value = '1';
            PlotInfo.Units(1) = str2double(ClustertoshowDropDown.Value);
            msgbox("Warning: Template from Max Amplitude Channel only available for specific units. Unit Selection was autoadjusted to the first one.")
        end
    end
    
    if strcmp(SpikeAnalysisType.Value,"Template from Max Amplitude Channel")
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "off";
        if strcmp(ClustertoshowDropDown.Value,"All") || strcmp(ClustertoshowDropDown.Value,"Non")
            ClustertoshowDropDown.Value = '1';
            PlotInfo.Units(1) = str2double(ClustertoshowDropDown.Value);
            msgbox("Warning: Template from Max Amplitude Channel only available for specific units. Unit Selection was autoadjusted to the first one.")
        end
    end
    
    if strcmp(SpikeAnalysisType.Value,"Cumulative Spike Amplitude Density Along Depth") || strcmp(SpikeAnalysisType.Value,"Spike Amplitude Density Along Depth")
        TimeWindowSpiketriggredLFPEditField.Enable = "on";
        WaveformEditField.Enable = "on";
        ChannelEditField.Enable = "on";
    end
end

%% Prepare Data for Plotting based on GUI inputs
if ~strcmp(SpikeAnalysisType.Value,"Channel Waveforms") && ~strcmp(SpikeAnalysisType.Value,"Average Waveforms Across Channel") && ~strcmp(SpikeAnalysisType.Value,"Waveforms from Raw Data")
    SpikeTimes = Data.Spikes.SpikeTimes/Data.Info.NativeSamplingRate;
else
    SpikeTimes = Data.Spikes.SpikeTimes;
end

if strcmp(Data.Info.SpikeType,'Internal')
    [SpikeTimes,SpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("Con_Spikes",Data.Info,SpikeTimes,Data.Spikes.SpikePositions(:,2),Data.Info.ChannelSpacing,PlotInfo.ChannelSelection,Data.Info.SpikeType,Data.Info.ProbeInfo.ActiveChannel);

elseif strcmp(Data.Info.SpikeType,'Kilosort') || strcmp(Data.Info.SpikeType,"SpikeInterface")
    UinquePos = unique(Data.Spikes.ChannelPosition(:,1));
    if numel(UinquePos)>=2
        [SpikeTimes,SpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("Con_Spikes",Data.Info,SpikeTimes,Data.Spikes.DataCorrectedSpikePositions(:,2),Data.Info.ChannelSpacing,PlotInfo.ChannelSelection,Data.Info.SpikeType,Data.Info.ProbeInfo.ActiveChannel);
    else
        [SpikeTimes,SpikePositions,SelectedChannelIndicies] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("Con_Spikes",Data.Info,SpikeTimes,Data.Spikes.SpikePositions(:,2),Data.Info.ChannelSpacing,PlotInfo.ChannelSelection,Data.Info.SpikeType,Data.Info.ProbeInfo.ActiveChannel);
    end
end

if isempty(SpikeTimes)
    SpikeTimes = "Error";
    SpikePositions = [];
    SpikeAmps = [];
    CluterPositions = [];
    ChannelPosition = [];
    WaveformChannel = [];
    PlotInfo = [];
    return;
end

WaveformChannel = [];
if strcmp(SpikeType,"Kilosort") || strcmp(SpikeType,"SpikeInterface")
    
    if ~isempty(SelectedChannelIndicies)
        SpikeAmps = Data.Spikes.SpikeAmps(SelectedChannelIndicies==0);

        CluterPositions = Data.Spikes.SpikeCluster(SelectedChannelIndicies==0);
        if min(Data.Spikes.SpikeCluster)==0
            CluterPositions = CluterPositions+1;
        end

        ChannelPosition = Data.Spikes.ChannelPosition;
        if ndims(Waveforms)==3
            Waveforms = Waveforms(:,SelectedChannelIndicies==0,:);
        else
            Waveforms = Waveforms(SelectedChannelIndicies==0,:);
        end
    else
        SpikeAmps = Data.Spikes.SpikeAmps;
        CluterPositions = Data.Spikes.SpikeCluster;

        if min(Data.Spikes.SpikeCluster)==0
            CluterPositions = CluterPositions+1;
        end

        ChannelPosition = Data.Spikes.ChannelPosition;

        Waveforms = Waveforms;
        
    end
    
elseif strcmp(SpikeType,"Internal")
    if isempty(Data.Spikes.SpikeCluster)
        CluterPositions = zeros(1,length(SpikePositions))';
    else
        if ~isempty(SelectedChannelIndicies)
            CluterPositions = Data.Spikes.SpikeCluster(SelectedChannelIndicies==0);
        else
            CluterPositions = Data.Spikes.SpikeCluster;
        end
        % CLuster ID's can start with 0 (from Kilosort). Its used for indexing, so
        % min value has to be 1
        
        if min(Data.Spikes.SpikeCluster)==0
            CluterPositions = CluterPositions+1;
        end
    end
    
    if str2double(Data.Info.ProbeInfo.NrRows)==1
        SpikePositions = Data.Info.ProbeInfo.ycoords(Data.Info.ProbeInfo.ActiveChannel(SpikePositions));
    else
        FakeChannelRange = 1:str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows);
        FakeYpositions = (FakeChannelRange-1)*Data.Info.ChannelSpacing;
        SpikePositions = FakeYpositions(Data.Info.ProbeInfo.ActiveChannel(SpikePositions));
    end

    if ~isempty(SelectedChannelIndicies)
        SpikeAmps = Data.Spikes.SpikeAmps(SelectedChannelIndicies==0);
        ChannelPosition = Data.Spikes.ChannelPosition;
        if ndims(Waveforms)==3
            Waveforms = Waveforms(:,SelectedChannelIndicies==0,:);
        else
            Waveforms = Waveforms(SelectedChannelIndicies==0,:);
        end
    else
        SpikeAmps = Data.Spikes.SpikeAmps;
        ChannelPosition = Data.Spikes.ChannelPosition;
    end
    
end

