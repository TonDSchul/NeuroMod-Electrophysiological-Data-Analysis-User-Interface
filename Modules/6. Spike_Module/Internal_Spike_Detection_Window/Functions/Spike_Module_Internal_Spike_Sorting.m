function [Data] = Spike_Module_Internal_Spike_Sorting(Data,SpikeSortingPath,WhatToDo)

if strcmp(WhatToDo,"Clustering")
    
    spikes = Data.Spikes.Waveforms;
    index = (Data.Spikes.SpikeTimes*(1/Data.Info.NativeSamplingRate))*1000; % take spike times from which waveforms were obtained and convert to ms
    sr = Data.Info.NativeSamplingRate;

    if ~isfolder(SpikeSortingPath)
        % If the folder does not exist, create it
        dashindex = find(SpikeSortingPath=='\');
        Parentfolder = SpikeSortingPath(1:dashindex(end)-1);
        Fistdirectory = SpikeSortingPath(1:dashindex(1)-1);
        if isfolder(Parentfolder) && isfolder(Fistdirectory)
            mkdir(SpikeSortingPath);
        else
            msgbox("Recording Folder no longer available. Please select a new directory to save your clustering!");
            SpikeSortingPath = uigetdir;  % Open the file explorer for the user to select a folder

            if SpikeSortingPath ~= 0  
                disp(['Selected folder: ', SpikeSortingPath]);
            else
                disp('Folder selection was canceled.');
            end
        end
        disp(['Folder created: ', SpikeSortingPath]);
    else
        disp('The folder already exists.');
    end
    
    SpikeInfo.DetectionThreshold = Data.Info.SpikeDetectionThreshold;
    SpikeInfo.NrStdThreshold = Data.Info.SpikeDetectionNrStd;

    msgbox("Data for spike sorting was succesfull saved.");
    TempSpikes = Data.Spikes;
    save(strcat(SpikeSortingPath,'\spikes.mat'),"index","spikes","sr","TempSpikes","SpikeInfo");
    clear TempSpikes
    disp('Spike Data saved for Sorting.');
        
    disp('Starting Spike Sorting.');
    cd(SpikeSortingPath);

    Do_clustering(strcat(SpikeSortingPath,'\spikes.mat'),'parallel',true,'make_plots',false)

    msgbox("Spike Sorting was succesfull.");
    
end

if isfile(strcat(strcat(SpikeSortingPath,'\times_spikes.mat')))
    disp('Loading Spike Sorting Data.');
    % First Load Spike Data and check whether its the same
    load(strcat(strcat(SpikeSortingPath,'\spikes.mat')),'TempSpikes','SpikeInfo');
    
    if isfield(Data,'Spikes') && strcmp(Data.Info.SpikeType,"Internal")
        if ~isequal(TempSpikes.SpikeTimes,Data.Spikes.SpikeTimes) || ~isequal(TempSpikes.SpikePositions,Data.Spikes.SpikePositions)
            msgbox("Warning: Spike Data clustering was based on is not the same as current spike dataset. Current Spike Dataset is replaced.");
            Data.Spikes = TempSpikes;
            Data.Info.SpikeDetectionThreshold = SpikeInfo.DetectionThreshold;
            Data.Info.SpikeDetectionNrStd = SpikeInfo.NrStdThreshold;
            clear TempSpikes      
        else
            if Data.Info.SpikeDetectionThreshold ~= SpikeInfo.DetectionThreshold || Data.Info.SpikeDetectionNrStd ~= SpikeInfo.NrStdThreshold
                msgbox("Warning: Spike Detection Parameter from clustered spikes and current dataset are not the same. Current Spike Dataset is replaced.");
                Data.Spikes = TempSpikes;
                Data.Info.SpikeDetectionThreshold = SpikeInfo.DetectionThreshold;
                Data.Info.SpikeDetectionNrStd = SpikeInfo.NrStdThreshold;
                clear TempSpikes   
            end
        end
    else
        Data.Spikes = TempSpikes;
        Data.Info.SpikeDetectionThreshold = SpikeInfo.DetectionThreshold;
        Data.Info.SpikeDetectionNrStd = SpikeInfo.NrStdThreshold;
        clear TempSpikes     
    end

    load(strcat(strcat(SpikeSortingPath,'\times_spikes.mat')),'cluster_class','par');

    Data.Spikes.SpikeCluster = cluster_class(:,1);
    Data.Info.SpikeType = "Internal";
    Data.Info.SpikeSorting = "WaveClus";

    msgbox("Spike Sorting Data succesfully loaded.");
else
    msgbox("Warning: No Spike Clustering Found!.");
end


