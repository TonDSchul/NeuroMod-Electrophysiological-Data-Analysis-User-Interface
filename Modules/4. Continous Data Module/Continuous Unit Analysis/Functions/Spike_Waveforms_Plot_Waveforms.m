function CurrentPlotData = Spike_Waveforms_Plot_Waveforms(Data,Units,Waveforms,SpikeCluster,Waves,figs,CurrentPlotData)

%________________________________________________________________________________________
%% Function to calculate and plot the selected number of waveforms to plot

% This function is called in the unit analysis window when the ISI has to
% be computed

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% 2. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 3. Waveforms: nspikes x ntimewaveform matrix holding waveform for each
% spike
% 4. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 5. Waves: 1x3 cell array, each cell contains the nr of waveforms to plot as a 1 x nwaveforms vector
% 6. figs: structure, each field is a figure object handle to plot in
% 7. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Prepare Data
MaxNrUnits = 0;
for i = 1:length(Units)
    if length(Units{i})>MaxNrUnits
        MaxNrUnits = length(Units{i});
    end
end

%% Time vector for plot
Time = (0:1/Data.Info.NativeSamplingRate:(size(Waveforms,2)-1)/Data.Info.NativeSamplingRate)*1000; %IN MS
%% Color map
colorMatrix = jet(MaxNrUnits);
for nplots = 1:length(Units)
    if ~isempty(Units{nplots})
        na = strcat("UIAxes_",num2str(nplots));
        Figurename = figs.(na);
        title(Figurename,strcat("Biggest Waveforms Unit(s) ",num2str(Units{nplots})));
        xlabel(Figurename,"Time [ms]")
        ylabel(Figurename,"Signal [mV]")
        Figurename.FontSize = 9;
    end
end
%% SpikeCLuster indexing starts with 1
if min(SpikeCluster) == 0
    SpikeCluster = SpikeCluster+1;
end

%% Loop over all three plots
for nplots = 1:length(Units)
    
    legendEntries = {}; % Cell array to store legend entries
    LegendHandles = [];
    if isempty(Units{nplots})
        continue;
    end

    %disp(strcat("Plot ",num2str(nplots)));
    na = strcat("UIAxes_",num2str(nplots));
    Figurename = figs.(na);

    Waveformhandles = findobj(Figurename, 'Tag', 'Waveforms');
    MeanWaveformhandles = findobj(Figurename, 'Tag', 'MeanWaveforms');
    
    NrUnitPlots = 0;
    NrMeanPlots = 0;

    for nindividualunits = 1:length(Units{nplots}) % Loop over all units per plot
        % Spike Indicies of the current unit
        Indicies = SpikeCluster == Units{nplots}(nindividualunits);

        TempClusterWaves = Waveforms(Indicies,:);
        % get biggest waveforms
        if sum(Indicies)>0  
            [~,BiggestAmplitudeIndex] = maxk(max(abs(TempClusterWaves),[],2),Waves{nplots});
        
            TempWaves = TempClusterWaves(BiggestAmplitudeIndex,:);
        end

        if sum(Indicies)>0
            if isempty(Waveformhandles)
                
                for i = 1:size(TempWaves,1)
                    NrUnitPlots = NrUnitPlots+1;
                    h = line(Figurename,Time,TempWaves(i,:),'Color',colorMatrix(nindividualunits,:), 'Tag', 'Waveforms','LineWidth',0.01);
                    if i==1
                        LegendHandles = [LegendHandles,h];
                    end
                end
            else
                
                for i = 1:size(TempWaves,1)
                    NrUnitPlots = NrUnitPlots+1;
                    if length(Waveformhandles)>= NrUnitPlots % enough plot handles
                        set(Waveformhandles(NrUnitPlots),'XData',Time,'YData',TempWaves(i,:),'Color',colorMatrix(nindividualunits,:),'LineWidth',0.01, 'Tag', 'Waveforms');
                        if i==1
                            LegendHandles = [LegendHandles,Waveformhandles(NrUnitPlots)];
                        end
                    elseif length(Waveformhandles) < NrUnitPlots % enough plot handles
                        h = line(Figurename,Time,TempWaves(i,:),'Color',colorMatrix(nindividualunits,:),'LineWidth',0.01, 'Tag', 'Waveforms');
                        if i==1
                            LegendHandles = [LegendHandles,h];
                        end
                    end
                end

            end
            
            %% Plot Mean
            if isempty(MeanWaveformhandles)
                NrMeanPlots = NrMeanPlots+1;
                meanline = line(Figurename,Time,mean(TempWaves,1),'Color','k','LineWidth',1, 'Tag', 'MeanWaveforms');
            else
                NrMeanPlots = NrMeanPlots+1;
                if length(MeanWaveformhandles) > NrMeanPlots
                    set(MeanWaveformhandles(NrMeanPlots),'XData',Time,'YData',mean(TempWaves,1),'Color','k','LineWidth',1, 'Tag', 'MeanWaveforms');
                    meanline = MeanWaveformhandles(NrMeanPlots);
                else
                    meanline = line(Figurename,Time,mean(TempWaves,1),'Color','k','LineWidth',1, 'Tag', 'MeanWaveforms');
                end
            end

            uistack(meanline, 'top'); 

            %% Save results to ba able to export 
            CurrentPlotData.UnitAnalyisWaveformsXData{nplots,nindividualunits} = Time;
            CurrentPlotData.UnitAnalyisWaveformsYData{nplots,nindividualunits} = TempWaves;
            CurrentPlotData.UnitAnalyisWaveformsCData{nplots,nindividualunits} = [];
            
            if strcmp(Data.Info.SpikeType,"Kilosort")
                CurrentPlotData.UnitAnalyisWaveformsType{nplots,nindividualunits} = strcat("Continous Kilosort Unit ",num2str(Units{nplots}(nindividualunits))," Analyis: Waveforms");
            else
                CurrentPlotData.UnitAnalyisWaveformsType{nplots,nindividualunits} = strcat("Continous Internal Unit ",num2str(Units{nplots}(nindividualunits))," Analyis: Waveforms");
            end

            CurrentPlotData.UnitAnalyisWaveformsXTicks{nplots,nindividualunits} = Figurename.XTickLabel;

            legendEntries{end + 1} = [strcat("Unit ",num2str(Units{nplots}(nindividualunits)))];

            % Waveformhandles = findobj(Figurename, 'Tag', 'Waveforms');
            % legendEntries = legend(Figurename,Waveformhandles(1),strcat("Unit ",num2str(Units{nplots}(nindividualunits))));

        end
    end % individual units
    
    legend(Figurename, LegendHandles, legendEntries);
    Waveformhandles = findobj(Figurename, 'Tag', 'Waveforms');
    MeanWaveformhandles = findobj(Figurename, 'Tag', 'MeanWaveforms');

    if length(Waveformhandles)>NrUnitPlots
        delete(Waveformhandles(NrUnitPlots+1:end));
    end

    if length(MeanWaveformhandles)>NrMeanPlots
        delete(MeanWaveformhandles(NrMeanPlots+1:end));
    end
    
    drawnow;

end % 3 plots

