This folder contains the following functions with respective Header:

 ###################################################### 

File: Spike_Module_Apply_SpikeInterface_Quality_Metrics.m
%________________________________________________________________________________________

%% Function to clean loaded spike sorting results from SpikeInterface using quality metrics and user input about thresholds

% Input:
% 1. Data: main window data structure
% 2. QualityMetrics: struc with one field per metric saving the user
% inputted threshold

% Output: 
% 1. Data: main window data structure with cleaned Data.Spikes

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Convert_Indicies_to_Data_Channel.m
%________________________________________________________________________________________

%% Function to convert spike positions for a probe design with 2 rows. This is becuase spike depths of the neighbouring channel are the same.
%% However, to display all channel in the GUI from top to bottom, spike depths have to be adjusted

% This basically just takes spikes from the second to the last channel and
% adds Channelspacing to them.
%For Channelspacing = 20um:
% Ch 0 +0um
% Ch 1 + 20um
% Ch 2 + 20um
% Ch 3 + 40um
% Ch 4 + 40um and so on....
% 
% Input:
% 1. Data = structure containing all data. 

% Output:
% 1. Data structure of toolbox with added field:
% Data.Spikes.DataCorrectedSpikePositions with adjusted spikepositions and
% Data.Spikes.SpikeChannel to save the corresponding spike channel indices
% used for adjustments

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Determine_Sorters_Available.m
%________________________________________________________________________________________

%% Function to determine (automatically) which sorter outputs are available folder specified in SorterFolders

% Note: order of folder locations in SorterFolders is relevant!
% 
% Input:
% 1. Data = structure containing all data. 
% 2. SorterFolders: string array with each indicie containing a path to
% search spike sorting data in. First indicie is path to external Kilosort 4 GUI, second indicie is Kilosort3, third is Mpuntainsort 5, then
% SpykingCircus 2 and Kilpsort 4 from SpikeInterface as last -- when
% autosearch: path = recording_path/Kilosort or recording_path/SpikeInterface with their respective sunfolders
% 3. ManualSelection: NOT USED ANYMORE! double, either 1 or 0 to indicate whether input paths
% come from autodetection (recording path/Kilosort) or where manually
% selcted (auto adds subfolder extensions like /Kilosort/kilosort4)
% 4. ChangedSelectedSorter: NOT USED ANYMORE! double, either 1,2,3,4 or 5. Each number stands
% for a sorter thas was selected. This is used to search for just a single
% sorter (when the user selects a different folder in the GUI) to indicate
% which is searche for; 1 = external KS3 and 4; 2 = MS5; 3 = SC2; 4 = KS4
% SpikeInterface; 5=Waveclus

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Get_Kilosort_Amplitude.m
%________________________________________________________________________________________
%% Function to get the amplitude of ech spike detected by kilosort at the spike channel and time point detected by the sorter
% this is because kilosort works with ints that have to be converted back
% to mV which is not given (only if saved data for kilosort with this gui)

% Input Arguments:
% 1. Data: Main window data struc

% Output Arguments:
% 1. Data: Main window data struc with modified Data.Spikes.SpikeAmps 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Get_Spike_Channel.m
%________________________________________________________________________________________
%% Function to determine the data channel within the channel x times matrix each spike position in um corresponds to 
% One of two ways to determine spike positions for use with the actual data
% matrix and plotting spikedepth in the main window / analysis windows
% For each spike x and y position it is checked to which channel
% coordinates this is closest to. This becomes the data channel for that
% spike. Are more detailed representation of raw sorter output

% other method: max template channel, see Spike_Module_Get_Spike_Channel_Max_Template

% Input Arguments:
% 1. Data: Main window data struc

% Output Arguments:
% 1. Data: Main window data struc with modified Data.Spikes.SpikeChannel 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Get_Spike_Channel_Max_Template.m
%________________________________________________________________________________________
%% Function to determine the data channel within the channel x times matrix each spike position in um corresponds to 
% One of two ways to determine spike positions for use with the actual data
% matrix and plotting spikedepth in the main window / analysis windows
% For each spike in a cluster, the max template channel becomes the data
% matrix channel for each spike

% other method: channel coordinate closest to spike x and y position, see Spike_Module_Get_Spike_Channel

% Input Arguments:
% 1. Data: Main window data struc
% 2. Sorter: char, sorter used, since Kilosort max templates are zero
% indexed (not from spikeinterface since its manually created in the sorting script)

% Output Arguments:
% 1. Data: Main window data struc with modified Data.Spikes.SpikeChannel 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%______________________________________________________________________________________

Clus = unique(Data.Spikes.SpikeCluster);

Data.Spikes.SpikeChannel = zeros(size(Data.Spikes.SpikeTimes));

for i = 1:length(Clus)
    AllSpikesCluster = Data.Spikes.SpikeCluster == Clus(i);
    
    if ~isempty(AllSpikesCluster)
        if strcmp(Sorter,"Kilosort")
            Data.Spikes.SpikeChannel(AllSpikesCluster) = Data.Info.ProbeInfo.ActiveChannel(double(Data.Spikes.Cluster_Max_Template_Channel(i))); % noz zero indexed
        else
            Data.Spikes.SpikeChannel(AllSpikesCluster) = Data.Info.ProbeInfo.ActiveChannel(double(Data.Spikes.Cluster_Max_Template_Channel(i)) + 1); % zero indexed
        end
    else
        warning(strcat("Clus ",num2str(NumClus(i))," contains no spikes."));
    end
end


 ###################################################### 

File: Spike_Module_Load_Kilosort_Data.m
%________________________________________________________________________________________

%% Function to load .npy and .mat files Kilosort ouputs after finishing the analysis

% This functions includes and uses function from the Spike repository on
% Github from Cortex Lab available at https://github.com/cortex-lab/spikes

% Note: NPY files are read using the respective readNPY function from the Open Ephys Analysis Tools from Github. 
% Functions from the spike-master github page from Cortex Lab where used:
% ksDriftmap (modified for the purpose of this GUI)

% Input:
% 1. Data = structure containing all data. After loading, field Data.Spikes is added with
% several subfields. Those include most importantly a vector for SpikeTimes, SpikePositions,
% SpikeAmplitudes and SpikeCluster. Therefore, to plot/access specific spikes, logical
% indexing can be used.
% 2. Autorun: Variable specifiying whether function is called from the
% autorun function or from the GUI; "SingleFolder" or "MultipleFolder" when
% called from autorun, something else as a string whe not
% 3. SelectedFolder: Folder from whioch data was extracted/loaded, as char
% 4. ScalingFactor: single value as double specfying the scalingfactor used
% to transform raw data to int. This is used to compute real amplitude values of
% spikes from kilosort
% 5. KSVersion: string, either "Kilosort 4 external GUI" or "Kilosort 3
% external GUI" to set which version should be loaded
% 6. DeleteMUA: logical one or zero whether to delete kept_spikes == 0
% 7. SpikeChannelType: char, either 'Channel closest to X and Y of
% respective spikes' OR 'Single channel for all spikes in one unit (max template channel)'

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Load_Phy_Conda_Python_exe.m
%________________________________________________________________________________________
%% Function to check whether python.exe is present and prompt to select a folder containing it if not

%% Creates a variable in GUI_Path/Modules/MISC/Variables (do not edit) that saves the path to the python exe if it was succesfully selected

% Inputs:
% 1. executablefolder: char, GUI path

% Outputs
% 1. Python_Conda_Environment_Path: char, path to the selected python conda
% exe

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Load_SpikeInterface_Sorter.m
%________________________________________________________________________________________

%% Function to load .npy and .mat files SpikeInterface ouputs for Mountainsort 5, Spykingcircus 2 and Kilosort 4

% Note: NPY files are read using the respective readNPY function from the Open Ephys Analysis Tools from Github. 

% Input:
% 1. Data = structure containing all data. After loading, field Data.Spikes is added with
% several subfields. Those include most importantly a vector for SpikeTimes, SpikePositions,
% SpikeAmplitudes and SpikeCluster. Therefore, to plot/access specific spikes, logical
% indexing can be used.
% 2. SelectedFolder: char, folder location containing spike results
% 4. CurrentSorter: char, name of the sorter to load, used for
% Data.Info.Sorter, either 'Mountainsort5' or 'Spykingcircus2' or 'SpikeInterface Kilosort'
% 5. SelectedCurationMethods: quality metrics and thresholds selected by
% user
% 6. SpikeChannelType: char, either 'Channel closest to X and Y of
% respective spikes' OR 'Single channel for all spikes in one unit (max template channel)'

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Open_SpikeInterfaceGUI.m
%________________________________________________________________________________________

%% Not used anymore, was experimental, maybe updated and implemented

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

File: Spike_Module_Start_Phy.m
%________________________________________________________________________________________

%% This function starts the python script LoadWithNeo.py to extract a recording with Neuralensemble NEO

% Input:
% 1. Data: main window data structure with all relevant data components
% 2. executableFolder: char, path in which NeuroMod was opened, from main
% window
% 3. resultsFolder: char with path to the sorting results to cd into and
% start phy

% Output: 
% 1. Success: double, 1 or 0 whether script succesfully finished

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


 ###################################################### 

