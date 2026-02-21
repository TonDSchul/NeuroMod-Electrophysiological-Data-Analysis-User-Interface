function [Filterorder] = Utility_Determine_FIR_FilterOrder(app,LowFrequency)

%________________________________________________________________________________________
%% Function to automatically determine an appropriate filter order for FIR filters 

% this is used every time the user sqitches a selected filter to FIR (or at standard in the phase sync window when not changed by the user)

% Input:
% 1. LowFrequency: double, lower frequency part (either cutoff for low/high pass or lower cutoff for narrowband)

% Outout:
% 1.Filterorder: string with determined filter order

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if contains(app.DataTypeDropDown.Value,'Preprocessed Data') && isfield(app.Mainapp.Data.Info,'DownsampleFactor')  
    if app.CoupleTimetoMainWindowCheckBox.Value == 1
        TimeDuration = str2double(app.Mainapp.TimeRangeViewBox.Value(1:end-1));
    else
        times = str2double(strsplit(app.TimeWindowfromtoinsEditField.Value,','));
        TimeDuration = times(2)-times(1);
    end
    StartIndex = app.Mainapp.CurrentTimePoints;
    StopIndex = StartIndex+round(TimeDuration*app.Mainapp.Data.Info.DownsampledSampleRate);
    if StopIndex > size(app.Mainapp.Data.Preprocessed,2)
        StopIndex = size(app.Mainapp.Data.Preprocessed,2);
    end
    SampleRate = app.Mainapp.Data.Info.DownsampledSampleRate;
else % If not downsampled
    if contains(app.DataTypeDropDown.Value,'Raw Data') || strcmp(app.DataTypeDropDown.Value,'Preprocessed Data')
        if app.CoupleTimetoMainWindowCheckBox.Value == 1
            TimeDuration = str2double(app.Mainapp.TimeRangeViewBox.Value(1:end-1));
        else
            times = str2double(strsplit(app.TimeWindowfromtoinsEditField.Value,','));
            TimeDuration = times(2)-times(1);
        end
        StartIndex = app.Mainapp.CurrentTimePoints;
        StopIndex = StartIndex+ceil(TimeDuration*app.Mainapp.Data.Info.NativeSamplingRate);
        if StopIndex > size(app.Mainapp.Data.Raw,2)
            StopIndex = size(app.Mainapp.Data.Raw,2);
        end
        SampleRate = app.Mainapp.Data.Info.NativeSamplingRate;
    else
        Filterorder = "200";
        return;
    end
end

if StopIndex-StartIndex<SampleRate
    DownsampleFactor = floor(app.Mainapp.Data.Info.NativeSamplingRate/1000);
    a = round((StopIndex-StartIndex)/DownsampleFactor);
    Filterorder = num2str(round(a/4));
else
    if SampleRate>=1000
        Filterorder = num2str(round( 3*(1000/LowFrequency)));
    else
        Filterorder = num2str(round( 3*(SampleRate/LowFrequency)));
    end
end
