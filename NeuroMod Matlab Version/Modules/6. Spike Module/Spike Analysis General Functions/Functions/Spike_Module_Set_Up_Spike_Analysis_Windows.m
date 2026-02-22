function [app] = Spike_Module_Set_Up_Spike_Analysis_Windows(app,WindowType,EventWindow,ActiveChannel)

%________________________________________________________________________________________
%% Function to prepare all spike analysis windows on startup
% This function fills in standard values and individual options to select in windows based on
% data components

% This function is called on startup of all spike analysis windows

% Inputs:
% 1. app: app object containing all components to fill out. This is the
% respective app window of the analysis the user selects
% 2. WindowType: not used yet. Can pass exact type of window openend if
% necessary
% 3. EventWindow: Either "EventWindow" when this function is called on startup
% of a event spike analysis window. "Non" otherwise

% Outputs
% 1. app: app object with individual fields having a char added to their
% Value fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Prepare GUI by extracting some Info and filling out the dropdown menus with the corresponding data
           
%% Check if Spike Data available

if ~isfield(app.Mainapp.Data,'Spikes')
    msgbox("No Kilosort Data loaded. Please first use the main window 'Load from Kilosort' function");
    delete(app);
    return;
else
    if isempty(app.Mainapp.Data.Spikes)
        msgbox("No Kilosort Data loaded. Please first use the main window 'Load from Kilosort' function");
        delete(app);
        return;
    end
end

if strcmp(EventWindow,"EventWindow")
    %% Manage Basline Normalization Time Window of event related spike windows
    app.BaselineWindowStartStopinsEditField.Enable = "on";
    app.TimeWindowSpiketriggredLFPEditField.Enable = "on";
    app.BaselineWindowStartStopinsEditField.Value = strcat(num2str(-0.002),',',num2str(0)); 

    % Standard Settings
    app.SpikeBinSettings.depth_bin_size = app.Mainapp.Data.Info.ChannelSpacing; %20; % Depth bin size
    app.SpikeBinSettings.time_bin_size = 0.006; % app.GeneralSettings.Time bin size in seconds
    
    app.ChannelSelectionforPlottingEditField.Value = strcat('1,',num2str(size(app.Mainapp.Data.Raw,1)));
    
    % Event channel selected
    for i = 1:length(app.Mainapp.Data.Info.EventChannelNames)
        app.EventChannelSelectionDropDown.Items{i} = convertStringsToChars(app.Mainapp.Data.Info.EventChannelNames{i});
    end

    %% -------------------- Populate event channel selection -------------------- 
    [app.EventRangeEditField.Value] = Event_Module_Check_EventInput(app.EventRangeEditField.Value,app.Mainapp.Data,app.EventChannelSelectionDropDown.Value,"Raw Event Related Data",1);

    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
        [PlotInfo,~,~,~,~,~,~] = Event_Spikes_Prepare_Plots(app.Mainapp.Data,app.EventRangeEditField.Value,app.ChannelSelectionforPlottingEditField.Value,app.BaselineWindowStartStopinsEditField,app.SpikeRateNumBinsEditField.Value,"Kilosort",0,app.TimeWindowSpiketriggredLFPEditField.Value,app.SpikeBinSettings,app.Mainapp.ActiveChannel,app.Mainapp.PreservePlotChannelLocations);
    else
        [PlotInfo,~,~,~,~,~,~] = Event_Spikes_Prepare_Plots(app.Mainapp.Data,app.EventRangeEditField.Value,app.ChannelSelectionforPlottingEditField.Value,app.BaselineWindowStartStopinsEditField,app.SpikeRateNumBinsEditField.Value,"Internal",0,app.TimeWindowSpiketriggredLFPEditField.Value,app.SpikeBinSettings,app.Mainapp.ActiveChannel,app.Mainapp.PreservePlotChannelLocations);
    end
    
    app.BaselineWindowStartStopinsEditField.Value = strcat(num2str(-PlotInfo.TimearoundEvent(1)),',',num2str(0)); 

    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
        [~,SpikeTimes,~,~,SpikeCluster,~,~] = Event_Spikes_Prepare_Plots(app.Mainapp.Data,app.EventRangeEditField.Value,app.ChannelSelectionforPlottingEditField.Value,app.BaselineWindowStartStopinsEditField,app.SpikeRateNumBinsEditField.Value,"Kilosort",0,app.TimeWindowSpiketriggredLFPEditField.Value,app.SpikeBinSettings,app.Mainapp.ActiveChannel,app.Mainapp.PreservePlotChannelLocations);
    else
        [~,SpikeTimes,~,~,SpikeCluster,~,~] = Event_Spikes_Prepare_Plots(app.Mainapp.Data,app.EventRangeEditField.Value,app.ChannelSelectionforPlottingEditField.Value,app.BaselineWindowStartStopinsEditField,app.SpikeRateNumBinsEditField.Value,"Internal",0,app.TimeWindowSpiketriggredLFPEditField.Value,app.SpikeBinSettings,app.Mainapp.ActiveChannel,app.Mainapp.PreservePlotChannelLocations);
    end

    spaceindicie = find(app.Mainapp.Data.Info.EventRelatedDataTimeRange==' ');
    if ~isempty(spaceindicie)
        app.TimearoundEvent(1) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(1:spaceindicie(1)-1));
        app.TimearoundEvent(2) = str2double(app.Mainapp.Data.Info.EventRelatedDataTimeRange(spaceindicie(1)+1:end));
        if app.TimearoundEvent(1) ~= 0
            app.TimearoundEvent(1) = -app.TimearoundEvent(1);
        end
    end

end

if strcmp(EventWindow,"Non")
    %% Manage TextField
    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
        texttoshow = [strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.Spikes.SpikeTimes)));...
        strcat("Number of Cluster: ",num2str(length(unique(app.Mainapp.Data.Spikes.SpikeCluster))))];
    else
        %if isfield(app.Mainapp.Data.Info,'Sorter')
            if strcmp(app.Mainapp.Data.Info.Sorter,'WaveClus')
                texttoshow = [strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.Spikes.SpikeTimes)));...
                strcat("Number of Cluster: ",num2str(length(unique(app.Mainapp.Data.Spikes.SpikeCluster))))];
            else
                texttoshow = strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.Spikes.SpikeTimes)));
            end
        %end
    end
else
    %% Manage TextField
    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
        texttoshow = [strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.EventRelatedSpikes.SpikeTimes)));...
        strcat("Number of Cluster: ",num2str(length(unique(app.Mainapp.Data.EventRelatedSpikes.SpikeCluster))))];
    else
        if strcmp(app.Mainapp.Data.Info.Sorter,'WaveClus')
            texttoshow = [strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.EventRelatedSpikes.SpikeTimes)));...
            strcat("Number of Cluster: ",num2str(length(unique(app.Mainapp.Data.EventRelatedSpikes.SpikeCluster))))];
        else
            texttoshow = strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.EventRelatedSpikes.SpikeTimes)));
        end
    end
end

app.TextArea.Value = texttoshow;

if strcmp(EventWindow,"Non")
    %% Manage Continous Events Selection
    
    texttoshow = {};
    
    if isfield(app.Mainapp.Data,'Events')
        app.EventstoshowDropDown.Enable = "on";
        texttoshow{1} = 'Non';
        for i = 1:length(app.Mainapp.Data.Events)
            texttoshow{i+1} = app.Mainapp.Data.Info.EventChannelNames{i};
        end
        app.EventstoshowDropDown.Items = texttoshow;
    else
        app.EventstoshowDropDown.Enable = "off";
    end  
end

if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") && strcmp(EventWindow,"Non") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface") && strcmp(EventWindow,"Non")
    % Exatract number of spike clusters Kilosort found
    app.numCluster = numel(unique(app.Mainapp.Data.Spikes.SpikeCluster));
elseif strcmp(app.Mainapp.Data.Info.SpikeType,"Internal") && strcmp(app.Mainapp.Data.Info.Sorter,'WaveClus')
    % Exatract number of spike clusters Kilosort found
    app.numCluster = numel(unique(app.Mainapp.Data.Spikes.SpikeCluster));
elseif strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") && strcmp(EventWindow,"EventWindow") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface") && strcmp(EventWindow,"EventWindow")
    % Exatract number of spike clusters Kilosort found
    app.numCluster = numel(unique(app.Mainapp.Data.Spikes.SpikeCluster));
end

if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
    % Define unique color for each cluster
    app.rgbMatrix = lines(app.numCluster);
else
    if strcmp(app.Mainapp.Data.Info.Sorter,'WaveClus')
        app.rgbMatrix = lines(app.numCluster);
    else
        app.rgbMatrix = lines(1);
    end
end

%% If event spike plot cluster can be missing. So cluster dropdown menu has to be adjusted 
if strcmp(EventWindow,"EventWindow")
    AllUniquecluster = unique(app.Mainapp.Data.EventRelatedSpikes.SpikeCluster);
    if min(app.Mainapp.Data.EventRelatedSpikes.SpikeCluster) == 0
        AllUniquecluster = AllUniquecluster+1;
    end
    
    if strcmp(EventWindow,"EventWindow")
        % Exatract number of spike clusters Kilosort found
        app.numCluster = numel(unique(app.Mainapp.Data.EventRelatedSpikes.SpikeCluster));
    end
else
    AllUniquecluster = unique(app.Mainapp.Data.Spikes.SpikeCluster);
    if min(app.Mainapp.Data.Spikes.SpikeCluster) == 0
        AllUniquecluster = AllUniquecluster+1;
    end
end
%% Manage Cluster Selection
if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"Internal") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
    texttoshow = {};
    
    if strcmp(app.Mainapp.Data.Info.SpikeType,"Internal") && ~strcmp(app.Mainapp.Data.Info.Sorter,'WaveClus')
        texttoshow{1} = 'Non';
    else
        texttoshow{1} = 'Non';
        texttoshow{2} = 'All';

        for i = 1:length(AllUniquecluster)
            texttoshow{i+2} = num2str(AllUniquecluster(i));
        end
    end
    app.ClustertoshowDropDown.Items = texttoshow;
end

if strcmp(EventWindow,"Non")
    %% Manage TimeWindow Spiketriggred LFP Selection
    app.TimeWindowSpiketriggredLFPEditField.Enable = "on";

    app.TimeWindowSpiketriggredLFPEditField.Value = strcat(num2str(-0.002),',',num2str(0.1)); 
    
    app.ChannelSelectionforPlottingEditField.Value = strcat('1,',num2str(size(app.Mainapp.Data.Raw,1)));

    %% Set up GUI components
    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
        app.WaveformSelectionforPlottingEditField.Value = strcat('1,100');
    end
end

%% Prepare and Initiate Plots
set(app.UIAxes, 'YDir','reverse');
set(app.UIAxes,'xticklabel',{[]});

if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
    yyaxis(app.UIAxes_3, 'left');
end

set(app.UIAxes_3, 'YDir','reverse');

if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") || strcmp(app.Mainapp.Data.Info.SpikeType,"SpikeInterface")
    yyaxis(app.UIAxes_3, 'right');
    set(app.UIAxes_3, 'YDir','reverse');
    ylabel(app.UIAxes_3,"Spike Rate [Hz]")
end

app.UIAxes_3.FontSize = 10;

% % Switch back to the left y-axis
% yyaxis(app.UIAxes_3, 'left');

set(app.UIAxes_5, 'YDir','reverse');