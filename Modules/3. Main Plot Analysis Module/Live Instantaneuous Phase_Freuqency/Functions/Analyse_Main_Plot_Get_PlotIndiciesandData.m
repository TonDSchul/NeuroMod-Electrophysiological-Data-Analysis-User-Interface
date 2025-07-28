function [StartIndex,StopIndex,DatatoPlot,Time,Samplefrequency] = Analyse_Main_Plot_Get_PlotIndiciesandData(app,DataTypeDropDown,StartIndex,StopIndex)

%________________________________________________________________________________________

%% Function to get the data indices and actual data from the part shown in the main window data plot

% Inputs:
% 1. app: Main window app object
% 2. DataTypeDropDown: char, from live phase sync window not main window!! either 'Raw Data' or 'Preprocessed Data'
% depending on what the user selects
% 3. StartIndex: double, Data index (from Data.Raw or Data.Preprocessed) at which the
% data snippet starts -----> only used if first 'if statement block' below
% is not triggered. It checks if data is downsampled in different
% situations and makes adjsutments accordingly
% 4. StopIndex: double, Data index (from Data.Raw or Data.Preprocessed) at which the
% data snippet ends -----> only used if first 'if statement block' below
% is not triggered. It checks if data is downsampled in different
% situations and makes adjsutments accordingly

% Output:
% 1. StartIndex: double, Determined data index (from Data.Raw or Data.Preprocessed) at which the
% data snipeet starts
% 2. StopIndex: double, Determined data index (from Data.Raw or Data.Preprocessed) at which the
% data snipeet ends
% 3. DatatoPlot: channel x time matrix with currently viewed data snippet
% data
% 4. Time: time of current data snippet (in respect to whole recording)
% 5. Samplefrequency: double in Hz. In case data was downsampled
% autodetection here and correct sample rate later on.

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

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