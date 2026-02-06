function [CSDClim,Trialplot,Meanplot,Eventplot,CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(Data,Figure,Figure2,EventRelatedData,EventTime,DataChannelSelected,CSD,rgbcolormap,PlotLineSpacing,Type,TwoORThreeD,CurrentPlotData,PlotAppearance,ERPChannel,DataType,SingleChannelPlotType,EventNr,PreservePlotChannelLocations,BaselineNormalize,NormalizationWindow,GeneralPlotType)

%________________________________________________________________________________________
%% Function to calculate and plot ERP and CSD for event analysis windows

% Called when clicking on ERP or CSD button in event related signal
% analysis window 

% Inputs: 
% 1. Data: data strcuture of main window, to simplfy inputs later on?!
% 2.Figure: axis handle to figure you want to plot in -- CSD plot or ERP
% all trials plot with mean as black line
% 3.Figure2: axis handle to figure you want to plot in -- ERP
% all channel plot with mean for each channel
% 4. EventRelatedData: nchannel x nevents x ntimepoints single matrix
% containing event related data
% 5. EventTime: double time vector of events with one time in seconds for
% each time point of the EventRelatedData variable (with negativ pre event time)
% 6. DataChannelSelected: 1 x 2 double with channelrange to be plotted;
% [1,10] means channel 1 to 10 
% 7. CSD: structure containing infos for csd: CSD.ChannelSpacing;
% CSD.HammWindow --> IMPORTANT: When empty: ERP plotted, when plopulated: CSD is
% plotted!!! this structure comes from the
% 'Event_Module_Organize_TF_Window_Inputs' function
% 8. rgbcolormap: nplots x 3 double matrix with rgb values for each line
% plotted (only for plotting multiple channel erp's with consistent colors)
% 9. PlotLineSpacing: factor as double that determines the spacing between
% plotted erp lines of different channel
% 10. Type: Detmerines what is plotted, Options: 'SingleERPOnly' for just
% erp plots of one channel over all events OR 'MultipleERPOnly' for just
% erp plot of each channel OR 'All' for both plots
% 11. TwoORThreeD: string, either "TwoD" or "ThreeD" to show plot in 2 or 3
% dimensions
% 12. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 13. PlotAppearance: structure holding info about plot appearances the user
% might have modified.
% 14. ERPChannel: char, Channel for ERP Plot on top
% 15. DataType: char, either 'Raw Event Related Data' or 'Preprocessed Event Related Data'
% 16. SingleChannelPlotType: ERP plot type of single channel plot on top.
% if 0: all trials in grey lines, mean in black line. 0: imagesc plot with
% every trial and ERP overlayed
% 17. EventNr: double, nr of trigger shown. So that in imagsc plot y axis labels
% can be spaced farther if there are many trigger
% 18.PreservePlotChannelLocations: double, 1 or 0 whether to preserve
% original spacing between active channel (in case of inactiove islands between active channel)
% 19. BaselineNormalize: logical, 1 or 0 whehter to normlaitze
% 20. NormalizationWindow: comma separated char, from to like '-0.2,0' in
% seconds
% 21. GeneralPlotType: char, if individual lines or gird trace view is
% plotted

% Outputs:
% 1. CSDClim
% 2. Trialplot: Handle to single trials of ERP plot for single channel
% 3. Meanplot: Handle to ERP of ERP plot for single channel
% 4. Eventplot: Handle to plotted event line of plots
% 5. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% For ERP per Channel plot: If i.e. channel 1-10 not plotted, index of those lines is still 1:10.
% therefore colormap index has to be real channels

Trialplot = [];
Meanplot = [];
Eventplot = [];
CSDClim = [];

% Extract Cell with eventindicies of selected event channel
OriginalDataChannelSelected = DataChannelSelected;

%% For all Channel ERP
[DataChannelSelected] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,DataChannelSelected,'MainPlot');

%% PLOT ERP
if isempty(CSD)
    if strcmp(Type,'All') || strcmp(Type,'SingleERPOnly') 
        if BaselineNormalize
            EventRelatedData = Event_Module_Baseline_Normalize(Data,EventRelatedData,NormalizationWindow,EventTime,"ERP");
        end
    end

    if strcmp(GeneralPlotType,"IndividualLines")
        if strcmp(Type,'SingleERPOnly') || strcmp(Type,'All')
            CurrentPlotData = Event_Module_ERP_IndividualLines(Data,EventRelatedData,EventNr,EventTime,Figure,DataType,ERPChannel,SingleChannelPlotType,PlotAppearance,CurrentPlotData);
        end
        if strcmp(Type,'MultipleERPOnly') || strcmp(Type,'All')
            CurrentPlotData = Event_Module_ERP_MultipleLines(Data,EventRelatedData,PlotLineSpacing,EventTime,Figure2,Type,DataChannelSelected,rgbcolormap,PlotAppearance,CurrentPlotData);
        end
    else
        
    end

%% Plot CSD
else

    if strcmp(TwoORThreeD,"ThreeD")
        cla(Figure);
    end

    if size(EventRelatedData,2) == 0
        msgbox("No Events for this Channel found");
        return;
    end

    if length(DataChannelSelected) < 3
        msgbox("Error: At least 3 channel required to compute CSD! Returning.")
        return;
    end
        
    DatatoPlot = squeeze(mean(EventRelatedData(DataChannelSelected,:,:),2,'omitnan'));
    
    [csd,~] = Analyse_Main_Window_Compute_CSD(DatatoPlot',CSD.ChannelSpacing,CSD.HammWindow,Data,DataType);
    
    %baseline normalize csd result
    if BaselineNormalize
        csd = Event_Module_Baseline_Normalize(Data,csd,NormalizationWindow,EventTime,"CSD");
    end

    if str2double(Data.Info.ProbeInfo.VertOffset) ~= 0
        CSD.ChannelSpacing = unique(diff(Data.Info.ProbeInfo.ycoords));
    else
        CSD.ChannelSpacing = CSD.ChannelSpacing;
    end

    ds = 0:CSD.ChannelSpacing:(length(OriginalDataChannelSelected)-1)*CSD.ChannelSpacing;
    
    DepthDiff = (ds(2) - ds(1))/2;

    %% Plot 
    cmlimscsd = abs([min(csd,[],'all') max(csd,[],'all')]);
    [~,cmlimscsdmax] = max(cmlimscsd);

    CSDClim(1) = -cmlimscsd(cmlimscsdmax);
    CSDClim(2) = cmlimscsd(cmlimscsdmax);

    if strcmp(TwoORThreeD,"ThreeD")
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
    
        if length(PowerDepth2D_handles)>1
            delete(PowerDepth2D_handles(2:end));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        elseif length(PowerDepth3D_handles)>1
            delete(PowerDepth3D_handles(2:end));
            PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
        end
    
        if length(PowerDepth3D_handles)+length(PowerDepth2D_handles)==1
            delete(PowerDepth3D_handles(:));
            delete(PowerDepth2D_handles(:));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
            PowerDepth3D_handles = findobj(Figure, 'Tag', 'PowerDepth3D');
        end
    
        if isempty(PowerDepth2D_handles) || isempty(PowerDepth3D_handles)
            %3D
            surf(Figure,EventTime,ds(1:size(csd,2)),csd','EdgeColor', 'none', 'Tag','PowerDepth3D')
            %2D
            % % 2D Plot
        else
            %3D
            set(PowerDepth3D_handles(1),'XData',EventTime,'YData',ds(1:size(csd,2)),'CData',csd','ZData',csd','EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            %2D
            % 2D Plot
        end
    
        %imagesc(Figure,Time,ydata,mnLFP)
        view(Figure,45,45);
        box(Figure, 'off');
        grid(Figure, 'off');
    elseif strcmp(TwoORThreeD,"TwoD")
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        if length(PowerDepth2D_handles)>1
            delete(PowerDepth2D_handles(2:end));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        end

        if isempty(PowerDepth2D_handles)
            % 2D Plot
            min_z = 0;
            imagesc(Figure,EventTime,ds, csd', 'Tag', 'PowerDepth2D');            
        else
            min_z = 0;
            set(PowerDepth2D_handles(1),'XData',EventTime,'YData',ds, ...
            'CData', csd', 'Tag', 'PowerDepth2D');
        end
    end
   

    %% Plot Event line
    Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
    if length(Event_handles)>1
        delete(Event_handles(2:end));
    end

    if strcmp(TwoORThreeD,"TwoD")
        if isempty(Event_handles)
            eventLine = line(Figure,[0, 0],[ds(1)-DepthDiff,ds(end)+DepthDiff],'Color',PlotAppearance.CSDWindow.TriggerColor,'LineWidth',PlotAppearance.CSDWindow.TriggerLineWidth, 'Parent', Figure, 'Tag', 'Event');
        else
            set(Event_handles(1), 'XData', [0, 0], 'YData', [ds(1)-DepthDiff,ds(end)+DepthDiff], 'Parent', Figure,'LineWidth',PlotAppearance.CSDWindow.TriggerLineWidth,'Color',PlotAppearance.CSDWindow.TriggerColor, 'Tag', 'Event');
            eventLine = Event_handles(1);
        end
    elseif strcmp(TwoORThreeD,"ThreeD")
        % Define the Y and Z ranges
        Y = [ds(1)-DepthDiff, ds(end)+DepthDiff];
        Z = [min(csd,[],'all'), max(csd,[],'all')];  
        
        % Create a plane through Y and Z
        [YGrid, ZGrid] = meshgrid(Y, Z);
        
        XGrid = zeros(size(YGrid));
        if isempty(Event_handles)
            eventLine=surf(Figure,XGrid, YGrid, ZGrid, 'FaceColor', PlotAppearance.CSDWindow.TriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
        else
            set(Event_handles(1), 'XData',XGrid,'YData', YGrid,'ZData', ZGrid, 'FaceColor', PlotAppearance.CSDWindow.TriggerColor, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
            eventLine = Event_handles(1);
        end
    end
    
    % Bring the event line to the front
    uistack(eventLine, 'top');
    
    % Add legend only once
    if isempty(findobj(Figure, 'Type', 'legend'))
        % Create legend with imagesc and event line
        legendHandle = legend(eventLine, {'Trigger'});
        set(legendHandle, 'HandleVisibility', 'off');
    end

    xlim(Figure,[EventTime(1),EventTime(end)]);
    
    ylim(Figure,[ds(1)-DepthDiff,ds(end)+DepthDiff]);
    clim(Figure,CSDClim);
    set(Figure,'YDir','reverse');
    title(Figure,"Event Related Current Source Density Analysis")
    xlabel(Figure,PlotAppearance.CSDWindow.XLabel)
    ylabel(Figure,PlotAppearance.CSDWindow.YLabel) 
    cbar_handle=colorbar('peer',Figure,'location','EastOutside');
    cbar_handle.Label.String = PlotAppearance.CSDWindow.CLabel;
    cbar_handle.Label.Rotation = 270;
    cbar_handle.Color = 'k';  
    cbar_handle.Label.Color = 'k';        % Sets the color of the label text
    Figure.XLabel.Color = [0 0 0];
    Figure.YLabel.Color = [0 0 0];       
    Figure.YColor = 'k';  
    Figure.XColor = 'k';  
    Figure.Title.Color = 'k';  
    Figure.Box ="off";

    %% save plotted data in case user wants to save 
    % Save data main plot -- channel spike rate
    
    CurrentPlotData.CSDXData = EventTime;
    CurrentPlotData.CSDYData = ds;
    CurrentPlotData.CSDCData = csd';
    CurrentPlotData.CSDType = strcat("Current Source Density");
    CurrentPlotData.CSDXTicks = Figure.XTickLabel;
    
    Utility_Set_YAxis_Depth_Labels(Data,Figure,[],OriginalDataChannelSelected,0)

end