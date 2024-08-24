function plotWFampCDFs(pdfs, cdfs, ampBins, depthBins,PDFCDF,Figure,Channeldepth,ChannelSpacing,SpikeType,TwoORThreeD)

depthX = depthBins(1:end-1)+mean(diff(depthBins))/2;
ampX = ampBins(1:end-1)+mean(diff(ampBins))/2;

if strcmp(TwoORThreeD,"ThreeD")
    cla(Figure)
end

%
if strcmp(PDFCDF,"PDF")
    if strcmp(TwoORThreeD,"TwoD")

        min_z = 0;
        surface(Figure,ampX, depthX, min_z * ones(size(pdfs)), ...
        'CData', pdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none');

    elseif strcmp(TwoORThreeD,"ThreeD")
        surf(Figure,ampX,depthX,pdfs,'EdgeColor', 'none')
        % 2D Plot
        min_z = min(pdfs,[],'all');
        surface(Figure,ampX, depthX, min_z * ones(size(pdfs)), ...
        'CData', pdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none');

        view(Figure,45,45);
        box(Figure, 'off');
        grid(Figure, 'off');
    end

    xlabel(Figure,'Spike Amplitude (mV)');
    ylabel(Figure,'Depth on Probe (µm)');
    title(Figure,'Probability Density Function');
    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    cbar_handle.Label.String = "firing rate (sp/s)";
    cbar_handle.Label.Rotation = 270;
    colormap(Figure,colormap_greyZero_blackred);
    xlim(Figure,[min(ampX) max(ampX)])
    
    ylim(Figure,[0,depthX(end-1)])


    manualxticklabels = min(ampX):max(ampX)/20:max(ampX);

    %Add xticks
    Execute_Autorun_Set_Up_Figure(Figure,1,"Non",manualxticklabels,20,[],[],[],9);

else
    if strcmp(TwoORThreeD,"TwoD")
        %2D
        min_z = 0;
        surface(Figure,ampX, depthX, min_z * ones(size(cdfs)), ...
        'CData', cdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
    elseif strcmp(TwoORThreeD,"ThreeD")
        %3D
        surf(Figure,ampX,depthX,cdfs,'EdgeColor', 'none')
        %2D
        min_z = min(cdfs,[],'all');
        surface(Figure,ampX, depthX, min_z * ones(size(cdfs)), ...
        'CData', cdfs, 'FaceColor', 'texturemap', 'EdgeColor', 'none');

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
    
    ylim(Figure,[0,depthX(end-1)])

    manualxticklabels = min(ampX):max(ampX)/20:max(ampX);

    %Add xticks
    Execute_Autorun_Set_Up_Figure(Figure,1,"Non",manualxticklabels,20,[],[],[],9);
end
