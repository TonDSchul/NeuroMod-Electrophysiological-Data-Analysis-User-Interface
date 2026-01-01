function DataToNormalize = Event_Module_Baseline_Normalize(Data,DataToNormalize,TimeWindow,EventTimeWindow,AnalysisType)

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