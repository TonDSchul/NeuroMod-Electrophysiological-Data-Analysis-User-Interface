function [Units,Waves,Wavefigs,ISIfigs,AutoCfigs,SpikeTimes,SpikePositions,SpikeCluster,SpikeWaveforms,SpikeChannel] = Spike_Module_Prepare_WaveForm_Window_and_Analysis(Data,U1,U2,U3,W1,W2,W3,F1,F2,F3,F4,F5,F6,F7,F8,F9,Type,SpikeWindow)

%________________________________________________________________________________________
%% Function to calculate and plot the selected number of waveforms to plot

% This function is called in the unit analysis window to prepare and check data for
% plotting

% Note: computed for all spikes, not only selected nr of waveforms. Is computed channel wise to avoid artefacts from channel in loop. 

% Inputs:
% 1. Data: data structure from the main window holding spike data
% F1, F2.. = figure handles for figures 1 to 3 for current plot
% U1, U2.. = app.UnitSelection.Value for all 3 of those objects in the app
% window
% W1, W2.. = app.WaveSelection.Value for all 3 of those objects in the app
% window
% 3. Type: string representing what was changed by the user, either "U1" or
% "U2" or "U3" --> U1 when first unit input field was changed, U2 for
% second and so on
% 4. SpikeWindow: "EventWindow" when started from the event module,
% "ContinousWindow" when started from the continous module

% Outputs

% 1. Units: 1x3 cell array, each cell contains the units for a plot as a 1 x nunits vector
% 2. Waves: 1x3 cell array, each cell contains the nr of waveforms for a plot as a 1 x nunits vector
% 3. Wavefigs: structure, each field is a figure object handle to plot waveforms in
% 4. ISIfigs: structure, each field is a figure object handle to plot ISI's in
% 5. AutoCfigs: structure, each field is a figure object handle to plot Autocorrelogram in
% 6. SpikeTimes: nspikes x 1 with spike times in samples
% 7. SpikePositions: nspikes x 1 with nr of channel for each spike (for kilosort in um, for internal spikes channel identity)
% 8. SpikeCluster: nspikes x 1 with cluster/unit identity of each spike
% 9. SpikeWaveforms: nspikes x ntimewaveform matrix holding waveform for each
% spike
% 10. SpikeChannel: nspikes x 1 with nr of channel for each spike

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Event Window: Just select spike indicies of events selected

if strcmp(SpikeWindow,"EventWindow")
    %% Select Data based on Event Selecio
    
    EventRange = 1:size(Data.EventRelatedData,2);
    
    EventIndicies = zeros(length(Data.EventRelatedSpikes.SpikeEvents),1);

    for i = 1:length(EventRange)
        EventIndicies = EventIndicies + (Data.EventRelatedSpikes.SpikeEvents == EventRange(i));
    end

    EventIndicies(EventIndicies>=1) = 1;
    
    SpikeTimes = Data.EventRelatedSpikes.SpikeTimes(EventIndicies==1);
    SpikePositions = Data.EventRelatedSpikes.SpikePositions(EventIndicies==1);
    SpikeChannel = Data.EventRelatedSpikes.SpikeChannel(EventIndicies==1);
    SpikeCluster = Data.EventRelatedSpikes.SpikeCluster(EventIndicies==1);
    SpikeWaveforms = Data.EventRelatedSpikes.SpikeWaveforms(EventIndicies==1,:);

else
    SpikeTimes = Data.Spikes.SpikeTimes;
    SpikePositions = Data.Spikes.SpikePositions(:,2);
    SpikeCluster = Data.Spikes.SpikeCluster;
    SpikeWaveforms = Data.Spikes.Waveforms;
    SpikeChannel = Data.Spikes.SpikeChannel;
end

MaxNrUnits = length(unique(Data.Spikes.SpikeCluster));
%% Prepare inputs

Units = cell(1,3);

for nUnits = 1:3
    commaindex = eval(strcat("find(U",num2str(nUnits),"==',')"));
    Unitvalue = eval(strcat("U",num2str(nUnits)));
    % Unit 1
    if ~isempty(commaindex)
        for i = 1:length(commaindex)+1
            if i == 1
                if str2double(Unitvalue(1:commaindex(1)-1))<=MaxNrUnits
                    Units{nUnits}(i) = str2double(Unitvalue(1:commaindex(1)-1));
                else
                    Units{nUnits}(i) = MaxNrUnits;
                    msgbox("Warning: Specified Unit(s) number exceed max number of units. Autochanged to last cluster!");
                end
            elseif i == length(commaindex)+1
                if str2double(Unitvalue(commaindex(end)+1:end))<=MaxNrUnits
                    Units{nUnits}(i) = str2double(Unitvalue(commaindex(end)+1:end));
                else
                    Units{nUnits}(i) = MaxNrUnits;
                    msgbox("Warning: Specified Unit(s) number exceed max number of units. Autochanged to last cluster!");
                end
            else
                if str2double(Unitvalue(commaindex(i-1)+1:commaindex(i)-1))<=MaxNrUnits
                    Units{nUnits}(i) = str2double(Unitvalue(commaindex(i-1)+1:commaindex(i)-1));
                else
                    Units{nUnits}(i) = MaxNrUnits;
                    msgbox("Warning: Specified Unit(s) number exceed max number of units. Autochanged to last cluster!");
                end
            end  
        end
    else
        if isnumeric(str2double(Unitvalue))
            if str2double(Unitvalue)<=MaxNrUnits
                Units{nUnits} = str2double(Unitvalue);
            else
                Units{nUnits} = MaxNrUnits;
                msgbox("Warning: Specified Unit(s) number exceed max number of units. Autochanged to last cluster!");
            end
        else
            msgbox("Warning: No numeric input. Autoadjusted to unit 1");
            Units{nUnits} = 1;
        end
    end % if comma
end % Unit loop

%% Plot Waveforms
Waves{1} = str2double(W1);
Waves{2} = str2double(W2);
Waves{3} = str2double(W3);

if strcmp(Type,"U1") || strcmp(Type,"W1")
    Units{2} = [];
    Units{3} = [];
    Waves{2} = [];
    Waves{3} = [];
elseif strcmp(Type,"U2") || strcmp(Type,"W2")
    Units{1} = [];
    Units{3} = [];
    Waves{1} = [];
    Waves{3} = [];
elseif strcmp(Type,"U3") || strcmp(Type,"W3")
    Units{1} = [];
    Units{2} = [];
    Waves{1} = [];
    Waves{2} = [];
elseif strcmp(Type,"BinSize")

elseif strcmp(Type,"ISIMaxTime")

end

%% Figures
Wavefigs.UIAxes_1 = F1;
Wavefigs.UIAxes_2 = F2;
Wavefigs.UIAxes_3 = F3;

ISIfigs.UIAxes_1 = F4;
ISIfigs.UIAxes_2 = F5;
ISIfigs.UIAxes_3 = F6;

AutoCfigs.UIAxes_1 = F7;
AutoCfigs.UIAxes_2 = F8;
AutoCfigs.UIAxes_3 = F9;