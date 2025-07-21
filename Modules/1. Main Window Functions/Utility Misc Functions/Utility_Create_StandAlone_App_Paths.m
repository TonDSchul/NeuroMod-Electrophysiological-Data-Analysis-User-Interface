function Utility_Create_StandAlone_App_Paths(executableFolder)

%% Recording Folder
RecordingFolder(1) = strcat(executableFolder,"/Recording Data/");
if ~isfolder(RecordingFolder(1))
    mkdir(RecordingFolder(1));
end
RecordingFolder(2) = strcat(executableFolder,"/Recording Data/Example Data/");
if ~isfolder(RecordingFolder(2))
    mkdir(RecordingFolder(2));
end
RecordingFolder(3) = strcat(executableFolder,"/Recording Data/Raw Recordings/");
if ~isfolder(RecordingFolder(3))
    mkdir(RecordingFolder(3));
end
RecordingFolder(4) = strcat(executableFolder,"/Recording Data/Saved GUI Data/");
if ~isfolder(RecordingFolder(4))
    mkdir(RecordingFolder(4));
end

%% Probe Layout Folder
ProbeLayoutFolder(1) = strcat(executableFolder,"/Probe Layouts");
if ~isfolder(ProbeLayoutFolder(1))
    mkdir(ProbeLayoutFolder(1));
end
ProbeLayoutFolder(2) = strcat(executableFolder,"/Probe Layouts/Channel Orders");
if ~isfolder(ProbeLayoutFolder(2))
    mkdir(ProbeLayoutFolder(2));
end
ProbeLayoutFolder(3) = strcat(executableFolder,"/Probe Layouts/Kilosort Channelmaps");
if ~isfolder(ProbeLayoutFolder(3))
    mkdir(ProbeLayoutFolder(3));
end
ProbeLayoutFolder(4) = strcat(executableFolder,"/Probe Layouts/Saved Probe Layouts");
if ~isfolder(ProbeLayoutFolder(4))
    mkdir(ProbeLayoutFolder(4));
end
ProbeLayoutFolder(5) = strcat(executableFolder,"/Probe Layouts/Trajectories");
if ~isfolder(ProbeLayoutFolder(5))
    mkdir(ProbeLayoutFolder(5));
end
ProbeLayoutFolder(6) = strcat(executableFolder,"/Probe Layouts/Active Channel");
if ~isfolder(ProbeLayoutFolder(6))
    mkdir(ProbeLayoutFolder(6));
end

%% Analysis Results
AnalysisResultsFolder(1) = strcat(executableFolder,"/Analysis Results");
if ~isfolder(AnalysisResultsFolder(1))
    mkdir(AnalysisResultsFolder(1));
end

%% Autorun Configs
AutorunFolder(1) = strcat(executableFolder,"/Autorun Configs/Config_Files");
if ~isfolder(AutorunFolder(1))
    mkdir(AutorunFolder(1));
end

%% MISC Variables
MISCFolder(1) = strcat(executableFolder,"/Modules/MISC/Variables (do not edit)");
if ~isfolder(MISCFolder(1))
    mkdir(MISCFolder(1));
end

%% Default Autoruns
MISCFolder(1) = strcat(executableFolder,"/Modules/MISC/Default Autorun Configs (do not edit!)");
if ~isfolder(MISCFolder(1))
    mkdir(MISCFolder(1));
end

