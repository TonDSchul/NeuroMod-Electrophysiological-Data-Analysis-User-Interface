function CurrentPlotData = Event_Module_ERP_IndividualLines(Data,EventRelatedData,EventNr,EventTime,Figure,DataType,ERPChannel,SingleChannelPlotType,PlotAppearance,CurrentPlotData)


    
    if size(EventRelatedData,2) == 0
        msgbox("No Events for this Channel found");
        return;
    end
    
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
    
    if size(EventRelatedData,2)==1
        DataLinestoPlot = DataLinestoPlot';
    end

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

    if size(EventRelatedData,2) > 1
        if SingleChannelPlotType == 1
            yyaxis(Figure, 'right');
            MeanToPlot = mean(DataLinestoPlot,1);
        else
            MeanToPlot = mean(DataLinestoPlot,1);
        end
    else
        MeanToPlot = DataLinestoPlot;
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


    %% save plotted data in case user wants to save 
    % Save data main plot -- channel spike rate
    
    CurrentPlotData.ERPoverEventsXData = EventTime;
    CurrentPlotData.ERPoverEventsYData = DataLinestoPlot;
    CurrentPlotData.ERPoverEventsCData = [];
    CurrentPlotData.ERPoverEventsType = strcat("Event Related Potential over Events");

    CurrentPlotData.ERPoverEventsXTicks = Figure.XTickLabel;
