function [Data] = Spike_Module_Load_Kilosort_Data(Data,Autorun,SelectedFolder,ScalingFactor)

%________________________________________________________________________________________

%% Function to load .npy and .mat files Kilosort ouputs after finishing the analysis
% This functions includes and uses function from the npy-matlab github
% repository available at https://github.com/kwikteam/npy-matlab
% This functions includes and uses function from the Spike repository on
% Github from Nick Steinmetz available at https://github.com/cortex-lab/spikes

% Note: Matlab NPY Toolbox and spike-master github project have to be in path (saved within folder Toolboxes of GUI files)
% Functions used from the Spike repository: 
% ksDriftmap (modified for the purpose of this GUI)
% Functions used from the npy-matlab repository: 
% readNPY (original)

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

% Output:
% 1. Data structure of toolbox with added field: Data.Spikes, called
% using app.Data.Spikes in GUI

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Check for existing spike data

if isfield(Data,'Spikes')
    msgbox("Warning: Spike data already part of the dataset. Exisitng data will be removed.");
    Data.Spikes = [];
    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
    end
    if isfield(Data.Info,'SpikeSorting')
        fieldsToDelete = {'SpikeSorting'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'SpikeDetectionNrStd')
        fieldsToDelete = {'SpikeDetectionNrStd'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end

    if isfield(Data.Info,'SpikeDetectionThreshold')
        fieldsToDelete = {'SpikeDetectionThreshold'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
    Data.Info.SpikeType = "Non";
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
%if ~isfield(Data.)



%% First detect KS version -- only 3 has rez.mat file and params.py
[stringArray] = Utility_Extract_Contents_of_Folder(SelectedFolder);
KSversion = [];

foundrez = find(stringArray == "rez.mat");
foundparams = find(stringArray == "params.py");

if isempty(foundrez) || isempty(foundparams)
    KSversion = 4;
else
    KSversion = 3;
end

if isempty(KSversion)
    msgbox("Error: Could not determine Kilosort Version.")
    return;
end

%% Use the spike-master toolbox to extract most important spike anaysis parameter from kilosort .npy files
[Data.Spikes.SpikeTimes, Data.Spikes.SpikeAmps, SpikePositions, ~,Data.Spikes.BiggestAmplWaveform] = ksDriftmap(folderPath,KSversion);

if KSversion == 3
    %load(stringArray(foundrez),'rez');
    Data.Spikes.SpikePositions = zeros(length(Data.Spikes.SpikeTimes),2);
    Data.Spikes.SpikePositions(:,2) = SpikePositions;
end

%% Apply ScalingFactor if available (Kilosort works with int format and saves results as such 
%% Scalingfactor is saved automatically by the GUI when the user saves data for kilosort.)
if ~isempty(ScalingFactor)
    Data.Spikes.SpikeAmps = Data.Spikes.SpikeAmps./ScalingFactor;
end

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
    if strcmp(fileNames{i}(1:end-4),'spike_clusters')
        Data.Spikes.SpikeCluster = readNPY(fullfile(folderPath,fileNames{i}));
        Data.Spikes.SpikeCluster = double(Data.Spikes.SpikeCluster);
    %elseif strcmp(fileNames{i}(1:end-4),'spike_times')
    elseif strcmp(fileNames{i}(1:end-4),'spike_templates')
        Data.Spikes.SpikeTemplates = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'channel_map')
        Data.Spikes.ChannelMap = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'channel_positions')
        Data.Spikes.ChannelPosition = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'spike_positions')
        if KSversion == 4
            Data.Spikes.SpikePositions = readNPY(fullfile(folderPath,fileNames{i}));
        end
    elseif strcmp(fileNames{i}(1:end-4),'templates_ind')
        Data.Spikes.templates_ind = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'templates')
        Data.Spikes.templates = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'spike_detection_templates')
        Data.Spikes.spike_detection_templates = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'pc_features')
        Data.Spikes.pc_features = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'pc_feature_ind')
        Data.Spikes.pc_feature_ind = readNPY(fullfile(folderPath,fileNames{i}));
    elseif strcmp(fileNames{i}(1:end-4),'kept_spikes')
        Data.Spikes.kept_spikes = readNPY(fullfile(folderPath,fileNames{i}));
    end
end

% Normalize to 0 um as first channel (if kilosort channelmap starts with 20um)
if Data.Spikes.ChannelMap(1) == Data.Info.ChannelSpacing
    msgbox("Warning: Kilosort Channelmap does not start with 0um. SpikePositions are therefore substracted by the channelspacing to rescale to 0um.")
    Data.Spikes.SpikePositions(:,2) = Data.Spikes.SpikePositions(:,2) - Data.Info.ChannelSpacing;
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
    fieldsToDelete = {'Spikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
    Data.Info.SpikeType = 'Non';
    msgbox("No Kilosort 4 data found in selected path.");
    fieldsToDelete = {'EventRelatedSpikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
    if isfield(Data,'EventRelatedSpikes')
        fieldsToDelete = {'EventRelatedSpikes'};
        % Delete fieldsven
        Data = rmfield(Data, fieldsToDelete);
    end
    return;
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
    %Data.Spikes.SpikeChannel(SpikeAboveTime==1) = [];
    Data.Spikes.SpikeCluster(SpikeAboveTime==1) = [];
    Data.Spikes.SpikeTemplates(SpikeAboveTime==1) = [];

    msgbox("Warning: spike time(s) bigger than maximum time found an deleted. Please check whether you loaded the correct kilosort outpout or try Kilsoort with another format (int16)." )
end

SpikeTimesSmaller0 = Data.Spikes.SpikeTimes<= 0;

if sum(SpikeTimesSmaller0)>0
    Data.Spikes.SpikeTimes(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikePositions(SpikeTimesSmaller0==1,:) = [];
    Data.Spikes.SpikeAmps(SpikeTimesSmaller0==1) = [];
    %Data.Spikes.SpikeChannel(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikeCluster(SpikeTimesSmaller0==1) = [];
    Data.Spikes.SpikeTemplates(SpikeTimesSmaller0==1) = [];

    msgbox("Warning: spike time(s) smaller or equal to 0 found and deleted. This is a known behavior fixed in newer Kilosort 4 versions." )
end

%% Specify SpikeType
Data.Info.SpikeType = 'Kilosort';

%% Extract Waveforms
% For Kilosort we dont have channel information to extract from raw or
% preprocessed data --> Therefor we take channel closest to position

SpikePositions = Data.Spikes.SpikePositions(:,2)+Data.Info.ChannelSpacing;
SpikePositions = SpikePositions./Data.Info.ChannelSpacing;
SpikePositions = round(SpikePositions);

Data.Spikes.SpikeChannel = SpikePositions;
%SpikePositions = double(Data.Spikes.SpikeChannel);

%% Data needs to be high pass filtered! Otherwise waveforms are weird. Recommended is also grand average
% Detect high pass filter
HigPassFiltered = 1;

if isfield(Data,'Preprocessed') 
    if isfield(Data.Info,'FilterMethod') 
        if ~strcmp(Data.Info.FilterMethod,'High-Pass')
            msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
            HigPassFiltered = 0;
        end
    else
        msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
        HigPassFiltered = 0;
    end
else
    msgbox("Warning: No High Pass filtered data found. This will screw with scale and amplitude of waveforms. Data is temporarily high pass filtered for waveform extraction!");
    HigPassFiltered = 0;
end

%%% if it has to be high pass filtered --> save as TempData, extract
%%% waveforms and delete temp variable
if HigPassFiltered == 0
    PreproInfo = [];
    PreprocessingSteps = [];

    Methods = ["Filter"];
    [PreproInfo,PreprocessingSteps,~] = Preprocess_Module_Construct_Pipeline(Methods,PreproInfo,PreprocessingSteps,0,"High-Pass","Butterworth IR","300","Zero-phase forward and reverse","3",[],Data.Info.NativeSamplingRate);
        
    if isfield(PreproInfo,'ChannelDeletion')
        ChannelDeletion = PreproInfo.ChannelDeletion;
    else
        ChannelDeletion = [];
    end
    
    TextArea = [];
    
    [TempData,PreproInfo,TextArea] = Preprocess_Module_Delete_Old_Settings(Data,PreproInfo,PreprocessingSteps,ChannelDeletion,TextArea);
    
    [TempData] = Preprocess_Module_Apply_Pipeline (TempData,TempData.Info.NativeSamplingRate,PreprocessingSteps,0,PreproInfo,ChannelDeletion,TextArea);
    
    %% Now extract Waveforms
    [Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(TempData,TempData.Spikes.SpikeTimes,SpikePositions,"NormalWaveforms");
    
    clear TempData;

else % If high pass was already applied

    [Data.Spikes.Waveforms,SpikesWithWaveform] = Spikes_Module_Get_Waveforms(Data,Data.Spikes.SpikeTimes,SpikePositions,"NormalWaveforms");
    
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

if KSversion == 3
    msgbox("Kilosort 3 data successfully loaded.");
elseif KSversion == 4
    msgbox("Kilosort 4 data successfully loaded.");
end
