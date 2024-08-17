function [app] = Spikes_Set_Up_Spike_Analysis_Windows(app,WindowType,EventWindow)

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
    
    app.BaselineWindowStartStopinsEditField.Value = strcat(num2str(-0.002),',',num2str(0.005)); 
    
    app.ChannelSelectionforPlottingEditField.Value = strcat('1,',num2str(size(app.Mainapp.Data.Raw,1)));

    app.EventRangeEditField.Value = strcat('1,',num2str(size(app.Mainapp.Data.EventRelatedData,2)));

    [PlotInfo,~,~,~,~,~,~] = Event_Spikes_Prepare_Plots(app.Mainapp.Data,app.EventRangeEditField.Value,app.ChannelSelectionforPlottingEditField.Value,app.BaselineWindowStartStopinsEditField,app.SpikeRateNumBinsEditField.Value,"Kilosort");
    
    app.BaselineWindowStartStopinsEditField.Value = strcat(num2str(-PlotInfo.TimearoundEvent(1)),',',num2str(0.005)); 

    [~,SpikeTimes,~,~,SpikeCluster,~,~] = Event_Spikes_Prepare_Plots(app.Mainapp.Data,app.EventRangeEditField.Value,app.ChannelSelectionforPlottingEditField.Value,app.BaselineWindowStartStopinsEditField,app.SpikeRateNumBinsEditField.Value,"Kilosort");
    
end

if strcmp(EventWindow,"Non")
    %% Manage TextField
    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort")
        texttoshow = [strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.Spikes.SpikeTimes)));...
        strcat("Number of Cluster: ",num2str(length(unique(app.Mainapp.Data.Spikes.SpikeCluster))))];
    else
        texttoshow = strcat("Number of Spikes: ",num2str(length(app.Mainapp.Data.Spikes.SpikeTimes)));
    end
else
    %% Manage TextField
    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort")
        texttoshow = [strcat("Number of Spikes: ",num2str(length(SpikeTimes)));...
        strcat("Number of Cluster: ",num2str(length(unique(SpikeCluster))))];
    else
        texttoshow = strcat("Number of Spikes: ",num2str(length(SpikeTimes)));
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


if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") && strcmp(EventWindow,"Non")
    % Exatract number of spike clusters Kilosort found
    app.numCluster = numel(unique(app.Mainapp.Data.Spikes.SpikeCluster));
elseif strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort") && strcmp(EventWindow,"EventWindow")
    % Exatract number of spike clusters Kilosort found
    app.numCluster = numel(unique(SpikeCluster));
end

if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort")
    % Define unique color for each cluster
    app.rgbMatrix = lines(app.numCluster);
else
    app.rgbMatrix = lines(1);
end

%% Manage Cluster Selection
if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort")
    texttoshow = {};
    
    texttoshow{1} = 'Non';
    texttoshow{2} = 'All';
    
    for i = 0:app.numCluster-1
        texttoshow{i+3} = num2str(i);
    end
    
    app.ClustertoshowDropDown.Items = texttoshow;
end



if strcmp(EventWindow,"Non")
    %% Manage TimeWindow Spiketriggred LFP Selection
    app.TimeWindowSpiketriggredLFPEditField.Enable = "off";
    if isfield(app.Mainapp.Data,'Preprocessed')
        if ~isfield(app.Mainapp.Data.Info,'DownsampleFactor')
            app.TimeWindowSpiketriggredLFPEditField.Value = strcat(num2str(-0.002),',',num2str(0.005));
        else
            app.TimeWindowSpiketriggredLFPEditField.Value = strcat(num2str(-0.05),',',num2str(0.2));
        end
    else
        app.TimeWindowSpiketriggredLFPEditField.Value = strcat(num2str(-0.002),',',num2str(0.005)); 
    end
    
    app.ChannelSelectionforPlottingEditField.Value = strcat('1,',num2str(size(app.Mainapp.Data.Raw,1)));

    %% Set up GUI components
    if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort")
        app.UnitstoPlotEditField.Value = strcat('1');
    end
    
    app.WaveformSelectionforPlottingEditField.Value = strcat('1,1');
end

%% Prepare and Initiate Plots
set(app.UIAxes, 'YDir','reverse');
set(app.UIAxes,'xticklabel',{[]});

if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort")
    yyaxis(app.UIAxes_3, 'left');
end

set(app.UIAxes_3, 'YDir','reverse');

if strcmp(app.Mainapp.Data.Info.SpikeType,"Kilosort")
    yyaxis(app.UIAxes_3, 'right');
    set(app.UIAxes_3, 'YDir','reverse');
    ylabel(app.UIAxes_3,"Spike Rate [Hz]")
end

app.UIAxes_3.FontSize = 10;

% % Switch back to the left y-axis
% yyaxis(app.UIAxes_3, 'left');

set(app.UIAxes_5, 'YDir','reverse');