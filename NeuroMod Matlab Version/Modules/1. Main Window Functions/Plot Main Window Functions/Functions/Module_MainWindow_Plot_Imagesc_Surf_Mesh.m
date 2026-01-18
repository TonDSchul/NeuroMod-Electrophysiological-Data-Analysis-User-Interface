function ClimMaxValues = Module_MainWindow_Plot_Imagesc_Surf_Mesh(Data,Info,Time,Depth,ActiveChannel,UIAxis,ClimMaxValues,PlotAppearance,ImageScChannel_handles)

if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh")     
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf")
        if isempty(ImageScChannel_handles)
            if isscalar(unique(Info.ProbeInfo.xcoords))
                ChannelText_handles = findobj(UIAxis,'Tag', 'TextArea');
                if length(ChannelText_handles)>numel(ActiveChannel)
                    delete(ChannelText_handles(numel(ActiveChannel)+1:end));
                    ChannelText_handles = findobj(UIAxis,'Tag', 'TextArea');
                end

                nPatch = 2*length(unique(Info.ProbeInfo.ycoords));
                
                y = 0:1:nPatch;        % patch height
                x = [0 1];             % patch width
                LaufVariable = 0;
                
                for i = 1:nPatch
                    IndicateNotActiveChannel = 0;
                    if mod(i,2)==1                 % data patches
                        LaufVariable = LaufVariable + 1;
                        if sum(LaufVariable==ActiveChannel)>0
                            c = Data((i+1)/2);
                        else
                            c = NaN;
                            IndicateNotActiveChannel = 1;
                        end
                    else                           % blank patches
                        c = NaN;
                    end
                
                    patch(UIAxis,[x(1) x(2) x(2) x(1)], ...
                          [y(i) y(i) y(i+1) y(i+1)], ...
                          c, ...
                          'EdgeColor','none','Tag','ImageScChannel');
                    
                    if ~isnan(c)
                        if isempty(ChannelText_handles)
                            text(UIAxis,x(1)-0.5, y(i)+0.5, strcat("Ch ",num2str(Info.ProbeInfo.ActiveChannel(LaufVariable))), ...
                             'HorizontalAlignment','center', ...
                             'VerticalAlignment','middle', ...
                             'Color','k','Tag','TextArea')
                        else
                            if LaufVariable<=length(ChannelText_handles)
                                set(ChannelText_handles(LaufVariable), ...
                                    'Position', [x(1)-0.5, y(i)+0.5, 0], ...
                                    'String', strcat("Ch ", num2str(Info.ProbeInfo.ActiveChannel(LaufVariable))), ...
                                    'HorizontalAlignment','center', ...
                                    'VerticalAlignment','middle', ...
                                    'Color','k', ...
                                    'Tag','TextArea');
                            else
                                text(UIAxis,x(1)-0.5, y(i)+0.5, strcat("Ch ",num2str(Info.ProbeInfo.ActiveChannel(LaufVariable))), ...
                             'HorizontalAlignment','center', ...
                             'VerticalAlignment','middle', ...
                             'Color','k','Tag','TextArea')
                            end
                        end

                    end
                end
                xlim(UIAxis,[-2,3]);
                ylim(UIAxis,[y(1)-1,y(end)+1])
            
            elseif length(unique(Info.ProbeInfo.xcoords))==2
                imagesc(UIAxis, Data, ...
                    'Tag','ImageScChannel');
                
                ChannelText_handles = findobj(UIAxis,'Tag', 'TextArea');
                if length(ChannelText_handles)>round(numel(Info.ProbeInfo.ActiveChannel)/2)
                    delete(ChannelText_handles(round(numel(Info.ProbeInfo.ActiveChannel)/2)+1:end));
                    ChannelText_handles = findobj(UIAxis,'Tag', 'TextArea');
                end
                
                LaufVariable = 1;
                AllChannel = Info.ProbeInfo.ActiveChannel(1):1:Info.ProbeInfo.ActiveChannel(end);
                ChannelToChooseFrom = Info.ProbeInfo.ActiveChannel(1:2:end);
                LaufVariablePlot = round(Info.ProbeInfo.ActiveChannel(1))/2;
                for k = 1:length(AllChannel)
                    CurrentChannel = AllChannel(k);
                    
                    if mod(LaufVariable,2)
                        if sum(CurrentChannel==Info.ProbeInfo.ActiveChannel)>0
                            if isempty(ChannelText_handles)
                                text(UIAxis,0, LaufVariablePlot+0.5, strcat("Ch ",num2str(CurrentChannel)), ...
                                 'HorizontalAlignment','center', ...
                                 'VerticalAlignment','middle', ...
                                 'Color','k','Tag','TextArea')
                                
                            else
                                if k<=length(ChannelText_handles)
                                    set(ChannelText_handles(k), ...
                                        'Position', [0, LaufVariablePlot+0.5, 0], ...
                                        'String', strcat("Ch ", num2str(CurrentChannel)), ...
                                        'HorizontalAlignment','center', ...
                                        'VerticalAlignment','middle', ...
                                        'Color','k', ...
                                        'Tag','TextArea');
                                    
                                else
                                    text(UIAxis,0, LaufVariablePlot+0.5, strcat("Ch ",num2str(CurrentChannel)), ...
                                     'HorizontalAlignment','center', ...
                                     'VerticalAlignment','middle', ...
                                     'Color','k','Tag','TextArea')
                                    
                                end
                            end
                        end
                        LaufVariablePlot = LaufVariablePlot +1;
                    end
                    LaufVariable = LaufVariable + 1;
                    
                end


                xlim(UIAxis,[-2,5]);
            else % plot matrix
                pcolor(UIAxis, Data, ...
                    'EdgeColor','none', ...
                    'Tag','ImageScChannel');
            end
           
        else
            set(ImageScChannel_handles(1), ...
                'CData', Data, ...
                'Tag','ImageScChannel');
        end
    end
    
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh")
        h = mesh(UIAxis,Data,'Tag','ImageScChannel');
        h.FaceColor = 'flat';   % or 'flat'
        h.EdgeColor = 'k';     % optional
        colormap(UIAxis, parula)   % or jet, turbo, etc.
    end
    
    if strcmp(PlotAppearance.MainWindow.Data.LockedClimSettings,"on")
        CurrentClim = [min(Data,[],'all') max(Data,[],'all')];
        
        if isempty(ClimMaxValues)
            ClimMaxValues = CurrentClim;
        end

        if CurrentClim(1)<ClimMaxValues(1)
            ClimMaxValues(1) = CurrentClim(1);
        end
        if CurrentClim(2)>ClimMaxValues(2)
            ClimMaxValues(2) = CurrentClim(2);
        end      
        if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh")
            zlim(UIAxis,ClimMaxValues);
            view(UIAxis, 45, 45)
        end
        clim(UIAxis,ClimMaxValues);
    else
        CurrentClim = [min(Data,[],'all') max(Data,[],'all')];
        clim(UIAxis,CurrentClim);
    end

    UIAxis.YDir = 'reverse';
end

if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Imagesc")
    if isempty(ImageScChannel_handles)
        imagesc(UIAxis,Time,Depth,Data,'Tag','ImageScChannel')
    else
        set(ImageScChannel_handles(1), 'XData', Time, 'YData', Depth,'CData', Data,'Tag','ImageScChannel');
    end

    if strcmp(PlotAppearance.MainWindow.Data.LockedClimSettings,"on")
        CurrentClim = [min(Data,[],'all') max(Data,[],'all')];
        
        if isempty(ClimMaxValues)
            ClimMaxValues = CurrentClim;
        end

        if CurrentClim(1)<ClimMaxValues(1)
            ClimMaxValues(1) = CurrentClim(1);
        end
        if CurrentClim(2)>ClimMaxValues(2)
            ClimMaxValues(2) = CurrentClim(2);
        end      
        if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh")
            zlim(UIAxis,ClimMaxValues);
            view(UIAxis, 45, 45)
        end
        clim(UIAxis,ClimMaxValues);
    else
        CurrentClim = [min(Data,[],'all') max(Data,[],'all')];
        clim(UIAxis,CurrentClim);
    end
end