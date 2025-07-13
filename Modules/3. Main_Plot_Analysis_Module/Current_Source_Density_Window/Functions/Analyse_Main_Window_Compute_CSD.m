
function [csd,ds]=Analyse_Main_Window_Compute_CSD(dat,ds,hamwidth,Data,DataType)

%________________________________________________________________________________________

%% Function to calculate current source density (CSD) 
% gets called in 'Analyse_Main_Window_CSD' function

% Inputs:
% 1. dat: nchannel x ntimepoints single data matrix containing data
% 2: ds: Channel spacing of probe in um as double
% (Data.Info.ChannelSpacing) NOTE: gets converted in mm!
% 3: hamwidth: Width of Hamm Window to smooth data in time and depth as
% uneven double, recommended: 5
% 4. Data: main app data structure
% 5. DataType: char, either 'Preprocessed Data' or 'Raw Data'

% Output:
% 1. csd: nchannel x time x csd matrix containing the current source density
% derivatives in mV/mm^2 (Note: one channel is lost!)
% 2. ds: Channel spacing of probe in mm as double

% Author: Michael Lippert, Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________


%% Init

%hamwidth=5; %size of hamming window. Has two be odd (3,5,7...) 7 is standard
ds=ds/1000; % convert um to millimeter spacing of electrode contacts: Neuronexus: 50 um, Cambridge Neurotech H6B AND H7b 25um

%% Referencing
if isfield(Data.Info,'GrandAverage') && strcmp(DataType,'Preprocessed Data')
else
    ref=mean(dat,2); %mean
    dat=dat-repmat(ref,1,size(dat,2)); %subtract grand average
end
%% Add additional taps left and right of the signal by linear extrapolation

s2=size(dat,2); %get number of channels
dat=interp1(dat',(1-ceil(hamwidth/2)):s2+ceil(hamwidth/2),'linear','extrap')'; %linear extrapolation !!!uses only last difference!!!!

%% Hamming Smoothing

dat=filter(hamming(hamwidth)/sum(hamming(hamwidth)),1,dat')';
dat=dat(:,hamwidth:end); %delete tails

%% Calculate second derivative

csd=-diff(diff(dat,1,2),1,2); %CSD is negative 2nd derivative over space

%% Divide by square distance

csd=csd/ds'^2;

end