function [Data] = Utility_Delete_Units (Data,UnitToDelete)

%________________________________________________________________________________________
%% Function to delete all spike information of a selected unit 

% This function gets called in the Unit Analysis window when the user
% clicks on the 'Delete Unit' Button

% Input Arguments:
% 1. Data: main window structure holding dataset (including spike data as Data.Spikes)
% 2. UnitToDelete: char, has to start with 'Unit' followed by a space
% and a number, i.e. 'Unit 10' -- space is important!

% Output Arguments:
% 1. Data: main window structure holding dataset with deleted spikes of the
% selected unit

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

TempCluster = Data.Spikes.SpikeCluster;

if min(TempCluster) == 0
    TempCluster = TempCluster+1;
end

% Convert Unitstring to unit number
spaceindex = find(UnitToDelete==' ');
UnitNumber = str2double(UnitToDelete(spaceindex+1:end));

% Delete corresponding spikes
SpikeIndiciesToDelete = TempCluster == UnitNumber;

if sum(SpikeIndiciesToDelete)>0
    Data.Spikes.SpikeTimes(SpikeIndiciesToDelete) = [];
    Data.Spikes.SpikePositions(SpikeIndiciesToDelete,:)= [];
    Data.Spikes.SpikeChannel(SpikeIndiciesToDelete)= [];
    Data.Spikes.Waveforms(SpikeIndiciesToDelete,:)= [];
    Data.Spikes.SpikeAmps(SpikeIndiciesToDelete)= [];
    
    if isfield(Data.Spikes,'DataCorrectedSpikePositions')
        Data.Spikes.DataCorrectedSpikePositions(SpikeIndiciesToDelete)= [];
    end

    % When spike cluster 10 deleted, cluster afterwards have to be
    % substarcted by 1 to ensure continoues spike cluster indicies
    TempCluster(SpikeIndiciesToDelete) = [];
    SpikeClusterBiggerThanDeleted = TempCluster > UnitNumber;
    TempCluster(SpikeClusterBiggerThanDeleted) = TempCluster(SpikeClusterBiggerThanDeleted)-1;
    
    %% The following only applies to Kilosort
    if isfield(Data.Spikes,'SpikeTemplates')
        if strcmp(Data.Info.Sorter,"SpikeInterface Kilosort") || strcmp(Data.Info.Sorter,"External Kilosort GUI")
            if ~isempty(Data.Spikes.SpikeTemplates)
                Data.Spikes.SpikeTemplates(SpikeIndiciesToDelete) = [];
            end
        end
    end
    
    try
        if isfield(Data.Spikes,'BiggestAmplWaveform')
            if ~isempty(Data.Spikes.BiggestAmplWaveform)
                Data.Spikes.BiggestAmplWaveform(UnitNumber,:) = [];
            end
        end
    
        if isfield(Data.Spikes,'pc_feature_ind')
            if ~isempty(Data.Spikes.pc_feature_ind)
                Data.Spikes.pc_feature_ind(UnitNumber,:) = [];
            end
        end
    
        if isfield(Data.Spikes,'templates')
            if ~isempty(Data.Spikes.templates)
                Data.Spikes.templates(UnitNumber,:,:) = [];
            end
        end
    
        if isfield(Data.Spikes,'templates_ind')
            if ~isempty(Data.Spikes.templates_ind)
                Data.Spikes.templates_ind(UnitNumber,:) = [];
            end
        end
    catch
        warning("Tamplate and biggest waveform information is faulty and could not be deleted!")
    end
    
end
