function [Curation] = Spike_Module_Check_For_Curation(Data,SorterPath)

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
    disp("Could not determine whether spiked ata was curated.")
end