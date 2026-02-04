function Module_MainWindow_Show_Spike_Selector_Waveforms(app,PlotType)

SelectedSpike = str2double(app.SpikeNrEditField.Value);

if ~strcmp(app.Mainapp.Data.Info.SpikeType,"Internal") && ~strcmp(app.Mainapp.Data.Info.SpikeType,"Non")
    ClustertoShow = app.ClusterDropDown;
    ChannelToShow = app.Mainapp.ActiveChannel;
else
    app.ClusterDropDown.Enable = "off";
    ClustertoShow.Value = 'Non';
    ChannelToShow = str2double(app.SpikeChannelEditField.Value);
end

ChannelSelectionforPlottingEditField.Value = strcat('1,',num2str(size(app.Mainapp.Data.Raw,1)));
SpikeAnalysisType.Value = 'Spike Map';
WaveformEditField.Value = '1,10';
SpikeRateBinsEditField.Value = '10';
TimeWindowSpiketriggredLFPEditField.Value = '-0.1,0';

[SpikeTimes,~,SpikeAmps,CluterPositions,Waveforms,~,~,~,~,ClustertoshowDropDown,~,~,WaveformChannel] = Continous_Spikes_Prepare_Plots(app.Mainapp.Data,ChannelSelectionforPlottingEditField,WaveformEditField,ClustertoShow,[],app.Mainapp.Data.Info.SpikeType,SpikeAnalysisType,SpikeRateBinsEditField,TimeWindowSpiketriggredLFPEditField,1,'',app.Mainapp.Data.Spikes.Waveforms,ChannelToShow,SpikeAnalysisType.Value,app.Mainapp.PreservePlotChannelLocations);

if isstring(SpikeTimes)
    msgbox("No spikes with current settings found! Check if channel with the selected unit are active in the probe view window!");
    cla(app.UIAxes)
    app.SelectedSpike.SpikeTimes = [];
    return;
end

if ~isempty(app.SpikeAmplitudemVempytfornonEditField.Value)
    AmplitudeTrehshold = str2double(app.SpikeAmplitudemVempytfornonEditField.Value);

    IndiciesBelowAmplTresh = Waveforms <= AmplitudeTrehshold;
    SumIndiciesBelowAmplTresh = sum(IndiciesBelowAmplTresh,2)';

    if sum(IndiciesBelowAmplTresh)==0
        msgbox("No spikes below amplitude threshold found!");
        return;
    else
        SpikeTimes(SumIndiciesBelowAmplTresh==0)=[];
        SpikeAmps(SumIndiciesBelowAmplTresh==0)=[];
        Waveforms(SumIndiciesBelowAmplTresh==0,:)=[];
    end
    WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
    MarkedWaveHandles = findobj(app.UIAxes,'Tag', 'MarkedWave');
    delete(WaveformHandles);
    delete(MarkedWaveHandles);
    app.PreviouslyMarkedSpike = [];
end

%% get waveform from current spike

TimeToPlot = 0:1/app.Mainapp.Data.Info.NativeSamplingRate:(size(Waveforms,2)-1)/app.Mainapp.Data.Info.NativeSamplingRate;

RangeAroundSpike = (length(TimeToPlot)-1)/2; % 50 samples in total

% get currently marked Wavefrm
if ~strcmp(app.Mainapp.Data.Info.SpikeType,"Internal") && ~strcmp(app.Mainapp.Data.Info.SpikeType,"Non")
    ClusterIndicies = CluterPositions == str2double(app.ClusterDropDown.Value);
   
     if sum(ClusterIndicies)==0
        msgbox("No spikes with current settings found! Check if channel with the selected unit are active in the probe view window!");
        return;
    else
        SpikeTimes(ClusterIndicies==0)=[];
        SpikeAmps(ClusterIndicies==0)=[];
        Waveforms(ClusterIndicies==0,:)=[];
        WaveformChannel(ClusterIndicies==0,:)=[];
    end
    app.SelectedSpike.Channel = WaveformChannel(SelectedSpike);
else
    app.SelectedSpike.Channel = ChannelToShow;
end

app.SelectedSpike.SpikeTimes = SpikeTimes;

SampleRate = app.Mainapp.Data.Info.NativeSamplingRate;
WaveFormSamples = round(SpikeTimes(SelectedSpike)*SampleRate)-RangeAroundSpike:round(SpikeTimes(SelectedSpike)*SampleRate)+RangeAroundSpike;

[PreproChannel] = Organize_Convert_ActiveChannel_to_DataChannel(app.Mainapp.Data.Info.ProbeInfo.ActiveChannel,app.SelectedSpike.Channel,'MainPlot');
CurrentWaveform = app.Mainapp.Data.Preprocessed(PreproChannel,WaveFormSamples);

WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
if length(WaveformHandles)>length(SpikeTimes)
    delete(WaveformHandles(length(SpikeTimes)+1:end));
    WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
end

title(app.UIAxes,strcat("All Waveforms Channel ",app.SpikeChannelEditField.Value))
xlabel(app.UIAxes,"Time [ms]")
ylabel(app.UIAxes,"Signal [mV]")

if isempty(WaveformHandles)
    for i = 1:length(SpikeTimes)
        line(app.UIAxes,TimeToPlot,Waveforms(i,:),'Color','c','Tag','Waveforms')
    end
else
    for i = 1:length(SpikeTimes)
        if i <=length(WaveformHandles)
            set(WaveformHandles(i),'XData',TimeToPlot,'YData',Waveforms(i,:),'Color','c','Tag','Waveforms')
        else
            line(app.UIAxes,TimeToPlot,Waveforms(i,:),'Color','c','Tag','Waveforms')
        end
    end
end

app.CurrentNumSpikes = length(SpikeTimes);

%% Plot currently selected Spike
MarkedWaveHandles = findobj(app.UIAxes,'Tag', 'MarkedWave');
if isempty(MarkedWaveHandles)
    line(app.UIAxes,TimeToPlot,CurrentWaveform,'Color','r','LineWidth',3,'Tag','MarkedWave')
else
    set(MarkedWaveHandles(1),'XData',TimeToPlot,'YData',CurrentWaveform,'Color','r','LineWidth',3,'Tag','MarkedWave')
    uistack(MarkedWaveHandles(1),'top')
end
