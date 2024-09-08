function plotWFampCDFs(pdfs, cdfs, ampBins, depthBins,PDFCDF,Figure,Channeldepth,ChannelSpacing,SpikeType,TwoORThreeD,ClustertoShow)

depthX = depthBins(1:end-1)+mean(diff(depthBins))/2;
ampX = ampBins(1:end-1)+mean(diff(ampBins))/2;

if strcmp(PDFCDF,"PDF")
    if strcmp(TwoORThreeD,"TwoD")
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        if length(PowerDepth2D_handles)>1
            delete(PowerDepth2D_handles(2:end));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        end
    
        min_z = 0;
        if isempty(PowerDepth2D_handles)
            surface(Figure,ampX, depthX, min_z * ones(size(pdfs)), ...
            'CData', pdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            set(PowerDepth2D_handles(1),'XData',ampX,'YData', depthX,'ZData', min_z * ones(size(pdfs)), ...
            'CData', pdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        end

    elseif strcmp(TwoORThreeD,"ThreeD")

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
            % 3D Plot
            surf(Figure,ampX,depthX,pdfs,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            % 2D Plot
            min_z = min(pdfs,[],'all');
            surface(Figure,ampX, depthX, min_z * ones(size(pdfs)), ...
            'CData', pdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            % 3D Plot
            set(PowerDepth3D_handles(1),'XData',ampX,'YData',depthX,'ZData',pdfs,'CData',pdfs,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            % 2D Plot
            min_z = min(pdfs,[],'all');
            set(PowerDepth2D_handles(1),'XData',ampX,'YData', depthX,'ZData', min_z * ones(size(pdfs)), ...
            'CData', pdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        end

        view(Figure,45,45);
        box(Figure, 'off');
        grid(Figure, 'off');
    end

    xlabel(Figure,'Spike Amplitude (mV)');
    ylabel(Figure,'Depth on Probe (µm)');
    if strcmp(ClustertoShow,"All") || strcmp(ClustertoShow,"Non")
        title(Figure,strcat("All Units Probability Density Function"));
    else
        title(Figure,strcat("Unit ",ClustertoShow," Probability Density Function"));
    end

    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    cbar_handle.Label.String = "firing rate (sp/s)";
    cbar_handle.Label.Rotation = 270;
    colormap(Figure,colormap_greyZero_blackred);
    xlim(Figure,[min(ampX) max(ampX)])
    
    ylim(Figure,[0,Channeldepth])
    manualxticklabels = min(ampX):max(ampX)/20:max(ampX);

    %Add xticks
    Execute_Autorun_Set_Up_Figure(Figure,1,"Non",manualxticklabels,20,[],[],[],9);

else % if CDF
    if strcmp(TwoORThreeD,"TwoD")
        PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        if length(PowerDepth2D_handles)>1
            delete(PowerDepth2D_handles(2:end));
            PowerDepth2D_handles = findobj(Figure, 'Tag', 'PowerDepth2D');
        end
    
        min_z = 0;
        if isempty(PowerDepth2D_handles)
            surface(Figure,ampX, depthX, min_z * ones(size(cdfs)), ...
            'CData', cdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            set(PowerDepth2D_handles(1),'XData',ampX,'YData', depthX,'ZData', min_z * ones(size(cdfs)), ...
            'CData', cdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        end

    elseif strcmp(TwoORThreeD,"ThreeD")

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
            % 3D Plot
            surf(Figure,ampX,depthX,cdfs,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            % 2D Plot
            min_z = min(cdfs,[],'all');
            surface(Figure,ampX, depthX, min_z * ones(size(cdfs)), ...
            'CData', cdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        else
            % 3D Plot
            set(PowerDepth3D_handles(1),'XData',ampX,'YData',depthX,'ZData',cdfs,'CData',cdfs,'EdgeColor', 'none', 'Tag', 'PowerDepth3D')
            % 2D Plot
            min_z = min(cdfs,[],'all');
            set(PowerDepth2D_handles(1),'XData',ampX,'YData', depthX,'ZData', min_z * ones(size(cdfs)), ...
            'CData', cdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none', 'Tag', 'PowerDepth2D');
        end

        view(Figure,45,45);
        box(Figure, 'off');
        grid(Figure, 'off');
    end
    
    xlabel(Figure,'Spike Amplitude (mV)');
    ylabel(Figure,'Depth on Probe (µm)');
    title(Figure,'Inverse Cumulative Distribution Function');
    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    cbar_handle.Label.String = "firing rate (sp/s)";
    cbar_handle.Label.Rotation = 270;
    colormap(Figure,colormap_greyZero_blackred);
    xlim(Figure,[min(ampX) max(ampX)])
    
    ylim(Figure,[0,Channeldepth])

    manualxticklabels = min(ampX):max(ampX)/20:max(ampX);

    %Add xticks
    Execute_Autorun_Set_Up_Figure(Figure,1,"Non",manualxticklabels,20,[],[],[],9);
end
