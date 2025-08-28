function [Data,SaveFilter] = Spike_Module_Internal_Spike_Sorting(Data,SpikeSortingPath,WhatToDo,ClusterType,CurrentSorter)

%________________________________________________________________________________________

%% Function to manage wave clus 3 toolbox to conduct spike sorting

% This function is called when the user either creates a new spike sorting
% with wave clus 3 or loads existing spike data. It takes the spike times
% obtained from the internal spike detection, saves it as a .mat file and
% passes that path into wave clus 3 to perform spike sorting. Standard
% folder is 'Recording_Path/Wave_Clus'.

% Input:
% 1. Data: main window data structure
% 2. SpikeSortingPath: char, folder to save spike times to / load spike sorting from; standard 'Recording_Path/Wave_Clus'
% 3. WhatToDo: string, either "Clustering" to perform new spike sorting OR
% "Loading" to only load spike cluserting results (actually the string doesnt matter, spike sorting results have to be loaded in any case. Only determines if wave clus 3 is executed)
% 4. ClusterType: string, either "AllChannelTogether" OR "IndividualChannel"
% 5. CurrentSorter: string, currently only "Waveclus" (sets the Info.Sorter value)

% Output: 
% 1. Data structure with added field 'Spikes' (Data.Spikes); Now
% Spike.SpikeCluster contains the unit identities of each spike. 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if strcmp(WhatToDo,"Clustering")
    
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
    

    if strcmp(ClusterType,'IndividualChannel')

        disp("Saving Spike Times in one file for each channel to load into wave_clus")
    
        h = waitbar(0, 'Preparing Clustering...', 'Name','Preparing Clustering...');
    
        for nchannel = 1:size(Data.Raw,1)
    
            SpikeforChannel = Data.Spikes.SpikePositions(:,2)==nchannel;
    
            if sum(SpikeforChannel)>0
                spikes = Data.Spikes.Waveforms(SpikeforChannel,:);
                index = (Data.Spikes.SpikeTimes(SpikeforChannel)*(1/Data.Info.NativeSamplingRate))*1000; % take spike times from which waveforms were obtained and convert to ms
                sr = Data.Info.NativeSamplingRate;
            else
                spikes = [];
                index = []; % take spike times from which waveforms were obtained and convert to ms
                sr = Data.Info.NativeSamplingRate;
            end
        
            TempSpikes = Data.Spikes;
    
            SpikeInfo.DetectionThreshold = Data.Info.SpikeDetectionThreshold;
            SpikeInfo.NrStdThreshold = Data.Info.SpikeDetectionNrStd;
            save(strcat(SpikeSortingPath,'\Ch',num2str(nchannel),'_spikes.mat'),"index","spikes","sr","TempSpikes","SpikeInfo");
    
            msg = sprintf('Preparing Clustering... (%d%% done)', round(100*(nchannel/size(Data.Raw,1))));
            waitbar(nchannel/size(Data.Raw,1), h, msg);
    
        end
        
        TempSpikes = Data.Spikes;
        save(strcat(SpikeSortingPath,'\GUISpikeData.mat'),"TempSpikes");
        clear TempSpikes

        disp('Spike Data succesfully saved for Sorting. Please watch the Matlab command window to see when sorting finished.');
        
        disp('Starting Spike Sorting.');

        close(h);

        %% Call wave clus
    
        ChannelNumVector = 1:size(Data.Raw,1);
        
        Do_clustering(ChannelNumVector,'parallel',true,'make_plots',false)

    elseif strcmp(ClusterType,'AllChannelTogether')

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
        save(strcat(SpikeSortingPath,'\times_spikes.mat'),"index","spikes","sr","TempSpikes","SpikeInfo");
        clear TempSpikes

        disp('Spike Data succesfully saved for Sorting.');
        
        disp('Starting Spike Sorting.');

        %% Call wave clus
    
        Do_clustering(strcat(SpikeSortingPath,'\times_spikes.mat'),'parallel',true,'make_plots',false)

    end

    msgbox("Spike Sorting was succesfull.");
    
end

if isfile(strcat(strcat(SpikeSortingPath,'\times_spikes.mat')))
    disp('Loading Spike Sorting Data.');
    % First Load Spike Data and check whether its the same
    load(strcat(strcat(SpikeSortingPath,'\times_spikes.mat')),'TempSpikes','SpikeInfo');
    
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

    if min(Data.Spikes.SpikeChannel)==0
        Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel+1;
    end

    Data.Spikes.SpikeCluster = cluster_class(:,1);
    Data.Info.SpikeType = "Internal";
    Data.Info.Sorter = CurrentSorter;

    msgbox("Spike Sorting Data succesfully loaded.");

elseif isfile(strcat(strcat(SpikeSortingPath,'\Ch1_spikes.mat')))
    
    disp('Loading Spike Sorting Data.');

    load(strcat(strcat(SpikeSortingPath,'\Ch1_spikes.mat')),'SpikeInfo');
    load(strcat(strcat(SpikeSortingPath,'\GUISpikeData.mat')),'TempSpikes');
    
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

    StartClusterNr = 0;

    if min(Data.Spikes.SpikeChannel)==0
        Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel+1;
    end
    
    Data.Spikes.SpikeCluster = zeros(size(Data.Spikes.SpikeTimes));

    for nchannel = 1:size(Data.Raw,1)
        
         if isfile(strcat(SpikeSortingPath,'\times_Ch',num2str(nchannel),'.mat'))
             load(strcat(strcat(SpikeSortingPath,'\times_Ch',num2str(nchannel),'.mat')),'cluster_class','par');
             SpikesInChanel = Data.Spikes.SpikePositions(:,2) == nchannel;
                
             if sum(SpikesInChanel) == length(cluster_class)
    
             else
                warning(strcat("More spikes in cluster results for channel ",num2str(nchannel)," than in oroginal dataset. Please check that you loaded the correct wave_clus results folder"))
             end
    
             if nchannel==1
                 if sum(cluster_class(:,1) == 0) >0
                    cluster_class(:,1) = cluster_class(:,1)+1;
                 end
                 
                Data.Spikes.SpikeCluster(SpikesInChanel) = cluster_class(:,1);
    
             else
                numclusters = length(unique(Data.Spikes.SpikeCluster))-1; % -1 bc of 0 
    
                if sum(cluster_class(:,1) == 0) >0
                    cluster_class(:,1) = cluster_class(:,1)+1;
                end
    
                cluster_class(:,1) = cluster_class(:,1) + numclusters;
    
                Data.Spikes.SpikeCluster(SpikesInChanel) = cluster_class(:,1);
             end
         end
    end

    Data.Info.SpikeType = "Internal";
    Data.Info.Sorter = CurrentSorter;

    msgbox("Spike Sorting Data succesfully loaded.");

else
    msgbox("Warning: No Spike Clustering Found!.");
end


