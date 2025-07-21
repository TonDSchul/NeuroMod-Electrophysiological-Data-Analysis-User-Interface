function [StartIndex,StopIndex,DatatoPlot,Time,Samplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,DataTypeDropDown,StartIndex,StopIndex)

% convert time points from donwsaampled state to raw data state 
if isfield(app.Data.Info,'DownsampleFactor') && strcmp(app.DropDown.Value,'Preprocessed Data') && strcmp(DataTypeDropDown,'Raw Data') 
    TimeinSecs = app.Data.TimeDownsampled(app.CurrentTimePoints);
    differences = abs(app.Data.Time - TimeinSecs);
    [~, TempCurrentTimePoints] = min(differences);

    TimeDuration = str2double(app.TimeRangeViewBox.Value(1:end-1));
    StartIndex = TempCurrentTimePoints;
    StopIndex = StartIndex+ceil(TimeDuration*app.Data.Info.NativeSamplingRate);
    if StopIndex > size(app.Data.Raw,2)
        StopIndex = size(app.Data.Raw,2);
    end
elseif isfield(app.Data.Info,'DownsampleFactor') && strcmp(app.DropDown.Value,'Raw Data') && strcmp(DataTypeDropDown,'Preprocessed Data') 
    TimeinSecs = app.Data.Time(app.CurrentTimePoints);
    differences = abs(app.Data.TimeDownsampled - TimeinSecs);
    [~, TempCurrentTimePoints] = min(differences);
    
    TimeDuration = str2double(app.TimeRangeViewBox.Value(1:end-1));
    StartIndex = TempCurrentTimePoints;
    StopIndex = StartIndex+round(TimeDuration*app.Data.Info.DownsampledSampleRate);
    if StopIndex > size(app.Data.Preprocessed,2)
        StopIndex = size(app.Data.Preprocessed,2);
    end
end

if strcmp(DataTypeDropDown,'Raw Data')   
    DatatoPlot = app.Data.Raw(:,StartIndex:StopIndex);
    Time = app.Data.Time(StartIndex:StopIndex);
    Samplefrequency = app.Data.Info.NativeSamplingRate;
elseif strcmp(DataTypeDropDown,'Preprocessed Data')
    if isfield(app.Data.Info,'DownsampleFactor')
        DatatoPlot = app.Data.Preprocessed(:,StartIndex:StopIndex);
        Time = app.Data.TimeDownsampled(StartIndex:StopIndex);
        Samplefrequency = app.Data.Info.DownsampledSampleRate;
    else
        DatatoPlot = app.Data.Preprocessed(:,StartIndex:StopIndex);
        Time = app.Data.Time(StartIndex:StopIndex);
        Samplefrequency = app.Data.Info.NativeSamplingRate;
    end
end