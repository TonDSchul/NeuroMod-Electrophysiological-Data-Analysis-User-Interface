function [texttoshow] = Analyse_Main_Window_Populate_Processing_Info(FlagActualDownsample,FlagActualLowPass,FlagActualBandpass,Samplefrequency)

texttoshow = [];
if FlagActualDownsample
    texttoshow = strcat("Downsampling (",num2str(Samplefrequency),"Hz)");
end
if FlagActualLowPass
    if isempty(texttoshow)
        if ~FlagActualDownsample
            texttoshow = "Just Low_Pass Filter";
        else
            texttoshow = "Downsampling already found. Just Low_Pass Filter";
        end
    else
        texttoshow = strcat(texttoshow," with Low_Pass Filter");
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