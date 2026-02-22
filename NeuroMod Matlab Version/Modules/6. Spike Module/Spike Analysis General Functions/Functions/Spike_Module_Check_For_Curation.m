function [Curation] = Spike_Module_Check_For_Curation(Data,SorterPath)

%________________________________________________________________________________________

%%  Function to check whether manualy curation can be determined by new_cluster_id.json file being present

% This gets called in the
% 'Manage_Dataset_Module_Extract_Raw_Recording_Main' function when Intan is
% identified as the recording system

% Input:
% 1. Data: mian window data structure
% 2. SorterPath: char, path to the spike sorting results

% Output: 
% 1. Curation: 1 or 0 whether curation could be determined (1) or not (0)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


Curation = 0;

try
    PhyFolder = strcat(SorterPath,"\.phy");
    PhyFile  = strcat(PhyFolder,"\new_cluster_id.json");
    
    if isfolder(PhyFolder)
        if isfile(PhyFile)
            Curation = 1;
        end
    end
catch
    disp("Could not determine whether spiked data was curated.")
end