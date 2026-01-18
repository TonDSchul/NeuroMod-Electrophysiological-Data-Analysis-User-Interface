function Module_MainWindow_Plot_Internal_Spikes(Data,Info,Time,SpikePlot,SpikeDatatype,SpikePlotType,SpikeData,ActiveChannel,Channel_Selection,UIAxis,ChannelSpacing,PlotAppearance)

if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Internal")
    if strcmp(SpikePlotType,"Points")
        if ~isempty(SpikeData.Indicie)
            
            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');

            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh")
                [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("NotMainWindow",Info,SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);
                delete(SpikeHandles)
                SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
            else
                [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("MainWindow",Info,SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);
            end

            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
                FakeData = [];
                FakeData.Info = Info;
                [~,~,~,FakeDepths] = Spike_Module_Analysis_Determine_Depths(FakeData,0,Info.ProbeInfo.ActiveChannel(Channel_Selection));
                SpikeData.Position = FakeDepths(SpikeData.Position);
            end
           % SpikeData.Position = FakeDepths(SpikeData.Position);
            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh")
                % create matrix with data for each channel at proper channel
                % location
                SpikeData.Position = Info.ProbeInfo.ActiveChannel(SpikeData.Position);
                [~,SpikeData] = Module_MainWindow_Convert_DataMatrix_Into_Grid(Info,Data,PlotAppearance,SpikeData,"SpikeMatrix",Channel_Selection);       
            end

            % INdex of SpikeData.Position in Info.ProbeInfo.ActiveChannel
            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
                %% Scale and Plot Spike Positions
                for nspikes = 1:numel(SpikeData.Indicie) 
                    SpikeData.Position(nspikes) = Data(SpikeData.Position(nspikes),SpikeData.Indicie(nspikes));
                end
            end
            % Plot
            if isempty(SpikeHandles)
                if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
                    line(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, ...
                     'LineStyle', 'none', ...  % No line between markers
                     'Marker', 'o', ...        % Marker type
                     'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                     'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                     'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                     'Tag', 'Spikes');
                elseif strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf")
                    [Channel,Row] = find(SpikeData.Position==1);
                    if length(unique(Info.ProbeInfo.xcoords))>2
                        Channel = Channel + 0.5;
                        Row = Row + 0.5;
                    end
                    line(UIAxis, Row, Channel, ...
                     'LineStyle', 'none', ...  % No line between markers
                     'Marker', 'o', ...        % Marker type
                     'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                     'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                     'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                     'Tag', 'Spikes');
                end
            else
                if length(SpikeHandles) >= numel(SpikeData.Indicie)
                    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
                        set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                        delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                    elseif strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf")
                        [Channel,Row] = find(SpikeData.Position==1);
                        if length(unique(Info.ProbeInfo.xcoords))>2
                            Channel = Channel + 0.5;
                            Row = Row + 0.5;
                        end
                        set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Row, 'YData', Channel, 'Tag', 'Spikes');
                        delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                    end
                elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
                        set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
                        line(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), ...
                         'LineStyle', 'none', ...  % No line between markers
                         'Marker', 'o', ...        % Marker type
                         'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                         'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                         'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                         'Tag', 'Spikes');
                    elseif strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf")
                        [Channel,Row] = find(SpikeData.Position==1);
                        if length(unique(Info.ProbeInfo.xcoords))>2
                            Channel = Channel + 0.5;
                            Row = Row + 0.5;
                        end
                        set(SpikeHandles, 'XData', Row, 'YData', Channel, 'Tag', 'Spikes');
                        line(UIAxis, Row(length(SpikeHandles)+1:end), Channel(length(SpikeHandles)+1:end), ...
                         'LineStyle', 'none', ...  % No line between markers
                         'Marker', 'o', ...        % Marker type
                         'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                         'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                         'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                         'Tag', 'Spikes');
                    end
                end
            end
        end % ~isempty(SpikeData.Indicies)
    elseif strcmp(SpikePlotType,"Waveforms") && strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
        
        [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("MainWindow",Info,SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);

        SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
        numspikesplotted = 0;
 
        Samplestoshowaroundspike = SampleRate*0.001; % num samples equivalent to 2ms

        %% Plot time window around spike in red
        SpikeIndiciesInRange = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
        SpikeindiciesinRangeButAtStart = SpikeData.Indicie-Samplestoshowaroundspike < 0 & SpikeData.Indicie+Samplestoshowaroundspike <= size(Data,2);
        SpikeindiciesinRangeButAtEnd = SpikeData.Indicie-Samplestoshowaroundspike > 0 & SpikeData.Indicie+Samplestoshowaroundspike > size(Data,2);

        SpikeIndicies = SpikeData.Indicie(SpikeIndiciesInRange==1);
        SpikePositions = SpikeData.Position(SpikeIndiciesInRange==1);

        for i = 1:numel(SpikePositions) % Channel
            numspikesplotted = numspikesplotted+1;
            if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike), 'YData', Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
            else 
                line(UIAxis, Time(SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike), Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
            end
        end  
        SpikeIndicies = [];
        SpikePositions = [];
        % If spike line would be smaller than window
        if ~isempty(SpikeindiciesinRangeButAtStart)
            SpikeIndicies = SpikeData.Indicie(SpikeindiciesinRangeButAtStart==1);
            SpikePositions = SpikeData.Position(SpikeindiciesinRangeButAtStart==1);
            SpikePositions = SpikePositions+1; % first channel is 0 for convenience for spike analysis, but used as index here
            for i = 1:numel(SpikePositions) % Channel
                numspikesplotted = numspikesplotted+1;
                if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                    set(SpikeHandles(numspikesplotted), 'XData', Time(1:SpikeIndicies(i)+Samplestoshowaroundspike), 'YData', Data(SpikePositions(i),1:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                else 
                    line(UIAxis, Time(1:SpikeIndicies(i)+Samplestoshowaroundspike), Data(SpikePositions(i),1:SpikeIndicies(i)+Samplestoshowaroundspike),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                end
            end  
        end
        SpikeIndicies = [];
        SpikePositions = [];
        % If spike line would be bigger than window
        if ~isempty(SpikeindiciesinRangeButAtEnd)
            SpikeIndicies = SpikeData.Indicie(SpikeindiciesinRangeButAtEnd==1);
            SpikePositions = SpikeData.Position(SpikeindiciesinRangeButAtEnd==1);
            for i = 1:numel(SpikePositions) % Channel
                numspikesplotted = numspikesplotted+1;
                if numspikesplotted <= length(SpikeHandles) && ~isempty(SpikeHandles) 
                    set(SpikeHandles(numspikesplotted), 'XData', Time(SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)), 'YData', Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                else 
                    line(UIAxis, Time(SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)), Data(SpikePositions(i),SpikeIndicies(i)-Samplestoshowaroundspike:length(Time)),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainSpikes,'Color',PlotAppearance.MainWindow.Data.Color.MainSpikes, 'Tag', 'Spikes');
                end
            end  
        end
        SpikeIndicies = [];
        SpikePositions = [];

        if length(SpikeHandles)>numspikesplotted
            delete(SpikeHandles(numspikesplotted+1:end));
        end
    end
end