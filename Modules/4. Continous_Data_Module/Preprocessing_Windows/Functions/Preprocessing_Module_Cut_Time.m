function [Data] = Preprocessing_Module_Cut_Time(Data,CutType,CutTime,PreprocessingSteps,PPSteps)

%________________________________________________________________________________________

%% Function to delete specific time spans of the recording. 
% Time span can either be from 0 to a specified amount of seconds (CutStart)
% or a specified time point till the end of the recording (CutEnd)

% Input:
% 1. Data: Data structure
% 2. CutType: Either 'CutStart' or 'CutEnd' as char to specify if first or
% last seconds of the recording are deleted
% 3. CutTime: Time in seconds as double specifying the duration of data to
% delete. (if 20 seconds and CutEnd: The last 20 seconds of the recording are deleted)
% 4: PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 5: current iteration of preprocessing steps execute, as double (index of PreprocessingSteps currently executed)

% NOTE: If Kilosort spike data extracted: Spike data gets deleted. It could
% be modified accordingly, but would then differ in time from the file
% kilosort analysed and the kilosort ouput data is based on. Therefore I
% want to force the user to save for kilosort again, analyse again and have
% a matching set of datasets in the gui and kilosort.
% Internal spikes are modified accordingly, all spike indicies in deleted
% time range get deleted too.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


if strcmp(CutType,"CutStart")

elseif strcmp(CutType,"CutEnd")
    CutTime = Data.Time(end)-CutTime;
end

%% Give Kilosort Warning 
if strcmp(Data.Info.SpikeType,'Kilosort')
    msgbox("Warning: Found kilosort data is deleted from dataset since time was cut. Please analyze cutted dataset again with kilosort and load the output again.");
end

%% This gets freshly extracted everytime its needed anyway, but for good measure its just always deleted 
if isfield(Data,'EventRelatedSpikes')
    fieldsToDelete = {'EventRelatedSpikes'};
    % Delete fields
    Data = rmfield(Data, fieldsToDelete);
end

%% Check whether data is downsampled
Downsamplingflag = 0;
    
for i = 1:PPSteps
    if strcmp(PreprocessingSteps(i),"Downsampling")
        Downsamplingflag = 1;
    end
end

%% Cut Data
% 1. Raw Data
[~, index] = min(abs(Data.Time - CutTime));

if strcmp(CutType,"CutStart")
    if isfield(Data,'Raw')
        Data.Raw = Data.Raw(:,index+1:end);
    end
elseif strcmp(CutType,"CutEnd")
    if isfield(Data,'Raw')
        Data.Raw = Data.Raw(:,1:index);
    end
end
%% Cut preprocessed data and downsampled data 
if isfield(Data,'Preprocessed')
    if isfield(Data,'TimeDownsampled') && Downsamplingflag == 0
        [~, index] = min(abs(Data.TimeDownsampled - CutTime));
        if strcmp(CutType,"CutStart")
            Data.TimeDownsampled = Data.TimeDownsampled(index+1:end)-CutTime;
        elseif strcmp(CutType,"CutEnd")
            Data.TimeDownsampled = Data.TimeDownsampled(1:index-1);
        end
    elseif Downsamplingflag == 1
        [~, index] = min(abs(Data.TimeDownsampled - CutTime));
        if strcmp(CutType,"CutStart")
            Data.TimeDownsampled = Data.TimeDownsampled(index+1:end)-CutTime;
        elseif strcmp(CutType,"CutEnd")
            Data.TimeDownsampled = Data.TimeDownsampled(1:index-1);
        end
    else
        [~, index] = min(abs(Data.Time - CutTime));  
    end 
    if strcmp(CutType,"CutStart")
        Data.Preprocessed = Data.Preprocessed(:,index+1:end);
    elseif strcmp(CutType,"CutEnd")
        Data.Preprocessed = Data.Preprocessed(:,1:index);
    end

else % Add as prepro data when empty at this point
    Data.Preprocessed = Data.Raw;
end

%% Cut Time
[~, index] = min(abs(Data.Time - CutTime));

if strcmp(CutType,"CutStart")
    Data.Time = Data.Time(:,index+1:end)-CutTime;
elseif strcmp(CutType,"CutEnd")
    Data.Time = Data.Time(1:index);
end

Data.Info.num_data_points = length(Data.Time);

%% Cut Events
if isfield(Data,'Events')
    for i = 1:length(Data.Events)
        if strcmp(CutType,"CutStart")
            EventsToDelete = Data.Events{i} <= index; 
        elseif strcmp(CutType,"CutEnd")
            EventsToDelete = Data.Events{i} >= index; 
        end
        if sum(EventsToDelete) == 0
            continue;
        end

        Data.Events{i}(EventsToDelete==1) = [];
        
        %% If current ev ent Channel is the one for which event data was extracted
        if isfield(Data.Info,"EventRelatedDataChannel")
            if strcmp(Data.Info.EventChannelNames(i),Data.Info.EventRelatedDataChannel)
                %% Normal Event Related Data
                if size(Data.EventRelatedData,2) <= sum(EventsToDelete)
                    fieldsToDelete = {'EventRelatedData'};
                    % Delete fields
                    Data = rmfield(Data, fieldsToDelete);
                    fieldsToDelete = {'EventRelatedDataChannel','EventRelatedDataType','EventRelatedDataTimeRange'};
                    Data.Info = rmfield(Data.Info, fieldsToDelete);
                else
                    if strcmp(CutType,"CutStart")
                        Data.EventRelatedData(:,1:sum(EventsToDelete),:) = [];
                    elseif strcmp(CutType,"CutEnd")
                        Data.EventRelatedData(:,end-sum(EventsToDelete)+1:end,:) = [];
                    end
                end
            end
            %% Preprocessed Event Related Data
            if isfield(Data,'PreprocessedEventRelatedData')
                if size(Data.PreprocessedEventRelatedData,2) <= sum(EventsToDelete)
                    fieldsToDelete = {'PreprocessedEventRelatedData'};
                    % Delete fields
                    Data = rmfield(Data, fieldsToDelete);
                else
                    if strcmp(CutType,"CutStart")
                        Data.PreprocessedEventRelatedData(:,1:sum(EventsToDelete),:) = [];
                    elseif strcmp(CutType,"CutEnd")
                        Data.PreprocessedEventRelatedData(:,end-sum(EventsToDelete)+1:end,:) = [];
                    end
                end
            end
        end

        if ~isempty(Data.Events{i})
            if strcmp(CutType,"CutStart")
                %% Normalize Time
                Data.Events{i} = Data.Events{i}-index;
            end
        else
            Data.Events(i) = [];
            Data.Info.EventChannelNames(i) = [];
        end
    end % Lopp over all events
    if isempty(Data.Events)
        fieldsToDelete = {'Events'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        fieldsToDelete = {'EventChannelNames','EventChannelType'};
        % Delete fields
        Data.Info = rmfield(Data.Info, fieldsToDelete);
    end
end 
%% Cut Spikes
if isfield(Data,'Spikes')
    if strcmp(Data.Info.SpikeType,'Kilosort')
        fieldsToDelete = {'Spikes'};
        % Delete fields
        Data = rmfield(Data, fieldsToDelete);
        if isfield(Data.Info,'SpikeDetectionThreshold')
            fieldsToDelete = {'SpikeDetectionThreshold'};
            % Delete fields
            Data.Info = rmfield(Data.Info, fieldsToDelete);
        end
        Data.Info.SpikeType = "Non";
    else
        if strcmp(CutType,"CutStart")
            SpikeIndiciestoDelte = Data.Spikes.SpikeTimes < index;
        elseif strcmp(CutType,"CutEnd")
            SpikeIndiciestoDelte = Data.Spikes.SpikeTimes > index;
        end

        if sum(SpikeIndiciestoDelte)==length(Data.Spikes.SpikeTimes)
            fieldsToDelete = {'Spikes'};
            % Delete fields
            Data = rmfield(Data, fieldsToDelete);
            Data.Info.SpikeType = "Non";
            if isfield(Data.Info,'SpikeDetectionThreshold')
                fieldsToDelete = {'SpikeDetectionThreshold'};
                % Delete fields
                Data.Info = rmfield(Data.Info, fieldsToDelete);
            end
        else
            Data.Spikes.SpikeTimes(SpikeIndiciestoDelte==1) = [];
            Data.Spikes.SpikePositions(SpikeIndiciestoDelte==1,:) = [];
            Data.Spikes.SpikeAmps(SpikeIndiciestoDelte==1) = [];
            Data.Spikes.SpikeChannel(SpikeIndiciestoDelte==1) = [];
            % Scale Spike Times to new time frame
            if strcmp(CutType,"CutStart")
                Data.Spikes.SpikeTimes = Data.Spikes.SpikeTimes-index;
            end
        end
    end
end
