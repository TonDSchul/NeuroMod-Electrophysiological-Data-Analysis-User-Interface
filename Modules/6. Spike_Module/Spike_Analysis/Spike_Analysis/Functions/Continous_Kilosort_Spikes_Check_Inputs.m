function [ChannelEditField,WaveformEditField,Error,SpikeRateBinsEditField] = Continous_Kilosort_Spikes_Check_Inputs(Data,ChannelEditField,WaveformEditField,SpikeAnalysisType,SpikeRateBinsEditField)

%________________________________________________________________________________________
%% Function to check, GUI inputs when Kilosort spikes analyzed. 
% This function chekcs the proper format of inputs. It takes the
% text editfields from the respective app window and checks the .Value char
% saved in it. If it obeys format, it is return as is. If not, it gets
% replaced by a standard value that also gets visible in the GUI. The
% function also checks whether there are too many channel, units and
% waveforms selected for a certain analysis which can not be plotted.

% This function gets called in the Continous_Spikes_Prepare_Plots function

% Inputs:
% 1. Data: main window data structure with time vector (Data.Time), raw data (for channel) and Info
% field
% 2. ChannelEditField: object holding app text with the field Value containing a char of the user input. Correct format: ChannelEditField.Value = '1,10' for channel 1 to 10. 
% 3. WaveformEditField: object holding app text with the field Value containing a char of the user input. Correct format: WaveformEditField.Value = '1,10' for waveforms 1 to 10. 
% 5. SpikeAnalysisType: Name as char of analysis done, Options: 'SpikeRateBinSizeChange' OR "Spike Map" OR "Waveforms from Raw Data" OR
% "Average Waveforms Across Channel" OR "Waveforms Templates" OR "Template from Max Amplitude Channel" OR "Cumulative Spike Amplitude Density
% Along Depth" OR "Spike Amplitude Density Along Depth" OR "Spike Triggered LFP"
% 6. SpikeRateBinsEditField: object holding app text with the field Value containing a char of the user input. Correct format: SpikeRateBinsEditField.Value = '100'

% Output:
% 1. ChannelEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 
% 3. WaveformEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 

% 5. Error: Indicates if an error happened consisting of too many channel,
% units and waveforms selcted which would result in a 3d matrix. Then the
% code stops and the user gets a message
% 6: SpikeRateBinsEditField: object holding app text with the field Value
% containing a char of corrected or unchanged input 

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

Error = 0;

%% Check Unit, waveform, channel and SpikeRat Input 

[ChannelEditField.Value] = Utility_SimpleCheckInputs(ChannelEditField.Value,"Two",strcat('1,',num2str(size(Data.Raw,1))),1,0);

[WaveformEditField.Value] = Utility_SimpleCheckInputs(WaveformEditField.Value,"Two",strcat('1,10'),0,0);

[SpikeRateBinsEditField.Value] = Utility_SimpleCheckInputs(SpikeRateBinsEditField.Value,"One",'300',0,0);


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
end

if strcmp(SpikeAnalysisType,"Waveforms Templates")

end

if strcmp(SpikeAnalysisType,"Waveform from Max Amplitude Channel")

end

if strcmp(SpikeAnalysisType,"Template from Max Amplitude Channel")

end
