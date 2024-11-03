function [DataChannelRange,DataChannelSelected,EventNrRange,CSD,TF] = Event_Module_Organize_TF_Window_Inputs(Data,Type,ChannelSelectionDropDown,EventNumberSelectionEditField,FrequencyRangeminmaxstepsEditField,CycleWidthfromto23EditField,FilterWidthHzminmaxstepsEditField,FactorFilterOrderChangesforeachFrequEditField)

%________________________________________________________________________________________
%% Function to capture all inputs for the time frequency power calculations and organize them to calculate and plot later

% Called when clicking on Time Frequency Power button in event related signal
% analysis window 

% Inputs: 
% 1.Data: structure with GUI data - not needed here but always useful for
% modifications
% 2. Type: string, determines type of time frequency calculation; options: "Moorlet
% Wavelets" for complex moorlet wavelet convolution with varying cycle
% width OR "Filter Hilbert" For filter hilbert transform. NOTE: TODO: "Filter
% Hilbert" does not fully work yet!
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
CSD = [];
DataChannelRange = [];
%% Extract Values to do calculations

CommaIndex = find(EventNumberSelectionEditField==',');
EventNrRange(1) = str2double(EventNumberSelectionEditField(1:CommaIndex-1));
EventNrRange(2) = str2double(EventNumberSelectionEditField(CommaIndex+1:end));

DataChannelSelected = ChannelSelectionDropDown;

[DataChannelSelected] = Organize_Convert_ActiveChannel_to_DataChannel(Data.Info.ProbeInfo.ActiveChannel,DataChannelSelected,'MainWindow');
    
if strcmp(Type,"Moorlet Wavelets")
    %% Get Info of Wavelet Cycles from GUI
    indicesep = [];
    indicesep = find(CycleWidthfromto23EditField == ',');
    TF.Range_cycles(1,1) = str2double(CycleWidthfromto23EditField(1:indicesep(1)-1));
    TF.Range_cycles(1,2) = str2double(CycleWidthfromto23EditField(indicesep(1)+1:end)); 
    
    % Get Info of Frequency Range from GUI
    indicesep = find(FrequencyRangeminmaxstepsEditField == ',');
    TF.FreqRange(1,1) = str2double(FrequencyRangeminmaxstepsEditField(1:indicesep(1)-1));
    TF.FreqRange(1,2) = str2double(FrequencyRangeminmaxstepsEditField(indicesep(1)+1:indicesep(2)-1));
    TF.FreqRange(1,3) = str2double(FrequencyRangeminmaxstepsEditField(indicesep(2)+1:end));
elseif strcmp(Type,"Filter Hilbert")
    %% Get Info of Wavelet Cycles from GUI
    indicesep = find(CycleWidthfromto23EditField == ',');
    TF.Range_cycles(1,1) = str2double(CycleWidthfromto23EditField(1:indicesep(1)-1));
    TF.Range_cycles(1,2) = str2double(CycleWidthfromto23EditField(indicesep(1)+1:end)); 
    
    % Get Info of Frequency Range from GUI
    indicesep = find(FrequencyRangeminmaxstepsEditField == ',');
    TF.FreqRange(1,1) = str2double(FrequencyRangeminmaxstepsEditField(1:indicesep(1)-1));
    TF.FreqRange(1,2) = str2double(FrequencyRangeminmaxstepsEditField(indicesep(1)+1:indicesep(2)-1));
    TF.FreqRange(1,3) = str2double(FrequencyRangeminmaxstepsEditField(indicesep(2)+1:end));

    TF.FilterOrder = str2double(FactorFilterOrderChangesforeachFrequEditField);
    
    indicesep = find(FilterWidthHzminmaxstepsEditField == ',');
    TF.FilterRange(1,1) = str2double(FilterWidthHzminmaxstepsEditField(1:indicesep(1)-1));
    TF.FilterRange(1,2) = str2double(FilterWidthHzminmaxstepsEditField(indicesep(1)+1:end)); 

end

