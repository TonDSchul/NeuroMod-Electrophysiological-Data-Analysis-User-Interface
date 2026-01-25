function [ClimMaxValues,PreviousThreshGrids,PlotThreshGrids] = Module_MainWindow_Plot_Data(Data,Info,UIAxis,Time,Channel_Selection,PlotLineSpacing,Type,colorMap,Preprocessed,EventPlot,EventData,SampleRate,SpikePlot,SpikeData,StartIndex,StopIndex,SpikeDatatype,ChannelSpacing,PlotAppearance,SpikePlotType,ActiveChannel,frameTime,ClimMaxValues,PreviousThreshGrids,DataT2,PlotThreshGrids)

%________________________________________________________________________________________
%% Function to Plot Data in the Main Window (raw data, preprocessed data, spike data and event data)

% Gets called in the 'Organize_Prepare_Plot_and_Extract_GUI_Info' function

% Input Arguments:
% 1. Data: Channel x Time holding the raw/preprocessed data (single/double)
% 2. UIAxis: App UIAxes object designating the plot you want to plot in
% 3. Time: Vector with time points to be plotted (single/double)
% 4. Channel_Selection [Ch1,Ch2]: Vector with two values, for the start andstop channel selected in main window
% 5. PlotLineSpacing: Factor (double) to introduce spacing between channel plots
% based on GUI slider input
% 6. Type: "Static" to not plot movie but just single plot. "Movie to plot movie"
% 7. colorMap: Colormap object to be used (as many elements as channel in dataset in a nelements x 3 matrix with rgb values)
% 8.Preprocessed: if 1: Data to be plotted is downsamßpled
% 9. EventPlot: "Events" to show event plots if within time range, any other
% string like "Non" leads to no events being plotted
% 10. EventData: vector of time points (in s as double) of the event selected
% on the bottom right of the main window. Only needed if EventPlot = "Events"
% 11. SampleRate as double in Hz
% 12. SpikePlot: string, "Spikes" when plotting spikes, some other string
% like "non" when not
% 13. SpikeData: structure with spike indicies and positions (all spikes)
% 14. StartIndex: First idicie plotted in main plot in samples as double
% 15. StopIndex: Last idicie plotted in main plot in samples as double
% 16. SpikeDatatype: Either "Internal" when plotting internal spike data or
% "Kilosort" when plotting spikes analysed with kilosort Or "SpikeInterface"
% 17. ChannelSpacing: as double in um
% 18. PlotAppearance: structure holding indo about the appearance of plots
% the user selected
% 19. SpikePlotType: string, either "Points" or "Waveforms" to specifiy how
% spikes should be plotted when the user selected them 
% 20. frameTime: double, Time in seconds of each frame based on selected
% frame rate
% 21. CurrentClim: double vector, lower and upper clim of max values so far

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% Scale all channel lines so that they are as far apart as specified in main window
% (Channelspacing)

if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
    for i = 1:size(Data,1)     
        Data(i, :) = Data(i, :) - (i - 1) * PlotLineSpacing;
    end
    YMaxLimitsMultipeERP = max(Data,[],"all");
    YMinLimitsMultipeERP = min(Data,[],"all");
    if size(Data,1)>1
        ylim(UIAxis, [YMinLimitsMultipeERP,YMaxLimitsMultipeERP]);
    end
    Depth = [];
else
    Depth = 0:ChannelSpacing:(size(Data,1)-1)*ChannelSpacing;
    YMinLimitsMultipeERP = Depth(1);
    YMaxLimitsMultipeERP = Depth(end);
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
        ylim(UIAxis, [1,length(unique(Info.ProbeInfo.ycoords))]);
    else
        ylim(UIAxis, [Depth(1),Depth(end)]);
    end
end

%% Predefine x and y lims and title before plotting to increase performance!
if Time(1) ~= Time(end)
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
        if length(unique(Info.ProbeInfo.xcoords)) > 1
            xlim(UIAxis, [1,length(unique(Info.ProbeInfo.xcoords))]);
        end
    else
        xlim(UIAxis, [Time(1),Time(end)]);
    end
else
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
        if length(unique(Info.ProbeInfo.xcoords)) > 1
            xlim(UIAxis, [1,length(unique(Info.ProbeInfo.xcoords))]);
        end
    end
end

if size(Data,1)>1
    if ~isempty(UIAxis.YTickLabel)
        if ~isempty(UIAxis.YTickLabel{1})
            set(UIAxis,'yticklabel',{[]});
            ylabel(UIAxis,PlotAppearance.MainWindow.Data.MainYLabel)
        end
    end
end

if ~strcmp(UIAxis.XLabel.String,PlotAppearance.MainWindow.Data.MainXLabel)
    xlabel(UIAxis,PlotAppearance.MainWindow.Data.MainXLabel)
end
% Manage Title
if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
    if Preprocessed == 0
        title(UIAxis, strcat(PlotAppearance.MainWindow.Data.Title.Raw," at Time: ",num2str(Time(1)),"s"));
    elseif Preprocessed == 1 
        title(UIAxis, strcat(PlotAppearance.MainWindow.Data.Title.Preprocessed," at Time: ",num2str(Time(1)),"s"));
    end
else
    if Preprocessed == 0
        if ~strcmp(UIAxis.Title.String,PlotAppearance.MainWindow.Data.Title.Raw)
            title(UIAxis, PlotAppearance.MainWindow.Data.Title.Raw);
        end
    elseif Preprocessed == 1 
        if ~strcmp(UIAxis.Title.String,PlotAppearance.MainWindow.Data.Title.Preprocessed)
            title(UIAxis, PlotAppearance.MainWindow.Data.Title.Preprocessed);
        end
    end
end
%% Select the current Colormap (tempcolorMapset set in Main window of GUI when colormap setting changed)

EventIndicies = 0;

if strcmp(EventPlot,"Events")
    %% Downsampling: Events handled seperately. This is bc. event times are save in respect to raw data time.
    %% Time points saved in there are therefore not necessary the same as in the downsampled time vector.
    % Therefore, closest value of the event time to the downsampled
    % time vector has to be found. (When eventtime in range of downsampled time)

    TempEventIndicies = EventData >= StartIndex & EventData <= StopIndex;
    EventSamples = EventData(TempEventIndicies)-(StartIndex-1);

    EventIndicies = zeros(size(Time));
    EventIndicies(EventSamples) = 1;

    EventIndexNr = find(TempEventIndicies==1);
else
    EventIndexNr=[];
end

%% Start Plot
% If Not movie mode:
if isempty(PreviousThreshGrids)
    PreviousThreshGrids.T1 = [];
    PreviousThreshGrids.T2 = [];
else
    if ~isfield(PreviousThreshGrids,'T1')
        PreviousThreshGrids.T1 = [];
        PreviousThreshGrids.T2 = [];
    end
end

if strcmp(Type,"Static")
    % All objects being plotted are lines. The following code captures all the lines
    % plotted to keep track of how much is plotted and to update already
    % created line objects instead of creating new ones every time.
    
    %% First Check and delete unneccesary plot handles
  
    if sum(EventIndicies) == 0
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        delete(Eventline_handles(1:end));  
    else
        Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        if length(Eventline_handles) > sum(EventIndicies)
            delete(Eventline_handles(sum(EventIndicies)+1:end)); 
            Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
        end
    end

    lineHandles = findobj(UIAxis, 'Tag', 'Data');
    
    ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');

    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        delete(lineHandles);
        if length(ImageScChannel_handles)>1
            delete(ImageScChannel_handles(2:end));
            ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
        end
    else
        if ~isempty(ImageScChannel_handles)
            delete(ImageScChannel_handles);
            ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
        end
    end
    
    %% Create Surf Grid
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
        % create matrix with data for each channel at proper channel
        % location
        [Data,~] = Module_MainWindow_Convert_DataMatrix_Into_Grid(Info,Data,PlotAppearance,SpikeData,"DataMatrix",Channel_Selection,Type);       
        
        if strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
            [PreviousThreshGrids,PlotThreshGrids] = Module_MainWindow_Axon_Viewer(Data,PreviousThreshGrids,Info,Type,PlotAppearance,PlotThreshGrids);
            Data = PlotThreshGrids; 

            if isfield(PreviousThreshGrids,'SpikeChannelSelected')
                % PrevValue = PreviousThreshGrids.SpikeChannelSelected;
                % PreviousThreshGrids = [];
                % PreviousThreshGrids.SpikeChannelSelected = PrevValue;
            else
                PreviousThreshGrids = [];
                PlotThreshGrids = [];
            end

            
        end
    end

    %% Plot Channel Data
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
        if isempty(lineHandles) 
            % Plot for the first time
            lines = line(UIAxis,Time,Data,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
            % ColorMap
            for i = 1:size(Data,1)
                lines(i).Color = colorMap(i, :);
            end
            UIAxis.XLabel.Color = [0 0 0];
            UIAxis.YLabel.Color = [0 0 0];       
            UIAxis.YColor = 'k';  
            UIAxis.XColor = 'k';  
            UIAxis.Title.Color = 'k';  
        else
            if length(lineHandles) >= size(Data,1)
                for i = 1:size(Data,1)
                    set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                end
                delete(lineHandles(size(Data,1)+1:end));
                % ColorMap
                for i = 1:size(Data,1)
                    lines(i).Color = colorMap(i, :);
                end
            elseif length(lineHandles) < size(Data,1)

                for i = 1:length(lineHandles)
                    set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                    lines(i)=lineHandles(i);
                end
                % Plot rest of the lines
                lines(i+1:size(Data,1)) = line(UIAxis,Time,Data(i+1:end,:),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data');
                % ColorMap
                for i = 1:size(Data,1)
                    lines(i).Color = colorMap(i, :);
                end
            end
        end
    end
    
    %% Plot surf, imagsc, mesh
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
        ClimMaxValues = Module_MainWindow_Plot_Imagesc_Surf_Mesh(Data,Info,Time,Depth,ActiveChannel,UIAxis,ClimMaxValues,PlotAppearance,ImageScChannel_handles);
    end

    % Plot Event Indices and Label for event number
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagsc")
        Module_MainWindow_Plot_Events_and_Label(Info,Data,Time,EventIndicies,UIAxis,EventPlot,EventIndexNr,Eventline_handles,YMinLimitsMultipeERP,YMaxLimitsMultipeERP,Channel_Selection,PlotAppearance)
    end

    %% Plot Toolbox internally computed Spike Data
    Module_MainWindow_Plot_Internal_Spikes(Data,Info,Time,SpikePlot,SpikeDatatype,SpikePlotType,SpikeData,ActiveChannel,Channel_Selection,UIAxis,ChannelSpacing,PlotAppearance)

    %% Plot loaded Kilosort Spikes
    if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Kilosort") || strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"SpikeInterface")
        if ~isempty(SpikeData.Indicie)
            
            [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("MainWindow",Info,SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);

            SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
            
            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
                if str2double(Info.ProbeInfo.NrRows) == 1
                    %% If for example channel 10-20 are selected, Starting depth is no longer 0. Therefore, Kilosort Spike positions have to be adjusted so that the the line plotted corresponds to 0 um depth
                    %range_Positions = (Channel_Selection(2)*ChannelSpacing)-(Channel_Selection(1)*ChannelSpacing);
                    
                    range_Positions = (length(Channel_Selection)-1)*ChannelSpacing;
    
                    %% Scale and Plot Spike Positions
                    for j = 1:numel(SpikeData.Indicie) 
                        %To Plot sorted Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                        % Calculate the range of both vectors
                        range_ScalingEachChannel = min(double(Data(:,SpikeData.Indicie(j)))) - max(double(Data(:,SpikeData.Indicie(j))));
                        % Compute the scaling factor
                        SpikeData.Position(j) = SpikeData.Position(j) ./ (range_Positions/range_ScalingEachChannel);                    
                    end
                else
                     %% Scale and Plot Spike Positions
                    for nspikes = 1:numel(SpikeData.Indicie) 
                        SpikeData.Position(nspikes) = Data(SpikeData.Position(nspikes),SpikeData.Indicie(nspikes));
                    end
                end
            else%imagsc plot
                SpikeData.Position = (round(SpikeData.Position/ChannelSpacing))*ChannelSpacing;
            end
         
            if isempty(SpikeHandles)
                line(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, ...
                 'LineStyle', 'none', ...  % No connecting lines between markers
                 'Marker', 'o', ...        % Marker type
                 'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                 'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                 'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                 'Tag', 'Spikes');
            else
                if length(SpikeHandles) >= numel(SpikeData.Indicie)
                    set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                    delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                    set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');

                    line(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), ...
                     'LineStyle', 'none', ...  % No connecting lines between markers
                     'Marker', 'o', ...        % Marker type
                     'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                     'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                     'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                     'Tag', 'Spikes');
                end
            end      
        end
    end 
end


if strcmp(Type,"Movie")
    
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
        InterpolatedFrames = 3;
    else
        InterpolatedFrames = 1;
    end

    for nInterpolatedFrames = InterpolatedFrames
            tic % Leave here for framrate!!!

            %% First Check and delete unneccesary plot handles
          
            if sum(EventIndicies) == 0
                Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
                delete(Eventline_handles(1:end));  
            else
                Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
                if length(Eventline_handles) > sum(EventIndicies)
                    delete(Eventline_handles(sum(EventIndicies)+1:end)); 
                    Eventline_handles = findobj(UIAxis,'Type', 'line', 'Tag', 'Events');
                end
            end
        
            lineHandles = findobj(UIAxis, 'Tag', 'Data');
            
            ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
        
            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
                delete(lineHandles);
                if length(ImageScChannel_handles)>1
                    delete(ImageScChannel_handles(2:end));
                    ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
                end
            else
                if ~isempty(ImageScChannel_handles)
                    delete(ImageScChannel_handles);
                    ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
                end
            end
            
            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
                % create matrix with data for each channel at proper channel
                % location
                [DataT1,~] = Module_MainWindow_Convert_DataMatrix_Into_Grid(Info,Data,PlotAppearance,SpikeData,"DataMatrix",Channel_Selection,Type);
                [DataT2,~] = Module_MainWindow_Convert_DataMatrix_Into_Grid(Info,DataT2,PlotAppearance,SpikeData,"DataMatrix",Channel_Selection,Type);
            end
           
            %% Plot Channel Data
            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
                if isempty(lineHandles) 
                    % Plot for the first time
                    lines = line(UIAxis,Time,Data,'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                    % ColorMap
                    for i = 1:size(Data,1)
                        lines(i).Color = colorMap(i, :);
                    end
                    UIAxis.XLabel.Color = [0 0 0];
                    UIAxis.YLabel.Color = [0 0 0];       
                    UIAxis.YColor = 'k';  
                    UIAxis.XColor = 'k';  
                    UIAxis.Title.Color = 'k';  
                else
                    if length(lineHandles) >= size(Data,1)
                        for i = 1:size(Data,1)
                            set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                        end
                        delete(lineHandles(size(Data,1)+1:end));
                        % ColorMap
                        for i = 1:size(Data,1)
                            lines(i).Color = colorMap(i, :);
                        end
                    elseif length(lineHandles) < size(Data,1)
        
                        for i = 1:length(lineHandles)
                            set(lineHandles(i), 'XData', Time, 'YData', Data(i,:), 'Color', colorMap(i, :), 'Tag', 'Data','LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData);
                            lines(i)=lineHandles(i);
                        end
                        % Plot rest of the lines
                        lines(i+1:size(Data,1)) = line(UIAxis,Time,Data(i+1:end,:),'LineWidth',PlotAppearance.MainWindow.Data.LineWidth.MainData, 'Tag', 'Data');
                        % ColorMap
                        for i = 1:size(Data,1)
                            lines(i).Color = colorMap(i, :);
                        end
                    end
                end
            end
            
            %% Plot surf, imagsc, mesh
            if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer") 
                nInterp = PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.TimeInterpol;

                for nInterpolateFrames = 1:nInterp
                    ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
                    delete(ImageScChannel_handles(1:end));
                    ImageScChannel_handles = findobj(UIAxis,'Tag', 'ImageScChannel');
                    
                    alpha = nInterpolateFrames / (nInterp + 1);
                    Data = (1-alpha)*DataT1 + alpha*DataT2;

                    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
                        [PreviousThreshGrids,PlotThreshGrids] = Module_MainWindow_Axon_Viewer(Data,PreviousThreshGrids,Info,Type,PlotAppearance,PlotThreshGrids);
                        Data = PlotThreshGrids;
                    end

                    ClimMaxValues = Module_MainWindow_Plot_Imagesc_Surf_Mesh(Data,Info,Time,Depth,ActiveChannel,UIAxis,ClimMaxValues,PlotAppearance,ImageScChannel_handles);
                    pause(PlotAppearance.MainWindow.Data.AdditionalPlotDelay)
                end

            elseif strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc") 
                ClimMaxValues = Module_MainWindow_Plot_Imagesc_Surf_Mesh(Data,Info,Time,Depth,ActiveChannel,UIAxis,ClimMaxValues,PlotAppearance,ImageScChannel_handles);
            end

            % Plot Event Indices and Label for event number
            Module_MainWindow_Plot_Events_and_Label(Info,Data,Time,EventIndicies,UIAxis,EventPlot,EventIndexNr,Eventline_handles,YMinLimitsMultipeERP,YMaxLimitsMultipeERP,Channel_Selection,PlotAppearance)
        
            %% Plot Toolbox internally computed Spike Data
            Module_MainWindow_Plot_Internal_Spikes(Data,Info,Time,SpikePlot,SpikeDatatype,SpikePlotType,SpikeData,ActiveChannel,Channel_Selection,UIAxis,ChannelSpacing,PlotAppearance)
        
            %% Plot loaded Kilosort Spikes
            if strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"Kilosort") || strcmp(SpikePlot,"Spikes") && strcmp(SpikeDatatype,"SpikeInterface")
                if ~isempty(SpikeData.Indicie)
                    
                    [SpikeData.Indicie,SpikeData.Position,~] = Continous_Spikes_Delete_Spikes_Not_In_ChannelRange("MainWindow",Info,SpikeData.Indicie,SpikeData.Position,ChannelSpacing,ActiveChannel,SpikeDatatype,Info.ProbeInfo.ActiveChannel);
        
                    SpikeHandles = findobj(UIAxis, 'Type', 'line', 'Tag', 'Spikes');
                    
                    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Individual Lines")
                        if str2double(Info.ProbeInfo.NrRows) == 1
                            %% If for example channel 10-20 are selected, Starting depth is no longer 0. Therefore, Kilosort Spike positions have to be adjusted so that the the line plotted corresponds to 0 um depth
                            %range_Positions = (Channel_Selection(2)*ChannelSpacing)-(Channel_Selection(1)*ChannelSpacing);
                            
                            range_Positions = (length(Channel_Selection)-1)*ChannelSpacing;
            
                            %% Scale and Plot Spike Positions
                            for j = 1:numel(SpikeData.Indicie) 
                                %To Plot sorted Spikes, Spike Positions are in um. So they have to be scaled to the plot (app.PlotLineSpacing)
                                % Calculate the range of both vectors
                                range_ScalingEachChannel = min(double(Data(:,SpikeData.Indicie(j)))) - max(double(Data(:,SpikeData.Indicie(j))));
                                % Compute the scaling factor
                                SpikeData.Position(j) = SpikeData.Position(j) ./ (range_Positions/range_ScalingEachChannel);                    
                            end
                        else
                             %% Scale and Plot Spike Positions
                            for nspikes = 1:numel(SpikeData.Indicie) 
                                SpikeData.Position(nspikes) = Data(SpikeData.Position(nspikes),SpikeData.Indicie(nspikes));
                            end
                        end
                    else%imagsc plot
                        SpikeData.Position = (round(SpikeData.Position/ChannelSpacing))*ChannelSpacing;
                    end
                 
                    if isempty(SpikeHandles)
                        line(UIAxis, Time(SpikeData.Indicie), SpikeData.Position, ...
                         'LineStyle', 'none', ...  % No connecting lines between markers
                         'Marker', 'o', ...        % Marker type
                         'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                         'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                         'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                         'Tag', 'Spikes');
                    else
                        if length(SpikeHandles) >= numel(SpikeData.Indicie)
                            set(SpikeHandles(1:numel(SpikeData.Indicie)), 'XData', Time(SpikeData.Indicie), 'YData', SpikeData.Position, 'Tag', 'Spikes');
                            delete(SpikeHandles(numel(SpikeData.Indicie)+1:end));
                        elseif length(SpikeHandles) < numel(SpikeData.Indicie)
                            set(SpikeHandles, 'XData', Time(SpikeData.Indicie(1:length(SpikeHandles))), 'YData', SpikeData.Position(1:length(SpikeHandles)), 'Tag', 'Spikes');
        
                            line(UIAxis, Time(SpikeData.Indicie(length(SpikeHandles)+1:end)), SpikeData.Position(length(SpikeHandles)+1:end), ...
                             'LineStyle', 'none', ...  % No connecting lines between markers
                             'Marker', 'o', ...        % Marker type
                             'MarkerFaceColor', PlotAppearance.MainWindow.Data.Color.MainSpikes, ...
                             'MarkerEdgeColor', 'k', ... % Marker edge color (black)
                             'MarkerSize', PlotAppearance.MainWindow.Data.LineWidth.MainSpikes + 1.5, ...
                             'Tag', 'Spikes');
                        end
                    end      
                end
            end  
        
            drawnow;
        
            % limit time for new plot so that its not updating too fast and
            % according to framerate
            plottime = toc;
            if ~strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") && ~strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") && ~strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
                pause(PlotAppearance.MainWindow.Data.AdditionalPlotDelay)
            
                % if plottime<frameTime
                %     timeremaining = frameTime-plottime;
                %     pause(timeremaining);
                % end
            end
    end
end


if size(Data,1) == 1
    if min(Data) ~= max(Data)
        ylim(UIAxis,[min(Data) max(Data)])
    end
end