function [Data,SaveFilter] = Spike_Module_Load_SpikeInterface_Sorter(Data,SelectedFolder,CurrentSorter)

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

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________


%% First detect KS version -- only 3 has rez.mat file and params.py
[stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);

SorterData = find(stringArray == "params.py");

if isempty(SorterData)
    msgbox("No SpikeInterface sorting output found. Please export your Sorting Analyzer object for phy first and select the correct output folder")
    return;
end

%% Check for existing spike data
SaveFilter = "No";

if isfield(Data,'Spikes')
    msgbox("Warning: Spike data already part of the dataset. Exisitng data will be removed.");
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Spikes");
end      

% initiate field
Data.Spikes = [];

%% Take folder from above, get folder contents, loop through them and load the npy file
% Get a list of all files in the folder
fileList = dir(SelectedFolder);

% Extract filenames (excluding directories '.' and '..')
fileNames = {fileList(~[fileList.isdir]).name};

if isstring(SelectedFolder)
    % Convert the string to a character array
    Data.Spikes.DataPath = char(SelectedFolder);
else
    Data.Spikes.DataPath = SelectedFolder;
end

%% Loop thtough filenames. If name matches with the below condition, file content is loaded
for i = 1:length(fileNames)
    if strcmp(fileNames{i}(1:end-4),'spike_clusters')
        Data.Spikes.SpikeCluster = readNPY(fullfile(SelectedFolder,fileNames{i}));
        Data.Spikes.SpikeCluster = double(Data.Spikes.SpikeCluster);
    elseif strcmp(fileNames{i}(1:end-4),'amplitudes')
        Data.Spikes.SpikeAmps = readNPY(fullfile(SelectedFolder,fileNames{i}));
        Data.Spikes.SpikeAmps = double(Data.Spikes.SpikeAmps);
    elseif strcmp(fileNames{i}(1:end-4),'cluster_isi_violations_ratio')
        Tempcluster_isi_violations_ratio = readtable(fullfile(SelectedFolder,fileNames{i}), "FileType","text",'Delimiter', '\t');
        Data.Spikes.cluster_isi_violations_ratio = table2array(Tempcluster_isi_violations_ratio);
    elseif strcmp(fileNames{i}(1:end-4),'cluster_isi_violations_count')
        TempIsiviolations = readtable(fullfile(SelectedFolder,fileNames{i}), "FileType","text",'Delimiter', '\t');
        Data.Spikes.cluster_isi_violations_count = table2array(TempIsiviolations);
    elseif strcmp(fileNames{i}(1:end-4),'amplitude')
        Data.Spikes.SpikeAmps = readNPY(fullfile(SelectedFolder,fileNames{i}));
        Data.Spikes.SpikeAmps = double(Data.Spikes.SpikeAmps);
    elseif strcmp(fileNames{i}(1:end-4),'channel_groups')
        Data.Spikes.SpikeTemplates = readNPY(fullfile(SelectedFolder,fileNames{i}));
        Data.Spikes.SpikeTemplates = double(Data.Spikes.SpikeTemplates);
    elseif strcmp(fileNames{i}(1:end-4),'channel_map')
        Data.Spikes.ChannelMap = readNPY(fullfile(SelectedFolder,fileNames{i}));
        Data.Spikes.ChannelMap = double(Data.Spikes.ChannelMap);
    elseif strcmp(fileNames{i}(1:end-4),'channel_positions')
        Data.Spikes.ChannelPosition = readNPY(fullfile(SelectedFolder,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'spike_times')
        Data.Spikes.SpikeTimes = readNPY(fullfile(SelectedFolder,fileNames{i}));
        Data.Spikes.SpikeTimes = double(Data.Spikes.SpikeTimes);
    elseif strcmp(fileNames{i}(1:end-4),'templates_ind')
        Data.Spikes.templates_ind = readNPY(fullfile(SelectedFolder,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'templates')
        Data.Spikes.templates = readNPY(fullfile(SelectedFolder,fileNames{i}));
        Data.Spikes.templates = double(Data.Spikes.templates);
    elseif strcmp(fileNames{i}(1:end-4),'spike_detection_templates')
        Data.Spikes.spike_detection_templates = readNPY(fullfile(SelectedFolder,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'pc_features')
        Data.Spikes.pc_features = readNPY(fullfile(SelectedFolder,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'pc_feature_ind')
        Data.Spikes.pc_feature_ind = readNPY(fullfile(SelectedFolder,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'kept_spikes')
        Data.Spikes.kept_spikes = readNPY(fullfile(SelectedFolder,fileNames{i}));
    end
end

if length(Data.Spikes.ChannelMap)~=length(Data.Info.ProbeInfo.ActiveChannel)
    msgbox("Error: Loaded spike data contains more channel than current probe design does. This can be due to channel deletion conducted after sorting or loading the wrong sorting data.")
    [Data,~] = Organize_Delete_Dataset_Components(Data,"Spikes");
    return;
end

UinquePos = unique(Data.Spikes.ChannelPosition(:,1));

for i = 1:length(fileNames)
    if strcmp(fileNames{i}(1:end-4),'SpikePositions')
        TempPositions = load(fullfile(SelectedFolder,fileNames{i}));
        % Get the list of field names
        fields = fieldnames(TempPositions.SpikePositions);
        % Assuming TempPositions is a 1 x n structure array
        n = numel(TempPositions.SpikePositions); % Number of elements in the structure
        
        % Preallocate a matrix to store the results
        % Assuming each field contains two numbers
        resultMatrix = zeros(n, 2);
        
        % Loop over the structure array
        for idx = 1:n
            % Loop over fields (assuming you are working with the first field for each structure element)
            for j = 1:numel(fields)
                fieldName = fields{j};
                
                if isscalar(UinquePos)
                    resultMatrix(idx, 1) = TempPositions.SpikePositions(idx).(fieldName);
                    resultMatrix(idx, 2) = TempPositions.SpikePositions(idx).(fieldName);
                else
                    resultMatrix(idx, j) = TempPositions.SpikePositions(idx).(fieldName);
                end
            end
        end
        Data.Spikes.SpikePositions = resultMatrix;
    end
end

if ~isfield(Data.Spikes,'SpikePositions')
    msgbox("Error: No SpikePosition.mat file found. When you use your own SpikeInterface code, please save the spike_locations output from the sorting analyzer as a .mat file! For reference, see 'GUI_Path\Proj. Ephys GUI\Modules\SpikeInterface\SpikeInterface_Sorting.py' for reference.")
    Data.Spikes = [];
else
    if isempty(Data.Spikes.SpikePositions)
        msgbox("Error: No SpikePosition.mat file found. When you use your own SpikeInterface code, please save the spike_locations output from the sorting analyzer as a .mat file! For reference, see 'GUI_Path\Proj. Ephys GUI\Modules\SpikeInterface\SpikeInterface_Sorting.py' for reference.")
        Data.Spikes = [];
    end
end

%% If no KilosortData found: Spike Field is emptyx but has to be deleted
if isempty(Data.Spikes)
    [Data,~] = Organize_Delete_Dataset_Components(Data,"EventRelatedData");
    msgbox("No sorting data could be loaded.");
    return;
end

% Normalize to 0 um as first channel (if kilosort channelmap starts with 20um)
if Data.Spikes.ChannelPosition(1,2) ~= 0
    disp("Warning: Channelmap does not start with 0um. SpikePositions are substracted by the channelspacing to rescale to 0um! If thats not a wanted behavior, change this in Spike_Module_Load_Kilosort_Data.m orCheck whether the correct output folder was selected.m by commenting the lines after this message prompt.")
    Data.Spikes.SpikePositions(:,2) = Data.Spikes.SpikePositions(:,2) - Data.Info.ChannelSpacing;
    Data.Spikes.ChannelPosition(:,2) = Data.Spikes.ChannelPosition(:,2)-Data.Info.ChannelSpacing;
end

UinquePos = unique(Data.Spikes.ChannelPosition(:,2));
PosDiff = UinquePos(2)-UinquePos(1);

if PosDiff ~= Data.Info.ChannelSpacing
    msgbox("Warning: Channelspacing of probe design used for Kilosort different to channelspacing of this recording! Channel positions of spikes will be shifted!.")
    warning("Channelspacing of probe design used for Kilosort different to channelspacing of this recording! Channel positions of spikes will be shifted!.");
end

if size(Data.Spikes.ChannelMap,1) > size(Data.Raw,1) || size(Data.Spikes.ChannelMap,1) < size(Data.Raw,1)
    msgbox("Warning: Loaded sorting data seems to have a different channelconfiguration than GUI data has. Check whether the correct output folder was selected.");
    disp("Warning: Loaded sorting data seems to have a different channelconfiguration than GUI data has. Check whether the correct output folder was selected.");
end

% extracted every time analysis ios plotted, so removing is not really
% necessary, but for good measure
if isfield(Data,'EventRelatedSpikes')
    fieldsToDelete = {'EventRelatedSpikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
end

if max(Data.Spikes.SpikeTimes,[],'all') > length(Data.Time)
    SpikeAboveTime = Data.Spikes.SpikeTimes>length(Data.Time);

    Data.Spikes.SpikeTimes(SpikeAboveTime==1) = [];
    Data.Spikes.SpikePositions(SpikeAboveTime==1,:) = [];
    Data.Spikes.SpikeAmps(SpikeAboveTime==1) = [];
    Data.Spikes.SpikeCluster(SpikeAboveTime==1) = [];
    Data.Spikes.SpikeTemplates(SpikeAboveTime==1) = [];

    msgbox("Warning: spike time(s) bigger than maximum time found an deleted. Please check whether you loaded the correct output folder." )
end

SpikeTimesSmaller0 = Data.Spikes.SpikeTimes<= 0;

if sum(SpikeTimesSmaller0)>0
    Data.Spikes.SpikeTimes(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikePositions(SpikeTimesSmaller0==1,:) = [];
    Data.Spikes.SpikeAmps(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikeCluster(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikeTemplates(SpikeTimesSmaller0==1) = [];

    msgbox("Warning: spike time(s) smaller or equal to 0 found and deleted. This is a known behavior in Kilosort and fixed in newer versions." )
end

%% Specify SpikeType
Data.Info.SpikeType = 'SpikeInterface';
Data.Info.Sorter = CurrentSorter;

%% Extract Waveforms
% For Kilosort we dont have channel information to extract from raw or
% preprocessed data --> Therefore we take channel closest to position

if sum(isnan(Data.Spikes.SpikePositions(:,2)))>0
    Data.Spikes.SpikeTimes(isnan(Data.Spikes.SpikePositions(:,2))) = [];
    Data.Spikes.SpikePositions(isnan(Data.Spikes.SpikePositions(:,2)),:) = [];
    Data.Spikes.SpikeAmps(isnan(Data.Spikes.SpikePositions(:,2))) = [];
    Data.Spikes.SpikeCluster(isnan(Data.Spikes.SpikePositions(:,2))) = [];
    Data.Spikes.SpikeTemplates(isnan(Data.Spikes.SpikePositions(:,2))) = [];
end

SpikePositions = Data.Spikes.SpikePositions(:,2);
SpikePositions = SpikePositions./Data.Info.ChannelSpacing;
SpikePositions = round(SpikePositions)+1;
Data.Spikes.SpikeChannel = SpikePositions;

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
        
        %% Now extract Waveforms
        [Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(TempData,TempData.Spikes.SpikeTimes,Data.Spikes.SpikeChannel,"NormalWaveforms");
        
        TempData = [];
        
    else
        [Data,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
        [Data] = Preprocess_Module_Apply_Pipeline (Data,Data.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea);
        
        %% Now extract Waveforms
        [Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,Data.Spikes.SpikeChannel,"NormalWaveforms");
    end
    
else % If high pass was already applied
    
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
    %Data.Spikes.SpikeTemplates = Data.Spikes.SpikeTemplates(SpikesWithWaveform==1);
end

% Now if we have two rows we have to adjust the actual channel to a data
% channel which goes from 1 to 64. This ensures porper scaling in the main
% window plot, but is not valid for any computations down the line!

UinquePos = unique(Data.Spikes.ChannelPosition(:,1));

if numel(UinquePos)>=2
    [Data] = Spike_Module_Convert_Indicies_to_Data_Channel(Data);
end

msgbox("SpikeInterface Sorting successfully loaded.");
