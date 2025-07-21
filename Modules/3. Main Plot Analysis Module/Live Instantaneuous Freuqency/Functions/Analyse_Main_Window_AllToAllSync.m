function [CurrentPlotData] = Analyse_Main_Window_AllToAllSync(Figure3,Hilbert_Phases,PlotAppearance,CurrentPlotData,SelectedChannel)

%% All To All synchronization

nchans = size(Hilbert_Phases,1);

% initialize
synchmat = zeros(2,nchans,nchans);

for chani=1:nchans
    for chanj=1:nchans

        %%% Time window 1
        % extract angles
        tmpAi = Hilbert_Phases(chani,:);
        tmpAj = Hilbert_Phases(chanj,:);
        % synch on each trial
        % length of average vector of phase angle differences embedded in eulers formular
        synchmat(1,chani,chanj) = abs(mean(exp(1i*( tmpAi-tmpAj )),2));
    end
end


%% Plot

SynchMat_handle = findobj(Figure3, 'Tag', 'SynchMat');

if length(SynchMat_handle)>1
    delete(SynchMat_handle(2:end));
end

% show difference
if isempty(SynchMat_handle)
    imagesc(Figure3,squeeze(synchmat(1,:,:)),'Tag','SynchMat')

    xlabel(Figure3,PlotAppearance.PhaseSyncPlots.AlltoAllXLabel)
    ylabel(Figure3,PlotAppearance.PhaseSyncPlots.AlltoAllYLabel)
    
    title(Figure3,PlotAppearance.PhaseSyncPlots.AlltoAllTitle);
    cbar_handle=colorbar('peer',Figure3,'location','EastOutside');
    cbar_handle.Label.String = PlotAppearance.PhaseSyncPlots.AlltoAllCLabel;
    cbar_handle.Label.Rotation = 270;
    cbar_handle.Color = 'k';  
    cbar_handle.Label.Color = 'k';        % Sets the color of the label text

    cbar_handle.FontSize = PlotAppearance.PhaseSyncPlots.AlltoAllFontSize-1.5;
    Figure3.FontSize = PlotAppearance.PhaseSyncPlots.AlltoAllFontSize;
else
    set(SynchMat_handle,'CData', squeeze(synchmat(1,:,:)), 'Tag', 'SynchMat'); % Replace image data
end

%% costume y labels

Figure3.YTick = 1:length(SelectedChannel);
Figure3.YTickLabel = string(SelectedChannel);
Figure3.XTick = 1:length(SelectedChannel);
Figure3.XTickLabel = string(SelectedChannel);

xlim(Figure3,[0.5 size(Hilbert_Phases,1)+0.5]);
ylim(Figure3,[0.5 size(Hilbert_Phases,1)+0.5]);

%% save plotted data in case user wants to save 
CurrentPlotData.AllToAllSyncXData = 1:nchans;
CurrentPlotData.AllToAllSyncYData = 1:nchans;
CurrentPlotData.AllToAllSyncCData = squeeze(synchmat(1,:,:));
CurrentPlotData.AllToAllSyncType = "All to All Active Channel Synhcronization Strength (Avg phase differences vector lengths)";
CurrentPlotData.AllToAllSyncXTicks = Figure3.XTickLabel;