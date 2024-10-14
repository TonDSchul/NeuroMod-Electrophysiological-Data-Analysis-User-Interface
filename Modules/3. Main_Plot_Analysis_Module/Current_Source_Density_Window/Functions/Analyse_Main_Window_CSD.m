function [currentClim,CurrentPlotData] = Analyse_Main_Window_CSD(hamwidth,ChannelSpacing,ChannelSelection,CSDClim,Figure,DatatoPlot,TimeRangetoPlot,Plottype,LockCLim,TwoORThreeD,CurrentPlotData,PlotAppearance)

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
% 9. TwoORThreeD: string, either "TwoD" or "ThreeD", specifies number of
% dimensions of plot
% 10. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them
% 11. PlotAppearance: structure holding information about plot appearances
% the user can select

% Output:
% 1. currentClim: global clim - either unchanged from previous csd plot if
% limits were no exceeded or current clim otherwise. 
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

nChan = size(DatatoPlot,1);
ds = (0:nChan)*ChannelSpacing; %depth in micrometers given 50 µm spacing

[csd,~] = Analyse_Main_Window_Compute_CSD(DatatoPlot',ChannelSpacing,hamwidth);

%% Plot 

xlim(Figure,[TimeRangetoPlot(1),TimeRangetoPlot(end)]);
ylim(Figure,[ds(1),ds(end-1)]);
titlestring = strcat("Current source density analysis of main window time range channel ",ChannelSelection);
title(Figure,titlestring);
xlabel(Figure,PlotAppearance.LiveCSDWindow.XLabel)
ylabel(Figure,PlotAppearance.LiveCSDWindow.YLabel) 
Figure.FontSize = PlotAppearance.LiveCSDWindow.FontSize;

if strcmp(TwoORThreeD,"TwoD")
    PowerDepth_handles = findobj(Figure, 'Tag', 'PowerDepth');
    if length(PowerDepth_handles)>1
        delete(PowerDepth_handles(2:end))
        PowerDepth_handles = findobj(Figure, 'Tag', 'PowerDepth');
    end
    % 2D Plot
    min_z = 0;
    if isempty(PowerDepth_handles)
        surface(Figure,TimeRangetoPlot, ds(1:size(csd,2)), min_z * ones(size(csd')), ...
        'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth');
        cbar_handle=colorbar('peer',Figure,'location','EastOutside');
        cbar_handle.Label.String = PlotAppearance.LiveCSDWindow.CLabel;
        cbar_handle.Label.Rotation = 270;
    else
        set(PowerDepth_handles(1),'XData', TimeRangetoPlot, 'YData', ds(1:size(csd,2)), 'ZData', min_z * ones(size(csd')), ...
        'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth');
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
        cbar_handle=colorbar('peer',Figure,'location','EastOutside');
        cbar_handle.Label.String = PlotAppearance.LiveCSDWindow.CLabel;
        cbar_handle.Label.Rotation = 270;
        % 3D Plot
        surf(Figure,TimeRangetoPlot,ds(1:size(csd,2)),csd','EdgeColor', 'none','Tag','PowerDepth3D')
        % 2D Plot
        min_z = min(csd,[],'all');
        surface(Figure,TimeRangetoPlot, ds(1:size(csd,2)), min_z * ones(size(csd')), ...
        'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth2D');
    else
        % 3D Plot
        set(PowerDepth3D_handles(1),'XData', TimeRangetoPlot,'YData', ds(1:size(csd,2)),'CData',csd','ZData',csd','EdgeColor', 'none','Tag','PowerDepth3D')
        % 2D Plot
        min_z = min(csd,[],'all');
        set(PowerDepth2D_handles(1),'XData',TimeRangetoPlot,'YData', ds(1:size(csd,2)), 'ZData', min_z * ones(size(csd')), ...
        'CData', csd', 'FaceColor', 'texturemap', 'EdgeColor', 'none','Tag','PowerDepth2D');
    end

    view(Figure,45,45);
    box(Figure, 'off');
    grid(Figure, 'off');

end

%% Clim 

cmlimscsd = abs([min(csd,[],'all') max(csd,[],'all')]);
[~,cmlimscsdmax] = max(cmlimscsd);

currentClim(1) = -cmlimscsd(cmlimscsdmax);
currentClim(2) = cmlimscsd(cmlimscsdmax);

if LockCLim== 1
    if ~isempty(CSDClim)
        if abs(currentClim(1)) > abs(CSDClim(1))
            Figure.CLim = currentClim;
        else
            Figure.CLim = CSDClim;
            currentClim = CSDClim;
        end
    else
        Figure.CLim = currentClim;
    end
else
    Figure.CLim = currentClim;
end

%% save plotted data in case user wants to save 
CurrentPlotData.XData = TimeRangetoPlot;
CurrentPlotData.YData = ds(1:size(csd,2));
CurrentPlotData.CData = csd';
CurrentPlotData.Type = "Current Source Density";
CurrentPlotData.XTicks = Figure.XTickLabel;