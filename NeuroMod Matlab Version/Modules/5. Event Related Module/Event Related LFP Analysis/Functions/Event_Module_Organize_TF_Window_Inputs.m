function [TF] = Event_Module_Organize_TF_Window_Inputs(Data,ChannelSelectionDropDown,AnalysisType,ActiveChannel,EventNumberSelectionEditField,FrequencyRangeminmaxstepsEditField,CycleWidthfromto23EditField,ChannelTrialsToCompare,TriggerToCompare,ChannelToCompare,NumScales)

%________________________________________________________________________________________
%% Function to capture all inputs for the time frequency power calculations and organize them to calculate and plot later

% Called when clicking on Time Frequency Power button in event related signal
% analysis window 

% Inputs: 
% 1.Data: structure with GUI data - not needed here but always useful for
% modifications
% 2. ChannelSelectionDropDown: char with channel to plot from TF window;
%i.e. '1,10' for channel 1 to 10. -- if multiple channel, power is
%calculated over the mean of all channel
% 3. AnalysisType:
% 4. ActiveChannel
% 3. EventNumberSelectionEditField: char with selection which events should
% be part of the calculations, i.e. '1,10' for events 1 to 10. This affects
% the ERP and therefore the phase locked and non phase locked components
% when plotted.
% FrequencyRangeminmaxstepsEditField: char, comma separated numbers with
% min,steps,max frequency in Hz
% CycleWidthfromto23EditField: NOT Used anymore
% TriggerToCompare: char, comma separated numbers with trials to compare in
% wavelet coherence analysis like [1,2]
% ChannelToCompare: char, comma separated numbers with channel to compare in
% wavelet coherence analysis like [1,2]
% NumScales: number of scales for wavelet coherence (same as VoicesPerOctave parameter)

% Outputs:
% 1. TF: struc with all parameters neccessary for plotting event related
% time frequency analysis, see below for fields

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

TF = [];

%% Extract Values to do calculations
EventNrRange = eval(EventNumberSelectionEditField);

if isempty(EventNrRange)
    EventNrRange = 1;
end

if ~isnumeric(ChannelSelectionDropDown)
    ChannelSelectionDropDown = str2double(ChannelSelectionDropDown);
end

[SingleChannelSelected] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ChannelSelectionDropDown,'MainWindow');

[MultiChannelSelected] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,ActiveChannel,'MainWindow');

%% Get Info of Wavelet Cycles from GUI
TF.SingleChannelSelected = SingleChannelSelected;
TF.MultiChannelSelected = MultiChannelSelected; 
TF.EventNrRange = EventNrRange; 

% Get Info of Frequency Range from GUI
indicesep = find(FrequencyRangeminmaxstepsEditField == ',');
TF.FreqRange(1,1) = str2double(FrequencyRangeminmaxstepsEditField(1:indicesep(1)-1));
TF.FreqRange(1,2) = str2double(FrequencyRangeminmaxstepsEditField(indicesep(1)+1:indicesep(2)-1));
TF.FreqRange(1,3) = str2double(FrequencyRangeminmaxstepsEditField(indicesep(end)+1:end));

if isscalar(linspace(TF.FreqRange(1),TF.FreqRange(3),TF.FreqRange(2)))
    TF.FreqRange(2) = 1;
    TF.FreqRange(3) = TF.FreqRange(1) + 1;
    msgbox(strcat("Need at least two different frequencies to compute! Autochanging to ",num2str(TF.FreqRange(1))," in steps of",num2str(TF.FreqRange(2))," to ",num2str(TF.FreqRange(3)),"Hz"));
end

TF.AnalysisType = AnalysisType;

TF.ChannelTriggerToCompareType = [TriggerToCompare,ChannelToCompare];%1 = trigger
TF.ChannelTriggerToCompare = str2double(strsplit(ChannelTrialsToCompare,','));

TF.NumScales = str2double(NumScales);