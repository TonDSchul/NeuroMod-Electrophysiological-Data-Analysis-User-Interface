function DataToNormalize = Event_Module_Baseline_Normalize(Data,DataToNormalize,TimeWindow,EventTimeWindow,AnalysisType)

%________________________________________________________________________________________

%% Function to baseline normalize event related data
% takes channel by trials by time matrix with event related data before the
% actual analysis

% Inputs:
% 1. Data: Data structure with raw data and preprocessed data (if applicable); Raw and Preprocessed Data =
% nchannel x time points single matrix with data
% 2: DataToNormalize: channel x trials x time matrix with event related
% data to baseline normalize
% 3. TimeWindow: char with comma separated time range, baseline is calculated
% for i.e. (-0.2,0)
% 4. EventTimeWindow: all time points of event related potential in seconds (app.Data.Info.EventRelatedTime)
% 5. AnalysisType: char, type of event related analysis baseline is normalized
% for, either "ERP" OR "StaticSpec"

% Outputs:
% 1. CurrentPlotData: structure in which analysis results are saved in
% case user wants to export them. See below to see which fields and data

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


if ischar(TimeWindow)
    TimeWindow = str2double(strsplit(TimeWindow,','));
end

[~,MinTimeIndice] = min(abs(EventTimeWindow - TimeWindow(1)));
[~,MaxTimeIndice] = min(abs(EventTimeWindow - TimeWindow(2)));
IndicieRange = MinTimeIndice:MaxTimeIndice;

if strcmp(AnalysisType,"ERP") || strcmp(AnalysisType,"StaticSpec")
    [NrChannel,TrialNr,ntime] = size(DataToNormalize);
    
    for ntrials = 1:TrialNr
        for nchan = 1:NrChannel
            CurrentTrialData = squeeze(DataToNormalize(nchan,ntrials,:))';
            Baseline = mean(CurrentTrialData(IndicieRange));
            %DataToNormalize(nchan,ntrials,IndicieRange) = Baseline;
            DataToNormalize(nchan,ntrials,:) = DataToNormalize(nchan,ntrials,:) - Baseline;
        end
    end
else%%% For CSD and stuff normalize the result
                
    [Time,NrChannel] = size(DataToNormalize);
    
    for currentchannel = 1:NrChannel
        CurrentTrialData = squeeze(DataToNormalize(:,currentchannel))';
        Baseline = mean(CurrentTrialData(IndicieRange));
        %DataToNormalize(nchan,ntrials,IndicieRange) = Baseline;
        DataToNormalize(:,currentchannel) = DataToNormalize(:,currentchannel) - Baseline;
    end
end