function [tf,frex] = Event_Module_Time_Frequency_Hilbert_TimeFrequ_ITPC (Data,srate,time,FreqRange,FilterRange,FilterOrder,TrialsofInterest,Channel,BaselineNormalize)

%________________________________________________________________________________________
%% Function to calculate time frequency power and intertrial phase clustering using a filter hilbert.

%***********************
%% work in progress, not implemented yet!!!!!!!!!!!!
%***********************

% This function is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Note: Only supported for one channel that is specified in the "Channel"
% input. If input data matrix contains only one channel, the "Channel"
% variable has to be 1. All selected trials/events are concatonated to a supertrial. Every calculation is done with this
% supertrial and converted back to the original data format afterwards

% Inputs: 1. Data: Contains data of the currently selected animal, sessions
%                  and condition. Format: 3D Matrix with Channel x Trials x Time Points as
%                  dimensions. 
%         2. srate: Sampling rate in Hz
%         3. time: Vector containing time points (in seconds)
%         4. FreqRange: Frequency range of narrwoband filter [min frequ, max frequ, steps from min to max freq] in Hz
%         5. FilterRange: Filter width of narrowband filter [min freq, max freq] in Hz
%         6. FilterOrder: Order nr. of narrwoband filter
%         7. TrialsofInterest: Trials of the data matrix for which the  calculations are done [from, to]
%         8. Channel: Channel of interest (onyl one!).
%         9. BaselineNormalize: Whether you want your signal to be baseline normalized. 1 = yes, 2 = no. Time window is manually selected in line 48.

% Outputs: 1. tf: Result of the calculation with 4 dimensions. First indice of the first dimension is the result of the time frequency power 
%                 calculation, the second indidce the results of the ITPC. The other three dimensions are [Frequencies x time x power]
%          2. frex: Frequency range for which TF and ITPC was calculated (one dimensional vector) in Hz
%
% Output is plotted in the "Plot_HilbertTimeFrequency" function.
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Transform data in required format (Channel x time x trials)

h = waitbar(0, 'Calculating Time Frequency Power...', 'Name','Calculating Time Frequency Power...');

if size(Data,1)>1
    data = mean(Data,1);
end

data = squeeze(data);

% if size(data,2) > 1
%     data = permute(data, [2 1]);
% end

NrSelectedTrials = size(data,1);
%% TF analysis

AllTrials = size(data,1);
nyquist = srate/2;

nFrex  = FreqRange(3);
frex   = linspace(FreqRange(1),FreqRange(2),nFrex);
fwidth = linspace(FilterRange(1),FilterRange(2),nFrex);

% baseline
bidx = dsearchn(time',[-0.05 0]');

% Concatonate all events/trials
longdata = double( reshape(data,1,[]) ); % double for filtfilt function

% initialize output matrices
tf = zeros(2,nFrex,length(time),2); % The first two corresponds to total and nonphase locked components, the second two corresponds to TF(1) and ITPC (2)
filtpow = zeros(nFrex,2000);

if length(TrialsofInterest)>1
    erp = mean(data,1)';
elseif isscalar(length(TrialsofInterest))
    erp = data;
end

% compute induced power by subtracting ERP from each trial
longnonphaselockeddata = double(data);
longnonphaselockeddata = longnonphaselockeddata - repmat(erp',size(longnonphaselockeddata,1),1); %% Substract ERP from Signal to get non-ERP residual
longnonphaselockeddata = reshape(longnonphaselockeddata,1,[]);
%tf(1,.....) = Total 
%tf(12,.....) = NonPhaselocked 

fraction = 0.05;
msg = sprintf('Calculating Time Frequency Power... (%d%% done)', 0);
waitbar(fraction, h, msg);

for fi=1:nFrex
    
    %% create and characterize filter
    
    % create the filter
    frange = [frex(fi)-fwidth(fi) frex(fi)+fwidth(fi)];
    order  = round( FilterOrder * srate/frange(1) );
    fkern  = fir1(order,frange/nyquist);
    
    % compute the power spectrum of the filter kernel
    filtpow(fi,:) = abs(fft(fkern,2000)).^2; % 2000 = zeropadding so that frequ. resolution is the same fo filter kernel (that changes for each frequ) --> easier to plot
    
    %% apply to data
        
    % apply to data
    filtdat = filtfilt(fkern,1,longdata);
    filtdatNonPhaselocked = filtfilt(fkern,1,longnonphaselockeddata);

    filtdat = reshape(filtdat,[],AllTrials);
    filtdatNonPhaselocked = reshape(filtdatNonPhaselocked,[],AllTrials);
    
    % filtdat = filtdat(:,TrialsofInterest(1,1):TrialsofInterest(1,2));
    % filtdatNonPhaselocked = filtdatNonPhaselocked(:,TrialsofInterest(1,1):TrialsofInterest(1,2));

    filtdat = reshape(filtdat,1,[]);
    filtdatNonPhaselocked = reshape(filtdatNonPhaselocked,1,[]);

    % hilbert transform
    hdat = hilbert(filtdat);
    hdatNonPhaselocked = hilbert(filtdatNonPhaselocked);

    ILPCfilteredData = reshape(hdat,[],NrSelectedTrials);
    ILPCfilteredDataNPL = reshape(hdatNonPhaselocked,[],NrSelectedTrials);

    % extract power
    powdat = abs( reshape(hdat,[],NrSelectedTrials) ).^2;
    powdatNPL = abs( reshape(hdatNonPhaselocked,[],NrSelectedTrials) ).^2;

    % Baseline norm.
    base = mean(mean(powdat(bidx(1):bidx(2),:),2),1);
    baseNPL = mean(mean(powdatNPL(bidx(1):bidx(2),:),2),1);

    % trial average and put into TF matrix
    if BaselineNormalize == 1
        tf(1,fi,:,1) = mean(powdat,2)/base ;
        tf(2,fi,:,1) = mean(powdatNPL,2)/baseNPL ;
    else
        tf(1,fi,:,1) = mean(powdat,2);
        tf(2,fi,:,1) = mean(powdatNPL,2);
    end
    
    % ITPC
    tf(1,fi,:,2) = abs(mean(exp(1i*angle(ILPCfilteredData)),2));
    tf(2,fi,:,2) = abs(mean(exp(1i*angle(ILPCfilteredDataNPL)),2));

    msg = sprintf('Calculating Time Frequency Power... (%d%% done)', round((fi+1)/(nFrex+1)*100));
    waitbar((fi+1)/(nFrex+1), h, msg);

end

if ~isempty(h)
    close(h);
end