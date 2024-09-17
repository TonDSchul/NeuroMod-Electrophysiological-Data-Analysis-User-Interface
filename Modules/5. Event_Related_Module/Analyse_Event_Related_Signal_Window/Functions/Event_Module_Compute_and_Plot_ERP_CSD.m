function [CSDClim,Trialplot,Meanplot,Eventplot,CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(Data,Figure,Figure2,EventRelatedData,EventTime,DataChannelSelected,CSD,rgbcolormap,PlotLineSpacing,Type,TwoORThreeD,CurrentPlotData)

%________________________________________________________________________________________
%% Function to calculate and plot ERP and CSD for event analysis windows

% Called when clicking on ERP or CSD button in event related signal
% analysis window 

% Inputs: 
% 1.Figure: axis handle to figure you want to plot in -- CSD plot or ERP
% all trials plot with mean as black line
% 2.Figure2: axis handle to figure you want to plot in -- ERP
% all channel plot with mean for each channel
% 3. EventRelatedData: nchannel x nevents x ntimepoints single matrix
% containing event related data
% 4. EventTime: double time vector of events with one time in seconds for
% each time point of the EventRelatedData variable (with negativ pre event time)
% 5. DataChannelSelected: 1 x 2 double with channelrange to be plotted;
% [1,10] means channel 1 to 10 
% 6. CSD: structure containing infos for csd: CSD.ChannelSpacing;
% CSD.HammWindow --> IMPORTANT: When empty: ERP plotted, when plopulated: CSD is
% plotted!!! this structure comes from the
% 'Event_Module_Organize_TF_Window_Inputs' function
% 7. rgbcolormap: nplots x 3 double matrix with rgb values for each line
% plotted (only for plotting multiple channel erp's with consistent colors)
% 8. PlotLineSpacing: factor as double that determines the spacing between
% plotted erp lines of different channel
% 9. Type: Detmerines what is plotted, Options: 'SingleERPOnly' for just
% erp plots of one channel over all events OR 'MultipleERPOnly' for just
% erp plot of each channel OR 'All' for both plots
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

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

NumEvents = size(EventRelatedData,2);

%% PLOT ERP
if isempty(CSD)

    if strcmp(Type,'SingleERPOnly') || strcmp(Type,'All')
        
        if size(EventRelatedData,2) == 0
            msgbox("No Events for this Channel found");
            return;
        end

        if DataChannelSelected(1) == DataChannelSelected(2) 
            DataLinestoPlot = squeeze(EventRelatedData(DataChannelSelected(1),:,:));
            ylim(Figure,[min(DataLinestoPlot,[],'all') max(DataLinestoPlot,[],'all')]);   
        else
            DataLinestoPlot = squeeze(mean(EventRelatedData(DataChannelSelected(1):DataChannelSelected(2),:,:),1));
            ylim(Figure,[min(squeeze(mean(EventRelatedData(DataChannelSelected(1):DataChannelSelected(2),:,:),1)),[],'all') max(squeeze(mean(EventRelatedData(DataChannelSelected(1):DataChannelSelected(2),:,:),1)),[],'all')]);    
        end
    
        xlim(Figure,[EventTime(1) EventTime(end)]);
        xlabel(Figure,"Time [s]")
        ylabel(Figure,"Event Related Potential [mV]")
        title(Figure,strcat("Event Related Potential Channel: ",num2str(DataChannelSelected)));
            
        TrialLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'TrialLines');
    
        %% Plot Trials
        % Delete handles if too many (i.e. the user reduced the amount of events/trials shown)

        Trialplot = [];

        if ~isempty(TrialLinesHandles)
            if length(TrialLinesHandles) > size(EventRelatedData,2)
                delete(TrialLinesHandles(size(EventRelatedData,2)+1:end));
                TrialLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'TrialLines');
            end
        end
        
        if isempty(TrialLinesHandles)
            if size(EventRelatedData,2) == 1
                Trialplot = line(Figure,EventTime,squeeze(mean(EventRelatedData(DataChannelSelected(1):DataChannelSelected(2),:,:),1))', 'Color', [0.75 0.75 0.75],'Tag','TrialLines');
            else
                Trialplot = line(Figure,EventTime,squeeze(mean(EventRelatedData(DataChannelSelected(1):DataChannelSelected(2),:,:),1)), 'Color', [0.75 0.75 0.75],'Tag','TrialLines');
            end
        else
            for i = 1:size(EventRelatedData,2)
                if i <= length(TrialLinesHandles)
                    set(TrialLinesHandles(i), 'YData', squeeze(mean(EventRelatedData(DataChannelSelected(1):DataChannelSelected(2),i,:),1))', 'Color', [0.75 0.75 0.75], 'Tag', 'TrialLines');
                    Trialplot = TrialLinesHandles(i);
                else
                    Trialplot = line(Figure,EventTime,squeeze(mean(EventRelatedData(DataChannelSelected(1):DataChannelSelected(2),i,:),1))', 'Color', [0.75 0.75 0.75],'Tag','TrialLines');
                end
            end
        end
       
        if size(EventRelatedData,2) > 1 % If just one trial: no mean has to be plotted
            %% Plot Mean
            MeanLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'MeanLines');
        
            if ~isempty(MeanLinesHandles)
                if length(MeanLinesHandles) > 1
                    delete(MeanLinesHandles(2:end));
                    MeanLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'MeanLines');
                end
            end
        
            if isempty(MeanLinesHandles)
                Meanplot = line(Figure,EventTime,mean(DataLinestoPlot,1),'Color','k','LineWidth',2,'Tag','MeanLines');
            else
                set(MeanLinesHandles(1), 'YData', mean(DataLinestoPlot,1),'Color','k','LineWidth',2,'Tag','MeanLines');
                Meanplot = MeanLinesHandles(1);
            end
           
            %% Plot Event Line
            EventLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'EventLines');
            
            if ~isempty(EventLinesHandles)
                if length(EventLinesHandles) > 1
                    delete(EventLinesHandles(2:end));
                    EventLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'EventLines');
                end
            end
            
            if isempty(EventLinesHandles)
                Eventplot = line(Figure,[0,0],[min(min(DataLinestoPlot)) max(max(DataLinestoPlot))],'Color','r','LineWidth',2,'Tag','EventLines');
            else
                set(EventLinesHandles(:), 'XData',[0,0],'YData', [min(min(DataLinestoPlot)) max(max(DataLinestoPlot))],'Color','r','LineWidth',2,'Tag','EventLines');
                Eventplot = EventLinesHandles(1);
            end

            % Bring Event Line to the front
            uistack(Meanplot, 'top');
            uistack(Eventplot, 'top');
            
            % Add legend only once
            if isempty(findobj(Figure, 'Type', 'legend'))
                % Create legend and then set its 'HandleVisibility' to 'off'
                legendHandle = legend([Trialplot(1), Meanplot, Eventplot], {'Trials/Events', 'ERP', 'Trigger'});
                set(legendHandle, 'HandleVisibility', 'off');
            end

        else % If no mean plotted bc only one trial selected
            MeanLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'MeanLines');
            delete(MeanLinesHandles(:));
        end

        %% save plotted data in case user wants to save 
        % Save data main plot -- channel spike rate
        
        CurrentPlotData.ERPoverEventsXData = EventTime;
        CurrentPlotData.ERPoverEventsYData = DataLinestoPlot;
        CurrentPlotData.ERPoverEventsCData = [];
        CurrentPlotData.ERPoverEventsType = strcat("Event Related Potential over Events");

        CurrentPlotData.ERPoverEventsXTicks = Figure.XTickLabel;

    end

    if strcmp(Type,'MultipleERPOnly') || strcmp(Type,'All')
        %% Plot ERP for all Channel
        adjustedcolormap = rgbcolormap;
    
        [nc,ntr,nti] = size(EventRelatedData);

        EventRelatedData = squeeze(mean(EventRelatedData(:,:,:),2,'omitnan'));

        for nchannel = 1:nc   
            EventRelatedData(nchannel,:) = EventRelatedData(nchannel,:) - (nchannel - 1) * PlotLineSpacing;
        end
    
        YMaxLimitsMultipeERP = max(EventRelatedData,[],"all");
        YMinLimitsMultipeERP = min(EventRelatedData,[],"all");
        xlim(Figure2, [EventTime(1),EventTime(end)]);
        ylim(Figure2, [YMinLimitsMultipeERP,YMaxLimitsMultipeERP]);
        xlabel(Figure2,"Time [s]")
        title(Figure2,"Event Related Potential for all Channel");
    
        ChannelERPHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'ChannelERP');
    
        if ~isempty(ChannelERPHandles)
            if length(ChannelERPHandles) > 1
                delete(ChannelERPHandles(2:end));
                ChannelERPHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'ChannelERP');
            end
        end
    
        for nchannel = 1:size(EventRelatedData,1)
            if nchannel <= length(ChannelERPHandles)
                set(ChannelERPHandles(nchannel), 'YData', EventRelatedData(nchannel,:),'Color',adjustedcolormap(nchannel,:),'LineWidth',2,'Tag','ChannelERP');
                Meanplot = ChannelERPHandles(1);
            else
                Meanplot = line(Figure2,EventTime,EventRelatedData(nchannel,:),'Color',adjustedcolormap(nchannel,:),'LineWidth',2,'Tag','ChannelERP');
            end
        end

        %% Plot Event Line
        EventLinesHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'EventLines');
        
        if ~isempty(EventLinesHandles)
            if length(EventLinesHandles) > 1
                delete(EventLinesHandles(2:end));
                EventLinesHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'EventLines');
            end
        end
        
        if isempty(EventLinesHandles)
            Eventplot = line(Figure2,[0,0],[min(EventRelatedData,[],'all') max(EventRelatedData,[],'all')],'Color','r','LineWidth',2,'Tag','EventLines');
        else
            set(EventLinesHandles(:), 'XData',[0,0],'YData', [min(EventRelatedData,[],'all') max(EventRelatedData,[],'all')],'Color','r','LineWidth',2,'Tag','EventLines');
            Eventplot = EventLinesHandles(1);
        end
    
        % Bring Event Line to the front
        uistack(Meanplot, 'top');
        uistack(Eventplot, 'top');
        
        % Add legend only once
        if isempty(findobj(Figure2, 'Type', 'legend'))
            % Create legend and then set its 'HandleVisibility' to 'off'
            legendHandle = legend(Figure2,Eventplot, {'Trigger'});
            set(legendHandle, 'HandleVisibility', 'off');
        end

        %% save plotted data in case user wants to save 
        % Save data main plot -- channel spike rate
        
        CurrentPlotData.ERPoverChannelXData = EventTime;
        CurrentPlotData.ERPoverChannelYData = EventRelatedData;
        CurrentPlotData.ERPoverChannelCData = [];
        CurrentPlotData.ERPoverChannelType = strcat("Event Related Potential over Channel");
        CurrentPlotData.ERPoverChannelXTicks = Figure2.XTickLabel;

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
    
    DatatoPlot = squeeze(mean(EventRelatedData(CSD.SurfaceChannel:end,:,:),2,'omitnan'));
    
    [csd,~]=Analyse_Main_Window_Compute_CSD(DatatoPlot',CSD.ChannelSpacing,CSD.HammWindow);

    nChan = size(csd,2);
    
    ds = (0:nChan-1)*CSD.ChannelSpacing; %depth in micrometers given 50 µm spacing

    %% Plot 

    CSDClim(1) = min(min(csd));
    CSDClim(2) = max(max(csd));

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
            surf(Figure,EventTime,ds,csd','EdgeColor', 'none', 'Tag','PowerDepth3D')
            %2D
            % 2D Plot
            min_z = min(csd,[],'all');
            surface(Figure,EventTime,ds, min_z * ones(size(csd')), ...
            'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            %3D
            set(PowerDepth3D_handles(1),'XData',EventTime,'YData',ds,'CData',csd','ZData',csd','EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            %2D
            % 2D Plot
            min_z = min(csd,[],'all');
            set(PowerDepth2D_handles(1),'XData',EventTime,'YData',ds,'ZData', min_z * ones(size(csd')), ...
            'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
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
            surface(Figure,EventTime,ds, min_z * ones(size(csd')), ...
            'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            min_z = 0;
            set(PowerDepth2D_handles(1),'XData',EventTime,'YData',ds,'ZData', min_z * ones(size(csd')), ...
            'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        end
    end
   

    %% Plot Event line
    Event_handles = findobj(Figure,'Type', 'line', 'Tag', 'Event');
    if length(Event_handles)>1
        delete(Event_handles(2:end));
    end

    if strcmp(TwoORThreeD,"TwoD")
        if isempty(Event_handles)
            eventLine = line(Figure,[0, 0],ylim(Figure),'Color','r','LineWidth',2, 'Parent', Figure, 'Tag', 'Event');
        else
            set(Event_handles(1), 'XData', [0, 0], 'YData', ylim(Figure), 'Parent', Figure, 'Tag', 'Event');
            eventLine = Event_handles(1);
        end
    elseif strcmp(TwoORThreeD,"ThreeD")
        % Define the Y and Z ranges
        Y = [ds(1), ds(end)];
        Z = [min(csd,[],'all'), max(csd,[],'all')];  
        
        % Create a plane through Y and Z
        [YGrid, ZGrid] = meshgrid(Y, Z);
        
        XGrid = zeros(size(YGrid));
        if isempty(Event_handles)
            eventLine=surf(Figure,XGrid, YGrid, ZGrid, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
        else
            set(Event_handles(1), 'XData',XGrid,'YData', YGrid,'ZData', ZGrid, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'Tag', 'Event');
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
    ylim(Figure,[ds(1),ds(end)]);
    set(Figure,'YDir','reverse');
    title(Figure,"Event Related Current Source Density Analysis")
    xlabel(Figure,'Time [s]')
    ylabel(Figure,'Depth [µm]') 
    cbar_handle=colorbar('peer',Figure,'location','EastOutside');
    cbar_handle.Label.String = "Signal [mV/mm^2]";
    cbar_handle.Label.Rotation = 270;

    %% save plotted data in case user wants to save 
    % Save data main plot -- channel spike rate
    
    CurrentPlotData.CSDXData = EventTime;
    CurrentPlotData.CSDYData = ds;
    CurrentPlotData.CSDCData = csd';
    CurrentPlotData.CSDType = strcat("Current Source Density");
    CurrentPlotData.CSDXTicks = Figure.XTickLabel;

end