function [texttoshow] = Analyse_Main_Window_Populate_Processing_Info(FlagActualDownsample,FlagActualLowPass,FlagActualBandpass,Samplefrequency,LowPassSettings)

%________________________________________________________________________________________

%% Function to write into textare of the phase sync window which preprocessing steps where applied automatically

% Inputs:
% 1. FlagActualDownsample: double, 1 or 0 , whether data was downsampled
% or not
% FlagActualLowPass: double, 1 or 0 , whether data was low pass filtered
% or not
% FlagActualBandpassdouble: double, 1 or 0 , whether data was narrowband filtered
% or not
% Samplefrequency: double, sample frequency after downsampling (or no downsampling)
% LowPassSettings: struc with fields: LowPassSettings.Cutoff, LowPassSettings.FilterOrder

% Outputs:
% 1. texttoshow: string to show in the text area object of the phase syn
% window

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

texttoshow = [];
if FlagActualDownsample
    texttoshow = strcat("Downsampling (",num2str(Samplefrequency),"Hz)");
end
if FlagActualLowPass
    if isempty(texttoshow)
        if ~FlagActualDownsample
            texttoshow = strcat("Just Low Pass Filter (Cutoff: ",num2str(LowPassSettings.Cutoff),"; Filter Order: ",num2str(LowPassSettings.FilterOrder),")");
        else
            texttoshow = "Downsampling already found. Just Low_Pass Filter";
        end
    else
        texttoshow = strcat(texttoshow," with Low_Pass Filter (Cutoff: ",num2str(LowPassSettings.Cutoff),"; Filter Order: ",num2str(LowPassSettings.FilterOrder),")");
    end
end
if FlagActualBandpass
    if isempty(texttoshow)
        texttoshow = "Just Bandpass Filtering Applied";
    else
        texttoshow = strcat(texttoshow," and Bandpass Filter Applied.");
    end
else
    if ~isempty(texttoshow)
        texttoshow = strcat(texttoshow," Applied");
    else
        texttoshow = "No Additional Processing Steps Applied";
    end
end