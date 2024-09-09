function [Units,Waves,Wavefigs,ISIfigs,AutoCfigs,SpikeTimes,SpikePositions,SpikeCluster,SpikeWaveforms,SpikeChannel] = Spike_Module_Prepare_WaveForm_Window_and_Analysis(Data,U1,U2,U3,W1,W2,W3,F1,F2,F3,F4,F5,F6,F7,F8,F9,Type,SpikeWindow)

%%
% F1, F2.. = figure handles
% U1, U2.. = app.UnitSelection.Value
% W1, W2.. = app.WaveSelection.Value


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