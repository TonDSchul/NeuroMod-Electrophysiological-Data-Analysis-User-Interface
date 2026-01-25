function Module_MainWindow_Show_Spike_Selector_Waveforms(app,PlotType)

if strcmp(PlotType,"FullPlot")
    if ~strcmp(app.Mainapp.Data.Info.SpikeType,"Internal") && ~strcmp(app.Mainapp.Data.Info.SpikeType,"Non")
        UniqueCluster = unique(app.Mainapp.Data.Spikes.SpikeCluster);
        for k = 1:length(UniqueCluster)
            app.ClusterDropDown.Items{k} = num2str(UniqueCluster(k));
        end
        app.ClusterDropDown.Value = app.ClusterDropDown.Items{1};
        ClustertoShow = app.ClusterDropDown;
    else
        app.ClusterDropDown.Enable = "off";
        ClustertoShow.Value = 'Non';
    end

    ChannelSelectionforPlottingEditField.Value = strcat('1,',num2str(size(app.Mainapp.Data.Raw,1)));
    SpikeAnalysisType.Value = 'Spike Map';
    WaveformEditField.Value = '1,10';
    SpikeRateBinsEditField.Value = '10';
    TimeWindowSpiketriggredLFPEditField.Value = '-0.1,0';
    
    ChannelToShow = str2double(app.SpikeChannelEditField.Value);
    
    [SpikeTimes,~,SpikeAmps,CluterPositions,Waveforms,~,~,~,~,ClustertoshowDropDown,~,~,WaveformChannel] = Continous_Spikes_Prepare_Plots(app.Mainapp.Data,ChannelSelectionforPlottingEditField,WaveformEditField,ClustertoShow,[],app.Mainapp.Data.Info.SpikeType,SpikeAnalysisType,SpikeRateBinsEditField,TimeWindowSpiketriggredLFPEditField,1,'',app.Mainapp.Data.Spikes.Waveforms,ChannelToShow,SpikeAnalysisType.Value,app.Mainapp.PreservePlotChannelLocations);
    
    if ~isempty(app.SpikeAmplitudemVempytfornonEditField.Value)
        AmplitudeTrehshold = str2double(app.SpikeAmplitudemVempytfornonEditField.Value);

        IndiciesBelowAmplTresh = Waveforms <= AmplitudeTrehshold;
        SumIndiciesBelowAmplTresh = sum(IndiciesBelowAmplTresh,1)';

        if sum(IndiciesBelowAmplTresh)==0
            msgbox("No spikes below amplitude threshold found!");
            return;
        else
            SpikeTimes(SumIndiciesBelowAmplTresh==1)=[];
            SpikeAmps(SumIndiciesBelowAmplTresh==1)=[];
            Waveforms(SumIndiciesBelowAmplTresh==1,:)=[];
        end
    end

    app.SelectedSpike.SpikeTimes = SpikeTimes;
    app.SelectedSpike.Channel = ChannelToShow;

    WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
    if length(WaveformHandles)>length(SpikeTimes)
        delete(WaveformHandles(length(SpikeTimes)+1:end));
        WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
    end
    
    title(app.UIAxes,strcat("All Waveforms Channel ",app.SpikeChannelEditField.Value))
    xlabel(app.UIAxes,"Time [ms]")
    ylabel(app.UIAxes,"Signal [mV]")
    
    TimeToPlot = 0:1/app.Mainapp.Data.Info.NativeSamplingRate:(size(Waveforms,2)-1)/app.Mainapp.Data.Info.NativeSamplingRate;
    
    if isempty(WaveformHandles)
        for i = 1:length(SpikeTimes)
            line(app.UIAxes,TimeToPlot,Waveforms(i,:),'Color','c','Tag','Waveforms')
        end
        WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
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
    
    WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
    if str2double(app.SpikeNrEditField.Value)>length(SpikeTimes)
        warning("Selected spike number exceeds spike number present in current selection. No spike is marked.");
        MarkedWaveHandles = findobj(app.UIAxes,'Tag', 'MarkedWave');
        delete(MarkedWaveHandles);
        return;
    else
        MarkedWaveHandles = findobj(app.UIAxes,'Tag', 'MarkedWave');
        if ~isempty(MarkedWaveHandles)
            set(MarkedWaveHandles,'Color','c','LineWidth',1)
        end

        set(WaveformHandles(str2double(app.SpikeNrEditField.Value)),'Color','r','LineWidth',3,'Tag','MarkedWave')
        uistack(WaveformHandles(str2double(app.SpikeNrEditField.Value)),'top')
        app.PreviouslyMarkedSpike = str2double(app.SpikeNrEditField.Value);
    end
else % Just mark a new spike
    WaveformHandles = findobj(app.UIAxes,'Tag', 'Waveforms');
    MarkedWaveHandles = findobj(app.UIAxes,'Tag', 'MarkedWave');
    
    if ~isempty(MarkedWaveHandles)
        set(MarkedWaveHandles,'Color','c','LineWidth',1)
    end
    app.PreviouslyMarkedSpike = str2double(app.SpikeNrEditField.Value);

    set(WaveformHandles(str2double(app.SpikeNrEditField.Value)),'Color','r','LineWidth',3,'Tag','MarkedWave')
    uistack(WaveformHandles(str2double(app.SpikeNrEditField.Value)),'top')

end