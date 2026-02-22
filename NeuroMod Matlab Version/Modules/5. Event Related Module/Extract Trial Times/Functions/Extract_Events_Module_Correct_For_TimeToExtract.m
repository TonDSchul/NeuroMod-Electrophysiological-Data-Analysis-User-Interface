function [Data,texttoshow] = Extract_Events_Module_Correct_For_TimeToExtract(Data,TimeAndChannelToExtract)

%________________________________________________________________________________________

%% Function that takes event indices (time stamps in respect to whole recording) and changes them to fit into the time range the user choose to extract
% substracts number of samples recording extraction was started at, deletes
% samples <= 0 and > num_samples

% Input:
% 1. Data: Main window data strucure with all relevant dataset compontntes
% TimeAndChannelToExtract: struc with fields:  TimeToExtract (comma
% separated like 0,Inf) 

% Output
% 1. Data: Main window data strucure with changed Data.Events and
% Data.Info fields
% 2. texttoshow: string, info text about was was deleted

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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
            disp(strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," events from event channel ",Data.Info.EventChannelNames{i}," due event samples numubers being bigger than the extracted recording time."));
            texttoshow = [texttoshow;strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," events from event channel ",Data.Info.EventChannelNames{i}," due event samples numubers being bigger than the extracted recording time.")];
        else
            disp(strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," due event samples numubers being bigger than the extracted recording time."));
            texttoshow = [texttoshow;strcat("Deleted ",num2str(sum(IndiciesToDelete)+sum(deletedbcsmaller0))," due event samples numubers being bigger than the extracted recording time.")];
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
    texttoshow = [texttoshow;"This is due to recording time extracted is not the original recording time."];
end