function [tf,frex] = Event_Module_Time_Frequency_Wavelet_ITPC_Cycles(Data,time,BaselineNorm,FreqRange,Range_cycles)

%________________________________________________________________________________________
%% Function to calculate time Frequency power and intertrial phase using complex moorlet wavelets with varying wavelet widths to 
% tackle the time/frequency tradeoff.

% This function is based on the "Complete neural
% signal processing and analysis: Zero to hero" workshop by Michael Cohen
% on udemy: https://www.udemy.com/course/solved-challenges-ants/?couponCode=LETSLEARNNOWPP

% Note: If multiple Channels in input data. mean is calculated. All selected trials are concatonated to a supertrial. Every calculation is done with this
% supertrial and converted back to the original data format afterwards

% Inputs: 1. Data: Format: 3D Matrix with Channel x Trials x Time Points as
%                  dimensions. (Mean over channel when multiple channels) 
%         3. time: Vector containing time points (in seconds)
%         4. FreqRange: Frequency range of narrwoband filter [min frequ, max frequ, steps from min to max freq] in Hz
%         5. FilterRange: Filter width of narrowband filter [min freq, max freq] in Hz
%         6. Range_cycles: Range of cycles widths of wavelets (from, to). Range determines the resolution of the time and frequency domain.
%         Higher filter order favors time resolution while frequency resolution suffers. To accomodate this tradeoff, the the higher
%         the frequency the higher the cylce width (higher end of input range) to increase temporal resolution for higher frequencies
%         9. BaselineNorm: Whether you want your signal to be baseline
%         normalized. 1 = yes, 2 = no. Time window is manually selected in
%         line 47. TODO: implement option in GUI

% Outputs: 1. tf: Result of the calculation with 4 dimensions. First indice of the first dimension is the result of the time frequency power 
%                 calculation, the second indidce the results of the ITPC. The other three dimensions are [Frequencies x time x power]
%          2. frex: Frequency range for which TF and ITPC was calculated (one dimensional vector) in Hz
%
% Output is plotted in the "Event_Module_Time_Frequency_Plot_WaveletTF" function.
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

%% Transform Data in Correct Format and Initiate Variables

if ~isa(Data, 'double')
    Data = double(Data);
end

h = waitbar(0, 'Calculating Time Frequency Power...', 'Name','Calculating Time Frequency Power...');

if size(Data,1)>1
    Data = mean(Data,1);
end

Data = squeeze(Data);

if size(Data,2) > 1
    Data = permute(Data, [2 1]);
end

% baseline time window
baseline_time = [ -0.05 0];

%% ERP
erp = mean(Data,2);

%% Non Phase Locked Signal (Signal-ERP)
nonphaselocked = Data - repmat(erp,1,size(Data,2)); %% Substract ERP from Signal to get non-ERP residual

%% Initializing
min_freqcycle =  FreqRange(1);
max_freqcycle =  FreqRange(3);
num_frexcycle =  FreqRange(2);

frex = linspace(min_freqcycle,max_freqcycle,num_frexcycle); 

% convert baseline time into indices
% convert baseline from ms to indices
baseidx = dsearchn(time',baseline_time');

dataXcycle = {};

% initialize output time-frequency data
%First 2 = Total and non phase locked; Second 2 = Power and ITPC
tf = zeros(2,length(frex),size(Data,1),2);

% notice: defining cycles as a vector for all frequencies
scycle = logspace(log10(Range_cycles(1)),log10(Range_cycles(end)),num_frexcycle) ./ (2*pi*frex);
wavtimecycle = time;
half_wavecycle = floor(length(wavtimecycle)/2);
  
% FFT parameters
nWavecycle = length(wavtimecycle);
nDatacycle = size(Data,1) * size(Data,2);
nConvcycle = nWavecycle + nDatacycle - 1;

%% now compute the FFT of all trials concatenated (Supertrial)

dataXcycle{1} = fft(reshape(Data,1,[]),nConvcycle); % total 
dataXcycle{2} = fft(reshape(nonphaselocked,1,[]),nConvcycle); % induced (non-phase locked)

fraction = 0.05;
msg = sprintf('Calculating Time Frequency Power... (%d%% done)', 0);
waitbar(fraction, h, msg);

%% now perform convolution

% loop over frequencies
for fi=1:length(frex)
    
    % create wavelet and get its FFT
    wavelet  = exp(2*1i*pi*frex(fi).*wavtimecycle) .* exp(-wavtimecycle.^2./(2*scycle(fi)^2));
    waveletX = fft(wavelet,nConvcycle);
    waveletX = waveletX ./ max(waveletX);
    
    % now run convolution in one step
    for i=1:2
        ascycle = ifft(waveletX .* dataXcycle{i});
    
        ascycle = ascycle(half_wavecycle+1:end-half_wavecycle);
        
        % and reshape back to time X trials
        ascycle = reshape( ascycle, size(Data,1), size(Data,2) );
        
        % compute power and average over trials
        if size(Data,2) > 1
            tf(i,fi,:,1) = mean( abs(ascycle).^2 ,2);
        elseif size(Data,2) == 1
            tf(i,fi,:,1) = abs(ascycle).^2;
        end

        baselinecycle = mean(tf(i,:,baseidx(1):baseidx(2),1) ,3);

        tf(i,fi,:,2) = abs(mean(exp(1i*angle(ascycle)),2));
    end

    msg = sprintf('Calculating Time Frequency Power... (%d%% done)', round((fi+1)/(numel(frex)+1)*100));
    waitbar((fi+1)/(numel(frex)+1), h, msg);

end

if BaselineNorm == 1 
    tf(1,:,:,1) = bsxfun(@rdivide, tf(1,:,:,1), baselinecycle);
    tf(2,:,:,1) = bsxfun(@rdivide, tf(2,:,:,1), baselinecycle);
end

if ~isempty(h)
    close(h);
end
    
