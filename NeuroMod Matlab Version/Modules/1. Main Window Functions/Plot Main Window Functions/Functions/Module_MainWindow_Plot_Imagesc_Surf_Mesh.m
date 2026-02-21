function ClimMaxValues = Module_MainWindow_Plot_Imagesc_Surf_Mesh(Data,Info,Time,Depth,ActiveChannel,UIAxis,ClimMaxValues,PlotAppearance,ImageScChannel_handles,SpikeDataCell)

%________________________________________________________________________________________

%% Function to plot data in main window as surf, mesh or imagsc

% gets called in 
% Module_MainWindow_Plot_Data

% Inputs: 
% 1. Data: channel by time matrix with data to plot
% 2. Info: main data metadata structure from Data.Info
% 4. Time: double vector with time stamps for each plotted data point in
% main plot
% 5. Depth: double vector depths for each channel plotted in imagsc plot
% 6. ActiveChannel: data matrix channel indicies plotted
% 6. UIAxis: plot axes to plot in (app.UIAxes)
% 7. ClimMaxValues: 1 x 2 double vector with global clims plotted so far
% 8. PlotAppearance: structure holding indo about the appearance of plots
% the user selected
% 9. ImageScChannel_handles: handle to imagsc plot
% 10: SpikeDataCell: cell array with spike indicies for each channel (empty cell for no spikes in that channel)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
    %Create Mask for inactive channel to not shown interpolated data for
    %     %them
    
    InactiveMask = true(size(Data));
    LaufVariable = 1;
    if length(unique(Info.ProbeInfo.xcoords))>=2
        CorrectedActiveChannel = Info.ProbeInfo.ActiveChannel(ActiveChannel);
        for nchannnel = 1:length(unique(Info.ProbeInfo.ycoords))
            for nrows = 1:length(unique(Info.ProbeInfo.xcoords))
                if sum(LaufVariable==Info.ProbeInfo.ActiveChannel)>0
                    if sum(LaufVariable==CorrectedActiveChannel)==0 % not present original data channel
                        InactiveMask(nchannnel,nrows) = false;
                    end
                end
                LaufVariable = LaufVariable + 1;
            end
        end
    end

    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Surf") || strcmp(PlotAppearance.MainWindow.Data.Plottype,"AxonViewer")
        
        if ~isempty(SpikeDataCell)
            mask = ~cellfun(@isempty, SpikeDataCell);  
            [SpikeRows, SpikeColumns] = find(mask);        
        else
            SpikeRows = [];
            SpikeColumns = [];
        end

        if length(SpikeRows) + length(SpikeColumns) > 1
            SpikeRows = SpikeRows + 0.5;
            SpikeColumns = SpikeColumns + 0.5;
        end

        if isempty(ImageScChannel_handles)
            if PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.EnableSpaceInterpol && PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.SpaceInterpol > 1
                [X,Y] = meshgrid(1:size(Data,2),1:size(Data,1));
                scale = PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.SpaceInterpol;
                xq = linspace(1,size(Data,2),size(Data,2)*scale);
                yq = linspace(1,size(Data,1),size(Data,1)*scale);
                [Xq,Yq] = meshgrid(xq,yq);
                
                Data = fillmissing(Data,'nearest');   % or 'linear'
                Data = interp2(X,Y,Data,Xq,Yq,'cubic');

                %also interpolate active channel mask
                MaskInterp = interp2(X,Y,double(InactiveMask),Xq,Yq,'nearest') > 0.5;
                Data(MaskInterp==0) = nan;

                SurfSpikeHandles = findobj(UIAxis, 'Tag', 'SurfSpikes');
                delete(SurfSpikeHandles);

                pcolor(UIAxis, Xq,Yq,Data, ...
                'EdgeColor','none', ...
                'Tag','ImageScChannel');

                if length(SpikeRows) + length(SpikeColumns) > 1
                    % SpikeRows = SpikeRows + 0.5;
                    % SpikeColumns = SpikeColumns + 0.5;
                    scatter(UIAxis,SpikeColumns, SpikeRows,60, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r','Tag','SurfSpikes');
                end
            else
                Data(InactiveMask==0) = nan;
                
                SurfSpikeHandles = findobj(UIAxis, 'Tag', 'SurfSpikes');
                delete(SurfSpikeHandles);

                pcolor(UIAxis,Data, ...
                'EdgeColor','none', ...
                'Tag','ImageScChannel');

                if length(SpikeRows) + length(SpikeColumns) > 1
                    % SpikeRows = SpikeRows + 0.5;
                    % SpikeColumns = SpikeColumns + 0.5;
                    scatter(UIAxis,SpikeColumns, SpikeRows,60, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r','Tag','SurfSpikes');
                end
            end
        else
            if length(ImageScChannel_handles)>1
                delete(ImageScChannel_handles(2:end))
            end

            if PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.EnableSpaceInterpol && PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.SpaceInterpol > 1
                [X,Y] = meshgrid(1:size(Data,2),1:size(Data,1));
                scale = PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.SpaceInterpol;
                xq = linspace(1,size(Data,2),size(Data,2)*scale);
                yq = linspace(1,size(Data,1),size(Data,1)*scale);
                [Xq,Yq] = meshgrid(xq,yq);
                
                Data = fillmissing(Data,'nearest');   % or 'linear'
                Data = interp2(X,Y,Data,Xq,Yq,'cubic');

                %also interpolate active channel mask
                MaskInterp = interp2(X,Y,double(InactiveMask),Xq,Yq,'nearest') > 0.5;
                Data(MaskInterp==0) = nan;
            else
                Data(InactiveMask==0) = nan;
            end

            set(ImageScChannel_handles(1),'CData',Data,'Tag','ImageScChannel')
        end      
    end
    
    if strcmp(PlotAppearance.MainWindow.Data.Plottype,"Mesh")
        if PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.EnableSpaceInterpol && PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.SpaceInterpol > 1
            [X,Y] = meshgrid(1:size(Data,2),1:size(Data,1));
            scale = PlotAppearance.MainWindow.Data.TimeAndSpaceInterpolation.SpaceInterpol;
            xq = linspace(1,size(Data,2),size(Data,2)*scale);
            yq = linspace(1,size(Data,1),size(Data,1)*scale);
            [Xq,Yq] = meshgrid(xq,yq);
            
            Data = fillmissing(Data,'nearest');   % or 'linear'
            Data = interp2(X,Y,Data,Xq,Yq,'cubic');

            %also interpolate active channel mask
            MaskInterp = interp2(X,Y,double(InactiveMask),Xq,Yq,'nearest') > 0.5;
            Data(MaskInterp==0) = nan;

            h = mesh(UIAxis,Data,'Tag','ImageScChannel');
        else
            %also interpolate active channel mask
            %MaskInterp = interp2(X,Y,double(InactiveMask),Xq,Yq,'nearest') > 0.5;
            Data(InactiveMask==0) = nan;

            h = mesh(UIAxis,Data,'Tag','ImageScChannel');
        end

        
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
            if CurrentClim(1) ~= CurrentClim(2)
                zlim(UIAxis,CurrentClim);
            end
            view(UIAxis, 45, 45)
        end
        if CurrentClim(1) ~= CurrentClim(2) && sum(isnan(CurrentClim))==0
            clim(UIAxis,CurrentClim);
        end
    else
        CurrentClim = [min(Data,[],'all') max(Data,[],'all')];
        if CurrentClim(1) ~= CurrentClim(2) && sum(isnan(CurrentClim))==0
            clim(UIAxis,CurrentClim);
        end
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
            if CurrentClim(1) ~= CurrentClim(2)
                zlim(UIAxis,CurrentClim);
            end
            view(UIAxis, 45, 45)
        end
        if CurrentClim(1) ~= CurrentClim(2)
            clim(UIAxis,CurrentClim);
        end
    else
        CurrentClim = [min(Data,[],'all') max(Data,[],'all')];
        if CurrentClim(1) ~= CurrentClim(2)
            clim(UIAxis,CurrentClim);
        end
    end
end