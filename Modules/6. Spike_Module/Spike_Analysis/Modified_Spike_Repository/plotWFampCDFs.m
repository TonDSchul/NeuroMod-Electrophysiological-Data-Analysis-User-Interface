
function plotWFampCDFs(pdfs, cdfs, ampBins, depthBins,PDFCDF,Figure,Channeldepth,ChannelSpacing,SpikeType)

depthX = depthBins(1:end-1)+mean(diff(depthBins))/2;
ampX = ampBins(1:end-1)+mean(diff(ampBins))/2;

if strcmp(PDFCDF,"PDF")
    imagesc(Figure,ampX, depthX, pdfs)
    xlabel(Figure,'Spike Amplitude (mV)');
    ylabel(Figure,'Depth on Probe (µm)');
    title(Figure,'Probability Density Function');
    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    cbar_handle.Label.String = "firing rate (sp/s)";
    cbar_handle.Label.Rotation = 270;
    colormap(Figure,colormap_greyZero_blackred);
    xlim(Figure,[min(ampX) max(ampX)])
    if strcmp(SpikeType,"Kilosort")
        ylim(Figure,[0,Channeldepth])
    else
        ylim(Figure,[ChannelSpacing/2,Channeldepth])
    end

    manualxticklabels = min(ampX):max(ampX)/20:max(ampX);

    %Add xticks
    Execute_Autorun_Set_Up_Figure(Figure,1,"Non",manualxticklabels,20,[],[],[],9);

else
    imagesc(Figure,ampX, depthX, cdfs)
    xlabel(Figure,'Spike Amplitude (mV)');
    ylabel(Figure,'Depth on Probe (µm)');
    title(Figure,'Inverse Cumulative Distribution Function');
    cbar_handle=colorbar('peer',Figure,'location','WestOutside');
    cbar_handle.Label.String = "firing rate (sp/s)";
    cbar_handle.Label.Rotation = 270;
    colormap(Figure,colormap_greyZero_blackred);
    xlim(Figure,[min(ampX) max(ampX)])
    if strcmp(SpikeType,"Kilosort")
        ylim(Figure,[0,Channeldepth])
    else
        ylim(Figure,[ChannelSpacing/2,Channeldepth])
    end
    manualxticklabels = min(ampX):max(ampX)/20:max(ampX);

    %Add xticks
    Execute_Autorun_Set_Up_Figure(Figure,1,"Non",manualxticklabels,20,[],[],[],9);
end
