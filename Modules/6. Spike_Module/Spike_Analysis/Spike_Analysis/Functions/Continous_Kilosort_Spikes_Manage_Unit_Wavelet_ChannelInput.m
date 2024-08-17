function [ChannelEditField,WaveformEditField,UnitsEditField,Error,SpikeRateBinsEditField] = Continous_Kilosort_Spikes_Manage_Unit_Wavelet_ChannelInput(Data,CurrentInput,ChannelEditField,WaveformEditField,UnitsEditField,SpikeAnalysisType,SpikeRateBinsEditField)

Error = 0;


%% Check Unitnumber and SpikeRat Input 

[UnitsEditField.Value] = Utility_SimpleCheckInputs(UnitsEditField.Value,"One",'1');

[SpikeRateBinsEditField.Value] = Utility_SimpleCheckInputs(SpikeRateBinsEditField.Value,"One",'300');

if strcmp(SpikeAnalysisType,"Average Waveforms Across Channel") 

end

if strcmp(SpikeAnalysisType,"Spike Amplitude Density Along Depth")
    %% Channel
    %% Handle Channel Input

    commaindicie = find(ChannelEditField.Value == ',');
    ChannelSelection(1) = str2double(ChannelEditField.Value(1:commaindicie(1)-1));
    ChannelSelection(2) = str2double(ChannelEditField.Value(commaindicie(1)+1:end));

    if ChannelSelection(1) == ChannelSelection(2)
        ChannelSelection(1) = 1;
        ChannelSelection(2) = size(Data.Raw,1);
        ChannelEditField.Value = strcat(num2str(ChannelSelection(1)),',',num2str(ChannelSelection(2)));
        msgbox('Amplitude density plot only possible for multiple channel!')
    end
end

if strcmp(SpikeAnalysisType,"Cumulative Spike Amplitude Density Along Depth")
    %% Channel
    %% Handle Channel Input

    commaindicie = find(ChannelEditField.Value == ',');
    ChannelSelection(1) = str2double(ChannelEditField.Value(1:commaindicie(1)-1));
    ChannelSelection(2) = str2double(ChannelEditField.Value(commaindicie(1)+1:end));

    if ChannelSelection(1) == ChannelSelection(2)
        ChannelSelection(1) = 1;
        ChannelSelection(2) = size(Data.Raw,1);
        ChannelEditField.Value = strcat(num2str(ChannelSelection(1)),',',num2str(ChannelSelection(2)));
        msgbox('Amplitude density plot only possible for multiple channel!')
    end
end

if strcmp(SpikeAnalysisType,"Waveforms from Raw Data")
    %% If User currently changed Waveform
   
    %% Handle Waveform Input
    commaindicie = find(WaveformEditField.Value == ',');
    Waveform(1) = str2double(WaveformEditField.Value(1:commaindicie(1)-1));
    Waveform(2) = str2double(WaveformEditField.Value(commaindicie(1)+1:end));
    WaveformRange = Waveform(1):Waveform(2); 
    %% Handle Channel Input
    commaindicie = find(ChannelEditField.Value == ',');
    ChannelSelection(1) = str2double(ChannelEditField.Value(1:commaindicie(1)-1));
    ChannelSelection(2) = str2double(ChannelEditField.Value(commaindicie(1)+1:end));
    ChannelformRange = ChannelSelection(1):ChannelSelection(2);

    %% Check if inputs will work
    if numel(ChannelformRange) > 1 && numel(WaveformRange) > 1 
        msgbox('Channelselection, Unitselection and Waveformselection have too many indicies. Two of those have to be set to a single value (i.e. 10,10)!')
        Error=1;
        return;
    end
end

if strcmp(SpikeAnalysisType,"Waveforms Templates")

end

if strcmp(SpikeAnalysisType,"Waveform from Max Amplitude Channel")

end

if strcmp(SpikeAnalysisType,"Template from Max Amplitude Channel")

end
