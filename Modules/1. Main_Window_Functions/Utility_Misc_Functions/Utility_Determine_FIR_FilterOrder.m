function [Filterorder] = Utility_Determine_FIR_FilterOrder(app,LowFrequency)

if strcmp(app.Mainapp.DropDown.Value,'Preprocessed Data') && isfield(app.Mainapp.Data.Info,'DownsampleFactor')  
    TimeDuration = str2double(app.Mainapp.TimeRangeViewBox.Value(1:end-1));
    StartIndex = app.Mainapp.CurrentTimePoints;
    StopIndex = StartIndex+round(TimeDuration*app.Mainapp.Data.Info.DownsampledSampleRate);
    if StopIndex > size(app.Mainapp.Data.Preprocessed,2)
        StopIndex = size(app.Mainapp.Data.Preprocessed,2);
    end
    SampleRate = app.Mainapp.Data.Info.DownsampledSampleRate;
else % If not downsampled
    if strcmp(app.Mainapp.DropDown.Value,'Raw Data') || strcmp(app.Mainapp.DropDown.Value,'Preprocessed Data')
        TimeDuration = str2double(app.Mainapp.TimeRangeViewBox.Value(1:end-1));
        StartIndex = app.Mainapp.CurrentTimePoints;
        StopIndex = StartIndex+ceil(TimeDuration*app.Mainapp.Data.Info.NativeSamplingRate);
        if StopIndex > size(app.Mainapp.Data.Raw,2)
            StopIndex = size(app.Mainapp.Data.Raw,2);
        end
        SampleRate = app.Mainapp.Data.Info.NativeSamplingRate;
    else
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





% if SampleRate >= 1000
% 
% else
%     if StopIndex-StartIndex<SampleRate
%         Filterorder = num2str(round( 4*StopIndex-StartIndex/LowFrequency ));
%     else
%         Filterorder = num2str(round( 4*SampleRate/LowFrequency ));
%     end
% end
