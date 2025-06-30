function [type,dir,filterorder,wintype,df,Cutoff,DownsampleFactor] = Preprocess_Module_Set_Filter_Parameter(PPSteps,PreprocessingSteps,Info)

%________________________________________________________________________________________

%% Function to Set Parameters for Filter functions based on saved filter parameter in app.Info structure
% Filtering is done with fieldtrip functions. The inputs to those functions
% specifying for example the filtertype are not user friendly. Therefore,
% the names in the GUI are different from those fieldtrip needs and are
% therefore translated in this function to be compatible with fieldtrip.

% Input:
% 1. PPSteps: Current iteration of preprocessing steps conducted (double)
% 2. PreprocessingSteps: string array with names of preprocessing steps
% captured in the gui. The are computed in the order specified in the
% array. Options: % Preprocessing ethod to apply. Either "Filter" OR "Downsample" OR "Normalize" OR "GrandAverage" OR "ChannelDeletion" OR "CutStart" OR "CutEnd"
% 3. Info: Structure containing parameters for each preprocessing
% step. This is populated in the 'Preprocess_Module_Construct_Pipeline'
% function.

% Outputs
% For type,dir,filterorder,wintype look below in the code how the GUI
% inputs are translated into different chars
% df always stays emtpy
% Cutoff: double 1x1 or 1x2 array with cutoff frequencies. For Narrowband
% a lower and upper cutoff has to be specified. Then it is 1x2, otherwise
% 1x1
% DownsampleFactor: Just taken from Info structure. Only non-emtpy when
% downsampling is the current preprocessing step


% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

%% 
% If all the above except band stop: Set options for
% fieldtrip preprocessing options based on GUI
% parameter saved in app.Data.Info (set in
% Preprocess_Construct_Pipeline function)

DownsampleFactor = [];
type = [];
dir = [];
filterorder = [];
Cutoff = [];

if strcmp(PreprocessingSteps(PPSteps),"High-Pass") || strcmp(PreprocessingSteps(PPSteps),"Low-Pass")
    if strcmp(Info.FilterType,"Butterworth IR")  
        type = 'but';
    elseif strcmp(Info.FilterType,"FIR-1")
        type ='fir';
    elseif strcmp(Info.FilterType,"Firls")
        type ='firls';
    end
    if strcmp(Info.FilterDirection,"Forward")
        dir = 'onepass';
    elseif strcmp(Info.FilterDirection,"Reverse")
        dir ='onepass-reverse';
    elseif strcmp(Info.FilterDirection,"Zero-phase forward and reverse")
        dir ='twopass';
    elseif strcmp(Info.FilterDirection,"Zero-phase reverse and forward")
        dir ='twopass-reverse';
    end
elseif strcmp(PreprocessingSteps(PPSteps),"Narrowband")

    if strcmp(Info.NarrowbandFilterType,"Butterworth IR")  
        type = 'but';
    elseif strcmp(Info.NarrowbandFilterType,"FIR-1")
        type ='fir';
    elseif strcmp(Info.NarrowbandFilterType,"Firls")
        type ='firls';
    end
    if strcmp(Info.NarrowbandFilterDirection,"Forward")
        dir = 'onepass';
    elseif strcmp(Info.NarrowbandFilterDirection,"Reverse")
        dir ='onepass-reverse';
    elseif strcmp(Info.NarrowbandFilterDirection,"Zero-phase forward and reverse")
        dir ='twopass';
    elseif strcmp(Info.NarrowbandFilterDirection,"Zero-phase reverse and forward")
        dir ='twopass-reverse';
    end

% If Bandstop Filter. Treated differently bc
% variable names are different (i.e. BandStopFilterDirection instead of FilterDirection). This is since one of the
% filters above AND the band stop can BOTH be applied to
% the dataset
elseif strcmp(PreprocessingSteps(PPSteps),"Band-Stop")

    if strcmp(Info.BandStopFilterType,"Butterworth IR")  
        type = 'but';
    elseif strcmp(Info.BandStopFilterType,"FIR-1")
        type ='fir';
    elseif strcmp(Info.BandStopFilterType,"Firls")
        type ='firls';
    end
    if strcmp(Info.BandStopFilterDirection,"Forward")
        dir = 'onepass';
    elseif strcmp(Info.BandStopFilterDirection,"Reverse")
        dir ='onepass-reverse';
    elseif strcmp(Info.BandStopFilterDirection,"Zero-phase forward and reverse")
        dir ='twopass';
    elseif strcmp(Info.BandStopFilterDirection,"Zero-phase reverse and forward")
        dir ='twopass-reverse';
    end

end

df = [];

%% Set filter order. 
% Band-Stop and Median Filter treated differently bc
% variable names are different (i.e. BandStopFilterOrder instead of FilterOrder). This is since one of the
% filters above AND the band stop can BOTH be applied to
% the dataset
    
% If any filter except of bandpass and median filter

if strcmp(PreprocessingSteps(PPSteps),"High-Pass") || strcmp(PreprocessingSteps(PPSteps),"Low-Pass") 
    filterorder = str2double(Info.FilterOrder);
end
if strcmp(PreprocessingSteps(PPSteps),"Narrowband")
    filterorder = str2double(Info.NarrowbandFilterOrder);
end
% If band pass
if strcmp(PreprocessingSteps(PPSteps),"Band-Stop")
    filterorder = str2double(Info.BandStopFilterOrder);
end
if strcmp(PreprocessingSteps(PPSteps),"Median Filter")
    filterorder = str2double(Info.MedianFilterOrder);
end

wintype = 'hamming';

%% Set Cutoff Frequency
% If Narrwoband or bandstop: Cutoff frequency is a
% range defined by two values instead of just one like
% for high or low pass filter
if strcmp(PreprocessingSteps(PPSteps),"Narrowband") 
    value = Info.NarrowbandCutoff;
    indicesep = find(value == ',');
    Cutoff(1,1) = str2double(value(1:indicesep(1)-1));
    Cutoff(1,2) = str2double(value(indicesep+1:end));
elseif strcmp(PreprocessingSteps(PPSteps),"Band-Stop")
    value = Info.BandStopCutoff;
    indicesep = find(value == ',');
    Cutoff(1,1) = str2double(value(1:indicesep(1)-1));
    Cutoff(1,2) = str2double(value(indicesep+1:end));
elseif strcmp(PreprocessingSteps(PPSteps),"High-Pass") || strcmp(PreprocessingSteps(PPSteps),"Low-Pass") 
    % Only one value for high/lowpass
    Cutoff = str2double(Info.Cutoff);  % Passband edge frequency in Hz
end

if isfield(Info,'DownsampleFactor') && strcmp(PreprocessingSteps(PPSteps),"Downsampling") 
    DownsampleFactor = Info.DownsampleFactor;
end
