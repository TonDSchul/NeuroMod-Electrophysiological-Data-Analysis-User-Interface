function Analysis_Hilbert_Inspect_NarrowBand_Filterkernel (srate,costumfrex,orderfactor,costumfilter)
%________________________________________________________________________________________
%% Function to show the frequency response and filter gains of narrowband filter used for the hilbert filter.

%***********************
%% work in progress, not implemented yet!!!!!!!!!!!!
%***********************

% Inputs: 1.srate: Sampling rate of your signal in Hz as double
%         2.costumfrex: Frequency range of narrowband filter [min freq, max
%         frequ, steps from min to max freq] in Hz double
%         3.orderfactor: Order nr. for filter double
%         4.costumfilter: 1x2 double, Filter Width, Min and max in Hz [min freq, max freq]
%
% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.
%________________________________________________________________________________________

% filter parameters
nyquist = srate/2;
frange  = [costumfrex(1) costumfrex(2)];
transw  = .1;

order   = round( orderfactor*srate/frange(1) );
shape   = [ 0 0 1 1 0 0 ];
frex    = [ 0 frange(1)-frange(1)*transw frange frange(2)+frange(2)*transw nyquist ] / nyquist;

% filter kernel
filtkern = firls(order,frex,shape);
% compute the power spectrum of the filter kernel
filtpow = abs(fft(filtkern));
% compute the frequencies vector and remove negative frequencies
hz      = linspace(0,srate/2,floor(length(filtkern)/2)+1);
filtpow = filtpow(1:length(hz));

figure()
subplot(1,2,1)
hold on
plot(hz,filtpow,'ks-','linew',2,'markerfacecolor','w')

% Define the range of frequencies from 0 to 100 Hz
all_frequencies = hz;

% Define the range of interest (5 to 10 Hz)
start_freq = costumfrex(1,1);
end_freq = costumfrex(1,2);

% Create a logical vector indicating whether each frequency is within the range
within_range = (all_frequencies >= start_freq) & (all_frequencies <= end_freq);

% Convert logical vector to binary (1 or 0)
binary_vector = double(within_range);

%% Plot Freqeuncy Response
plot(hz,binary_vector,'ro-','linew',2,'markerfacecolor','w')
set(gca,'xlim',[0 60])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter (firls)')
axis square

%% Plot filter gains
nyquist = srate/2;

nFrex  = costumfrex(3);
frex   = linspace(costumfrex(1),costumfrex(2),nFrex);
fwidth = linspace(costumfilter(1),costumfilter(2),nFrex);

filtpow = zeros(nFrex,2000); %%% 2000 for zeropadding

for fi=1:nFrex

    %% create and characterize filter

    % create the filter
    frange = [frex(fi)-fwidth(fi) frex(fi)+fwidth(fi)];
    order  = round(orderfactor*srate/frange(1));
    fkern  = fir1(order,frange/nyquist);

    % compute the power spectrum of the filter kernel
    filtpow(fi,:) = abs(fft(fkern,2000)).^2; % 2000 = zeropadding so that frequ. resolution is the same fo filter kernel (that changes for each frequ) --> easier to plot

end

subplot(1,2,2)
imagesc([0 srate],frex([1 end]),filtpow)
set(gca,'ydir','normal','xlim',[0 frex(end)+10])
xlabel('Frequency (Hz)'), ylabel('filter center frequency (Hz)')
title('Filter Gains in')




