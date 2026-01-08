function [Data,texttoshow] = Extract_Events_Module_Correct_For_TimeToExtract(Data,TimeAndChannelToExtract)

if contains(TimeAndChannelToExtract.TimeToExtract,',')
    if ~contains(TimeAndChannelToExtract.TimeToExtract,'Inf')
        Timetoextract = str2double(strsplit(TimeAndChannelToExtract.TimeToExtract,','));
    else
        TempTimetoextract = str2double(strsplit(TimeAndChannelToExtract.TimeToExtract,','));
        Timetoextract(1) = TempTimetoextract(1);
        Timetoextract(2) = Data.Time(end); 
    end
else
    Timetoextract = eval(TimeAndChannelToExtract.TimeToExtract);
end

% convert to samples
Timetoextract = round(Timetoextract*Data.Info.NativeSamplingRate);
if Timetoextract(1)==0
    Timetoextract(1) = 1;
end
texttoshow = [];
for i = 1:length(Data.Events)
    IndiciesToDelete = Data.Events{i}<Timetoextract(1);
    IndiciesToDelete = IndiciesToDelete + Data.Events{i}>Timetoextract(2);

    IndiciesToDelete(IndiciesToDelete>1) = 1;
    Data.Events{i}(IndiciesToDelete==1) = [];
    Data.Events{i} = Data.Events{i} - (Timetoextract(1) - 1);
    % delete smaller than 0
    deletedbcsmaller0 = Data.Events{i}<=0;
    Data.Events{i}(deletedbcsmaller0) = [];
    
    if sum(IndiciesToDelete)+sum(deletedbcsmaller0)>0
        if ~strcmp(Data.Info.RecordingType,"Open Ephys")
            disp(strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," events from event channel ",Data.Info.EventChannelNames{i}," due to time being extracted from the recording is smaller than the whole recording duration."));
            texttoshow = [texttoshow;strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," events from event channel ",Data.Info.EventChannelNames{i}," due to time being extracted from the recording is smaller than the whole recording duration.")];
        else
            disp(strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," events because time being extracted from the recording is smaller than the whole recording duration."));
            texttoshow = [texttoshow;strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," events because time being extracted from the recording is smaller than the whole recording duration.")];
        end
    end
end

if isempty(Data.Events)
    if isfield(Data.Info,'EventChannelNames')
        Data.Info = rmfield(Data.Info, 'EventChannelNames');
    end
    if isfield(Data.Info,'EventChannelType')
        Data.Info = rmfield(Data.Info, 'EventChannelType');
    end
    if isfield(Data.Info,'EventRelatedDataTimeRange')
        Data.Info = rmfield(Data.Info, 'EventRelatedDataTimeRange');
    end
    if isfield(Data.Info,'EventRelatedActiveChannel')
        Data.Info = rmfield(Data.Info, 'EventRelatedActiveChannel');
    end
    
    if isfield(Data,'Events')
        Data = rmfield(Data, 'Events');
    end
end
if isempty(texttoshow)
    texttoshow = "No event trigger violate time constraints.";
else
    texttoshow = [texttoshow;"All trigger had to be deleted due to time violations. No event data remaining."];
end