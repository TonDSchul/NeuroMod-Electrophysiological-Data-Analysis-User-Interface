function [CSDClim,Trialplot,Meanplot,Eventplot,CurrentPlotData] = Event_Module_Compute_and_Plot_ERP_CSD(Data,Figure,Figure2,EventRelatedData,EventTime,DataChannelSelected,CSD,rgbcolormap,PlotLineSpacing,Type,TwoORThreeD,CurrentPlotData,PlotAppearance,ERPChannel,DataType,SingleChannelPlotType,EventNr,PreservePlotChannelLocations)

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

NumEvents = size(EventRelatedData,2);
%% For all Channel ERP
[DataChannelSelected] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,DataChannelSelected,'MainPlot');

%% PLOT ERP
if isempty(CSD)
    
    if strcmp(Type,'SingleERPOnly') || strcmp(Type,'All')
        
        if size(EventRelatedData,2) == 0
            msgbox("No Events for this Channel found");
            return;
        end

        % if SingleChannelPlotType == 0
        %     yyaxis(Figure, 'left');
        % end
        
        %% ----------------------------------- Convert Selected Channel in Datachannel of Data matrix -----------------------------------
        OriginalERPChannel = str2double(ERPChannel);
        
        if Data.Info.ProbeInfo.SwitchTopBottomChannel == 1
            TempActiveChannel = (str2double(Data.Info.ProbeInfo.NrChannel)*str2double(Data.Info.ProbeInfo.NrRows)+1)-sort(Data.Info.ProbeInfo.ActiveChannel);
            [ERPChannel] = Organize_Convert_ActiveChannel_to_DataChannel(TempActiveChannel,OriginalERPChannel,'MainPlot');
        else
            [ERPChannel] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,OriginalERPChannel,'MainPlot');
        end
        
        %% ----------------------------------- Select Data based on Info from above -----------------------------------
        DataLinestoPlot = squeeze(EventRelatedData(ERPChannel,:,:));
        
        %% ----------------------------------- Get existing handles -----------------------------------
        TrialLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'TrialLines');
        TrialLinesImagescHandles = findobj(Figure, 'Tag', 'ImageSCTrialLines');

        %% Plot Trials
        % Delete handles if too many (i.e. the user reduced the amount of events/trials shown)

        Trialplot = [];

        %% ----------------------------------- LinePlot -----------------------------------
        if SingleChannelPlotType == 0
            %% Delete imagesc handle
            if ~isempty(TrialLinesImagescHandles)
                delete(TrialLinesImagescHandles(:));
            end
            %% Delete if too many handles
            if ~isempty(TrialLinesHandles)
                if length(TrialLinesHandles) > size(EventRelatedData,2)
                    delete(TrialLinesHandles(size(EventRelatedData,2)+1:end));
                    TrialLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'TrialLines');
                end
            end

            if isempty(TrialLinesHandles)
                if size(EventRelatedData,2) == 1
                    Trialplot = line(Figure,EventTime,squeeze(EventRelatedData(ERPChannel,:,:))', 'Color', PlotAppearance.ERPWindow.SingleERP.EventColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.EventLineWidth,'Tag','TrialLines');
                else
                    Trialplot = line(Figure,EventTime,squeeze(EventRelatedData(ERPChannel,:,:)), 'Color', PlotAppearance.ERPWindow.SingleERP.EventColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.EventLineWidth,'Tag','TrialLines');
                end
            else
                for i = 1:size(EventRelatedData,2)
                    if i <= length(TrialLinesHandles)
                        set(TrialLinesHandles(i), 'XData',EventTime , 'YData',squeeze(EventRelatedData(ERPChannel,i,:))', 'Color', PlotAppearance.ERPWindow.SingleERP.EventColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.EventLineWidth, 'Tag', 'TrialLines');
                        Trialplot = TrialLinesHandles(i);
                    else
                        Trialplot = line(Figure,EventTime,squeeze(EventRelatedData(ERPChannel,i,:))', 'Color', PlotAppearance.ERPWindow.SingleERP.EventColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.EventLineWidth,'Tag','TrialLines');
                    end
                end
            end
        %% ----------------------------------- ImageSC -----------------------------------
        else 
            yyaxis(Figure, 'left');
            %% Delete line handle
            if ~isempty(TrialLinesHandles)
                delete(TrialLinesHandles(:));
            end

            if isempty(TrialLinesImagescHandles)
                Trialplot = imagesc(Figure,EventTime,1:size(EventRelatedData,2),squeeze(EventRelatedData(ERPChannel,:,:)),'Tag','ImageSCTrialLines');
            else
                if size(EventRelatedData,2)>1
                    Trialplot = set(TrialLinesImagescHandles(1),'XData',EventTime,'YData',1:size(EventRelatedData,2),'CData',squeeze(EventRelatedData(ERPChannel,:,:)), 'Tag','ImageSCTrialLines');
                else
                    Trialplot = set(TrialLinesImagescHandles(1),'XData',EventTime,'YData',1:size(EventRelatedData,2),'CData',squeeze(EventRelatedData(ERPChannel,:,:))', 'Tag','ImageSCTrialLines');
                end
            end
        end

        %% ------------- figure properties --------------------
        xlabel(Figure,PlotAppearance.ERPWindow.SingleERP.XLabel)
        
        if SingleChannelPlotType == 0
            ylim(Figure,[min(DataLinestoPlot,[],'all') max(DataLinestoPlot,[],'all')]);  
            TempYlim = [min(DataLinestoPlot,[],'all') max(DataLinestoPlot,[],'all')]; % for event line y limits
            ylabel(Figure,PlotAppearance.ERPWindow.SingleERP.YLabel)
            set(Figure, 'YDir', 'normal')  
            
            cbar_handle=colorbar('peer',Figure,'location','WestOutside');
            if ~isempty(cbar_handle)
                delete(cbar_handle);
            end
        else
            
            ylim(Figure,[0.5 size(EventRelatedData,2) + 0.5]); 

            TempYlim = [0.5 size(EventRelatedData,2)+0.5];  % for event line y limits

            if strcmp(DataType,"Preprocessed Event Related Data")
                if isfield(Data.Info.EventRelatedPreprocessing,'TrialRejectionTrials')
                    ylabel(Figure,'Trial Identities (Trial Numbers)')
                    %% costume y labels
                    TrialNumbers = string(1:size(Data.PreprocessedEventRelatedData,2));
                    
                    OriginalTrials = 1:size(Data.EventRelatedData,2);
                    OriginalTrials(ismember(OriginalTrials,Data.Info.EventRelatedPreprocessing.TrialRejectionTrials)) = [];
                    TrialIdentities = string(OriginalTrials);
                    
                    a = strings;
                    for i = 1:length(TrialNumbers)
                        a(i) = strcat(TrialIdentities(i),"(",TrialNumbers(i),")");
                    end
                    
                    if length(1:length(EventNr))>=50
                        atemp = [];
                        for i = 1:10:length(a)
                            atemp = [atemp,a(i)];
                        end
                        Figure.YTick = 1:10:length(a);
                        Figure.YTickLabel = string(atemp);
                    else
                        Figure.YTick = 1:length(a);
                        Figure.YTickLabel = string(a);
                    end
                else
                    ylabel(Figure,'Trial Numbers')
                    if length(1:length(EventNr))<=50
                        Figure.YTick = 1:length(EventNr);
                        Figure.YTickLabel = string(EventNr);
                    else
                        Figure.YTick = 1:10:length(EventNr);
                        Figure.YTickLabel = string(1:10:length(EventNr));
                    end
                end
            else
                ylabel(Figure,'Trial Numbers')
                if length(1:length(EventNr))<=50
                    Figure.YTick = 1:length(EventNr);
                    Figure.YTickLabel = string(EventNr);
                else
                    Figure.YTick = 1:10:length(EventNr);
                    Figure.YTickLabel = string(1:10:length(EventNr));
                end
            end


            
            set(Figure, 'YDir', 'normal') 

            %cbar 
            cbar_handle=colorbar('peer',Figure,'location','WestOutside');
            cbar_handle.Label.String = 'Signal [mV]';
            cbar_handle.Label.Rotation = 270;
            cbar_handle.Color = 'k';  
            cbar_handle.Label.Color = 'k';        % Sets the color of the label text

        end

        xlim(Figure,[EventTime(1) EventTime(end)]);
        title(Figure,strcat("Trial-Wise Signal and Event Related Potential Channel ",num2str(OriginalERPChannel)));

        Figure.FontSize = PlotAppearance.ERPWindow.SingleERP.FontSize;
        Figure.Color = PlotAppearance.ERPWindow.SingleERP.BackgroundColor;
        Figure.XLabel.Color = 'k';  
        Figure.YLabel.Color = 'k';  
        Figure.XColor = 'k';  
        Figure.YColor = 'k';
        Figure.Title.Color = 'k';  
        Figure.Box ="off";

        if size(EventRelatedData,2) > 1 % If just one trial: no mean has to be plotted
            
            if SingleChannelPlotType == 1
                yyaxis(Figure, 'right');
                MeanToPlot = mean(DataLinestoPlot,1);
            else
                MeanToPlot = mean(DataLinestoPlot,1);
            end

            %% Plot Mean
            MeanLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'MeanLines');
        
            if ~isempty(MeanLinesHandles)
                if length(MeanLinesHandles) > 1
                    delete(MeanLinesHandles(2:end));
                    MeanLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'MeanLines');
                end
            end
        
            if isempty(MeanLinesHandles)
                Meanplot = line(Figure,EventTime,MeanToPlot,'Color',PlotAppearance.ERPWindow.SingleERP.MeanColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.MeanLineWidth,'Tag','MeanLines');
            else
                set(MeanLinesHandles(1), 'XData',EventTime , 'YData', MeanToPlot,'Color',PlotAppearance.ERPWindow.SingleERP.MeanColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.MeanLineWidth,'Tag','MeanLines');
                Meanplot = MeanLinesHandles(1);
            end

            if SingleChannelPlotType == 1 % for right axis (mean)
                ylim(Figure,[min(MeanToPlot) max(MeanToPlot)]);
            else
                ylim(Figure,[min(TempYlim) max(TempYlim)]);
            end
            
            ylabel(Figure,'Signal [mV]')
           
            %% Plot Trigger Line
            EventLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'EventLines');

            if SingleChannelPlotType == 1
                yyaxis(Figure, 'left');
            end

            if ~isempty(EventLinesHandles)
                if length(EventLinesHandles) > 1
                    delete(EventLinesHandles(2:end));
                    EventLinesHandles = findobj(Figure, 'Type', 'line', 'Tag', 'EventLines');
                end
            end
            
            if isempty(EventLinesHandles)
                Eventplot = line(Figure,[0,0],TempYlim,'Color',PlotAppearance.ERPWindow.SingleERP.TriggerColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.TriggerLineWidth,'Tag','EventLines');
            else
                set(EventLinesHandles(:), 'XData',[0,0],'YData', TempYlim,'Color',PlotAppearance.ERPWindow.SingleERP.TriggerColor,'LineWidth',PlotAppearance.ERPWindow.SingleERP.TriggerLineWidth,'Tag','EventLines');
                Eventplot = EventLinesHandles(1);
            end
            
            % Add legend only once
            if isempty(findobj(Figure, 'Type', 'legend'))
                % Create legend and then set its 'HandleVisibility' to 'off'
                if SingleChannelPlotType == 0 
                    legendHandle = legend([Trialplot(1), Meanplot, Eventplot], {'Trials/Events', 'ERP', 'Trigger'});
                else
                    legendHandle = legend([Meanplot, Eventplot], { 'ERP', 'Trigger'});
                end
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
        adjustedcolormap = rgbcolormap(DataChannelSelected,:);
        
        if DataChannelSelected(1) == DataChannelSelected(end) 
            DataToPlot = squeeze(mean(EventRelatedData(DataChannelSelected(1),:,:),2))';
        else
            DataToPlot = squeeze(mean(EventRelatedData(DataChannelSelected,:,:),2,'omitnan')); 
        end

        [nc,ntr,nti] = size(DataToPlot);
        
        % DataToPlot = squeeze(mean(DataToPlot(:,:,:),2,'omitnan'));
        
        for nchannel = 1:nc   
            DataToPlot(nchannel,:) = DataToPlot(nchannel,:) - (nchannel - 1) * PlotLineSpacing;
        end
        
        YMaxLimitsMultipeERP = max(DataToPlot,[],"all");
        YMinLimitsMultipeERP = min(DataToPlot,[],"all");
        xlim(Figure2, [EventTime(1),EventTime(end)]);
        ylim(Figure2, [YMinLimitsMultipeERP,YMaxLimitsMultipeERP]);
        xlabel(Figure2,PlotAppearance.ERPWindow.MultipleERP.XLabel)
        ylabel(Figure2,PlotAppearance.ERPWindow.MultipleERP.YLabel)
        title(Figure2,"Event Related Potential All Active Channel");
        
        ChannelERPHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'ChannelERP');
        
        if ~isempty(ChannelERPHandles)
            if length(ChannelERPHandles) > 1
                delete(ChannelERPHandles(2:end));
                ChannelERPHandles = findobj(Figure2, 'Type', 'line', 'Tag', 'ChannelERP');
            end
        else
            Figure2.FontSize = PlotAppearance.ERPWindow.MultipleERP.FontSize;
            Figure2.Color = PlotAppearance.ERPWindow.MultipleERP.BackgroundColor;
            Figure2.XLabel.Color = [0 0 0];
            %UIAxes.XTickLabelMode = 'auto';
            Figure2.XColor = 'k';  
            Figure2.Title.Color = 'k';  
            Figure2.Box ="off";
        end
    
        for nchannel = 1:size(DataToPlot,1)
            if nchannel <= length(ChannelERPHandles)
                set(ChannelERPHandles(nchannel), 'XData',EventTime, 'YData', DataToPlot(nchannel,:),'Color',adjustedcolormap(nchannel,:),'LineWidth',PlotAppearance.ERPWindow.MultipleERP.MeanLineWidth,'Tag','ChannelERP');
                Meanplot = ChannelERPHandles(1);
            else
                Meanplot = line(Figure2,EventTime,DataToPlot(nchannel,:),'Color',adjustedcolormap(nchannel,:),'LineWidth',PlotAppearance.ERPWindow.MultipleERP.MeanLineWidth,'Tag','ChannelERP');
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
            Eventplot = line(Figure2,[0,0],[min(DataToPlot,[],'all') max(DataToPlot,[],'all')],'Color',PlotAppearance.ERPWindow.MultipleERP.TriggerColor,'LineWidth',PlotAppearance.ERPWindow.MultipleERP.TriggerLineWidth,'Tag','EventLines');
        else
            set(EventLinesHandles(:), 'XData',[0,0],'YData', [min(DataToPlot,[],'all') max(DataToPlot,[],'all')],'Color',PlotAppearance.ERPWindow.MultipleERP.TriggerColor,'LineWidth',PlotAppearance.ERPWindow.MultipleERP.TriggerLineWidth,'Tag','EventLines');
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
        CurrentPlotData.ERPoverChannelYData = DataToPlot;
        CurrentPlotData.ERPoverChannelCData = [];
        CurrentPlotData.ERPoverChannelType = strcat("Event Related Potential over Channel");
        CurrentPlotData.ERPoverChannelXTicks = Figure2.XTickLabel;

        %Utility_Set_YAxis_Depth_Labels(Data,Figure2,[],OriginalDataChannelSelected)
        Figure2.YTickLabel = flip(Figure2.YTickLabel);

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
    
    % if str2double(Data.Info.ProbeInfo.NrRows) == 1
    %     ds = Data.Info.ProbeInfo.ycoords(min(OriginalDataChannelSelected)):CSD.ChannelSpacing:Data.Info.ProbeInfo.ycoords(max(OriginalDataChannelSelected));
    % else
    ds = 0:CSD.ChannelSpacing:(length(OriginalDataChannelSelected)-1)*CSD.ChannelSpacing;
        %ds = (min(OriginalDataChannelSelected)-1)*Data.Info.ChannelSpacing:Data.Info.ChannelSpacing:(max(OriginalDataChannelSelected)-1)*Data.Info.ChannelSpacing;
    % end

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