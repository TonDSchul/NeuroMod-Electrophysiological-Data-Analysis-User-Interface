function [currentClim,CurrentPlotData] = Analyse_Main_Window_CSD(DatatoPlot,Time,hamwidth,ChannelSpacing,CSDClim,Figure,LockCLim,TwoORThreeD,CurrentPlotData,PlotAppearance,Data,EventData,Samplefrequency,SelectedEventIndice,PlotEvent,DataType)

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
% 6. Time: Time vector as double with one time point for each
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
% 12. Data: main window data structure with all relevant data components
% 13. EventData: vector with all event indices of the currently selected
% event channel in the main window
% 14. Samplefrequency: double, current sample frequency in Hz. Not from
% Data.Info in case data was downsampled --> autodetection before this fct
% is called which smaplerate is correct
% 15. SelectedEventIndice: Indicie of the event channel that is currently
% selected, out of all event channel (from cell array in Data.Info.EventChannelNames)
% 16. PlotEvent: char from Main window, 'Events' to show that events are plotted and potentially part of the current data window being analysed 
% 17. DataType: char, either 'Preprocessed Data' or 'Raw Data' to analyse
% for the raw or preprocessed GUI dataset

% Output:
% 1. currentClim: global clim - either unchanged from previous csd plot if
% limits were no exceeded or current clim otherwise. 
% 2. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if size(DatatoPlot,1)<3
    currentClim = [];
    CurrentPlotData = [];
    msgbox("At least 3 channel required for CSD! Returning.")
    return;
end

% Distinguish between downsampled data and normal data
nChan = size(DatatoPlot,1);
ds = (0:nChan)*ChannelSpacing; %depth in micrometers given 50 µm spacing

[csd,~] = Analyse_Main_Window_Compute_CSD(DatatoPlot',ChannelSpacing,hamwidth,Data,DataType);

%% Plot 

xlim(Figure,[Time(1),Time(end)]);
DepthDiff = (ds(2) - ds(1))/2;


if strcmp(TwoORThreeD,"TwoD")
    PowerDepth_handles = findobj(Figure, 'Tag', 'PowerDepth');
    if length(PowerDepth_handles)>1
        delete(PowerDepth_handles(2:end))
        PowerDepth_handles = findobj(Figure, 'Tag', 'PowerDepth');
    end
    % 2D Plot
    if isempty(PowerDepth_handles)
        imagesc(Figure,Time, ds(1:size(csd,2)),csd','Tag','PowerDepth');
        cbar_handle=colorbar('peer',Figure,'location','EastOutside');
        cbar_handle.Label.String = PlotAppearance.LiveCSDWindow.CLabel;
        cbar_handle.Label.Rotation = 270;
        cbar_handle.Color = 'k';  
        cbar_handle.Label.Color = 'k';        % Sets the color of the label text

        titlestring = strcat("Current Source Density Analysis of Main Window Plot");
        title(Figure,titlestring);
        xlabel(Figure,PlotAppearance.LiveCSDWindow.XLabel)
        ylabel(Figure,PlotAppearance.LiveCSDWindow.YLabel) 
        Figure.FontSize = PlotAppearance.LiveCSDWindow.FontSize;
        
        Figure.XLabel.Color = [0 0 0];
        Figure.YLabel.Color = [0 0 0];       
        Figure.YColor = 'k';  
        %UIAxes.XTickLabelMode = 'auto';
        Figure.XColor = 'k';  
        Figure.Title.Color = 'k';  
        Figure.Box ="off";

    else
        set(PowerDepth_handles(1),'XData', Time, 'YData', ds(1:size(csd,2)), ...
        'CData', csd','Tag','PowerDepth');
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
        surf(Figure,Time,ds(1:size(csd,2)),csd','EdgeColor', 'none','Tag','PowerDepth3D')
        % % 2D Plot
        titlestring = strcat("Current Source Density Analysis of Main Window Plot");
        title(Figure,titlestring);
        xlabel(Figure,PlotAppearance.LiveCSDWindow.XLabel)
        ylabel(Figure,PlotAppearance.LiveCSDWindow.YLabel) 
        Figure.FontSize = PlotAppearance.LiveCSDWindow.FontSize;
        
        Figure.XLabel.Color = [0 0 0];
        Figure.YLabel.Color = [0 0 0];       
        Figure.YColor = 'k';  
        %UIAxes.XTickLabelMode = 'auto';
        Figure.XColor = 'k';  
        Figure.Title.Color = 'k';  
        Figure.Box ="off";

        cbar_handle=colorbar('peer',Figure,'location','EastOutside');
        cbar_handle.Label.String = PlotAppearance.LiveCSDWindow.CLabel;
        cbar_handle.Label.Rotation = 270;
        cbar_handle.Color = 'k';  
        cbar_handle.Label.Color = 'k';        % Sets the color of the label text
    else
        % 3D Plot
        set(PowerDepth3D_handles(1),'XData', Time,'YData', ds(1:size(csd,2)),'CData',csd','ZData',csd','EdgeColor', 'none','Tag','PowerDepth3D')

    end

    view(Figure,45,45);
    box(Figure, 'off');
    grid(Figure, 'off');

end

ylim(Figure,[ds(1)-DepthDiff,ds(end-1)+DepthDiff]);

%% --------------- Handle Events ---------------
if strcmp(PlotEvent,'Events')
    Analyse_Main_Window_Plot_Events(Figure,Data,Time,EventData,0-DepthDiff,ds(size(csd,2))+DepthDiff,Samplefrequency,SelectedEventIndice)
else
    Eventline_handles = findobj(Figure,'Type', 'line', 'Tag', 'Events');
    delete(Eventline_handles); 
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
CurrentPlotData.XData = Time;
CurrentPlotData.YData = ds(1:size(csd,2));
CurrentPlotData.CData = csd';
CurrentPlotData.Type = "Current Source Density";
CurrentPlotData.XTicks = Figure.XTickLabel;