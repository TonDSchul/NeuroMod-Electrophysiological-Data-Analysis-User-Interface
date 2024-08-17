function [currentClim] = Analyse_Main_Window_CSD(hamwidth,ChannelSpacing,ChannelSelection,CSDClim,Figure,DatatoPlot,TimeRangetoPlot,Plottype,LockCLim)

%________________________________________________________________________________________

%% Main Function to calculate and plot current source density (CSD) for the main window data plot

% Note: LockCLim option determines, whether there should be a global limit
% for the colormap. If set to 1, the current clim is compared to the max of
% clim of previous csd plots. If current clims exceed the previous clims,
% global clim is set to current. Otherwise global clim remains unchanged. 

% Inputs:
% 1: hamwidth: Width of Hamm Window to smooth data in time and depth as
% uneven double, recommended: 5
% 2: ChannelSpacing: Channel spacing of probe in um as double
% (Data.Info.ChannelSpacing) NOTE: gets converted in mm!
% 3. ChannelSelection: GUI channel selection field as char, i.e. '1,10' --
% just for title!
% 4. CSDClim: 1 x 2 double, comes from CSD window and captures the clim of previous csd
% plots. This is used to compare to current clim and determine if colormap
% limits have to be changed. Only applies if LockCLim = 1, 
% 5. Figure: axes object of figure to plot CSD in
% DatatoPlot: nchannel x n timepoints single matrix of data to calculate csd with
% 6. TimeRangetoPlot: Time vector as double with one time point for each
% sample of DatatoPlot
% 7. Plottype: string, "Initial" if plotted for first time or if figure handles are
% supposed to be overwritten. "Non" otherwise 
% 8. LockCLim: 1 or 0 as double. 1 to only update clim when current clim
% exceeds global clim from csd window

% Output:
% 1. currentClim: global clim - either unchanged from previous csd plot if
% limits were no exceeded or current clim otherwise. 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

nChan = size(DatatoPlot,1);
ds = (0:nChan)*ChannelSpacing; %depth in micrometers given 50 µm spacing

[csd] = Analyse_Main_Window_Compute_CSD(DatatoPlot',ChannelSpacing,hamwidth);

%% Plot 

xlim(Figure,[TimeRangetoPlot(1),TimeRangetoPlot(end)]);
ylim(Figure,[ds(1),ds(end)]);
titlestring = strcat("Current source density analysis of main window time range channel ",ChannelSelection);
title(Figure,titlestring);

if ~isempty(Figure.Children) && Plottype ~= "Initial"
    set(Figure.Children,'XData', TimeRangetoPlot , 'YData', ds ,'CData', csd');
else
    imagesc(Figure,TimeRangetoPlot,ds,csd') %plot CSD
    xlabel(Figure,'Time [s]')
    ylabel(Figure,'Depth [µm]') 
    cbar_handle=colorbar('peer',Figure,'location','EastOutside');
    cbar_handle.Label.String = "Signal [mV/mm^2]";
    cbar_handle.Label.Rotation = 270;
end

if LockCLim== 1
    currentClim(1) = min(csd,[],'all');
    currentClim(2) = max(csd,[],'all');

    if isempty(CSDClim)
        CSDClim = currentClim;
    else
        if currentClim(1) < CSDClim(1) && currentClim(2) < CSDClim(2)
            Figure.CLim = [currentClim(1) CSDClim(2)];
            currentClim(2) = CSDClim(2);
        elseif currentClim(1) < CSDClim(1) && currentClim(2) > CSDClim(2)
            Figure.CLim = [currentClim(1) currentClim(2)];
        elseif currentClim(1) > CSDClim(1) && currentClim(2) > CSDClim(2)
            Figure.CLim = [CSDClim(1) currentClim(2)];
            currentClim(1) = CSDClim(1);
        elseif currentClim(1) > CSDClim(1) && currentClim(2) < CSDClim(2)
            Figure.CLim = CSDClim;
            currentClim = CSDClim;
        end     
    end
else
    currentClim(1) = min(csd,[],'all');
    currentClim(2) = max(csd,[],'all');
    Figure.CLim = currentClim;
end