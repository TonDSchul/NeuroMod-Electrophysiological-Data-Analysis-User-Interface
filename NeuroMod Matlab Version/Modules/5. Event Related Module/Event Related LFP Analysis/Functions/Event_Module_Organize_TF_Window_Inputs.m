function [TF] = Event_Module_Organize_TF_Window_Inputs(Data,ChannelSelectionDropDown,AnalysisType,ActiveChannel,EventNumberSelectionEditField,FrequencyRangeminmaxstepsEditField,CycleWidthfromto23EditField,ChannelTrialsToCompare,TriggerToCompare,ChannelToCompare,NumScales)

%________________________________________________________________________________________
%% Function to capture all inputs for the time frequency power calculations and organize them to calculate and plot later

% Called when clicking on Time Frequency Power button in event related signal
% analysis window 

% Inputs: 
% 1.Data: structure with GUI data - not needed here but always useful for
% modifications
%3. ChannelSelectionDropDown: char with channel to plot from TF window;
%i.e. '1,10' for channel 1 to 10. -- if multiple channel, power is
%calculated over the mean of all channel
% 4. EventNumberSelectionEditField: char with selection which events should
% be part of the calculations, i.e. '1,10' for events 1 to 10. This affects
% the ERP and therefore the phase locked and non phase locked components
% when plotted.
% 5. FrequencyRangeminmaxstepsEditField: char with frequency range for
% which TF is calculated in Hz, i.e. '1,120,100' for 1Hz to 100Hz in 120 steps
% 6. CycleWidthfromto23EditField: char with cycle width for complex moorlet
% wavelet. i.e. '4,9' This addressed the time/frequency tradeoff. The higher the
% frequency, the higher the temporal resolution of the TF analysis. Range determines
% difference in temporal resolution between high and low frequencies, low
% numbers means low temporal resolution, high numbers high temporal
% resolution.
% 7. FilterWidthHzminmaxstepsEditField: char with frequency Range for hilbert filter
% transform narrowband filter. Since this TF analysis is not working yet, this has
% no influence yet., i.e. '10,20'
% 8. FactorFilterOrderChangesforeachFrequEditField: char with filter order
% for hilbert filter transform narrowband filter; i.e. '3';

% Outputs:
% 1. DataChannelRange: Nr of Channel as double
% 2. DataChannelSelected: 1 x 2 vector of selected channel, from to, i.i
% [1,10] for channel 1 to 10 
% 3. EventNrRange: Channel Range as double vector from event 1 to
% last event
% 4. CSD: structure holding parameters for CSD. Of course it is set to
% empty bc here ionly TF is computed. 
% 5. TF: structure holding parameters for TF analysis. With fields:
%TF.Range_cycles: 1x2 double [from,to]
%TF.FreqRange: 1x3 double [from,steps,to]
%TF.FilterRange: 1x2 double [from,to]
%TF.FilterOrder 1x1 double

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