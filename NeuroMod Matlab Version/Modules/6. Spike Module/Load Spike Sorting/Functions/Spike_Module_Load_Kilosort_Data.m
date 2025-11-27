function [Data,SaveFilter] = Spike_Module_Load_Kilosort_Data(Data,Autorun,SelectedFolder,ScalingFactor,KSVersion)

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

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

if nargin<5
    KSVersion = "Kilosort 4 external GUI";
end

%% Check for existing spike data
SaveFilter = "No";

if isfield(Data,'Spikes')
    msgbox("Warning: Spike data already part of the dataset. Exisitng data will be removed.");
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Spikes");
end     

% initiate field
Data.Spikes = [];

%% Get folder containing kilosort data. If executet from autorun: Differentiate between multi and single recording analysis
if Autorun == "SingleFolder"
    % If just a single recording is analysed, user is asked for save
    % location of kilosort data
    msgbox("Please selecet a folder containing Kilosort Data");

    % Prompt user to select a folder
    folderPath = uigetdir('Select a folder');
    
    % Check if user cancels the dialog
    if folderPath == 0
        disp('Operation canceled by user');
        return;
    end
else
    % If just multiple recordings are analysed or GUI is used, Kilosort data is extracted
    % automatically from standard folder structure created (Kilosort folder in recording folder)
    folderPath = SelectedFolder;
end

%% Check if data wa high pass filtered - if not do it here, otherwise waveforms will look weird. (recommended is also top take the grand average)


%% First detect KS version -- only 3 has rez.mat file and params.py
[stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);
KSversion = [];

if strcmp(KSVersion,"Kilosort 4 external GUI")
    KSversion = 4;
else
    KSversion = 3;

    foundrez = find(stringArray == "rez.mat");
    foundparams = find(stringArray == "params.py");
    if isempty(foundrez) || isempty(foundparams)
        msgbox("Could not find rez.mat output file from kilosort. Returning");
        return;
    end
end

if isempty(KSversion)
    msgbox("Error: Could not determine Kilosort Version.")
    return;
end

[stringArray] = Utility_Extract_Contents_of_Folder(folderPath);

if sum(contains(stringArray,".npy")) == 0
    msgbox("Error: Kilosort output directory doesnt contain expected .npy files.")
    return;
end
%% Use the spike-master toolbox to extract most important spike anaysis parameter from kilosort .npy files

%
%% Apply ScalingFactor if available (Kilosort works with int format and saves results as such 
%% Scalingfactor is saved automatically by the GUI when the user saves data for kilosort.)
% if ~isempty(ScalingFactor)
%     Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps./ScalingFactor;
% end

%% Take folder from above, get folder contents, loop through them and load the npy file
% Get a list of all files in the folder
fileList = dir(folderPath);

% Extract filenames (excluding directories '.' and '..')
fileNames = {fileList(~[fileList.isdir]).name};

if isstring(folderPath)
    % Convert the string to a character array
    Data.Spikes.DataPath = char(folderPath);
else
    Data.Spikes.DataPath = folderPath;
end

%% Loop thtough filenames. If name matches with the below condition, file content is loaded
for i = 1:length(fileNames)
    if strcmp(fileNames{i},'spike_clusters.npy')
        Data.Spikes.SpikeCluster = readNPY(fullfile(folderPath,fileNames{i}));
        Data.Spikes.SpikeCluster = double(Data.Spikes.SpikeCluster);
    elseif strcmp(fileNames{i},'spike_templates.npy')
        Data.Spikes.SpikeTemplates = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'channel_map.npy')
        Data.Spikes.ChannelMap = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'channel_positions.npy')
        Data.Spikes.OrigChannelPosition = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'spike_positions.npy')
        if KSversion == 4
            Data.Spikes.SpikePositions = readNPY(fullfile(folderPath,fileNames{i}));
        else
            [~, ~ , Data.Spikes.SpikePositions, ~ ,~, ~] = ksDriftmap(folderPath,KSversion);
        end
        Data.Spikes.SpikePositions = double(Data.Spikes.SpikePositions);
        SpikePositions = Data.Spikes.SpikePositions(:,2);
    elseif strcmp(fileNames{i},'spike_times.npy')
        Data.Spikes.SpikeTimes = readNPY(fullfile(folderPath,fileNames{i}));
        Data.Spikes.SpikeTimes = double(Data.Spikes.SpikeTimes);
    elseif strcmp(fileNames{i},'templates_ind.npy')
        Data.Spikes.templates_ind = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'amplitudes.npy')
         Data.Spikes.SpikeAmps = readNPY(fullfile(folderPath,fileNames{i}));
         Data.Spikes.SpikeAmps = double(Data.Spikes.SpikeAmps);
         %[~, Data.Spikes.SpikeAmps , ~, ~ ,~, ~] = ksDriftmap(folderPath,KSversion);
         if ~isempty(ScalingFactor)
            Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps./ScalingFactor;
         end
    elseif strcmp(fileNames{i},'templates.npy')
        Data.Spikes.templates = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'spike_detection_templates.npy')
        Data.Spikes.spike_detection_templates = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'pc_features.npy')
        Data.Spikes.pc_features = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'pc_feature_ind.npy')
        Data.Spikes.pc_feature_ind = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i},'kept_spikes.npy')
        Data.Spikes.kept_spikes = readNPY(fullfile(folderPath,fileNames{i}));
    end
end

%% Get Channel number corresponding to depth in um
if str2double(Data.Info.ProbeInfo.NrRows) == 1
    SpikePositions = SpikePositions./Data.Info.ChannelSpacing;
    Data.Spikes.SpikeChannel = round(SpikePositions)+1;
    
    % now some channel can be wrongly assigned when right at the border between
    % two channel --> spike channel can be NOT part of active channel (if there
    % is a gap in active channel) but is shifted by one
    NonExistent = ismember(Data.Spikes.SpikeChannel, Data.Info.ProbeInfo.ActiveChannel);
    % Get the spikes that are NOT in ActiveChannel
    ZeroIndex = find(NonExistent==0);
    
    for i = 1:length(ZeroIndex)
        CurrentChannel = Data.Spikes.SpikeChannel(ZeroIndex(i));
        
        % take nearest channel. If two nearest, take the smaller one (bc round() was used)
        [minDist, minIdx] = min(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel));
        
        % Handle ties: if multiple channels have same distance, pick the lower one
        nearestChannels = Data.Info.ProbeInfo.ActiveChannel(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel) == minDist);
        Data.Spikes.SpikeChannel(ZeroIndex(i)) = min(nearestChannels);  % pick lower one
    end
else %% Two channel rows
    %% Depth can be the same. Therefore we need the x position as well
    SpikePositionsX = Data.Spikes.SpikePositions(:,1);
    for i = 1:length(SpikePositions)
        % find closes y values (multiple)
        distances = abs(Data.Info.ProbeInfo.ycoords - SpikePositions(i));
        minDist = min(distances);
        % indice of all channel matching depth -- two if same channel
        % depths for both rows
        Yidx = find(distances == minDist);
        
        % find closest x value (only one)
        [~, Xidx] = min(abs(Data.Info.ProbeInfo.xcoords(Yidx) - SpikePositionsX(i))); 
        
        Data.Spikes.SpikeChannel(i) = Yidx(Xidx);

    end

    % now some channel can be wrongly assigned when right at the border between
    % two channel --> spike channel can be NOT part of active channel (if there
    % is a gap in active channel) but is shifted by one
    NonExistent = ismember(Data.Spikes.SpikeChannel, Data.Info.ProbeInfo.ActiveChannel);
    % Get the spikes that are NOT in ActiveChannel
    ZeroIndex = find(NonExistent==0);
    
    for i = 1:length(ZeroIndex)
        CurrentChannel = Data.Spikes.SpikeChannel(ZeroIndex(i));
        
        % take nearest channel. If two nearest, take the smaller one (bc round() was used)
        [minDist, minIdx] = min(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel));
        
        % Handle ties: if multiple channels have same distance, pick the lower one
        nearestChannels = Data.Info.ProbeInfo.ActiveChannel(abs(Data.Info.ProbeInfo.ActiveChannel - CurrentChannel) == minDist);
        Data.Spikes.SpikeChannel(ZeroIndex(i)) = min(nearestChannels);  % pick lower one
    end 

end

if size(Data.Spikes.SpikeChannel,1)<size(Data.Spikes.SpikeChannel,2)
    Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel';
end

if KSversion == 3
    if size(SpikePositions,2)==1
        %load(stringArray(foundrez),'rez');
        Data.Spikes.SpikePositions = zeros(length(Data.Spikes.SpikeTimes),2);
        Data.Spikes.SpikePositions(:,2) = SpikePositions;
    else
        Data.Spikes.SpikePositions = SpikePositions;
    end
end


%% ChannelPosition have to be full (not only active channel)
xcoords = Data.Info.ProbeInfo.xcoords;
ycoords = Data.Info.ProbeInfo.ycoords;

Data.Spikes.ChannelPosition = zeros(length(xcoords),2);
Data.Spikes.ChannelPosition(:,1) = xcoords';
Data.Spikes.ChannelPosition(:,2) = ycoords';

% Normalize to 0 um as first channel (if kilosort channelmap starts with 20um)
% if Data.Spikes.ChannelPosition(1,2) ~= 0
%     disp("Warning: Kilosort Channelmap does not start with 0um. SpikePositions are substracted by the channelspacing to rescale to 0um! If thats not a wanted behavior, change this in Spike_Module_Load_Kilosort_Data.m by commenting the lines after this message prompt.")
%     Data.Spikes.SpikePositions(:,2) = Data.Spikes.SpikePositions(:,2) - Data.Info.ChannelSpacing;
%     Data.Spikes.ChannelPosition(:,2) = Data.Spikes.ChannelPosition(:,2) - Data.Info.ChannelSpacing;
% end

UinquePos = unique(Data.Spikes.OrigChannelPosition(:,2));
PosDiff = UinquePos(2)-UinquePos(1);

if PosDiff ~= Data.Info.ChannelSpacing
    msgbox("Warning: Channelspacing of probe design used for Kilosort different to channelspacing of this recording! Channel positions of spikes will be shifted!.")
    warning("Channelspacing of probe design used for Kilosort different to channelspacing of this recording! Channel positions of spikes will be shifted!.");
end

if KSversion == 4
    if size(Data.Spikes.ChannelMap,1) > size(Data.Raw,1) || size(Data.Spikes.ChannelMap,1) < size(Data.Raw,1)
        msgbox("Warning: Loaded Kilosort data seems to have a different channelconfiguration than GUI data has. Check whether correct kilosort data was selected.");
        disp("Warning: Loaded Kilosort data seems to have a different channelconfiguration than GUI data has. Check whether correct kilosort data was selected.");
    end
elseif KSversion == 3
    if size(Data.Spikes.ChannelMap,2) > size(Data.Raw,1) || size(Data.Spikes.ChannelMap,2) < size(Data.Raw,1)
        msgbox("Warning: Loaded Kilosort data seems to have a different channelconfiguration than GUI data has. Check whether correct kilosort data was selected.");
        disp("Warning: Loaded Kilosort data seems to have a different channelconfiguration than GUI data has. Check whether correct kilosort data was selected.");
    end
end

%% If no KilosortData found: Spike Field is emptyx but has to be deleted
if isempty(Data.Spikes)
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Spikes");
    msgbox("No sorting data could be loaded.");
    return;
end

if max(Data.Spikes.SpikeTimes,[],'all') > length(Data.Time)
    SpikeAboveTime = Data.Spikes.SpikeTimes>length(Data.Time);

    Data.Spikes.SpikeTimes(SpikeAboveTime==1) = [];
    Data.Spikes.SpikePositions(SpikeAboveTime==1,:) = [];
    Data.Spikes.SpikeAmps(SpikeAboveTime==1) = [];
    Data.Spikes.SpikeChannel(SpikeAboveTime==1) = [];
    Data.Spikes.SpikeCluster(SpikeAboveTime==1) = [];
    Data.Spikes.SpikeTemplates(SpikeAboveTime==1) = [];

    msgbox("Warning: spike time(s) bigger than maximum time found an deleted. Please check whether you loaded the correct kilosort outpout." )
end

SpikeTimesSmaller0 = Data.Spikes.SpikeTimes<= 0;

if sum(SpikeTimesSmaller0)>0
    Data.Spikes.SpikeTimes(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikePositions(SpikeTimesSmaller0==1,:) = [];
    Data.Spikes.SpikeAmps(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikeChannel(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikeCluster(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikeTemplates(SpikeTimesSmaller0==1) = [];

    msgbox("Warning: spike time(s) smaller or equal to 0 found and deleted. This is a known behavior fixed in newer Kilosort 4 versions." )
end

if length(Data.Spikes.ChannelMap)~=length(Data.Info.ProbeInfo.ActiveChannel)
    msgbox("Error: Loaded spike data contains more channel than current probe design does. This can be due to channel deletion conducted after sorting or loading the wrong sorting data.")
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Spikes");
    return;
end

%% Specify SpikeType
Data.Info.SpikeType = 'Kilosort';
Data.Info.Sorter = 'External Kilosort GUI';
Data.Info.SorterPath = SelectedFolder;

%% Data needs to be high pass filtered! Otherwise waveforms are weird. Recommended is also grand average
% Detect high pass filter
HigPassFiltered = 1;

if isfield(Data,'Preprocessed') 
    if isfield(Data.Info,'FilterMethod') 
        if ~strcmp(Data.Info.FilterMethod,'High-Pass')
            %msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
            HigPassFiltered = 0;
        end
    else
        %msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
        HigPassFiltered = 0;
    end
else
    %msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
    HigPassFiltered = 0;
end

%%% if it has to be high pass filtered --> save as TempData, extract
%%% waveforms and delete temp variable
if HigPassFiltered == 0
    HighPassFilterSettings = [];
    Spike_Extraction_HighPassWindow = Spike_Extraction_AskforHighPass(HighPassFilterSettings);
    
    uiwait(Spike_Extraction_HighPassWindow.PreproSTAWindowUIFigure);
    
    if isvalid(Spike_Extraction_HighPassWindow)
        Cutoff = Spike_Extraction_HighPassWindow.HighPassFilterSettings.Cutoff;
        FilterOrder = Spike_Extraction_HighPassWindow.HighPassFilterSettings.FilterOrder;
        SaveFilter = Spike_Extraction_HighPassWindow.HighPassFilterSettings.SaveFilter;
        delete(Spike_Extraction_HighPassWindow);
    else
        disp("High pass filter settings window closed before manual config was saved. Using standard high pass filter settings (300Hz cutoff, filterorder 6)")
        Cutoff = "300";
        FilterOrder = "6";
        SaveFilter = "No";
    end

    PreproInfo = [];
    PreprocessingSteps = [];

    Methods = ["Filter"];
    [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods,PreproInfo,PreprocessingSteps,0,"High-Pass","Butterworth IR",Cutoff,"Zero-phase forward and reverse",FilterOrder,[],Data.Info.NativeSamplingRate);
        
    if isfield(PreproInfo,'ChannelDeletion')
        ChannelDeletion = PreproInfo.ChannelDeletion;
    else
        ChannelDeletion = [];
    end
    
    TextArea = [];
    
    if strcmp(SaveFilter,"No")
        [TempData,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
        [TempData] = Preprocess_Module_Apply_Pipeline (TempData,TempData.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea);
        % Get Waveform Amplitudes
        Data = Spike_Module_Get_Kilosort_Amplitude(Data);
        %% Now extract Waveforms
        [Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(TempData,TempData.Spikes.SpikeTimes,Data.Spikes.SpikeChannel,"NormalWaveforms");
        
        TempData = [];
        
    else
        [Data,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
        [Data] = Preprocess_Module_Apply_Pipeline (Data,Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea);
        % Get Waveform Amplitudes
        Data = Spike_Module_Get_Kilosort_Amplitude(Data);
        %% Now extract Waveforms
        [Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,Data.Spikes.SpikeChannel,"NormalWaveforms");
    end
    
else % If high pass was already applied
    % Get Waveform Amplitudes
    Data = Spike_Module_Get_Kilosort_Amplitude(Data);
    [Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,Data.Spikes.SpikeChannel,"NormalWaveforms");
    
end

% Remove NaN from Waveforms
% Some SPikes can be removed when they are too close to the edge of the
% recording to have a complete waveform
if sum(SpikesWithWaveform)>0
    NumSpikeRemoved = length(find(SpikesWithWaveform==0));
    if NumSpikeRemoved>0
        msgbox(strcat("Warning: ",num2str(NumSpikeRemoved)," Spikes removed bc they are too close to the time limits"))
    end
    Data.Spikes.SpikeTimes = Data.Spikes.SpikeTimes(SpikesWithWaveform==1);
    Data.Spikes.SpikePositions(SpikesWithWaveform==0,:) = [];
    Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps(SpikesWithWaveform==1);
    Data.Spikes.Waveforms = Data.Spikes.Waveforms(SpikesWithWaveform==1,:);
    Data.Spikes.SpikeChannel = Data.Spikes.SpikeChannel(SpikesWithWaveform==1); 
    Data.Spikes.SpikeCluster = Data.Spikes.SpikeCluster(SpikesWithWaveform==1);
    Data.Spikes.SpikeTemplates = Data.Spikes.SpikeTemplates(SpikesWithWaveform==1);
end

% Now if we have two rows we have to adjust the actual channel to a data
% channel which goes from 1 to 64. This ensures porper scaling in the main
% window plot, but is not valid for any computations down the line!

UinquePos = unique(Data.Spikes.ChannelPosition(:,1));

if numel(UinquePos)>=2
    [Data] = Spike_Module_Convert_Indicies_to_Data_Channel(Data);
end

if KSversion == 3
    msgbox("Kilosort 3 data successfully loaded.");
elseif KSversion == 4
    msgbox("Kilosort 4 data successfully loaded.");
end
